import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geprec_app/screens/dashboard.dart';
import 'package:geprec_app/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/pengguna_model.dart';
import '../services/user_service.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  Timer? _timer;

  _startDelay() {
    _timer = Timer(const Duration(seconds: 3), _goNext);
  }

  _goNext() async {
    bool loginStatus = await getLoginStatus();
    String username = await getLoginData("username");
    String password = await getLoginData("password");

    if (loginStatus) {
      PenggunaModel pengguna = await UserService.login(username, password);

      _goto(Dashboard(pengguna: pengguna));
    } else {
      _goto(const Login());
    }
  }

  _goto(Widget name) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) => name,
      ),
    );
  }

  Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loginStatus') ?? false;
  }

  Future<String> getLoginData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * -0.2,
            left: MediaQuery.of(context).size.width * -0.2,
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.8,
            left: MediaQuery.of(context).size.width * -0.2,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.55,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.8,
            left: MediaQuery.of(context).size.width * 0.8,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                Image(
                  width: MediaQuery.of(context).size.width * 0.8,
                  image: const AssetImage('assets/images/geprec.png'),
                ),
                Text(
                  "For your trusted records",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontStyle: FontStyle.italic),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                Text(
                  "v 1.0.0",
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
