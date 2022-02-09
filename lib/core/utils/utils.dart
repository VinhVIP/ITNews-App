import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:it_news/data/models/user.dart';

class Utils {
  static User user = User.empty;

  static int compareDatetime(String s1, String s2) {
    DateFormat dateFormat = DateFormat("dd/MM/yyyy-HH:mm");
    DateTime dt1 = dateFormat.parse(s1);
    DateTime dt2 = dateFormat.parse(s2);
    return dt1.compareTo(dt2);
  }

  static void showMessageDialog({
    required context,
    required String title,
    required String content,
    VoidCallback? onOK,
  }) {
    List<Widget> actions = [];
    if (onOK == null) {
      actions.add(TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('OK'),
      ));
    } else {
      actions.add(TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Hủy'),
      ));
      actions.add(TextButton(
        onPressed: onOK,
        child: const Text('Đồng ý'),
      ));
    }

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        title: Text(title),
        content: Text(content),
        actions: actions,
      ),
    );
  }

  static void showSnackbar({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }
}
