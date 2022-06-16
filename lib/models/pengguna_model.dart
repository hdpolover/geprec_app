class PenggunaModel {
  String? idPengguna;
  String? username;
  String? password;
  String? nama;
  String? fotoPengguna;

  PenggunaModel(
    this.idPengguna,
    this.username,
    this.password,
    this.nama,
    this.fotoPengguna,
  );

  factory PenggunaModel.fromMap(Map<String, dynamic> json) {
    return PenggunaModel(
      json['id_pengguna'],
      json['username'],
      json['password'],
      json['nama'],
      json['foto_pengguna'],
    );
  }

  factory PenggunaModel.fromJson(Map<String, dynamic> json) {
    return PenggunaModel(
      json['id_pengguna'],
      json['username'],
      json['password'],
      json['nama'],
      json['foto_pengguna'],
    );
  }
}
