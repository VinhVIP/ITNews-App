import 'package:avatar_view/avatar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/logic/tags/bloc/tags_bloc.dart';
import 'package:it_news/logic/tags/models/tag_element.dart';
import 'package:it_news/presentation/router/app_router.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AvatarView(
              radius: 35,
              avatarType: AvatarType.RECTANGLE,
              backgroundColor: Colors.red,
              imagePath: tagElement.tag.logo,
              placeHolder: const Icon(
                Icons.tag,
                size: 20,
              ),
            ),
            Text(
              tagElement.tag.name,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
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
            ),
            ElevatedButton(
              onPressed: () {
                if (tagElement.followStatus == TagFollowStatus.loading) return;
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
        ),
      ),
    );
  }
}
