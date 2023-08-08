import 'package:flutter/material.dart';

class AnimationPrac extends StatefulWidget {
  const AnimationPrac({super.key});

  @override
  State<AnimationPrac> createState() => _AnimationPracState();
}

class _AnimationPracState extends State<AnimationPrac> {
  int topBoxFlex = 3;

  int bottomBoxFlex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              onVerticalDragUpdate: (details) {
                int sensitivity = 8;
                if (details.delta.dy > sensitivity) {
                  // Down Swipe
                  setState(() {
                    topBoxFlex = 2;
                    bottomBoxFlex = 3;
                  });
                } else if (details.delta.dy < -sensitivity) {
                  // Up Swipe
                  setState(() {
                    topBoxFlex = 3;
                    bottomBoxFlex = 2;
                  });
                }
              },
              child: AnimatedContainer(
                duration: const Duration(
                  milliseconds: 150
                ),
                curve: Curves.linear,
                height: MediaQuery.of(context).size.height/topBoxFlex,
                margin: const EdgeInsets.all(15),
                color: Colors.lightBlue,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(
                milliseconds: 150
              ),
              height: MediaQuery.of(context).size.height/bottomBoxFlex,
              margin: const EdgeInsets.all(15),
              color: Colors.lightBlue,
            ),
          ],
        )
      ),
    );
  }
}