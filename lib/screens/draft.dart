import 'dart:convert';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:geprec_app/models/riwayat_kunjungan_model.dart';
import 'package:geprec_app/screens/widgets/draft_helper.dart';
import 'package:geprec_app/services/kunjungan_service.dart';
import 'package:intl/intl.dart';

class Draft extends StatefulWidget {
  const Draft({Key? key}) : super(key: key);

  @override
  State<Draft> createState() => _DraftState();
}

class _DraftState extends State<Draft> {
  Map<String, dynamic>? draftKunjungan;
  bool isLoading = false;

  getDataDratKunjungan() {
    return FutureBuilder(
      future: DraftHelper().getDataDraft(),
      builder: (context, snapshot) {
        RiwayatKunjunganModel.fromMap(snapshot.data as Map<String, dynamic>);

        draftKunjungan = snapshot.data as Map<String, dynamic>;

        return draftKunjungan!['id_kunjungan'] == ""
            ? Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.warning,
                              color: Colors.red,
                              size: 50,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Tidak ada draft. Silakan simpan kunjungan sebagai draft terlebih dahulu.",
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          "Tanggal Kunjungan",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          draftKunjungan!['tgl_kunjungan'],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Foto Meteran",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Image.memory(base64Decode(
                            draftKunjungan!['foto_meteran'].substring(22))),
                        const SizedBox(height: 20),
                        const Text(
                          "Foto Selfie",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        draftKunjungan!['foto_selfie'] == ""
                            ? Center(
                                child: FancyShimmerImage(
                                  boxFit: BoxFit.cover,
                                  imageUrl: "",
                                  errorWidget: Image.network(
                                      'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
                                ),
                              )
                            : Image.memory(base64Decode(
                                draftKunjungan!['foto_selfie'].substring(22))),
                        const SizedBox(height: 20),
                        const Text(
                          "ID Gas Pelanggan",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          draftKunjungan!['id_gas_pelanggan'],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Pembacaan Meteran",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(draftKunjungan!['pembacaan_meter']),
                        const SizedBox(height: 20),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
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
                              setState(() {
                                isLoading = true;
                              });

                              simpanData();
                            },
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                      ],
                    ),
                  ),
                ],
              );
      },
    );
  }

  simpanData() async {
    Map<String, dynamic> data = {
      "id_pengguna": draftKunjungan!['id_pengguna'],
      "id_kunjungan": draftKunjungan!['id_kunjungan'],
      "foto_meteran": draftKunjungan!['foto_meteran'],
      "foto_selfie": draftKunjungan!['foto_selfie'],
      "pembacaan_meter": draftKunjungan!['pembacaan_meter'],
      "id_gas_pelanggan": draftKunjungan!['id_gas_pelanggan'],
      "latitude": draftKunjungan!['latitude'],
      "longitude": draftKunjungan!['longitude'],
      "tgl_kunjungan": DateFormat('yyyy-MM-dd kk:mm:ss')
          .format(DateTime.parse(draftKunjungan!['tgl_kunjungan'])),
    };

    bool result = await KunjunganService.ngunjungi(data);

    if (result) {
      DraftHelper().hapusDataDraft();

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
    } else {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text("Gagal menambahkan kunjungan. Coba lagi."),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Draft Kunjungan"),
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: getDataDratKunjungan(),
      ),
    );
  }
}
