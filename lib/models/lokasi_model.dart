class LokasiModel {
  final int skpdId;
  final String unitKerja;
  final String lokasi;
  final String lat;
  final String long;
  final int radius;
  final String keterangan;
  final InfoModel info;

  LokasiModel({
    required this.skpdId,
    required this.unitKerja,
    required this.lokasi,
    required this.lat,
    required this.long,
    required this.radius,
    required this.keterangan,
    required this.info,
  });

  factory LokasiModel.fromJson(Map<String, dynamic> json) {
    return LokasiModel(
      skpdId: json['skpd_id'] ?? 0,
      unitKerja: json['unit_kerja'] ?? '',
      lokasi: json['lokasi'] ?? '',
      lat: json['lat'] ?? '',
      long: json['long'] ?? '',
      radius: json['radius'] ?? 0,
      keterangan: json['keterangan'] ?? '',
      info: InfoModel.fromJson(json['info'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skpd_id': skpdId,
      'unit_kerja': unitKerja,
      'lokasi': lokasi,
      'lat': lat,
      'long': long,
      'radius': radius,
      'keterangan': keterangan,
      'info': info.toJson(),
    };
  }
}



class InfoModel {
  final String jarak;
  final String pesan;

  InfoModel({
    required this.jarak,
    required this.pesan,
  });

  factory InfoModel.fromJson(Map<String, dynamic> json) {
    return InfoModel(
      jarak: json['jarak'] ?? '',
      pesan: json['pesan'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jarak': jarak,
      'pesan': pesan,
    };
  }
}
