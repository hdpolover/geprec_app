import 'package:geprec_app/app_constants.dart';
import 'package:geprec_app/models/pengguna_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  Future<PenggunaModel> sendFruit(PenggunaModel pengguna) async {
    String url = "${AppConstants.baseUrl}/";

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // body: jsonEncode(<String, String>{
      //   'title': title,
      //   'id': idKunjungan.toString(),
      //   'imgUrl': imgUrl,
      //   'quantity': quantity.toString()
      // }),
    );
    if (response.statusCode == 201) {
      return PenggunaModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }
}
