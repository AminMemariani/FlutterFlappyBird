import 'package:flutter/material.dart';

class Barrier extends StatelessWidget {
  final double size;

  const Barrier({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: size,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          gradient: LinearGradient(colors: [
            Colors.green.shade400,
            Colors.green.shade100,
            Colors.green.shade400
          ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
    );
  }
}
