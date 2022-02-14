import 'package:avatar_view/avatar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/core/utils/utils.dart';
import 'package:it_news/data/models/post_full.dart';
import 'package:it_news/data/repositories/post_repository.dart';
import 'package:it_news/data/repositories/tag_repository.dart';
import 'package:it_news/logic/post/bloc/post_bloc.dart';
import 'package:it_news/logic/tags/bloc/tags_bloc.dart';
import 'package:http/http.dart' as http;

class PostConfigure extends StatelessWidget {
  const PostConfigure({Key? key, required this.postFull}) : super(key: key);
  final PostFull postFull;

  @override
  Widget build(BuildContext context) {
    final httpClient = http.Client();
    return MultiBlocProvider(
      providers: [
        BlocProvider<TagsBloc>(
          create: (_) {
            return TagsBloc(TagRepository(httpClient: httpClient))
              ..add(TagFetchedWithSelection(postFull.tags));
          },
        ),
        BlocProvider<PostBloc>(
          create: (_) {
            return PostBloc(
                postRepository: PostRepository(httpClient: httpClient));
          },
        )
      ],
      child: AccessAndTags(postFull: postFull),
    );
  }
}

class AccessAndTags extends StatefulWidget {
  const AccessAndTags({Key? key, required this.postFull}) : super(key: key);
  final PostFull postFull;

  @override
  _AccessAndTagsState createState() => _AccessAndTagsState();
}

class _AccessAndTagsState extends State<AccessAndTags> {
  var access = ['Nháp', 'Công khai', 'Ẩn link'];
  late String? accessValue;
  late int accessNumber;
  List<int> tagsSelection = [];

  @override
  void initState() {
    super.initState();
    accessNumber = widget.postFull.post.access;
    accessValue = access[accessNumber];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Lựa chọn"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Chọn chế độ bài viết:",
                style: TextStyle(fontSize: 17),
              ),
              DropdownButton(
                value: accessValue,
                items: access.map((e) {
                  return DropdownMenuItem(value: e, child: Text(e));
                }).toList(),
                onChanged: (String? newAccess) {
                  setState(() {
                    accessValue = newAccess;
                    accessNumber = access.indexWhere((e) => e == newAccess);
                  });
                },
                borderRadius: BorderRadius.circular(15),
              ),
            ],
          ),
          const Text(
            "Chọn thẻ (tối thiểu 1, tối đa 5 thẻ):",
            style: TextStyle(fontSize: 17),
          ),
          BlocConsumer<TagsBloc, TagsState>(
            listenWhen: (previous, current) {
              return current.message.isNotEmpty;
            },
            listener: (context, state) {
              Utils.showMessageDialog(
                  context: context, title: "Thông báo", content: state.message);
            },
            builder: (context, state) {
              // Lưu lại danh sách các thẻ đã chọn
              tagsSelection.clear();
              for (int i = 0; i < state.tags.length; i++) {
                if (state.tags[i].isSelected) {
                  tagsSelection.add(state.tags[i].tag.idTag);
                }
              }

              return Wrap(
                spacing: 6,
                children: state.tags.map((tagElement) {
                  return ChoiceChip(
                    label: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 5.0,
                      children: [
                        AvatarView(
                          radius: 12,
                          avatarType: AvatarType.CIRCLE,
                          backgroundColor: Colors.red,
                          imagePath: tagElement.tag.logo,
                          placeHolder: const Icon(
                            Icons.tag,
                            size: 12,
                          ),
                        ),
                        Text(tagElement.tag.name),
                      ],
                    ),
                    selected: tagElement.isSelected,
                    onSelected: (value) {
                      context
                          .read<TagsBloc>()
                          .add(TagSelected(tagElement.tag.idTag));
                    },
                  );
                }).toList(),
              );
            },
          )
        ],
      ),
      floatingActionButton: BlocConsumer<PostBloc, PostState>(
        listenWhen: (previous, current) {
          return current.message.isNotEmpty;
        },
        listener: (context, state) {
          if (state.writeStatus == PostWriteStatus.success) {
            Utils.isEdited = true;
            Navigator.pop(context);

            // Utils.showMessageDialog(
            //   context: context,
            //   title: "Thông báo",
            //   content: state.message,
            //   onOK: () {
            //   },
            // );
          } else {
            Utils.showMessageDialog(
              context: context,
              title: "Thông báo",
              content: state.message,
            );
          }
        },
        builder: (context, state) {
          return ElevatedButton(
            onPressed: () {
              if (state.writeStatus == PostWriteStatus.loading) return;

              if (tagsSelection.isEmpty) {
                Utils.showMessageDialog(
                  context: context,
                  title: "Thông báo",
                  content: "Bài viết phải được gắn ít nhất 1 thẻ!",
                );
                return;
              }

              if (widget.postFull.post.idPost == 0) {
                // Thêm bài mới
                context.read<PostBloc>().add(
                      PostWriteEvent(
                        title: widget.postFull.post.title,
                        content: widget.postFull.post.content,
                        access: accessNumber,
                        tags: tagsSelection,
                      ),
                    );
              } else {
                // Chỉnh sửa bài viết
                context.read<PostBloc>().add(
                      PostUpdatedEvent(
                        idPost: widget.postFull.post.idPost,
                        title: widget.postFull.post.title,
                        content: widget.postFull.post.content,
                        access: accessNumber,
                        tags: tagsSelection,
                      ),
                    );
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                textButton(state.writeStatus),
                if (state.writeStatus == PostWriteStatus.loading)
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3.0,
                      ),
                    ),
                  )
                else
                  const SizedBox(
                    width: 30,
                    height: 30,
                    child: Icon(Icons.arrow_forward_rounded),
                  ),
              ],
            ),
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          );
        },
      ),
    );
  }

  Widget textButton(PostWriteStatus status) {
    String text = "";
    if (status == PostWriteStatus.loading) {
      if (widget.postFull.post.idPost == 0) {
        text = "Đang đăng bài";
      } else {
        text = "Đang cập nhật";
      }
    } else {
      if (widget.postFull.post.idPost == 0) {
        text = "Đăng bài";
      } else {
        text = "Cập nhật";
      }
    }

    return Text(
      text,
      style: const TextStyle(fontSize: 17),
    );
  }
}
