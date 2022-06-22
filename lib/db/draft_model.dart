const String draftTable = "drafts";

class DraftFields {
  static final List<String> values = [
    id,
    idPengguna,
    idKunjungan,
    fotoMeteran,
    fotoSelfie,
    pembacaanMeter,
    idGasPelanggan,
    latitudeD,
    longitudeD,
    tglKunjunganD,
  ];

  static const String id = '_id';
  static const String idPengguna = 'id_pengguna';
  static const String idKunjungan = 'id_kunjungan';
  static const String fotoMeteran = 'foto_meteran';
  static const String fotoSelfie = 'foto_selfie';
  static const String pembacaanMeter = 'pembacaan_meter';
  static const String idGasPelanggan = 'id_gas_pelanggan';
  static const String latitudeD = 'latitude';
  static const String longitudeD = 'longitude';
  static const String tglKunjunganD = 'tgl_kunjungan';
}

class DraftModel {
  final int? id;
  final String idPengguna;
  final String idKunjungan;
  final String fotoMeteran;
  final String fotoSelfie;
  final String pembacaanMeter;
  final String idGasPelanggan;
  final String latitudeD;
  final String longitudeD;
  final String tglKunjunganD;

  DraftModel({
    this.id,
    required this.idPengguna,
    required this.idKunjungan,
    required this.fotoMeteran,
    required this.fotoSelfie,
    required this.pembacaanMeter,
    required this.idGasPelanggan,
    required this.latitudeD,
    required this.longitudeD,
    required this.tglKunjunganD,
  });

  DraftModel copy({
    final int? id,
    final String? idPengguna,
    final String? idKunjungan,
    final String? fotoMeteran,
    final String? fotoSelfie,
    final String? pembacaanMeter,
    final String? idGasPelanggan,
    final String? latitudeD,
    final String? longitudeD,
    final String? tglKunjunganD,
  }) =>
      DraftModel(
        id: id ?? this.id,
        idPengguna: idPengguna ?? this.idPengguna,
        idKunjungan: idKunjungan ?? this.idKunjungan,
        fotoMeteran: fotoMeteran ?? this.fotoMeteran,
        fotoSelfie: fotoSelfie ?? this.fotoSelfie,
        pembacaanMeter: pembacaanMeter ?? this.pembacaanMeter,
        idGasPelanggan: idGasPelanggan ?? this.idGasPelanggan,
        latitudeD: latitudeD ?? this.latitudeD,
        longitudeD: longitudeD ?? this.longitudeD,
        tglKunjunganD: tglKunjunganD ?? this.tglKunjunganD,
      );

  Map<String, Object?> toJson() => {
        DraftFields.id: id,
        DraftFields.idPengguna: idPengguna,
        DraftFields.idKunjungan: idKunjungan,
        DraftFields.fotoMeteran: fotoMeteran,
        DraftFields.fotoSelfie: fotoSelfie,
        DraftFields.pembacaanMeter: pembacaanMeter,
        DraftFields.idGasPelanggan: idGasPelanggan,
        DraftFields.latitudeD: latitudeD,
        DraftFields.longitudeD: longitudeD,
        DraftFields.tglKunjunganD: tglKunjunganD
      };

  static DraftModel fromJson(Map<String, Object?> json) => DraftModel(
        id: json[DraftFields.id] as int?,
        idPengguna: json[DraftFields.idPengguna] as String,
        idKunjungan: json[DraftFields.idKunjungan] as String,
        fotoMeteran: json[DraftFields.fotoMeteran] as String,
        fotoSelfie: json[DraftFields.fotoSelfie] as String,
        pembacaanMeter: json[DraftFields.pembacaanMeter] as String,
        idGasPelanggan: json[DraftFields.idGasPelanggan] as String,
        latitudeD: json[DraftFields.latitudeD] as String,
        longitudeD: json[DraftFields.longitudeD] as String,
        tglKunjunganD: json[DraftFields.tglKunjunganD] as String,
      );
}
