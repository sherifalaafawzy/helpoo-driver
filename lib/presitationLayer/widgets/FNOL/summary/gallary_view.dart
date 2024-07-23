import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/dataLayer/Constants/variables.dart';
import 'package:helpoo/dataLayer/models/currentUser.dart';
import 'package:helpoo/dataLayer/models/imagesModel.dart';
import 'package:helpoo/service_request/core/util/extensions/build_context_extension.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:photo_view/photo_view.dart';

class GalleryView extends StatelessWidget {
  final List<ImagesModel> images;

  GalleryView({
    Key? key,
    required this.images,
  }) : super(key: key);
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          'gallery'.tr,
          style: GoogleFonts.tajawal(
            textStyle: TextStyle(
              color: appWhite,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontSize: 18.0,
            ),
          ),
        ),
        centerTitle: true,
        leading: Container(
          height: 48,
          width: 48,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Center(
            child: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(
                CurrentUser.isArabic
                    ? MdiIcons.arrowRightThin
                    : MdiIcons.arrowLeftThin,
                color: appWhite,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: controller,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Container(
                child: PhotoView(
                  imageProvider: CachedNetworkImageProvider(
                    assetsUrl + images[index].imagePath!,
                    // fit: BoxFit.contain,
                    // placeholder: (context, url) =>
                    //     Center(
                    //       child: CircularProgressIndicator(),
                    //     ),
                    // errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                // child: CachedNetworkImage(
                //   imageUrl: assetsUrl + images[index].imagePath!,
                //   fit: BoxFit.contain,
                //   placeholder: (context, url) => Center(
                //     child: CircularProgressIndicator(),
                //   ),
                //   errorWidget: (context, url, error) => Icon(Icons.error),
                // ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 100,
            ),
            child: SmoothPageIndicator(
              controller: controller,
              count: images.length,
              effect: WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: mainColor,
                dotColor: mainColor.withOpacity(0.4),
              ),
            ),
          )
        ],
      ),
    );
  }
}
