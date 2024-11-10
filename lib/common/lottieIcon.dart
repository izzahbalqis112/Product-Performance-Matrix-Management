import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieIcon extends StatelessWidget {
  final String assetPath;
  final bool isSelected;

  LottieIcon({required this.assetPath, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      assetPath,
      repeat: isSelected,
      animate: isSelected,
      height: 40,
      width: 40,
    );
  }
}
