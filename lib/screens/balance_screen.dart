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
        backgroundColor: AppColors.secondaryColor,
        child: const Icon(Icons.add),
        onPressed: () => showAddOptions(),
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
    IconData selectedIcon = Icons.money;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isGasto ? "Nuevo Gasto" : "Nuevo Ingreso"),
        content: Column(
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
                DropdownMenuItem(value: Icons.money, child: Text("Dinero")),
                DropdownMenuItem(value: Icons.icecream, child: Text("Helado")),
                DropdownMenuItem(
                  value: Icons.card_giftcard,
                  child: Text("Regalo"),
                ),
                DropdownMenuItem(value: Icons.people, child: Text("Gente")),
                DropdownMenuItem(
                  value: Icons.shopping_cart,
                  child: Text("Carrito"),
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
      child: Column(
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
}
