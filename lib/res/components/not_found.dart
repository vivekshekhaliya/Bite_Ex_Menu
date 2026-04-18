import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants/app_colors.dart';
import 'custom_text.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('empty'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/lotties/not_found.json',
            height: 200,
            width: 200,
          ),
          SizedBox(height: 16),
          CustomText(
            data: 'No data found!',
            fontSize: 24,
            color: AppColors.lightBlueGrayColor,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
