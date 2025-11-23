import 'package:flutter/material.dart';

class MyProfilView extends StatelessWidget {
  const MyProfilView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: const Text(
        'My Profil Page',
        style: TextStyle(fontSize: 24, color: Colors.black),
      ),
    );
  }
}
