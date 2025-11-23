import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');

      if (userJson == null) {
        _isActiveToken = false;
        _isLoading = false;
        notifyListeners();
        return;
      }

      final userMap = json.decode(userJson) as Map<String, dynamic>;
      final user = UserModel.fromJson(userMap);

      if (user.nip.isEmpty || user.token.isEmpty) {
        _isActiveToken = false;
        _isLoading = false;
        notifyListeners();
        return;
      }

      final isActive =
          await _apiService.checkToken(user.nip, user.token);
      _isActiveToken = isActive;
    } catch (e, stacktrace) {
      _errorMessage = e.toString();
      _isActiveToken = false;
      debugPrint('Error in SplashViewModel.checkToken: $e');
      debugPrint('Stacktrace: $stacktrace');
    }

    _isLoading = false;
    notifyListeners();
  }
}
