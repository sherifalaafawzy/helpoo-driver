// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/dataLayer/bloc/app/app_bloc.dart';

import '../../../dataLayer/constants/variables.dart';
import '../../../dataLayer/models/currentUser.dart';

class PackageBenefits extends StatelessWidget {
  PackageBenefits({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appBloc = BlocProvider.of<AppBloc>(context);

    return Scaffold(
      backgroundColor: appWhite,
      appBar: AppBar(
        iconTheme: IconThemeData(color: appWhite),
        backgroundColor: mainColor,
        centerTitle: true,
        // leading: SizedBox(),
        title: Text(
          "Package Details".tr,
          style: GoogleFonts.tajawal(
            textStyle: const TextStyle(
              color: appWhite,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: Get.height,
          width: double.maxFinite,
          child: Stack(
            children: [
              Container(
                height: Get.height,
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...appBloc.packageBenefitsList
                                .map((note) => Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: mainColor,
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Flexible(
                                            child: Text(note.name,
                                                style: GoogleFonts.tajawal(
                                                  textStyle: TextStyle(
                                                    color: appDarkGrey,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 16.0,
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                    )),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
