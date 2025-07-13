import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:finestra_app/core/app_colors.dart';
import 'package:finestra_app/core/info_item.dart';
import 'package:finestra_app/screens/balance_screen.dart';
import 'package:finestra_app/screens/general_screen.dart';
import 'package:finestra_app/screens/graphic_screen.dart';
import 'package:finestra_app/screens/list_super_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MoneyItem> gastos = [
    MoneyItem(icon: Icons.icecream, title: "Helado", amount: 20.00),
  ];

  List<MoneyItem> ingresos = [
    MoneyItem(icon: Icons.icecream, title: "Helado", amount: 20.00),
    MoneyItem(icon: Icons.people, title: "Salida Amigos", amount: 200.00),
    MoneyItem(
      icon: Icons.shopping_cart_rounded,
      title: "Despensa",
      amount: 800.00,
    ),
  ];

  double get totalGastos => gastos.fold(0, (sum, item) => sum + item.amount);
  double get totalIngresos =>
      ingresos.fold(0, (sum, item) => sum + item.amount);

  double get balance => totalIngresos - totalGastos;

  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
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
      GraphicScreen(gastos: gastos, ingresos: ingresos),
      const ListSuperScreen(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.logout),
        ),
        backgroundColor: AppColors.primaryColor,
        title: const Text("Blue Money"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              uploadData();
            },
            icon: const Icon(Icons.cloud_upload_rounded, size: 30),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet_outlined),
            label: "Balance",
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
