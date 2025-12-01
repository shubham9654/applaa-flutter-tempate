import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  final String id;
  final double amount;
  final String currency;
  final String status;
  final DateTime createdAt;
  final String? description;

  const PaymentEntity({
    required this.id,
    required this.amount,
    required this.currency,
    required this.status,
    required this.createdAt,
    this.description,
  });

  @override
  List<Object?> get props => [id, amount, currency, status, createdAt, description];
}

