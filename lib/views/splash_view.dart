import 'dart:async';
import 'package:flutter/material.dart';
import '../routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      // Navigate to login page after 3 seconds
      Navigator.pushReplacementNamed(context, Routes.login);
    });
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
