import 'package:flutter/material.dart';
import 'package:geprec_app/models/pengguna_model.dart';
import 'package:geprec_app/models/riwayat_kunjungan_model.dart';
import 'package:geprec_app/screens/widgets/kunjungan_item.dart';
import 'package:geprec_app/screens/widgets/riwayat_kunjungan_item.dart';

import '../models/kunjungan_model.dart';

class RiwayatSearch extends SearchDelegate {
  List<RiwayatKunjunganModel>? riwayat;
  RiwayatKunjunganModel? selectedResult;

  RiwayatSearch(this.riwayat);

  @override
  String get searchFieldLabel => "Cari riwayat kunjungan (ID gas pelanggan)";

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return RiwayatKunjunganItem(
      riwayatKunjunganModel: selectedResult!,
      context: context,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<RiwayatKunjunganModel> hasilSearchKunjungan = [];

    query.isEmpty
        ? hasilSearchKunjungan = riwayat!
        : hasilSearchKunjungan.addAll(
            riwayat!.where(
              (element) => element.idGasPelanggan!.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            ),
          );

    return hasilSearchKunjungan.isEmpty
        ? Padding(
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
                    "Tidak ditemukan data berdasarkan pencarian Anda. Coba lagi.",
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemCount: hasilSearchKunjungan.length,
            itemBuilder: (context, index) {
              return RiwayatKunjunganItem(
                riwayatKunjunganModel: hasilSearchKunjungan[index],
                context: context,
              );
            },
          );
  }
}
