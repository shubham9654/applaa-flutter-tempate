# Stripe Setup Guide

## Backend Server Required

⚠️ **Important**: Never expose your Stripe secret key in the mobile app. Payment intents must be created on your backend server.

## Backend Implementation Example (Node.js)

```javascript
const express = require('express');
const stripe = require('stripe')('sk_test_your_secret_key');

const app = express();
app.use(express.json());

// Create Payment Intent
app.post('/create-payment-intent', async (req, res) => {
  const { amount, currency } = req.body;

  try {
    const paymentIntent = await stripe.paymentIntents.create({
      amount: amount, // Amount in cents
      currency: currency,
    });

    res.json({ clientSecret: paymentIntent.client_secret });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Confirm Payment
app.post('/confirm-payment', async (req, res) => {
  const { paymentIntentId, paymentMethodId } = req.body;

  try {
    const paymentIntent = await stripe.paymentIntents.confirm({
      paymentIntentId,
      paymentMethod: paymentMethodId,
    });

    res.json(paymentIntent);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

app.listen(3000, () => console.log('Server running on port 3000'));
```

## Flutter Configuration

1. **Update App Config**
   ```dart
   // lib/core/config/app_config.dart
   static const String stripePublishableKey = 'pk_test_your_key';
   ```

2. **Update Backend URL**
   ```dart
   // lib/features/payments/data/datasources/payments_remote_datasource.dart
   const String baseUrl = 'https://your-backend-url.com/api';
   ```

## Testing

Use Stripe test cards:
- Success: `4242 4242 4242 4242`
- Decline: `4000 0000 0000 0002`
- 3D Secure: `4000 0025 0000 3155`

Any future expiry date and any CVC.

## Production

1. Replace test keys with live keys
2. Update backend URL to production
3. Implement proper error handling
4. Add webhook handlers for payment events
5. Implement proper authentication on backend

