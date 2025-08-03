import 'dart:async';
import 'dart:math';

import 'package:flappy_bird/widgets/barrier.dart';
import 'package:flappy_bird/widgets/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //-----------------------------------------
  // Game physics
  //-----------------------------------------
  static double y = 0; // bird vertical position (-1 = top, +1 = bottom)
  double initPosition = y; // initial y when jump starts
  double time = 0; // elapsed time since last jump
  double height = 0; // current height of the parabola
  final double gravity = -1.1; // gravity (acceleration)
  final double velocity = 1.4; // initial jump velocity

  //-----------------------------------------
  // Bird & barriers dimensions (in Alignment space)
  //-----------------------------------------
  final double birdWidth = 0.05; // half width of bird sprite
  final double birdHeight = 0.05; // half height of bird sprite

  //-----------------------------------------
  // Barriers (dynamic lists so we can add/remove)
  //-----------------------------------------
  static const double barrierWidth = 0.2; // half width of barrier
  static const double gapSize = 0.35; // vertical gap the bird must fly through

  /// Horizontal position (x‑value in Alignment coordinates) of each barrier pair.
  /// We keep two pairs that re‑cycle from right to left.
  final List<double> barrierX = [2, 2 + 1.5];

  /// Vertical sizes of [topHeight, bottomHeight] for each barrier pair (fractions of screen height).
  final List<List<double>> barrierHeights = [
    [
      0.6,
      0.6
    ], //   initial dummy values – will be randomised as soon as game starts
    [0.6, 0.6],
  ];

  bool isGameStarted = false;

  //-----------------------------------------
  // Game loop
  //-----------------------------------------
  void startGame() {
    isGameStarted = true;

    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      //------------------- physics --------------
      height = gravity * time * time + velocity * time;
      setState(() => y = initPosition - height);

      //------------------- move barriers --------------
      for (int i = 0; i < barrierX.length; i++) {
        barrierX[i] -= 0.01;

        // When the pair disappears off the left edge, reset it to the right
        // and give it a new random gap position.
        if (barrierX[i] < -1.4) {
          barrierX[i] += 2.8; // distance between the two pairs
          _randomiseBarrierHeights(i);
        }
      }

      //------------------- collision --------------
      if (_birdHitBarrier() || y < -1 || y > 1) {
        timer.cancel();
        isGameStarted = false;
        _showGameOverDialog();
      }

      //------------------- time update --------------
      time += 0.016; // ~60FPS
    });
  }

  //-----------------------------------------
  // Random gap generator
  //-----------------------------------------
  final Random _rand = Random();
  void _randomiseBarrierHeights(int index) {
    // Generate a random top height between 0.2 and 0.6 of the screen height.
    final double top = _rand.nextDouble() * 0.4 + 0.2;
    final double bottom = 1 - top - gapSize;
    barrierHeights[index] = [top, bottom];
  }

  //-----------------------------------------
  // Jump handler
  //-----------------------------------------
  void jump() {
    setState(() {
      time = 0;
      initPosition = y;
    });
  }

  //-----------------------------------------
  // Collision detection
  //-----------------------------------------
  bool _birdHitBarrier() {
    for (int i = 0; i < barrierX.length; i++) {
      // Check horizontal overlap.
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth) {
        // If we are within the x‑range of this barrier pair,
        // ensure the bird is inside the vertical gap. Otherwise, it's a hit!
        final double topLimit = -1 + barrierHeights[i][0];
        final double bottomLimit = 1 - barrierHeights[i][1];
        if (y <= topLimit || y + birdHeight >= bottomLimit) {
          return true;
        }
      }
    }
    return false;
  }

  //-----------------------------------------
  // Reset game
  //-----------------------------------------
  void resetGame() {
    Navigator.pop(context); // close dialog
    setState(() {
      y = 0;
      initPosition = 0;
      height = 0;
      time = 0;
      barrierX[0] = 2;
      barrierX[1] = 2 + 1.5;
      _randomiseBarrierHeights(0);
      _randomiseBarrierHeights(1);
      isGameStarted = false;
    });
  }

  //-----------------------------------------
  // Game over dialog
  //-----------------------------------------
  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog.adaptive(
        backgroundColor: Colors.grey[800],
        title: const Center(
          child: Text(
            'G A M E   O V E R',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: resetGame,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'PLAY AGAIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //-----------------------------------------
  // UI
  //-----------------------------------------
  @override
  Widget build(BuildContext context) {
    // Full screen height is split into -1 (top) to +1 (bottom) => range 2.
    // Convert barrier fractional heights into pixel values for the Barrier widget.
    final double screenHeight = MediaQuery.of(context).size.height / 2;

    return Scaffold(
      body: Column(
        children: [
          // Game area
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                // Bird & taps
                GestureDetector(
                  onTap: isGameStarted ? jump : startGame,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 0),
                    alignment: Alignment(0, y),
                    color: Colors.blue,
                    child: Bird(y: y),
                  ),
                ),

                // Tap to play text
                Align(
                  alignment: const Alignment(0, -0.2),
                  child: isGameStarted
                      ? const SizedBox.shrink()
                      : const Text(
                          'T A P   T O   P L A Y',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),

                // Barrier pair 0
                Align(
                  alignment: Alignment(barrierX[0], -1),
                  child: Barrier(size: screenHeight * barrierHeights[0][0]),
                ),
                Align(
                  alignment: Alignment(barrierX[0], 1),
                  child: Barrier(size: screenHeight * barrierHeights[0][1]),
                ),

                // Barrier pair 1
                Align(
                  alignment: Alignment(barrierX[1], -1),
                  child: Barrier(size: screenHeight * barrierHeights[1][0]),
                ),
                Align(
                  alignment: Alignment(barrierX[1], 1),
                  child: Barrier(size: screenHeight * barrierHeights[1][1]),
                ),
              ],
            ),
          ),

          // Ground
          Container(
            height: 15,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
