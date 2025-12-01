import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/payment_entity.dart';

// Placeholder baseUrl - replace with your actual backend URL
const String baseUrl = 'https://your-backend-url.com/api';

abstract class PaymentsRemoteDataSource {
  Future<String> createPaymentIntent(double amount, String currency);
  Future<PaymentEntity> confirmPayment(String paymentIntentId, String paymentMethodId);
}

class PaymentsRemoteDataSourceImpl implements PaymentsRemoteDataSource {
  @override
  Future<String> createPaymentIntent(double amount, String currency) async {
    try {
      // In production, this should be done on your backend server
      // This is a simplified example - you should never expose your secret key in the app
      final response = await http.post(
        Uri.parse('$baseUrl/create-payment-intent'), // Replace with your backend URL
        headers: {
          'Content-Type': 'application/json',
          // In production, include authentication token
        },
        body: jsonEncode({
          'amount': (amount * 100).toInt(), // Convert to cents
          'currency': currency.toLowerCase(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['clientSecret'] as String;
      } else {
        throw Exception('Failed to create payment intent: ${response.body}');
      }
    } catch (e) {
      // Fallback for demo - in production, remove this
      throw Exception('Payment intent creation failed. Please configure your backend: $e');
    }
  }

  @override
  Future<PaymentEntity> confirmPayment(
    String paymentIntentId,
    String paymentMethodId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/confirm-payment'), // Replace with your backend URL
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'paymentIntentId': paymentIntentId,
          'paymentMethodId': paymentMethodId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PaymentEntity(
          id: data['id'],
          amount: (data['amount'] as int) / 100.0,
          currency: data['currency'],
          status: data['status'],
          createdAt: DateTime.parse(data['created']),
          description: data['description'],
        );
      } else {
        throw Exception('Failed to confirm payment: ${response.body}');
      }
    } catch (e) {
      throw Exception('Payment confirmation failed: $e');
    }
  }
}

