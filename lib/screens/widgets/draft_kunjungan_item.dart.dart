import 'dart:convert';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:geprec_app/db/draft_model.dart';
import 'package:geprec_app/screens/widgets/draft_helper.dart';
import 'package:intl/intl.dart';

class DraftKunjunganItem extends StatefulWidget {
  DraftModel draft;
  BuildContext context;
  DraftKunjunganItem({required this.context, required this.draft, Key? key})
      : super(key: key);

  @override
  State<DraftKunjunganItem> createState() => _DraftKunjunganItemState();
}

class _DraftKunjunganItemState extends State<DraftKunjunganItem> {
  String? fotoM, fotoS;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    getFoto();
  }

  getFoto() async {
    setState(() {
      isLoading = true;
    });

    String a = await DraftHelper().getGambar(widget.draft.fotoMeteran);
    String b = await DraftHelper().getGambar(widget.draft.fotoSelfie);

    setState(() {
      fotoM = a;
      fotoS = b;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // pushNewScreen(
        //   context,
        //   screen: DetailRiwayatKunjungan(
        //     riwayatKunjungan: widget.draft,
        //   ),
        //   withNavBar: false, // OPTIONAL VALUE. True by default.
        //   pageTransitionAnimation: PageTransitionAnimation.fade,
        // );
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
                  "Dikunjungi pada ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(widget.draft.tglKunjunganD))}",
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Foto Meteran",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(height: 5),
                      //isLoading ? CircularProgressIndicator() : Text(fotoM!),
                      isLoading
                          ? const CircularProgressIndicator()
                          : Image.memory(
                              base64Decode(
                                fotoM!.substring(22),
                              ),
                              fit: BoxFit.cover,
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width * 0.4,
                            ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Foto Selfie",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(height: 5),
                      isLoading
                          ? const CircularProgressIndicator()
                          : fotoS == ""
                              ? FancyShimmerImage(
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  boxFit: BoxFit.cover,
                                  imageUrl: "",
                                  errorWidget: Image.network(
                                      'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
                                )
                              : isLoading
                                  ? const CircularProgressIndicator()
                                  : Image.memory(
                                      base64Decode(
                                        fotoS!.substring(22),
                                      ),
                                      fit: BoxFit.cover,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.12,
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                    ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ID Gas Pelanggan",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(height: 5),
                      Text(widget.draft.idGasPelanggan),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pembacaan Meter",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(height: 5),
                      Text(widget.draft.pembacaanMeter),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
