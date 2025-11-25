import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';

class LoginViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  UserModel? _user;
  UserModel? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _apiService.login(username, password);
      _user = user;

      // Save user data to Hive box as JSON string
      final userBox = Hive.box('userBox');
      final userJson = json.encode(user.toJson());
      await userBox.put('user', userJson);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
