class RiwayatKunjunganModel {
  String? idRiwayatKunjungan;
  String? idPengguna;
  String? idKunjungan;
  String? fotoMeteran;
  String? fotoSelfie;
  String? idGasPelanggan;
  String? pembacaanMeter;
  DateTime? tglKunjungan;
  String? status;

  RiwayatKunjunganModel(
    this.idRiwayatKunjungan,
    this.idPengguna,
    this.idKunjungan,
    this.fotoMeteran,
    this.fotoSelfie,
    this.idGasPelanggan,
    this.pembacaanMeter,
    this.tglKunjungan,
    this.status,
  );

  factory RiwayatKunjunganModel.fromMap(Map<String, dynamic> json) {
    return RiwayatKunjunganModel(
      json['id_riwayat_kunjungan'],
      json['id_pengguna'],
      json['id_kunjungan'],
      json['foto_meteran'],
      json['foto_selfie'],
      json['id_gas_pelanggan'],
      json['pembacaan_meter'],
      DateTime.parse(json['tgl_kunjungan']),
      json['rstatus'],
    );
  }

  factory RiwayatKunjunganModel.fromJson(Map<String, dynamic> json) {
    return RiwayatKunjunganModel(
      json['id_riwayat_kunjungan'],
      json['id_pengguna'],
      json['id_kunjungan'],
      json['foto_meteran'],
      json['foto_selfie'],
      json['id_gas_pelanggan'],
      json['pembacaan_meter'],
      DateTime.parse(json['tgl_kunjungan']),
      json['rstatus'],
    );
  }
}
