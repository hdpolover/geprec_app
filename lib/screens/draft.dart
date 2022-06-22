import 'package:flutter/material.dart';
import 'package:geprec_app/db/db_helper.dart';
import 'package:geprec_app/db/draft_model.dart';
import 'package:geprec_app/screens/widgets/draft_helper.dart';
import 'package:geprec_app/screens/widgets/draft_kunjungan_item.dart.dart';
import 'package:geprec_app/services/kunjungan_service.dart';

class Draft extends StatefulWidget {
  const Draft({Key? key}) : super(key: key);

  @override
  State<Draft> createState() => _DraftState();
}

class _DraftState extends State<Draft> {
  late List<DraftModel> draftKunjungan;
  bool isLoading = false;
  bool isLoadingBtn = false;

  @override
  void initState() {
    super.initState();

    getData();
  }

  Future getData() async {
    setState(() => isLoading = true);

    List<DraftModel> a = await DbHelper.instance.readAllDrafts();

    setState(() {
      draftKunjungan = a;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    DbHelper.instance.close();

    super.dispose();
  }

  getDataDratKunjungan() {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : draftKunjungan.isEmpty
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
            : ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                itemCount: draftKunjungan.length,
                itemBuilder: (context, index) {
                  return DraftKunjunganItem(
                    draft: draftKunjungan[index],
                    context: context,
                  );
                },
              );
  }

  simpanData() async {
    setState(() {
      isLoadingBtn = true;
    });

    for (int i = 0; i < draftKunjungan.length; i++) {
      String a = await DraftHelper().getGambar(draftKunjungan[i].fotoMeteran);
      String b = await DraftHelper().getGambar(draftKunjungan[i].fotoSelfie);

      Map<String, dynamic> data = {
        "id_pengguna": draftKunjungan[i].idPengguna,
        "id_kunjungan": draftKunjungan[i].idKunjungan,
        "foto_meteran": a,
        "foto_selfie": b,
        "pembacaan_meter": draftKunjungan[i].pembacaanMeter,
        "id_gas_pelanggan": draftKunjungan[i].idGasPelanggan,
        "latitude": draftKunjungan[i].latitudeD,
        "longitude": draftKunjungan[i].longitudeD,
        "tgl_kunjungan": draftKunjungan[i].tglKunjunganD,
      };

      await KunjunganService.ngunjungi(data);
      await DraftHelper().hapusGambar(draftKunjungan[i].fotoMeteran);
      await DraftHelper().hapusGambar(draftKunjungan[i].fotoSelfie);
      await DbHelper.instance.delete(draftKunjungan[i].id!);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text("Berhasil menambahkan semua draft kunjungan"),
        ),
      ),
    );

    setState(() {
      isLoadingBtn = false;
    });

    Navigator.of(context).pop();
    Navigator.of(context).pop();

    // } else {
    //   setState(() {
    //     isLoadingBtn = false;
    //   });

    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Padding(
    //         padding: EdgeInsets.only(bottom: 10),
    //         child: Text("Gagal menambahkan draft kunjungan. Coba lagi."),
    //       ),
    //     ),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Draft Kunjungan"),
        centerTitle: true,
        elevation: 1,
      ),
      floatingActionButton: isLoading
          ? null
          : draftKunjungan.isEmpty
              ? null
              : FloatingActionButton.extended(
                  heroTag: "button2",
                  onPressed: isLoadingBtn
                      ? null
                      : () {
                          //_showSettingsBottomSheet();
                          // pushNewScreen(
                          //   context,
                          //   screen: DaftarKunjungan(
                          //     pengguna: widget.pengguna,
                          //   ),
                          //   withNavBar: false, // OPTIONAL VALUE. True by default.
                          //   pageTransitionAnimation: PageTransitionAnimation.fade,
                          // );
                          simpanData();
                        },
                  icon: isLoadingBtn ? null : const Icon(Icons.save),
                  label: isLoadingBtn
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text('Simpan Semua Draft'),
                ),
      body: getDataDratKunjungan(),
    );
  }
}
