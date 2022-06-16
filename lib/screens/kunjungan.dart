import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geprec_app/models/kunjungan_model.dart';
import 'package:geprec_app/screens/tambah_kunjungan.dart';
import 'package:geprec_app/screens/widgets/kunjungan_item.dart';
import 'package:latlong2/latlong.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class Kunjungan extends StatefulWidget {
  const Kunjungan({Key? key}) : super(key: key);

  @override
  State<Kunjungan> createState() => _KunjunganState();
}

class _KunjunganState extends State<Kunjungan> {
  String accessToken =
      "pk.eyJ1IjoiaGRwb2xvdmVyIiwiYSI6ImNsNDlxZm4yOTA2NWszaXMzZzM1c21hdmQifQ.Nw3fQgQk5OOL6nUIkdfUOg";

  List<KunjunganModel> kunjungan = [
    KunjunganModel(
        "1",
        "Rumah A",
        "989798",
        "009909",
        "Jl. Cenderawasih No. 11, Malang, Jawa Timur",
        "0",
        "0",
        "https://cf.shopee.co.id/file/0f9c4bdf86e566afba817d3b5b7ebf04",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."),
    KunjunganModel(
        "1",
        "Rumah B",
        "989798",
        "339830",
        "Jl. Indonesia No. 11, Malang, Jawa Timur",
        "0",
        "0",
        "https://cdn-2.tstatic.net/pontianak/foto/bank/images/ilustrasi-meteran-listrik-pln-1.jpg",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."),
    KunjunganModel(
        "1",
        "Rumah C",
        "989908",
        "003939",
        "Jl. Nusantara No. 12, Malang, Jawa Timur",
        "0",
        "0",
        "https://sudutpandang.id/wp-content/uploads/2020/03/Meteran-PLN-scaled-e1585323303198.jpg",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."),
  ];

  Position? _currentPosition;
  String? _currentAddress;
  double? latt, longg;

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
      latt = _currentPosition!.latitude;
      longg = _currentPosition!.longitude;
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Text("Berhasil mendapatkan lokasi sekarang"),
    )));
  }

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                _getCurrentPosition();
              },
              child: const Icon(Icons.my_location_rounded),
            ),
            const SizedBox(height: 10),
            FloatingActionButton.extended(
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
            options: MapOptions(
              center: latt == null
                  ? LatLng(-7.973006, 112.6079458)
                  : LatLng(latt!, longg!),
              zoom: 15.0,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/"
                    "{z}/{x}/{y}?access_token=$accessToken",
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    width: 100.0,
                    height: 100.0,
                    point: latt == null
                        ? LatLng(-7.973006, 112.6079458)
                        : LatLng(latt!, longg!),
                    builder: (ctx) => Icon(
                      Icons.my_location_rounded,
                      color: Theme.of(context).primaryColor,
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
                ],
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
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
                    leading: const CircleAvatar(
                      radius: 23.0,
                      backgroundImage: NetworkImage(
                          "https://images.unsplash.com/photo-1597466765990-64ad1c35dafc"),
                    ),
                    trailing: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    ),
                    title: Text(
                      "Hai, John Doe",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 16,
                            color: Colors.white,
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
                                screen: TambahKunjungan(),
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
          body: ListView.builder(
            controller: ModalScrollController.of(context),
            itemCount: kunjungan.length,
            itemBuilder: (context, index) {
              return KunjunganItem(
                kunjunganModel: kunjungan[index],
              );
            },
          ),
        );
      },

      //   builder: (builder) {
      //     return Container(
      //       padding: const EdgeInsets.all(10),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Padding(
      //             padding: const EdgeInsets.fromLTRB(20, 30, 20, 5),
      //             child: Row(
      //               children: [
      //                 Expanded(
      //                   child: Text(
      //                     "Daftar Kunjungan",
      //                     style: Theme.of(context).textTheme.subtitle1?.copyWith(
      //                           fontWeight: FontWeight.bold,
      //                           color: Colors.black,
      //                           fontSize: 23,
      //                         ),
      //                   ),
      //                 ),
      //                 ElevatedButton.icon(
      //                   onPressed: () {
      //                     pushNewScreen(
      //                       context,
      //                       screen: TambahKunjungan(),
      //                       withNavBar: false, // OPTIONAL VALUE. True by default.
      //                       pageTransitionAnimation: PageTransitionAnimation.fade,
      //                     );
      //                   },
      //                   icon: const Icon(Icons.add),
      //                   label: const Text(
      //                     "Tambah",
      //                     style: TextStyle(color: Colors.white),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //           const SizedBox(height: 20),
      //           const Divider(
      //             height: 1,
      //             thickness: 1,
      //             color: Colors.grey,
      //           ),
      //           const SizedBox(height: 10),
      //           SizedBox(
      //             width: MediaQuery.of(context).size.width,
      //             child: SingleChildScrollView(
      //               child: Column(
      //                 children: [
      //                   Text("jje"),
      //                   Text("jje"),
      //                   Text("jje"),
      //                   Text("jje"),
      //                   SizedBox(
      //                     height: MediaQuery.of(context).size.height * 0.25,
      //                     width: double.infinity,
      //                     child: ClipRRect(
      //                       borderRadius: BorderRadius.circular(10),
      //                       child: FancyShimmerImage(
      //                         boxFit: BoxFit.cover,
      //                         imageUrl:
      //                             "https://cf.shopee.co.id/file/0f9c4bdf86e566afba817d3b5b7ebf04",
      //                         errorWidget: Image.network(
      //                             'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
      //                       ),
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     height: MediaQuery.of(context).size.height * 0.25,
      //                     width: double.infinity,
      //                     child: ClipRRect(
      //                       borderRadius: BorderRadius.circular(10),
      //                       child: FancyShimmerImage(
      //                         boxFit: BoxFit.cover,
      //                         imageUrl:
      //                             "https://cf.shopee.co.id/file/0f9c4bdf86e566afba817d3b5b7ebf04",
      //                         errorWidget: Image.network(
      //                             'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
      //                       ),
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     height: MediaQuery.of(context).size.height * 0.25,
      //                     width: double.infinity,
      //                     child: ClipRRect(
      //                       borderRadius: BorderRadius.circular(10),
      //                       child: FancyShimmerImage(
      //                         boxFit: BoxFit.cover,
      //                         imageUrl:
      //                             "https://cf.shopee.co.id/file/0f9c4bdf86e566afba817d3b5b7ebf04",
      //                         errorWidget: Image.network(
      //                             'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
      //                       ),
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     height: MediaQuery.of(context).size.height * 0.25,
      //                     width: double.infinity,
      //                     child: ClipRRect(
      //                       borderRadius: BorderRadius.circular(10),
      //                       child: FancyShimmerImage(
      //                         boxFit: BoxFit.cover,
      //                         imageUrl:
      //                             "https://cf.shopee.co.id/file/0f9c4bdf86e566afba817d3b5b7ebf04",
      //                         errorWidget: Image.network(
      //                             'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
      //                       ),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //     );
      //   },
    );
  }
}
