import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';  // Add this import for jsonDecode
// Removed import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../viewmodels/home_viewmodel.dart';
import '../models/user_model.dart';

class AbsenView extends StatefulWidget {
  const AbsenView({Key? key}) : super(key: key);

  @override
  _AbsenViewState createState() => _AbsenViewState();
}

class _AbsenViewState extends State<AbsenView> {
   UserModel? _user;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

   @override
  void initState() {
    super.initState();
    _loadUserData();  
  }



  Future<void> _loadUserData() async {
    final box = await Hive.openBox('userBox');
    final userJson = box.get('user');
    if (userJson != null) {
      final userMap = json.decode(userJson);
      setState(() {
        _user = UserModel.fromJson(userMap);
      });
    }
  }

  Future<String?> _getIpAddress() async {
    try {
      final ip = await Ipify.ipv4();
      return ip;
    } catch (e) {
      print('Error getting IP address: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> _getCoordinateData() async {
    final coordinateBox = Hive.box('coordinateBox');
    final coordString = coordinateBox.get('coordinate_data');
    if (coordString != null) {
      try {
        final Map<String, dynamic> data = Map<String, dynamic>.from(
            await Future.value(jsonDecode(coordString)));
        return data;
      } catch (e) {
        print('Error decoding coordinate_data: $e');
      }
    }
    return null;
  }

  Future<File> _addWatermark(File originalImage, String watermarkText) async {
    final bytes = await originalImage.readAsBytes();
    img.Image? original = img.decodeImage(bytes);

    if (original == null) {
      throw Exception('Failed to decode image');
    }

    // Resize the image with a scale factor to keep maximum dimension ~750px
    final maxDimension = 750;
    int newWidth, newHeight;
    if (original.width > original.height) {
      newWidth = maxDimension;
      newHeight = (original.height * maxDimension / original.width).round();
    } else {
      newHeight = maxDimension;
      newWidth = (original.width * maxDimension / original.height).round();
    }
    final resized = img.copyResize(original, width: newWidth, height: newHeight);

    // Draw watermark background rectangle for contrast on left side only with smaller width
    const padding = 12;
    const watermarkFontSize = 24;
    final lines = watermarkText.split('\n');
    int totalHeight = lines.length * (watermarkFontSize + 8);

    // Define watermark rectangle dimensions: narrow vertical bar on left
    int rectWidth = 200; // limited width to avoid face covering
    int x1 = padding ~/ 2;
    int y1 = resized.height - totalHeight - padding;
    int x2 = x1 + rectWidth;
    int y2 = resized.height - padding ~/ 2;

    img.fillRect(
      resized,
      x1: x1,
      y1: y1,
      x2: x2,
      y2: y2,
      color: img.ColorUint8.rgba(0, 0, 0, 128), // 50% opacity black
    );

    // Draw each line of watermark text along the left side area with shadow
    int y = y1 + 4; // small offset from rectangle top
    for (String line in lines) {
      // Draw shadow (black, offset +1,+1)
      img.drawString(
        resized,
        line,
        font: img.arial24,
        x: x1 + padding,
        y: y + 1,
        color: img.ColorUint8.rgba(0, 0, 0, 200),
      );

      // Draw main text (white, semi-transparent)
      img.drawString(
        resized,
        line,
        font: img.arial24,
        x: x1 + padding,
        y: y,
        color: img.ColorUint8.rgba(255, 255, 255, 180),
      );

      y += watermarkFontSize + 8;
    }
    
    // Get directory path to save image
    final Directory? externalDir = await getExternalStorageDirectory();
    if (externalDir == null) {
      throw Exception("External storage directory not available");
    }
    final String customPath =
        '${externalDir.path}/Pictures/MyCustomApp';
    final Directory customDir = Directory(customPath);

    if (!await customDir.exists()) {
      await customDir.create(recursive: true);
    }

    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final String filePath = '$customPath/IMG_${timestamp}_marked.jpg';
    final File outputFile = File(filePath);

    // Encode jpg with quality 40
    final jpgBytes = img.encodeJpg(resized, quality: 40);
    await outputFile.writeAsBytes(jpgBytes);

    print("trace saved marked image in $filePath");

    return outputFile;
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        // Prepare watermark text
        final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
        final UserModel? user = homeViewModel.user;

        String nip = (user?.nip ?? '').trim();
        print('Debug: user.nip = $nip');
        if (nip.isEmpty) {
          nip = 'N/A';
        }

        String currentYear = DateFormat('yyyy').format(DateTime.now());

        Map<String, dynamic>? coordinateData = await _getCoordinateData();
        print('Debug: coordinateData = $coordinateData');

        String latLong = '';
        if (coordinateData != null &&
            coordinateData['lat'] != null &&
            coordinateData['long'] != null) {
          final lat = coordinateData['lat'].toString().trim();
          final long = coordinateData['long'].toString().trim();
          latLong = '$lat, $long';
        } else if (user != null &&
            user.lat.isNotEmpty &&
            user.long.isNotEmpty) {
          latLong = '${user.lat.trim()}, ${user.long.trim()}';
        }
        latLong = latLong.trim();
        print('Debug: latLong = $latLong');
        if (latLong.isEmpty) {
          latLong = 'N/A';
        }

        String? ipAddress = await _getIpAddress();
        ipAddress ??= ''; // fallback empty string if null
        print('Debug: ipAddress = $ipAddress');

        String watermarkText = '''
Status: absen masuk
IMEI HP: null
APIP: $ipAddress
LAT-LONG: $latLong
TGL-JAM: ${DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())}
NIP: $nip
dhe bdg kab $currentYear
''';

        File watermarkedFile =
            await _addWatermark(File(pickedFile.path), watermarkText);

        setState(() {
          _imageFile = watermarkedFile;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil photo: $e')));
    }
  }

  void _absen() async {
    print('Data-datanya: $_user');
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan ambil photo terlebih dahulu.')));
      return;
    }

    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    final UserModel? user = homeViewModel.user;
    String nip = (user?.nip ?? '').trim();
    if (nip.isEmpty) {
      nip = 'N/A';
    }
    final String filename = 'laporan';
    final String filepath = _imageFile!.path;
    final String tgl = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final int jenisAbsen = 1;

    await homeViewModel.sendAttendanceData(
      filename: filename,
      filepath: filepath,
      nip: nip,
      tgl: tgl,
      jenisAbsen: jenisAbsen,
    );

    print('Data absensi telah dikirim ke ViewModel.');
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Absen berhasil')));
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
        title: const Text('Absen Masuk'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Container(
              height: 250,
              width: double.infinity,
              alignment: Alignment.center,
              child: _imageFile == null
                  ? const Text(
                      'Belum ada photo',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    )
                  : Image.file(_imageFile!, fit: BoxFit.contain),
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
                child: const Text('Absen Masuk'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
