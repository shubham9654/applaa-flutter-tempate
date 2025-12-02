# Applaa Flutter Template - Complete Guide

This is a production-ready Flutter template designed to be used as a base for multiple projects.

## 🎯 Template Features

### Core Architecture
- ✅ **Clean Architecture** - Separated into Data/Domain/Presentation layers
- ✅ **BLoC State Management** - Consistent state management across all features
- ✅ **Dependency Injection** - Using GetIt for service locator pattern
- ✅ **Navigation** - go_router with route guards and nested navigation
- ✅ **Error Handling** - Comprehensive error handling throughout

### Features Included
- ✅ **Authentication** - Firebase Auth with guest mode support
- ✅ **User Profile** - Profile management with Firebase
- ✅ **Payments** - Stripe integration with backend support
- ✅ **Dashboard** - Revenue analytics with charts
- ✅ **Notifications** - FCM + Local notifications
- ✅ **Settings** - Theme, language, preferences
- ✅ **AdMob** - Banner and interstitial ads (Android/iOS only)

### Platform Support
- ✅ **Android** - Full feature support
- ✅ **iOS** - Full feature support
- ✅ **Web** - Limited support (no AdMob, limited notifications)

---

## 🚀 Quick Start

1. **Clone or copy this template**
   ```bash
   git clone <template-repo>
   cd applaa_flutter_template
   ```

2. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your values
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

The app will work in **guest mode** without any setup. Features will show warnings when setup is needed.

---

## 📋 Setup Requirements

### Required for Full Functionality

1. **Firebase** - For authentication, profile, notifications
   - See [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
   - Required for: Auth, Profile, Notifications

2. **Stripe** - For payment processing
   - See [STRIPE.md](STRIPE.md)
   - Required for: Payments
   - **Note**: Requires backend server

3. **AdMob** (Optional) - For displaying ads
   - See [ADMOB_SETUP.md](ADMOB_SETUP.md)
   - **Platform**: Android & iOS only (not supported on web)

See [SETUP_REQUIREMENTS.md](SETUP_REQUIREMENTS.md) for detailed requirements.

---

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── config/          # App configuration
│   ├── constants/       # App constants
│   ├── di/              # Dependency injection
│   ├── router/          # Navigation setup
│   ├── services/        # Core services (AdMob, Notifications)
│   ├── theme/           # Theme configuration
│   ├── utils/           # Utilities (SetupChecker, FirebaseChecker)
│   └── widgets/         # Reusable widgets (Drawer, Warnings)
├── features/
│   ├── auth/            # Authentication module
│   ├── profile/         # User profile module
│   ├── settings/         # Settings module
│   ├── payments/        # Stripe payments module
│   ├── dashboard/       # Revenue dashboard module
│   ├── notifications/   # Notifications module
│   ├── splash/          # Splash screen
│   └── home/            # Home with bottom navigation
└── main.dart            # App entry point
```

---

## 🔧 Customization Guide

### 1. App Branding

**Update app name and version:**
- `lib/core/config/app_config.dart` - App name and version
- `pubspec.yaml` - Package name and description
- `android/app/src/main/AndroidManifest.xml` - Android app name
- `ios/Runner/Info.plist` - iOS app name

**Update app icon:**
- Android: `android/app/src/main/res/mipmap-*/`
- iOS: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- Web: `web/icons/`

**Update theme:**
- `lib/core/theme/app_theme.dart` - Colors, typography, etc.

### 2. Features

**Add new feature:**
1. Create feature folder in `lib/features/`
2. Follow Clean Architecture pattern:
   - `data/` - Data sources and repositories
   - `domain/` - Entities, repositories (interfaces), use cases
   - `presentation/` - UI, BLoC, pages
3. Register in dependency injection (`lib/core/di/injection_container.dart`)
4. Add route in `lib/core/router/app_router.dart`

**Remove unused features:**
1. Remove feature folder
2. Remove from dependency injection
3. Remove routes
4. Update navigation

### 3. Configuration

**Environment variables:**
- Copy `.env.example` to `.env`
- Add your keys and configuration
- Never commit `.env` to version control

**Service configuration:**
- Firebase: See [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
- Stripe: See [STRIPE.md](STRIPE.md)
- AdMob: See [ADMOB_SETUP.md](ADMOB_SETUP.md)

---

## 🛡️ Error Handling & Warnings

The template includes comprehensive error handling:

### Setup Warnings
- **Firebase**: Shows warning if not configured
- **Stripe**: Shows warning on payments page if not configured
- **AdMob**: Shows warning on dashboard if not configured or on web

### Platform Warnings
- **AdMob**: Automatically detects web platform and shows "not supported" message
- **Notifications**: Platform-specific handling

### Authentication Warnings
- **Guest Mode**: App works without authentication
- **Protected Pages**: Profile and Payments show sign-in prompts for guests
- **Missing Firebase**: Clear error messages when Firebase is not configured

---

## 📱 Platform-Specific Features

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
- ❌ Push Notifications (Limited)

The template automatically detects the platform and shows appropriate warnings.

---

## 🧪 Testing

### Run Tests
```bash
flutter test
```

### Run Analysis
```bash
flutter analyze
```

### Check for Issues
```bash
flutter doctor
```

---

## 📦 Building for Production

### Android
```bash
flutter build appbundle --release
# or
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
# Then archive in Xcode
```

### Web
```bash
flutter build web --release
```

See [PRODUCTION_CHECKLIST.md](PRODUCTION_CHECKLIST.md) for complete production readiness checklist.

---

## 🔍 Setup Status Checking

The template includes a `SetupChecker` utility that automatically checks:

- ✅ Firebase configuration status
- ✅ Stripe configuration status
- ✅ AdMob configuration status
- ✅ Platform compatibility
- ✅ Authentication status

Warnings are automatically displayed in:
- Drawer menu
- Payments page
- Dashboard page
- Settings page

---

## 📚 Documentation

- [README.md](README.md) - General project information
- [SETUP_REQUIREMENTS.md](SETUP_REQUIREMENTS.md) - All setup requirements
- [FIREBASE_SETUP.md](FIREBASE_SETUP.md) - Firebase configuration
- [STRIPE.md](STRIPE.md) - Stripe payment setup
- [ADMOB_SETUP.md](ADMOB_SETUP.md) - AdMob ad setup
- [PRODUCTION_CHECKLIST.md](PRODUCTION_CHECKLIST.md) - Production readiness
- [QUICK_START.md](QUICK_START.md) - Quick start guide

---

## 🐛 Troubleshooting

### Common Issues

**White screen on startup:**
- Check if all dependencies are installed: `flutter pub get`
- Check for initialization errors in console
- Verify Firebase setup (if using authentication)

**Sign in/Sign out errors:**
- Check if Firebase is configured
- Verify AuthBloc is registered in dependency injection
- Check error messages in console

**Payments not working:**
- Verify Stripe keys are configured
- Check backend server is running
- Verify API endpoints are correct

**AdMob not working:**
- Check if you're on web (AdMob doesn't work on web)
- Verify AdMob App ID in manifest/plist
- Check ad unit IDs are correct

**Build errors:**
- Run `flutter clean`
- Run `flutter pub get`
- Check `flutter doctor` for issues

---

## 🔄 Using as Template

### For New Projects

1. **Copy this template** to your new project folder
2. **Update package name** in `pubspec.yaml`
3. **Update app configuration** in `lib/core/config/app_config.dart`
4. **Update branding** (name, icon, theme)
5. **Configure services** (Firebase, Stripe, AdMob)
6. **Customize features** as needed
7. **Remove unused features** if not needed

### Best Practices

- ✅ Keep the core architecture intact
- ✅ Follow the existing patterns for new features
- ✅ Use the SetupChecker for new services
- ✅ Add setup warnings for new features
- ✅ Document any customizations
- ✅ Test thoroughly before deploying

---

## 📝 License

This template is provided as-is for use in your projects. Customize as needed.

---

## 🤝 Support

For issues or questions:
1. Check the documentation files
2. Review setup guides
3. Check Flutter documentation
4. Review service provider documentation

---

## ✨ Features Summary

| Feature | Status | Platform | Setup Required |
|---------|--------|----------|----------------|
| Guest Mode | ✅ | All | None |
| Authentication | ✅ | All | Firebase |
| Profile | ✅ | All | Firebase |
| Payments | ✅ | All | Stripe + Backend |
| Dashboard | ✅ | All | Firebase (optional) |
| Notifications | ✅ | Android/iOS | Firebase |
| AdMob | ✅ | Android/iOS | AdMob |
| Settings | ✅ | All | None |
| Dark Mode | ✅ | All | None |

---

**This template is production-ready and scalable. Use it as a solid foundation for your Flutter projects!**

