import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../dataLayer/models/currentUser.dart';
import '../../../dataLayer/constants/variables.dart';
import '../../../dataLayer/models/vehicle.dart';
import '../../widgets/addFirstCar.dart';
import '../../widgets/carCard.dart';
import '../../widgets/round_button.dart';
import '../shared/editVehicle.dart';
import '../homeScreen.dart';

class registerVehicle extends StatefulWidget {
  final bool withBack;

  const registerVehicle({
    Key? key,
    this.withBack = false,
  }) : super(key: key);

  @override
  State<registerVehicle> createState() => _registerVehicleState();
}

class _registerVehicleState extends State<registerVehicle> {
  @override
  void initState() {
    Vehicle.clearVehicle();
    setState(() {
      Vehicle.anotherVehicle = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Vehicle.anotherVehicle) {
          setState(() {
            Vehicle.anotherVehicle = false;
          });
          return false;
        } else {
          debugPrint('Back Pressed');

          Get.back();
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: appWhite,
        appBar: AppBar(
          iconTheme: IconThemeData(color: appWhite),
          backgroundColor: mainColor,
          centerTitle: true,
          leading: (CurrentUser.cars.isEmpty || Vehicle.anotherVehicle)
              ? Container(
                  height: 48,
                  width: 48,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        if (Vehicle.anotherVehicle) {
                          setState(() {
                            Vehicle.anotherVehicle = false;
                          });
                        } else {
                          debugPrint('Back Pressed');
                          Get.back();
                        }
                      },
                      icon: Icon(
                        CurrentUser.isArabic
                            ? MdiIcons.arrowRightThin
                            : MdiIcons.arrowLeftThin,
                        color: appWhite,
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          title: Text(
            "my vehicles".tr,
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
        body: CurrentUser.cars.isEmpty || Vehicle.anotherVehicle
            ? Padding(
                padding: const EdgeInsets.only(top: 20),
                child: addFirstCar(
                  vehicleRegister: true,
                  packageCar: false,
                  car: null,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          "please confirm info".tr,
                          style: GoogleFonts.tajawal(
                            textStyle: const TextStyle(
                              color: mainColor,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0,
                            ),
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          children: List<Widget>.from(
                            CurrentUser.cars.map(
                              (c) => carCard(
                                c,
                                () {
                                  Get.to(() => editVehicle(
                                        vehicle: c,
                                        packageCar: false,
                                      ));
                                },
                                false,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Get.width,
                        child: RoundButton(
                          onPressed: () {
                            setState(() {
                              Vehicle.anotherVehicle = true;
                            });
                          },
                          padding: true,
                          text: 'Add More Vehicle(s)'.tr,
                          color: mainColor,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: Get.width,
                        child: RoundButton(
                          onPressed: () async {
                            Get.offAll(() => homeScreen(
                                  index: 0,
                                ));
                          },
                          padding: true,
                          text: 'confirm'.tr,
                          color: mainColor,
                        ),
                      )
                    ]),
              ),
      ),
    );
  }
}
