import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';

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
        if (data is List && data.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('coordinate_data', json.encode(data[0]));
          print('testing 1 ${json.encode(data[0]).toString()}');
        } else if (data is Map) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('coordinate_data', json.encode(data));
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
}
