import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payments_repository.dart';

part 'payments_event.dart';
part 'payments_state.dart';

class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  final PaymentsRepository paymentsRepository;

  PaymentsBloc(this.paymentsRepository) : super(PaymentsInitial()) {
    on<CreatePaymentIntent>(_onCreatePaymentIntent);
    on<ConfirmPayment>(_onConfirmPayment);
    on<ResetPaymentState>(_onResetPaymentState);
  }

  Future<void> _onCreatePaymentIntent(
    CreatePaymentIntent event,
    Emitter<PaymentsState> emit,
  ) async {
    emit(PaymentsLoading());
    try {
      final clientSecret = await paymentsRepository.createPaymentIntent(
        event.amount,
        event.currency,
      );
      emit(PaymentIntentCreated(clientSecret));
    } catch (e) {
      emit(PaymentsError(e.toString()));
    }
  }

  Future<void> _onConfirmPayment(
    ConfirmPayment event,
    Emitter<PaymentsState> emit,
  ) async {
    emit(PaymentsLoading());
    try {
      final payment = await paymentsRepository.confirmPayment(
        event.paymentIntentId,
        event.paymentMethodId,
      );
      emit(PaymentConfirmed(payment));
    } catch (e) {
      emit(PaymentsError(e.toString()));
    }
  }

  void _onResetPaymentState(
    ResetPaymentState event,
    Emitter<PaymentsState> emit,
  ) {
    emit(PaymentsInitial());
  }
}

