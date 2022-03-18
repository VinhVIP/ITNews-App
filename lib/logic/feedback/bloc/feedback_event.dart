part of 'feedback_bloc.dart';

class FeedbackEvent extends Equatable {
  const FeedbackEvent();

  @override
  List<Object> get props => [];
}

class FeedbacksFetched extends FeedbackEvent {}

class FeedbackRead extends FeedbackEvent {
  final int idFeedback;

  const FeedbackRead(this.idFeedback);
}

class FeedbackDeleted extends FeedbackEvent {
  final int idFeedback;

  const FeedbackDeleted(this.idFeedback);
}
