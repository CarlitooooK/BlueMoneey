import 'package:finestra_app/core/app_colors.dart';
import 'package:finestra_app/core/info_item.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphicScreen extends StatefulWidget {
  final List<MoneyItem> gastos;
  final List<MoneyItem> ingresos;

  const GraphicScreen({
    super.key,
    required this.gastos,
    required this.ingresos,
  });

  @override
  State<GraphicScreen> createState() => _GraphicScreenState();
}

class _GraphicScreenState extends State<GraphicScreen> {
  late List<GDPData> _gastosChartData;
  late List<GDPData> _ingresosChartData;
  late TooltipBehavior _tooltipBehavior;

  int? _explodedIndexChart1;
  int? _explodedIndexChart2;

  @override
  void initState() {
    super.initState();
    _gastosChartData = convertToChartData(widget.gastos);
    _ingresosChartData = convertToChartData(widget.ingresos);
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    final totalGastos = _gastosChartData.fold<double>(
      0,
      (sum, item) => sum + item.gdp,
    );
    final totalIngresos = _ingresosChartData.fold<double>(
      0,
      (sum, item) => sum + item.gdp,
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundMainScreen,
      body: ListView(
        children: [
          buildChartTitle(
            "Gráfica de Gastos",
            Icons.arrow_circle_down,
            Colors.red,
          ),
          _buildGastosChart(totalGastos),
          buildChartTitle(
            "Gráfica de Ingresos",
            Icons.arrow_circle_up,
            Colors.green,
          ),
          _buildIngresosChart(totalIngresos),
        ],
      ),
    );
  }

  Widget buildChartTitle(String title, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 40, right: 40),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 30),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGastosChart(double total) {
    if (_gastosChartData.isEmpty) {
      return Container(
        height: 300,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.insert_chart_outlined, size: 80, color: Colors.grey),
              SizedBox(height: 20),
              Text(
                "Sin gastos para mostrar",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "Agrega algunos gastos para ver la gráfica",
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return graphicGastos(total);
  }

  Widget _buildIngresosChart(double total) {
    if (_ingresosChartData.isEmpty) {
      return Container(
        height: 300,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.insert_chart_outlined, size: 80, color: Colors.grey),
              SizedBox(height: 20),
              Text(
                "Sin ingresos para mostrar",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "Agrega algunos ingresos para ver la gráfica",
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return graphicIngresos(total);
  }

  SfCircularChart graphicGastos(double total) {
    return SfCircularChart(
      legend: buildLegend(),
      tooltipBehavior: _tooltipBehavior,
      series: <CircularSeries>[
        DoughnutSeries<GDPData, String>(
          dataSource: _gastosChartData,
          xValueMapper: (GDPData data, _) => data.continent,
          yValueMapper: (GDPData data, _) => data.gdp,
          dataLabelMapper: (GDPData data, _) =>
              '${(data.gdp / total * 100).toStringAsFixed(1)}%',
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          pointColorMapper: (GDPData data, int index) =>
              customColors[index % customColors.length],
          explode: true,
          explodeOffset: '15%',
          explodeIndex: _explodedIndexChart1,
          enableTooltip: true,
          selectionBehavior: SelectionBehavior(
            enable: true,
            selectedColor: AppColors.primaryColor,
            unselectedOpacity: 1,
          ),
          onPointTap: (ChartPointDetails details) {
            setState(() {
              _explodedIndexChart1 = _explodedIndexChart1 == details.pointIndex
                  ? null
                  : details.pointIndex;
            });
          },
        ),
      ],
    );
  }

  SfCircularChart graphicIngresos(double total) {
    return SfCircularChart(
      legend: buildLegend(),
      tooltipBehavior: _tooltipBehavior,
      series: <CircularSeries>[
        DoughnutSeries<GDPData, String>(
          dataSource: _ingresosChartData,
          xValueMapper: (GDPData data, _) => data.continent,
          yValueMapper: (GDPData data, _) => data.gdp,
          dataLabelMapper: (GDPData data, _) =>
              '${(data.gdp / total * 100).toStringAsFixed(1)}%',
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          pointColorMapper: (GDPData data, int index) =>
              customColors[index % customColors.length],
          explode: true,
          explodeOffset: '15%',
          explodeIndex: _explodedIndexChart2,
          enableTooltip: true,
          selectionBehavior: SelectionBehavior(
            enable: true,
            selectedColor: Colors.blueGrey,
            unselectedOpacity: 1,
          ),
          onPointTap: (ChartPointDetails details) {
            setState(() {
              _explodedIndexChart2 = _explodedIndexChart2 == details.pointIndex
                  ? null
                  : details.pointIndex;
            });
          },
        ),
      ],
    );
  }

  Legend buildLegend() {
    return const Legend(
      isVisible: true,
      position: LegendPosition.left,
      overflowMode: LegendItemOverflowMode.wrap,
      textStyle: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  List<GDPData> convertToChartData(List<MoneyItem> items) {
    return items.map((item) => GDPData(item.title, item.amount)).toList();
  }

  final List<Color> customColors = [
    Colors.teal,
    Colors.amber,
    Colors.purple,
    Colors.lime,
    AppColors.buttonColor,
    Colors.deepOrange,
    Colors.indigo,
    Colors.pink,
    Colors.cyan,
    Colors.orange,
    Colors.brown,
    Colors.grey,
  ];
}

class GDPData {
  final String continent;
  final double gdp;

  GDPData(this.continent, this.gdp);
}
