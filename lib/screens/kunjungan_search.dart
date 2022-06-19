import 'package:flutter/material.dart';
import 'package:geprec_app/models/pengguna_model.dart';
import 'package:geprec_app/screens/widgets/kunjungan_item.dart';

import '../models/kunjungan_model.dart';

class KunjunganSearch extends SearchDelegate {
  List<KunjunganModel>? kunjungan;
  PenggunaModel pengguna;
  KunjunganModel? selectedResult;

  KunjunganSearch(this.kunjungan, this.pengguna);

  @override
  String get searchFieldLabel => "Cari daftar kunjungan";

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
    return KunjunganItem(
      kunjungan: selectedResult!,
      pengguna: pengguna,
      context: context,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<KunjunganModel> hasilSearchKunjungan = [];

    query.isEmpty
        ? hasilSearchKunjungan = kunjungan!
        : hasilSearchKunjungan.addAll(
            kunjungan!.where(
              (element) => element.namaKunjungan!.toLowerCase().contains(
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
              return KunjunganItem(
                kunjungan: hasilSearchKunjungan[index],
                pengguna: pengguna,
                context: context,
              );
            },
          );
  }
}
