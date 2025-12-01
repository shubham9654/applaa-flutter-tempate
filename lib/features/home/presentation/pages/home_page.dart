import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_drawer.dart';

class HomePage extends StatefulWidget {
  final Widget child;

  const HomePage({super.key, required this.child});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Dashboard',
      route: AppConstants.homeRoute,
    ),
    NavigationItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: 'Settings',
      route: AppConstants.settingsRoute,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    context.go(_navigationItems[index].route);
  }

  @override
  Widget build(BuildContext context) {
    // Determine current index based on route
    final currentRoute = GoRouterState.of(context).matchedLocation;
    final index = _navigationItems.indexWhere(
      (item) => item.route == currentRoute || 
                (item.route == AppConstants.homeRoute && 
                 (currentRoute == AppConstants.homeRoute || currentRoute == AppConstants.dashboardRoute)),
    );
    if (index != -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _currentIndex != index) {
          setState(() {
            _currentIndex = index;
          });
        }
      });
    }

    return Scaffold(
      drawer: const AppDrawer(),
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onItemTapped,
        destinations: _navigationItems.map((item) {
          return NavigationDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.activeIcon),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}

