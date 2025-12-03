import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'dart:ui';
import '../bloc/settings_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/constants/app_constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchActive = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (!_isSearchActive) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
            
            // Check if user is authenticated
            bool isAuthenticated = false;
            User? currentUser;
            try {
              currentUser = FirebaseAuth.instance.currentUser;
              isAuthenticated = currentUser != null;
            } catch (e) {
              isAuthenticated = false;
            }

            return CustomScrollView(
              slivers: [
                // Sticky Header
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  backgroundColor: Colors.grey[50]!.withOpacity(0.9),
                  elevation: 0,
                  flexibleSpace: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: Colors.grey[50]!.withOpacity(0.9),
                      ),
                    ),
                  ),
                  title: _isSearchActive
                      ? Container(
                          height: 40,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            autofocus: true,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1E293B),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search settings...',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 16,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.grey[600],
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        _searchController.clear();
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        )
                      : const Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                  actions: [
                    if (_isSearchActive)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: TextButton(
                          onPressed: _toggleSearch,
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFF6C5CE7),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: IconButton(
                          icon: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.search,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                          ),
                          onPressed: _toggleSearch,
                        ),
                      ),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      _buildSettingsList(
                        context,
                        isAuthenticated,
                        currentUser,
                        settings,
                        _searchQuery,
                      ),
                    ),
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

  List<Widget> _buildSettingsList(
    BuildContext context,
    bool isAuthenticated,
    User? currentUser,
    dynamic settings,
    String searchQuery,
  ) {
    final List<Widget> items = [];
    
    // Helper function to check if a title matches the search query
    bool matchesSearch(String title) {
      if (searchQuery.isEmpty) return true;
      return title.toLowerCase().contains(searchQuery);
    }
    
    // Profile Card - Show if no search or search matches profile-related terms
    if (searchQuery.isEmpty || 
        'profile'.contains(searchQuery) || 
        'personal information'.contains(searchQuery) ||
        'jane doe'.contains(searchQuery) ||
        'user'.contains(searchQuery))
      items.add(
      Container(
        margin: const EdgeInsets.only(bottom: 32),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xFF6C5CE7),
                    backgroundImage: (isAuthenticated && currentUser?.photoURL != null)
                        ? NetworkImage(currentUser!.photoURL!)
                        : null,
                    child: (isAuthenticated && currentUser?.photoURL == null) || !isAuthenticated
                        ? const Text(
                            'JD',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C5CE7),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAuthenticated
                        ? (currentUser?.displayName ?? 'User')
                        : 'Jane Doe',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isAuthenticated
                        ? (currentUser?.email ?? 'user@applaa.ui')
                        : 'jane.doe@applaa.ui',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                context.push(AppConstants.profileRoute);
              },
              child: const Text(
                'Edit',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6C5CE7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    
    // Premium Banner - Show if no search or search matches premium-related terms
    if (searchQuery.isEmpty || 
        'premium'.contains(searchQuery) || 
        'features'.contains(searchQuery) ||
        'upgrade'.contains(searchQuery))
      items.add(
      Container(
                          margin: const EdgeInsets.only(bottom: 32),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF6C5CE7), Color(0xFF818CF8)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6C5CE7).withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                right: -24,
                                top: -24,
                                child: Container(
                                  width: 96,
                                  height: 96,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: -24,
                                bottom: -24,
                                child: Container(
                                  width: 96,
                                  height: 96,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              // Premium content
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.amber, size: 20),
                                        SizedBox(width: 8),
                                        Text(
                                          'Premium Features',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Unlock all premium features and remove ads.',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
    );
    
    // Account Section - Filter items based on search
    final accountItems = <Widget>[];
    final hasPersonalInfo = matchesSearch('Personal Information');
    final hasSecurity = matchesSearch('Security & Login') || matchesSearch('Security') || matchesSearch('Login');
    final hasPayments = matchesSearch('Payments & Billing') || matchesSearch('Payments') || matchesSearch('Billing');
    
    if (hasPersonalInfo) {
      accountItems.add(
        _buildSettingsItem(
          context: context,
          icon: Icons.person_outline,
          iconColor: const Color(0xFF6C5CE7),
          title: 'Personal Information',
          onTap: () {
            context.push(AppConstants.profileRoute);
          },
          showDivider: hasSecurity || hasPayments,
        ),
      );
    }
    if (hasSecurity) {
      accountItems.add(
        _buildSettingsItem(
          context: context,
          icon: Icons.shield_outlined,
          iconColor: const Color(0xFF6C5CE7),
          title: 'Security & Login',
          onTap: () {},
          showDivider: hasPayments,
        ),
      );
    }
    if (hasPayments) {
      accountItems.add(
        _buildSettingsItem(
          context: context,
          icon: Icons.credit_card_outlined,
          iconColor: const Color(0xFF6C5CE7),
          title: 'Payments & Billing',
          onTap: () {
            context.push(AppConstants.paymentsRoute);
          },
        ),
      );
    }
    
    if (accountItems.isNotEmpty) {
      items.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 4),
          child: Text(
            'ACCOUNT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
              letterSpacing: 1.2,
            ),
          ),
        ),
      );
      items.add(
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[100]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: accountItems,
          ),
        ),
      );
    }
    
    // Preferences Section - Filter items based on search
    final preferenceItems = <Widget>[];
    final hasNotifications = matchesSearch('Push Notifications') || matchesSearch('Notifications') || matchesSearch('Push');
    final hasDarkMode = matchesSearch('Dark Mode') || matchesSearch('Dark') || matchesSearch('Theme');
    final hasLanguage = matchesSearch('Language') || matchesSearch('English');
    
    if (hasNotifications) {
      preferenceItems.add(
        _buildSettingsItemWithToggle(
          context: context,
          icon: Icons.notifications_outlined,
          iconColor: Colors.orange[500]!,
          title: 'Push Notifications',
          value: settings.notificationsEnabled,
          onChanged: (value) {
            context.read<SettingsBloc>().add(
                  const ToggleNotifications(),
                );
          },
          showDivider: hasDarkMode || hasLanguage,
        ),
      );
    }
    if (hasDarkMode) {
      preferenceItems.add(
        _buildSettingsItemWithToggle(
          context: context,
          icon: Icons.dark_mode_outlined,
          iconColor: Colors.grey[600]!,
          title: 'Dark Mode',
          value: settings.isDarkMode,
          onChanged: (value) {
            context.read<SettingsBloc>().add(
                  const ToggleTheme(),
                );
          },
          showDivider: hasLanguage,
        ),
      );
    }
    if (hasLanguage) {
      preferenceItems.add(
        _buildSettingsItem(
          context: context,
          icon: Icons.language_outlined,
          iconColor: Colors.blue[500]!,
          title: 'Language',
          subtitle: 'English (US)',
          onTap: () {
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
      );
    }
    
    if (preferenceItems.isNotEmpty) {
      items.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 4),
          child: Text(
            'PREFERENCES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
              letterSpacing: 1.2,
            ),
          ),
        ),
      );
      items.add(
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[100]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: preferenceItems,
          ),
        ),
      );
    }
    
    // Support Section - Filter items based on search
    final supportItems = <Widget>[];
    final hasHelp = matchesSearch('Help Center') || matchesSearch('Help');
    final hasTerms = matchesSearch('Terms & Privacy') || matchesSearch('Terms') || matchesSearch('Privacy');
    
    if (hasHelp) {
      supportItems.add(
        _buildSettingsItem(
          context: context,
          icon: Icons.help_outline,
          iconColor: Colors.green[600]!,
          title: 'Help Center',
          onTap: () {},
          showDivider: hasTerms,
        ),
      );
    }
    if (hasTerms) {
      supportItems.add(
        _buildSettingsItem(
          context: context,
          icon: Icons.description_outlined,
          iconColor: Colors.purple[500]!,
          title: 'Terms & Privacy',
          onTap: () {},
        ),
      );
    }
    
    if (supportItems.isNotEmpty) {
      items.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 4),
          child: Text(
            'SUPPORT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
              letterSpacing: 1.2,
            ),
          ),
        ),
      );
      items.add(
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[100]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: supportItems,
          ),
        ),
      );
    }
    
    // Logout Button - Show if no search or search matches logout-related terms
    if (searchQuery.isEmpty || 
        'logout'.contains(searchQuery) || 
        'log out'.contains(searchQuery) ||
        'sign out'.contains(searchQuery))
      items.add(
                        Container(
                          margin: const EdgeInsets.only(bottom: 32),
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.red[100]!),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextButton.icon(
                            onPressed: () {
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
                                        Navigator.pop(context);
                                        if (!GetIt.instance.isRegistered<AuthBloc>()) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Firebase authentication is not configured.'),
                                              backgroundColor: Colors.orange,
                                            ),
                                          );
                                          return;
                                        }
                                        try {
                                          context.read<AuthBloc>().add(const SignOutRequested());
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Signed out successfully'),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                          appRouter.go(AppConstants.homeRoute);
                                        } catch (e) {
                                          debugPrint('Sign out error: $e');
                                        }
                                      },
                                      child: const Text('Sign Out'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.logout, color: Colors.red),
                            label: const Text(
                              'Log Out',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
    );
    
    // Show "no results" message if searching and no settings items found
    // Check if we have any actual settings items (not just profile/premium)
    final hasLogout = searchQuery.isEmpty || 
                     'logout'.contains(searchQuery) || 
                     'log out'.contains(searchQuery) ||
                     'sign out'.contains(searchQuery);
    final hasSettingsItems = accountItems.isNotEmpty || 
                            preferenceItems.isNotEmpty || 
                            supportItems.isNotEmpty ||
                            hasLogout;
    
    if (searchQuery.isNotEmpty && !hasSettingsItems) {
      items.add(
        Container(
          margin: const EdgeInsets.only(top: 100),
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No results found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try searching with different keywords',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return items;
  }

  Widget _buildSettingsItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool showDivider = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: showDivider
              ? Border(
                  bottom: BorderSide(color: Colors.grey[50]!),
                )
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[300],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItemWithToggle({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool showDivider = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: showDivider
            ? Border(
                bottom: BorderSide(color: Colors.grey[50]!),
              )
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF6C5CE7),
          ),
        ],
      ),
    );
  }
}

