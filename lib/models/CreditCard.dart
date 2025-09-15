import 'dart:ui';

class CreditCard {
  final String id;
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final String cardType;
  final Color color;
  final String cvv;

  CreditCard({
    required this.id,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.cardType,
    required this.color,
    required this.cvv,
  });
}