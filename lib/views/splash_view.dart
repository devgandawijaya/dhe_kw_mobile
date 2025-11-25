import 'dart:async';

import 'package:flutter/material.dart';

import '../routes.dart';
import '../viewmodels/splash_viewmodel.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late SplashViewModel _viewModel;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _viewModel = SplashViewModel();
    _viewModel.addListener(() {
      if (_viewModel.isLoading == false && !_navigated) {
        _navigated = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_viewModel.isActiveToken == true) {
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            Navigator.pushReplacementNamed(context, Routes.login);
          }
        });
      }
    });
    _viewModel.checkToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Image.asset(
          'assets/dhe.png',
          height: 180,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
