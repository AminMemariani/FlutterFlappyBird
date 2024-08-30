import 'dart:async';

import 'package:flappy_bird/widgets/barrier.dart';
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
  double gravity = -1.1;
  double speed = 1.4;
  double birdWidth = 0.1;
  double birdHeight = 0.1;
  bool isGameStarted = false;
  double oddBarrierX = 1;
  double evenBarrierX = 2.4;
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    [0.6, 0, 4],
    [0.4, 0, 6]
  ];

  void initGame() {
    isGameStarted = true;
    Timer.periodic(const Duration(milliseconds: 60), (timer) {
      height = gravity * time * time + speed * time;
      setState(() {
        y = initPosition - height;
      });
      setState(() {
        if (oddBarrierX < -1.3) {
          oddBarrierX += 2.4;
        } else {
          oddBarrierX -= 0.01;
        }
      });
      setState(() {
        if (evenBarrierX < -1.3) {
          evenBarrierX += 2.4;
        } else {
          evenBarrierX -= 0.01;
        }
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
    Navigator.pop(context);
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
            backgroundColor: Colors.grey[700],
            actions: [
              GestureDetector(
                  onTap: resetGame,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Text(
                          "PLAY AGAIN",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 18,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                  ))
            ],
          );
        });
  }

  bool playerLost() {
    if (y < -1 || y > 1) {
      return true;
    }
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
              barrierX[i] + barrierWidth >= -birdHeight &&
              (y <= -1 + barrierHeight[i][0]) ||
          y + birdHeight >= 1 - barrierHeight[i][1]) {
        return true;
      }
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
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 3,
              child: Stack(children: [
                GestureDetector(
                  onTap: isGameStarted ? jump : initGame,
                  child: AnimatedContainer(
                    color: Colors.blue,
                    duration: const Duration(milliseconds: 0),
                    alignment: Alignment(0, y),
                    child: Bird(y: y),
                  ),
                ),
                Container(
                  alignment: const Alignment(0, -0.3),
                  child: isGameStarted
                      ? const Text("")
                      : const Text(
                          "T A P   T O   P L A Y",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 0),
                  alignment: Alignment(oddBarrierX, -1),
                  child: const Barrier(size: 160),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 0),
                  alignment: Alignment(oddBarrierX, 1),
                  child: const Barrier(size: 240),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 0),
                  alignment: Alignment(evenBarrierX, -1),
                  child: const Barrier(size: 120),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 0),
                  alignment: Alignment(evenBarrierX, 1),
                  child: const Barrier(size: 280),
                ),
              ])),
          Container(
            height: 15,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
