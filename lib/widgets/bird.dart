import 'package:flutter/material.dart';

class Bird extends StatelessWidget {
  final double y;
  const Bird({super.key, required this.y});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, y),
      child: Image.asset(
        "assets/bird.png",
        width: 50,
      ),
    );
  }
}
