import 'package:flutter/material.dart';
import 'package:it_news/data/models/feedback.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackDetail extends StatelessWidget {
  const FeedbackDetail({Key? key, required this.feedback}) : super(key: key);
  final MyFeedback feedback;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Chi tiết phản hồi"),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          _subject(),
          _sender(),
          _content(),
          _openMailReply(),
        ],
      ),
    );
  }

  Widget _subject() {
    return Text(
      feedback.subject,
      style: const TextStyle(
          color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _content() {
    return Text(
      feedback.content,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
    );
  }

  Widget _sender() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _menuTitle("Người gửi:"),
              Text("${feedback.realName} - @${feedback.accountName}"),
            ],
          ),
          Row(
            children: [
              _menuTitle("Email:"),
              Text(feedback.email),
            ],
          ),
          Row(
            children: [
              _menuTitle("Thời gian:"),
              Text(
                "${feedback.day} - ${feedback.time}",
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _menuTitle(String text) {
    return SizedBox(
      width: 80,
      child: Text(
        text,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _openMailReply() {
    return Align(
      alignment: Alignment.centerRight,
      child: OutlinedButton(
          onPressed: () {
            _launchGmail();
          },
          child: const Text("Trả lời")),
    );
  }

  void _launchGmail() async {
    String url =
        "mailto:${feedback.email}?subject=Phản hồi: ${feedback.subject}&body=Chào bạn ${feedback.realName}";

    if (!await launch(url)) {
      print("Không thể mở gmail");
    }
  }
}
