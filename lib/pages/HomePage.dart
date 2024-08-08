import 'dart:async';

import 'package:flappy_bird/widgets/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double y = 0;

  void jump() {
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        y -= 0.05;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: jump,
      child: Scaffold(
        body: Column(children: [
          Expanded(
              flex: 3,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Stack(
                    children: [Bird(y: y)],
                  ),
                ),
              )),
          Expanded(
              child: Container(
            color: Colors.brown,
          ))
        ]),
      ),
    );
  }
}
