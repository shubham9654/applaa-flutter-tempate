import '../entities/notification_entity.dart';

abstract class NotificationsRepository {
  Future<List<NotificationEntity>> getNotifications();
  Future<void> saveNotification(NotificationEntity notification);
  Future<void> markAsRead(String notificationId);
  Future<String?> getFCMToken();
}

