import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppCustomFlipText extends StatelessWidget {
  final num value;
  final String? prefix;
  final String? suffix;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextDecoration? decoration;
  const AppCustomFlipText({
    super.key,
    required this.value,
    this.prefix,
    this.suffix,
    this.fontSize,
    this.fontWeight,
    this.color, this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedFlipCounter(
      value: value,
      prefix: prefix,
      suffix: suffix,
      textStyle: GoogleFonts.inter(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          decoration: decoration
      ),
    );
  }
}
