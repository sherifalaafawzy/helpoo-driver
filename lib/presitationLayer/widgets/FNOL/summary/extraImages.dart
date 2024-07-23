import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../imageView.dart';
import '../../../../dataLayer/Constants/variables.dart';
import '../../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import 'dart:io' as io;

class extraImages extends StatelessWidget {
  const extraImages({super.key});

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<FnolBloc>(context);

    return Column(
      children: [
        bloc.fnol.airBagImages.length == 0
            ? const SizedBox(
                width: 100,
                height: 100,
                child: Text('extra photos'),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Text(
                  "Extra Photos".tr,
                  style: GoogleFonts.tajawal(
                    textStyle: const TextStyle(
                      color: appBlack,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 18.0,
                    ),
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
        bloc.fnol.airBagImages.length == 0
            ? const SizedBox(
                width: 0,
                height: 0,
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SizedBox(
                  height: 210,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: bloc.fnol.airBagImages.length,
                    // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 2),
                    itemBuilder: (_, idx) => bloc.fnol.airBagImages.length > idx
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: buildImageItem(idx, bloc, context),
                          )
                        : Container(),
                  ),
                ),
              ),
      ],
    );
  }

  Widget buildImageItem(int idx, bloc, ctx) {
    if (bloc.fnol.requiredImagesList == null) {
      return Container();
    }
    var key = bloc.fnol.requiredImagesList![idx];
    String? img = bloc.fnol.getImageObject(key);
    // String desc = bloc.fnol.getImageDescription(key);
    debugPrint('key is = $key');
    if (img == null) {
      return FutureBuilder<String?>(
        future: bloc.fnol.getImage('air_bag_images' + (idx).toString()),
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if ((snapshot.data == null || snapshot.data!.isEmpty) &&
              bloc.fnol.getImageDescription(key) == "air_bag_images") {
            return const SizedBox();
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Text(bloc.fnol.getImageDescription(key));
          } else {
            return Column(
              children: [
                // Text(key),
                Container(
                    height: 170,
                    child:
                        Image.file(io.File(snapshot.data!), fit: BoxFit.cover)),
                Text('extra ' + (idx + 1).toString()),
                // Image.asset(snapshot.data!),
              ],
            );
          }
        },
      );
    }
    return GestureDetector(
      onTap: () {
        Get.to(imageView(img: img));
        // showImageViewer(context, NetworkImage(img.data.attributes.url));
        showImageViewer(ctx, AssetImage('asstes/imgs/City driver-amico.png'));
      },
      child: Container(
        width: 263,
        height: 182,
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(
              12,
            ),
          ),
          color: appWhite,
        ),
        child: Column(
          children: [
            Container(
              width: 263,
              height: 182,
              decoration: BoxDecoration(
                border: Border.all(
                  color: mainColor,
                  width: 3,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    12,
                  ),
                ),
                image: DecorationImage(
                  image: AssetImage('asstes/imgs/City driver-amico.png'),
                  //  NetworkImage(
                  //   img.data.attributes.url,
                  // ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 4),
            Text(
              bloc.fnol.getImageDescription(key),
              style: GoogleFonts.tajawal(
                textStyle: const TextStyle(
                  color: mainColor,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 15.0,
                ),
              ),
              textAlign: TextAlign.right,
            )
          ],
        ),
      ),
    );
  }
}
