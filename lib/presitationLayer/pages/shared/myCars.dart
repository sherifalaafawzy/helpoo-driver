import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../dataLayer/models/currentUser.dart';
import '../../../dataLayer/models/vehicle.dart';
import '../../../dataLayer/constants/variables.dart';
import '../../widgets/addFirstCar.dart';
import '../../widgets/carCard.dart';
import 'editVehicle.dart';

class MyCars extends StatefulWidget {
  const MyCars({
    Key? key,
  }) : super(key: key);
  @override
  State<MyCars> createState() => _MyCarsState();
}

class _MyCarsState extends State<MyCars> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Vehicle.addVehicle || CurrentUser.cars.isEmpty
        ? addFirstCar(
            vehicleRegister: false,
            packageCar: false,
            car: null,
          )
        : ListView(
            children: [
              SizedBox(
                height: 24,
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        Vehicle.addVehicle = true;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.plusCircleOutline,
                          color: mainColor,
                        ),
                        Text(
                          CurrentUser.isCorporate ? 'add vehicle corporate'.tr : 'Add Vehicle'.tr,
                          style: GoogleFonts.tajawal(
                            textStyle: const TextStyle(
                              color: mainColor,
                              fontWeight: FontWeight.w800,
                              fontStyle: FontStyle.normal,
                              fontSize: 20.0,
                            ),
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 107,
                    height: 2,
                    decoration: const BoxDecoration(
                      color: mainColor,
                    ),
                  ),
                  CurrentUser.cars.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              ...CurrentUser.cars.where((element) => element.id != null && element.id! >= 0).map<Widget>(
                                    (Vehicle c) => InkWell(
                                      onTap: () {},
                                      child: carCard(
                                        c,
                                        () async {
                                          await Get.to(() => editVehicle(vehicle: c, packageCar: false));
                                          setState(() {});
                                        },
                                        false,
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        )
                      : Container()
                ],
              ),
            ],
          );
  }
}
