import 'dart:convert';

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

  Future<dynamic> checkCoordinate({
    required int userId,
    required String latDevice,
    required String longDevice,
  }) async {
    try {
      final response = await _dio.post(
        'http://31.97.222.142:2100/api/check_coordinate',
        data: {
          'user_id': userId,
          'lat_device': latDevice,
          'long_device': longDevice,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.data['success'] == true) {
        final data = response.data['data'];
        if (data is Map<String, dynamic>) {
          return data;
        } else if (data is List) {
          return data;
        } else {
          throw Exception('Unexpected data type from API');
        }
      } else {
        throw Exception(response.data['message'] ?? 'Coordinate check failed');
      }
    } on DioError catch (e) {
      throw Exception('Failed to check coordinate: ${e.message}');
    }
  }

  Future<bool> checkToken(String nip, String token) async {
    try {
      final response = await _dio.post(
        'http://31.97.222.142:2100/api/check_token',
        queryParameters: {
          'username': nip,
          'token': token,
        },
      );
      final data = response.data;
      if (data != null && data is Map<String, dynamic>) {
        return data['active_token'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> postAttendance({
    required int pegawaiId,
    required String tgl,
    required int jenisAttedance,
  }) async {
    try {
      final response = await _dio.post(
        'https://e-absensi.bandungkab.go.id/api/stsAbsenToday',
        data: {
          'pegawai_id': pegawaiId.toString(),
          'tgl': tgl,
          'jenis_attedance': jenisAttedance.toString(),
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return response.data;
        } else if (response.data is String) {
          // Parse string response if needed
          return jsonDecode(response.data) as Map<String, dynamic>;
        } else if (response.data is List) {
          if (response.data.isEmpty) {
            // Return empty map on empty list response to avoid error
            return {};
          } else {
            throw Exception('Unexpected non-empty list response format');
          }
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('API call failed with status: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('Failed to post attendance: ${e.message}');
    }
  }
}
