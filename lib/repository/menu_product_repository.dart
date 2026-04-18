import 'package:dio/dio.dart';

import '../data/network/api_client.dart';
import '../res/constants/app_url.dart';

class MenuProductRepository {
  /// GET REQUEST
  static Future<Map<String, dynamic>> getMenuProduct({int page = 1}) async {
    try {
      Response response = await ApiClient.dio.get(
        AppUrl.productUrl,
        queryParameters: {"page": page},
      );

      return response.data;
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }
}
