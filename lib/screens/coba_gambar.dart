import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as ui;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_exif_plugin/flutter_exif_plugin.dart' as dd;
import 'package:image_watermark/image_watermark.dart';
import 'package:stamp_image/stamp_image.dart';

class CobaGambar extends StatefulWidget {
  CobaGambar({Key? key}) : super(key: key);

  @override
  State<CobaGambar> createState() => _CobaGambarState();
}

class _CobaGambarState extends State<CobaGambar> {
  Position? _currentPosition;
  bool isLoading = false;
  Position? pos;

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
  }

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
      pos = _currentPosition;
      print(pos);
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

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  String? base64ImageFile;
  File? img;
  var _image;
  var imgBytes;
  var imgBytes2;
  var watermarkedImgBytes;

  File? _originalImage;
  File? _watermarkedImage;

  void _setImageFileListFromFile(XFile? value) {
    _imageFile = value;
  }

  ///Resetting an image file
  // Future resetImage() async {
  //   setState(() {
  //     img = null;
  //   });
  // }

  // ///Handler when stamp image complete
  // void resultStamp(File? file) {
  //   print(file?.path);
  //   setState(() {
  //     img = file;
  //   });
  // }

  void takePhoto() async {
    XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );

    if (image != null) {
      _image = image;
      var t = await image.readAsBytes();
      imgBytes = Uint8List.fromList(t);
    }

    // watermarkedImgBytes = await image_watermark.addImageWatermark(
    //     imgBytes, //image bytes
    //     imgBytes2, //watermark img bytes
    //     imgHeight: 200, //watermark img height
    //     imgWidth: 200, //watermark img width
    //     dstY: 400,
    //     dstX: 400);

    var watermarkedImg = await image_watermark.addTextWatermark(
      imgBytes,

      ///image bytes
      pos!.toString(),

      ///watermark text
      50,

      ///position of watermark x coordinate
      50,

      ///y coordinate
      color: Colors.yellow,
    );

    watermarkedImgBytes = watermarkedImg;

    setState(() {});
    // final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    // setState(() {
    //   _originalImage = File(pickedFile!.path);
    // });

    // ui.Image? originalImage = ui.decodeImage(_originalImage!.readAsBytesSync());

    // ui.drawString(originalImage!, ui.arial_24, 100, 120, 'Think Different');

    // // Store the watermarked image to a File
    // List<int> wmImage = ui.encodePng(originalImage);

    // setState(() {
    //   _watermarkedImage = File.fromRawPath(Uint8List.fromList(wmImage));
    // });

    //   // StampImage.create(
    //   //   context: context,
    //   //   image: File(pickedFile.path),
    //   //   children: [
    //   //     Positioned(
    //   //       bottom: 0,
    //   //       right: 0,
    //   //       child: Text("hello"),
    //   //     ),
    //   //     // Positioned(
    //   //     //   top: 0,
    //   //     //   left: 0,
    //   //     //   child: _logoFlutter(),
    //   //     // )
    //   //   ],
    //   //   onSuccess: (file) {
    //   //     setState(() {
    //   //       img = file;
    //   //     });
    //   //   },
    //   // );
    // }
    // XFile? image = await _picker.pickImage(
    //   source: ImageSource.camera,
    //   imageQuality: 90,
    // );

    // if (image != null) {
    //   _image = image;
    //   var t = await image.readAsBytes();
    //   imgBytes = Uint8List.fromList(t);
    // }

    // var watermarkedImg = await image_watermark.addTextWatermarkCentered(
    //   imgBytes,

    //   ///image bytes
    //   pos!.toString(),

    //   ///watermark text
    //   // 50,

    //   // ///position of watermark x coordinate
    //   // 50,

    //   ///y coordinate
    //   color: Colors.yellow,
    // );

    // watermarkedImgBytes = watermarkedImg;

    // setState(() {});
    // _picker.pickImage(source: ImageSource.camera).then((pickedFile) async {
    //   var myImagePath = "/data/user/0/com.geprec.geprec_app/cache";

    //   final exif = dd.FlutterExif.fromBytes(await pickedFile!.readAsBytes());

    //   Position position = pos!;

    //   var watermarkedImg = await image_watermark.addTextWatermark(
    //     await pickedFile.readAsBytes(),

    //     ///image bytes
    //     'watermarkText',

    //     ///watermark text
    //     20,

    //     ///position of watermark x coordinate
    //     30,

    //     ///y coordinate
    //     color: Colors.green,
    //   );

    //   ///default : Colors.white

    //   // await exif.setLatLong(position.latitude, position.longitude);
    //   // await exif.saveAttributes();

    //   // final modifiedImage = await exif.imageData;
    //   var imageName = DateTime.now().toIso8601String();
    //   File imageFile = File("$myImagePath/$imageName.jpg");
    //   imageFile.writeAsBytes(
    //     List.from(watermarkedImg),
    //   );

    //   print(imageFile.path);

    //   setState(() {
    //     img = imageFile;
    //   });
    // });
    // try {
    //   final XFile? pickedFile = await _picker.pickImage(
    //     source: ImageSource.camera,
    //   );

    //   // setState(() {
    //   //   _setImageFileListFromFile(pickedFile);
    //   // });

    //   var bytes = File(pickedFile!.path).readAsBytesSync();
    //   final exif = dd.FlutterExif.fromBytes(bytes);

    //   Position position = pos!;

    //   await exif.setLatLong(position.latitude, position.longitude);
    //   exif.setAttribute("hello", "my comment");
    //   await exif.saveAttributes();

    //   final modifiedImage = await exif.imageData;
    //   File imageFile = File(pickedFile.path);
    //   imageFile.writeAsBytes(
    //     List.from(modifiedImage!),
    //   );

    //   setState(() {
    //     img = imageFile;
    //   });
    // } catch (e) {
    //   print(e);
    // }
  }

  editImage() {
    final picker = ImagePicker();

    picker.pickImage(source: ImageSource.camera).then((pickedFile) async {
      var myImagePath = pickedFile!.path;

      final exif = dd.FlutterExif.fromPath(myImagePath);

      //final exif = dd.FlutterExif.fromBytes(await pickedFile!.readAsBytes());

      Position position = pos!;

      await exif.setLatLong(position.latitude, position.longitude);
      await exif.saveAttributes();

      final modifiedImage = await exif.imageData;
      var imageName = "imgName..";
      File imageFile = File("$myImagePath/$imageName.jpg");
      imageFile.writeAsBytes(
        List.from(modifiedImage!),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  takePhoto();
                },
                child: Container(
                  height: watermarkedImgBytes != null
                      ? null
                      : MediaQuery.of(context).size.height * 0.2,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  padding: watermarkedImgBytes != null
                      ? const EdgeInsets.all(0)
                      : const EdgeInsets.all(10),
                  child: watermarkedImgBytes != null
                      ? Image.memory(
                          watermarkedImgBytes!,
                          fit: BoxFit.contain,
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
            ],
          ),
        ),
      ),
    );
  }
}
