import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/revenue_entity.dart';

abstract class DashboardRemoteDataSource {
  Future<RevenueEntity> getRevenueData(String userId);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final FirebaseFirestore firestore;

  DashboardRemoteDataSourceImpl(this.firestore);

  @override
  Future<RevenueEntity> getRevenueData(String userId) async {
    try {
      // Fetch payment transactions
      final paymentsSnapshot = await firestore
          .collection('payments')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'succeeded')
          .orderBy('createdAt', descending: true)
          .get();

      double totalRevenue = 0;
      double monthlyRevenue = 0;
      double weeklyRevenue = 0;
      final now = DateTime.now();
      final monthStart = DateTime(now.year, now.month, 1);
      final weekStart = now.subtract(Duration(days: now.weekday - 1));

      final chartDataMap = <DateTime, double>{};

      for (var doc in paymentsSnapshot.docs) {
        final data = doc.data();
        final amount = (data['amount'] as num).toDouble();
        final createdAt = (data['createdAt'] as Timestamp).toDate();

        totalRevenue += amount;

        if (createdAt.isAfter(monthStart)) {
          monthlyRevenue += amount;
        }

        if (createdAt.isAfter(weekStart)) {
          weeklyRevenue += amount;
        }

        // Group by date for chart
        final dateKey = DateTime(createdAt.year, createdAt.month, createdAt.day);
        chartDataMap[dateKey] = (chartDataMap[dateKey] ?? 0) + amount;
      }

      // Convert to list and sort
      final chartData = chartDataMap.entries
          .map((e) => RevenueDataPoint(date: e.key, amount: e.value))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));

      return RevenueEntity(
        totalRevenue: totalRevenue,
        monthlyRevenue: monthlyRevenue,
        weeklyRevenue: weeklyRevenue,
        chartData: chartData,
      );
    } catch (e) {
      // Return empty data on error
      return const RevenueEntity(
        totalRevenue: 0,
        monthlyRevenue: 0,
        weeklyRevenue: 0,
        chartData: [],
      );
    }
  }
}

