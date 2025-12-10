# Remote Config Service - Quick Reference

## Import
```dart
import 'package:applaa_template/core/services/remote_config_service.dart';
```

## Get Instance
```dart
final remoteConfig = RemoteConfigService();
```

## Quick Examples

### Authentication
```dart
// Check if email auth is enabled
if (remoteConfig.getEnableEmailAuth()) {
  // Show email login form
}

// Get minimum password length
final minLength = remoteConfig.getMinPasswordLength();

// Check if biometric auth is enabled
if (remoteConfig.getEnableBiometricAuth()) {
  // Show FaceID/TouchID button
}
```

### Stripe Payments
```dart
// Check if Stripe is enabled
if (remoteConfig.getEnableStripePayments()) {
  // Initialize Stripe
  await Stripe.instance.applySettings(
    publishableKey: remoteConfig.getStripePublishableKey(),
    merchantIdentifier: remoteConfig.getStripeMerchantId(),
  );
}

// Get payment limits
final minAmount = remoteConfig.getMinPaymentAmount();
final maxAmount = remoteConfig.getMaxPaymentAmount();
final currency = remoteConfig.getCurrency();
```

### Dashboard & Revenue
```dart
// Check if revenue chart should be shown
if (remoteConfig.getEnableRevenueChart()) {
  // Show chart
}

// Get refresh intervals
final chartInterval = remoteConfig.getChartUpdateInterval(); // seconds
final dashInterval = remoteConfig.getDashboardRefreshInterval(); // seconds

// Get revenue goal
if (remoteConfig.getShowRevenueGoal()) {
  final goal = remoteConfig.getMonthlyRevenueGoal();
  // Display goal widget
}
```

### App-wide Controls
```dart
// Check maintenance mode
if (remoteConfig.getAppMaintenanceMode()) {
  // Show maintenance screen (automatic with MaintenanceModeWidget)
}

// Get API base URL
final apiUrl = remoteConfig.getApiBaseUrl();

// Check feature flags
if (remoteConfig.getEnableAnalytics()) {
  // Enable analytics
}
```

### AdMob
```dart
// Check if ads are enabled
if (remoteConfig.getEnableAds()) {
  final refreshInterval = remoteConfig.getAdRefreshInterval();
  final bannerId = remoteConfig.getBannerAdUnitId();
  // Show ads
}
```

## Testing Functions

### Force Fetch (Bypass Cache)
```dart
// For testing - fetches immediately
await remoteConfig.forceFetch();
```

### Listen for Updates
```dart
// Real-time config updates
remoteConfig.onConfigUpdated.listen((update) {
  print('Updated keys: ${update.updatedKeys}');
  // Handle update
});
```

## All Available Methods

### Auth
- `getEnableEmailAuth()` → bool
- `getEnableGoogleAuth()` → bool
- `getEnableAppleAuth()` → bool
- `getEnableFacebookAuth()` → bool
- `getEnableBiometricAuth()` → bool
- `getMinPasswordLength()` → int
- `getRequireEmailVerification()` → bool

### Payments
- `getEnableStripePayments()` → bool
- `getStripePublishableKey()` → String
- `getStripeMerchantId()` → String
- `getEnableApplePay()` → bool
- `getEnableGooglePay()` → bool
- `getMinPaymentAmount()` → double
- `getMaxPaymentAmount()` → double
- `getCurrency()` → String
- `getPaymentMethods()` → String (JSON)

### Dashboard
- `getEnableRevenueChart()` → bool
- `getEnableEarningsWidget()` → bool
- `getChartUpdateInterval()` → int
- `getDashboardRefreshInterval()` → int
- `getShowRevenueGoal()` → bool
- `getMonthlyRevenueGoal()` → double
- `getEnableRealtimeUpdates()` → bool

### General
- `getAppMaintenanceMode()` → bool
- `getAppMinVersion()` → String
- `getForceUpdate()` → bool
- `getFeatureFlags()` → String (JSON)
- `getApiBaseUrl()` → String
- `getEnableAnalytics()` → bool
- `getEnableCrashReporting()` → bool

### AdMob
- `getEnableAds()` → bool
- `getAdRefreshInterval()` → int
- `getBannerAdUnitId()` → String
- `getInterstitialAdUnitId()` → String

### UI
- `getPrimaryColor()` → String (hex)
- `getEnableDarkMode()` → bool
- `getShowWelcomeScreen()` → bool

## Helpers

### Wrapper Widget for Auth
```dart
RemoteConfigAuthWrapper(
  authMethod: 'google', // 'email', 'apple', 'facebook', 'biometric'
  child: YourAuthButton(),
)
```

### Maintenance Mode Widget
```dart
MaintenanceModeWidget(
  child: YourApp(),
)
```

## Firebase Console

1. Go to Firebase Console → Remote Config
2. Add parameters (see FIREBASE_REMOTE_CONFIG_SETUP.md)
3. Set values
4. Click "Publish changes"
5. App will fetch on next launch

## Default Values

All parameters have sensible defaults defined in `_getDefaultValues()`.
App will work even if Remote Config fetch fails.

## Best Practices

✅ Always check flags before showing features
✅ Handle null/empty values gracefully  
✅ Use wrappers for conditional UI
✅ Test with force fetch during development
✅ Monitor config changes in production

❌ Don't store secrets in Remote Config
❌ Don't fetch too frequently (respect cache)
❌ Don't assume config is always available
❌ Don't hard-code sensitive data

## Need Help?

See full documentation: `FIREBASE_REMOTE_CONFIG_SETUP.md`

