import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:it_news/data/models/notification.dart';
import 'package:it_news/data/repositories/notification_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _notificationRepository;

  NotificationBloc(this._notificationRepository)
      : super(const NotificationState()) {
    on<NotificationFetched>(_onNotificationFetched);
    on<NotificationReadEvent>(_onNotificationRead);
    on<NotificationDeleted>(_onNotificationDeleted);
    on<NotificationReadAll>(_onNotificationReadAll);
    on<NotificationDeletedAll>(_onNotificationDeteledAll);
    on<NotificationCount>(_onNotificationCountUnread);
    on<NotificationCountUpdated>(onNotificationCountUpdated);
  }

  void _onNotificationCountUnread(
      NotificationCount event, Emitter<NotificationState> emit) async {
    final count = await _notificationRepository.countUnreadNotification();
    emit(state.copyWith(countUnreadNotification: count));
  }

  void onNotificationCountUpdated(
      NotificationCountUpdated event, Emitter<NotificationState> emit) {
    emit(state.copyWith(countUnreadNotification: event.count));
  }

  void _onNotificationFetched(
      NotificationFetched event, Emitter<NotificationState> emit) async {
    emit(state.copyWith(fetchedStatus: NotificationFetchedStatus.loading));

    final List<Notifications>? list =
        await _notificationRepository.getNotifications();

    emit(state.copyWith(
      notifications: list,
      fetchedStatus: NotificationFetchedStatus.success,
    ));
  }

  void _onNotificationRead(
      NotificationReadEvent event, Emitter<NotificationState> emit) async {
    final response =
        await _notificationRepository.readNotification(event.idNotification);
    if (response.statusCode == 200) {
      int index = state.notifications.indexWhere(
          (element) => element.idNotification == event.idNotification);
      Notifications notification =
          state.notifications[index].copyWith(status: 1);
      List<Notifications> list = List.from(state.notifications);
      list.removeAt(index);
      list.insert(index, notification);

      emit(state.copyWith(notifications: list));
    }
  }

  void _onNotificationDeleted(
      NotificationDeleted event, Emitter<NotificationState> emit) async {
    final response =
        await _notificationRepository.deleteNotification(event.idNotification);
    if (response.statusCode == 200) {
      int index = state.notifications.indexWhere(
          (element) => element.idNotification == event.idNotification);
      List<Notifications> list = List.from(state.notifications);
      list.removeAt(index);

      emit(state.copyWith(notifications: list));
    }
  }

  void _onNotificationReadAll(
      NotificationReadAll event, Emitter<NotificationState> emit) async {
    final response = await _notificationRepository.readAllNotification();
    if (response.statusCode == 200) {
      List<Notifications> list = List.from(state.notifications);
      for (int i = 0; i < list.length; i++) {
        list[i] = list[i].copyWith(status: 1);
      }
      emit(state.copyWith(notifications: list));
    }
  }

  void _onNotificationDeteledAll(
      NotificationDeletedAll event, Emitter<NotificationState> emit) async {
    final response = await _notificationRepository.deleteAllNotification();
    if (response.statusCode == 200) {
      emit(state.copyWith(notifications: []));
    }
  }
}
