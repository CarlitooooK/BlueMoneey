import 'package:finestra_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';

import '../../core/shared/widgets/QuickActionTile.dart';
import '../../models/CreditCard.dart';

class CardsScreen extends StatefulWidget {
  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  List<CreditCard> creditCards = [
    CreditCard(
      id: '1',
      cardNumber: '4532 1234 5678 9012',
      cardHolder: 'JUAN PÉREZ',
      expiryDate: '12/26',
      cardType: 'AMERICAN EXPRESS',
      color: Colors.blue,
      cvv: '123',
    ),
    CreditCard(
      id: '2',
      cardNumber: '5555 4444 3333 2222',
      cardHolder: 'MARÍA GARCÍA',
      expiryDate: '08/25',
      cardType: 'MASTERCARD',
      color: Colors.red,
      cvv: '456',
    ),
  ];

  SwiperController swiperController = SwiperController();
  int currentCardIndex = 0;

  // Datos simulados para las funcionalidades
  Map<String, Map<String, dynamic>> cardData = {
    '1': {
      'cutoffDate': DateTime(2024, 12, 15),
      'paymentDate': DateTime(2024, 12, 28),
      'currentBalance': 15750.00,
      'spendingLimit': 50000.00,
      'transactions': [
        {'date': DateTime(2024, 11, 20), 'description': 'Amazon', 'amount': 1250.00},
        {'date': DateTime(2024, 11, 18), 'description': 'Starbucks', 'amount': 85.50},
        {'date': DateTime(2024, 11, 15), 'description': 'Gasolina', 'amount': 650.00},
        {'date': DateTime(2024, 11, 12), 'description': 'Supermercado', 'amount': 2340.00},
        {'date': DateTime(2024, 11, 10), 'description': 'Netflix', 'amount': 199.00},
      ]
    },
    '2': {
      'cutoffDate': DateTime(2024, 12, 10),
      'paymentDate': DateTime(2024, 12, 25),
      'currentBalance': 8920.00,
      'spendingLimit': 30000.00,
      'transactions': [
        {'date': DateTime(2024, 11, 22), 'description': 'Restaurante', 'amount': 850.00},
        {'date': DateTime(2024, 11, 19), 'description': 'Uber', 'amount': 120.00},
        {'date': DateTime(2024, 11, 16), 'description': 'Farmacia', 'amount': 345.50},
        {'date': DateTime(2024, 11, 14), 'description': 'Ropa', 'amount': 1200.00},
      ]
    }
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMainScreen,
      body: Column(
        children: [
          // Swiper de tarjetas
          Container(
            height: 220,
            margin: EdgeInsets.symmetric(vertical: 20),
            child: creditCards.isEmpty
                ? _buildEmptyState()
                : Swiper(
              controller: swiperController,
              itemBuilder: (BuildContext context, int index) {
                return _buildCreditCard(creditCards[index], index);
              },
              itemCount: creditCards.length,
              viewportFraction: 0.85,
              scale: 0.9,
              loop: false,
              onIndexChanged: (index) {
                setState(() {
                  currentCardIndex = index;
                });
              },
            ),
          ),

          // Información adicional
          if (creditCards.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total de tarjetas: ${creditCards.length}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _showAddCardDialog,
                    icon: Icon(Icons.add_circle_outline),
                    label: Text('Agregar'),
                  ),
                ],
              ),
            ),
          ],

          // Lista de acciones rápidas
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          'Acciones Rápidas',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  QuickActionTile(
                    icon: Icons.calendar_month,
                    title: 'Fechas de Corte y Pago',
                    subtitle: 'Paga tus estados de cuenta',
                    onTap: () => _showPaymentDatesDialog(),
                  ),
                  QuickActionTile(
                    icon: Icons.history,
                    title: 'Historial de gastos',
                    subtitle: 'Conoce tus gastos para esta tarjeta',
                    onTap: () => _showExpenseHistoryDialog(),
                  ),
                  QuickActionTile(
                    icon: Icons.account_balance_wallet,
                    title: 'Limite de compras',
                    subtitle: 'Establece un limite de compras',
                    onTap: () => _showSpendingLimitDialog(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentDatesDialog() {
    if (creditCards.isEmpty) return;

    final currentCard = creditCards[currentCardIndex];
    final data = cardData[currentCard.id] ?? {};
    final cutoffDate = data['cutoffDate'] as DateTime?;
    final paymentDate = data['paymentDate'] as DateTime?;
    final balance = data['currentBalance'] as double? ?? 0.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.calendar_month, color: Colors.blue),
            SizedBox(width: 10),
            Expanded(child: Text('Fechas de Corte y Pago')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información de la tarjeta
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: currentCard.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.credit_card, color: currentCard.color),
                  SizedBox(width: 10),
                  Text(
                    '${currentCard.cardType} •••• ${currentCard.cardNumber.substring(currentCard.cardNumber.length - 4)}',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Saldo actual
            _buildInfoRow(
              'Saldo Actual:',
              '\$${balance.toStringAsFixed(2)}',
              Icons.account_balance,
              Colors.red,
            ),
            SizedBox(height: 15),

            // Fecha de corte
            if (cutoffDate != null)
              _buildInfoRow(
                'Fecha de Corte:',
                '${cutoffDate.day}/${cutoffDate.month}/${cutoffDate.year}',
                Icons.event,
                Colors.orange,
              ),
            SizedBox(height: 15),

            // Fecha de pago
            if (paymentDate != null)
              _buildInfoRow(
                'Fecha Límite de Pago:',
                '${paymentDate.day}/${paymentDate.month}/${paymentDate.year}',
                Icons.payment,
                Colors.green,
              ),
            SizedBox(height: 20),

            // Días restantes
            if (paymentDate != null) ...[
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.amber[700]),
                    SizedBox(width: 10),
                    Text(
                      'Te quedan ${paymentDate.difference(DateTime.now()).inDays} días para pagar',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.amber[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showPaymentMethodsDialog(balance);
            },
            child: Text('Pagar Ahora'),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethodsDialog(double amount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Realizar Pago'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Monto a pagar: \$${amount.toStringAsFixed(2)}'),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.account_balance, color: Colors.blue),
              title: Text('Transferencia Bancaria'),
              subtitle: Text('Cuenta •••• 1234'),
              onTap: () {
                Navigator.pop(context);
                _showPaymentConfirmation('Transferencia Bancaria');
              },
            ),
            ListTile(
              leading: Icon(Icons.qr_code, color: Colors.green),
              title: Text('SPEI/CoDi'),
              subtitle: Text('Pago inmediato'),
              onTap: () {
                Navigator.pop(context);
                _showPaymentConfirmation('SPEI/CoDi');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showPaymentConfirmation(String method) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Text('Pago Programado'),
          ],
        ),
        content: Text('Tu pago por $method ha sido programado exitosamente.'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _showExpenseHistoryDialog() {
    if (creditCards.isEmpty) return;

    final currentCard = creditCards[currentCardIndex];
    final data = cardData[currentCard.id] ?? {};
    final transactions = data['transactions'] as List? ?? [];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.history, color: Colors.blue),
            SizedBox(width: 10),
            Expanded(child: Text('Historial de Gastos')),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información de la tarjeta
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: currentCard.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.credit_card, color: currentCard.color),
                    SizedBox(width: 10),
                    Text(
                      '${currentCard.cardType} •••• ${currentCard.cardNumber.substring(currentCard.cardNumber.length - 4)}',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),

              // Resumen de gastos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryCard(
                    'Total Gastado',
                    '\$${transactions.fold<double>(0, (sum, t) => sum + t['amount']).toStringAsFixed(2)}',
                    Icons.trending_up,
                    Colors.red,
                  ),
                  _buildSummaryCard(
                    'Transacciones',
                    '${transactions.length}',
                    Icons.receipt,
                    Colors.blue,
                  ),
                ],
              ),
              SizedBox(height: 15),

              Text(
                'Últimas Transacciones:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // Lista de transacciones
              Expanded(
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    final date = transaction['date'] as DateTime;
                    final description = transaction['description'] as String;
                    final amount = transaction['amount'] as double;

                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.red[50],
                          child: Icon(Icons.shopping_cart, color: Colors.red),
                        ),
                        title: Text(description),
                        subtitle: Text('${date.day}/${date.month}/${date.year}'),
                        trailing: Text(
                          '-\$${amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Aquí podrías navegar a una pantalla completa de historial
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Exportando reporte detallado...')),
              );
            },
            child: Text('Ver Reporte'),
          ),
        ],
      ),
    );
  }

  void _showSpendingLimitDialog() {
    if (creditCards.isEmpty) return;

    final currentCard = creditCards[currentCardIndex];
    final data = cardData[currentCard.id] ?? {};
    double currentLimit = data['spendingLimit'] as double? ?? 0.0;
    double currentBalance = data['currentBalance'] as double? ?? 0.0;

    TextEditingController limitController = TextEditingController(
        text: currentLimit.toStringAsFixed(0)
    );

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.account_balance_wallet, color: Colors.blue),
              SizedBox(width: 10),
              Expanded(child: Text('Límite de Compras')),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información de la tarjeta
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: currentCard.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.credit_card, color: currentCard.color),
                    SizedBox(width: 10),
                    Text(
                      '${currentCard.cardType} •••• ${currentCard.cardNumber.substring(currentCard.cardNumber.length - 4)}',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Información actual
              Text('Límite Actual: \$${currentLimit.toStringAsFixed(2)}'),
              Text('Saldo Usado: \$${currentBalance.toStringAsFixed(2)}'),
              Text('Disponible: \$${(currentLimit - currentBalance).toStringAsFixed(2)}'),
              SizedBox(height: 15),

              // Barra de progreso
              LinearProgressIndicator(
                value: currentBalance / currentLimit,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  currentBalance / currentLimit > 0.8 ? Colors.red : Colors.blue,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '${((currentBalance / currentLimit) * 100).toStringAsFixed(1)}% utilizado',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              SizedBox(height: 20),

              // Campo para nuevo límite
              TextField(
                controller: limitController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Nuevo Límite',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                  helperText: 'Mínimo \$1,000 - Máximo \$200,000',
                ),
                onChanged: (value) {
                  setDialogState(() {});
                },
              ),
              SizedBox(height: 15),

              // Límites sugeridos
              Text('Límites sugeridos:', style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [10000, 25000, 50000, 100000].map((amount) =>
                    ActionChip(
                      label: Text('\$${amount.toString()}'),
                      onPressed: () {
                        limitController.text = amount.toString();
                        setDialogState(() {});
                      },
                    )
                ).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final newLimit = double.tryParse(limitController.text) ?? currentLimit;
                if (newLimit >= 1000 && newLimit <= 200000) {
                  setState(() {
                    cardData[currentCard.id]!['spendingLimit'] = newLimit;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Límite actualizado a \$${newLimit.toStringAsFixed(2)}'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('El límite debe estar entre \$1,000 y \$200,000'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ... (resto de métodos existentes: _buildEmptyState, _buildCreditCard, etc.)

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.credit_card_off,
            size: 60,
            color: Colors.grey[400],
          ),
          SizedBox(height: 15),
          Text(
            'No tienes tarjetas agregadas',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Toca el botón + para agregar tu primera tarjeta',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _showAddCardDialog,
            icon: Icon(Icons.add),
            label: Text('Agregar Tarjeta'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditCard(CreditCard card, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [card.color, card.color.withValues(green: 0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Patrón de fondo
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha:0.1),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con tipo de tarjeta y botón eliminar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      card.cardType,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _deleteCard(index),
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.white70,
                        size: 20,
                      ),
                      constraints: BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),

                Spacer(),

                // Número de tarjeta
                Text(
                  card.cardNumber,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2,
                  ),
                ),

                SizedBox(height: 20),

                // Información del titular y fecha
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TITULAR',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          card.cardHolder,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'VENCE',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          card.expiryDate,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCardDialog() {
    final formKey = GlobalKey<FormState>();
    String cardNumber = '';
    String cardHolder = '';
    String expiryDate = '';
    String cvv = '';
    String cardType = 'VISA';
    Color selectedColor = Colors.blue;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Agregar Nueva Tarjeta'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Número de Tarjeta',
                      hintText: '1234 5678 9012 3456',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa el número de tarjeta';
                      }
                      return null;
                    },
                    onSaved: (value) => cardNumber = value ?? '',
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Titular de la Tarjeta',
                      hintText: 'JUAN PÉREZ',
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.characters,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa el nombre del titular';
                      }
                      return null;
                    },
                    onSaved: (value) => cardHolder = value ?? '',
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'MM/AA',
                            hintText: '12/26',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.datetime,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingresa la fecha';
                            }
                            return null;
                          },
                          onSaved: (value) => expiryDate = value ?? '',
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'CVV',
                            hintText: '123',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingresa el CVV';
                            }
                            return null;
                          },
                          onSaved: (value) => cvv = value ?? '',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: cardType,
                    decoration: InputDecoration(
                      labelText: 'Tipo de Tarjeta',
                      border: OutlineInputBorder(),
                    ),
                    items: ['VISA', 'MASTERCARD', 'AMERICAN EXPRESS']
                        .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        cardType = value ?? 'VISA';
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  Text('Color de la Tarjeta:'),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Colors.blue,
                      Colors.red,
                      Colors.green,
                      Colors.purple,
                      Colors.orange,
                    ].map((color) => GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: selectedColor == color
                              ? Border.all(color: Colors.black, width: 2)
                              : null,
                        ),
                      ),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  _addCard(cardNumber, cardHolder, expiryDate, cvv, cardType, selectedColor);
                  Navigator.pop(context);
                }
              },
              child: Text('Agregar'),
            ),
          ],
        ),
      ),
    );
  }

  void _addCard(String number, String holder, String expiry, String cvv, String type, Color color) {
    final newCardId = DateTime.now().millisecondsSinceEpoch.toString();

    setState(() {
      creditCards.add(CreditCard(
        id: newCardId,
        cardNumber: number,
        cardHolder: holder.toUpperCase(),
        expiryDate: expiry,
        cardType: type,
        color: color,
        cvv: cvv,
      ));

      // Agregar datos simulados para la nueva tarjeta
      cardData[newCardId] = {
        'cutoffDate': DateTime.now().add(Duration(days: 15)),
        'paymentDate': DateTime.now().add(Duration(days: 28)),
        'currentBalance': 0.0,
        'spendingLimit': 25000.0,
        'transactions': <Map<String, dynamic>>[]
      };
    });

    // Ir a la última tarjeta agregada
    Future.delayed(Duration(milliseconds: 100), () {
      swiperController.move(creditCards.length - 1);
    });
  }

  void _deleteCard(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Tarjeta'),
        content: Text('¿Estás seguro que deseas eliminar esta tarjeta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final cardId = creditCards[index].id;
                creditCards.removeAt(index);
                cardData.remove(cardId);

                // Ajustar el índice actual si es necesario
                if (currentCardIndex >= creditCards.length && creditCards.isNotEmpty) {
                  currentCardIndex = creditCards.length - 1;
                } else if (creditCards.isEmpty) {
                  currentCardIndex = 0;
                }
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}