import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatefulWidget {
  final String? data;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final TextDecorationStyle? decorationStyle;
  final double? decorationThickness;
  final TextAlign? textAlign;
  final double? height;
  final double? letterSpacing;
  final EdgeInsetsGeometry? padding;
  const CustomText({
    super.key,
    this.data,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.overflow,
    this.maxLines,
    this.decoration,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
    this.textAlign,
    this.height,
    this.letterSpacing,
    this.padding,
  });

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(0.0),
      child: Text(
        '${widget.data}',
        overflow: widget.overflow,
        maxLines: widget.maxLines,
        textAlign: widget.textAlign,
        style: GoogleFonts.inter(
          color: widget.color,
          height: widget.height,
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
          decoration: widget.decoration,
          decorationColor: widget.decorationColor,
          decorationStyle: widget.decorationStyle,
          decorationThickness: widget.decorationThickness,
          letterSpacing: widget.letterSpacing,
        ),
      ),
    );
  }
}
