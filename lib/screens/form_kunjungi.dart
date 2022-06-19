import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geprec_app/screens/widgets/draft_helper.dart';
import 'package:geprec_app/services/kunjungan_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

class FormKunjungan extends StatefulWidget {
  Map<String, dynamic> data;
  FormKunjungan({required this.data, Key? key}) : super(key: key);

  @override
  State<FormKunjungan> createState() => _FormKunjunganState();
}

class _FormKunjunganState extends State<FormKunjungan> {
  TextEditingController noMeteranController = TextEditingController();
  TextEditingController idGasPelangganController = TextEditingController();

  Position? _currentPosition;
  Position? _pos;

  @override
  void initState() {
    _getCurrentPosition();
    super.initState();
  }

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

    setState(() {
      _pos = _currentPosition;
    });
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
  void dispose() {
    noMeteranController.dispose();
    idGasPelangganController.dispose();
    super.dispose();
  }

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  String? base64ImageFile;

  void _setImageFileListFromFile(XFile? value) {
    _imageFile = value;
  }

  Future<void> takePhoto({BuildContext? context}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
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
    } catch (e) {
      print(e);
    }
  }

  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final _wajibValidator = MultiValidator([
    RequiredValidator(errorText: 'Harap isi kolom ini'),
  ]);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Form Kunjungan"),
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Foto Meteran",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        buildTutorial(context);
                      },
                      icon: const Icon(Icons.info),
                    ),
                  ],
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
                              const Text("Ambil Foto"),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "ID Gas Pelanggan",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: idGasPelangganController,
                  validator: _wajibValidator,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Masukan id gas pelanggan',
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Pembacaan Meter",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: noMeteranController,
                  validator: _wajibValidator,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Masukan pembacaan meter',
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
                      if (_formKey.currentState!.validate()) {
                        if (_imageFile != null) {
                          setState(() {
                            isLoading = true;
                          });

                          simpanData();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Harap ambil foto meteran"),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  simpanData() async {
    Map<String, dynamic> data = {
      "id_pengguna": widget.data['id_pengguna'],
      "id_kunjungan": widget.data['id_kunjungan'],
      "foto_meteran": base64ImageFile,
      "foto_selfie": widget.data['foto_selfie'],
      "pembacaan_meter": noMeteranController.text,
      "id_gas_pelanggan": idGasPelangganController.text,
      "latitude": _pos!.latitude.toString(),
      "longitude": _pos!.longitude.toString(),
      "tgl_kunjungan": DateFormat('yyyy-MM-dd kk:mm:ss').format(DateTime.now()),
    };

    bool result = await KunjunganService.ngunjungi(data);

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text("Berhasil menambahkan kunjungan"),
          ),
        ),
      );

      setState(() {
        isLoading = false;
      });

      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } else {
      print("gagal");

      setState(() {
        isLoading = false;
      });

      buildConfirmationDialog(context, data);

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Padding(
      //       padding: EdgeInsets.only(bottom: 10),
      //       child: Text("Gagal menambahkan kunjungan. Coba lagi."),
      //     ),
      //   ),
      // );
    }
  }

  void buildConfirmationDialog(
      BuildContext context, Map<String, dynamic> data) {
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
            height: MediaQuery.of(context).size.height * 0.47,
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
                      "Gagal menyimpan data kunjungan. Simpan sebagai draft?",
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
                            backgroundColor: Colors.red),
                        onPressed: () {
                          DraftHelper().saveDataDraft(data);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child:
                                    Text("Berhasil menyimpan draft kunjungan"),
                              ),
                            ),
                          );

                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "IYA",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: SizedBox(
                      width: 213,
                      height: 55,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary),
                        child: Text("COBA LAGI",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                ?.copyWith(color: Colors.white)),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
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

  buildTutorial(BuildContext context) {
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
            height: MediaQuery.of(context).size.height * 0.55,
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
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Cara Mengambil Foto",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(fontWeight: FontWeight.normal),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Image(
                    width: MediaQuery.of(context).size.width,
                    image: const AssetImage('assets/images/panduan.jpg'),
                  ),
                  // FancyShimmerImage(
                  //   width: double.infinity,
                  //   boxFit: BoxFit.cover,
                  //   imageUrl:
                  //       "https://static.wixstatic.com/media/2c800d_0a210df4abec444aaa8a9220bc973b97~mv2.jpg/v1/fit/w_1000%2Ch_1000%2Cal_c%2Cq_80/file.jpg",
                  //   errorWidget: Image.network(
                  //       'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
                  // ),
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
