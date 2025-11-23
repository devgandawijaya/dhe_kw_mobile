import 'package:dio/dio.dart';
import '../models/user_model.dart';

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

  Future<UserModel> login(String username, String password) async {
    try {
      final response = await _dio.post(
        'http://31.97.222.142:2100/api/login',
        data: {
          'username': username,
          'password': password,
        },
        options: Options(contentType: Headers.jsonContentType),
      );
      if (response.data['success'] == true) {
        final userJson = response.data['user'];
        return UserModel.fromJson(userJson);
      } else {
        throw Exception(response.data['message'] ?? 'Login failed');
      }
    } on DioError catch (e) {
      throw Exception('Failed to login: ${e.message}');
    }
  }
}
