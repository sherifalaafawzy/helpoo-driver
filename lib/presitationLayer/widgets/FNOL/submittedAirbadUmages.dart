import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../dataLayer/constants/variables.dart';
import 'imageView.dart';

class BuildSubmittedAirBagImageView extends StatelessWidget {
  const BuildSubmittedAirBagImageView({
    Key? key,
    required this.img,
  }) : super(key: key);

  final String img;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(imageView(img: img));
        // showImageViewer(context, NetworkImage(img.data.attributes.url));
        showImageViewer(
            context, AssetImage('asstes/imgs/City driver-amico.png'));
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
                  // NetworkImage(
                  //   img.data.attributes.url,
                  // ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
