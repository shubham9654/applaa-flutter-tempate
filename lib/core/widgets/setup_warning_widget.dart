import 'package:flutter/material.dart';
import '../utils/setup_checker.dart';

/// Widget to show setup warnings for missing configurations
class SetupWarningWidget extends StatelessWidget {
  final SetupRequirement requirement;
  final bool showActionButton;
  final VoidCallback? onDismiss;

  const SetupWarningWidget({
    super.key,
    required this.requirement,
    this.showActionButton = true,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (requirement.status) {
      case SetupStatus.notConfigured:
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange.shade700;
        icon = Icons.warning_amber_rounded;
        break;
      case SetupStatus.platformNotSupported:
        backgroundColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue.shade700;
        icon = Icons.info_outline;
        break;
      case SetupStatus.configured:
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green.shade700;
        icon = Icons.check_circle_outline;
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey.shade700;
        icon = Icons.help_outline;
    }

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: textColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  requirement.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: textColor,
                  ),
                ),
              ),
              if (requirement.platform != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: textColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    requirement.platform!,
                    style: TextStyle(
                      fontSize: 10,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            requirement.message,
            style: TextStyle(
              fontSize: 12,
              color: textColor.withOpacity(0.9),
            ),
          ),
          if (showActionButton && requirement.setupGuide != null &&
              requirement.status != SetupStatus.configured) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onDismiss != null)
                  TextButton(
                    onPressed: onDismiss,
                    child: Text(
                      'Dismiss',
                      style: TextStyle(color: textColor),
                    ),
                  ),
                TextButton(
                  onPressed: () {
                    // Could navigate to setup guide or show dialog
                    _showSetupInfo(context, requirement);
                  },
                  child: Text(
                    'Setup Guide',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showSetupInfo(BuildContext context, SetupRequirement requirement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${requirement.name} Setup'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(requirement.message),
            if (requirement.platform != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.phone_android, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Available on: ${requirement.platform}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
            if (requirement.setupGuide != null) ...[
              const SizedBox(height: 16),
              const Text(
                'For detailed setup instructions, please refer to:',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                requirement.setupGuide!,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// Banner widget showing all setup requirements
class SetupStatusBanner extends StatelessWidget {
  final bool showOnlyIssues;

  const SetupStatusBanner({
    super.key,
    this.showOnlyIssues = true,
  });

  @override
  Widget build(BuildContext context) {
    final requirements = SetupChecker.getAllRequirements();
    final issues = requirements.where((r) =>
        r.status == SetupStatus.notConfigured ||
        r.status == SetupStatus.platformNotSupported).toList();

    if (showOnlyIssues && issues.isEmpty) {
      return const SizedBox.shrink();
    }

    final itemsToShow = showOnlyIssues ? issues : requirements;

    return Column(
      children: itemsToShow
          .map((req) => SetupWarningWidget(requirement: req))
          .toList(),
    );
  }
}

