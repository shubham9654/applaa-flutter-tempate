import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notifications_repository.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsRepository notificationsRepository;

  NotificationsBloc(this.notificationsRepository) : super(NotificationsInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkAsRead>(_onMarkAsRead);
    on<GetFCMToken>(_onGetFCMToken);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsLoading());
    try {
      final notifications = await notificationsRepository.getNotifications();
      emit(NotificationsLoaded(notifications));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  Future<void> _onMarkAsRead(
    MarkAsRead event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      await notificationsRepository.markAsRead(event.notificationId);
      final notifications = await notificationsRepository.getNotifications();
      emit(NotificationsLoaded(notifications));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  Future<void> _onGetFCMToken(
    GetFCMToken event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      final token = await notificationsRepository.getFCMToken();
      emit(FCMTokenLoaded(token ?? ''));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }
}

