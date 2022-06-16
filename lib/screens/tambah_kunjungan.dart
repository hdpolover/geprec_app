import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class TambahKunjungan extends StatefulWidget {
  TambahKunjungan({Key? key}) : super(key: key);

  @override
  State<TambahKunjungan> createState() => _TambahKunjunganState();
}

class _TambahKunjunganState extends State<TambahKunjungan> {
  TextEditingController noMeteranController = TextEditingController();
  TextEditingController noPelangganController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController namaRumahController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  void dispose() {
    noMeteranController.dispose();
    noPelangganController.dispose();
    addressController.dispose();
    namaRumahController.dispose();
    noteController.dispose();
    super.dispose();
  }

  PlatformFile? pickedFile;

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  void _setImageFileListFromFile(XFile? value) {
    _imageFile = value;
  }

  Future<void> takePhoto({BuildContext? context}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );
      setState(() {
        _setImageFileListFromFile(pickedFile);
      });
    } catch (e) {
      print(e);
    }
  }

  bool isLoading = false;

  String? url;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  // Future uploadFile(String packageId, PlatformFile platformFile) async {
  //   final path = 'orders/$packageId/${platformFile.name}';
  //   final file = File(platformFile.path!);

  //   final ref = FirebaseStorage.instance.ref().child(path);
  //   uploadTask = ref.putFile(file);

  //   final snapshot = await uploadTask!.whenComplete(() {});

  //   String a = await snapshot.ref.getDownloadURL();

  //   setState(() {
  //     url = a;
  //   });
  // }

  Position? _currentPosition;
  String? _currentAddress;

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
      addressController.text = _currentAddress!;

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
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Kunjungan"),
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Nomor Pelanggan",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: noPelangganController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Masukan nomor pelanggan',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Nomor Meteran",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: noMeteranController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Masukan nomor meteran',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Nama Rumah",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: namaRumahController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Masukan nama rumah',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Alamat",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: addressController,
                readOnly: true,
                autofocus: false,
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '-',
                ),
              ),
              const SizedBox(height: 5),
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
                          primary: _currentAddress == null
                              ? Theme.of(context).colorScheme.primary
                              : Colors.red, // background
                          onPrimary: Colors.white, // foreground
                        ),
                        icon: const Icon(Icons.location_pin),
                        label: Text(
                          _currentAddress == null
                              ? 'Ambil alamat sekarang'
                              : "Ulangi ambil alamat",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Catatan (patokan, detail rumah, dll) *opsional",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: noteController,
                minLines: 5,
                maxLines: 10,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Masukan catatan',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Foto Meteran",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  takePhoto(context: context);
                  //selectFile();
                },
                child: Container(
                  height: _imageFile != null ? null : height * 0.2,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  padding: _imageFile != null
                      ? const EdgeInsets.all(0)
                      : const EdgeInsets.all(10),
                  child: _imageFile != null
                      ? Image.file(
                          File(_imageFile!.path),
                          fit: BoxFit.cover,
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.upload,
                              size: 30,
                            ),
                            const SizedBox(height: 5),
                            const Text("Ambil Gambar"),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white, // foreground
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Simpan'),
                  onPressed: () {
                    // _savePackage();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
