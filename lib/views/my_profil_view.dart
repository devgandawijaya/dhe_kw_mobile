import 'dart:convert';
import 'package:dhe/models/lokasi_model.dart';
import 'package:dhe/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MyProfilView extends StatefulWidget {
  final int? skpdId;

  const MyProfilView({super.key, this.skpdId});

  @override
  State<MyProfilView> createState() => _MyProfilViewState();
}

class _MyProfilViewState extends State<MyProfilView> {
  UserModel? _user;
  LokasiModel? _lokasiModel;
  int? skpdId;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    /// Ambil dari constructor
    skpdId = widget.skpdId;
    print("SKPD ID (from constructor): $skpdId");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /// Ambil dari route hanya sekali
    skpdId ??= ModalRoute.of(context)!.settings.arguments as int?;
    print("SKPD ID (from route): $skpdId");
  }

  /// ---------------------------
  /// LOAD HIVE USER + LOKASI
  /// ---------------------------
  Future<void> _loadUserData() async {
    final box = await Hive.openBox('userBox');
    final userJson = box.get('user');

    final coordinate = await Hive.openBox('coordinateBox');
    final coordinateJson = coordinate.get('coordinate_data');

    if (userJson != null) {
      final userMap = json.decode(userJson);
      setState(() {
        _user = UserModel.fromJson(userMap);
      });
    }

    if (coordinateJson != null) {
      final coordinateMap = json.decode(coordinateJson);
      setState(() {
        _lokasiModel = LokasiModel.fromJson(coordinateMap);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    final lokasi = _lokasiModel;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,

      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : _buildProfile(user, lokasi),
    );
  }

  /// --------------------------------------
  ///    WIDGET PROFIL — UI HIJAU PUTIH
  /// --------------------------------------
  Widget _buildProfile(UserModel user, LokasiModel? lokasi) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: [
          /// Foto bulat dari URL
          CircleAvatar(
            radius: 65,
            backgroundColor: Colors.green.shade200,
            backgroundImage: NetworkImage(
              user.photo ??
                  "https://i.pravatar.cc/300", // fallback
            ),
          ),

          const SizedBox(height: 15),

          /// Nama Bold Center
          Text(
            user.nama ?? "-",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 25),

          /// Item kiri sesuai urutan permintaan
          buildItem("Lokasi Kerja", lokasi?.lokasi ?? "-"),
          buildItem("Jabatan Lengkap", user.jabatanLengkap ?? "-"),
          buildItem("NIP", user.nip ?? "-"),
          buildItem("Pegawai ID", (user.pegawaiId ?? "-").toString()),
          buildItem("Tipe HP", user.tipe ?? "-"),
          buildItem("Merk HP", user.merk ?? "-"),
          buildItem("HP ID", user.androidId ?? "-"),
          buildItem("Lokasi Kerja", user.skpdnama ?? "-"),

          buildItem("Lat - Long",
              "${lokasi?.lat ?? '-'} , ${lokasi?.long ?? '-'}"),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  /// Reusable Row hijau-putih
  Widget buildItem(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title : ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green.shade900,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.green.shade800),
            ),
          ),
        ],
      ),
    );
  }
}
