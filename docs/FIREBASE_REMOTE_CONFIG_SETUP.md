# Firebase Remote Config Setup Guide

This guide explains how to set up and use Firebase Remote Config in your Applaa Flutter app.

## Table of Contents
1. [Overview](#overview)
2. [Firebase Console Setup](#firebase-console-setup)
3. [Configuration Keys](#configuration-keys)
4. [Usage Examples](#usage-examples)
5. [Testing](#testing)

## Overview

Firebase Remote Config allows you to change the behavior and appearance of your app without publishing an app update. This implementation includes:

- **Auth Controls**: Enable/disable authentication methods
- **Payment Settings**: Configure Stripe integration
- **Dashboard & Revenue**: Control analytics features
- **App Behavior**: Maintenance mode, force updates
- **UI Customization**: Theme colors, feature flags

## Firebase Console Setup

### Step 1: Enable Remote Config

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Navigate to **Remote Config** in the left sidebar
4. Click **Create configuration**

### Step 2: Add Configuration Parameters

Add the following parameters in Firebase Console:

#### Authentication Parameters

| Parameter Key | Type | Default Value | Description |
|--------------|------|---------------|-------------|
| `enable_email_auth` | Boolean | `true` | Enable/disable email authentication |
| `enable_google_auth` | Boolean | `true` | Enable/disable Google Sign-In |
| `enable_apple_auth` | Boolean | `true` | Enable/disable Apple Sign-In |
| `enable_facebook_auth` | Boolean | `true` | Enable/disable Facebook Login |
| `enable_biometric_auth` | Boolean | `true` | Enable/disable biometric authentication |
| `min_password_length` | Number | `6` | Minimum password length |
| `require_email_verification` | Boolean | `false` | Require email verification after signup |

#### Stripe Payment Parameters

| Parameter Key | Type | Default Value | Description |
|--------------|------|---------------|-------------|
| `enable_stripe_payments` | Boolean | `true` | Enable/disable Stripe payments |
| `stripe_publishable_key` | String | `""` | Stripe publishable key |
| `stripe_merchant_id` | String | `""` | Stripe merchant identifier |
| `enable_apple_pay` | Boolean | `true` | Enable Apple Pay |
| `enable_google_pay` | Boolean | `true` | Enable Google Pay |
| `min_payment_amount` | Number | `1.0` | Minimum payment amount |
| `max_payment_amount` | Number | `10000.0` | Maximum payment amount |
| `currency` | String | `"USD"` | Currency code |
| `payment_methods` | JSON | `["card", "apple_pay", "google_pay"]` | Available payment methods |

#### Dashboard & Revenue Parameters

| Parameter Key | Type | Default Value | Description |
|--------------|------|---------------|-------------|
| `enable_revenue_chart` | Boolean | `true` | Show revenue chart on dashboard |
| `enable_earnings_widget` | Boolean | `true` | Show earnings widget |
| `chart_update_interval` | Number | `300` | Chart update interval (seconds) |
| `dashboard_refresh_interval` | Number | `60` | Dashboard refresh interval (seconds) |
| `show_revenue_goal` | Boolean | `true` | Display revenue goal |
| `monthly_revenue_goal` | Number | `10000.0` | Monthly revenue target |
| `enable_realtime_updates` | Boolean | `true` | Enable real-time data updates |

#### General App Parameters

| Parameter Key | Type | Default Value | Description |
|--------------|------|---------------|-------------|
| `app_maintenance_mode` | Boolean | `false` | Put app in maintenance mode |
| `app_min_version` | String | `"1.0.0"` | Minimum required app version |
| `force_update` | Boolean | `false` | Force users to update |
| `feature_flags` | JSON | `{}` | Custom feature flags object |
| `api_base_url` | String | `"https://api.applaa.com"` | API base URL |
| `enable_analytics` | Boolean | `true` | Enable analytics tracking |
| `enable_crash_reporting` | Boolean | `true` | Enable crash reporting |

#### AdMob Parameters

| Parameter Key | Type | Default Value | Description |
|--------------|------|---------------|-------------|
| `enable_ads` | Boolean | `true` | Enable/disable ads |
| `ad_refresh_interval` | Number | `60` | Ad refresh interval (seconds) |
| `banner_ad_unit_id` | String | `""` | Banner ad unit ID |
| `interstitial_ad_unit_id` | String | `""` | Interstitial ad unit ID |

#### UI Customization Parameters

| Parameter Key | Type | Default Value | Description |
|--------------|------|---------------|-------------|
| `primary_color` | String | `"#6C5CE7"` | App primary color (hex) |
| `enable_dark_mode` | Boolean | `true` | Allow dark mode |
| `show_welcome_screen` | Boolean | `true` | Show welcome screen on first launch |

### Step 3: Publish Configuration

1. Click **Publish changes** in Firebase Console
2. Your app will fetch these values on next launch

## Configuration Keys

All configuration keys are defined as constants in `RemoteConfigService`:

```dart
// Access in your code
final remoteConfig = RemoteConfigService();

// Auth
bool emailEnabled = remoteConfig.getEnableEmailAuth();
int minPasswordLength = remoteConfig.getMinPasswordLength();

// Payments
bool stripeEnabled = remoteConfig.getEnableStripePayments();
String stripeKey = remoteConfig.getStripePublishableKey();

// Dashboard
bool showChart = remoteConfig.getEnableRevenueChart();
double revenueGoal = remoteConfig.getMonthlyRevenueGoal();

// General
bool maintenanceMode = remoteConfig.getAppMaintenanceMode();
String apiUrl = remoteConfig.getApiBaseUrl();
```

## Usage Examples

### 1. Conditionally Show Auth Methods

The login/signup pages already include wrappers:

```dart
// Google Sign-In button - only shows if enabled
RemoteConfigAuthWrapper(
  authMethod: 'google',
  child: GoogleSignInButton(),
)

// Biometric authentication
RemoteConfigAuthWrapper(
  authMethod: 'biometric',
  child: BiometricLoginButton(),
)
```

### 2. Configure Stripe Payments

```dart
final remoteConfig = RemoteConfigService();

if (remoteConfig.getEnableStripePayments()) {
  final publishableKey = remoteConfig.getStripePublishableKey();
  await Stripe.instance.applySettings(
    publishableKey: publishableKey,
    merchantIdentifier: remoteConfig.getStripeMerchantId(),
    applePay: remoteConfig.getEnableApplePay(),
    googlePay: remoteConfig.getEnableGooglePay(),
  );
}
```

### 3. Show/Hide Dashboard Features

```dart
// In dashboard
if (remoteConfig.getEnableRevenueChart()) {
  RevenueChart(
    updateInterval: Duration(
      seconds: remoteConfig.getChartUpdateInterval(),
    ),
  );
}

if (remoteConfig.getShowRevenueGoal()) {
  RevenueGoalWidget(
    goal: remoteConfig.getMonthlyRevenueGoal(),
  );
}
```

### 4. Maintenance Mode

Wrap your app in `MaintenanceModeWidget`:

```dart
return MaintenanceModeWidget(
  child: MaterialApp(
    // Your app
  ),
);
```

### 5. Real-time Config Updates

Listen for config changes:

```dart
RemoteConfigService().onConfigUpdated.listen((update) {
  // Config was updated
  print('Updated keys: ${update.updatedKeys}');
  // Refresh UI or trigger actions
});
```

### 6. Force Fetch (Testing)

```dart
// Force fetch latest values (bypasses cache)
await RemoteConfigService().forceFetch();
```

## Testing

### Local Testing

1. **Change fetch interval** for testing:
```dart
await _remoteConfig.setConfigSettings(RemoteConfigSettings(
  fetchTimeout: const Duration(seconds: 10),
  minimumFetchInterval: Duration.zero, // Fetch immediately
));
```

2. **Test maintenance mode**:
   - Set `app_maintenance_mode` to `true` in Firebase Console
   - Publish changes
   - Force fetch in app
   - App should show maintenance screen

3. **Test auth toggles**:
   - Disable `enable_google_auth` in Firebase Console
   - Publish and force fetch
   - Google Sign-In button should disappear

### A/B Testing

Use Remote Config conditions for A/B testing:

1. In Firebase Console, click **Add condition**
2. Set conditions (e.g., 50% of users)
3. Assign different values to each group
4. Track engagement/conversion metrics

### Debugging

Enable debug logging:

```dart
final remoteConfig = RemoteConfigService();
// Check current values in logs
await remoteConfig.forceFetch(); // Logs all current values
```

## Best Practices

1. **Always provide defaults**: Set sensible defaults in `_getDefaultValues()`
2. **Cache duration**: Use appropriate `minimumFetchInterval` (1-12 hours for production)
3. **Gradual rollout**: Test with small user percentage first
4. **Monitor metrics**: Track how config changes affect user behavior
5. **Version control**: Document config changes in git
6. **Fallback handling**: App should work even if Remote Config fails

## Conditional User Targeting

In Firebase Console, you can target specific users:

- **User in random percentile**: A/B testing
- **User property**: Target by country, language, etc.
- **App version**: Different config for different versions
- **Platform**: iOS vs Android specific settings

Example condition:
```
User property 'country' equals 'US'
AND App version >= '2.0.0'
```

## Security Notes

1. **Never store secrets**: Don't put API keys, passwords, or secrets in Remote Config
2. **Use for client-side only**: Server-side configs should use different methods
3. **Validate values**: Always validate fetched values before using them
4. **Rate limiting**: Remote Config has quotas, don't fetch too frequently

## Troubleshooting

### Config not updating?

1. Check fetch interval hasn't passed
2. Verify Firebase project is correct
3. Check internet connection
4. Use `forceFetch()` to bypass cache
5. Verify config is published in Firebase Console

### App crashes after config change?

1. Check default values are set
2. Validate config values before using
3. Add try-catch around config-dependent code
4. Test config changes in staging first

## Resources

- [Firebase Remote Config Documentation](https://firebase.google.com/docs/remote-config)
- [FlutterFire Remote Config Plugin](https://firebase.flutter.dev/docs/remote-config/overview/)
- [Best Practices Guide](https://firebase.google.com/docs/remote-config/best-practices)

---

**Need Help?** Check the [Firebase Console](https://console.firebase.google.com/) or contact the development team.

