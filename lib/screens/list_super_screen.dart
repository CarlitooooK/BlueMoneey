import 'package:finestra_app/core/app_colors.dart';
import 'package:finestra_app/core/info_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // Asegúrate de importar tu widget personalizado

class ListSuperScreen extends StatefulWidget {
  final List<MoneyItem> gastos;
  const ListSuperScreen({super.key, required this.gastos});

  @override
  State<ListSuperScreen> createState() => _ListSuperScreenState();
}

class _ListSuperScreenState extends State<ListSuperScreen> {
  final TextEditingController myController = TextEditingController();
  final TextEditingController myController2 = TextEditingController();
  double currentValue = 1.0;
  int counterBtn = 0;

  List<MoneyItem> moneyItems = [];
  double? total = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMainScreen,
      body: ListView(
        children: [
          titleContainer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              children: [
                Container(
                  width: 150,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      "Total: $total",
                      style: TextStyle(
                        fontSize: 24,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                textFieldSuper(
                  Icon(Icons.add_shopping_cart_outlined),
                  "Añadir Producto",
                  TextInputType.text,
                  myController,
                ),

                const SizedBox(height: 20),
                textFieldSuper(
                  Icon(Icons.attach_money),
                  "Costo por unidad/kilo",
                  TextInputType.number,
                  myController2,
                ),
                const SizedBox(height: 20),
                Text(
                  "Cantidad: ${currentValue.toInt()}",
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Slider(
                    divisions: 20,
                    min: 0,
                    max: 20,
                    value: currentValue,
                    activeColor: AppColors.primaryColor,
                    onChanged: (double newValue) {
                      setState(() {
                        currentValue = newValue;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    String nombre = myController.text.trim();
                    String costoTexto = myController2.text.trim();
                    double? costo = double.tryParse(costoTexto);
                    if (nombre.isEmpty) {
                      counterBtn = 0;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Ingresa un producto",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      );
                      return;
                    }

                    if (costo == null) {
                      counterBtn = 0;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Ingresa un precio válido",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      );
                      return;
                    }
                    counterBtn++;
                    if (counterBtn == 1) {
                      alertShopping(
                        context,
                        Text("Instrucciones"),
                        Text(
                          "Asegurese de agregar su despensa al apartado gastos antes de salir de la vista",
                          style: TextStyle(fontSize: 18),
                        ),
                      );
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
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    foregroundColor: WidgetStatePropertyAll(Colors.black),
                  ),

                  child: Text(
                    "Agregar a la lista",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),

                SizedBox(height: 20),

                // Mostrar la lista de items
                ...moneyItems.asMap().entries.map((entry) {
                  int index = entry.key;
                  MoneyItem item = entry.value;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Slidable(
                      key: ValueKey(item.title + item.amount.toString()),
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            borderRadius: BorderRadius.circular(12),
                            onPressed: (_) {
                              setState(() {
                                moneyItems.removeAt(index);
                                total = total! - item.amount;
                              });
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Eliminar',
                          ),
                        ],
                      ),
                      child: item,
                    ),
                  );
                }),
                ElevatedButton(
                  onPressed: () {
                    if (moneyItems.isNotEmpty) {
                      widget.gastos.add(
                        MoneyItem(
                          icon: Icons.shopping_bag_outlined,
                          title: "Despensa",
                          amount: total!,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Despensa agregada a los gastos",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      );
                    } else {
                      alertShopping(
                        context,
                        Text("Alerta"),
                        Text(
                          "Agregar al menos un producto primero",
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    foregroundColor: WidgetStatePropertyAll(Colors.black),
                  ),
                  child: Text(
                    textAlign: TextAlign.center,
                    "Agregar a gastos",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> alertShopping(
    BuildContext context,
    Text title,
    Text content,
  ) {
    return showDialog<String>(
      animationStyle: AnimationStyle(duration: Duration(milliseconds: 550)),
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: title,
        content: content,
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
  }

  Container textFieldSuper(
    Icon icono,
    String hint,
    TextInputType type,
    TextEditingController controller,
  ) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(0, 3, 20, 0),
      margin: const EdgeInsets.only(left: 20, right: 20),
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        keyboardType: type,
        cursorColor: Colors.black,
        controller: controller,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: icono,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black),
        ),
        style: const TextStyle(color: Colors.black, fontSize: 18),
      ),
    );
  }

  Padding titleContainer() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 40.0,
        bottom: 10,
        left: 40,
        right: 40,
      ),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart,
              color: Color.fromARGB(255, 11, 182, 165),
              size: 40,
            ),
            SizedBox(width: 6),
            Text("Supermercado", style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
