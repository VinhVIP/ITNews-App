part of 'notification_bloc.dart';

enum NotificationFetchedStatus { initial, loading, success, failure }

class NotificationState extends Equatable {
  final List<Notifications> notifications;
  final NotificationFetchedStatus fetchedStatus;
  final int countUnreadNotification;

  const NotificationState({
    this.notifications = const <Notifications>[],
    this.fetchedStatus = NotificationFetchedStatus.initial,
    this.countUnreadNotification = 0,
  });

  int countUnread(List<Notifications> notifications) {
    int count = 0;
    for (int i = 0; i < notifications.length; i++) {
      if (notifications[i].status == 0) count++;
    }
    return count;
  }

  @override
  List<Object> get props =>
      [notifications, fetchedStatus, countUnreadNotification];

  NotificationState copyWith({
    List<Notifications>? notifications,
    NotificationFetchedStatus? fetchedStatus,
    int? countUnreadNotification,
  }) {
    int count = 0;

    if (countUnreadNotification == null) {
      if (notifications != null) {
        count = countUnread(notifications);
      }
    } else {
      count = countUnreadNotification;
    }

    return NotificationState(
      notifications: notifications ?? this.notifications,
      fetchedStatus: fetchedStatus ?? this.fetchedStatus,
      countUnreadNotification: count,
    );
  }
}
