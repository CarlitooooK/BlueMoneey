import 'package:finestra_app/features/pages/cards_screen.dart';
import 'package:finestra_app/models/transaction_model.dart';

class ExtendedCardData {
  DateTime? cutoffDate;
  DateTime? paymentDate;
  double currentBalance;
  double? spendingLimit; // Solo para tarjetas de crédito
  double? creditLimit; // Solo para tarjetas de crédito
  List<Transaction> transactions;
  CardType cardType;
  bool isActive;
  double cashbackPercentage;

  ExtendedCardData({
    this.cutoffDate,
    this.paymentDate,
    required this.currentBalance,
    this.spendingLimit,
    this.creditLimit,
    required this.transactions,
    required this.cardType,
    this.isActive = true,
    this.cashbackPercentage = 0.0,
  });
}
