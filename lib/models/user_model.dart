class UserModel {
  final int idKw;
  final int id;
  final String nip;
  final String? karpeg;
  final String nama;
  final String gender;
  final String lahirTanggal;
  final int golruId;
  final String golru;
  final String pangkat;
  final int eselonId;
  final String eselon;
  final int jabatanjnsID;
  final int kelompokJabatanId;
  final int hrJabatanId;
  final int? hrJabatanTambahanId;
  final int? keljabTambahanId;
  final String? keljabTambahan;
  final int? hrJabatanPltplhId;
  final int? skpdPltplhId;
  final int? jabatanPltplhId;
  final String? jabatanPltplh;
  final String jabatanLengkap;
  final int skpdId;
  final String skpdnama;
  final int skpdIdLama;
  final String skpdnamaLama;
  final int bup;
  final int statpegID;
  final String statpeg;
  final int? simpelAsnId;
  final int isactive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? deletedAt;
  final String kdSkpd;
  final String namaSkpd;
  final String fkgolru;
  final String fktgllahir;
  final String fkstatpeg;
  final String fknamajab;
  final int kelas;
  final String name;
  final String email;
  final String username;
  final String password;
  final String? rememberToken;
  final int pegawaiID;
  final int skpdID;
  final int kelompokJabatanID;
  final String photo;
  final String noHp;
  final String androidId;
  final String tipe;
  final String merk;
  final String token;
  final String? flag;
  final int roleId;
  final String roleName;
  final int pegawaiId;
  final String lat;
  final String long;
  final bool activasi;
  final DateTime activasiStart;
  final DateTime activasiEnd;

  UserModel({
    required this.idKw,
    required this.id,
    required this.nip,
    this.karpeg,
    required this.nama,
    required this.gender,
    required this.lahirTanggal,
    required this.golruId,
    required this.golru,
    required this.pangkat,
    required this.eselonId,
    required this.eselon,
    required this.jabatanjnsID,
    required this.kelompokJabatanId,
    required this.hrJabatanId,
    this.hrJabatanTambahanId,
    this.keljabTambahanId,
    this.keljabTambahan,
    this.hrJabatanPltplhId,
    this.skpdPltplhId,
    this.jabatanPltplhId,
    this.jabatanPltplh,
    required this.jabatanLengkap,
    required this.skpdId,
    required this.skpdnama,
    required this.skpdIdLama,
    required this.skpdnamaLama,
    required this.bup,
    required this.statpegID,
    required this.statpeg,
    this.simpelAsnId,
    required this.isactive,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.kdSkpd,
    required this.namaSkpd,
    required this.fkgolru,
    required this.fktgllahir,
    required this.fkstatpeg,
    required this.fknamajab,
    required this.kelas,
    required this.name,
    required this.email,
    required this.username,
    required this.password,
    this.rememberToken,
    required this.pegawaiID,
    required this.skpdID,
    required this.kelompokJabatanID,
    required this.photo,
    required this.noHp,
    required this.androidId,
    required this.tipe,
    required this.merk,
    required this.token,
    this.flag,
    required this.roleId,
    required this.roleName,
    required this.pegawaiId,
    required this.lat,
    required this.long,
    required this.activasi,
    required this.activasiStart,
    required this.activasiEnd,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idKw: json['id_kw'] ?? 0,
      id: json['id'] ?? 0,
      nip: json['nip'] ?? '',
      karpeg: json['karpeg'],
      nama: json['nama'] ?? '',
      gender: json['gender'] ?? '',
      lahirTanggal: json['lahir_tanggal'] ?? '',
      golruId: json['golru_id'] ?? 0,
      golru: json['golru'] ?? '',
      pangkat: json['pangkat'] ?? '',
      eselonId: json['eselon_id'] ?? 0,
      eselon: json['eselon'] ?? '',
      jabatanjnsID: json['jabatanjnsID'] ?? 0,
      kelompokJabatanId: json['kelompok_jabatan_id'] ?? 0,
      hrJabatanId: json['hr_jabatan_id'] ?? 0,
      hrJabatanTambahanId: json['hr_jabatan_tambahan_id'],
      keljabTambahanId: json['keljab_tambahan_id'],
      keljabTambahan: json['keljab_tambahan'],
      hrJabatanPltplhId: json['hr_jabatan_pltplh_id'],
      skpdPltplhId: json['skpd_pltplh_id'],
      jabatanPltplhId: json['jabatan_pltplh_id'],
      jabatanPltplh: json['jabatan_pltplh'],
      jabatanLengkap: json['jabatan_lengkap'] ?? '',
      skpdId: json['skpd_id'] ?? 0,
      skpdnama: json['skpdnama'] ?? '',
      skpdIdLama: json['skpd_id_lama'] ?? 0,
      skpdnamaLama: json['skpdnama_lama'] ?? '',
      bup: json['bup'] ?? 0,
      statpegID: json['statpegID'] ?? 0,
      statpeg: json['statpeg'] ?? '',
      simpelAsnId: json['simpel_asn_id'],
      isactive: json['isactive'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      deletedAt: json['deleted_at'],
      kdSkpd: json['kd_skpd'] ?? '',
      namaSkpd: json['nama_skpd'] ?? '',
      fkgolru: json['fkgolru'] ?? '',
      fktgllahir: json['fktgllahir'] ?? '',
      fkstatpeg: json['fkstatpeg'] ?? '',
      fknamajab: json['fknamajab'] ?? '',
      kelas: json['kelas'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      rememberToken: json['remember_token'],
      pegawaiID: json['pegawaiID'] ?? 0,
      skpdID: json['skpdID'] ?? 0,
      kelompokJabatanID: json['kelompok_jabatanID'] ?? 0,
      photo: json['photo'] ?? '',
      noHp: json['no_hp'] ?? '',
      androidId: json['android_id'] ?? '',
      tipe: json['tipe'] ?? '',
      merk: json['merk'] ?? '',
      token: json['token'] ?? '',
      flag: json['flag'],
      roleId: json['role_id'] ?? 0,
      roleName: json['role_name'] ?? '',
      pegawaiId: json['pegawai_id'] ?? 0,
      lat: json['lat'] ?? '',
      long: json['long'] ?? '',
      activasi: json['activasi'] ?? false,
      activasiStart: DateTime.parse(json['activasi_start'] ?? DateTime.now().toIso8601String()),
      activasiEnd: DateTime.parse(json['activasi_end'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id_kw": idKw,
      "id": id,
      "nip": nip,
      "karpeg": karpeg,
      "nama": nama,
      "gender": gender,
      "lahir_tanggal": lahirTanggal,
      "golru_id": golruId,
      "golru": golru,
      "pangkat": pangkat,
      "eselon_id": eselonId,
      "eselon": eselon,
      "jabatanjnsID": jabatanjnsID,
      "kelompok_jabatan_id": kelompokJabatanId,
      "hr_jabatan_id": hrJabatanId,
      "hr_jabatan_tambahan_id": hrJabatanTambahanId,
      "keljab_tambahan_id": keljabTambahanId,
      "keljab_tambahan": keljabTambahan,
      "hr_jabatan_pltplh_id": hrJabatanPltplhId,
      "skpd_pltplh_id": skpdPltplhId,
      "jabatan_pltplh_id": jabatanPltplhId,
      "jabatan_pltplh": jabatanPltplh,
      "jabatan_lengkap": jabatanLengkap,
      "skpd_id": skpdId,
      "skpdnama": skpdnama,
      "skpd_id_lama": skpdIdLama,
      "skpdnama_lama": skpdnamaLama,
      "bup": bup,
      "statpegID": statpegID,
      "statpeg": statpeg,
      "simpel_asn_id": simpelAsnId,
      "isactive": isactive,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
      "deleted_at": deletedAt,
      "kd_skpd": kdSkpd,
      "nama_skpd": namaSkpd,
      "fkgolru": fkgolru,
      "fktgllahir": fktgllahir,
      "fkstatpeg": fkstatpeg,
      "fknamajab": fknamajab,
      "kelas": kelas,
      "name": name,
      "email": email,
      "username": username,
      "password": password,
      "remember_token": rememberToken,
      "pegawaiID": pegawaiID,
      "skpdID": skpdID,
      "kelompok_jabatanID": kelompokJabatanID,
      "photo": photo,
      "no_hp": noHp,
      "android_id": androidId,
      "tipe": tipe,
      "merk": merk,
      "token": token,
      "flag": flag,
      "role_id": roleId,
      "role_name": roleName,
      "pegawai_id": pegawaiId,
      "lat": lat,
      "long": long,
      "activasi": activasi,
      "activasi_start": activasiStart.toIso8601String(),
      "activasi_end": activasiEnd.toIso8601String(),
    };
  }
}
