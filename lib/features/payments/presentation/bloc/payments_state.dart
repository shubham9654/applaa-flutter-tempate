part of 'payments_bloc.dart';

abstract class PaymentsState extends Equatable {
  const PaymentsState();

  @override
  List<Object?> get props => [];
}

class PaymentsInitial extends PaymentsState {}

class PaymentsLoading extends PaymentsState {}

class PaymentIntentCreated extends PaymentsState {
  final String clientSecret;

  const PaymentIntentCreated(this.clientSecret);

  @override
  List<Object> get props => [clientSecret];
}

class PaymentConfirmed extends PaymentsState {
  final PaymentEntity payment;

  const PaymentConfirmed(this.payment);

  @override
  List<Object> get props => [payment];
}

class PaymentsError extends PaymentsState {
  final String message;

  const PaymentsError(this.message);

  @override
  List<Object> get props => [message];
}

