import 'dart:convert';
import 'dart:ffi';
import 'dart:io' show File;
import 'package:dhe/models/absensi_model.dart';
import 'package:dhe/models/lokasi_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:geolocator/geolocator.dart';
import 'package:network_info_plus/network_info_plus.dart' show NetworkInfo;

import '../models/user_model.dart';
import '../services/api_service.dart';

import 'dart:convert';
import 'package:intl/intl.dart';

class HomeViewModel extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  LokasiModel? _lokasi;
  LokasiModel? get lokasi => _lokasi;

  set user(UserModel? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> fetchAndSaveCoordinates() async {
    if (_user == null) return;

    try {
      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final apiService = ApiService();
      final data = await apiService.checkCoordinate(
        userId: _user!.pegawaiId,
        latDevice: position.latitude.toString(),
        longDevice: position.longitude.toString(),
      );

      _lokasi = data;

      // Save user data to Hive box as JSON string
      final userBox = Hive.box('coordinateBox');
      final userJson = json.encode(data.toJson());
      await userBox.put('coordinate_data', userJson);
      print('coordinateBox :::  $userJson');

    } catch (e) {
      // Optionally handle or log error
      print('testing 2 ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> postAttendance(int jenisAttendance) async {
    if (_user == null) {
      throw Exception('User is not logged in');
    }
    final apiService = ApiService();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    try {
      final response = await apiService.postAttendance(
        pegawaiId: _user!.pegawaiId,
        tgl: today,
        jenisAttedance: jenisAttendance,
      );
      return response;
    } catch (e) {
      throw Exception('Error posting attendance: $e');
    }
  }






  Future<bool> sendAttendanceData({
    required String filename,
    required String filepath,
    required String nip,
    required String tgl,
    required String latlong,
    required String lat,
    required String lon,
    required int jenisAbsen,
  }) async {

    final file = File(filepath);

    // cek apakah file ada
    if (!file.existsSync()) {
      print("File tidak ditemukan: $filepath");
      return false;
    }

    final fileModif = File(filepath);

    // cek apakah file ada
    if (!fileModif.existsSync()) {
      print("File tidak ditemukan: $filepath");
      return false;
    }

    try {
      final result = await ApiService().uploadAttendanceImage(
        filepath: filepath,
        filename: filename,
        nip: nip,
        tgl: tgl,
        jenisAbsensi: jenisAbsen,
      );

      if (result['code'] == 200) {

        print('=== Data Photo ===');
        print('filename: $filename');
        print('filepath: $filepath');
        print('nip: $nip');
        print('tgl: $tgl');
        print('latlong: $latlong');
        print('lat: $lat');
        print('lon: $lon');
        print('jenisAbsen: $jenisAbsen');
        print('=======Photo============');

        return true;
      } else if (result.containsKey('error')) {
        print("Upload gagal: ${result['error']}");
        return false;
      } else {
        print("Upload gagal: Unknown error");
        return false;
      }
    } catch (e) {
      print("Error sendAttendanceData Sini: $e");
      return false;
    }
  }



  Future<bool> sendStoreAbsensiData({
    required int pegawaiId,
    required String nip,
    required String jenisAbsen,
    required String lat,
    required String lon,
    required String apMac,
    required String apIp,
    String mac = '',
    required String ip,
    required String imei,
    required String tglJam,
    required String tgl,
    required String dari,
    required String sampai,
    String note = '',
    int photoSts = 1,
    int filests = 1,
    String fileext = 'pdf',
  }) async {
    try {
      final absen = await ApiService().sendAttendance(
        pegawaiId: pegawaiId,
        nip: nip,
        jenisAbsen: jenisAbsen,
        lat: lat,
        lon: lon,
        apMac: apMac,
        apIp: apIp,
        mac: mac,
        ip: ip,
        imei: imei,
        tglJam: tglJam,
        tgl: tgl,
        dari: dari,
        sampai: sampai,
        note: note,
        photoSts: photoSts,
        filests: filests,
        fileext: fileext,
      );

      if (absen != null) {
        // Print beberapa info penting ke terminal
        print("=== Absensi Berhasil ===");
        print('pegawaiId: $pegawaiId');
        print('nip: $nip');
        print('jenisAbsen: $jenisAbsen');
        print('lat: $lat');
        print('lon: $lon');
        print('apMac: $apMac');
        print('apIp: $apIp');
        print('mac: $mac');
        print('ip: $ip');
        print('imei: $imei');
        print('tglJam: $tglJam');
        print('tgl: $tgl');
        print('dari: $dari');
        print('sampai: $sampai');
        print('note: $note');
        print('photoSts: $photoSts');
        print('filests: $filests');
        print('fileext: $fileext');
        print('===================');


        return true;
      } else {
        print("Absensi gagal atau response null");
        return false;
      }
    } catch (e) {
      print("Error sendAttendanceData Store: $e");
      return false;
    }
  }

}
