import 'dart:async';
import 'package:flutter/material.dart';
import 'package:menu/services/shared_pref_service.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../repository/auth_repository.dart';
import '../../res/components/custom_text.dart';
import '../../res/constants/app_colors.dart';
import '../../view_model/auth_view_model.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String sessionId = "";
  Timer? timer;

  bool isLoggedIn = false;

  int retryCount = 0;
  int maxRetries = 150;

  int retryCreateCount = 0;
  int maxCreateRetry = 5;

  @override
  void initState() {
    super.initState();
    initQrFlow();
  }

  /// 🔥 INIT FLOW
  Future<void> initQrFlow() async {
    setState(() {
      retryCount = 0;
      sessionId = "";
      isLoggedIn = false;
    });

    try {
      final newSessionId = await AuthRepository.createSession();

      if (!mounted) return;

      setState(() {
        sessionId = newSessionId;
      });

      retryCreateCount = 0;

      startPolling();
    } catch (e) {
      debugPrint("Session create failed ❌: $e");

      retryCreateCount++;

      if (retryCreateCount > maxCreateRetry) {
        debugPrint("Max retry reached ❌");
        return;
      }

      Future.delayed(const Duration(seconds: 2), () {
        initQrFlow();
      });
    }
  }

  /// 🔥 POLLING
  void startPolling() {
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (isLoggedIn) {
        timer.cancel();
        return;
      }

      retryCount++;

      if (retryCount > maxRetries) {
        timer.cancel();

        if (!isLoggedIn) {
          initQrFlow();
        }

        return;
      }

      await checkLoginStatus();
    });
  }

  /// 🔥 CHECK SESSION
  Future<void> checkLoginStatus() async {
    try {
      if (isLoggedIn) return;

      final data = await AuthRepository.checkSession(sessionId);

      if (data["is_logged_in"] == 1 || data["is_logged_in"] == true) {
        isLoggedIn = true;

        timer?.cancel();

        if (!mounted) return;

        final authViewModel =
        Provider.of<AuthViewModel>(context, listen: false);

        int page = int.tryParse(data["page_no"].toString()) ?? 1;

        await SharedPrefService.savePref('page', page);

        authViewModel.signInApi(
          data["email"],
          data["password"],
          context,
        );
      }
    } catch (e) {
      debugPrint("Check session error: $e");
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  /// 🔥 UI
  Widget _buildQrUI() {
    String qrUrl =
        "https://site.biteexchange.com/qr-login?session=$sessionId";

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/app_icon.png',
          height: 300,
        ),

        const SizedBox(height: 20),

        const CustomText(
          data: "Scan to Login",
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),

        const SizedBox(height: 40),

        QrImageView(
          data: qrUrl,
          size: 400,
          backgroundColor: Colors.white,
        ),

        const SizedBox(height: 20),

        const CustomText(
          data: "Use your mobile to scan and login",
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
        ),

        const SizedBox(height: 10),

        const CustomText(
          data: "Waiting for login...",
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: Center(
        child: sessionId.isEmpty
            ? const CircularProgressIndicator()
            : _buildQrUI(),
      ),
    );
  }
}