import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../bloc/dashboard_bloc.dart';
import '../../../../core/services/admob_service.dart';
import '../../../../core/di/injection_container.dart';
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
    context.read<DashboardBloc>().add(const LoadRevenueData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
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
                  Text(state.message),
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
                Icon(icon, color: color),
              ],
            ),
            const SizedBox(height: 8),
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

class _AdMobBannerWidget extends StatefulWidget {
  @override
  State<_AdMobBannerWidget> createState() => _AdMobBannerWidgetState();
}

class _AdMobBannerWidgetState extends State<_AdMobBannerWidget> {
  final AdMobService _adMobService = getIt<AdMobService>();

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _adMobService.loadBannerAd(
      adSize: AdSize.banner,
      onAdLoaded: (ad) {
        setState(() {});
      },
      onAdFailedToLoad: (error) {
        debugPrint('Banner ad failed to load: $error');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_adMobService.isBannerAdReady && _adMobService.bannerAd != null) {
      return SizedBox(
        height: _adMobService.bannerAd!.size.height.toDouble(),
        width: double.infinity,
        child: AdWidget(ad: _adMobService.bannerAd!),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  void dispose() {
    _adMobService.disposeBannerAd();
    super.dispose();
  }
}
