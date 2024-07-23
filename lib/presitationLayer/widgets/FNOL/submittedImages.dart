import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'imageView.dart';

class submittedImages extends StatelessWidget {
  const submittedImages({
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
        showImageViewer(context, AssetImage('assets/imgs/intro1.png'));
      },
      child: Container(
        height: 60,
        width: 60,
        // margin: const EdgeInsets.all(8.0),
        child: GridTile(
          child: Material(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset("assets/imgs/intro1.png"),
                  // Image.network(
                  //   img.data.attributes.url,
                  //   fit: BoxFit.cover,
                  // ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
