import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../main.dart';
import '../../res/constants/app_url.dart';
import '../../res/routes/routes_name.dart';
import '../../services/shared_pref_service.dart';
import 'dio_cache.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppUrl.baseUrl,
      connectTimeout: Duration(seconds: 15),
      receiveTimeout: Duration(seconds: 15),
      sendTimeout: Duration(seconds: 15),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    ),
  );

  static Future<void> init() async {
    dio.interceptors.clear();

    /// 🧠 CACHE INTERCEPTOR (FIRST)
    await DioCache.init();
    dio.interceptors.add(DioCacheInterceptor(options: DioCache.options));

    /// 🔹 AUTH HEADER INTERCEPTOR (FIRST)
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SharedPrefService.getPref('token');
          if (token != null && token.toString().isNotEmpty && token != "null") {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },

        onError: (error, handler) async {
          // ❗ Show error ONLY when retries are exhausted
          if (error.requestOptions.extra['retries_attempted'] == null ||
              error.requestOptions.extra['retries_attempted'] == 2) {
            String? message;

            switch (error.type) {
              case DioExceptionType.connectionTimeout:
              case DioExceptionType.sendTimeout:
              case DioExceptionType.receiveTimeout:
                message = "Internet is too slow. Please try again.";
                break;

              case DioExceptionType.connectionError:
                message = "No internet connection.";
                break;

              case DioExceptionType.badResponse:
                if (error.response?.statusCode == 403 ||
                    error.response?.statusCode == 401) {
                  await SharedPrefService.clearPref('token');
                  await SharedPrefService.clearPref('user');

                  if (navigatorKey.currentContext != null) {
                    Navigator.pushNamedAndRemoveUntil(
                      navigatorKey.currentContext!,
                      RoutesName.signInScreen,
                      (route) => false,
                    );
                  }

                  message = "Session expired. Please login again.";
                }
                break;

              default:
                break;
            }

            if (message != null) {
              error.requestOptions.extra['error_message'] = message;
            }
          }

          return handler.next(error);
        },
      ),
    );

    /// 🔁 RETRY INTERCEPTOR (SECOND)
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        retries: 2,
        retryDelays: const [Duration(seconds: 2), Duration(seconds: 4)],
        retryEvaluator: (error, attempt) {
          // Track retry count
          error.requestOptions.extra['retries_attempted'] = attempt;

          // ✅ Retry ONLY GET requests
          if (error.requestOptions.method != 'GET') return false;

          return error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.connectionError;
        },
      ),
    );

    /// 🪵 LOGGER (LAST)
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 100,
      ),
    );
  }

  /// 🔹 Global Error Formatter
  static String handleError(DioException e) {
    final extraMessage = e.requestOptions.extra['error_message'];
    if (extraMessage != null) {
      return extraMessage;
    }
    if (e.response != null && e.response?.data is Map) {
      return e.response!.data["message"] ?? "Something went wrong";
    }
    return "Something went wrong";
  }
}
