import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:async';

import 'package:dhe/models/lokasi_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../viewmodels/home_viewmodel.dart';
import '../models/user_model.dart';

class AbsenView extends StatefulWidget {
  const AbsenView({Key? key, this.skpdId}) : super(key: key);
  final int? skpdId;

  @override
  State<AbsenView> createState() => _AbsenViewState();
}

class _AbsenViewState extends State<AbsenView> {
  UserModel? _user;
  LokasiModel? _lokasiModel;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  int? skpdId;

  @override
  void initState() {
    super.initState();
    skpdId = widget.skpdId;
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (skpdId == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is int) skpdId = args;
    }
  }

  Future<void> _loadUserData() async {
    final userBox = await Hive.openBox('userBox');
    final coordBox = await Hive.openBox('coordinateBox');

    final userJson = userBox.get('user');
    final coordJson = coordBox.get('coordinate_data');

    if (userJson != null) {
      final map = json.decode(userJson);
      _user = UserModel.fromJson(map);
    }

    if (coordJson != null) {
      final map = json.decode(coordJson);
      _lokasiModel = LokasiModel.fromJson(map);
    }

    if (mounted) setState(() {});
  }

  Future<String?> _getIpAddress() async {
    try {
      return await Ipify.ipv4();
    } catch (e) {
      return "Tidak terdeteksi";
    }
  }

  String getAbsenType(int? id) {
    switch (id) {
      case 1:
        return "Absen Masuk";
      case 2:
        return "Absen Pulang";
      default:
        return "Absen";
    }
  }

  // ==================== WATERMARK + DECODE AMAN ====================
  Future<File> _addWatermark(File originalImage, String watermarkText) async {
    final Uint8List bytes = await originalImage.readAsBytes();

    // DECODE GAMBAR – 100% AMAN (support HEIC, WebP, dll)
    final img.Image? image = await _decodeImageSafely(bytes);
    if (image == null) {
      throw Exception("Gagal membaca gambar. Format tidak didukung atau file rusak.");
    }

    // Resize max 750px
    final maxDim = 750;
    img.Image resized = image;
    if (image.width > maxDim || image.height > maxDim) {
      resized = image.width > image.height
          ? img.copyResize(image, width: maxDim)
          : img.copyResize(image, height: maxDim);
    }

    // Background watermark (sisi kiri)
    const padding = 16;
    const fontSize = 26;
    final lines = watermarkText
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final lineHeight = fontSize + 10;
    final totalTextHeight = lines.length * lineHeight;

    final rectWidth = 240;
    final rectX1 = padding ~/ 2;
    final rectY1 = resized.height - totalTextHeight - padding * 2;
    final rectX2 = rectX1 + rectWidth;
    final rectY2 = resized.height - padding;

    img.fillRect(
      resized,
      x1: rectX1,
      y1: rectY1,
      x2: rectX2,
      y2: rectY2,
      color: img.ColorUint8.rgba(0, 0, 0, 150), // semi-transparan hitam
    );

    // Tulis teks dengan shadow
    int y = rectY1 + padding;
    for (String line in lines) {
      // Shadow
      img.drawString(resized, line,
          font: img.arial24,
          x: rectX1 + padding + 1,
          y: y + 1,
          color: img.ColorUint8.rgba(0, 0, 0, 200));

      // Teks utama
      img.drawString(resized, line,
          font: img.arial24,
          x: rectX1 + padding,
          y: y,
          color: img.ColorUint8.rgba(255, 255, 255, 240));

      y += lineHeight;
    }

    // Simpan file
    final String saveDir = await _getSaveDirectory();
    final String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final String fileName = 'ABSEN_${timestamp}_wm.jpg';
    final String fullPath = path.join(saveDir, fileName);

    final jpgBytes = img.encodeJpg(resized, quality: 88);
    final File finalFile = File(fullPath);
    await finalFile.writeAsBytes(jpgBytes);

    print("Foto watermark selesai → $fullPath");
    return finalFile;
  }

  // DECODE GAMBAR DENGAN FALLBACK KE FLUTTER ENGINE (PASTI BISA!)
  Future<img.Image?> _decodeImageSafely(Uint8List bytes) async {
    // 1. Coba package image (v4+ sudah support HEIC & WebP)
    var image = img.decodeImage(bytes);
    if (image != null) return image;

    // 2. Coba decode manual
    image = img.decodeJpg(bytes) ??
        img.decodePng(bytes) ??
        img.decodeWebP(bytes) ??
        img.decodeGif(bytes) ??
        img.decodeBmp(bytes);
    if (image != null) return image;

    // 3. Fallback terakhir: Flutter native decoder
    try {
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final uiImage = frame.image;

      final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;

      final pngBytes = byteData.buffer.asUint8List();
      return img.decodePng(pngBytes);
    } catch (e) {
      print("Semua decode gagal: $e");
      return null;
    }
  }

  // Folder simpan (Android + iOS)
  Future<String> _getSaveDirectory() async {
    Directory? baseDir;
    if (Platform.isAndroid) {
      baseDir = await getExternalStorageDirectory();
      baseDir ??= Directory('/storage/emulated/0/Pictures');
    } else {
      baseDir = await getApplicationDocumentsDirectory();
    }

    final String appDir = path.join(baseDir!.path, 'MyCustomApp');
    final Directory dir = Directory(appDir);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return appDir;
  }

  // ==================== AMBIL FOTO ====================
  Future<void> _takePhoto() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 95,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (picked == null) return;

      final String ip = await _getIpAddress() ?? "Tidak terdeteksi";
      final String latlong = "${_lokasiModel?.lat ?? ''} ${_lokasiModel?.long ?? ''}";

      final String watermarkText = '''
${getAbsenType(skpdId)}
NIP: ${_user?.nip ?? '-'}
IP: $ip
LAT-LONG: $latlong
${DateFormat('dd MMM yyyy HH:mm:ss').format(DateTime.now())}
dhe bdg kab ${DateTime.now().year}
© All Rights Reserved''';

      final File watermarkedFile = await _addWatermark(File(picked.path), watermarkText);

      setState(() {
        _imageFile = watermarkedFile;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal ambil foto: $e")),
        );
      }
    }
  }

  String _mapJenisAbsen(int jenisAbsen) {
     switch (jenisAbsen) {
       case 1:
         return "masuk";
       case 2:
         return "pulang";
       case 3:
         return "lembur_masuk";
       case 4:
         return "lembur_pulang";
       default:
         throw Exception("Jenis absen tidak valid: $jenisAbsen");
     }
   }


   String getCurrentTglJam() {
     final now = DateTime.now();
     final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
     return formatter.format(now);
   }

   String getCurrentDate() {
     final now = DateTime.now();
     final formatter = DateFormat('yyyy-MM-dd');
     return formatter.format(now);
   }

   Future<String?> getApMac() async {
     final info = NetworkInfo();
     try {
       final bssid = await info.getWifiBSSID();
       return bssid; // bisa null jika gagal
     } catch (e) {
       print("Gagal mendapatkan apMac: $e");
       return null;
     }
   }

   Future<String?> getDeviceIp() async {
     final info = NetworkInfo();
     try {
       final ip = await info.getWifiIP(); // IP WiFi device
       return ip; // bisa null jika tidak tersambung WiFi
     } catch (e) {
       print("Gagal mendapatkan IP: $e");
       return null;
     }
   }

  // ==================== KIRIM ABSEN ====================
  void _absen() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ambil foto dulu!')),
      );
      return;
    }

    final vm = Provider.of<HomeViewModel>(context, listen: false);

    final bool success = await vm.sendAttendanceData(
      filename: path.basename(_imageFile!.path),
      filepath: _imageFile!.path,
      nip: _user!.nip,
      tgl: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      latlong: "${_lokasiModel?.lat} ${_lokasiModel?.long}",
      lat: _lokasiModel?.lat ?? '',
      lon: _lokasiModel?.long ?? '',
      jenisAbsen: skpdId ?? 1,
    );

    if (success) {

         String _absens = skpdId.toString();
      String _apmac = await getApMac() ?? '';
      String _ip = await getDeviceIp() ?? '';

     bool isAbsen = await vm.sendStoreAbsensiData(
         pegawaiId: _user!.pegawaiId,
         nip: _user!.nip,
         jenisAbsen: _absens,
         lat: _lokasiModel?.lat ?? '',
         lon: _lokasiModel?.long ?? '',
         apMac: _apmac,
         apIp: _ip,
         ip: _ip,
         imei: '',
         tglJam: '',
         tgl: getCurrentDate(),
         dari: '',
         sampai: ''
     );

     if(isAbsen){
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
           content: Text('Absen Berhasil'),
           backgroundColor: Colors.green,
           duration: Duration(seconds: 2),
         ),
       );

       // delay agar snackBar sempat tampil
       Future.delayed(const Duration(milliseconds: 500), () {
         if (context.mounted) Navigator.pop(context, true);
       });

     }else{
       ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Absen gagal')));
     }

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text("Absen berhasil!"),
      //     backgroundColor: Colors.green,
      //   ),
      // );
      // Future.delayed(const Duration(milliseconds: 800), () {
      //   if (mounted) Navigator.pop(context, true);
      // });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Absen gagal")),
      );
    }
  }

  // ==================== UI ====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(getAbsenType(skpdId)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                height: 320,
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                child: _imageFile == null
                    ? const Center(
                        child: Text(
                          "Belum ada foto",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(_imageFile!, fit: BoxFit.contain),
                      ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _takePhoto,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Ambil Foto", style: TextStyle(fontSize: 17)),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _absen,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Kirim Absen", style: TextStyle(fontSize: 17, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}