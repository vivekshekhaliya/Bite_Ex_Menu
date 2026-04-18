import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

enum ToastType { success, error, warning, info }

class ToastMessage {
  static void cherryMessage(
      BuildContext context,
      String label,
      ToastType type,
      ) {
    if (type == ToastType.success) {
      CherryToast.success(
        title: Text(
          label,
          maxLines: 1,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.whiteColor,
          ),
        ),
        height: 60,
        width: MediaQuery.of(context).size.width,
        displayCloseButton: false,
        animationType: AnimationType.fromBottom,
        toastPosition: Position.bottom,
        borderRadius: 16,
        shadowColor: AppColors.darkGunmetalColor,
        backgroundColor: AppColors.darkGunmetalColor,
        animationDuration: Duration(milliseconds: 500),
      ).show(context);
    } else if (type == ToastType.error) {
      CherryToast.error(
        title: Text(
          label,
          maxLines: 1,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.whiteColor,
          ),
        ),
        height: 60,
        width: MediaQuery.of(context).size.width,
        displayCloseButton: false,
        animationType: AnimationType.fromBottom,
        toastPosition: Position.bottom,
        borderRadius: 16,
        shadowColor: AppColors.darkGunmetalColor,
        backgroundColor: AppColors.darkGunmetalColor,
        animationDuration: Duration(milliseconds: 500),
      ).show(context);
    } else if (type == ToastType.warning) {
      CherryToast.warning(
        title: Text(
          label,
          maxLines: 1,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.whiteColor,
          ),
        ),
        height: 60,
        width: MediaQuery.of(context).size.width,
        displayCloseButton: false,
        animationType: AnimationType.fromBottom,
        toastPosition: Position.bottom,
        borderRadius: 16,
        shadowColor: AppColors.darkGunmetalColor,
        backgroundColor: AppColors.darkGunmetalColor,
        animationDuration: Duration(milliseconds: 500),
      ).show(context);
    } else if (type == ToastType.info) {
      CherryToast.info(
        title: Text(
          label,
          maxLines: 1,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.whiteColor,
          ),
        ),
        height: 60,
        width: MediaQuery.of(context).size.width,
        displayCloseButton: false,
        animationType: AnimationType.fromBottom,
        toastPosition: Position.bottom,
        borderRadius: 16,
        shadowColor: AppColors.darkGunmetalColor,
        backgroundColor: AppColors.darkGunmetalColor,
        animationDuration: Duration(milliseconds: 500),
      ).show(context);
    }
  }
}
