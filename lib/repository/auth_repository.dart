import 'package:dio/dio.dart';
import '../data/network/api_client.dart';
import '../res/constants/app_url.dart';

class AuthRepository {
  /// 🔐 LOGIN
  static Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      Response response = await ApiClient.dio.post(
        AppUrl.signInUrl,
        data: {
          "email": email,
          "password": password,
        },
      );

      return response.data;
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  /// 🔥 CREATE SESSION (FROM BACKEND)
  static Future<String> createSession() async {
    final response = await ApiClient.dio.post("/create-session");

    return response.data["session_id"];
  }

  /// 🔥 CHECK SESSION
  static Future<Map<String, dynamic>> checkSession(String sessionId) async {
    final response = await ApiClient.dio.get(
      "/check-session",
      queryParameters: {
        "session": sessionId,
      },
      options: Options(
        extra: {"noCache": true},
      ),
    );

    return response.data;
  }
}