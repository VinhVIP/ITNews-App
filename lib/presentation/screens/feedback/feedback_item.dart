import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:it_news/data/models/feedback.dart';
import 'package:it_news/logic/feedback/bloc/feedback_bloc.dart';
import 'package:it_news/presentation/router/app_router.dart';
import 'package:provider/src/provider.dart';

class FeedbackItem extends StatelessWidget {
  const FeedbackItem({Key? key, required this.feedback}) : super(key: key);

  final MyFeedback feedback;

  @override
  Widget build(BuildContext context) {
    return SwipeActionCell(
      key: ValueKey(feedback.idFeedback),
      trailingActions: [
        SwipeAction(
          content: Tooltip(
            message: "Xóa",
            child: IconButton(
              onPressed: () {
                context
                    .read<FeedbackBloc>()
                    .add(FeedbackDeleted(feedback.idFeedback));
              },
              icon: const Icon(Icons.delete),
              color: Colors.red,
              splashRadius: 25,
            ),
          ),
          color: Colors.transparent,
          onTap: (handler) {},
          widthSpace: 50,
        ),
        if (feedback.status == 0) ...[
          SwipeAction(
            content: Tooltip(
              message: "Đánh dấu đã đọc",
              child: IconButton(
                onPressed: () {
                  context
                      .read<FeedbackBloc>()
                      .add(FeedbackRead(feedback.idFeedback));
                },
                icon: const Icon(Icons.check),
                color: Colors.green,
                splashRadius: 25,
              ),
            ),
            color: Colors.transparent,
            onTap: (handler) {},
            widthSpace: 50,
          ),
        ],
      ],
      child: Card(
        color: feedback.status == 0 ? Colors.white : Colors.grey.shade200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: feedback.status == 0 ? 2 : 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Navigator.pushNamed(context, AppRouter.feedbackDetail,
                arguments: feedback);

            context.read<FeedbackBloc>().add(FeedbackRead(feedback.idFeedback));
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feedback.subject,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: feedback.status == 0 ? Colors.green : Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feedback.content,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: feedback.status == 0 ? Colors.green : Colors.grey,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${feedback.day} - ${feedback.time}",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
