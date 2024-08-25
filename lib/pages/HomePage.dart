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
  double gravity = -2.3;
  double speed = 3;
  double birdWidth = 0.1;
  double birdHeight = 0.1;
  bool isGameStarted = false;
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    [0.6, 0, 4],
    [0.4, 0, 6]
  ];

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
            content: Container(),
            actions: [
              GestureDetector(
                  onTap: resetGame,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        color: Colors.white,
                        child: Text(
                          "PLAY AGAIN",
                          style: TextStyle(color: Colors.grey[700]),
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
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Barrier(
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[0][0],
                          barrierX: barrierX[0],
                          isBottomBarrier: false),
                      Barrier(
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[0][1],
                          barrierX: barrierX[0],
                          isBottomBarrier: false),
                      Barrier(
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[1][0],
                          barrierX: barrierX[0],
                          isBottomBarrier: false),
                      Barrier(
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[1][1],
                          barrierX: barrierX[0],
                          isBottomBarrier: false),
                    ],
                  ),
                ),
              )),
          Container(
            height: 15,
            color: Colors.green,
          ),
          Expanded(
              child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "CURRENT SCORE",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "0",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "HIGH SCORE",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "0",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                )
              ],
            ),
            color: Colors.brown,
          ))
        ]),
      ),
    );
  }
}
