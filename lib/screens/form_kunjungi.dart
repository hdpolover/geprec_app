import 'dart:convert';
import 'dart:io';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class FormKunjungan extends StatefulWidget {
  const FormKunjungan({Key? key}) : super(key: key);

  @override
  State<FormKunjungan> createState() => _FormKunjunganState();
}

class _FormKunjunganState extends State<FormKunjungan> {
  TextEditingController noMeteranController = TextEditingController();
  TextEditingController idGasPelangganController = TextEditingController();

  @override
  void dispose() {
    noMeteranController.dispose();
    idGasPelangganController.dispose();
    super.dispose();
  }

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

      var bytes = File(_imageFile!.path).readAsBytesSync();
      String base64Image = base64Encode(bytes);

      File file = File(_imageFile!.path);
      String fileExtension = p.extension(file.path);

      setState(() {
        noMeteranController.text =
            "data:image/${fileExtension.split('.').last};base64,$base64Image";
      });

      debugPrint(
          "data:image/${fileExtension.split('.').last};base64,$base64Image");
    } catch (e) {
      print(e);
    }
  }

  bool isLoading = false;

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
                            const Text("Ambil Gambar"),
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
              TextField(
                controller: idGasPelangganController,
                keyboardType: TextInputType.text,
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
              TextField(
                controller: noMeteranController,
                keyboardType: TextInputType.text,
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
                  },
                ),
              ),
            ],
          ),
        ),
      ),
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
            height: MediaQuery.of(context).size.height * 0.7,
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
                  FancyShimmerImage(
                    width: double.infinity,
                    boxFit: BoxFit.cover,
                    imageUrl:
                        "https://static.wixstatic.com/media/2c800d_0a210df4abec444aaa8a9220bc973b97~mv2.jpg/v1/fit/w_1000%2Ch_1000%2Cal_c%2Cq_80/file.jpg",
                    errorWidget: Image.network(
                        'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
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
