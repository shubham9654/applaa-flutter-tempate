import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bloc/dashboard_bloc.dart';
import '../../../../core/services/admob_service.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/setup_warning_widget.dart';
import '../../../../core/utils/setup_checker.dart';
import '../../domain/entities/revenue_entity.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Load data after the first frame to ensure context has providers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadDashboardData();
      }
    });
  }

  void _loadDashboardData() {
    try {
      // Check if DashboardBloc is available in the widget tree
      final dashboardBloc = context.read<DashboardBloc>();
      dashboardBloc.add(const LoadRevenueData());
    } catch (e) {
      debugPrint('DashboardBloc not available: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if DashboardBloc is available in providers
    try {
      // Try to access DashboardBloc to see if it's in the tree
      context.read<DashboardBloc>();
      
      // If we get here, DashboardBloc is available
      return Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          elevation: 0,
        ),
        body: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DashboardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<DashboardBloc>()
                          .add(const LoadRevenueData());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is DashboardLoaded) {
            final revenue = state.revenueData;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Actions Section
                  _buildQuickActions(context),
                  const SizedBox(height: 24),
                  // Revenue Summary Cards
                  Row(
                    children: [
                      Expanded(
                        child: _RevenueCard(
                          title: 'Total Revenue',
                          amount: revenue.totalRevenue,
                          icon: Icons.account_balance_wallet,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _RevenueCard(
                          title: 'Monthly',
                          amount: revenue.monthlyRevenue,
                          icon: Icons.calendar_month,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _RevenueCard(
                          title: 'Weekly',
                          amount: revenue.weeklyRevenue,
                          icon: Icons.calendar_today,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Revenue Chart
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Revenue Trend',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: revenue.chartData.isEmpty
                                ? const Center(
                                    child: Text('No data available'),
                                  )
                                : LineChart(
                                    _buildChartData(revenue.chartData),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // AdMob Banner
                  _AdMobBannerWidget(),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
    } catch (e) {
      // DashboardBloc not available, show default dashboard
      debugPrint('DashboardBloc not in providers: $e');
      return _buildDefaultDashboard();
    }
  }

  Widget _buildDefaultDashboard() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AdMob setup warning
            Builder(
              builder: (context) {
                final admobSetup = SetupChecker.checkAdMob();
                if (admobSetup.status != SetupStatus.configured) {
                  return Column(
                    children: [
                      SetupWarningWidget(requirement: admobSetup),
                      const SizedBox(height: 16),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            // Quick Actions Section
            _buildQuickActions(context),
            const SizedBox(height: 24),
            // Welcome Card
            _BeautifulCard(
              gradient: LinearGradient(
                colors: [Colors.blue[400]!, Colors.purple[400]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.waving_hand,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome Back!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Ready to get started?',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Stats Cards Row
            Row(
              children: [
                Expanded(
                  child: _BeautifulCard(
                    color: Colors.blue[50],
                    borderColor: Colors.blue[200]!,
                    child: const _StatCard(
                      title: 'Total Revenue',
                      value: '\$0.00',
                      icon: Icons.account_balance_wallet,
                      iconColor: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _BeautifulCard(
                    color: Colors.green[50],
                    borderColor: Colors.green[200]!,
                    child: const _StatCard(
                      title: 'Monthly',
                      value: '\$0.00',
                      icon: Icons.calendar_month,
                      iconColor: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _BeautifulCard(
                    color: Colors.orange[50],
                    borderColor: Colors.orange[200]!,
                    child: const _StatCard(
                      title: 'Weekly',
                      value: '\$0.00',
                      icon: Icons.calendar_today,
                      iconColor: Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _BeautifulCard(
                    color: Colors.purple[50],
                    borderColor: Colors.purple[200]!,
                    child: const _StatCard(
                      title: 'Active Users',
                      value: '0',
                      icon: Icons.people,
                      iconColor: Colors.purple,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Quick Actions Card
            _BeautifulCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _ActionChip(
                        icon: Icons.payment,
                        label: 'Payments',
                        color: Colors.blue,
                        onTap: () {},
                      ),
                      _ActionChip(
                        icon: Icons.person,
                        label: 'Profile',
                        color: Colors.green,
                        onTap: () {},
                      ),
                      _ActionChip(
                        icon: Icons.settings,
                        label: 'Settings',
                        color: Colors.orange,
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Info Card
            _BeautifulCard(
              gradient: LinearGradient(
                colors: [Colors.amber[100]!, Colors.orange[100]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange[700], size: 32),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Connect Firebase to see real-time data and analytics.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _buildChartData(List<RevenueDataPoint> dataPoints) {
    if (dataPoints.isEmpty) {
      return LineChartData();
    }

    final spots = dataPoints.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.amount);
    }).toList();

    final maxY =
        dataPoints.map((e) => e.amount).reduce((a, b) => a > b ? a : b);

    return LineChartData(
      gridData: const FlGridData(show: true),
      titlesData: const FlTitlesData(show: true),
      borderData: FlBorderData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: Colors.blue,
          barWidth: 3,
          dotData: const FlDotData(show: false),
          belowBarData:
              BarAreaData(show: true, color: Colors.blue.withOpacity(0.1)),
        ),
      ],
      minY: 0,
      maxY: maxY * 1.2,
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    // Check if user is authenticated
    bool isAuthenticated = false;
    try {
      isAuthenticated = FirebaseAuth.instance.currentUser != null;
    } catch (e) {
      isAuthenticated = false;
    }

    // Only show quick actions if not authenticated
    if (isAuthenticated) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6C5CE7), Color(0xFF818CF8)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C5CE7).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.bolt,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Actions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Sign in to access all features',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push(AppConstants.loginRoute);
                  },
                  icon: const Icon(Icons.login, size: 18),
                  label: const Text('Sign In'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF6C5CE7),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.push(AppConstants.signupRoute);
                  },
                  icon: const Icon(Icons.person_add, size: 18),
                  label: const Text('Sign Up'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RevenueCard extends StatelessWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color color;

  const _RevenueCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Beautiful Card Widget
class _BeautifulCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final Color? borderColor;
  final Gradient? gradient;

  const _BeautifulCard({
    required this.child,
    this.color,
    this.borderColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: child,
      ),
    );
  }
}

// Stat Card Widget
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: iconColor,
          ),
        ),
      ],
    );
  }
}

// Action Chip Widget
class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  _ActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate based on label
        switch (label) {
          case 'Payments':
            context.go(AppConstants.paymentsRoute);
            break;
          case 'Profile':
            context.go(AppConstants.profileRoute);
            break;
          case 'Settings':
            context.go(AppConstants.settingsRoute);
            break;
        }
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdMobBannerWidget extends StatefulWidget {
  @override
  State<_AdMobBannerWidget> createState() => _AdMobBannerWidgetState();
}

class _AdMobBannerWidgetState extends State<_AdMobBannerWidget> {
  AdMobService? _adMobService;

  @override
  void initState() {
    super.initState();
    try {
      if (getIt.isRegistered<AdMobService>()) {
        _adMobService = getIt<AdMobService>();
        _loadBannerAd();
      }
    } catch (e) {
      debugPrint('AdMobService not available: $e');
    }
  }

  void _loadBannerAd() {
    if (_adMobService == null) return;
    _adMobService!.loadBannerAd(
      adSize: AdSize.banner,
      onAdLoaded: (ad) {
        if (mounted) setState(() {});
      },
      onAdFailedToLoad: (error) {
        debugPrint('Banner ad failed to load: $error');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_adMobService != null &&
        _adMobService!.isBannerAdReady &&
        _adMobService!.bannerAd != null) {
      return SizedBox(
        height: _adMobService!.bannerAd!.size.height.toDouble(),
        width: double.infinity,
        child: AdWidget(ad: _adMobService!.bannerAd!),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  void dispose() {
    _adMobService?.disposeBannerAd();
    super.dispose();
  }
}
