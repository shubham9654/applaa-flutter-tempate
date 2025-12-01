import '../entities/revenue_entity.dart';

abstract class DashboardRepository {
  Future<RevenueEntity> getRevenueData(String userId);
}

