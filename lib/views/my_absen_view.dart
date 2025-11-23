import 'package:flutter/material.dart';

class MyAbsenView extends StatelessWidget {
  const MyAbsenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: const Text(
        'My Absen Page',
        style: TextStyle(fontSize: 24, color: Colors.black),
      ),
    );
  }
}
