import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerAuthor extends StatefulWidget {
  const ShimmerAuthor({Key? key}) : super(key: key);

  @override
  _ShimmerAuthorState createState() => _ShimmerAuthorState();
}

class _ShimmerAuthorState extends State<ShimmerAuthor> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white70,
      highlightColor: Colors.green,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new),
            padding: EdgeInsets.zero,
            color: Colors.white,
            constraints: const BoxConstraints(),
            splashRadius: 18.0,
          ),
          const SizedBox(width: 10),
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 15,
                    color: Colors.white,
                  ),
                  const Text(" • "),
                  Container(
                    width: 70,
                    height: 15,
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                width: 100,
                height: 15,
                color: Colors.white,
              ),
            ],
          )
        ],
      ),
    );
  }
}
