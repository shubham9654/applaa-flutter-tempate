import 'package:flutter/material.dart';
import '../services/remote_config_service.dart';

class MaintenanceModeWidget extends StatelessWidget {
  final Widget child;
  
  const MaintenanceModeWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final remoteConfig = RemoteConfigService();
    
    if (remoteConfig.getAppMaintenanceMode()) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.construction,
                    size: 100,
                    color: Colors.orange[700],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Under Maintenance',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'We\'re currently performing maintenance to improve your experience. Please check back soon!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () async {
                      // Force fetch new config
                      await remoteConfig.forceFetch();
                      // Trigger rebuild - in a real app you'd want better state management
                      if (context.mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => MaintenanceModeWidget(child: child),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Check Again'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    
    return child;
  }
}

