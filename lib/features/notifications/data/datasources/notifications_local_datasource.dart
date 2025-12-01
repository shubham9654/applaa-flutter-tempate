import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/entities/notification_entity.dart';

abstract class NotificationsLocalDataSource {
  Future<List<NotificationEntity>> getNotifications();
  Future<void> saveNotification(NotificationEntity notification);
  Future<void> markAsRead(String notificationId);
}

class NotificationsLocalDataSourceImpl implements NotificationsLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _notificationsKey = 'notifications';

  NotificationsLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    final jsonString = sharedPreferences.getString(_notificationsKey);
    if (jsonString == null) {
      return [];
    }

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => NotificationEntity(
          id: json['id'],
          title: json['title'],
          body: json['body'],
          createdAt: DateTime.parse(json['createdAt']),
          isRead: json['isRead'] ?? false,
          data: json['data'],
        )).toList();
  }

  @override
  Future<void> saveNotification(NotificationEntity notification) async {
    final notifications = await getNotifications();
    notifications.insert(0, notification);
    
    final jsonList = notifications.map((n) => {
          'id': n.id,
          'title': n.title,
          'body': n.body,
          'createdAt': n.createdAt.toIso8601String(),
          'isRead': n.isRead,
          'data': n.data,
        }).toList();

    await sharedPreferences.setString(_notificationsKey, jsonEncode(jsonList));
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final notifications = await getNotifications();
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      final updated = NotificationEntity(
        id: notifications[index].id,
        title: notifications[index].title,
        body: notifications[index].body,
        createdAt: notifications[index].createdAt,
        isRead: true,
        data: notifications[index].data,
      );
      notifications[index] = updated;

      final jsonList = notifications.map((n) => {
            'id': n.id,
            'title': n.title,
            'body': n.body,
            'createdAt': n.createdAt.toIso8601String(),
            'isRead': n.isRead,
            'data': n.data,
          }).toList();

      await sharedPreferences.setString(_notificationsKey, jsonEncode(jsonList));
    }
  }
}

