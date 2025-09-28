import 'package:finestra_app/core/constants/app_colors.dart';
import 'package:finestra_app/core/constants/info_item.dart';
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

class _GraphicScreenState extends State<GraphicScreen>
    with TickerProviderStateMixin {
  late List<GDPData> _gastosChartData;
  late List<GDPData> _ingresosChartData;
  late TooltipBehavior _tooltipBehavior;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  int? _explodedIndexChart1;
  int? _explodedIndexChart2;

  @override
  void initState() {
    super.initState();
    _gastosChartData = convertToChartData(widget.gastos);
    _ingresosChartData = convertToChartData(widget.ingresos);
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      borderWidth: 2,
      borderColor: AppColors.primaryColor.withOpacity(0.5),
      color: Colors.white,
      textStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
    final balance = totalIngresos - totalGastos;

    return Scaffold(
      backgroundColor: AppColors.backgroundMainScreen,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            // Header con estadísticas resumidas
            SliverToBoxAdapter(
              child: _buildStatsHeader(totalIngresos, totalGastos, balance),
            ),

            // Gráfica de Gastos
            SliverToBoxAdapter(
              child: _buildSection(
                title: "Distribución de Gastos",
                icon: Icons.trending_down_rounded,
                iconColor: const Color(0xFFE53E3E),
                child: _buildGastosChart(totalGastos),
              ),
            ),

            // Gráfica de Ingresos
            SliverToBoxAdapter(
              child: _buildSection(
                title: "Distribución de Ingresos",
                icon: Icons.trending_up_rounded,
                iconColor: const Color(0xFF38A169),
                child: _buildIngresosChart(totalIngresos),
              ),
            ),

            // Análisis comparativo
            SliverToBoxAdapter(
              child: _buildComparativeAnalysis(totalIngresos, totalGastos),
            ),

            // Espacio final
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsHeader(
    double totalIngresos,
    double totalGastos,
    double balance,
  ) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.analytics_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Resumen Financiero',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Ingresos',
                  '\$${totalIngresos.toStringAsFixed(2)}',
                  Icons.arrow_upward_rounded,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Gastos',
                  '\$${totalGastos.toStringAsFixed(2)}',
                  Icons.arrow_downward_rounded,
                  Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Balance',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${balance.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: balance >= 0 ? Colors.white : Colors.red[200],
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
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
                    color: iconColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(20), child: child),
        ],
      ),
    );
  }

  Widget _buildGastosChart(double total) {
    if (_gastosChartData.isEmpty) {
      return _buildEmptyState(
        "Sin gastos registrados",
        "Agrega algunos gastos para visualizar la distribución",
        Icons.shopping_cart_outlined,
        Colors.red.withOpacity(0.3),
      );
    }

    return Column(
      children: [
        SizedBox(height: 300, child: graphicGastos(total)),
        const SizedBox(height: 16),
        _buildChartLegend(_gastosChartData, total, Colors.red),
      ],
    );
  }

  Widget _buildIngresosChart(double total) {
    if (_ingresosChartData.isEmpty) {
      return _buildEmptyState(
        "Sin ingresos registrados",
        "Agrega algunos ingresos para visualizar la distribución",
        Icons.account_balance_wallet_outlined,
        Colors.green.withOpacity(0.3),
      );
    }

    return Column(
      children: [
        SizedBox(height: 300, child: graphicIngresos(total)),
        const SizedBox(height: 16),
        _buildChartLegend(_ingresosChartData, total, Colors.green),
      ],
    );
  }

  Widget _buildEmptyState(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, size: 40, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegend(
    List<GDPData> data,
    double total,
    Color accentColor,
  ) {
    return Column(
      children: data.map((item) {
        final percentage = (item.gdp / total * 100);
        final colorIndex = data.indexOf(item);
        final color = customColors[colorIndex % customColors.length];

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.continent,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${item.gdp.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildComparativeAnalysis(double totalIngresos, double totalGastos) {
    if (totalIngresos == 0 && totalGastos == 0) return const SizedBox();

    final savingsRate = totalIngresos > 0
        ? ((totalIngresos - totalGastos) / totalIngresos * 100)
        : 0;
    final expenseRatio = totalIngresos > 0
        ? (totalGastos / totalIngresos * 100)
        : 0;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.analytics_outlined,
                  color: AppColors.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Análisis Financiero',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildAnalysisRow(
            'Tasa de Ahorro',
            '${savingsRate.toStringAsFixed(1)}%',
            savingsRate >= 20
                ? Colors.green
                : savingsRate >= 10
                ? Colors.orange
                : Colors.red,
            Icons.savings_outlined,
          ),
          const SizedBox(height: 12),
          _buildAnalysisRow(
            'Ratio de Gastos',
            '${expenseRatio.toStringAsFixed(1)}%',
            expenseRatio <= 80
                ? Colors.green
                : expenseRatio <= 90
                ? Colors.orange
                : Colors.red,
            Icons.receipt_long_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisRow(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  SfCircularChart graphicGastos(double total) {
    return SfCircularChart(
      tooltipBehavior: _tooltipBehavior,
      series: <CircularSeries>[
        DoughnutSeries<GDPData, String>(
          dataSource: _gastosChartData,
          xValueMapper: (GDPData data, _) => data.continent,
          yValueMapper: (GDPData data, _) => data.gdp,
          dataLabelMapper: (GDPData data, _) =>
              '${(data.gdp / total * 100).toStringAsFixed(1)}%',
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
            textStyle: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          pointColorMapper: (GDPData data, int index) =>
              customColors[index % customColors.length],
          explode: true,
          explodeOffset: '8%',
          explodeIndex: _explodedIndexChart1,
          enableTooltip: true,
          innerRadius: '60%',
          radius: '90%',
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
      tooltipBehavior: _tooltipBehavior,
      series: <CircularSeries>[
        DoughnutSeries<GDPData, String>(
          dataSource: _ingresosChartData,
          xValueMapper: (GDPData data, _) => data.continent,
          yValueMapper: (GDPData data, _) => data.gdp,
          dataLabelMapper: (GDPData data, _) =>
              '${(data.gdp / total * 100).toStringAsFixed(1)}%',
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
            textStyle: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          pointColorMapper: (GDPData data, int index) =>
              customColors[index % customColors.length],
          explode: true,
          explodeOffset: '8%',
          explodeIndex: _explodedIndexChart2,
          enableTooltip: true,
          innerRadius: '60%',
          radius: '90%',
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

  List<GDPData> convertToChartData(List<MoneyItem> items) {
    return items.map((item) => GDPData(item.title, item.amount)).toList();
  }

  final List<Color> customColors = [
    const Color(0xFF4FC3F7),
    const Color(0xFFFFB74D),
    const Color(0xFFBA68C8),
    const Color(0xFF81C784),
    const Color(0xFFFF8A65),
    const Color(0xFF64B5F6),
    const Color(0xFFA1C4FD),
    const Color(0xFFFFF176),
    const Color(0xFFFF9E80),
    const Color(0xFF90CAF9),
    const Color(0xFFBCAAA4),
    const Color(0xFFE0E0E0),
  ];
}

class GDPData {
  final String continent;
  final double gdp;

  GDPData(this.continent, this.gdp);
}
