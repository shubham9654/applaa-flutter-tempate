import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Utility class to check Firebase availability and setup status
class FirebaseChecker {
  static bool _isFirebaseInitialized = false;
  static bool _isFirebaseAvailable = false;

  /// Check if Firebase is initialized and available
  static Future<bool> checkFirebaseAvailability() async {
    try {
      // Try to access Firebase Auth instance
      FirebaseAuth.instance;
      _isFirebaseInitialized = true;
      _isFirebaseAvailable = true;
      return true;
    } catch (e) {
      debugPrint('Firebase not available: $e');
      _isFirebaseInitialized = false;
      _isFirebaseAvailable = false;
      return false;
    }
  }

  /// Get current Firebase availability status
  static bool get isFirebaseAvailable => _isFirebaseAvailable;

  /// Get current Firebase initialization status
  static bool get isFirebaseInitialized => _isFirebaseInitialized;

  /// Check if user is authenticated (only works if Firebase is available)
  static bool isUserAuthenticated() {
    try {
      return FirebaseAuth.instance.currentUser != null;
    } catch (e) {
      return false;
    }
  }
}

