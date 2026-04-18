import 'package:flutter/material.dart';

import '../../../res/components/custom_text.dart';
import '../../../res/constants/app_colors.dart';

class MenuHeader extends StatelessWidget {
  final num pageId;
  final String title;
  const MenuHeader({super.key, required this.pageId, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left Line
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.transparentColor,
                        AppColors.whiteColor,
                        AppColors.whiteColor,
                        AppColors.whiteColor,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
              Container(
                height: 44,
                width: 6,
                decoration: BoxDecoration(color: AppColors.whiteColor),
              ),
            ],
          ),
        ),

        SizedBox(width: 30),
        CustomText(
          data: title,
          fontSize: (pageId == 1 || pageId == 2) ? 40 : 38,
          fontWeight: FontWeight.bold,
          color: AppColors.whiteColor,
          textAlign: TextAlign.center,
        ),
        SizedBox(width: 30),

        // Right Line
        Expanded(
          child: Row(
            children: [
              Container(
                height: 44,
                width: 6,
                decoration: BoxDecoration(color: AppColors.whiteColor),
              ),
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.whiteColor,
                        AppColors.whiteColor,
                        AppColors.whiteColor,
                        AppColors.transparentColor,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
