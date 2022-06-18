import 'package:geprec_app/app_constants.dart';
import 'package:geprec_app/models/pengguna_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  static Future<PenggunaModel> login(String username, String password) async {
    String url =
        "${AppConstants.baseUrl}api/user/login?username=$username&password=$password";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      List<dynamic> data = (jsonData as Map<String, dynamic>)['data'];
      return PenggunaModel.fromJson(data[0]);
    } else {
      throw 'Gagal login. Coba lagi.';
    }
  }
  // static Future<PenggunaModel> login(String username, String password) async {
  //   String url =
  //       "${AppConstants.baseUrl}api/user/login?username=$username&password=$password";

  //   final http.Response response = await http.get(
  //     Uri.parse(url),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     PenggunaModel penggunaModel =
  //         PenggunaModel.fromJson(json.decode(response.body));
  //     print(penggunaModel.username);
  //     return penggunaModel;
  //   } else {
  //     print(response.body);
  //     throw Exception('Gagal login');
  //   }
  // }
}
