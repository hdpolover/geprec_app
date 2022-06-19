class KunjunganModel {
  String? idKunjungan;
  String? namaKunjungan;
  String? alamat;
  String? latitudeAwal;
  String? longitudeAwal;
  String? latitudeBaru;
  String? longitudeBaru;
  String? catatan;
  String? fotoKunjungan;
  String? resetLokasi;

  KunjunganModel(
    this.idKunjungan,
    this.namaKunjungan,
    this.alamat,
    this.catatan,
    this.latitudeAwal,
    this.longitudeAwal,
    this.latitudeBaru,
    this.longitudeBaru,
    this.fotoKunjungan,
    this.resetLokasi,
  );

  factory KunjunganModel.fromMap(Map<String, dynamic> json) {
    return KunjunganModel(
      json['id_kunjungan'],
      json['nama_kunjungan'],
      json['alamat'],
      json['catatan'],
      json['latitude_awal'],
      json['longitude_awal'],
      json['latitude_baru'],
      json['longitude_baru'],
      json['foto_kunjungan'],
      json['reset_lokasi'],
    );
  }

  factory KunjunganModel.fromJson(Map<String, dynamic> json) {
    return KunjunganModel(
      json['id_kunjungan'],
      json['nama_kunjungan'],
      json['alamat'],
      json['catatan'],
      json['latitude_awal'],
      json['longitude_awal'],
      json['latitude_baru'],
      json['longitude_baru'],
      json['foto_kunjungan'],
      json['reset_lokasi'],
    );
  }
}
