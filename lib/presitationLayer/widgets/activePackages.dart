// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../dataLayer/constants/variables.dart';
import '../../dataLayer/models/currentUser.dart';
import '../../dataLayer/models/package.dart';
import 'choosePackageCard.dart';

class activePackages extends StatelessWidget {
  bool register;

  activePackages({
    Key? key,
    required this.register,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CurrentUser.packages.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'You Already Subscribed To The Following Packages'.tr,
                  style: GoogleFonts.tajawal(
                    textStyle: const TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 18.0,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : Container(),
        ...CurrentUser.packages.map<Widget>(
          (Package c) => GestureDetector(
            onTap: () {
              print(c.packageId);
            },
            child: choosePackageCard(
              package: c,
              value: c.id.toString(),
              active: c.active!,
              packageBenefits: c.packageBenefits,
              onChanged: (v) {},
              register: register,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Do you Want to Add New Package?'.tr,
          style: GoogleFonts.tajawal(
            textStyle: const TextStyle(
              color: mainColor,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              fontSize: 20.0,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
