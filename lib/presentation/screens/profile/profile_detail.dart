import 'package:avatar_view/avatar_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/core/utils/utils.dart';
import 'package:it_news/data/models/user.dart';
import 'package:it_news/logic/author/bloc/author_bloc.dart';
import 'package:it_news/logic/authors/models/author_element.dart';
import 'package:it_news/presentation/router/app_router.dart';
import 'package:it_news/presentation/screens/profile/followers_page.dart';
import 'package:it_news/presentation/screens/profile/tags_following_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'followings_page.dart';

class ProfileDetail extends StatelessWidget {
  const ProfileDetail({Key? key, required this.authorElement})
      : super(key: key);
  final AuthorElement authorElement;

  void showBottomModal(context, widget) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      builder: (context) => widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // physics: const ScrollPhysics(),
      // shrinkWrap: true,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            authorElement.author.avatar.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: CachedNetworkImage(
                      imageUrl: authorElement.author.avatar,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  )
                : SizedBox(
                    width: 100,
                    height: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Container(
                        color: Colors.greenAccent,
                        child: const Icon(Icons.person),
                      ),
                    ),
                  ),
          ],
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            "${authorElement.author.realName} ${authorElement.author.idRole == 1 ? "(Admin)" : authorElement.author.idRole == 2 ? "(Mod)" : ""}",
            style: TextStyle(
              color: authorElement.author.idRole == 1
                  ? Colors.red
                  : authorElement.author.idRole == 2
                      ? Colors.blue
                      : Colors.green,
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
        ),
        Center(
          child: Text(
            "@${authorElement.author.accountName}",
            style: const TextStyle(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
              fontSize: 16,
            ),
          ),
        ),
        Utils.user.idAccount != authorElement.author.idAccount
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buttonFollow(context),
                  buttonRole(context),
                  lockButton(context),
                ],
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 0, bottom: 4, right: 6),
          child: Column(
            children: [
              DetailItem(title: 'Email', value: authorElement.author.email),
              DetailItem(title: 'Ngày sinh', value: authorElement.author.birth),
              DetailItem(
                  title: 'Giới tính',
                  value: authorElement.author.gender == 0 ? "Nam" : "Nữ"),
              DetailItem(title: 'Cơ quan', value: authorElement.author.company),
              DetailItem(
                  title: 'Ngày tham gia',
                  value: authorElement.author.createDate),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ItemStatistics(
              color: Colors.blue,
              icon: Icons.post_add,
              num: authorElement.author.totalPost,
              description: "Bài viết",
              onPress: () {
                Navigator.of(context).pushNamed(
                  AppRouter.postsOfAuthor,
                  arguments: authorElement.author,
                );
              },
            ),
            ItemStatistics(
              color: Colors.green,
              icon: Icons.star,
              num: authorElement.author.totalVoteUp -
                  authorElement.author.totalVoteDown,
              description: "Điểm vote",
              onPress: () {},
            ),
            ItemStatistics(
              color: Colors.indigo,
              icon: Icons.remove_red_eye,
              num: authorElement.author.totalView,
              description: "Lượt xem",
              onPress: () {},
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ItemStatistics(
              color: Colors.pink,
              icon: Icons.people,
              num: authorElement.author.totalFollower,
              description: "Follower",
              onPress: () {
                showBottomModal(
                    context, FollowersPage(author: authorElement.author));
              },
            ),
            ItemStatistics(
              color: Colors.orange,
              icon: Icons.person_add_alt_1,
              num: authorElement.author.totalFollowing,
              description: "Following",
              onPress: () {
                showBottomModal(
                    context, FollowingsPage(author: authorElement.author));
              },
            ),
            ItemStatistics(
              color: Colors.brown,
              icon: Icons.tag,
              num: authorElement.author.totalTagFollow,
              description: "Thẻ",
              onPress: () {
                showBottomModal(
                    context, TagsFollowingPage(author: authorElement.author));
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget lockButton(BuildContext context) {
    if (Utils.user.idRole == 3 ||
        Utils.user.idRole >= authorElement.author.idRole) {
      return Container();
    }
    return IconButton(
      onPressed: () {
        if (authorElement.author.accountStatus != 0) {
          Utils.showMessageDialog(
              context: context,
              title: "Mở khóa tài khoản",
              content:
                  "Tài khoản này đang bị khóa ${authorElement.author.accountStatus == 1 ? "tạm thời" : "vĩnh viễn"}. Bạn muốn mở khóa tài khoản này?",
              onOK: () {
                BlocProvider.of<AuthorBloc>(context)
                    .add(AuthorUnlocked(authorElement.author.idAccount));
                Navigator.pop(context);
              });
        } else {
          showDialog(
              context: context,
              builder: (_) => _Lock(
                    author: authorElement.author,
                    ctx: context,
                  ));
        }
      },
      icon: authorElement.author.accountStatus == 0
          ? const Icon(Icons.lock_open)
          : authorElement.author.accountStatus == 1
              ? const Icon(Icons.lock_clock_outlined)
              : const Icon(Icons.lock),
      splashRadius: 20,
    );
  }

  Widget buttonRole(BuildContext context) {
    if (Utils.user.idRole != 1 || authorElement.author.idRole == 1) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: OutlinedButton(
        child: Text(
          authorElement.author.role,
          style: TextStyle(
              color: authorElement.author.idRole == 2
                  ? Colors.blue
                  : Colors.green),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: const Text("Đổi chức vụ"),
                  content: const Text("Chọn chức vụ muốn thay đổi thành"),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<AuthorBloc>(context).add(
                          AuthorRoleChanged(
                            idAccount: authorElement.author.idAccount,
                            role: 2,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: const Text("Moder"),
                      style: ElevatedButton.styleFrom(primary: Colors.blue),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<AuthorBloc>(context).add(
                          AuthorRoleChanged(
                            idAccount: authorElement.author.idAccount,
                            role: 3,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: const Text("User"),
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                    ),
                  ],
                );
              });
        },
      ),
    );
  }

  Widget buttonFollow(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (authorElement.followStatus == AuthorFollowStatus.loading) {
          return;
        }
        if (authorElement.author.followStatus) {
          BlocProvider.of<AuthorBloc>(context)
              .add(AuthorUnFollowed(authorElement.author.idAccount));
        } else {
          BlocProvider.of<AuthorBloc>(context)
              .add(AuthorFollowed(authorElement.author.idAccount));
        }
      },
      child: authorElement.followStatus == AuthorFollowStatus.loading
          ? LoadingAnimationWidget.horizontalRotatingDots(
              color: Colors.yellow,
              size: 25,
            )
          : Text(
              authorElement.author.followStatus ? "Đang theo dõi" : "Theo dõi",
            ),
      style: ElevatedButton.styleFrom(
        primary: authorElement.author.followStatus
            ? Colors.lightBlueAccent
            : Colors.blue,
      ),
    );
  }
}

class _Lock extends StatefulWidget {
  final User author;
  final BuildContext ctx;

  const _Lock({
    Key? key,
    required this.author,
    required this.ctx,
  }) : super(key: key);

  @override
  State<_Lock> createState() => _LockState();
}

class _LockState extends State<_Lock> {
  late int? lockType;
  final TextEditingController _controllerReason = TextEditingController();
  final TextEditingController _controllerHoursLock = TextEditingController();

  String? errHours, errReason;

  @override
  void initState() {
    super.initState();
    lockType = 1;
  }

  void lockTime() {
    if (_controllerReason.text.isEmpty) {
      setState(() {
        errReason = " Lý do khóa không được bỏ trống!";
      });
      return;
    }

    if (_controllerHoursLock.text.isEmpty) {
      setState(() {
        errHours = " Thời gian khóa không được bỏ trống!";
      });
      return;
    }

    try {
      int time = int.parse(_controllerHoursLock.text);

      BlocProvider.of<AuthorBloc>(widget.ctx).add(
        AuthorLockedTime(
          idAccount: widget.author.idAccount,
          reason: _controllerReason.text.trim(),
          hoursLock: time,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        errHours = "Định dạng giờ không hợp lệ!";
      });
    }
  }

  void lockForever() {
    if (_controllerReason.text.isEmpty) {
      setState(() {
        errReason = " Lý do khóa không được bỏ trống!";
      });
      return;
    }

    BlocProvider.of<AuthorBloc>(widget.ctx).add(
      AuthorLockedForever(
        idAccount: widget.author.idAccount,
        reason: _controllerReason.text.trim(),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
          height: 390,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Khóa tài khoản",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: const Text('Khóa tạm thời'),
                leading: Radio(
                  value: 1,
                  groupValue: lockType,
                  onChanged: (int? value) {
                    setState(() {
                      lockType = value;
                    });
                  },
                ),
              ),
              Utils.user.idRole == 1
                  ? ListTile(
                      title: const Text('Khóa vĩnh viễn'),
                      leading: Radio(
                        value: 2,
                        groupValue: lockType,
                        onChanged: (int? value) {
                          setState(() {
                            lockType = value;
                            _controllerHoursLock.text = "";
                          });
                        },
                      ),
                    )
                  : Container(),
              TextField(
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      errReason = " Lý do khóa không được bỏ trống!";
                    });
                  } else {
                    setState(() {
                      errReason = null;
                    });
                  }
                },
                controller: _controllerReason,
                decoration: InputDecoration(
                  labelText: "Lý do khóa",
                  errorText: errReason,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  if (value.isEmpty && lockType == 1) {
                    setState(() {
                      errHours = "Thời gian khóa không được bỏ trống!";
                    });
                  } else {
                    setState(() {
                      errHours = null;
                    });
                  }
                },
                controller: _controllerHoursLock,
                enabled: lockType == 1,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Thời gian khóa (giờ)",
                  errorText: errHours,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    if (lockType == 1) {
                      // Khóa tạm thời
                      lockTime();
                    } else {
                      // Khóa vĩnh viễn
                      lockForever();
                    }
                  },
                  child: const Text("Khóa")),
            ],
          )),
    );
  }
}

class DetailItem extends StatelessWidget {
  const DetailItem({Key? key, required this.title, required this.value})
      : super(key: key);
  final String title, value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.arrow_right,
          color: Colors.green,
        ),
        SizedBox(
          width: 120,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        value.isNotEmpty
            ? Flexible(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.blue,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            : const Flexible(
                child: Text(
                  '(Trống)',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
      ],
    );
  }
}

class ItemStatistics extends StatelessWidget {
  const ItemStatistics({
    Key? key,
    required this.color,
    required this.icon,
    required this.num,
    required this.description,
    required this.onPress,
  }) : super(key: key);

  final Color color;
  final IconData icon;
  final int num;
  final String description;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      width: 75,
      height: 100,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: onPress,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                icon,
                size: 20,
                color: Colors.amberAccent,
              ),
              Text(
                '$num',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
