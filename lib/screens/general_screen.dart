import 'package:finestra_app/core/app_colors.dart';
import 'package:finestra_app/core/info_item.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GeneralScreen extends StatefulWidget {
  final List<MoneyItem> gastos;
  final List<MoneyItem> ingresos;
  final double ingresosTotal;
  final double gastosTotal;
  final double balance;

  const GeneralScreen({
    super.key,
    required this.gastos,
    required this.ingresos,
    required this.gastosTotal,
    required this.ingresosTotal,
    required this.balance,
  });

  @override
  State<GeneralScreen> createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMainScreen,
      body: ListView(
        padding: const EdgeInsets.all(40.0),
        children: [
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.monetization_on, color: Colors.green, size: 40),
                SizedBox(width: 6),
                Text("Movimientos", style: TextStyle(fontSize: 24)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Text(
            "Balance \$${widget.balance.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          // TOTAL DE INGRESOS
          Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.backgroundTotals,
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Total de Ingresos:",
                      style: TextStyle(
                        fontSize: 22,
                        color: AppColors.buttonColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "\$${widget.ingresosTotal.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 22,
                        color: AppColors.buttonColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: double.infinity,
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white70,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          widget.ingresos.isEmpty
                              ? "Sin Ingresos"
                              : "Último Ingreso",
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: widget.ingresos.isEmpty
                                ? const Center(
                                    child: Text(
                                      "No hay ingresos registrados",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : widget.ingresos.last,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // TOTAL DE GASTOS
          Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.backgroundTotals,
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Total de Gastos:",
                      style: TextStyle(
                        fontSize: 22,
                        color: AppColors.buttonColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "\$${widget.gastosTotal.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 22,
                        color: AppColors.buttonColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: double.infinity,
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white70,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          widget.gastos.isEmpty ? "Sin Gastos" : "Último Gasto",
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: widget.gastos.isEmpty
                                ? const Center(
                                    child: Text(
                                      "No hay gastos registrados",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : widget.gastos.last,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // GRÁFICA GENERAL
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  "Gráfica General",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildChart(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    // Si no hay datos en ninguna de las dos listas
    if (widget.ingresos.isEmpty && widget.gastos.isEmpty) {
      return Container(
        height: 200,
        child: const Center(
          child: Text(
            "No hay datos para mostrar en la gráfica",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Crear lista de datos solo con los valores que existen
    List<ChartData> chartData = [];

    if (widget.ingresosTotal > 0) {
      chartData.add(ChartData("Ingresos", widget.ingresosTotal));
    }

    if (widget.gastosTotal > 0) {
      chartData.add(ChartData("Gastos", widget.gastosTotal));
    }

    return SfCircularChart(
      legend: const Legend(
        borderColor: Colors.black,
        textStyle: TextStyle(fontSize: 14),
        isVisible: true,
        position: LegendPosition.bottom,
      ),
      series: <CircularSeries>[
        DoughnutSeries<ChartData, String>(
          pointColorMapper: (ChartData data, int index) =>
              customColors[index % customColors.length],
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.tipo,
          yValueMapper: (ChartData data, _) => data.valor,
          dataLabelMapper: (ChartData data, _) =>
              "${data.tipo}: \$${data.valor.toStringAsFixed(2)}",
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          explode: true,
          explodeIndex: chartData.length > 1 ? 1 : 0,
        ),
      ],
    );
  }

  final List<Color> customColors = [
    AppColors.primaryColor,
    AppColors.buttonColor,
  ];
}

class ChartData {
  final String tipo;
  final double valor;

  ChartData(this.tipo, this.valor);
}
