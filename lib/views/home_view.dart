import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  final String title;

  const HomeView({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        color: Colors.white,
        child: const Center(
          child: SizedBox.shrink(),
        ),
      ),
    );
  }
}
