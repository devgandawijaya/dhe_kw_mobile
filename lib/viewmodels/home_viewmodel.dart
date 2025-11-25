import 'dart:convert';
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

      if (data != null) {
        final coordinateBox = Hive.box('coordinateBox');
        if (data is List && data.isNotEmpty) {
          await coordinateBox.put('coordinate_data', json.encode(data[0]));
          print('testing 1 ${json.encode(data[0]).toString()}');
        } else if (data is Map) {
          await coordinateBox.put('coordinate_data', json.encode(data));
          print('testing 1 ${json.encode(data).toString()}');
        } else {
          print('Unexpected data format: $data');
        }
      }
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
