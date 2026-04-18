import 'package:flutter/material.dart';

class TvWrapper extends StatelessWidget {
  final Widget child;

  const TvWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            // 🔥 IMPORTANT: swapped values
            width: 1920,
            height: 1080,
            child: RotatedBox(
              quarterTurns: 3, // try 1 if उल्टा
              child: SizedBox(
                width: 1080,
                height: 1920,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}