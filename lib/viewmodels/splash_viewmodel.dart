import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';

class SplashViewModel extends ChangeNotifier {
  final ApiService _apiService;

  SplashViewModel({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool? _isActiveToken;
  bool? get isActiveToken => _isActiveToken;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> checkToken() async {
    _isLoading = true;
    notifyListeners();

    try {
      final box = Hive.box('userBox');
      final userJson = box.get('user');

      if (userJson == null) {
        _setResult(false);
        return;
      }

      final userMap = json.decode(userJson);
      final user = UserModel.fromJson(userMap);

      if (user.nip.isEmpty || user.token.isEmpty) {
        _setResult(false);
        return;
      }

      final isActive = await _apiService
          .checkToken(user.nip, user.token)
          .timeout(const Duration(seconds: 3), onTimeout: () => false);

      _setResult(isActive);
    } catch (e) {
      _setResult(false);
    }
  }


  void _setResult(bool value) {
    _isActiveToken = value;
    _isLoading = false;
    notifyListeners();
  }
}
