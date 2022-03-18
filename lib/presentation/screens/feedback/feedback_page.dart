import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/data/repositories/feedback_repository.dart';
import 'package:it_news/logic/feedback/bloc/feedback_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:it_news/presentation/screens/feedback/feedback_item.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FeedbackBloc(FeedbackRepository(http.Client()))
        ..add(FeedbacksFetched()),
      child: const FeedbackPageList(),
    );
  }
}

class FeedbackPageList extends StatelessWidget {
  const FeedbackPageList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Danh sách phản hồi"),
          backgroundColor: Colors.green,
        ),
        body: BlocBuilder<FeedbackBloc, FeedbackState>(
          builder: (context, state) {
            if (state.fetchedStatus == FeedbacksFetchedStatus.success) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<FeedbackBloc>().add(FeedbacksFetched());
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return FeedbackItem(feedback: state.feedbacks[index]);
                    },
                    itemCount: state.feedbacks.length,
                  ),
                ),
              );
            } else if (state.fetchedStatus == FeedbacksFetchedStatus.failure) {
              return const Center(
                child: Text('Lỗi tải danh sách phản hồi!'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
