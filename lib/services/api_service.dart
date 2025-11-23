import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: '', // Set your base URL here if needed
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
                // Allow both http and https
                // Dio supports both, no extra config needed here
              ),
            );

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioError catch (e) {
      // Handle DioError or rethrow
      throw Exception('Failed to GET $path: ${e.message}');
    }
  }

  // Add other HTTP methods as needed (post, put, delete etc.)
}
