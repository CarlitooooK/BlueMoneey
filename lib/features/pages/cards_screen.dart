import 'package:finestra_app/core/constants/app_colors.dart';
import 'package:finestra_app/models/extended_card_data_model.dart';
import 'package:finestra_app/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import '../../core/shared/widgets/QuickActionTile.dart';
import '../../models/credit_card_model.dart';

// Enums para mejor organización
enum CardType { credit, debit }

enum TransactionType { expense, income, payment }

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
      cardType: 'VISA CRÉDITO',
      color: Colors.blue,
      cvv: '123',
    ),
    CreditCard(
      id: '2',
      cardNumber: '5555 4444 3333 2222',
      cardHolder: 'MARÍA GARCÍA',
      expiryDate: '08/25',
      cardType: 'MASTERCARD DÉBITO',
      color: Colors.red,
      cvv: '456',
    ),
  ];

  SwiperController swiperController = SwiperController();
  int currentCardIndex = 0;

  // Categorías para transacciones
  final List<String> expenseCategories = [
    'Alimentación',
    'Transporte',
    'Entretenimiento',
    'Compras',
    'Servicios',
    'Salud',
    'Educación',
    'Otros',
  ];

  // Datos extendidos para las tarjetas
  Map<String, ExtendedCardData> cardData = {
    '1': ExtendedCardData(
      cutoffDate: DateTime(2024, 12, 15),
      paymentDate: DateTime(2024, 12, 28),
      currentBalance: -15750.00, // Negativo en crédito = deuda
      spendingLimit: 50000.00,
      creditLimit: 50000.00,
      cardType: CardType.credit,
      cashbackPercentage: 1.5,
      transactions: [
        Transaction(
          id: '1',
          date: DateTime(2024, 11, 20),
          description: 'Amazon',
          amount: 1250.00,
          type: TransactionType.expense,
          category: 'Compras',
        ),
        Transaction(
          id: '2',
          date: DateTime(2024, 11, 18),
          description: 'Starbucks',
          amount: 85.50,
          type: TransactionType.expense,
          category: 'Alimentación',
        ),
        Transaction(
          id: '3',
          date: DateTime(2024, 11, 15),
          description: 'Gasolina Shell',
          amount: 650.00,
          type: TransactionType.expense,
          category: 'Transporte',
        ),
      ],
    ),
    '2': ExtendedCardData(
      currentBalance: 12500.00, // Positivo en débito = saldo disponible
      cardType: CardType.debit,
      cashbackPercentage: 0.5,
      transactions: [
        Transaction(
          id: '4',
          date: DateTime(2024, 11, 22),
          description: 'Depósito Nómina',
          amount: 15000.00,
          type: TransactionType.income,
          category: 'Ingresos',
        ),
        Transaction(
          id: '5',
          date: DateTime(2024, 11, 19),
          description: 'Uber',
          amount: 120.00,
          type: TransactionType.expense,
          category: 'Transporte',
        ),
      ],
    ),
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

          // Información rápida de la tarjeta actual
          if (creditCards.isNotEmpty) ...[
            _buildCurrentCardInfo(),
            SizedBox(height: 10),
          ],

          // Información adicional
          if (creditCards.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total de tarjetas: ${creditCards.length}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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

              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Handle indicator
                  Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Título
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Acciones Rápidas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Acciones principales
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildQuickActionButton(
                          Icons.add_circle,
                          'Agregar\nGasto',
                          Colors.red,
                          () => _showAddTransactionDialog(
                            TransactionType.expense,
                          ),
                        ),
                        _buildQuickActionButton(
                          Icons.account_balance,
                          'Agregar\nIngreso',
                          Colors.green,
                          () =>
                              _showAddTransactionDialog(TransactionType.income),
                        ),
                        _buildQuickActionButton(
                          Icons.payment,
                          'Realizar\nPago',
                          Colors.blue,
                          () => _showPaymentDialog(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),

                  // Acciones secundarias - Ahora como elementos del ListView principal
                  QuickActionTile(
                    icon: Icons.calendar_month,
                    title: 'Fechas de Corte y Pago',
                    subtitle: 'Gestiona fechas y pagos',
                    onTap: () => _showPaymentDatesDialog(),
                  ),
                  QuickActionTile(
                    icon: Icons.history,
                    title: 'Historial de transacciones',
                    subtitle: 'Ver todos los movimientos',
                    onTap: () => _showExpenseHistoryDialog(),
                  ),
                  QuickActionTile(
                    icon: Icons.account_balance_wallet,
                    title: 'Configurar límites',
                    subtitle: 'Establecer límites de gasto',
                    onTap: () => _showSpendingLimitDialog(),
                  ),
                  QuickActionTile(
                    icon: Icons.settings,
                    title: 'Configuración de tarjeta',
                    subtitle: 'Editar información y configuración',
                    onTap: () => _showCardSettingsDialog(),
                  ),

                  // Espacio adicional al final
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentCardInfo() {
    if (creditCards.isEmpty) return SizedBox();

    final currentCard = creditCards[currentCardIndex];
    final data = cardData[currentCard.id];
    if (data == null) return SizedBox();

    final bool isCredit = data.cardType == CardType.credit;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: _buildInfoColumn(
              isCredit ? 'Deuda Actual' : 'Saldo Disponible',
              isCredit
                  ? '\$${data.currentBalance.abs().toStringAsFixed(2)}'
                  : '\$${data.currentBalance.toStringAsFixed(2)}',
              isCredit ? Colors.red : Colors.green,
            ),
          ),
          if (isCredit) ...[
            Expanded(
              child: _buildInfoColumn(
                'Límite de Crédito',
                '\$${data.creditLimit?.toStringAsFixed(2) ?? '0.00'}',
                Colors.blue,
              ),
            ),
            Expanded(
              child: _buildInfoColumn(
                'Disponible',
                '\$${((data.creditLimit ?? 0) + data.currentBalance).toStringAsFixed(2)}',
                Colors.orange,
              ),
            ),
          ] else ...[
            Expanded(
              child: _buildInfoColumn(
                'Cashback',
                '${data.cashbackPercentage}%',
                Colors.purple,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTransactionDialog(TransactionType type) {
    if (creditCards.isEmpty) return;

    final currentCard = creditCards[currentCardIndex];
    final data = cardData[currentCard.id];
    if (data == null) return;

    final formKey = GlobalKey<FormState>();
    String description = '';
    double amount = 0.0;
    String category = expenseCategories.first;
    DateTime selectedDate = DateTime.now();

    // Para tarjetas de débito, verificar si es ingreso y si hay saldo suficiente para gastos
    if (data.cardType == CardType.debit && type == TransactionType.expense) {
      // Se validará en el onPressed
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              Icon(
                type == TransactionType.expense
                    ? Icons.remove_circle
                    : Icons.add_circle,
                color: type == TransactionType.expense
                    ? Colors.red
                    : Colors.green,
              ),
              SizedBox(width: 10),
              Text(
                type == TransactionType.expense
                    ? 'Agregar Gasto'
                    : 'Agregar Ingreso',
              ),
            ],
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                        Expanded(
                          child: Text(
                            '${currentCard.cardType} •••• ${currentCard.cardNumber.substring(currentCard.cardNumber.length - 4)}',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa una descripción';
                      }
                      return null;
                    },
                    onSaved: (value) => description = value ?? '',
                  ),
                  SizedBox(height: 15),

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Monto',
                      prefixText: '\$',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa un monto';
                      }
                      final parsedAmount = double.tryParse(value);
                      if (parsedAmount == null || parsedAmount <= 0) {
                        return 'Ingresa un monto válido';
                      }
                      return null;
                    },
                    onSaved: (value) =>
                        amount = double.tryParse(value ?? '') ?? 0.0,
                  ),
                  SizedBox(height: 15),

                  if (type == TransactionType.expense) ...[
                    DropdownButtonFormField<String>(
                      value: category,
                      decoration: InputDecoration(
                        labelText: 'Categoría',
                        border: OutlineInputBorder(),
                      ),
                      items: expenseCategories
                          .map(
                            (cat) =>
                                DropdownMenuItem(value: cat, child: Text(cat)),
                          )
                          .toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          category = value ?? expenseCategories.first;
                        });
                      },
                    ),
                    SizedBox(height: 15),
                  ],

                  ListTile(
                    title: Text('Fecha'),
                    subtitle: Text(
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                    ),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now().subtract(Duration(days: 365)),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setDialogState(() {
                          selectedDate = date;
                        });
                      }
                    },
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

                  // Validar saldo suficiente para tarjetas de débito
                  if (data.cardType == CardType.debit &&
                      type == TransactionType.expense) {
                    if (amount > data.currentBalance) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Saldo insuficiente. Saldo actual: \$${data.currentBalance.toStringAsFixed(2)}',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                  }

                  _addTransaction(
                    type,
                    description,
                    amount,
                    category,
                    selectedDate,
                  );
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

  void _addTransaction(
    TransactionType type,
    String description,
    double amount,
    String category,
    DateTime date,
  ) {
    if (creditCards.isEmpty) return;

    final currentCard = creditCards[currentCardIndex];
    final data = cardData[currentCard.id];
    if (data == null) return;

    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: date,
      description: description,
      amount: amount,
      type: type,
      category: type == TransactionType.income ? 'Ingresos' : category,
    );

    setState(() {
      data.transactions.insert(0, transaction); // Agregar al inicio

      // Actualizar saldo según el tipo de tarjeta y transacción
      if (data.cardType == CardType.credit) {
        // En tarjetas de crédito: gastos aumentan la deuda (más negativo), pagos la reducen
        if (type == TransactionType.expense) {
          data.currentBalance -= amount; // Más deuda
        } else if (type == TransactionType.payment) {
          data.currentBalance += amount; // Menos deuda
        }
      } else {
        // En tarjetas de débito: ingresos aumentan saldo, gastos lo reducen
        if (type == TransactionType.income) {
          data.currentBalance += amount;
        } else if (type == TransactionType.expense) {
          data.currentBalance -= amount;
        }
      }
    });

    // Calcular cashback para gastos
    if (type == TransactionType.expense && data.cashbackPercentage > 0) {
      final cashback = amount * (data.cashbackPercentage / 100);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '¡Ganaste \$${cashback.toStringAsFixed(2)} en cashback!',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${type == TransactionType.expense ? "Gasto" : "Ingreso"} agregado exitosamente',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showPaymentDialog() {
    if (creditCards.isEmpty) return;

    final currentCard = creditCards[currentCardIndex];
    final data = cardData[currentCard.id];
    if (data == null) return;

    // Solo mostrar para tarjetas de crédito con deuda
    if (data.cardType != CardType.credit || data.currentBalance >= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Esta tarjeta no tiene deuda pendiente'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final debtAmount = data.currentBalance.abs();
    final minimumPayment = debtAmount * 0.05; // 5% mínimo

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.payment, color: Colors.blue),
            SizedBox(width: 10),
            Text('Realizar Pago'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Deuda actual: \$${debtAmount.toStringAsFixed(2)}'),
            Text('Pago mínimo: \$${minimumPayment.toStringAsFixed(2)}'),
            SizedBox(height: 20),

            ListTile(
              title: Text('Pago Mínimo'),
              subtitle: Text('\$${minimumPayment.toStringAsFixed(2)}'),
              onTap: () {
                Navigator.pop(context);
                _processPayment(minimumPayment);
              },
            ),
            ListTile(
              title: Text('Pago Total'),
              subtitle: Text('\$${debtAmount.toStringAsFixed(2)}'),
              onTap: () {
                Navigator.pop(context);
                _processPayment(debtAmount);
              },
            ),
            ListTile(
              title: Text('Monto Personalizado'),
              subtitle: Text('Especificar cantidad'),
              onTap: () {
                Navigator.pop(context);
                _showCustomPaymentDialog(debtAmount);
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

  void _showCustomPaymentDialog(double maxAmount) {
    final formKey = GlobalKey<FormState>();
    double paymentAmount = 0.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Monto Personalizado'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Deuda máxima: \$${maxAmount.toStringAsFixed(2)}'),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Monto a pagar',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa un monto';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Ingresa un monto válido';
                  }
                  if (amount > maxAmount) {
                    return 'El monto no puede ser mayor a la deuda';
                  }
                  return null;
                },
                onSaved: (value) =>
                    paymentAmount = double.tryParse(value ?? '') ?? 0.0,
              ),
            ],
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
                Navigator.pop(context);
                _processPayment(paymentAmount);
              }
            },
            child: Text('Pagar'),
          ),
        ],
      ),
    );
  }

  void _processPayment(double amount) {
    _addTransaction(
      TransactionType.payment,
      'Pago de tarjeta de crédito',
      amount,
      'Pagos',
      DateTime.now(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Pago de \${amount.toStringAsFixed(2)} procesado exitosamente',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showAnalyticsDialog() {
    if (creditCards.isEmpty) return;

    // Calcular estadísticas generales
    double totalBalance = 0;
    double totalExpenses = 0;
    double totalIncome = 0;
    int totalTransactions = 0;

    for (final cardId in cardData.keys) {
      final data = cardData[cardId]!;
      if (data.cardType == CardType.credit) {
        totalBalance += data.currentBalance; // Deuda
      } else {
        totalBalance += data.currentBalance; // Saldo positivo
      }

      for (final transaction in data.transactions) {
        totalTransactions++;
        if (transaction.type == TransactionType.expense) {
          totalExpenses += transaction.amount;
        } else if (transaction.type == TransactionType.income) {
          totalIncome += transaction.amount;
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.analytics, color: Colors.blue),
            SizedBox(width: 10),
            Text('Análisis Financiero'),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAnalyticsCard(
                'Balance Total',
                totalBalance,
                totalBalance >= 0 ? Colors.green : Colors.red,
              ),
              _buildAnalyticsCard('Total Gastos', totalExpenses, Colors.red),
              _buildAnalyticsCard('Total Ingresos', totalIncome, Colors.green),
              _buildAnalyticsCard(
                'Transacciones',
                totalTransactions.toDouble(),
                Colors.blue,
                isInteger: true,
              ),
              SizedBox(height: 15),
              Text(
                'Promedio de gasto: \$${totalTransactions > 0 ? (totalExpenses / totalTransactions).toStringAsFixed(2) : '0.00'}',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(
    String title,
    double value,
    Color color, {
    bool isInteger = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
          Text(
            isInteger
                ? value.toInt().toString()
                : '\$${value.abs().toStringAsFixed(2)}',
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  void _showCardSettingsDialog() {
    if (creditCards.isEmpty) return;

    final currentCard = creditCards[currentCardIndex];
    final data = cardData[currentCard.id];
    if (data == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Configuración de Tarjeta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit, color: Colors.blue),
              title: Text('Editar información'),
              subtitle: Text('Cambiar datos de la tarjeta'),
              onTap: () {
                Navigator.pop(context);
                _showEditCardDialog();
              },
            ),
            ListTile(
              leading: Icon(
                data.isActive ? Icons.pause_circle : Icons.play_circle,
                color: data.isActive ? Colors.orange : Colors.green,
              ),
              title: Text(
                data.isActive ? 'Desactivar tarjeta' : 'Activar tarjeta',
              ),
              subtitle: Text(
                data.isActive ? 'Pausar temporalmente' : 'Reactivar tarjeta',
              ),
              onTap: () {
                Navigator.pop(context);
                _toggleCardStatus();
              },
            ),
            if (data.cardType == CardType.credit) ...[
              ListTile(
                leading: Icon(Icons.schedule, color: Colors.purple),
                title: Text('Configurar fechas'),
                subtitle: Text('Cambiar fechas de corte y pago'),
                onTap: () {
                  Navigator.pop(context);
                  _showDateConfigDialog();
                },
              ),
            ],
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Eliminar tarjeta'),
              subtitle: Text('Eliminar permanentemente'),
              onTap: () {
                Navigator.pop(context);
                _deleteCard(currentCardIndex);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showEditCardDialog() {
    final currentCard = creditCards[currentCardIndex];
    final data = cardData[currentCard.id];
    if (data == null) return;

    final formKey = GlobalKey<FormState>();
    String cardHolder = currentCard.cardHolder;
    String expiryDate = currentCard.expiryDate;
    double cashbackPercentage = data.cashbackPercentage;
    double? creditLimit = data.creditLimit;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Editar Tarjeta'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: cardHolder,
                    decoration: InputDecoration(
                      labelText: 'Titular de la Tarjeta',
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
                  TextFormField(
                    initialValue: expiryDate,
                    decoration: InputDecoration(
                      labelText: 'Fecha de Vencimiento (MM/AA)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa la fecha de vencimiento';
                      }
                      return null;
                    },
                    onSaved: (value) => expiryDate = value ?? '',
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    initialValue: cashbackPercentage.toString(),
                    decoration: InputDecoration(
                      labelText: 'Porcentaje de Cashback (%)',
                      border: OutlineInputBorder(),
                      suffixText: '%',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final percent = double.tryParse(value ?? '');
                      if (percent == null || percent < 0 || percent > 10) {
                        return 'Ingresa un porcentaje válido (0-10%)';
                      }
                      return null;
                    },
                    onSaved: (value) => cashbackPercentage =
                        double.tryParse(value ?? '') ?? 0.0,
                  ),
                  if (data.cardType == CardType.credit) ...[
                    SizedBox(height: 15),
                    TextFormField(
                      initialValue: creditLimit?.toString() ?? '',
                      decoration: InputDecoration(
                        labelText: 'Límite de Crédito',
                        prefixText: '{\}',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final limit = double.tryParse(value);
                          if (limit == null || limit <= 0) {
                            return 'Ingresa un límite válido';
                          }
                        }
                        return null;
                      },
                      onSaved: (value) =>
                          creditLimit = double.tryParse(value ?? ''),
                    ),
                  ],
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
                  _updateCard(
                    cardHolder,
                    expiryDate,
                    cashbackPercentage,
                    creditLimit,
                  );
                  Navigator.pop(context);
                }
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateCard(
    String cardHolder,
    String expiryDate,
    double cashbackPercentage,
    double? creditLimit,
  ) {
    setState(() {
      final currentCard = creditCards[currentCardIndex];
      final updatedCard = CreditCard(
        id: currentCard.id,
        cardNumber: currentCard.cardNumber,
        cardHolder: cardHolder.toUpperCase(),
        expiryDate: expiryDate,
        cardType: currentCard.cardType,
        color: currentCard.color,
        cvv: currentCard.cvv,
      );
      creditCards[currentCardIndex] = updatedCard;

      final data = cardData[currentCard.id]!;
      data.cashbackPercentage = cashbackPercentage;
      if (creditLimit != null) {
        data.creditLimit = creditLimit;
        data.spendingLimit = creditLimit;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarjeta actualizada exitosamente'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _toggleCardStatus() {
    if (creditCards.isEmpty) return;

    final currentCard = creditCards[currentCardIndex];
    final data = cardData[currentCard.id];
    if (data == null) return;

    setState(() {
      data.isActive = !data.isActive;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          data.isActive ? 'Tarjeta activada' : 'Tarjeta desactivada',
        ),
        backgroundColor: data.isActive ? Colors.green : Colors.orange,
      ),
    );
  }

  void _showDateConfigDialog() {
    if (creditCards.isEmpty) return;

    final currentCard = creditCards[currentCardIndex];
    final data = cardData[currentCard.id];
    if (data == null || data.cardType != CardType.credit) return;

    DateTime cutoffDate =
        data.cutoffDate ?? DateTime.now().add(Duration(days: 15));
    DateTime paymentDate =
        data.paymentDate ?? DateTime.now().add(Duration(days: 30));

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Configurar Fechas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Fecha de Corte'),
                subtitle: Text(
                  '${cutoffDate.day}/${cutoffDate.month}/${cutoffDate.year}',
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: cutoffDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (date != null) {
                    setDialogState(() {
                      cutoffDate = date;
                    });
                  }
                },
              ),
              ListTile(
                title: Text('Fecha de Pago'),
                subtitle: Text(
                  '${paymentDate.day}/${paymentDate.month}/${paymentDate.year}',
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: paymentDate,
                    firstDate: cutoffDate,
                    lastDate: cutoffDate.add(Duration(days: 30)),
                  );
                  if (date != null) {
                    setDialogState(() {
                      paymentDate = date;
                    });
                  }
                },
              ),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'La fecha de pago debe ser posterior a la fecha de corte.',
                  style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                ),
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
                setState(() {
                  data.cutoffDate = cutoffDate;
                  data.paymentDate = paymentDate;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Fechas actualizadas exitosamente'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  // Métodos existentes actualizados
  void _showPaymentDatesDialog() {
    if (creditCards.isEmpty) return;

    final currentCard = creditCards[currentCardIndex];
    final data = cardData[currentCard.id];
    if (data == null) return;

    // Para tarjetas de débito, mostrar información diferente
    if (data.cardType == CardType.debit) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.account_balance_wallet, color: Colors.green),
              SizedBox(width: 10),
              Text('Información de Débito'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                'Saldo Actual:',
                data.currentBalance.toStringAsFixed(2),
                Icons.account_balance,
                Colors.green,
              ),
              SizedBox(height: 15),
              _buildInfoRow(
                'Cashback:',
                '${data.cashbackPercentage}%',
                Icons.star,
                Colors.purple,
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Las tarjetas de débito no tienen fechas de corte ni pago.',
                  style: TextStyle(color: Colors.green[700]),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cerrar'),
            ),
          ],
        ),
      );
    } else {
      // Para tarjetas de crédito, mostrar fechas de corte y pago
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.credit_card, color: Colors.blue),
              SizedBox(width: 10),
              Text('Fechas de Pago'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                'Fecha de Corte:',
                data.cutoffDate != null
                    ? '${data.cutoffDate!.day}/${data.cutoffDate!.month}/${data.cutoffDate!.year}'
                    : "No definida",
                Icons.calendar_today,
                Colors.orange,
              ),
              SizedBox(height: 15),
              _buildInfoRow(
                'Fecha de Pago:',
                data.paymentDate != null
                    ? '${data.paymentDate!.day}/${data.paymentDate!.month}/${data.paymentDate!.year}'
                    : "No definida",
                Icons.payment,
                Colors.red,
              ),
              SizedBox(height: 15),
              _buildInfoRow(
                'Saldo Actual:',
                data.currentBalance.toStringAsFixed(2),
                Icons.account_balance,
                Colors.blue,
              ),
              SizedBox(height: 15),
              _buildInfoRow(
                'Límite de Crédito:',
                data.creditLimit?.toStringAsFixed(2) ?? "N/A",
                Icons.credit_score,
                Colors.purple,
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Recuerda realizar tu pago antes de la fecha límite para evitar intereses.',
                  style: TextStyle(color: Colors.blue[700]),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cerrar'),
            ),
          ],
        ),
      );
    }
  }

  void _showExpenseHistoryDialog() {
    if (creditCards.isEmpty) return;

    final currentCard = creditCards[currentCardIndex];
    final data = cardData[currentCard.id];
    if (data == null) return;

    final transactions = data.transactions;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.history, color: Colors.blue),
            SizedBox(width: 10),
            Expanded(child: Text('Historial de Transacciones')),
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
                  color: currentCard.color.withAlpha(20),
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

              // Resumen de transacciones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryCard(
                    'Total Gastado',
                    transactions
                        .where((t) => t.type == TransactionType.expense)
                        .fold<double>(0, (sum, t) => sum + t.amount)
                        .toStringAsFixed(2),
                    Icons.trending_down,
                    Colors.red,
                  ),
                  _buildSummaryCard(
                    'Total Ingresos',
                    transactions
                        .where((t) => t.type == TransactionType.income)
                        .fold<double>(0, (sum, t) => sum + t.amount)
                        .toStringAsFixed(2),
                    Icons.trending_up,
                    Colors.green,
                  ),
                ],
              ),
              SizedBox(height: 15),

              Text(
                'Transacciones Recientes:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // Lista de transacciones
              Expanded(
                child: transactions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long,
                              size: 50,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 10),
                            Text(
                              'No hay transacciones',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          final date = transaction.date;
                          final description = transaction.description;
                          final amount = transaction.amount;

                          Color iconColor;
                          IconData icon;
                          String prefix;

                          switch (transaction.type) {
                            case TransactionType.expense:
                              iconColor = Colors.red;
                              icon = Icons.remove_circle;
                              prefix = '-';
                              break;
                            case TransactionType.income:
                              iconColor = Colors.green;
                              icon = Icons.add_circle;
                              prefix = '+';
                              break;
                            case TransactionType.payment:
                              iconColor = Colors.blue;
                              icon = Icons.payment;
                              prefix = '';
                              break;
                          }

                          return Card(
                            margin: EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: iconColor.withOpacity(0.2),
                                child: Icon(icon, color: iconColor, size: 20),
                              ),
                              title: Text(description),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${date.day}/${date.month}/${date.year}',
                                  ),
                                  Text(
                                    transaction.category,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Text(
                                amount.toStringAsFixed(2),
                                style: TextStyle(
                                  color: iconColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onLongPress: () =>
                                  _showDeleteTransactionDialog(transaction),
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Exportando reporte detallado...')),
              );
            },
            child: Text('Exportar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteTransactionDialog(Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Transacción'),
        content: Text('¿Deseas eliminar "${transaction.description}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteTransaction(transaction);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _deleteTransaction(Transaction transaction) {
    if (creditCards.isEmpty) return;

    final currentCard = creditCards[currentCardIndex];
    final data = cardData[currentCard.id];
    if (data == null) return;

    setState(() {
      data.transactions.removeWhere((t) => t.id == transaction.id);

      // Revertir el efecto en el saldo
      if (data.cardType == CardType.credit) {
        if (transaction.type == TransactionType.expense) {
          data.currentBalance += transaction.amount; // Reducir deuda
        } else if (transaction.type == TransactionType.payment) {
          data.currentBalance -= transaction.amount; // Aumentar deuda
        }
      } else {
        if (transaction.type == TransactionType.income) {
          data.currentBalance -= transaction.amount; // Reducir saldo
        } else if (transaction.type == TransactionType.expense) {
          data.currentBalance += transaction.amount; // Aumentar saldo
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transacción eliminada'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showSpendingLimitDialog() {
    if (creditCards.isEmpty) return;

    final currentCard = creditCards[currentCardIndex];
    final data = cardData[currentCard.id];
    if (data == null) return;

    if (data.cardType == CardType.debit) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Las tarjetas de débito no tienen límites de crédito'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    double currentLimit = data.spendingLimit ?? 0.0;
    double currentDebt = data.currentBalance.abs();

    TextEditingController limitController = TextEditingController(
      text: currentLimit.toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.account_balance_wallet, color: Colors.blue),
              SizedBox(width: 10),
              Expanded(child: Text('Límite de Crédito')),
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
              Text('Límite Actual: ${currentLimit.toStringAsFixed(2)}'),
              Text('Deuda Actual: ${currentDebt.toStringAsFixed(2)}'),
              Text(
                'Disponible: ${(currentLimit - currentDebt).toStringAsFixed(2)}',
              ),
              SizedBox(height: 15),

              // Barra de progreso
              LinearProgressIndicator(
                value: currentDebt / currentLimit,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  currentDebt / currentLimit > 0.8 ? Colors.red : Colors.blue,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '${currentLimit > 0 ? ((currentDebt / currentLimit) * 100).toStringAsFixed(1) : '0.0'}% utilizado',
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
                  helperText: 'Mínimo \$1,000 - Máximo \$500,000',
                ),
                onChanged: (value) {
                  setDialogState(() {});
                },
              ),
              SizedBox(height: 15),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final newLimit =
                    double.tryParse(limitController.text) ?? currentLimit;
                if (newLimit >= 1000 && newLimit <= 500000) {
                  setState(() {
                    data.spendingLimit = newLimit;
                    data.creditLimit = newLimit;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Límite actualizado a ${newLimit.toStringAsFixed(2)}',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'El límite debe estar entre \$1,000 y \$500,000',
                      ),
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
          child: Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
        ),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
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
              fontSize: 14,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.credit_card_off, size: 60, color: Colors.grey[400]),
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
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
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
    final data = cardData[card.id];
    final isActive = data?.isActive ?? true;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: isActive
              ? [card.color, card.color.withOpacity(0.7)]
              : [Colors.grey[400]!, Colors.grey[600]!],
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
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),

          // Indicador de estado
          if (!isActive)
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'INACTIVA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con tipo de tarjeta y menú
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        card.cardType,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.white70,
                        size: 20,
                      ),
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            _showEditCardDialog();
                            break;
                          case 'delete':
                            _deleteCard(index);
                            break;
                          case 'toggle':
                            _toggleCardStatus();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 16),
                              SizedBox(width: 8),
                              Text('Editar'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'toggle',
                          child: Row(
                            children: [
                              Icon(
                                isActive ? Icons.pause : Icons.play_arrow,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text(isActive ? 'Desactivar' : 'Activar'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 16, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'Eliminar',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Spacer(),

                // Número de tarjeta
                Text(
                  isActive ? card.cardNumber : '•••• •••• •••• ••••',
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
    String cardTypeString = 'VISA';
    CardType cardType = CardType.credit;
    Color selectedColor = Colors.blue;
    double initialBalance = 0.0;
    double? creditLimit;
    double cashbackPercentage = 0.0;
    DateTime? cutoffDate;
    DateTime? paymentDate;

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

                  // Tipo de tarjeta (Crédito/Débito)
                  DropdownButtonFormField<CardType>(
                    value: cardType,
                    decoration: InputDecoration(
                      labelText: 'Tipo de Tarjeta',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: CardType.credit,
                        child: Text('Crédito'),
                      ),
                      DropdownMenuItem(
                        value: CardType.debit,
                        child: Text('Débito'),
                      ),
                    ],
                    onChanged: (value) {
                      setDialogState(() {
                        cardType = value ?? CardType.credit;
                      });
                    },
                  ),
                  SizedBox(height: 15),

                  // Marca de la tarjeta
                  DropdownButtonFormField<String>(
                    value: cardTypeString,
                    decoration: InputDecoration(
                      labelText: 'Marca',
                      border: OutlineInputBorder(),
                    ),
                    items: ['VISA', 'MASTERCARD', 'AMERICAN EXPRESS']
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(
                              '$type ${cardType == CardType.credit ? "CRÉDITO" : "DÉBITO"}',
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        cardTypeString = value ?? 'VISA';
                      });
                    },
                  ),
                  SizedBox(height: 15),

                  // Saldo inicial o límite de crédito
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: cardType == CardType.credit
                          ? 'Límite de Crédito'
                          : 'Saldo Inicial',
                      prefixText: '{\}',
                      border: OutlineInputBorder(),
                      helperText: cardType == CardType.credit
                          ? 'Límite disponible para gastar'
                          : 'Saldo actual en la cuenta',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final amount = double.tryParse(value ?? '');
                      if (amount == null || amount < 0) {
                        return 'Ingresa un monto válido';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      final amount = double.tryParse(value ?? '') ?? 0.0;
                      if (cardType == CardType.credit) {
                        creditLimit = amount;
                        initialBalance =
                            0.0; // Las tarjetas de crédito empiezan en 0
                      } else {
                        initialBalance = amount;
                      }
                    },
                  ),
                  SizedBox(height: 15),

                  // Porcentaje de cashback
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Cashback (%)',
                      suffixText: '%',
                      border: OutlineInputBorder(),
                      helperText: 'Porcentaje de recompensa (0-10%)',
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: '0',
                    validator: (value) {
                      final percent = double.tryParse(value ?? '');
                      if (percent == null || percent < 0 || percent > 10) {
                        return 'Ingresa un porcentaje entre 0 y 10';
                      }
                      return null;
                    },
                    onSaved: (value) => cashbackPercentage =
                        double.tryParse(value ?? '') ?? 0.0,
                  ),
                  SizedBox(height: 15),

                  // Fechas para tarjetas de crédito
                  if (cardType == CardType.credit) ...[
                    Text(
                      'Fechas de Corte y Pago:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text('Fecha de Corte'),
                            subtitle: Text(
                              cutoffDate != null
                                  ? '${cutoffDate!.day}/${cutoffDate!.month}/${cutoffDate!.year}'
                                  : 'No configurada',
                            ),
                            trailing: Icon(Icons.calendar_today),
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now().add(
                                  Duration(days: 15),
                                ),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(
                                  Duration(days: 365),
                                ),
                              );
                              if (date != null) {
                                setDialogState(() {
                                  cutoffDate = date;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text('Fecha de Pago'),
                            subtitle: Text(
                              paymentDate != null
                                  ? '${paymentDate!.day}/${paymentDate!.month}/${paymentDate!.year}'
                                  : 'No configurada',
                            ),
                            trailing: Icon(Icons.calendar_today),
                            onTap: () async {
                              final minDate = cutoffDate ?? DateTime.now();
                              final date = await showDatePicker(
                                context: context,
                                initialDate: minDate.add(Duration(days: 15)),
                                firstDate: minDate,
                                lastDate: minDate.add(Duration(days: 30)),
                              );
                              if (date != null) {
                                setDialogState(() {
                                  paymentDate = date;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                  ],

                  // Selector de color
                  Text('Color de la Tarjeta:'),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        [
                              Colors.blue,
                              Colors.red,
                              Colors.green,
                              Colors.purple,
                              Colors.orange,
                              Colors.teal,
                            ]
                            .map(
                              (color) => GestureDetector(
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
                                        ? Border.all(
                                            color: Colors.black,
                                            width: 2,
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
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
                  _addCard(
                    cardNumber,
                    cardHolder,
                    expiryDate,
                    cvv,
                    '$cardTypeString ${cardType == CardType.credit ? "CRÉDITO" : "DÉBITO"}',
                    selectedColor,
                    cardType,
                    initialBalance,
                    creditLimit,
                    cashbackPercentage,
                    cutoffDate,
                    paymentDate,
                  );
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

  void _addCard(
    String number,
    String holder,
    String expiry,
    String cvv,
    String type,
    Color color,
    CardType cardType,
    double initialBalance,
    double? creditLimit,
    double cashbackPercentage,
    DateTime? cutoffDate,
    DateTime? paymentDate,
  ) {
    final newCardId = DateTime.now().millisecondsSinceEpoch.toString();

    setState(() {
      creditCards.add(
        CreditCard(
          id: newCardId,
          cardNumber: number,
          cardHolder: holder.toUpperCase(),
          expiryDate: expiry,
          cardType: type,
          color: color,
          cvv: cvv,
        ),
      );

      // Crear datos extendidos para la nueva tarjeta
      cardData[newCardId] = ExtendedCardData(
        cutoffDate: cutoffDate,
        paymentDate: paymentDate,
        currentBalance: initialBalance,
        spendingLimit: creditLimit,
        creditLimit: creditLimit,
        cardType: cardType,
        cashbackPercentage: cashbackPercentage,
        transactions: [],
        isActive: true,
      );
    });

    // Ir a la última tarjeta agregada
    Future.delayed(Duration(milliseconds: 100), () {
      if (swiperController != null && creditCards.isNotEmpty) {
        swiperController.move(creditCards.length - 1);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarjeta ${type} agregada exitosamente'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deleteCard(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Tarjeta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('¿Estás seguro que deseas eliminar esta tarjeta?'),
            SizedBox(height: 10),
            Text(
              '${creditCards[index].cardType}\n•••• ${creditCards[index].cardNumber.substring(creditCards[index].cardNumber.length - 4)}',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Esta acción no se puede deshacer. Se eliminará toda la información y transacciones asociadas.',
                style: TextStyle(fontSize: 12, color: Colors.red[700]),
              ),
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
              setState(() {
                final cardId = creditCards[index].id;
                creditCards.removeAt(index);
                cardData.remove(cardId);

                // Ajustar el índice actual si es necesario
                if (currentCardIndex >= creditCards.length &&
                    creditCards.isNotEmpty) {
                  currentCardIndex = creditCards.length - 1;
                } else if (creditCards.isEmpty) {
                  currentCardIndex = 0;
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tarjeta eliminada exitosamente'),
                  backgroundColor: Colors.orange,
                ),
              );
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
