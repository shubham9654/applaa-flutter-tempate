import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/revenue_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository dashboardRepository;

  DashboardBloc(this.dashboardRepository) : super(DashboardInitial()) {
    on<LoadRevenueData>(_onLoadRevenueData);
  }

  Future<void> _onLoadRevenueData(
    LoadRevenueData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(const DashboardError('User not authenticated'));
        return;
      }

      final revenueData = await dashboardRepository.getRevenueData(userId);
      emit(DashboardLoaded(revenueData));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
