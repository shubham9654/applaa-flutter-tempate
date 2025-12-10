# 🚀 Quick Start: Firebase Remote Config

## ⚡ 5-Minute Setup

### Step 1: Firebase Console (2 minutes)

1. **Open Firebase Console**
   ```
   https://console.firebase.google.com/
   ```

2. **Navigate to Remote Config**
   - Click your project name
   - Left sidebar → **Remote Config** (under "Engage")
   - Click **Create configuration** or **Get started**

3. **Add Your First Parameter**
   - Click **Add parameter**
   - Parameter key: `enable_email_auth`
   - Data type: **Boolean**
   - Default value: **true**
   - Click **Add parameter**

4. **Publish**
   - Click **Publish changes** (top right)
   - Click **Publish** to confirm

✅ Done! Remote Config is now active.

---

## 🧪 Test It Works (3 minutes)

### Option A: Use the Test Page

1. **Add test route** to `lib/core/router/app_router.dart`:

```dart
import '../../test_remote_config.dart'; // Add this import

// Add this route to your routes list:
GoRoute(
  path: '/test-remote-config',
  name: 'test_remote_config',
  builder: (context, state) => const RemoteConfigTestPage(),
),
```

2. **Navigate to test page** in your app:
   ```dart
   context.go('/test-remote-config');
   ```

3. **View all config values** - you should see:
   - ✅ Email Auth Enabled: true
   - ✅ Google Auth Enabled: true
   - ✅ Min Password Length: 6
   - etc.

### Option B: Quick Console Test

Run in your app anywhere:

```dart
final remoteConfig = RemoteConfigService();
print('Email Auth: ${remoteConfig.getEnableEmailAuth()}');
print('Stripe Enabled: ${remoteConfig.getEnableStripePayments()}');
print('Maintenance Mode: ${remoteConfig.getAppMaintenanceMode()}');
```

---

## 🎯 Try These Features

### 1. Toggle Login Methods (30 seconds)

**Test: Disable Google Sign-In**

1. Firebase Console → Remote Config
2. Find `enable_google_auth`
3. Change value to **false**
4. Click **Publish changes**
5. In your app, click **"Force Fetch Config"** button (or restart)
6. ✨ Google Sign-In button should disappear!

### 2. Maintenance Mode (30 seconds)

**Test: Put app in maintenance**

1. Firebase Console → Remote Config
2. Find or add `app_maintenance_mode`
3. Change value to **true**
4. Click **Publish changes**
5. In your app, force fetch or restart
6. 🚧 App shows maintenance screen!

### 3. Change Payment Settings (30 seconds)

1. Firebase Console → Remote Config
2. Find `min_payment_amount`
3. Change from `1.0` to `10.0`
4. Publish changes
5. Your payment flow now enforces $10 minimum!

---

## 📝 Recommended Parameters to Add

Start with these essential parameters:

### ✅ Must Have (Add First)
```
enable_email_auth = true (Boolean)
enable_google_auth = true (Boolean)
app_maintenance_mode = false (Boolean)
min_password_length = 6 (Number)
```

### 💳 For Payments
```
enable_stripe_payments = true (Boolean)
stripe_publishable_key = "" (String) - Add your key
min_payment_amount = 1.0 (Number)
max_payment_amount = 10000.0 (Number)
currency = "USD" (String)
```

### 📊 For Dashboard
```
enable_revenue_chart = true (Boolean)
monthly_revenue_goal = 10000.0 (Number)
dashboard_refresh_interval = 60 (Number)
```

---

## 🎨 How to Use in Your Code

### Check if Feature is Enabled

```dart
final remoteConfig = RemoteConfigService();

// Before showing a feature
if (remoteConfig.getEnableRevenueChart()) {
  // Show revenue chart
  return RevenueChart();
}

// Before initializing Stripe
if (remoteConfig.getEnableStripePayments()) {
  final key = remoteConfig.getStripePublishableKey();
  await Stripe.instance.applySettings(publishableKey: key);
}
```

### Wrap Auth Buttons

```dart
// Email Login - only shows if enabled
RemoteConfigAuthWrapper(
  authMethod: 'email',
  child: EmailLoginForm(),
)

// Google Sign-In - only shows if enabled
RemoteConfigAuthWrapper(
  authMethod: 'google',
  child: GoogleSignInButton(),
)

// Biometric Auth - only shows if enabled
RemoteConfigAuthWrapper(
  authMethod: 'biometric',
  child: BiometricLoginButton(),
)
```

### Get Configuration Values

```dart
final remoteConfig = RemoteConfigService();

// Get boolean
bool isEnabled = remoteConfig.getEnableEmailAuth();

// Get number
int minLength = remoteConfig.getMinPasswordLength();
double minAmount = remoteConfig.getMinPaymentAmount();

// Get string
String currency = remoteConfig.getCurrency();
String apiUrl = remoteConfig.getApiBaseUrl();
```

---

## 🔧 Troubleshooting

### Config Not Updating?

1. **Check cache interval**
   ```dart
   // For testing, force immediate fetch:
   await remoteConfig.forceFetch();
   ```

2. **Verify Firebase project**
   - Make sure you're in the correct Firebase project
   - Check that config is **published** (not just saved)

3. **Check internet connection**
   - Remote Config requires network
   - Falls back to cached/default values offline

### Values Not Showing?

1. **Check initialization**
   ```dart
   // main.dart should have:
   await RemoteConfigService().initialize();
   ```

2. **Check default values**
   - All parameters have defaults in `remote_config_service.dart`
   - App works even if fetch fails

### Button Still Showing After Disable?

1. **Make sure you're using the wrapper**
   ```dart
   // Correct ✅
   RemoteConfigAuthWrapper(
     authMethod: 'google',
     child: GoogleButton(),
   )
   
   // Wrong ❌ - button always shows
   GoogleButton()
   ```

2. **Force refresh UI**
   ```dart
   setState(() {}); // After force fetch
   ```

---

## 📚 Full Documentation

For complete parameter list and advanced features, see:
- 📖 [Complete Setup Guide](FIREBASE_REMOTE_CONFIG_SETUP.md)
- 📋 [Integration Summary](FIREBASE_REMOTE_CONFIG_INTEGRATION.md)
- 🚀 [Quick Reference](REMOTE_CONFIG_QUICK_REFERENCE.md)

---

## ✅ Checklist

- [ ] Accessed Firebase Console
- [ ] Added at least 3 parameters
- [ ] Published configuration
- [ ] Tested in app (saw values)
- [ ] Tried toggling a feature
- [ ] Tested maintenance mode
- [ ] Wrapped auth buttons

**All done?** You're ready to control your app remotely! 🎉

---

## 🆘 Need Help?

**Can't find Remote Config in Firebase Console?**
- Make sure Firebase is set up for your project
- Remote Config is under "Engage" section in left sidebar

**App crashes when fetching config?**
- Check Firebase is initialized in `main.dart`
- Verify internet permissions in Android/iOS

**Config working but UI not updating?**
- Call `setState()` after force fetch
- Use `BlocBuilder` or state management for auto-refresh

---

**Pro Tip:** Use conditions in Firebase Console to target specific users:
- **User in random percentile** → A/B testing
- **App version** → Different config per version
- **Country** → Regional features

Start with simple true/false toggles and expand from there! 🚀

