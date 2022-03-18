part of 'feedback_bloc.dart';

enum FeedbacksFetchedStatus { initial, loading, success, failure }

class FeedbackState extends Equatable {
  final List<MyFeedback> feedbacks;
  final FeedbacksFetchedStatus fetchedStatus;
  final String message;

  const FeedbackState({
    this.feedbacks = const <MyFeedback>[],
    this.fetchedStatus = FeedbacksFetchedStatus.initial,
    this.message = "",
  });

  @override
  List<Object> get props => [feedbacks, fetchedStatus, message];

  FeedbackState copyWith({
    List<MyFeedback>? feedbacks,
    FeedbacksFetchedStatus? fetchedStatus,
    String? message,
  }) {
    return FeedbackState(
      feedbacks: feedbacks ?? this.feedbacks,
      fetchedStatus: fetchedStatus ?? this.fetchedStatus,
      message: message ?? "",
    );
  }
}
