// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../dataLayer/constants/variables.dart';
import '../../../dataLayer/models/currentUser.dart';
import '../../dataLayer/models/vehicle.dart';

class choosePublicPackage extends StatefulWidget {
  choosePublicPackage({
    super.key,
    required this.vehicle,
    required this.packageCar,
  });
  final Vehicle vehicle;
  bool packageCar;

  @override
  State<choosePublicPackage> createState() => _choosePublicPackageState();
}

class _choosePublicPackageState extends State<choosePublicPackage> {
  @override
  Widget build(BuildContext context) {
    if (widget.vehicle.package == null && widget.packageCar) {
      return Column(
        children: [
          // ListTile(
          //   leading: Checkbox(
          //     onChanged: (value) {
          //       setState(() {
          //         widget.packageCar = value!;
          //       });
          //     },
          //     value: widget.packageCar,
          //   ),
          //   title: Text(
          //     'Add this Car to The Active Package'.tr,
          //     style: GoogleFonts.tajawal(
          //       textStyle: const TextStyle(
          //         color: mainColor,
          //         fontWeight: FontWeight.w400,
          //         fontStyle: FontStyle.normal,
          //         fontSize: 16.0,
          //       ),
          //     ),
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: ListView.separated(
              separatorBuilder: (BuildContext context, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(height: 5),
              ),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: CurrentUser.packages.length,
              itemBuilder: (context, index) {
                // if (CurrentUser.packages[index].insuranceCompanyId == null)
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    border: Border.all(
                      color: mainColor,
                      width: 1,
                    ),
                  ),
                  child: RadioListTile(
                    visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity),
                    secondary: Wrap(
                      spacing: 5,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        Text(
                          CurrentUser.packages[index].numberOfCars.toString() +
                              "/" +
                              CurrentUser.packages[index].assignedCars
                                  .toString(),
                          style: GoogleFonts.tajawal(
                            textStyle: const TextStyle(
                              color: mainColor,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              fontSize: 13.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                          child: Image.asset('assets/imgs/car-activation.png'),
                        ),
                      ],
                    ),
                    controlAffinity: ListTileControlAffinity.platform,
                    title: Text(
                      CurrentUser.isArabic
                          ? CurrentUser.packages[index].arName
                          : CurrentUser.packages[index].enName,
                      style: GoogleFonts.tajawal(
                        textStyle: const TextStyle(
                          color: mainColor,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    value: CurrentUser.packages[index].packageId.toString(),
                    groupValue: CurrentUser.selectedPackage.id,
                    onChanged: (v) {
                      setState(() {
                        CurrentUser.selectedPackage.id = v.toString();
                      });
                    },
                  ),
                );

                // else
                //   return Container();
              },
            ),
          )
        ],
      );
    } else {
      return SizedBox(height: 18);
    }
  }
}
