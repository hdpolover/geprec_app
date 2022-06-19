import 'package:flutter/material.dart';
import 'package:geprec_app/models/pengguna_model.dart';
import 'package:geprec_app/models/riwayat_kunjungan_model.dart';
import 'package:geprec_app/screens/riwayat_search.dart';
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

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
      // builder: (context, child) => Theme(
      //     // data: ThemeData().copyWith(
      //     //   colorScheme:
      //     //       const ColorScheme.light(primary: CustomColors.colorGreen),
      //     // ),
      //     child: child!),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        //_dateController.text = DateFormat.MMMMEEEEd().format(selectedDate);
      });
    }
  }

  getDaftarRiwayatKunjungan() {
    return FutureBuilder(
      future: RiwayatKunjunganService.getRiwayatKunjungan(
          widget.pengguna.idPengguna!),
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
                    "Anda belum memiliki riwayat kunjungan. Silakan melakukan kunjungan terlebih dahulu.",
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
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
      appBar: AppBar(
        title: const Text("Riwayat Kunjungan"),
        actions: [
          // Navigate to the Search Screen
          // IconButton(
          //   onPressed: () {
          //     _selectDate(context);
          //   },
          //   icon: const Icon(Icons.calendar_today),
          // ),
          IconButton(
            onPressed: () {
              riwayat == null
                  ? null
                  : showSearch(
                      context: context,
                      delegate: RiwayatSearch(riwayat),
                    );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: getDaftarRiwayatKunjungan(),
        ),
      ),
    );
  }
}
