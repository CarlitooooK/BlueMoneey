import 'package:finestra_app/features/pages/cards_screen.dart';

class Transaction {
  final String id;
  final DateTime date;
  final String description;
  final double amount;
  final TransactionType type;
  final String category;

  Transaction({
    required this.id,
    required this.date,
    required this.description,
    required this.amount,
    required this.type,
    required this.category,
  });
}
