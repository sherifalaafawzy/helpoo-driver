import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/main.dart';
import '../../../../dataLayer/constants/variables.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../dataLayer/models/FNOL.dart';
import '../../../../dataLayer/models/currentUser.dart';
import '../../../pages/user_home_content/FNOL/FNOLMapPicker.dart';
import '../../../pages/user_home_content/FNOL/extraShooting.dart';
import '../../round_button.dart';
import '../../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../../willPopScopeWidget.dart';

class repairReport extends StatefulWidget {
  final FNOL report;
  final String type;
  const repairReport(this.report, {Key? key, required this.type})
      : super(key: key);

  @override
  State<repairReport> createState() => _repairReportState();
}

class _repairReportState extends State<repairReport> {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<FnolBloc>(context);
    return BlocListener<FnolBloc, FnolState>(
      listener: (context, state) {
        if (state is locationAdded) {
          setState(() {});
        }
      },
      child: willPopScopeWidget(
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
              widget.type == "resurvey"
                  ? "Resurvey report page".tr
                  : widget.type == "supplement"
                      ? "Supplement report page".tr
                      : "before repair report page".tr,
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
          body: ListView(children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Image.asset('assets/imgs/report.png',
                  height: 190, width: Get.width),
            ),
            Text(
              "before repair report shooting comment".tr,
              style: GoogleFonts.tajawal(
                textStyle: const TextStyle(
                  color: appBlack,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 18.0,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 16,
            ),
            ListTile(
              leading: Icon(
                MdiIcons.checkboxBlank,
                color: mainColor,
              ),
              title: Text(
                "please shoot clearly".tr,
                style: GoogleFonts.tajawal(
                  textStyle: const TextStyle(
                    color: appBlack,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0,
                  ),
                ),
                textAlign: TextAlign.start,
              ),
            ),
            ListTile(
              leading: Icon(
                MdiIcons.checkboxBlank,
                color: mainColor,
              ),
              title: Text(
                "shoot page by page".tr,
                style: GoogleFonts.tajawal(
                  textStyle: const TextStyle(
                    color: appBlack,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0,
                  ),
                ),
                textAlign: TextAlign.start,
              ),
            ),
            ListTile(
              leading: Icon(
                MdiIcons.checkboxBlank,
                color: mainColor,
              ),
              title: Text(
                "shoot in good light".tr,
                style: GoogleFonts.tajawal(
                  textStyle: const TextStyle(
                    color: appBlack,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0,
                  ),
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: RoundButton(
                          onPressed: () {
                            if (widget.type == "supplement") {
                              Get.to(() => extraShooting(
                                    widget.report,
                                    "supplement",
                                  ));
                            } else if (widget.type == "resurvey") {
                              Get.to(() => extraShooting(
                                    widget.report,
                                    "resurvey",
                                  ));
                            } else {
                              Get.to(() => extraShooting(
                                    widget.report,
                                    "repair_before",
                                  ));
                            }
                          },
                          padding: false,
                          text: 'Take Photos'.tr,
                          color: mainColor,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: RoundButton(
                          onPressed: () async {
                            if (widget.type == "supplement") {
                              bloc.fnol.pickupMultiImagesForReports(
                                  bloc, "supplement", widget.type);
                            } else if (widget.type == "resurvey") {
                              bloc.fnol.pickupMultiImagesForReports(
                                  bloc, "resurvey", widget.type);
                            } else {
                              bloc.fnol.pickupMultiImagesForReports(
                                  bloc, "repair_before", widget.type);
                            }
                          },
                          padding: false,
                          text: 'gallery'.tr,
                          color: mainColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: RoundButton(
                          onPressed: () async {
                            BlocProvider.of<FnolBloc>(
                                    navigatorKey.currentContext!)
                                .getLocation('');
                            // Get.to(
                            //   () => fnolMapPicker(
                            //     fnolType: widget.type,
                            //   ),
                            // );

                            if (widget.type == "supplement") {
                              Get.to(
                                  () => fnolMapPicker(fnolType: "supplement"));
                            } else if (widget.type == "resurvey") {
                              Get.to(() => fnolMapPicker(fnolType: "resurvey"));
                            } else {
                              Get.to(() =>
                                  fnolMapPicker(fnolType: "repair_before"));
                            }
                          },
                          padding: false,
                          text: 'skip'.tr,
                          color: appBlack,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
