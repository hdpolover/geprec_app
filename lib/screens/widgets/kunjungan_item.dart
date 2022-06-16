import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:geprec_app/models/kunjungan_model.dart';
import 'package:geprec_app/screens/detail_kunjungan.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class KunjunganItem extends StatefulWidget {
  KunjunganModel kunjunganModel;
  KunjunganItem({required this.kunjunganModel, Key? key}) : super(key: key);

  @override
  State<KunjunganItem> createState() => _KunjunganItemState();
}

class _KunjunganItemState extends State<KunjunganItem> {
  List<KunjunganModel> kunjungan = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushNewScreen(
          context,
          screen: DetailKunjungan(
            kunjungan: widget.kunjunganModel,
          ),
          withNavBar: false, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.fade,
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Expanded(
            child: Row(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FancyShimmerImage(
                      boxFit: BoxFit.cover,
                      imageUrl: widget.kunjunganModel.fotoKunjungan!,
                      errorWidget: Image.network(
                          'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "#${widget.kunjunganModel.nomorMeteran!}",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        Text(widget.kunjunganModel.namaKunjungan!),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.location_pin),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                widget.kunjunganModel.alamat!,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
