import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../../../../dataLayer/constants/variables.dart';
import '../../../../dataLayer/models/FNOL.dart';
import '../../../../dataLayer/models/FNOLMedia.dart';
import '../../../../dataLayer/models/currentUser.dart';
import '../../../widgets/round_button.dart';
import '../../../widgets/willPopScopeWidget.dart';
import 'FNOLComment.dart';
import 'extraShooting.dart';

class airBageImageInput extends StatefulWidget {
  final FNOL accidentReport;
  final int idx;
  const airBageImageInput({
    Key? key,
    required this.idx,
    required this.accidentReport,
  }) : super(key: key);

  @override
  airBageImageInputState createState() => airBageImageInputState();
}

class airBageImageInputState extends State<airBageImageInput> {
  List<String> imagePathList = [];
  bool cameraMode = false;

  int idx = 0;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<FnolBloc>(context);
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
          title: Text(
            // centerTitle: true,
            "Extra Photos".tr,
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              // width: 225,
              height: 250, // height: Get.height * .3,
              child: Image.asset(
                "assets/imgs/car-top.png",
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Extra Photos description'.tr,
                  style: GoogleFonts.tajawal(
                    textStyle: const TextStyle(
                      color: appBlack,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
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
                "air bags exploded".tr,
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
                "glass defects".tr,
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
                "other damaged parts".tr,
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
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RoundButton(
                        onPressed: () {
                          // var controller = bloc.fnol;
                          Get.to(() => extraShooting(
                                this.widget.accidentReport,
                                "air_bag_images",
                              ));
                        },
                        padding: false,
                        text: "Take Photos".tr,
                        color: mainColor),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RoundButton(
                        onPressed: () {
                          setState(() {
                            bloc.fnol.mediaController = MediaController();
                            bloc.fnol.mediaController.audio64 == null;
                          });
                          Get.to(() => fnolComment(this.widget.accidentReport));
                        },
                        padding: false,
                        text: "skip".tr,
                        color: appBlack),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
