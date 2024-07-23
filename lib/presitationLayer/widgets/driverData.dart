import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../dataLayer/constants/variables.dart';
import '../../dataLayer/models/serviceReqest.dart';
import 'driverRating.dart';

class driverData extends StatelessWidget {
  final ServiceRequest request;

  const driverData({Key? key, required this.request}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5.5),
        Container(
          width: Get.width * .47,
          height: 80,
          child: Row(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: request.driver.photo == null
                        ? Icon(
                            MdiIcons.accountCircle,
                            color: mainColor,
                            size: 32,
                          )
                        : Container(
                            width: 48,
                            height: 48,
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(0)),
                                  border:
                                      Border.all(color: mainColor, width: 2),
                                  color: appWhite,
                                ),
                                child: Image.network(request.driver.photo!)),
                          ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        request.driver.name!,
                        style: GoogleFonts.tajawal(
                          textStyle: const TextStyle(
                            color: appBlack,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0,
                          ),
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: driverRating(request.driver),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  if (!await launchUrl(Uri.parse(
                      'tel:${request.driver.phoneNumber.toString()}'))) {
                    throw 'Could not launch url'.tr;
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    MdiIcons.phone,
                    color: mainColor,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
