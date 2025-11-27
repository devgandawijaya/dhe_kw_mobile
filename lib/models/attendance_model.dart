// models/attendance_model.dart
class AttendanceModel {
  final int id;
  final int pegawaiId;
  final String nip;
  final String? absenMasuk;
  final String? absenPulang;
  final int? totalMenitAbsen;
  final String? indodate;
  final String? tgl;
  final String? indomasuk;
  final String? indopulang;
  final String? indodatelong;
  final String? photoMasuk;
  final String? photoPulang;
  final String? namaJadwal;

  AttendanceModel({
    required this.id,
    required this.pegawaiId,
    required this.nip,
    this.absenMasuk,
    this.absenPulang,
    this.totalMenitAbsen,
    this.indodate,
    this.tgl,
    this.indomasuk,
    this.indopulang,
    this.indodatelong,
    this.photoMasuk,
    this.photoPulang,
    this.namaJadwal,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] ?? 0,
      pegawaiId: json['pegawai_id'] ?? 0,
      nip: json['nip'] ?? '',
      absenMasuk: json['absen_masuk'] as String?,
      absenPulang: json['absen_pulang'] as String?,
      totalMenitAbsen: json['total_menit_absen'] is int ? json['total_menit_absen'] : int.tryParse('${json['total_menit_absen']}'),
      indodate: json['indodate'] as String?,
      tgl: json['tgl'] as String?,
      indomasuk: json['indomasuk'] as String?,
      indopulang: json['indopulang'] as String?,
      indodatelong: json['indodatelong'] as String?,
      photoMasuk: json['photo_masuk'] as String?,
      photoPulang: json['photo_pulang'] as String?,
      namaJadwal: json['nama_jadwal'] as String?,
    );
  }
}
