import 'package:flutter/material.dart';

class ModalCommentsHeader extends StatelessWidget {
  const ModalCommentsHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(""),
          ),
        ),
        const Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "Bình luận",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
            ),
          ),
        ),
      ],
    );
  }
}
