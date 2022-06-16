import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geprec_app/models/kunjungan_model.dart';
import 'package:geprec_app/screens/form_kunjungi.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class DetailKunjungan extends StatefulWidget {
  KunjunganModel kunjungan;
  DetailKunjungan({required this.kunjungan, Key? key}) : super(key: key);

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

    _currentPosition = await _geolocatorPlatform.getCurrentPosition(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
    ));

    String address = await getAddressFromLatLong(_currentPosition!);

    setState(() {
      _currentAddress = address;

      isLoading = false;
    });
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
                      boxFit: BoxFit.cover,
                      imageUrl: widget.kunjungan.fotoKunjungan!,
                      errorWidget: Image.network(
                          'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
                    ),
                    const Positioned.fill(
                      right: 10,
                      bottom: 10,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Chip(
                            backgroundColor: Colors.grey,
                            labelPadding: EdgeInsets.all(5),
                            label: Text(
                              "Terakhir dikunjungi pada 10 juni 2022",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )),
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
                        "Nomor Pelanggan",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "#${widget.kunjungan.nomorPelanggan!}",
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Nomor Meteran",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(widget.kunjungan.nomorMeteran!),
                      const SizedBox(height: 20),
                      const Text(
                        "Nama Kunjungan",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(widget.kunjungan.namaKunjungan!),
                      const SizedBox(height: 20),
                      const Text(
                        "Alamat",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(widget.kunjungan.alamat!),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: isLoading
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
                                  "Ulangi ambil alamat",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Catatan",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(widget.kunjungan.catatan!),
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
                          onPressed: () {},
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
                            //buildOkDialog(context);

                            pushNewScreen(
                              context,
                              screen: FormKunjungan(),
                              withNavBar:
                                  false, // OPTIONAL VALUE. True by default.
                              pageTransitionAnimation:
                                  PageTransitionAnimation.fade,
                            );
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
