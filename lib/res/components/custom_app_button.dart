import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../constants/app_colors.dart';
import 'custom_text.dart';

class CustomAppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool? isLoading;
  final FocusNode? focusNode;
  const CustomAppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.focusNode,
  });

  @override
  State<CustomAppButton> createState() => _CustomAppButtonState();
}

class _CustomAppButtonState extends State<CustomAppButton> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Focus(
      focusNode: widget.focusNode,
      child: Builder(
        builder: (context) {
          final hasFocus = Focus.of(context).hasFocus;
          return ElevatedButton(
            onPressed: widget.isLoading ?? false ? null : widget.onPressed,
            style: ElevatedButton.styleFrom(
              elevation: hasFocus ? 8 : 0,
              backgroundColor: AppColors.primaryColor,
              disabledBackgroundColor: AppColors.primaryColor,
              fixedSize: Size(size.width, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: widget.isLoading ?? true
                ? Center(
                    child: LoadingAnimationWidget.horizontalRotatingDots(
                      color: AppColors.whiteColor,
                      size: 40,
                    ),
                  )
                : CustomText(
                    data: widget.text,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
          );
        },
      ),
    );
  }
}
