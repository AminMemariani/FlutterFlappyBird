import 'dart:async';

import 'package:flappy_bird/widgets/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double y = 0;
  double height = 0;
  double initPosition = y;
  double time = 0;
  double gravity = -5;
  double velocity = 3;
  bool isGameStarted = false;

  void initGame() {
    isGameStarted = true;
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      height = gravity * time * time + velocity * time;
      setState(() {
        y = initPosition - height;
      });
      if (y < -1 || y > 1) {
        timer.cancel();
      }
      time += 0.1;
    });
  }

  void jump() {
    setState(() {
      time = 0;
      initPosition = y;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isGameStarted ? jump : initGame,
      child: Scaffold(
        body: Column(children: [
          Expanded(
              flex: 3,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Stack(
                    children: [
                      Bird(y: y),
                      Container(
                        alignment: const Alignment(0, -0.5),
                        child: const Text(
                          "TAP TO PLAY",
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      )
                    ],
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
