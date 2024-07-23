import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/constants.dart';

import '../../../../dataLayer/constants/variables.dart';
import '../../../../dataLayer/models/FNOL.dart';
import '../../pdfView.dart';

class showPdf extends StatelessWidget {
  final FNOL fnol;

  const showPdf({super.key, required this.fnol});

  @override
  Widget build(BuildContext context) {
    return fnol.pdf.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                "Accident Reports".tr,
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
              SizedBox(height: 8),
              ...fnol.pdf.map((e) => GestureDetector(
                    onTap: () => Get.to(
                        () => PdfView(pdf: assetsUrl + e, isFile: false)),
                    // child: Text(
                    //   "Tap To Open Report".tr,
                    //   style: GoogleFonts.tajawal(
                    //     textStyle: const TextStyle(
                    //       color: appBlack,
                    //       fontWeight: FontWeight.w400,
                    //       fontStyle: FontStyle.normal,
                    //       fontSize: 12.0,
                    //     ),
                    //   ),
                    //   maxLines: 3,
                    // ),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.picture_as_pdf,
                            size: 50,
                            color: mainColorHex,
                          ),
                          space5Vertical(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  "Tap To Open Report".tr,
                                  style: GoogleFonts.tajawal(
                                    textStyle:  TextStyle(
                                      color: mainColorHex,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  maxLines: 3,
                                ),
                              Text(
                                'تقرير التلفيات بالذكاء الاصطناعي',
                                style: TextStyle(
                                  color: mainColorHex,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          )
        : Container();
  }
}
