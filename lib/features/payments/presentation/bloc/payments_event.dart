part of 'payments_bloc.dart';

abstract class PaymentsEvent extends Equatable {
  const PaymentsEvent();

  @override
  List<Object?> get props => [];
}

class CreatePaymentIntent extends PaymentsEvent {
  final double amount;
  final String currency;

  const CreatePaymentIntent(this.amount, this.currency);

  @override
  List<Object> get props => [amount, currency];
}

class ConfirmPayment extends PaymentsEvent {
  final String paymentIntentId;
  final String paymentMethodId;

  const ConfirmPayment(this.paymentIntentId, this.paymentMethodId);

  @override
  List<Object> get props => [paymentIntentId, paymentMethodId];
}

class ResetPaymentState extends PaymentsEvent {
  const ResetPaymentState();
}

