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
              DetailItem(title: 'Ng??y sinh', value: authorElement.author.birth),
              DetailItem(
                  title: 'Gi???i t??nh',
                  value: authorElement.author.gender == 0 ? "Nam" : "N???"),
              DetailItem(title: 'C?? quan', value: authorElement.author.company),
              DetailItem(
                  title: 'Ng??y tham gia',
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
              description: "B??i vi???t",
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
              description: "??i???m vote",
              onPress: () {},
            ),
            ItemStatistics(
              color: Colors.indigo,
              icon: Icons.remove_red_eye,
              num: authorElement.author.totalView,
              description: "L?????t xem",
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
              description: "Th???",
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
              title: "M??? kh??a t??i kho???n",
              content:
                  "T??i kho???n n??y ??ang b??? kh??a ${authorElement.author.accountStatus == 1 ? "t???m th???i" : "v??nh vi???n"}. B???n mu???n m??? kh??a t??i kho???n n??y?",
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
                  title: const Text("?????i ch???c v???"),
                  content: const Text("Ch???n ch???c v??? mu???n thay ?????i th??nh"),
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
              authorElement.author.followStatus ? "??ang theo d??i" : "Theo d??i",
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
        errReason = " L?? do kh??a kh??ng ???????c b??? tr???ng!";
      });
      return;
    }

    if (_controllerHoursLock.text.isEmpty) {
      setState(() {
        errHours = " Th???i gian kh??a kh??ng ???????c b??? tr???ng!";
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
        errHours = "?????nh d???ng gi??? kh??ng h???p l???!";
      });
    }
  }

  void lockForever() {
    if (_controllerReason.text.isEmpty) {
      setState(() {
        errReason = " L?? do kh??a kh??ng ???????c b??? tr???ng!";
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
                "Kh??a t??i kho???n",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: const Text('Kh??a t???m th???i'),
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
                      title: const Text('Kh??a v??nh vi???n'),
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
                      errReason = " L?? do kh??a kh??ng ???????c b??? tr???ng!";
                    });
                  } else {
                    setState(() {
                      errReason = null;
                    });
                  }
                },
                controller: _controllerReason,
                decoration: InputDecoration(
                  labelText: "L?? do kh??a",
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
                      errHours = "Th???i gian kh??a kh??ng ???????c b??? tr???ng!";
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
                  labelText: "Th???i gian kh??a (gi???)",
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
                      // Kh??a t???m th???i
                      lockTime();
                    } else {
                      // Kh??a v??nh vi???n
                      lockForever();
                    }
                  },
                  child: const Text("Kh??a")),
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
                  '(Tr???ng)',
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
