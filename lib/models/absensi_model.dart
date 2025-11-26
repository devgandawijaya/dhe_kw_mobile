class AbsenModel {
  final String pegawaiId;
  final String nip;
  final int jenisabsenID;
  final String? jenisabsen;
  final String? stsabsen;
  final String jadwal;
  final String? namaApMasuk;
  final String? namaApPulang;
  final String? namaApLemburMasuk;
  final String? namaApLemburPulang;
  final String tgl;
  final String jammasuk;
  final String jampulang;
  final String jammasukLembur;
  final String jampulangLembur;
  final String absenNonStandar;
  final String? photoMasuk;
  final String? photoPulang;
  final String? photoLemburMasuk;
  final String? photoLemburPulang;
  final String? dokumen;

  AbsenModel({
    required this.pegawaiId,
    required this.nip,
    required this.jenisabsenID,
    this.jenisabsen,
    this.stsabsen,
    required this.jadwal,
    this.namaApMasuk,
    this.namaApPulang,
    this.namaApLemburMasuk,
    this.namaApLemburPulang,
    required this.tgl,
    required this.jammasuk,
    required this.jampulang,
    required this.jammasukLembur,
    required this.jampulangLembur,
    required this.absenNonStandar,
    this.photoMasuk,
    this.photoPulang,
    this.photoLemburMasuk,
    this.photoLemburPulang,
    this.dokumen,
  });

  factory AbsenModel.fromJson(Map<String, dynamic> json) {
    return AbsenModel(
      pegawaiId: json['pegawai_id'] ?? '',
      nip: json['nip'] ?? '',
      jenisabsenID: json['jenisabsenID'] ?? 0,
      jenisabsen: json['jenisabsen'],
      stsabsen: json['stsabsen'],
      jadwal: json['jadwal'] ?? '',
      namaApMasuk: json['nama_ap_masuk'],
      namaApPulang: json['nama_ap_pulang'],
      namaApLemburMasuk: json['nama_ap_lembur_masuk'],
      namaApLemburPulang: json['nama_ap_lembur_pulang'],
      tgl: json['tgl'] ?? '',
      jammasuk: json['jammasuk'] ?? '',
      jampulang: json['jampulang'] ?? '',
      jammasukLembur: json['jammasuk_lembur'] ?? '',
      jampulangLembur: json['jampulang_lembur'] ?? '',
      absenNonStandar: json['absen_non_standar'] ?? '',
      photoMasuk: json['photo_masuk'],
      photoPulang: json['photo_pulang'],
      photoLemburMasuk: json['photo_lembur_masuk'],
      photoLemburPulang: json['photo_lembur_pulang'],
      dokumen: json['dokumen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pegawai_id': pegawaiId,
      'nip': nip,
      'jenisabsenID': jenisabsenID,
      'jenisabsen': jenisabsen,
      'stsabsen': stsabsen,
      'jadwal': jadwal,
      'nama_ap_masuk': namaApMasuk,
      'nama_ap_pulang': namaApPulang,
      'nama_ap_lembur_masuk': namaApLemburMasuk,
      'nama_ap_lembur_pulang': namaApLemburPulang,
      'tgl': tgl,
      'jammasuk': jammasuk,
      'jampulang': jampulang,
      'jammasuk_lembur': jammasukLembur,
      'jampulang_lembur': jampulangLembur,
      'absen_non_standar': absenNonStandar,
      'photo_masuk': photoMasuk,
      'photo_pulang': photoPulang,
      'photo_lembur_masuk': photoLemburMasuk,
      'photo_lembur_pulang': photoLemburPulang,
      'dokumen': dokumen,
    };
  }
}