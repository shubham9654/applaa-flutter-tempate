import 'package:equatable/equatable.dart';

class RevenueEntity extends Equatable {
  final double totalRevenue;
  final double monthlyRevenue;
  final double weeklyRevenue;
  final List<RevenueDataPoint> chartData;

  const RevenueEntity({
    required this.totalRevenue,
    required this.monthlyRevenue,
    required this.weeklyRevenue,
    required this.chartData,
  });

  @override
  List<Object> get props => [totalRevenue, monthlyRevenue, weeklyRevenue, chartData];
}

class RevenueDataPoint extends Equatable {
  final DateTime date;
  final double amount;

  const RevenueDataPoint({
    required this.date,
    required this.amount,
  });

  @override
  List<Object> get props => [date, amount];
}

