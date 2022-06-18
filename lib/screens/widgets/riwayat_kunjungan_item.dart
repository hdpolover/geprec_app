import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:geprec_app/models/kunjungan_model.dart';
import 'package:geprec_app/models/riwayat_kunjungan_model.dart';
import 'package:geprec_app/screens/detail_kunjungan.dart';
import 'package:geprec_app/screens/detail_riwayat_kunjungan.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class RiwayatKunjunganItem extends StatefulWidget {
  RiwayatKunjunganModel riwayatKunjunganModel;
  BuildContext context;
  RiwayatKunjunganItem(
      {required this.context, required this.riwayatKunjunganModel, Key? key})
      : super(key: key);

  @override
  State<RiwayatKunjunganItem> createState() => _RiwayatKunjunganItemState();
}

class _RiwayatKunjunganItemState extends State<RiwayatKunjunganItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushNewScreen(
          context,
          screen: DetailRiwayatKunjungan(
            riwayatKunjungan: widget.riwayatKunjunganModel,
          ),
          withNavBar: false, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.fade,
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Dikunjungi pada ${DateFormat('dd/MM/yyyy HH:mm').format(widget.riwayatKunjunganModel.tglKunjungan!)}",
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.12,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FancyShimmerImage(
                        boxFit: BoxFit.cover,
                        imageUrl: widget.riwayatKunjunganModel.fotoMeteran!,
                        errorWidget: Image.network(
                            'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "#${widget.riwayatKunjunganModel.idGasPelanggan!}",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        Text(widget.riwayatKunjunganModel.pembacaanMeter!),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [buildChip()],
              )
            ],
          ),
        ),
      ),
    );
  }

  Chip buildChip() {
    int status = int.parse(widget.riwayatKunjunganModel.status!);

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
