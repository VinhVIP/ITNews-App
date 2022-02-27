import 'package:avatar_view/avatar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/core/utils/utils.dart';
import 'package:it_news/logic/tags/bloc/tags_bloc.dart';
import 'package:it_news/logic/tags/models/tag_element.dart';
import 'package:it_news/presentation/router/app_router.dart';
import 'package:it_news/presentation/screens/tags/tag_input_dialog.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TagItem extends StatelessWidget {
  const TagItem({Key? key, required this.tagElement}) : super(key: key);

  final TagElement tagElement;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRouter.postsOfTag,
            arguments: tagElement.tag,
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLogo(),
                _buildTagName(),
                _buildDetails(),
                _buildFollowButton(context),
              ],
            ),
            if (Utils.user.idRole <= 2) _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return AvatarView(
      radius: 35,
      avatarType: AvatarType.RECTANGLE,
      backgroundColor: Colors.red,
      imagePath: tagElement.tag.logo,
      placeHolder: const Icon(
        Icons.tag,
        size: 20,
      ),
    );
  }

  Widget _buildTagName() {
    return Text(
      tagElement.tag.name,
      style: const TextStyle(
        color: Colors.blue,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.post_add,
              size: 18,
            ),
            const SizedBox(width: 5),
            Text('${tagElement.tag.totalPost}'),
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.people,
              size: 18,
            ),
            const SizedBox(width: 5),
            Text('${tagElement.tag.totalFollower}'),
          ],
        ),
      ],
    );
  }

  Widget _buildFollowButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            if (tagElement.followStatus == TagFollowStatus.loading) {
              return;
            }
            if (tagElement.tag.statusFollow) {
              BlocProvider.of<TagsBloc>(context)
                  .add(TagUnFollowed(tagElement.tag.idTag));
            } else {
              BlocProvider.of<TagsBloc>(context)
                  .add(TagFollowed(tagElement.tag.idTag));
            }
          },
          child: tagElement.followStatus == TagFollowStatus.loading
              ? LoadingAnimationWidget.horizontalRotatingDots(
                  color: Colors.yellow,
                  size: 25,
                )
              : Text(
                  tagElement.tag.statusFollow ? "Bỏ theo dõi" : "Theo dõi",
                ),
          style: ElevatedButton.styleFrom(
            primary: tagElement.tag.statusFollow ? Colors.red : Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Column(
        children: [
          IconButton(
            padding: const EdgeInsets.only(top: 5),
            constraints: const BoxConstraints(),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => TagInputDialog(
                  isCreateNew: false,
                  tag: tagElement.tag,
                  ctx: context,
                ),
              );
            },
            icon: const Icon(Icons.edit),
            splashRadius: 20,
            color: Colors.blue,
          ),
          if (Utils.user.idRole == 1) ...[
            IconButton(
              onPressed: () {
                Utils.showMessageDialog(
                    context: context,
                    title: "Xóa thẻ ${tagElement.tag.name} ?",
                    content:
                        "Chỉ những thẻ không có bài viết mới có thể xóa. Bạn chắc chắn muốn xóa thẻ?",
                    onOK: () {
                      BlocProvider.of<TagsBloc>(context)
                          .add(TagDeleted(tagElement.tag.idTag));
                      Navigator.pop(context);
                    });
              },
              icon: const Icon(Icons.delete_forever),
              splashRadius: 20,
              color: Colors.red,
            ),
          ],
        ],
      ),
    );
  }
}
