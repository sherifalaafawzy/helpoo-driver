import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../dataLayer/constants/variables.dart';
import '../homeScreen.dart';
import '../../widgets/round_button.dart';
import '../user_home_content/service_request/selectVehicle.dart';

class packageActivation extends StatelessWidget {
  const packageActivation({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: appWhite,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: appWhite),
          backgroundColor: mainColor,
          centerTitle: true,
          title: Text(
            "package is activated successfully".tr,
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/imgs/car-activation.png',
                height: 250,
                width: 250,
              ),
              Text(
                'start to register cars'.tr,
                style: GoogleFonts.tajawal(
                  textStyle: const TextStyle(
                    color: mainColor,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    fontSize: 18.0,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: Get.width * .9,
                  height: Get.height * .14,
                  decoration: BoxDecoration(
                      color: appGrey,
                      border: Border.all(
                        color: appDarkGrey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Do you want to add Car(s) to your Package now?".tr,
                          style: GoogleFonts.tajawal(
                            textStyle: TextStyle(
                              color: mainColor,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                              fontSize: 18.0,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Package Will be Active in Your Car After 72 Hours".tr,
                          style: GoogleFonts.tajawal(
                            textStyle: TextStyle(
                              color: appRed,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 50,
                width: Get.width * 0.7,
                child: RoundButton(
                    onPressed: () {
                      Get.to(
                          () => selectVehicle(FNOL: false, packageCar: true));
                    },
                    padding: false,
                    text: 'yes now'.tr,
                    color: mainColor),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 50,
                width: Get.width * 0.7,
                child: RoundButton(
                    onPressed: () {
                      Get.to(() => homeScreen(index: 0));
                    },
                    padding: false,
                    text: 'Later'.tr,
                    color: mainColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
