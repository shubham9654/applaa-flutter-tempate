import '../entities/payment_entity.dart';

abstract class PaymentsRepository {
  Future<String> createPaymentIntent(double amount, String currency);
  Future<PaymentEntity> confirmPayment(String paymentIntentId, String paymentMethodId);
}

