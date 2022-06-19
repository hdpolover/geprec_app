import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geprec_app/screens/daftar_kunjungan.dart';
import 'package:geprec_app/screens/profil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/kunjungan_model.dart';
import '../models/pengguna_model.dart';
import '../services/kunjungan_service.dart';
import 'detail_kunjungan.dart';

class Home extends StatefulWidget {
  PenggunaModel pengguna;
  Home({required this.pengguna, Key? key}) : super(key: key);

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  final Completer<GoogleMapController> _controller = Completer();
  double? latTerakhir, longTerakhir;

  List<KunjunganModel>? kunjungan;

  Future saveLokasiTerakhir(
    String lat,
    String lng,
  ) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("lat", lat);
    prefs.setString("lng", lng);
  }

  Future getLokasiTerakhir() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      latTerakhir = double.parse(prefs.getString("lat") ?? "-6.2292488");
      longTerakhir = double.parse(prefs.getString("lng") ?? "107.0002226");
    });
  }

  CameraPosition geprec = const CameraPosition(
    target: LatLng(-6.2292488, 107.0002226),
    zoom: 17,
  );

  @override
  void initState() {
    getLokasiTerakhir();
    super.initState();
  }

  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    List<KunjunganModel> rawSc =
        await KunjunganService.getDaftarKunjungan(widget.pengguna.idPengguna!);

    setState(() {
      kunjungan = rawSc;
    });

    setState(() {
      _markers.clear();
      for (final k in kunjungan!) {
        final marker = Marker(
          markerId: MarkerId(k.idKunjungan!),
          position: LatLng(
              double.parse(k.latitudeAwal!), double.parse(k.longitudeAwal!)),
          infoWindow: InfoWindow(
              title: k.namaKunjungan,
              snippet: k.alamat,
              onTap: () {
                pushNewScreen(
                  context,
                  screen: DetailKunjungan(
                    pengguna: widget.pengguna,
                    kunjungan: k,
                  ),
                  withNavBar: false, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.fade,
                );
              }),
        );
        _markers[k.namaKunjungan!] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Wrap(
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "button1",
              onPressed: _currentLocation,
              child: const Icon(Icons.my_location_rounded),
            ),
            const SizedBox(height: 10),
            FloatingActionButton.extended(
              heroTag: "button2",
              onPressed: () {
                //_showSettingsBottomSheet();
                pushNewScreen(
                  context,
                  screen: DaftarKunjungan(
                    pengguna: widget.pengguna,
                  ),
                  withNavBar: false, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.fade,
                );
              },
              icon: const Icon(Icons.list),
              label: const Text('Daftar Kunjungan'),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(latTerakhir!, longTerakhir!),
                    zoom: 17,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  markers: _markers.values.toSet(),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);

                    _onMapCreated(controller);
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: GestureDetector(
                onTap: () {
                  pushNewScreen(
                    context,
                    screen: Profil(
                      pengguna: widget.pengguna,
                    ),
                    withNavBar: false, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.fade,
                  );
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.09,
                  //color: Colors.black45,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(10)), //here
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 23.0,
                        backgroundImage:
                            NetworkImage(widget.pengguna.fotoPengguna!),
                      ),
                      trailing: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 30,
                      ),
                      title: Text(
                        "Hai, ${widget.pengguna.nama}",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    LocationData? currentLocation;

    var location = Location();

    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    saveLokasiTerakhir(currentLocation!.latitude.toString(),
        currentLocation.longitude.toString());

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
        zoom: 17.0,
      ),
    ));
  }
}
