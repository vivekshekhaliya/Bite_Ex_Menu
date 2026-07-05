import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF4AAD52);
  // static const Color primaryColor = Color(0xFF1DA15B);
  static const Color secondaryColor = Color(0xFF181A20);
  static const Color midnightBlueColor = Color(0xFF162445);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color blackColor = Color(0xFF000000);
  static const Color blueColor = Color(0xFF2B8CEE);
  static const Color slateGrayColor = Color(0xFF4E5059);
  static const Color lightBlueGrayColor = Color(0xFFDCE0E3);
  static const Color coolGrayColor = Color(0xFF81838A);
  static const Color darkSlateGrayColor = Color(0xFF373A43);
  static const Color darkGunmetalColor = Color(0xFF212327);
  static const Color transparentColor = Color(0xFF00000000);
  static const Color jetGrayColor = Color(0xFF2C2E33);
  static const Color crimsonRedColor = Color(0xFFFF2E2E);
  // static const Color crimsonRedColor = Color(0xFFDB1025);
  // static const Color crimsonRedColor = Color(0xFFDC3035);
  static const Color orangeColor = Color(0xFFEF7C09);
  static const Color coolGrayBlueColor = Color(0xFF667085);
  static const Color lightCoolGrayColor = Color(0xFFB7B8BC);

  static Color parsePriceColor(String? colorStr, {Color fallback = coolGrayColor}) {
    if (colorStr == null || colorStr.isEmpty) {
      return fallback;
    }
    final cleanStr = colorStr.trim().toLowerCase();
    if (cleanStr == 'red' || cleanStr == 'crimson' || cleanStr.contains('red')) {
      return crimsonRedColor;
    }
    if (cleanStr == 'green' || cleanStr == 'primary' || cleanStr.contains('green')) {
      return primaryColor;
    }
    if (cleanStr == 'gray' || cleanStr == 'grey' || cleanStr.contains('gray') || cleanStr.contains('grey')) {
      return fallback;
    }
    try {
      String hexColor = cleanStr.replaceAll('#', '');
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor';
      }
      if (hexColor.startsWith('0x')) {
        hexColor = hexColor.substring(2);
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (_) {
      return fallback;
    }
  }
}
