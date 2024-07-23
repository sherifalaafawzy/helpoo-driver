import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/presitationLayer/widgets/FNOL/summary/gallary_view.dart';
import '../../../../dataLayer/constants/variables.dart';
import '../../../../dataLayer/models/FNOL.dart';
import '../../../../dataLayer/models/imagesModel.dart';

class imagesSlider extends StatefulWidget {
  final FNOL fnol;
  final List<ImagesModel> images;

  const imagesSlider({
    Key? key,
    required this.fnol,
    required this.images,
  }) : super(key: key);

  @override
  State<imagesSlider> createState() => _imagesSliderState();
}

class _imagesSliderState extends State<imagesSlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: Get.width * .86,
          height: Get.height * .26,
          child: buildListView(widget.fnol, widget.images),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget buildListView(fnol, images) {
    if (images == null) {
      return Container();
    }
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images!.length,
        itemBuilder: (ctx, idx) {
          return buildImageItem(idx, fnol, images);
        });
  }

  Widget buildImageItem(int idx, fnol, images) {
    if (images == null) {
      return Container();
    }

    var key = images![idx].imageName;
    // String? img = fnol.getImageObject(key);
    // String desc = fnol.getImageDescription(key);
    // if (img == null) {
    //   return Column(
    //     children: [
    //       Container(
    //           height: 170,
    //           child: Image.network(
    //               assetsUrl + images[idx].imagePath)),
    //       Text(desc),
    //     ],
    //   );

    // }
    return GestureDetector(
      onTap: () {
        // Get.to(imageView(
        //     img: assetsUrl + images[idx].imagePath));
        //***********************************
        // showImageViewer(
        //   context,
        //   // NetworkImage(
        //   //     assetsUrl + images[idx].imagePath),
        //
        //   CachedNetworkImageProvider(
        //     assetsUrl + images[idx].imagePath,
        //   ),
        //
        Get.to(
          GalleryView(
            images: images,
          ),
        );
        //   // CachedNetworkImage(
        //   //   placeholder: (context, url) => const CircularProgressIndicator(),
        //   //   imageUrl: assetsUrl + images[idx].imagePath,
        //   // ),
        // );
        //***********************************
      },
      child: Container(
        width: Get.width * .6,
        height: Get.height * .2,
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
              width: Get.width * .6,
              height: Get.height * .2,
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
                  image: NetworkImage(assetsUrl + images[idx].imagePath),
                  //  NetworkImage(
                  //   img.data.attributes.url,
                  // ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 4),
            images[idx].additional == false
                ? Text(
                    fnol.getImageDescription(key),
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
                : Container()
          ],
        ),
      ),
    );
  }
}
