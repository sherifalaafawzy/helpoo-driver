import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';
import '../../../../../dataLayer/models/serviceReqest.dart';
import '../../../../pages/homeScreen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../../dataLayer/constants/variables.dart';
import '../../../../../dataLayer/models/currentUser.dart';
import '../../../round_button.dart';
import 'package:url_launcher/url_launcher.dart';

class callCenterupport extends StatelessWidget {
  const callCenterupport({Key? key}) : super(key: key);

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(Uri.parse(launchUri.toString()));
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<ServiceRequestBloc>(context);
    return Scaffold(
      backgroundColor: appWhite,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: appWhite),
        backgroundColor: mainColor,
        centerTitle: true,
        title: Text(
          "customer support".tr,
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
                bloc.request = ServiceRequest();
                Get.to(() => homeScreen(index: 0));
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
        padding: const EdgeInsets.all(32.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                MdiIcons.faceAgent,
                color: mainColor,
                size: 256,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "please contact our customer support".tr,
                textAlign: TextAlign.center,
                style: GoogleFonts.tajawal(
                  textStyle: const TextStyle(
                    color: appBlack,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "17000".tr,
                textAlign: TextAlign.center,
                style: GoogleFonts.tajawal(
                  textStyle: const TextStyle(
                    color: mainColor,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.normal,
                    fontSize: 64.0,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: RoundButton(
                        onPressed: () async {
                          if (!await launchUrl(Uri.parse('tel:17000'))) {
                            throw 'Could not launch url'.tr;
                          }
                        },
                        padding: false,
                        text: 'call'.tr,
                        color: mainColor),
                  ),
                ],
              )
            ]),
      ),
    );
  }
}
