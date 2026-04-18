import 'package:flutter/material.dart';

import '../../res/components/custom_text.dart';
import '../../res/constants/app_colors.dart';
import '../../res/routes/routes_name.dart';
import '../../services/shared_pref_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScaleAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _textOpacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800), // faster overall
    );

    // Logo zoom animation (0 → 1 scale)
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack),
      ),
    );

    // Text slide from right (faster start)
    _textSlideAnimation =
        Tween<Offset>(begin: const Offset(1.2, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
          ),
        );

    // Text fade in
    _textOpacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final token = await SharedPrefService.getPref('token');

    debugPrint(token);

    await Future.delayed(const Duration(seconds: 2));

    if (token != null && token.toString().isNotEmpty) {
      Navigator.pushReplacementNamed(
        context,
        RoutesName.menuScreenOne,
      );
    } else {
      Navigator.pushReplacementNamed(context, RoutesName.signInScreen);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.secondaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 🔥 Logo Zoom Animation
            ScaleTransition(
              scale: _logoScaleAnimation,
              child: Image.asset(
                'assets/images/app_icon.png',
                height: 200,
                width: 250,
                fit: BoxFit.cover,
              ),
            ),

            /// 🚀 Text Slide + Fade Animation
            FadeTransition(
              opacity: _textOpacityAnimation,
              child: SlideTransition(
                position: _textSlideAnimation,
                child: Column(
                  children: [
                    CustomText(
                      data:
                      "Welcome to the BiteEx family\nThe exchange of taste",
                      textAlign: TextAlign.center,
                      fontSize: 18,
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}