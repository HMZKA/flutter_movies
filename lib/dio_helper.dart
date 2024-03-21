import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;
  static init() {
    dio = Dio(BaseOptions(baseUrl: "https://api.themoviedb.org/3/"));
  }

  static Future<Response?> get(
      {required String path, Map<String, dynamic>? queryParameters}) async {
    return await dio?.get(path, queryParameters: queryParameters);
  }
}
