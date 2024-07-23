import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../dataLayer/constants/variables.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    Key? key,
    required this.onTap,
    required this.text,
    required this.image,
  }) : super(key: key);
  final Function onTap;
  final String text;
  final Image image;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * .29,
      child: InkWell(
        onTap: () {
          onTap();
        },
        splashColor: mainColor,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            // height: Get.height * .15,
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: appGrey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          text,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    image,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
