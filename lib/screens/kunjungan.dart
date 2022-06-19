import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart' as g;
import 'package:geprec_app/models/kunjungan_model.dart';
import 'package:geprec_app/models/pengguna_model.dart';
import 'package:geprec_app/screens/profil.dart';
import 'package:geprec_app/screens/tambah_kunjungan.dart';
import 'package:geprec_app/screens/widgets/kunjungan_item.dart';
import 'package:geprec_app/services/kunjungan_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class Kunjungan extends StatefulWidget {
  PenggunaModel pengguna;
  Kunjungan({required this.pengguna, Key? key}) : super(key: key);

  @override
  State<Kunjungan> createState() => _KunjunganState();
}

class _KunjunganState extends State<Kunjungan> {
  String accessToken =
      "pk.eyJ1IjoiaGRwb2xvdmVyIiwiYSI6ImNsNDlxZm4yOTA2NWszaXMzZzM1c21hdmQifQ.Nw3fQgQk5OOL6nUIkdfUOg";

  List<KunjunganModel>? kunjungan;

  // Position? _currentPosition;
  // String? _currentAddress;
  // double? latt, longg;

  final g.GeolocatorPlatform _geolocatorPlatform =
      g.GeolocatorPlatform.instance;

  // Future<void> _getCurrentPosition() async {
  //   final hasPermission = await _handlePermission();

  //   if (!hasPermission) {
  //     return;
  //   }

  //   _currentPosition = await _geolocatorPlatform.getCurrentPosition(
  //       locationSettings: LocationSettings(
  //     accuracy: LocationAccuracy.high,
  //   ));

  //   String address = await getAddressFromLatLong(_currentPosition!);

  //   setState(() {
  //     _currentAddress = address;
  //     latt = _currentPosition!.latitude;
  //     longg = _currentPosition!.longitude;
  //   });

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Padding(
  //         padding: EdgeInsets.only(bottom: 10),
  //         child: Text("Berhasil mendapatkan lokasi sekarang"),
  //       ),
  //     ),
  //   );
  // }

  late final MapController mapController;

  LatLng? latLng;

  // Future<String> getAddressFromLatLong(Position position) async {
  //   List<Placemark> placemarks =
  //       await placemarkFromCoordinates(position.latitude, position.longitude);
  //   //print(placemarks);
  //   Placemark place = placemarks[0];
  //   return '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
  // }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    g.LocationPermission permission;

    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == g.LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == g.LocationPermission.denied) {
        return false;
      }
    }

    if (permission == g.LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  LocationData? _currentLocation;
  late final MapController _mapController;

  bool _liveUpdate = false;
  bool _permission = false;

  String? _serviceError = '';

  var interActiveFlags = InteractiveFlag.all;

  final Location _locationService = Location();

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    initLocationService();

    //_getCurrentPosition();
  }

  void initLocationService() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }

    await _locationService.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000,
    );

    LocationData? location;
    bool serviceEnabled;
    bool serviceRequestResult;

    try {
      location = await _locationService.getLocation();
      _currentLocation = location;
      _locationService.onLocationChanged.listen((LocationData result) async {
        if (mounted) {
          setState(() {
            _currentLocation = result;

            // If Live Update is enabled, move map center
            if (_liveUpdate) {
              _mapController.move(
                  LatLng(_currentLocation!.latitude!,
                      _currentLocation!.longitude!),
                  _mapController.zoom);
            }
          });
        }
      });
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      if (e.code == 'PERMISSION_DENIED') {
        _serviceError = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        _serviceError = e.message;
      }
      location = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    LatLng currentLatLng;

    // Until currentLocation is initially updated, Widget can locate to 0, 0
    // by default or store previous location value to show.
    if (_currentLocation != null) {
      currentLatLng =
          LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
    } else {
      currentLatLng = LatLng(0, 0);
    }

    var markers = <Marker>[
      Marker(
        width: 150.0,
        height: 150.0,
        point: currentLatLng,
        builder: (ctx) => const Icon(
          Icons.my_location,
          color: Colors.blue,
        ),
      ),
      Marker(
        width: 100.0,
        height: 100.0,
        point: LatLng(-7.973006, 112.6079458),
        builder: (ctx) => const Icon(
          Icons.location_pin,
          color: Colors.red,
        ),
      ),
    ];

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Wrap(
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "button1",
              onPressed: () {
                //_getCurrentPosition();
                initLocationService();
              },
              child: const Icon(Icons.my_location_rounded),
            ),
            const SizedBox(height: 10),
            FloatingActionButton.extended(
              heroTag: "button2",
              onPressed: () {
                _showSettingsBottomSheet();
              },
              icon: const Icon(Icons.list),
              label: const Text('Daftar Kunjungan'),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              center: LatLng(-7.973006, 112.6079458),
              zoom: 15.0,
              minZoom: 3.0,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/"
                    "{z}/{x}/{y}?access_token=$accessToken",
              ),
              MarkerLayerOptions(
                markers: markers,
              ),
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

  getDaftarKunjungan() {
    return FutureBuilder(
      future: KunjunganService.getDaftarKunjungan(widget.pengguna.idPengguna!),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<KunjunganModel> rawSc = snapshot.data as List<KunjunganModel>;

        kunjungan = rawSc
            //.where((element) => element.status == "1")
            .toList();
        // .reversed
        // .toList();

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 0),
          controller: ModalScrollController.of(context),
          itemCount: kunjungan!.length,
          itemBuilder: (context, index) {
            return KunjunganItem(
              pengguna: widget.pengguna,
              kunjungan: kunjungan![index],
              context: context,
            );
          },
        );
      },
    );
  }

  void _showSettingsBottomSheet() {
    showBarModalBottomSheet(
      context: context,
      barrierColor: Colors.black54,
      useRootNavigator: true,
      builder: (builder) {
        return NestedScrollView(
          controller: ScrollController(),
          physics: const ScrollPhysics(parent: PageScrollPhysics()),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Daftar Kunjungan",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 23,
                                  ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              pushNewScreen(
                                context,
                                screen: TambahKunjungan(
                                  pengguna: widget.pengguna,
                                ),
                                withNavBar:
                                    false, // OPTIONAL VALUE. True by default.
                                pageTransitionAnimation:
                                    PageTransitionAnimation.fade,
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text(
                              "Tambah",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ];
          },
          body: getDaftarKunjungan(),
          // body: ListView.builder(
          //   controller: ModalScrollController.of(context),
          //   itemCount: kunjungan.length,
          //   itemBuilder: (context, index) {
          //     return KunjunganItem(
          //       kunjunganModel: kunjungan[index],
          //     );
          //   },
          // ),
        );
      },
    );
  }
}
