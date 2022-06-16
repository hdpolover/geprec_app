class KunjunganModel {
  String? idKunjungan;
  String? namaKunjungan;
  String? nomorPelanggan;
  String? nomorMeteran;
  String? alamat;
  String? latitude;
  String? longitude;
  String? catatan;
  String? fotoKunjungan;

  KunjunganModel(
    this.idKunjungan,
    this.nomorPelanggan,
    this.nomorMeteran,
    this.namaKunjungan,
    this.alamat,
    this.catatan,
    this.latitude,
    this.longitude,
    this.fotoKunjungan,
  );

  factory KunjunganModel.fromMap(Map<String, dynamic> json) {
    return KunjunganModel(
      json['id_kunjungan'],
      json['nomor_pelanggan'],
      json['nomor_meteran'],
      json['nama_kunjungan'],
      json['alamat'],
      json['catatan'],
      json['latitude'],
      json['longitude'],
      json['foto_kunjungan'],
    );
  }

  factory KunjunganModel.fromJson(Map<String, dynamic> json) {
    return KunjunganModel(
      json['id_kunjungan'],
      json['nomor_pelanggan'],
      json['nomor_meteran'],
      json['nama_kunjungan'],
      json['alamat'],
      json['catatan'],
      json['latitude'],
      json['longitude'],
      json['foto_kunjungan'],
    );
  }
}
