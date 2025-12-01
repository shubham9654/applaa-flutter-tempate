import '../../domain/repositories/payments_repository.dart';
import '../../domain/entities/payment_entity.dart';
import '../datasources/payments_remote_datasource.dart';

class PaymentsRepositoryImpl implements PaymentsRepository {
  final PaymentsRemoteDataSource remoteDataSource;

  PaymentsRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> createPaymentIntent(double amount, String currency) {
    return remoteDataSource.createPaymentIntent(amount, currency);
  }

  @override
  Future<PaymentEntity> confirmPayment(String paymentIntentId, String paymentMethodId) {
    return remoteDataSource.confirmPayment(paymentIntentId, paymentMethodId);
  }
}

