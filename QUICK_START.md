# Quick Start Guide

## Prerequisites

- Flutter SDK (3.5.4+)
- Dart 3.5.4+
- Android Studio / Xcode (for mobile development)
- Firebase account
- Stripe account (for payments)
- AdMob account (for ads)

## Setup Steps

### 1. Clone and Install

```bash
cd applaa_template
flutter pub get
```

### 2. Firebase Configuration

1. Create a Firebase project
2. Add Android app → Download `google-services.json` → Place in `android/app/`
3. Add iOS app → Download `GoogleService-Info.plist` → Place in `ios/Runner/`
4. Enable Authentication (Email/Password)
5. Enable Firestore Database
6. Enable Cloud Messaging

See `FIREBASE_SETUP.md` for detailed instructions.

### 3. Update Configuration

Edit `lib/core/config/app_config.dart`:

```dart
// Stripe
static const String stripePublishableKey = 'pk_test_your_key';

// AdMob (use test IDs for development)
static const String admobAppId = 'ca-app-pub-3940256099942544~3347511713';
static const String admobBannerId = 'ca-app-pub-3940256099942544/6300978111';
static const String admobInterstitialId = 'ca-app-pub-3940256099942544/1033173712';
```

### 4. Backend Setup (Required for Payments)

Set up a backend server to create Stripe payment intents. See `STRIPE_SETUP.md` for details.

Update `lib/features/payments/data/datasources/payments_remote_datasource.dart`:

```dart
const String baseUrl = 'https://your-backend-url.com/api';
```

### 5. Run the App

```bash
flutter run
```

## Project Structure

```
lib/
├── core/              # Core functionality
│   ├── config/        # App configuration
│   ├── constants/     # Constants
│   ├── di/            # Dependency injection
│   ├── router/        # Navigation
│   ├── services/      # Core services
│   └── theme/         # Theme configuration
└── features/          # Feature modules
    ├── auth/          # Authentication
    ├── profile/       # User profile
    ├── settings/      # App settings
    ├── payments/      # Stripe payments
    ├── dashboard/     # Revenue dashboard
    ├── notifications/ # Notifications
    ├── splash/        # Splash screen
    └── home/          # Home with bottom nav
```

## Key Features

✅ **Authentication** - Email/Password with Firebase  
✅ **Profile Management** - View and edit user profile  
✅ **Settings** - Theme toggle, notifications, preferences  
✅ **Payments** - Stripe integration with card input  
✅ **Dashboard** - Revenue analytics with charts  
✅ **Notifications** - FCM + Local notifications  
✅ **Ads** - AdMob banner and interstitial ads  
✅ **Responsive** - Works on Android, iOS, and Web  

## Next Steps

1. Configure Firebase for your platforms
2. Set up Stripe backend server
3. Replace test AdMob IDs with your own
4. Customize theme and branding
5. Add your business logic
6. Test thoroughly before production

## Documentation

- `README.md` - Full documentation
- `FIREBASE_SETUP.md` - Firebase configuration
- `STRIPE_SETUP.md` - Stripe payment setup
- `ADMOB_SETUP.md` - AdMob configuration

## Support

For issues or questions:
- Check the documentation files
- Review Flutter/Firebase/Stripe/AdMob official docs
- Ensure all configuration files are properly set up

