import 'package:finestra_app/core/constants/info_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:finestra_app/core/constants/app_colors.dart';

class BalanceScreen extends StatefulWidget {
  final List<MoneyItem> gastos;
  final List<MoneyItem> ingresos;
  const BalanceScreen({
    super.key,
    required this.gastos,
    required this.ingresos,
  });

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> with TickerProviderStateMixin {
  int counterBtn = 0;

  AnimationController? _listController;
  AnimationController? _fabController;
  Animation<double>? _fadeAnimation;
  Animation<double>? _slideAnimation;
  Animation<double>? _fabAnimation;

  double get totalGastos => widget.gastos.fold(0, (sum, item) => sum + item.amount);
  double get totalIngresos => widget.ingresos.fold(0, (sum, item) => sum + item.amount);
  double get balance => totalIngresos - totalGastos;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _listController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fabController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _listController!,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<double>(
      begin: 0.3,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _listController!,
      curve: Curves.easeOutBack,
    ));

    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabController!,
      curve: Curves.elasticOut,
    ));

    _listController?.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _fabController?.forward();
    });
  }

  @override
  void dispose() {
    _listController?.dispose();
    _fabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMainScreen,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header con balance general
            SliverToBoxAdapter(
              child: _buildHeaderWithBalance(),
            ),

            // Lista de gastos
            SliverToBoxAdapter(
              child: _buildSection(
                title: "Gastos",
                total: totalGastos,
                items: widget.gastos,
                isGasto: true,
                color: Colors.red[600]!,
                icon: Icons.trending_down_rounded,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Lista de ingresos
            SliverToBoxAdapter(
              child: _buildSection(
                title: "Ingresos",
                total: totalIngresos,
                items: widget.ingresos,
                isGasto: false,
                color: Colors.green[600]!,
                icon: Icons.trending_up_rounded,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      floatingActionButton: _buildModernFAB(),
    );
  }

  Widget _buildHeaderWithBalance() {
    Color balanceColor = balance >= 0 ? Colors.green[600]! : Colors.red[600]!;
    IconData balanceIcon = balance >= 0 ? Icons.account_balance_wallet_rounded : Icons.warning_rounded;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.account_balance_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Balance General",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  balanceIcon,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  "\$${balance.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required double total,
    required List<MoneyItem> items,
    required bool isGasto,
    required Color color,
    required IconData icon,
  }) {
    return FadeTransition(
      opacity: _fadeAnimation ?? AlwaysStoppedAnimation(1.0),
      child: Transform.translate(
        offset: Offset(0, (_slideAnimation?.value ?? 0) * 50),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header de la sección
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.1),
                      color.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColor,
                            ),
                          ),
                          Text(
                            "${items.length} ${items.length == 1 ? 'movimiento' : 'movimientos'}",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        "\$${total.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Lista de items
              if (items.isEmpty)
                _buildEmptyState(isGasto)
              else
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: items.asMap().entries.map((entry) {
                      int index = entry.key;
                      MoneyItem item = entry.value;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Slidable(
                          key: ValueKey('${item.title}_$index'),
                          endActionPane: ActionPane(
                            motion: const BehindMotion(),
                            children: [
                              SlidableAction(
                                borderRadius: BorderRadius.circular(15),
                                onPressed: (_) {
                                  setState(() {
                                    if (isGasto) {
                                      widget.gastos.remove(item);
                                    } else {
                                      widget.ingresos.remove(item);
                                    }
                                  });
                                },
                                backgroundColor: Colors.red[600]!,
                                foregroundColor: Colors.white,
                                icon: Icons.delete_rounded,
                                label: 'Eliminar',
                              ),
                            ],
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundMainScreen.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: color.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    item.icon,
                                    color: color,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                ),
                                Text(
                                  "\$${item.amount.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isGasto) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundMainScreen.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            isGasto ? Icons.receipt_long_rounded : Icons.savings_rounded,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            isGasto ? 'No hay gastos registrados' : 'No hay ingresos registrados',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Presiona el botón + para agregar',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildModernFAB() {
    return ScaleTransition(
      scale: _fabAnimation ?? AlwaysStoppedAnimation(1.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.buttonColor.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          backgroundColor: AppColors.buttonColor,
          foregroundColor: Colors.white,
          onPressed: _handleFABPress,
          icon: const Icon(Icons.add_rounded, size: 24),
          label: const Text(
            "Agregar",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  void _handleFABPress() {
    if (counterBtn == 0) {
      _showInstructionsDialog();
      counterBtn = 1;
    } else {
      _showAddOptions();
    }
  }

  void _showInstructionsDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              Icons.info_rounded,
              color: AppColors.primaryColor,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text(
              'Instrucciones',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'Asegurese de subir los datos a la nube antes de salir de la app',
          style: TextStyle(fontSize: 16),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.buttonColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text(
              'Entendido',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "¿Qué deseas agregar?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOptionButton(
                  icon: Icons.remove_circle_rounded,
                  label: "Gasto",
                  color: Colors.red[600]!,
                  onTap: () {
                    Navigator.pop(context);
                    _showAddDialog(isGasto: true);
                  },
                ),
                _buildOptionButton(
                  icon: Icons.add_circle_rounded,
                  label: "Ingreso",
                  color: Colors.green[600]!,
                  onTap: () {
                    Navigator.pop(context);
                    _showAddDialog(isGasto: false);
                  },
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fixed icon options method - static list
  static const List<Map<String, dynamic>> _iconOptions = [
    {'icon': Icons.shopping_cart_rounded, 'label': 'Compras'},
    {'icon': Icons.restaurant_rounded, 'label': 'Comida'},
    {'icon': Icons.home_rounded, 'label': 'Casa'},
    {'icon': Icons.apartment_rounded, 'label': 'Renta'},
    {'icon': Icons.local_gas_station_rounded, 'label': 'Combustible'},
    {'icon': Icons.celebration_rounded, 'label': 'Entretenimiento'},
    {'icon': Icons.favorite_rounded, 'label': 'Personal'},
    {'icon': Icons.work_rounded, 'label': 'Trabajo'},
    {'icon': Icons.school_rounded, 'label': 'Educación'},
    {'icon': Icons.medical_services_rounded, 'label': 'Salud'},
    {'icon': Icons.attach_money_rounded, 'label': 'Dinero'},
    {'icon': Icons.category_rounded, 'label': 'General'},
  ];

  void _showAddDialog({required bool isGasto}) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    // Initialize with the first icon from the list
    IconData selectedIcon = _iconOptions.first['icon'] as IconData;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              isGasto ? Icons.remove_circle_rounded : Icons.add_circle_rounded,
              color: isGasto ? Colors.red[600] : Colors.green[600],
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              isGasto ? "Nuevo Gasto" : "Nuevo Ingreso",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDialogTextField(
                    controller: titleController,
                    label: "Título",
                    icon: Icons.title_rounded,
                  ),

                  const SizedBox(height: 16),

                  _buildDialogTextField(
                    controller: amountController,
                    label: "Monto",
                    icon: Icons.attach_money_rounded,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 20),

                  // Selector de iconos mejorado
                  Row(
                    children: [
                      Icon(
                        Icons.category_rounded,
                        color: AppColors.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Categoría:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundMainScreen.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: DropdownButton<IconData>(
                      value: selectedIcon,
                      isExpanded: true,
                      underline: const SizedBox(),
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 15,
                      ),
                      items: _iconOptions.map((option) {
                        return DropdownMenuItem<IconData>(
                          value: option['icon'] as IconData,
                          child: Row(
                            children: [
                              Icon(
                                option['icon'] as IconData,
                                color: AppColors.primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(option['label'] as String),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (icon) {
                        if (icon != null) {
                          setDialogState(() {
                            selectedIcon = icon;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancelar",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () => _addItem(titleController, amountController, selectedIcon, isGasto),
            style: ElevatedButton.styleFrom(
              backgroundColor: isGasto ? Colors.red[600] : Colors.green[600],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              "Agregar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(
        color: AppColors.textColor,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.textColor.withOpacity(0.7)),
        prefixIcon: Icon(icon, color: AppColors.primaryColor),
        filled: true,
        fillColor: AppColors.backgroundMainScreen.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primaryColor,
            width: 2,
          ),
        ),
      ),
    );
  }

  void _addItem(
      TextEditingController titleController,
      TextEditingController amountController,
      IconData selectedIcon,
      bool isGasto,
      ) {
    final title = titleController.text.trim();
    final amount = double.tryParse(amountController.text) ?? 0.0;

    if (title.isEmpty || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Por favor completa todos los campos correctamente"),
          backgroundColor: Colors.orange[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() {
      final item = MoneyItem(
        icon: selectedIcon,
        title: title,
        amount: amount,
      );
      if (isGasto) {
        widget.gastos.add(item);
      } else {
        widget.ingresos.add(item);
      }
    });

    Navigator.pop(context); 

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "${isGasto ? 'Gasto' : 'Ingreso'} agregado correctamente",
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: isGasto ? Colors.red[600] : Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}