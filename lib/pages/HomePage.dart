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
  double gravity = -2.5;
  double speed = 3;
  bool isGameStarted = false;

  void initGame() {
    isGameStarted = true;
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      height = gravity * time * time + speed * time;
      setState(() {
        y = initPosition - height;
      });
      if (playerLost()) {
        timer.cancel();
        isGameStarted = false;
        _showDialog();
      }

      time += 0.1;
    });
  }

  void resetGame() {
    setState(() {
      y = 0;
      initPosition = 0;
      height = 0;
      time = 0;
      isGameStarted = false;
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog.adaptive(
            title: const Center(
                child: Text(
              "G A M E   O V E R",
              style: TextStyle(
                color: Colors.white,
              ),
            )),
            backgroundColor: Colors.grey,
            content: Container(),
            actions: [],
          );
        });
  }

  bool playerLost() {
    if (y < -1 || y > 1) {
      return true;
    }
    return false;
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
                        child: Text(
                          isGameStarted ? "" : "T A P   T O   P L A Y",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 22),
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
