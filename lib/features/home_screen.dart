import 'dart:io';
import 'package:finestra_app/features/pages/cards_screen.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:finestra_app/core/constants/app_colors.dart';
import 'package:finestra_app/core/constants/info_item.dart';
import 'package:finestra_app/features/pages/balance_screen.dart';
import 'package:finestra_app/features/pages/general_screen.dart';

import 'pages/graphic_screen.dart';
import 'pages/list_super_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MoneyItem> gastos = [];

  List<MoneyItem> ingresos = [];

  double get totalGastos => gastos.fold(0, (sum, item) => sum + item.amount);

  double get totalIngresos =>
      ingresos.fold(0, (sum, item) => sum + item.amount);

  double get balance => totalIngresos - totalGastos;

  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void navigateBottomBar(int index) {
    // Animar hacia la página seleccionada
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    // Actualizar el índice cuando se desliza
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    _pageController.dispose(); // Limpiar el controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      GeneralScreen(
        gastos: gastos,
        ingresos: ingresos,
        ingresosTotal: totalIngresos,
        gastosTotal: totalGastos,
        balance: balance,
      ),
      BalanceScreen(gastos: gastos, ingresos: ingresos),
      CardsScreen(),
      GraphicScreen(gastos: gastos, ingresos: ingresos),
      ListSuperScreen(gastos: gastos),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: Image.asset("assets/gifs/bluey2.gif"),
        leadingWidth: 100,
        backgroundColor: AppColors.primaryColor,
        title: const Text("Blue Money"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              uploadData();
            },
            icon: const Icon(Icons.cloud_upload_rounded, size: 30),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(), // Efecto de rebote al deslizar
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.balance),
            label: "Balance",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: "Tarjetas",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_graph),
            label: "Gráficas",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Lista Súper",
          ),
        ],
        selectedItemColor: AppColors.buttonColor,
        backgroundColor: AppColors.backgroundStartScreen,
        selectedFontSize: 18,
        iconSize: 28,
        showUnselectedLabels: false,
      ),
    );
  }

  // === LOCAL STORAGE ===

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  String _serializeList(List<MoneyItem> list) {
    return list
        .map(
          (item) =>
              '${item.icon.codePoint}|${item.title}|${item.amount.toStringAsFixed(2)}',
        )
        .join('\n');
  }

  List<MoneyItem> _deserializeList(String content) {
    return content.split('\n').where((line) => line.isNotEmpty).map((line) {
      final parts = line.split('|');
      return MoneyItem(
        icon: IconData(int.parse(parts[0]), fontFamily: 'MaterialIcons'),
        title: parts[1],
        amount: double.parse(parts[2]),
      );
    }).toList();
  }

  Future<void> saveData() async {
    final file = await _localFile;
    final ingresosData = _serializeList(ingresos);
    final gastosData = _serializeList(gastos);
    final content = 'INGRESOS\n$ingresosData\nGASTOS\n$gastosData';
    await file.writeAsString(content);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Datos guardados localmente 📦")),
      );
    }
  }

  Future<void> loadData() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final content = await file.readAsString();
        final parts = content.split('GASTOS\n');
        final ingresosData = parts[0].replaceFirst('INGRESOS\n', '');
        final gastosData = parts[1];

        setState(() {
          ingresos = _deserializeList(ingresosData);
          gastos = _deserializeList(gastosData);
        });
      }
    } catch (e) {
      debugPrint("No se encontraron datos o el archivo falló: $e");
    }
  }

  void uploadData() async {
    await saveData();
  }
}
