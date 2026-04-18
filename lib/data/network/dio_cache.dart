import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:http_cache_hive_store/http_cache_hive_store.dart';
import 'package:path_provider/path_provider.dart';

class DioCache {
  static late CacheOptions options;

  static Future<void> init() async {
    final dir = await getTemporaryDirectory();

    options = CacheOptions(
      store: HiveCacheStore(dir.path),
      policy: CachePolicy.noCache,
    );
  }
}