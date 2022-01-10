import 'package:flutter/material.dart';

class TagItem extends StatelessWidget {
  final String tagName;
  const TagItem({Key? key, required this.tagName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.green,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Text(
            tagName,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          )),
    );
  }
}
