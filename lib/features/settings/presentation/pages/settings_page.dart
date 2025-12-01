import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/constants/app_constants.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SettingsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SettingsBloc>().add(const LoadSettings());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is SettingsLoaded) {
            final settings = state.settings;

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Card(
                  child: SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Toggle dark theme'),
                    value: settings.isDarkMode,
                    onChanged: (value) {
                      context.read<SettingsBloc>().add(const ToggleTheme());
                    },
                    secondary: const Icon(Icons.dark_mode),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: SwitchListTile(
                    title: const Text('Notifications'),
                    subtitle: const Text('Enable push notifications'),
                    value: settings.notificationsEnabled,
                    onChanged: (value) {
                      context.read<SettingsBloc>().add(
                            const ToggleNotifications(),
                          );
                    },
                    secondary: const Icon(Icons.notifications),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    title: const Text('Language'),
                    subtitle: Text(settings.language.toUpperCase()),
                    leading: const Icon(Icons.language),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Show language selection dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Select Language'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: const Text('English'),
                                onTap: () {
                                  context.read<SettingsBloc>().add(
                                        const ChangeLanguage('en'),
                                      );
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: const Text('Spanish'),
                                onTap: () {
                                  context.read<SettingsBloc>().add(
                                        const ChangeLanguage('es'),
                                      );
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  child: ListTile(
                    title: const Text('Sign Out'),
                    leading: const Icon(Icons.logout, color: Colors.red),
                    textColor: Colors.red,
                    iconColor: Colors.red,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Sign Out'),
                          content: const Text('Are you sure you want to sign out?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<AuthBloc>().add(const SignOutRequested());
                                Navigator.pop(context);
                                appRouter.go(AppConstants.loginRoute);
                              },
                              child: const Text('Sign Out'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

