class PenggunaModel {
  String? idPengguna;
  String? username;
  String? password;
  String? nama;
  String? fotoPengguna;
  String? status;

  PenggunaModel(
    this.idPengguna,
    this.username,
    this.password,
    this.nama,
    this.fotoPengguna,
    this.status,
  );

  factory PenggunaModel.fromMap(Map<String, dynamic> json) {
    return PenggunaModel(
      json['id_pengguna'],
      json['username'],
      json['password'],
      json['nama'],
      json['foto_pengguna'],
      json['status'],
    );
  }

  factory PenggunaModel.fromJson(Map<String, dynamic> json) {
    return PenggunaModel(
      json['id_pengguna'],
      json['username'],
      json['password'],
      json['nama'],
      json['foto_pengguna'],
      json['status'],
    );
  }
}
