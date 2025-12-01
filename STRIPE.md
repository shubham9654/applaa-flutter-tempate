# Stripe Integration Guide

Complete guide for setting up and troubleshooting Stripe payments in this Flutter app.

## Setup Instructions

### 1. Get Your Stripe Keys

1. Create a Stripe account at [Stripe](https://stripe.com/)
2. Go to [Stripe Dashboard > Developers > API keys](https://dashboard.stripe.com/apikeys)
3. Copy your **Publishable key** (starts with `pk_test_` or `pk_live_`)
4. Copy your **Secret key** (starts with `sk_test_` or `sk_live_`)

### 2. Configure Environment Variables

Add your Stripe keys to `.env` file:

```env
STRIPE_PUBLISHABLE_KEY=pk_test_your_publishable_key_here
STRIPE_SECRET_KEY=sk_test_your_secret_key_here
STRIPE_API_URL=https://api.stripe.com/v1
```

### 3. Backend Server Setup

⚠️ **Important**: Never expose your Stripe secret key in the mobile app. Payment intents must be created on your backend server.

#### Backend Implementation Example (Node.js)

```javascript
const express = require('express');
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);

const app = express();
app.use(express.json());

// Create Payment Intent
app.post('/create-payment-intent', async (req, res) => {
  const { amount, currency } = req.body;

  try {
    const paymentIntent = await stripe.paymentIntents.create({
      amount: amount, // Amount in cents
      currency: currency || 'usd',
    });

    res.json({ clientSecret: paymentIntent.client_secret });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

app.listen(3000, () => console.log('Server running on port 3000'));
```

### 4. Update Flutter Configuration

Update `lib/core/config/app_config.dart` or use environment variables:

```dart
static const String stripePublishableKey = 'pk_test_your_key';
static const String baseUrl = 'https://your-backend-url.com/api';
```

### 5. Update Backend URL

Update the API base URL in your `.env` file:

```env
API_BASE_URL=https://your-backend-url.com/api
```

## Testing

Use Stripe test cards:

- **Success**: `4242 4242 4242 4242`
- **Decline**: `4000 0000 0000 0002`
- **3D Secure**: `4000 0025 0000 3155`

Use any future expiry date (e.g., 12/25) and any 3-digit CVC (e.g., 123).

## Troubleshooting

### Color Property Error

If you encounter errors like:
```
Error: The getter 'r' isn't defined for the class 'Color'.
Error: The getter 'g' isn't defined for the class 'Color'.
```

This is a known bug in `stripe_platform_interface` version 11.5.0.

#### Fix Method

Edit the file:
`%LOCALAPPDATA%\Pub\Cache\hosted\pub.dev\stripe_platform_interface-11.5.0\lib\src\models\color.dart`

Change the `ColorX` extension from:
```dart
extension ColorX on Color {
  String get colorHexString {
    final red = (r * 255).toInt().toRadixString(16).padLeft(2, '0');
    final green = (g * 255).toInt().toRadixString(16).padLeft(2, '0');
    final blue = (b * 255).toInt().toRadixString(16).padLeft(2, '0');
    final alpha = (a * 255).toInt().toRadixString(16).padLeft(2, '0');
    return '$alpha$red$green$blue';
  }
}
```

To:
```dart
extension ColorX on Color {
  String get colorHexString {
    final redStr = red.toRadixString(16).padLeft(2, '0');
    final greenStr = green.toRadixString(16).padLeft(2, '0');
    final blueStr = blue.toRadixString(16).padLeft(2, '0');
    final alphaStr = alpha.toRadixString(16).padLeft(2, '0');
    return '$alphaStr$redStr$greenStr$blueStr';
  }
}
```

## Production Checklist

Before deploying to production:

- [ ] Replace test keys with live keys in `.env`
- [ ] Update backend URL to production endpoint
- [ ] Implement proper error handling
- [ ] Add webhook handlers for payment events
- [ ] Implement proper authentication on backend
- [ ] Test with real payment methods
- [ ] Set up Stripe webhooks for payment status updates
- [ ] Configure proper error logging and monitoring

## Additional Resources

- [Stripe Documentation](https://stripe.com/docs)
- [Stripe Flutter SDK](https://pub.dev/packages/flutter_stripe)
- [Stripe Testing](https://stripe.com/docs/testing)

