import 'dart:convert';
import 'dart:io' show File;

import 'package:dhe/models/absensi_model.dart';
import 'package:dhe/models/attendance_model.dart' show AttendanceModel;
import 'package:dio/dio.dart';
import '../models/lokasi_model.dart' show LokasiModel;
import '../models/user_model.dart';

class ApiService {
  final Dio _dio;

  ApiService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: '', // Set your base URL here if needed
                connectTimeout: const Duration(seconds: 30),
                receiveTimeout: const Duration(seconds: 60),
                sendTimeout: const Duration(seconds: 60),
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


  Future<List<AttendanceModel>> fetchDataAbsen({
    required int pegawaiId,
    required int bulan,
    required int tahun,
  }) async {
    try {
      final response = await _dio.post(
        '/api/dataAbsen',
        data: FormData.fromMap({
          'pegawai_id': pegawaiId.toString(),
          'bulan': bulan.toString(),
          'tahun': tahun.toString(),
        }),
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      final data = response.data;
      if (data == null) return [];

      if (data['status'] == 'success' && data['data'] is List) {
        final list = List<Map<String, dynamic>>.from(data['data']);
        return list.map((e) => AttendanceModel.fromJson(e)).toList();
      } else {
        // Jika server mengembalikan status lain, kembalikan list kosong
        return [];
      }
    } on DioException catch (e) {
      // logging sederhana; caller bisa tangani error lebih lanjut
      throw Exception('ApiService.fetchDataAbsen failed: ${e.message}');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }


  Future<LokasiModel> checkCoordinate({
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
        final dataList = response.data['data'] as List<dynamic>;
        if (dataList.isNotEmpty) {
          // Ambil item pertama dari list
          final userJson = dataList[0] as Map<String, dynamic>;
          return LokasiModel.fromJson(userJson);
        } else {
          throw Exception('No coordinate data available');
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
      ).timeout(const Duration(seconds: 3));;
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


  Future<Map<String, dynamic>> uploadAttendanceImage({
    required String filepath,
    required String filename,
    required String nip,
    required String tgl,
    required int jenisAbsensi,
  }) async {
    try {

      print('Sending absen data to API:');
      print('filename: $filename');
      print('filepath: $filepath');
      print('nip: $nip');
      print('tgl: $tgl');
      print('jenisAbsensi: $jenisAbsensi');


      File file = File(filepath);

      String fileName = file.path.split('/').last;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filepath, filename: fileName),
        "filename": filename,
        "nip": nip,
        "tgl": tgl,
        "jenisAbsensi": jenisAbsensi,
      });

      String curlCommand = '''
curl -X POST "https://e-absensi.bandungkab.go.id/api/UploadImage" \\
  -H "Content-Type: multipart/form-data" \\
  -F "file=@$filepath" \\
  -F "filename=$filename" \\
  -F "nip=$nip" \\
  -F "tgl=$tgl" \\
  -F "jenisAbsensi=$jenisAbsensi"
''';

      print("CURL command:\n$curlCommand");

      final response = await _dio.post(
        "https://e-absensi.bandungkab.go.id/api/UploadImage",
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );


      if (response.statusCode == 200) {
        final data = response.data is Map<String, dynamic>
            ? response.data
            : jsonDecode(response.data);

        if (data['code'] == 200) {
          print("Upload berhasil!");
          print("File URL: ${data['message']}");
          return data; // {'code': 200, 'message': 'URL file'}
        } else {
          print("Upload gagal: ${data['message']}");
          return {'error': data['message']};
        }
      } else {
        print("HTTP error: ${response.statusCode}");
        return {'error': 'HTTP error: ${response.statusCode}'};
      }

    } on DioError catch (e) {
      throw Exception("Upload error: ${e.message}");
    }
  }


  String _mapJenisAbsen(int jenisAbsen) {
    switch (jenisAbsen) {
      case 1:
        return "masuk";
      case 2:
        return "pulang";
      case 3:
        return "lembur_masuk";
      case 4:
        return "lembur_pulang";
      default:
        throw Exception("Jenis absen tidak valid: $jenisAbsen");
    }
  }



  Future<AbsenModel?> sendAttendance({
    required int pegawaiId,
    required String nip,
    required String jenisAbsen,
    required String lat,
    required String lon,
    String apMac = '',
    String apIp = '',
    String mac = '',
    String ip = '',
    String imei = '',
    required String tglJam,
    required String tgl,
    required String dari,
    required String sampai,
    String note = '',
    required int photoSts,
    int filests = 1,
    String fileext = 'pdf',
  }) async {
    try {

      print("=== REQUEST BODY ===");
      print({
        'pegawai_id': pegawaiId.toString(),
        'nip': nip,
        'jenisabsen': jenisAbsen,
        'lat': lat,
        'lon': lon,
        'apmac': apMac,
        'apip': apIp,
        'mac': mac,
        'ip': ip,
        'imei': imei,
        'tgljam': tglJam,
        'tgl': tgl,
        'dari': dari,
        'sampai': sampai,
        'note': note,
        'photosts': photoSts,
        'filests': filests.toString(),
        'fileext': fileext,
      });
      print("======================");


      final response = await _dio.post(
        'https://e-absensi.bandungkab.go.id/api/pnsAbsensi',
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: {
          'pegawai_id': pegawaiId.toString(),
          'nip': nip,
          'jenisabsen': jenisAbsen,
          'lat': lat,
          'lon': lon,
          'apmac': apMac,
          'apip': apIp,
          'mac': mac,
          'ip': ip,
          'imei': imei,
          'tgljam': tglJam,
          'tgl': tgl,
          'dari': dari,
          'sampai': sampai,
          'note': note,
          'photosts': photoSts,
          'filests': filests.toString(),
          'fileext': fileext,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data is Map<String, dynamic>
            ? response.data
            : Map<String, dynamic>.from(response.data);

        // Print response raw ke terminal
        print("Raw response: $data");

        if (data['status'] == 'success' && data['data'] != null) {
          // Mapping ke model
          final absen = AbsenModel.fromJson(data['data']);
          print("Mapped AbsenModel: ${absen.toJson()}");
          return absen;
        } else {
          print("Absen gagal: ${data['msg']}");
          return null;
        }
      } else {
        print("HTTP error: ${response.statusCode}");
        return null;
      }
    } on DioError catch (e) {
      print("Dio error: ${e.message}");
      return null;
    } catch (e) {
      print("Unexpected error: $e");
      return null;
    }
  }



}
