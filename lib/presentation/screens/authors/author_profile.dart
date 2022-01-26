import 'package:flutter/material.dart';
import 'package:it_news/data/models/user.dart';
import 'package:it_news/presentation/screens/profile/profile_detail.dart';

class AuthorProfile extends StatelessWidget {
  const AuthorProfile({Key? key, required this.author}) : super(key: key);
  final User author;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tác giả'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ProfileDetail(account: author),
      ),
    );
  }
}
