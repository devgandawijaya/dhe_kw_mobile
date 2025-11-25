import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PulangView extends StatefulWidget {
  const PulangView({Key? key}) : super(key: key);

  @override
  _PulangViewState createState() => _PulangViewState();
}

class _PulangViewState extends State<PulangView> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePhoto() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      // Handle errors if needed
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil photo: $e')));
    }
  }

  void _absen() {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan ambil photo terlebih dahulu.')));
      return;
    }
    // Placeholder for attendance logic
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Absen berhasil')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          tooltip: 'Kembali',
        ),
        title: const Text('Absen Pulang'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Container(
                height: 250,
                width: double.infinity,
                alignment: Alignment.center,
                child: _imageFile == null
                    ? const Text(
                        'Belum ada photo',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      )
                    : Image.file(_imageFile!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _takePhoto,
                child: const Text('Ambil Photo'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _absen,
                child: const Text('Absen Pulang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
