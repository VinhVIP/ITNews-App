part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class NotificationFetched extends NotificationEvent {}

class NotificationReadEvent extends NotificationEvent {
  final int idNotification;

  const NotificationReadEvent(this.idNotification);

  @override
  List<Object> get props => [idNotification];
}

class NotificationDeleted extends NotificationEvent {
  final int idNotification;

  const NotificationDeleted(this.idNotification);

  @override
  List<Object> get props => [idNotification];
}

class NotificationReadAll extends NotificationEvent {}

class NotificationDeletedAll extends NotificationEvent {}

class NotificationCount extends NotificationEvent {}

class NotificationCountUpdated extends NotificationEvent {
  final int count;

  const NotificationCountUpdated(this.count);

  @override
  List<Object> get props => [count];
}
