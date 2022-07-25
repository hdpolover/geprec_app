import 'package:flutter/material.dart';
import 'package:geprec_app/models/kunjungan_model.dart';
import 'package:geprec_app/models/pengguna_model.dart';
import 'package:geprec_app/screens/kunjungan_search.dart';
import 'package:geprec_app/screens/tambah_kunjungan.dart';
import 'package:geprec_app/screens/widgets/kunjungan_item.dart';
import 'package:geprec_app/services/kunjungan_service.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class DaftarKunjungan extends StatefulWidget {
  PenggunaModel pengguna;
  DaftarKunjungan({required this.pengguna, Key? key}) : super(key: key);

  @override
  State<DaftarKunjungan> createState() => _DaftarKunjunganState();
}

class _DaftarKunjunganState extends State<DaftarKunjungan> {
  List<KunjunganModel>? kunjungan;

  @override
  void initState() {
    _getDaftar();
    super.initState();
  }

  Future _getDaftar() async {
    setState(() {
      kunjungan = [];
    });

    List<KunjunganModel> rawSc =
        await KunjunganService.getDaftarKunjungan(widget.pengguna.idPengguna!);

    setState(() {
      kunjungan = rawSc;
    });
  }

  getDaftarKunjungan() {
    return FutureBuilder(
      future: KunjunganService.getDaftarKunjungan(widget.pengguna.idPengguna!),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Padding(
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
                    "Anda belum memiliki daftar kunjungan. Silakan hubungi admin atau tambahkan kunjungan baru.",
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        List<KunjunganModel> rawSc = snapshot.data as List<KunjunganModel>;

        kunjungan = rawSc
            //.where((element) => element.status == "1")
            .toList();
        // .reversed
        // .toList();

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          itemCount: kunjungan!.length,
          itemBuilder: (context, index) {
            return KunjunganItem(
              kunjungan: kunjungan![index],
              pengguna: widget.pengguna,
              context: context,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Kunjungan"),
        centerTitle: true,
        elevation: 1,
        actions: [
          // Navigate to the Search Screen
          IconButton(
            onPressed: () {
              kunjungan == null
                  ? null
                  : showSearch(
                      context: context,
                      delegate: KunjunganSearch(kunjungan, widget.pengguna),
                    );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _getDaftar,
        child: getDaftarKunjungan(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "button2",
        onPressed: () {
          pushNewScreen(
            context,
            screen: TambahKunjungan(
              pengguna: widget.pengguna,
            ),
            withNavBar: false, // OPTIONAL VALUE. True by default.
            pageTransitionAnimation: PageTransitionAnimation.fade,
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Kunjungan'),
      ),
    );
  }
}
