import 'package:flutter/material.dart';
import 'package:geprec_app/models/pengguna_model.dart';
import 'package:geprec_app/models/riwayat_kunjungan_model.dart';
import 'package:geprec_app/screens/widgets/kunjungan_item.dart';
import 'package:geprec_app/screens/widgets/riwayat_kunjungan_item.dart';
import 'package:geprec_app/services/riwayat_kunjungan_service.dart';

class Riwayat extends StatefulWidget {
  PenggunaModel pengguna;
  Riwayat({required this.pengguna, Key? key}) : super(key: key);

  @override
  State<Riwayat> createState() => _RiwayatState();
}

class _RiwayatState extends State<Riwayat> {
  List<RiwayatKunjunganModel>? riwayat;

  getDaftarRiwayatKunjungan() {
    return FutureBuilder(
      future: RiwayatKunjunganService.getRiwayatKunjungan(
          widget.pengguna.idPengguna!),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<RiwayatKunjunganModel> rawSc =
            snapshot.data as List<RiwayatKunjunganModel>;

        riwayat = rawSc
            //.where((element) => element.status == "1")
            .toList();
        // .reversed
        // .toList();

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          itemCount: riwayat!.length,
          itemBuilder: (context, index) {
            return RiwayatKunjunganItem(
              riwayatKunjunganModel: riwayat![index],
              context: context,
            );
          },
        );
      },
    );
  }

  Future _onRefresh() async {
    List<RiwayatKunjunganModel> data =
        await RiwayatKunjunganService.getRiwayatKunjungan(
            widget.pengguna.idPengguna!);

    setState(() {
      riwayat = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Kunjungan")),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: getDaftarRiwayatKunjungan(),
        ),
      ),
    );
  }
}
