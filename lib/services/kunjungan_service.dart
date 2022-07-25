import 'dart:async';
import 'dart:io';

import 'package:geprec_app/app_constants.dart';
import 'package:geprec_app/models/kunjungan_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class KunjunganService {
  static Future<bool> ngunjungi(Map<String, dynamic> data) async {
    String url = "${AppConstants.baseUrl}api/kunjungan/save_ngunjungi";

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'id_pengguna': data['id_pengguna'],
          'id_kunjungan': data['id_kunjungan'],
          'id_gas_pelanggan': data['id_gas_pelanggan'],
          'pembacaan_meter': data['pembacaan_meter'],
          'tgl_kunjungan': data['tgl_kunjungan'],
          'foto_meteran': data['foto_meteran'],
          'foto_selfie': data['foto_selfie'],
          'latitude': data['latitude'],
          'longitude': data['longitude'],
          'status': "0",
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
    // final http.Response response = await http.post(
    //   Uri.parse(url),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(<String, String>{
    //     'id_pengguna': data['id_pengguna'],
    //     'id_kunjungan': data['id_kunjungan'],
    //     'id_gas_pelanggan': data['id_gas_pelanggan'],
    //     'pembacaan_meter': data['pembacaan_meter'],
    //     'tgl_kunjungan': data['tgl_kunjungan'],
    //     'foto_meteran': data['foto_meteran'],
    //     'foto_selfie': data['foto_selfie'],
    //     'latitude': data['latitude'],
    //     'longitude': data['longitude'],
    //     'status': "0",
    //   }),
    // );

    // if (response.statusCode == 200) {
    //   return true;
    // } else {
    //   throw response.body;
    // }
  }

  static Future<bool> hapusKunjungan(String idKunjungan) async {
    String url = "${AppConstants.baseUrl}api/kunjungan/delete_kunjungan";

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'id_kunjungan': idKunjungan,
        }),
      );

      if (response.statusCode == 200) {
        print(response.body);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateLokasiKunjungan(
      String idKunjungan, Map<String, dynamic> data) async {
    String url =
        "${AppConstants.baseUrl}api/kunjungan/update_kunjungan/$idKunjungan";

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'alamat': data['alamat'],
        'latitude_baru': data['latitude_baru'].toString(),
        'longitude_baru': data['longitude_baru'].toString(),
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Gagal menambahkan kunjungan');
    }
  }

  static Future<bool> tambahKunjungan(Map<String, dynamic> data) async {
    String url = "${AppConstants.baseUrl}api/kunjungan/save_kunjungan";

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_pengguna': data['id_pengguna'],
        'nama_kunjungan': data['nama_kunjungan'],
        'alamat': data['alamat'],
        'catatan': data['catatan'],
        'latitude_awal': data['latitude_awal'].toString(),
        'longitude_awal': data['longitude_awal'].toString(),
        'latitude_baru': data['latitude_baru'].toString(),
        'longitude_baru': data['longitude_baru'].toString(),
        'foto_kunjungan': data['foto_kunjungan'],
        'id_pelanggan': data['id_pelanggan'],
        'nomor_meteran': data['nomor_meteran'],
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Gagal menambahkan kunjungan');
    }
  }

  static Future<List<KunjunganModel>> getDaftarKunjungan(String idUser) async {
    String url = "${AppConstants.baseUrl}api/kunjungan/list_kunjungan/$idUser";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      List<dynamic> kunjunganList = (jsonData as Map<String, dynamic>)['data'];

      List<KunjunganModel> kunjungan = [];
      for (int i = 0; i < kunjunganList.length; i++) {
        kunjungan.add(KunjunganModel.fromJson(kunjunganList[i]));
      }

      return kunjungan;
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  static Future<DateTime> getLastKunjungan(
      String idUser, String idKunjungan) async {
    String url =
        "${AppConstants.baseUrl}api/kunjungan/last_kunjungan?id_pengguna=$idUser&id_kunjungan=$idKunjungan";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      dynamic data = (jsonData as Map<String, dynamic>)['data'];
      return DateTime.parse(data['tgl_kunjungan']);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  static Future<int> checkKunjungan(String idUser, String idKunjungan) async {
    String url =
        "${AppConstants.baseUrl}api/kunjungan/check_kunjungan?id_pengguna=$idUser&id_kunjungan=$idKunjungan";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)['data'];
      return jsonData;
    } else {
      var jsonData = jsonDecode(response.body)['data'];
      return jsonData;
    }
  }
}
