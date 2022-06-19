import 'dart:convert';
import 'dart:io';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geprec_app/models/kunjungan_model.dart';
import 'package:geprec_app/models/pengguna_model.dart';
import 'package:geprec_app/screens/form_kunjungi.dart';
import 'package:geprec_app/services/kunjungan_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

class DetailKunjungan extends StatefulWidget {
  KunjunganModel kunjungan;
  PenggunaModel pengguna;
  DetailKunjungan({required this.pengguna, required this.kunjungan, Key? key})
      : super(key: key);

  @override
  State<DetailKunjungan> createState() => _DetailKunjunganState();
}

class _DetailKunjunganState extends State<DetailKunjungan> {
  Position? _currentPosition;
  String? _currentAddress;
  bool isLoading = false;

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }

    Position pos = await _geolocatorPlatform.getCurrentPosition(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
    ));

    String address = await getAddressFromLatLong(pos);

    setState(() {
      _currentPosition = pos;
      _currentAddress = address;

      isLoading = false;
    });

    Map<String, dynamic> data = {
      "alamat": _currentAddress,
      "latitude_baru": _currentPosition!.latitude,
      "longitude_baru": _currentPosition!.longitude,
    };

    bool result = await KunjunganService.updateLokasiKunjungan(
        widget.kunjungan.idKunjungan!, data);

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text("Berhasil menyimpan lokasi baru."),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text("Gagal menyimpan lokasi baru. Coba lagi."),
          ),
        ),
      );
    }
  }

  Future<String> getAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    //print(placemarks);
    Placemark place = placemarks[0];
    return '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  String? base64ImageFile;

  void _setImageFileListFromFile(XFile? value) {
    _imageFile = value;
  }

  Future<void> takePhoto({BuildContext? context, String? msg}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        imageQuality: 90,
        source: ImageSource.camera,
      );
      setState(() {
        _setImageFileListFromFile(pickedFile);
      });

      var bytes = File(_imageFile!.path).readAsBytesSync();
      String base64Image = base64Encode(bytes);

      File file = File(_imageFile!.path);
      String fileExtension = p.extension(file.path);

      setState(() {
        base64ImageFile =
            "data:image/${fileExtension.split('.').last};base64,$base64Image";
      });

      Future.delayed(const Duration(seconds: 2), () {
        ScaffoldMessenger.of(context!).showSnackBar(
          SnackBar(
            content: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(msg!),
            ),
          ),
        );
      });
    } catch (e) {
      print(e);
    }
  }

  buildLastKunjungan() {
    return FutureBuilder(
      future: KunjunganService.getLastKunjungan(
          widget.pengguna.idPengguna!, widget.kunjungan.idKunjungan!),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Chip(
            backgroundColor: Colors.red,
            labelPadding: EdgeInsets.all(7),
            label: Text(
              "Belum pernah dikunjungi",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }

        DateTime lastTanggalKunjungan = snapshot.data as DateTime;

        String formatTanggal =
            DateFormat("dd-MM-yyyy").format(lastTanggalKunjungan);

        return Chip(
          backgroundColor: Colors.green,
          labelPadding: const EdgeInsets.all(7),
          label: Text(
            "Terakhir dikunjungi pada $formatTanggal",
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Kunjungan"),
        centerTitle: true,
        elevation: 1,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    FancyShimmerImage(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.5,
                      boxFit: BoxFit.cover,
                      imageUrl: widget.kunjungan.fotoKunjungan!,
                      errorWidget: Image.network(
                          'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
                    ),
                    Positioned.fill(
                      right: 10,
                      bottom: 10,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: buildLastKunjungan(),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "Nama Rumah",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(widget.kunjungan.namaKunjungan!),
                      const SizedBox(height: 30),
                      const Text(
                        "Alamat",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(_currentAddress != null
                          ? _currentAddress!
                          : widget.kunjungan.alamat!),
                      const SizedBox(height: 10),
                      Text(_currentPosition != null
                          ? "[Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}]"
                          : "[Latitude: ${widget.kunjungan.latitudeBaru}, Longitude: ${widget.kunjungan.longitudeBaru}]"),
                      const SizedBox(height: 10),
                      widget.kunjungan.resetLokasi == "1"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    launchMapUrl(_currentAddress != null
                                        ? _currentAddress!
                                        : widget.kunjungan.alamat!);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    onPrimary: Colors.white, // foreground
                                  ),
                                  icon: const Icon(Icons.map),
                                  label: const Text(
                                    "Navigasi GMaps",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                isLoading
                                    ? const Padding(
                                        padding: EdgeInsets.all(10),
                                        child: CircularProgressIndicator(),
                                      )
                                    : ElevatedButton.icon(
                                        onPressed: () {
                                          setState(() {
                                            isLoading = true;
                                          });

                                          _getCurrentPosition();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.red, // background
                                          onPrimary: Colors.white, // foreground
                                        ),
                                        icon: const Icon(Icons.location_pin),
                                        label: const Text(
                                          "Reset alamat",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                              ],
                            )
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  launchMapUrl(widget.kunjungan.alamat!);
                                },
                                style: ElevatedButton.styleFrom(
                                  onPrimary: Colors.white, // foreground
                                ),
                                icon: const Icon(Icons.map),
                                label: const Text(
                                  "Navigasi GMaps",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                      const SizedBox(height: 20),
                      const Text(
                        "Catatan",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(widget.kunjungan.catatan!.trim().isEmpty
                          ? "-"
                          : widget.kunjungan.catatan!),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 50,
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            takePhoto(
                                context: context,
                                msg: "Foto selfie berhasil disimpan.");
                          },
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Ambil Selfie'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green, // background
                            onPrimary: Colors.white, // foreground
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (base64ImageFile != null) {
                              Map<String, dynamic> data = {
                                "foto_selfie": base64ImageFile,
                                "id_kunjungan": widget.kunjungan.idKunjungan,
                                "id_pengguna": widget.pengguna.idPengguna,
                              };

                              pushNewScreen(
                                context,
                                screen: FormKunjungan(
                                  data: data,
                                ),
                                withNavBar:
                                    false, // OPTIONAL VALUE. True by default.
                                pageTransitionAnimation:
                                    PageTransitionAnimation.fade,
                              );
                            } else {
                              Map<String, dynamic> data = {
                                "foto_selfie": "",
                                "id_kunjungan": widget.kunjungan.idKunjungan,
                                "id_pengguna": widget.pengguna.idPengguna,
                              };

                              pushNewScreen(
                                context,
                                screen: FormKunjungan(
                                  data: data,
                                ),
                                withNavBar:
                                    false, // OPTIONAL VALUE. True by default.
                                pageTransitionAnimation:
                                    PageTransitionAnimation.fade,
                              );
                            }
                          },
                          icon: const Icon(Icons.directions),
                          label: const Text('Kunjungi'),
                          style: ElevatedButton.styleFrom(
                            onPrimary: Colors.white, // foreground
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> launchMapUrl(String address) async {
    String query = Uri.encodeComponent(address);
    String googleUrl = "google.navigation:q=$query";
    Uri googleUri = Uri.parse(googleUrl);

    if (await canLaunchUrl(googleUri)) {
      await launchUrl(googleUri);
    }
  }

  void buildOkDialog(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 100),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(top: 150, left: 32, right: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: SizedBox.expand(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.error,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Pastikan Anda berada kurang dari radius 200 meter dari tempat yang akan dikunjungi. Coba lagi.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(fontWeight: FontWeight.normal),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      width: 213,
                      height: 55,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: const Text(
                          'OK',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
