import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants/app_colors.dart';
import 'custom_app_button.dart';
import 'custom_text.dart';
import 'package:audioplayers/audioplayers.dart';

class MarketCrashedModel extends StatefulWidget {
  const MarketCrashedModel({super.key});

  @override
  State<MarketCrashedModel> createState() => _MarketCrashedModelState();
}

class _MarketCrashedModelState extends State<MarketCrashedModel> {
  final AudioPlayer _player = AudioPlayer();
  @override
  void initState() {
    super.initState();

    _playCrashSound();

    /// ✅ Show confetti after dialog builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showConfetti();
    });
  }

  Future<void> _playCrashSound() async {
    await _player.play(AssetSource('sounds/bell_sound.mp3'));
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: size.width / 2,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.jetGrayColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/images/market_crashed.png", height: 180),
            const SizedBox(height: 20),

            CustomText(
              data: "💥 Boom! Market Crashed!",
              fontSize: 24,
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w700,
            ),

            const SizedBox(height: 12),

            CustomText(
              data:
                  "Too many items hit peak price, and the market couldn’t handle it! All prices are now reset this is your chance to order at minimum rates.",
              fontSize: 18,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w400,
              color: AppColors.lightCoolGrayColor,
            ),

            const SizedBox(height: 24),

            CustomAppButton(
              text: 'Order Now',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 🎉 Confetti
  void _showConfetti() {
    final rootContext = Navigator.of(context, rootNavigator: true).context;

    showDialog(
      context: rootContext,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (_) => Center(
        child: Lottie.asset(
          'assets/lotties/confetti_animation.json',
          repeat: false,
          onLoaded: (composition) {
            Future.delayed(composition.duration, () {
              /// ❌ Close confetti dialog
              if (Navigator.canPop(rootContext)) {
                Navigator.pop(rootContext);
              }

              /// ✅ Close main popup also
              if (mounted && Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            });
          },
        ),
      ),
    );
  }
}
