import 'package:shared_preferences/shared_preferences.dart';

class DraftHelper {
  Future saveDataDraft(Map<String, dynamic> data) async {
    var prefs = await SharedPreferences.getInstance();

    prefs.setString("id_pengguna", data["id_pengguna"]);
    prefs.setString("id_kunjungan", data["id_kunjungan"]);
    prefs.setString("foto_meteran", data["foto_meteran"]);
    prefs.setString("foto_selfie", data["foto_selfie"]);
    prefs.setString("pembacaan_meter", data["pembacaan_meter"]);
    prefs.setString("latitude", data["latitude"]);
    prefs.setString("longitude", data["longitude"]);
    prefs.setString("tgl_kunjungan", data["tgl_kunjungan"]);
    prefs.setString("id_gas_pelanggan", data["id_gas_pelanggan"]);
  }

  Future hapusDataDraft() async {
    var prefs = await SharedPreferences.getInstance();

    prefs.setString("id_pengguna", "");
    prefs.setString("id_kunjungan", "");
    prefs.setString("foto_meteran", "");
    prefs.setString("foto_selfie", "");
    prefs.setString("pembacaan_meter", "");
    prefs.setString("latitude", "");
    prefs.setString("longitude", "");
    prefs.setString("tgl_kunjungan", "1900-10-01 00:00:00");
    prefs.setString("id_gas_pelanggan", "");
  }

  Future<Map<String, dynamic>> getDataDraft() async {
    final prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> dataDraft = {
      "id_pengguna": prefs.getString("id_pengguna") ?? "",
      "id_kunjungan": prefs.getString("id_kunjungan") ?? "",
      "foto_meteran": prefs.getString("foto_meteran") ?? "",
      "foto_selfie": prefs.getString("foto_selfie") ?? "",
      "pembacaan_meter": prefs.getString("pembacaan_meter") ?? "",
      "id_gas_pelanggan": prefs.getString("id_gas_pelanggan") ?? "",
      "latitude": prefs.getString("latitude") ?? "",
      "longitude": prefs.getString("longitude") ?? "",
      "tgl_kunjungan":
          prefs.getString("tgl_kunjungan") ?? "1900-10-01 00:00:00",
    };

    return dataDraft;
  }
}
