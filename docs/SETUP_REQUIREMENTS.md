# Setup Requirements

This document outlines all setup requirements for the Applaa Flutter Template.

## Required Setups

### 1. Firebase (Required for Authentication & Profile)

**Status**: Required for full functionality

**Features that require Firebase:**
- User Authentication (Sign In/Sign Up)
- User Profile Management
- Push Notifications
- Cloud Firestore Database

**Platform Support**: ✅ Android, iOS, Web

**Setup Guide**: See [FIREBASE_SETUP.md](FIREBASE_SETUP.md)

**Configuration Files:**
- Android: `android/app/google-services.json`
- iOS: `ios/Runner/GoogleService-Info.plist`
- Web: `web/index.html` (Firebase config script)

**Environment Variables** (Optional - can use config files):
```env
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_API_KEY=your-firebase-api-key
FIREBASE_AUTH_DOMAIN=your-project.firebaseapp.com
```

**Note**: App works in guest mode without Firebase, but authentication features will be disabled.

---

### 2. Stripe (Required for Payments)

**Status**: Required for payment processing

**Features that require Stripe:**
- Payment processing
- Payment method management
- Transaction history

**Platform Support**: ✅ Android, iOS, Web

**Setup Guide**: See [STRIPE.md](STRIPE.md)

**Configuration**:
- Update `lib/core/config/app_config.dart`:
  ```dart
  static const String stripePublishableKey = 'pk_test_your_key';
  static const String stripeSecretKey = 'sk_test_your_key';
  ```

**Environment Variables**:
```env
STRIPE_PUBLISHABLE_KEY=pk_test_your_publishable_key_here
STRIPE_SECRET_KEY=sk_test_your_secret_key_here
```

**Backend Required**: Yes - Payment intents must be created on your backend server for security.

**Note**: Test keys are included by default. Replace with production keys before deploying.

---

### 3. AdMob (Optional - For Ads)

**Status**: Optional

**Features that require AdMob:**
- Banner ads
- Interstitial ads
- Ad revenue

**Platform Support**: ✅ Android, iOS | ❌ Web (Not Supported)

**Setup Guide**: See [ADMOB_SETUP.md](ADMOB_SETUP.md)

**Configuration**:
- Update `lib/core/config/app_config.dart`:
  ```dart
  static const String admobAppId = 'ca-app-pub-xxxxx';
  static const String admobBannerId = 'ca-app-pub-xxxxx';
  static const String admobInterstitialId = 'ca-app-pub-xxxxx';
  ```

**Environment Variables**:
```env
ADMOB_APP_ID=ca-app-pub-xxxxx
ADMOB_BANNER_ID=ca-app-pub-xxxxx
ADMOB_INTERSTITIAL_ID=ca-app-pub-xxxxx
```

**Platform-Specific Setup**:
- **Android**: Add App ID to `android/app/src/main/AndroidManifest.xml`
- **iOS**: Add App ID to `ios/Runner/Info.plist`

**Note**: Test ad IDs are included by default. AdMob does NOT work on web platform.

---

## Platform-Specific Features

### Android Only
- ✅ AdMob (Full support)
- ✅ Push Notifications (FCM)
- ✅ Local Notifications

### iOS Only
- ✅ AdMob (Full support)
- ✅ Push Notifications (APNs via FCM)
- ✅ Local Notifications

### Web Only
- ✅ Firebase Authentication
- ✅ Stripe Payments
- ❌ AdMob (Not supported)
- ❌ Push Notifications (Limited support)

---

## Quick Setup Checklist

### Minimum Setup (Guest Mode)
- [ ] No setup required - app works in guest mode
- [ ] Can browse Dashboard and Settings
- [ ] Profile and Payments require sign-in

### Basic Setup (Authentication)
- [ ] Configure Firebase (see FIREBASE_SETUP.md)
- [ ] Add `google-services.json` (Android)
- [ ] Add `GoogleService-Info.plist` (iOS)
- [ ] Configure Firebase for Web (if needed)

### Full Setup (All Features)
- [ ] Configure Firebase ✅
- [ ] Configure Stripe ✅
- [ ] Configure AdMob (Android/iOS only) ✅
- [ ] Set up backend server for Stripe ✅
- [ ] Update environment variables ✅
- [ ] Replace test keys with production keys ✅

---

## Environment Variables

Copy `.env.example` to `.env` and fill in your values:

```bash
cp .env.example .env
```

See `.env.example` for all available configuration options.

---

## Production Readiness Checklist

Before deploying to production:

- [ ] Replace all test keys with production keys
- [ ] Configure Firebase production project
- [ ] Set up Stripe production account
- [ ] Configure AdMob production ad units
- [ ] Set up backend server for Stripe
- [ ] Update API base URLs to production
- [ ] Test all features on target platforms
- [ ] Review and update app configuration
- [ ] Set up error logging and monitoring
- [ ] Configure analytics (if needed)
- [ ] Review privacy policy and terms
- [ ] Test payment flows thoroughly
- [ ] Verify ad placement compliance

---

## Troubleshooting

### Firebase Not Working
- Check if `google-services.json` is in correct location
- Verify Firebase project configuration
- Check internet connection
- Review Firebase console for errors

### Stripe Not Working
- Verify publishable key is correct
- Check backend server is running
- Verify API endpoints are correct
- Check network connectivity

### AdMob Not Working
- Verify you're not on web platform
- Check AdMob App ID in manifest/plist
- Verify ad unit IDs are correct
- Check AdMob account status
- Review AdMob policies compliance

---

## Support

For detailed setup instructions, refer to:
- [FIREBASE_SETUP.md](FIREBASE_SETUP.md) - Firebase configuration
- [STRIPE.md](STRIPE.md) - Stripe payment setup
- [ADMOB_SETUP.md](ADMOB_SETUP.md) - AdMob ad setup
- [README.md](README.md) - General project information

