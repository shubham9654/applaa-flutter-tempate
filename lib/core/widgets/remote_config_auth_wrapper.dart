import 'package:flutter/material.dart';
import '../services/remote_config_service.dart';

/// Wrapper widget that shows/hides auth methods based on Remote Config
class RemoteConfigAuthWrapper extends StatelessWidget {
  final String authMethod; // 'email', 'google', 'apple', 'facebook', 'biometric'
  final Widget child;
  final Widget? placeholder;

  const RemoteConfigAuthWrapper({
    super.key,
    required this.authMethod,
    required this.child,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final remoteConfig = RemoteConfigService();
    bool isEnabled = false;

    switch (authMethod.toLowerCase()) {
      case 'email':
        isEnabled = remoteConfig.getEnableEmailAuth();
        break;
      case 'google':
        isEnabled = remoteConfig.getEnableGoogleAuth();
        break;
      case 'apple':
        isEnabled = remoteConfig.getEnableAppleAuth();
        break;
      case 'facebook':
        isEnabled = remoteConfig.getEnableFacebookAuth();
        break;
      case 'biometric':
        isEnabled = remoteConfig.getEnableBiometricAuth();
        break;
      default:
        isEnabled = true; // Default to enabled if unknown
    }

    if (!isEnabled) {
      return placeholder ?? const SizedBox.shrink();
    }

    return child;
  }
}

