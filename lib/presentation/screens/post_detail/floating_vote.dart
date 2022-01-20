import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/logic/post/bloc/post_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FloatingVote extends StatelessWidget {
  const FloatingVote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostBloc, PostState>(
      buildWhen: (previous, current) {
        return previous.votedStatus != current.votedStatus ||
            previous.post.post.totalVoteUp - previous.post.post.totalVoteDown !=
                current.post.post.totalVoteUp - current.post.post.totalVoteDown;
      },
      listenWhen: (previous, current) {
        return previous.votedStatus != current.votedStatus;
      },
      listener: (context, state) {
        String message;
        switch (state.votedStatus) {
          case PostVoteStatus.voted:
            message = "Thêm vote thành công!";
            break;
          case PostVoteStatus.unvoted:
            message = "Xóa vote thành công!";
            break;
          case PostVoteStatus.failure:
            message = "Có lỗi xảy ra, xin hãy thử lại sau!";
            break;
          default:
            return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(milliseconds: 1500),
          ),
        );
      },
      builder: (context, state) {
        return Column(
          children: [
            state.votedStatus == PostVoteStatus.loadingUp
                ? Material(
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.green,
                    elevation: 4.0,
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: LoadingAnimationWidget.threeRotatingDots(
                        color: Colors.blue,
                        size: 25,
                      ),
                    ),
                  )
                : Material(
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.green,
                    elevation: 4.0,
                    child: IconButton(
                      color: Colors.white,
                      onPressed: () {
                        if (state.votedStatus == PostVoteStatus.loadingUp ||
                            state.votedStatus == PostVoteStatus.loadingDown) {
                          return;
                        }
                        if (state.post.post.voteType == PostVoteAdded.VOTEUP) {
                          // Xóa vote
                          context.read<PostBloc>().add(
                                PostVoteDeleted(
                                  idPost: state.post.post.idPost,
                                  previousVoteType: state.post.post.voteType,
                                ),
                              );
                        } else {
                          // Thêm vote
                          context.read<PostBloc>().add(
                                PostVoteAdded(
                                  idPost: state.post.post.idPost,
                                  voteType: PostVoteAdded.VOTEUP,
                                ),
                              );
                        }
                      },
                      icon: Icon(
                        state.post.post.voteType == PostVoteAdded.VOTEUP
                            ? Icons.arrow_drop_up_sharp
                            : Icons.arrow_circle_up_outlined,
                      ),
                    ),
                  ),
            const SizedBox(height: 5),
            Text(
              (state.post.post.totalVoteUp - state.post.post.totalVoteDown)
                  .toString(),
              style: const TextStyle(color: Colors.green),
            ),
            const SizedBox(height: 5),
            state.votedStatus == PostVoteStatus.loadingDown
                ? Material(
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.green,
                    elevation: 4.0,
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: LoadingAnimationWidget.threeRotatingDots(
                        color: Colors.blue,
                        size: 25,
                      ),
                    ),
                  )
                : Material(
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.green,
                    elevation: 4.0,
                    child: IconButton(
                      color: Colors.white,
                      onPressed: () {
                        if (state.votedStatus == PostVoteStatus.loadingUp ||
                            state.votedStatus == PostVoteStatus.loadingDown) {
                          return;
                        }
                        if (state.post.post.voteType ==
                            PostVoteAdded.VOTEDOWN) {
                          // Xóa vote
                          context.read<PostBloc>().add(
                                PostVoteDeleted(
                                  idPost: state.post.post.idPost,
                                  previousVoteType: state.post.post.voteType,
                                ),
                              );
                        } else {
                          // Thêm vote
                          context.read<PostBloc>().add(
                                PostVoteAdded(
                                  idPost: state.post.post.idPost,
                                  voteType: PostVoteAdded.VOTEDOWN,
                                ),
                              );
                        }
                      },
                      icon: Icon(
                        state.post.post.voteType == PostVoteAdded.VOTEDOWN
                            ? Icons.arrow_drop_down_sharp
                            : Icons.arrow_circle_down_outlined,
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }
}
