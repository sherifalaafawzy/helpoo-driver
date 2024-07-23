import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../../../widgets/willPopScopeWidget.dart';
import 'fnolSteps.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../dataLayer/constants/variables.dart';
import '../../../../dataLayer/models/FNOL.dart';
import '../../../../dataLayer/models/currentUser.dart';
import 'FNOLMapPicker.dart';
import '../../../widgets/round_button.dart';

class aRepairQuestions extends StatefulWidget {
  final FNOL report;
  final String type;

  const aRepairQuestions(this.report, this.type, {Key? key}) : super(key: key);

  @override
  State<aRepairQuestions> createState() => aRepairQuestionsState();
}

class aRepairQuestionsState extends State<aRepairQuestions> {
  @override
  Widget build(BuildContext context) {
    return willPopScopeWidget(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Scaffold(
        backgroundColor: appWhite,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: appWhite),
          backgroundColor: mainColor,
          centerTitle: true,
          title: Text(
            "Repair Inspection".tr,
            style: GoogleFonts.tajawal(
              textStyle: const TextStyle(
                color: appWhite,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 18.0,
              ),
            ),
          ),
          leading: Container(
            height: 48,
            width: 48,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: IconButton(
                onPressed: () {
                  Get.back();
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
        body: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Column(children: [
            Center(
              child: Text(
                "FNOL Follow Up".tr + " # " + widget.report.id.toString(),
                style: GoogleFonts.tajawal(
                  textStyle: const TextStyle(
                    color: appBlack,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 24.0,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Image.asset('assets/imgs/car-top.png',
                  height: 220, width: Get.width),
            ),
            SizedBox(
              width: Get.width * .8,
              child: Text(
                "Is your Car Repaired and Ready for Inspection?".tr,
                style: GoogleFonts.tajawal(
                  textStyle: const TextStyle(
                    color: appBlack,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 24.0,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: Get.width * .4,
                      child: RoundButton(
                          onPressed: () {
                            Get.to(
                              () => fNOLSteps(
                                fnol: widget.report,
                              ),
                            );
                          },
                          padding: false,
                          text: "NO".tr,
                          color: appBlack),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                        width: Get.width * .4,
                        child: RoundButton(
                            onPressed: () async {
                              debugPrint("yes");

                              BlocProvider.of<FnolBloc>(context)
                                  .getLocation('');

                              if (widget.type == "rightSave") {
                                Get.to(
                                    () => fnolMapPicker(fnolType: "rightSave"));
                              } else {
                                Get.to(
                                    () => fnolMapPicker(fnolType: "aRepair"));
                              }
                            },
                            padding: false,
                            text: 'Yes'.tr,
                            color: mainColor)),
                  ],
                )),
          ]),
        ),
      ),
    );
  }
}
