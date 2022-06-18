import 'package:geprec_app/app_constants.dart';
import 'package:geprec_app/models/riwayat_kunjungan_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RiwayatKunjunganService {
  static Future<List<RiwayatKunjunganModel>> getRiwayatKunjungan(
      String idUser) async {
    String url = "${AppConstants.baseUrl}api/riwayat/list_kunjungan/$idUser";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      List<dynamic> riwayatKunjunganList =
          (jsonData as Map<String, dynamic>)['data'];

      List<RiwayatKunjunganModel> riwayatKunjungan = [];
      for (int i = 0; i < riwayatKunjunganList.length; i++) {
        riwayatKunjungan
            .add(RiwayatKunjunganModel.fromJson(riwayatKunjunganList[i]));
      }

      return riwayatKunjungan;
    } else {
      throw Exception('Unexpected error occured!');
    }
  }
}
