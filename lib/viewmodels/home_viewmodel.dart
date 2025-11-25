import 'dart:convert';
import 'package:dhe/models/lokasi_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:geolocator/geolocator.dart';

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

      _lokasi = lokasi;

      // Save user data to Hive box as JSON string
      final userBox = Hive.box('coordinateBox');
      final userJson = json.encode(data.toJson());
      await userBox.put('coordinate_data', userJson);
      print('coordinateBox :::  ${json.encode(data.toJson())}');

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

  Future<void> sendAttendanceData({
    required String filename,
    required String filepath,
    required String nip,
    required String tgl,
    required int jenisAbsen,
  }) async {
    // Replace package name in filepath
    String modifiedFilePath = filepath.replaceFirst(
      'com.dhe.bedas.dhe',
      'com.diskominfo.daftarhadirelektronik',
    );

    // For now, print the data to console to simulate sending to the backend
    print('Sending absen data to ViewModel:');
    print('filename: $filename');
    print('filepath: $modifiedFilePath');
    print('nip: $nip');
    print('tgl: $tgl');
    print('jenisAbsen: $jenisAbsen');

    // Optionally, you can add API call here later

    // Simulate delay
    await Future.delayed(Duration(milliseconds: 500));
  }
}
