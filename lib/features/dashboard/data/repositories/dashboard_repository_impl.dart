import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/entities/revenue_entity.dart';
import '../datasources/dashboard_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<RevenueEntity> getRevenueData(String userId) {
    return remoteDataSource.getRevenueData(userId);
  }
}

