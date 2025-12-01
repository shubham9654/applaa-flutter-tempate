import '../../domain/repositories/notifications_repository.dart';
import '../../domain/entities/notification_entity.dart';
import '../datasources/notifications_local_datasource.dart';
import '../../../../core/services/notification_service.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsLocalDataSource localDataSource;
  final NotificationService notificationService;

  NotificationsRepositoryImpl(this.localDataSource, this.notificationService);

  @override
  Future<List<NotificationEntity>> getNotifications() {
    return localDataSource.getNotifications();
  }

  @override
  Future<void> saveNotification(NotificationEntity notification) {
    return localDataSource.saveNotification(notification);
  }

  @override
  Future<void> markAsRead(String notificationId) {
    return localDataSource.markAsRead(notificationId);
  }

  @override
  Future<String?> getFCMToken() {
    return notificationService.getFCMToken();
  }
}

