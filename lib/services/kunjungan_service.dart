import 'package:geprec_app/app_constants.dart';
import 'package:geprec_app/models/kunjungan_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  Future<KunjunganModel> tambahKunjungan(KunjunganModel kunjunganModel) async {
    String url = "${AppConstants.baseUrl}/api/kunjungan/save_kunjungan";

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nomor_pelanggan': kunjunganModel.nomorPelanggan!,
        'nomor_meteran': kunjunganModel.nomorMeteran!,
        'nama_kunjungan': kunjunganModel.namaKunjungan!,
        'alamat': kunjunganModel.alamat!,
        'catatan': kunjunganModel.catatan!,
        'latitude': kunjunganModel.latitude!,
        'foto_kunjungan': kunjunganModel.fotoKunjungan!,
      }),
    );

    if (response.statusCode == 200) {
      return KunjunganModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal menyimpan kunjungan');
    }
  }
}
