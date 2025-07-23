import 'package:finestra_app/core/info_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:finestra_app/core/app_colors.dart';

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

class _BalanceScreenState extends State<BalanceScreen> {
  int counterBtn = 0;
  double get totalGastos =>
      widget.gastos.fold(0, (sum, item) => sum + item.amount);
  double get totalIngresos =>
      widget.ingresos.fold(0, (sum, item) => sum + item.amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMainScreen,
      body: ListView(
        children: [
          const SizedBox(height: 20),
          sectionTitle("Total de Gastos", totalGastos),
          sectionList(widget.gastos, isGasto: true),
          sectionTitle("Total de Ingresos", totalIngresos),
          sectionList(widget.ingresos, isGasto: false),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.backgroundStartScreen,
        child: const Icon(Icons.add),
        onPressed: () {
          if (counterBtn == 0) {
            showDialog<String>(
              animationStyle: AnimationStyle(
                duration: Duration(milliseconds: 550),
              ),
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Instrucciones'),
                content: const Text(
                  'Asegurese de subir los datos a la nube antes de salir de la app',
                  style: TextStyle(fontSize: 18),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text(
                      'OK',
                      style: TextStyle(color: AppColors.textColor),
                    ),
                  ),
                ],
              ),
            );
            counterBtn = 1;
          }

          if (counterBtn == 1) {
            showAddOptions();
          }
        },
      ),
    );
  }

  void showAddOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.remove_circle_outline),
            title: const Text('Agregar Gasto'),
            onTap: () {
              Navigator.pop(context);
              showAddDialog(isGasto: true);
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Agregar Ingreso'),
            onTap: () {
              Navigator.pop(context);
              showAddDialog(isGasto: false);
            },
          ),
        ],
      ),
    );
  }

  void showAddDialog({required bool isGasto}) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    IconData selectedIcon = Icons.attach_money;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isGasto ? "Nuevo Gasto" : "Nuevo Ingreso"),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Título"),
                ),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: "Monto"),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                DropdownButton<IconData>(
                  value: selectedIcon,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                      value: Icons.shopping_cart,
                      child: Row(
                        children: [
                          Icon(Icons.shopping_cart),
                          SizedBox(width: 10),
                          Text("Carrito de Compras"),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: Icons.cake,
                      child: Row(
                        children: [
                          Icon(Icons.cake),
                          SizedBox(width: 10),
                          Text("Postre"),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: Icons.people,
                      child: Row(
                        children: [
                          Icon(Icons.people),
                          SizedBox(width: 10),
                          Text("Personas"),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: Icons.attach_money,
                      child: Row(
                        children: [
                          Icon(Icons.attach_money),
                          SizedBox(width: 10),
                          Text("Dinero"),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: Icons.home,
                      child: Row(
                        children: [
                          Icon(Icons.home),
                          SizedBox(width: 10),
                          Text("Casa"),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: Icons.apartment,
                      child: Row(
                        children: [
                          Icon(Icons.apartment),
                          SizedBox(width: 10),
                          Text("Renta"),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: Icons.restaurant,
                      child: Row(
                        children: [
                          Icon(Icons.restaurant),
                          SizedBox(width: 10),
                          Text("Comida"),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: Icons.celebration,
                      child: Row(
                        children: [
                          Icon(Icons.celebration),
                          SizedBox(width: 10),
                          Text("Fiesta"),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: Icons.favorite,
                      child: Row(
                        children: [
                          Icon(Icons.favorite),
                          SizedBox(width: 10),
                          Text("Amor"),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: Icons.local_bar,
                      child: Row(
                        children: [
                          Icon(Icons.local_bar),
                          SizedBox(width: 10),
                          Text("Bebidas"),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: Icons.inventory_2,
                      child: Row(
                        children: [
                          Icon(Icons.inventory_2),
                          SizedBox(width: 10),
                          Text("Insumos"),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: Icons.category,
                      child: Row(
                        children: [
                          Icon(Icons.category),
                          SizedBox(width: 10),
                          Text("General"),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (icon) {
                    if (icon != null) {
                      setState(() {
                        selectedIcon = icon;
                      });
                    }
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text;
              final amount = double.tryParse(amountController.text) ?? 0.0;
              if (title.isEmpty || amount <= 0) return;

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
            },
            child: const Text("Agregar"),
          ),
        ],
      ),
    );
  }

  Padding sectionTitle(String title, double total) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.secondaryColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Padding(padding: EdgeInsets.all(6)),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                color: AppColors.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              "\$${total.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 22,
                color: AppColors.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(padding: EdgeInsets.all(6)),
          ],
        ),
      ),
    );
  }

  Widget sectionList(List<MoneyItem> items, {required bool isGasto}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 14, left: 30, right: 30),
      child: items.isEmpty
          ? _buildEmptyState(isGasto)
          : Column(
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                  ), // Aquí está el margen visual
                  child: Slidable(
                    key: ValueKey(item.title),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          borderRadius: BorderRadius.circular(12),
                          onPressed: (_) {
                            setState(() {
                              if (isGasto) {
                                widget.gastos.remove(item);
                              } else {
                                widget.ingresos.remove(item);
                              }
                            });
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Eliminar',
                        ),
                      ],
                    ),
                    child: MoneyItem(
                      icon: item.icon,
                      title: item.title,
                      amount: item.amount,
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildEmptyState(bool isGasto) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isGasto ? Icons.money_off : Icons.account_balance_wallet_outlined,
              size: 40,
              color: Colors.grey.shade500,
            ),
            const SizedBox(height: 8),
            Text(
              isGasto
                  ? 'No hay gastos registrados'
                  : 'No hay ingresos registrados',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Toca el botón + para agregar',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}
