import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../dataLayer/Constants/variables.dart';
import '../../../../dataLayer/models/FNOL.dart';
import 'audioFilePlayer.dart';

class audioFileCard extends StatefulWidget {
  final FNOL fnol;

  const audioFileCard({super.key, required this.fnol});

  @override
  State<audioFileCard> createState() => _audioFileCardState();
}

class _audioFileCardState extends State<audioFileCard> {
  @override
  Widget build(BuildContext context) {
    return widget.fnol.mediaController.audioFilePath != null
        ? Container(
            width: Get.width * .5,
            height: Get.height * .1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      width: Get.width,
                      height: 70,
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        border: Border.all(
                          color: mainColor,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          audioFilePlayer(
                              widget.fnol.mediaController.audioFilePath!),
                        ],
                      ),
                    ),
                  ),
                  // Container(
                  //   width: 60,
                  //   height: 60,
                  //   decoration: BoxDecoration(
                  //     color: mainColor,
                  //     borderRadius: BorderRadius.all(
                  //       Radius.circular(8.0),
                  //     ),
                  //   ),
                  //   child: Center(
                  //     child: IconButton(
                  //       icon: Icon(
                  //         Icons.delete,
                  //         color: appWhite,
                  //       ),
                  //       tooltip: 'remove audio',
                  //       onPressed: () {
                  //         setState(() {
                  //           widget.fnol.mediaController.audioFilePath = null;
                  //         });
                  //       },
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          )
        : Container();
  }
}
