import 'package:finestra_app/core/constants/app_colors.dart';
import 'package:finestra_app/core/constants/info_item.dart';
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

class _GeneralScreenState extends State<GeneralScreen> with TickerProviderStateMixin {
  AnimationController? _balanceController;
  AnimationController? _cardController;
  AnimationController? _chartController;

  Animation<double>? _balanceAnimation;
  Animation<double>? _cardAnimation;
  Animation<double>? _chartAnimation;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _balanceController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _chartController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _balanceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _balanceController!,
      curve: Curves.elasticOut,
    ));

    _cardAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardController!,
      curve: Curves.easeOutBack,
    ));

    _chartAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _chartController!,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardController!,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 200), () {
      _balanceController?.forward();
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      _cardController?.forward();
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      _chartController?.forward();
    });
  }

  @override
  void dispose() {
    _balanceController?.dispose();
    _cardController?.dispose();
    _chartController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMainScreen,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header moderno con SliverAppBar
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              expandedHeight: 120,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildModernHeader(),
              ),
            ),

            // Contenido principal
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 20),

                  // Balance principal con animación
                  _buildBalanceCard(),

                  const SizedBox(height: 30),

                  // Cards de ingresos y gastos
                  _buildFinancialOverview(),

                  const SizedBox(height: 30),

                  // Gráfica mejorada
                  _buildModernChart(),

                  const SizedBox(height: 30),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.analytics_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Movimientos",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Resumen financiero",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    Color balanceColor = widget.balance >= 0
        ? Colors.green[600]!
        : Colors.red[600]!;

    IconData balanceIcon = widget.balance >= 0
        ? Icons.trending_up_rounded
        : Icons.trending_down_rounded;

    return ScaleTransition(
      scale: _balanceAnimation ?? AlwaysStoppedAnimation(1.0),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              balanceColor,
              balanceColor.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: balanceColor.withOpacity(0.4),
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
                Icon(
                  balanceIcon,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 12),
                const Text(
                  "Balance Total",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "\$${widget.balance.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.balance >= 0 ? "Situación favorable" : "Requiere atención",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialOverview() {
    return SlideTransition(
      position: _slideAnimation ?? AlwaysStoppedAnimation(Offset.zero),
      child: FadeTransition(
        opacity: _cardAnimation ?? AlwaysStoppedAnimation(1.0),
        child: Row(
          children: [
            Expanded(
              child: _buildFinancialCard(
                title: "Ingresos",
                amount: widget.ingresosTotal,
                icon: Icons.arrow_upward_rounded,
                color: Colors.green[600]!,
                lastItem: widget.ingresos.isEmpty ? null : widget.ingresos.last,
                isEmpty: widget.ingresos.isEmpty,
                emptyMessage: "Sin ingresos",
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFinancialCard(
                title: "Gastos",
                amount: widget.gastosTotal,
                icon: Icons.arrow_downward_rounded,
                color: Colors.red[600]!,
                lastItem: widget.gastos.isEmpty ? null : widget.gastos.last,
                isEmpty: widget.gastos.isEmpty,
                emptyMessage: "Sin gastos",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialCard({
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
    MoneyItem? lastItem,
    required bool isEmpty,
    required String emptyMessage,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          // Header de la tarjeta
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Monto principal
          Text(
            "\$${amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),

          const SizedBox(height: 16),

          // Divisor
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.2),
          ),

          const SizedBox(height: 16),

          // Último movimiento
          Text(
            isEmpty ? emptyMessage : "Último ${title.toLowerCase().substring(0, title.length-1)}",
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textColor.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.backgroundMainScreen.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: isEmpty
                ? Text(
              "No hay registros",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      lastItem!.icon,
                      size: 16,
                      color: AppColors.textColor,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        lastItem.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "\$${lastItem.amount.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernChart() {
    return FadeTransition(
      opacity: _chartAnimation ?? AlwaysStoppedAnimation(1.0),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.pie_chart_rounded,
                    color: AppColors.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Distribución Financiera",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              "Visualización de ingresos vs gastos",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textColor.withOpacity(0.7),
              ),
            ),

            const SizedBox(height: 24),

            _buildChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    // Si no hay datos
    if (widget.ingresos.isEmpty && widget.gastos.isEmpty) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          color: AppColors.backgroundMainScreen.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.insert_chart_outlined_rounded,
              size: 60,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              "No hay datos disponibles",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Agrega ingresos o gastos para ver la gráfica",
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

    // Crear datos para la gráfica
    List<ChartData> chartData = [];
    if (widget.ingresosTotal > 0) {
      chartData.add(ChartData("Ingresos", widget.ingresosTotal));
    }
    if (widget.gastosTotal > 0) {
      chartData.add(ChartData("Gastos", widget.gastosTotal));
    }

    return Container(
      height: 280,
      child: SfCircularChart(
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          textStyle: TextStyle(
            fontSize: 14,
            color: AppColors.textColor,
            fontWeight: FontWeight.w500,
          ),
          legendItemBuilder: (String name, dynamic series, dynamic point, int index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: customColors[index % customColors.length],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    name,
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        series: <CircularSeries>[
          DoughnutSeries<ChartData, String>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.tipo,
            yValueMapper: (ChartData data, _) => data.valor,
            pointColorMapper: (ChartData data, int index) =>
            customColors[index % customColors.length],
            dataLabelMapper: (ChartData data, _) =>
            "\$${data.valor.toStringAsFixed(0)}",
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              connectorLineSettings: const ConnectorLineSettings(
                type: ConnectorType.curve,
                length: '10%',
              ),
            ),
            explode: true,
            explodeIndex: 0,
            explodeOffset: '10%',
            innerRadius: '60%',
            radius: '90%',
            strokeColor: Colors.white,
            strokeWidth: 3,
          ),
        ],
        annotations: <CircularChartAnnotation>[
          CircularChartAnnotation(
            widget: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textColor.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    "\$${(widget.ingresosTotal + widget.gastosTotal).toStringAsFixed(0)}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  final List<Color> customColors = [
    Colors.green[600]!,     // Para ingresos
    Colors.red[600]!,       // Para gastos
  ];
}

class ChartData {
  final String tipo;
  final double valor;

  ChartData(this.tipo, this.valor);
}