import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/config/app_config.dart';
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
    bool isAuthenticated = false;
    try {
      isAuthenticated = FirebaseAuth.instance.currentUser != null;
    } catch (e) {
      isAuthenticated = false;
    }

    // Check if PaymentsBloc is available
    bool hasPaymentsBloc = false;
    try {
      context.read<PaymentsBloc>();
      hasPaymentsBloc = true;
    } catch (e) {
      hasPaymentsBloc = false;
    }

    // If not authenticated or no bloc, show demo UI
    if (!isAuthenticated || !hasPaymentsBloc) {
      return _buildDemoPaymentsUI(context);
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

  Widget _buildDemoPaymentsUI(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Payments'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1E293B),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payment Methods Section
            const Text(
              'Payment Methods',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6C5CE7), Color(0xFF818CF8)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C5CE7).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'VISA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Primary',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    '•••• •••• •••• 4242',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CARDHOLDER',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 10,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'John Doe',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'EXPIRES',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 10,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '12/25',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Add Payment Method Button
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Add Payment Method'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                side: const BorderSide(color: Color(0xFF6C5CE7)),
                foregroundColor: const Color(0xFF6C5CE7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Recent Transactions
            const Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            _buildTransactionItem(
              title: 'Premium Subscription',
              date: 'Dec 15, 2024',
              amount: '\$9.99',
              isPositive: false,
            ),
            const SizedBox(height: 12),
            _buildTransactionItem(
              title: 'Payment Received',
              date: 'Dec 10, 2024',
              amount: '\$49.99',
              isPositive: true,
            ),
            const SizedBox(height: 12),
            _buildTransactionItem(
              title: 'App Purchase',
              date: 'Dec 5, 2024',
              amount: '\$4.99',
              isPositive: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem({
    required String title,
    required String date,
    required String amount,
    required bool isPositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (isPositive ? Colors.green : Colors.red).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isPositive ? Icons.arrow_downward : Icons.arrow_upward,
              color: isPositive ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isPositive ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
