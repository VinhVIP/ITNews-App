import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:it_news/data/models/feedback.dart';
import 'package:it_news/data/repositories/feedback_repository.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final FeedbackRepository feedbackRepository;

  FeedbackBloc(this.feedbackRepository) : super(const FeedbackState()) {
    on<FeedbacksFetched>(_onFeedbacksFetched);
    on<FeedbackRead>(_onFeedbackRead);
    on<FeedbackDeleted>(_onFeedbackDeleted);
  }

  void _onFeedbacksFetched(
      FeedbacksFetched event, Emitter<FeedbackState> emit) async {
    emit(state.copyWith(fetchedStatus: FeedbacksFetchedStatus.loading));

    final List<MyFeedback>? feedbacks =
        await feedbackRepository.getAllFeedbacks();
    if (feedbacks != null) {
      emit(state.copyWith(
          feedbacks: feedbacks, fetchedStatus: FeedbacksFetchedStatus.success));
    } else {
      emit(state.copyWith(fetchedStatus: FeedbacksFetchedStatus.failure));
    }
  }

  void _onFeedbackRead(FeedbackRead event, Emitter<FeedbackState> emit) async {
    final response = await feedbackRepository.readFeedback(event.idFeedback);
    if (response.statusCode == 200) {
      int index = state.feedbacks
          .indexWhere((element) => element.idFeedback == event.idFeedback);
      MyFeedback feedback = state.feedbacks[index].copyWith(status: 1);
      List<MyFeedback> list = List.from(state.feedbacks);
      list.removeAt(index);
      list.insert(index, feedback);

      emit(state.copyWith(feedbacks: list));
    }
  }

  void _onFeedbackDeleted(
      FeedbackDeleted event, Emitter<FeedbackState> emit) async {
    final response = await feedbackRepository.deletFeedback(event.idFeedback);
    if (response.statusCode == 200) {
      int index = state.feedbacks
          .indexWhere((element) => element.idFeedback == event.idFeedback);
      List<MyFeedback> list = List.from(state.feedbacks);
      list.removeAt(index);

      emit(state.copyWith(feedbacks: list));
    }
  }
}
