import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/widgets/auth_required_widget.dart';
import '../../../../core/widgets/setup_warning_widget.dart';
import '../../../../core/utils/setup_checker.dart';
import '../bloc/payments_bloc.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _cardController = stripe.CardFormEditController();

  @override
  void initState() {
    super.initState();
    stripe.Stripe.publishableKey = AppConfig.stripePublishableKey;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  Future<void> _handlePayment() async {
    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(_amountController.text);
      if (amount == null || amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid amount')),
        );
        return;
      }

      try {
        // Create payment intent
        context.read<PaymentsBloc>().add(
              CreatePaymentIntent(amount, 'usd'),
            );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if user is authenticated
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Show sign-in prompt for guest users
        return const AuthRequiredWidget(
          title: 'Sign In Required',
          message: 'Please sign in to make payments and manage your payment methods.',
          icon: Icons.payment_outlined,
        );
      }
    } catch (e) {
      // Firebase not initialized, show sign-in prompt
      return const AuthRequiredWidget(
        title: 'Sign In Required',
        message: 'Please sign in to make payments and manage your payment methods.',
        icon: Icons.payment_outlined,
      );
    }

    // Check if PaymentsBloc is available
    try {
      context.read<PaymentsBloc>();
    } catch (e) {
      return Scaffold(
        appBar: AppBar(title: const Text('Payments')),
        body: const Center(
          child: Text('Payments feature is not available.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
      ),
      body: BlocConsumer<PaymentsBloc, PaymentsState>(
        listener: (context, state) {
          if (state is PaymentIntentCreated) {
            _processPayment(state.clientSecret);
          } else if (state is PaymentConfirmed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Payment successful: \$${state.payment.amount}'),
              ),
            );
            try {
              context.read<PaymentsBloc>().add(const ResetPaymentState());
            } catch (e) {
              debugPrint('PaymentsBloc not available: $e');
            }
            _amountController.clear();
          } else if (state is PaymentsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          // Check Stripe setup
          final stripeSetup = SetupChecker.checkStripe();
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Stripe setup warning
                  if (stripeSetup.status != SetupStatus.configured)
                    SetupWarningWidget(requirement: stripeSetup),
                  if (stripeSetup.status != SetupStatus.configured)
                    const SizedBox(height: 16),
                  Material(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Payment Amount',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Amount (USD)',
                                prefixText: '\$',
                                prefixIcon: Icon(Icons.attach_money),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an amount';
                                }
                                final amount = double.tryParse(value);
                                if (amount == null || amount <= 0) {
                                  return 'Please enter a valid amount';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Material(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Card Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            stripe.CardFormField(
                              controller: _cardController,
                              style: stripe.CardFormStyle(
                                borderColor: Colors.grey,
                                borderRadius: 12,
                                borderWidth: 1,
                                textColor: Colors.black,
                                placeholderColor: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: state is PaymentsLoading ? null : _handlePayment,
                    child: state is PaymentsLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Process Payment'),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Note: This is a demo. Configure your backend server to handle payment intents.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _processPayment(String clientSecret) async {
    try {
      // Collect card details
      await stripe.Stripe.instance.createPaymentMethod(
        params: const stripe.PaymentMethodParams.card(
          paymentMethodData: stripe.PaymentMethodData(
            billingDetails: stripe.BillingDetails(),
          ),
        ),
      );

      // Confirm payment
      await stripe.Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: const stripe.PaymentMethodParams.card(
          paymentMethodData: stripe.PaymentMethodData(
            billingDetails: stripe.BillingDetails(),
          ),
        ),
      );

      // Payment successful - the listener will handle the state update
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: $e')),
        );
      }
    }
  }
}
