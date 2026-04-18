import 'package:flutter/material.dart';
import 'package:menu/view/menu_view/menu_screen.dart';

import '../repository/auth_repository.dart';
import '../res/constants/toast_message.dart';
import '../services/shared_pref_service.dart';

class AuthViewModel with ChangeNotifier {
  bool _loginLoading = false;

  bool get loginLoading => _loginLoading;

  void setLoginLoading(bool value) {
    _loginLoading = value;
    notifyListeners();
  }

  Future<void> signInApi(
      String email, String password, BuildContext context) async {
    setLoginLoading(true);

    try {
      final response = await AuthRepository.signIn(
        email: email,
        password: password,
      );

      setLoginLoading(false);

      /// 🔐 Save token
      SharedPrefService.savePref('token', response['data']);

      ToastMessage.cherryMessage(
        context,
        'Login successful 🎉',
        ToastType.success,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MenuScreen()),
      );
    } catch (e) {
      setLoginLoading(false);

      ToastMessage.cherryMessage(
        context,
        e.toString(),
        ToastType.error,
      );
    }
  }
}