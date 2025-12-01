import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io' show Platform;
import '../config/app_config.dart';
import '../services/admob_service.dart';

/// Setup status for different services
enum SetupStatus {
  configured,
  notConfigured,
  platformNotSupported,
  optional,
}

/// Setup requirement information
class SetupRequirement {
  final String name;
  final SetupStatus status;
  final String message;
  final String? platform;
  final String? setupGuide;

  const SetupRequirement({
    required this.name,
    required this.status,
    required this.message,
    this.platform,
    this.setupGuide,
  });
}

/// Comprehensive setup checker for all services
class SetupChecker {
  static final SetupChecker _instance = SetupChecker._internal();
  factory SetupChecker() => _instance;
  SetupChecker._internal();

  /// Check Firebase setup
  static SetupRequirement checkFirebase() {
    try {
      // Check if Firebase Auth is accessible
      FirebaseAuth.instance;
      return SetupRequirement(
        name: 'Firebase',
        status: SetupStatus.configured,
        message: 'Firebase is configured and ready',
        setupGuide: 'FIREBASE_SETUP.md',
      );
    } catch (e) {
      return SetupRequirement(
        name: 'Firebase',
        status: SetupStatus.notConfigured,
        message: 'Firebase is not configured. Required for authentication, profile, and notifications.',
        setupGuide: 'FIREBASE_SETUP.md',
      );
    }
  }

  /// Check Stripe setup
  static SetupRequirement checkStripe() {
    final publishableKey = AppConfig.stripePublishableKey;
    final secretKey = AppConfig.stripeSecretKey;
    
    final isTestKey = publishableKey.contains('pk_test_') || 
                     publishableKey.contains('your_publishable_key');
    final isConfigured = !publishableKey.contains('your_publishable_key') &&
                        !secretKey.contains('your_secret_key');

    if (!isConfigured) {
      return SetupRequirement(
        name: 'Stripe',
        status: SetupStatus.notConfigured,
        message: 'Stripe keys are not configured. Required for payment processing.',
        setupGuide: 'STRIPE.md',
      );
    }

    if (isTestKey) {
      return SetupRequirement(
        name: 'Stripe',
        status: SetupStatus.configured,
        message: 'Stripe is configured (Test Mode). Update to production keys before deploying.',
        setupGuide: 'STRIPE.md',
      );
    }

    return SetupRequirement(
      name: 'Stripe',
      status: SetupStatus.configured,
      message: 'Stripe is configured and ready',
      setupGuide: 'STRIPE.md',
    );
  }

  /// Check AdMob setup
  static SetupRequirement checkAdMob() {
    // AdMob doesn't work on web
    if (kIsWeb) {
      return SetupRequirement(
        name: 'AdMob',
        status: SetupStatus.platformNotSupported,
        message: 'AdMob is not supported on web platform. Available on Android and iOS only.',
        platform: 'Android, iOS',
        setupGuide: 'ADMOB_SETUP.md',
      );
    }

    // Check if AdMob service is registered
    if (!GetIt.instance.isRegistered<AdMobService>()) {
      return SetupRequirement(
        name: 'AdMob',
        status: SetupStatus.notConfigured,
        message: 'AdMob service is not available. Required for displaying ads.',
        platform: 'Android, iOS',
        setupGuide: 'ADMOB_SETUP.md',
      );
    }

    // Check if using test IDs
    final appId = AppConfig.admobAppId;
    final isTestId = appId.contains('3940256099942544');

    if (isTestId) {
      return SetupRequirement(
        name: 'AdMob',
        status: SetupStatus.configured,
        message: 'AdMob is configured (Test IDs). Update to production IDs before publishing.',
        platform: 'Android, iOS',
        setupGuide: 'ADMOB_SETUP.md',
      );
    }

    return SetupRequirement(
      name: 'AdMob',
      status: SetupStatus.configured,
      message: 'AdMob is configured and ready',
      platform: 'Android, iOS',
      setupGuide: 'ADMOB_SETUP.md',
    );
  }

  /// Check if user is authenticated
  static bool isUserAuthenticated() {
    try {
      return FirebaseAuth.instance.currentUser != null;
    } catch (e) {
      return false;
    }
  }

  /// Get all setup requirements
  static List<SetupRequirement> getAllRequirements() {
    return [
      checkFirebase(),
      checkStripe(),
      checkAdMob(),
    ];
  }

  /// Get platform-specific information
  static String getPlatformInfo() {
    if (kIsWeb) {
      return 'Web';
    } else if (Platform.isAndroid) {
      return 'Android';
    } else if (Platform.isIOS) {
      return 'iOS';
    } else {
      return 'Unknown';
    }
  }

  /// Check if a feature is available on current platform
  static bool isFeatureAvailableOnPlatform(String featureName) {
    switch (featureName.toLowerCase()) {
      case 'admob':
      case 'ads':
        return !kIsWeb; // AdMob only on mobile
      case 'firebase':
        return true; // Firebase works on all platforms
      case 'stripe':
        return true; // Stripe works on all platforms
      case 'notifications':
        return !kIsWeb; // Push notifications mainly on mobile
      default:
        return true;
    }
  }

  /// Get summary of setup status
  static Map<String, dynamic> getSetupSummary() {
    final requirements = getAllRequirements();
    final configured = requirements.where((r) => r.status == SetupStatus.configured).length;
    final notConfigured = requirements.where((r) => r.status == SetupStatus.notConfigured).length;
    final platformNotSupported = requirements.where((r) => r.status == SetupStatus.platformNotSupported).length;

    return {
      'total': requirements.length,
      'configured': configured,
      'notConfigured': notConfigured,
      'platformNotSupported': platformNotSupported,
      'platform': getPlatformInfo(),
      'isProductionReady': notConfigured == 0 && platformNotSupported == 0,
    };
  }
}

