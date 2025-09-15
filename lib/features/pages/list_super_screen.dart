import 'package:finestra_app/core/constants/app_colors.dart';
import 'package:finestra_app/core/constants/info_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListSuperScreen extends StatefulWidget {
  final List<MoneyItem> gastos;
  const ListSuperScreen({super.key, required this.gastos});

  @override
  State<ListSuperScreen> createState() => _ListSuperScreenState();
}

class _ListSuperScreenState extends State<ListSuperScreen> with TickerProviderStateMixin {
  final TextEditingController myController = TextEditingController();
  final TextEditingController myController2 = TextEditingController();
  double currentValue = 1.0;
  int counterBtn = 0;

  List<MoneyItem> moneyItems = [];
  double? total = 0.0;

  AnimationController? _listController;
  AnimationController? _totalController;
  Animation<double>? _listAnimation;
  Animation<double>? _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _listController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _totalController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _listAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _listController!,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _totalController!,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _listController?.dispose();
    _totalController?.dispose();
    super.dispose();
  }

  void _animateTotal() {
    _totalController!.forward().then((_) {
      _totalController!.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMainScreen,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 20),

            // Header mejorado
            _buildModernHeader(),

            const SizedBox(height: 30),

            // Total con animación
            _buildTotalContainer(),

            const SizedBox(height: 30),

            // Formulario mejorado
            _buildFormSection(),

            const SizedBox(height: 30),

            // Lista de items mejorada
            _buildItemsList(),

            const SizedBox(height: 20),

            // Botón final mejorado
            _buildFinalButton(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.white.withOpacity(0.95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.buttonColor,
                  AppColors.buttonColor.withAlpha(190),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: AppColors.buttonColor,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.shopping_cart_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            "Supermercado",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalContainer() {
    return ScaleTransition(
      scale: _scaleAnimation ?? AlwaysStoppedAnimation(1.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.buttonColor,
              AppColors.buttonColor.withAlpha(190),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.buttonColor,
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              "Total: \$${total!.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Agregar Producto",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          _buildModernTextField(
            const Icon(Icons.add_shopping_cart_outlined, color: AppColors.buttonColor,),
            "Nombre del producto",
            TextInputType.text,
            myController,
          ),

          const SizedBox(height: 16),

          _buildModernTextField(
            const Icon(Icons.attach_money_rounded, color: AppColors.buttonColor,),
            "Costo por unidad/kilo",
            TextInputType.number,
            myController2,
          ),

          const SizedBox(height: 20),

          // Slider mejorado
          Row(
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                color: AppColors.buttonColor,
              ),
              const SizedBox(width: 12),
              Text(
                "Cantidad: ${currentValue.toInt()}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppColors.buttonColor,
                inactiveTrackColor: Colors.grey.withOpacity(0.3),
                thumbColor: AppColors.buttonColor,
                overlayColor:AppColors.buttonColor,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
              ),
              child: Slider(
                divisions: 20,
                min: 1,
                max: 20,
                value: currentValue,
                onChanged: (double newValue) {
                  setState(() {
                    currentValue = newValue;
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Botón agregar mejorado
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              onPressed: _addItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColor,
                foregroundColor: Colors.white,
                elevation: 5,
                shadowColor: AppColors.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              icon: const Icon(Icons.add_rounded, size: 22),
              label: const Text(
                "Agregar a la lista",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTextField(
      Icon icon,
      String hint,
      TextInputType type,
      TextEditingController controller,
      ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        keyboardType: type,
        controller: controller,
        textInputAction: TextInputAction.done,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.withOpacity(0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color:AppColors.buttonColor,
              width: 2,
            ),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: icon,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildItemsList() {
    if (moneyItems.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 60,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              "Tu carrito está vacío",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Agrega productos para comenzar",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.list_alt_rounded,
              color: AppColors.buttonColor,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              "Productos (${moneyItems.length})",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        ...moneyItems.asMap().entries.map((entry) {
          int index = entry.key;
          MoneyItem item = entry.value;

          return FadeTransition(
            opacity: _listAnimation ?? AlwaysStoppedAnimation(1.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Slidable(
                key: ValueKey(item.title + item.amount.toString()),
                endActionPane: ActionPane(
                  motion: const BehindMotion(),
                  children: [
                    SlidableAction(
                      borderRadius: BorderRadius.circular(15),
                      onPressed: (_) {
                        setState(() {
                          moneyItems.removeAt(index);
                          total = total! - item.amount;
                        });
                        _animateTotal();
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete_rounded,
                      label: 'Eliminar',
                    ),
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          item.icon,
                          color: AppColors.buttonColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "\$${item.amount.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.buttonColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.drag_handle_rounded,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildFinalButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: _addToExpenses,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.buttonColor,
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              color: AppColors.buttonColor,
              width: 2,
            ),
          ),
        ),
        icon: const Icon(Icons.add_to_photos_rounded, size: 24),
        label: const Text(
          "Agregar a gastos",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _addItem() {
    String nombre = myController.text.trim();
    String costoTexto = myController2.text.trim();
    double? costo = double.tryParse(costoTexto);

    if (nombre.isEmpty) {
      _showSnackBar("Ingresa un producto");
      return;
    }

    if (costo == null) {
      _showSnackBar("Ingresa un precio válido");
      return;
    }

    counterBtn++;
    if (counterBtn == 1) {
      _showInstructionsAlert();
    }

    setState(() {
      moneyItems.add(
        MoneyItem(
          icon: Icons.shopping_bag_outlined,
          title: "$nombre x${currentValue.toInt()}",
          amount: costo * currentValue,
        ),
      );
      total = (total! + (costo * currentValue));
      myController.clear();
      myController2.clear();
      currentValue = 1;
    });

    _listController?.forward();
    _animateTotal();
  }

  void _addToExpenses() {
    if (moneyItems.isNotEmpty) {
      widget.gastos.add(
        MoneyItem(
          icon: Icons.shopping_bag_outlined,
          title: "Despensa",
          amount: total!,
        ),
      );
      _showSnackBar("Despensa agregada a los gastos");
    } else {
      _showAlert(
        "Alerta",
        "Agregar al menos un producto primero",
      );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        backgroundColor: AppColors.buttonColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showInstructionsAlert() {
    _showAlert(
      "Instrucciones",
      "Asegurese de agregar su despensa al apartado gastos antes de salir de la vista",
    );
  }

  Future<String?> _showAlert(String title, String content) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.buttonColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}