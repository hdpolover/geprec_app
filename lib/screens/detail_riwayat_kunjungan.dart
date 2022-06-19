import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:geprec_app/models/riwayat_kunjungan_model.dart';
import 'package:intl/intl.dart';

class DetailRiwayatKunjungan extends StatefulWidget {
  RiwayatKunjunganModel riwayatKunjungan;
  DetailRiwayatKunjungan({required this.riwayatKunjungan, Key? key})
      : super(key: key);

  @override
  State<DetailRiwayatKunjungan> createState() => _DetailRiwayatKunjunganState();
}

class _DetailRiwayatKunjunganState extends State<DetailRiwayatKunjungan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Riwayat Kunjungan"),
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Tanggal Kunjungan",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              DateFormat('yyyy-MM-dd – kk:mm').format(
                                widget.riwayatKunjungan.tglKunjungan!,
                              ),
                            ),
                          ],
                        ),
                      ),
                      buildChip(),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Foto Meteran",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  FancyShimmerImage(
                    width: double.infinity,
                    boxFit: BoxFit.contain,
                    imageUrl: widget.riwayatKunjungan.fotoMeteran!,
                    errorWidget: Image.network(
                        'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Foto Selfie",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  FancyShimmerImage(
                    width: double.infinity,
                    boxFit: BoxFit.contain,
                    imageUrl: widget.riwayatKunjungan.fotoSelfie!,
                    errorWidget: Image.network(
                        'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "ID Gas Pelanggan",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.riwayatKunjungan.idGasPelanggan!,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Pembacaan Meteran",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(widget.riwayatKunjungan.pembacaanMeter!),
                  const SizedBox(height: 20),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Chip buildChip() {
    int status = int.parse(widget.riwayatKunjungan.status!);

    Chip? c;

    switch (status) {
      case 0:
        c = const Chip(
          labelPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          label: Text("Menunggu validasi"),
          backgroundColor: Colors.yellow,
        );
        break;
      case 1:
        c = const Chip(
          labelPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          label: Text("Diterima"),
          backgroundColor: Colors.green,
        );
        break;
      default:
        c = const Chip(
          labelPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          label: Text("Ditolak"),
          backgroundColor: Colors.red,
        );
        break;
    }

    return c;
  }
}
