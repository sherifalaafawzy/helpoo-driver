import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:intl/intl.dart';

import '../../dataLayer/constants/variables.dart';
import '../../dataLayer/models/currentUser.dart';
import '../../dataLayer/models/vehicle.dart';
import '../pages/shared/activateVehicle.dart';
import '../pages/shared/editVehicle.dart';
import 'round_button.dart';

class carCard extends StatefulWidget {
  final Vehicle car;
  final Function clickAction;
  final bool isSelected;

  const carCard(this.car, this.clickAction, this.isSelected, {Key? key})
      : super(key: key);

  @override
  State<carCard> createState() => _carCardState();
}

class _carCardState extends State<carCard> {
  ButtonStyle style = ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              side: BorderSide(color: mainColor))));

  ButtonStyle disabledStyle = ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              side: BorderSide(color: Colors.grey, width: 2))));

  @override
  Widget build(BuildContext context) {
    debugPrint('carCard build ${widget.car.id}');
    debugPrint('policyEnd ${widget.car.policyEnd}');

    if (widget.car.carPackages!.isNotEmpty) {
      debugPrint(
          'carPackages?.first.clientPackage?.id ${widget.car.carPackages?.last.clientPackage?.id ?? '------'}');
      debugPrint(
          'carPackages?.first.clientPackage?.startDate ${widget.car.carPackages?.last.clientPackage?.startDate ?? '------'}');
      debugPrint(
          'carPackages?.first.clientPackage?.endDate ${widget.car.carPackages?.last.clientPackage?.endDate ?? '------'}');
    }

    debugPrint('-------------------');

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 15),
          child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Container(
                    height: Get.height * .3,
                    margin: EdgeInsetsDirectional.only(
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: widget.isSelected
                            ? mainColor
                            : const Color(0xffd6d6d6),
                        width: widget.isSelected ? 3 : 2,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                      color: appWhite,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 20, left: 20, top: 30, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Full Name".tr,
                                style: Get.theme.textTheme.bodyLarge,
                              ),
                              SizedBox(
                                width: Get.width * .15,
                              ),
                              Expanded(
                                child: Text(
                                  CurrentUser.name!,
                                  style:
                                      Get.theme.textTheme.bodyLarge!.copyWith(
                                    color: appDarkGrey,
                                  ),
                                  maxLines: null,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: Get.width * .42,
                                  child: Row(
                                    children: [
                                      Text(
                                        "vehicle type".tr + ': ',
                                        style: Get.theme.textTheme.bodyLarge,
                                      ),
                                      Spacer(),
                                      Text(
                                        widget.car.manufacture!=null?widget.car.manufacture!.name:"",
                                        style: Get.theme.textTheme.bodyLarge!
                                            .copyWith(
                                          color: appDarkGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                SizedBox(
                                  width: Get.width * .3,
                                  child: Row(
                                    children: [
                                      Text(
                                        "model".tr,
                                        style: Get.theme.textTheme.bodyLarge,
                                      ),
                                      const Spacer(),
                                      Text(
                                        widget.car.model != null
                                            ? widget.car.model!.name
                                            : "",
                                        style: Get.theme.textTheme.bodyLarge!
                                            .copyWith(
                                          color: appDarkGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: Get.width * .3,
                                  child: Row(
                                    children: [
                                      Text(
                                        "year of manufacture".tr,
                                        style: Get.theme.textTheme.bodyLarge,
                                      ),
                                      const Spacer(),
                                      Text(
                                        widget.car.year.toString(),
                                        style: Get.theme.textTheme.bodyLarge!
                                            .copyWith(
                                          color: appDarkGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                SizedBox(
                                  width: Get.width * .3,
                                  child: Row(
                                    children: [
                                      Text(
                                        "color".tr,
                                        style: Get.theme.textTheme.bodyLarge,
                                      ),
                                      const Spacer(),
                                      Text(
                                        widget.car.color != null
                                            ? widget.car.color!.tr
                                            : "".tr,
                                        style: Get.theme.textTheme.bodyLarge!
                                            .copyWith(
                                          color: appDarkGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                          if (widget.car.insuranceCompany != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                widget.car.insuranceCompany != null
                                    ? Row(
                                        children: [
                                          SizedBox(
                                            width: Get.width * 0.8,
                                            child: Row(
                                              children: [
                                                Text(
                                                  "insurance company".tr,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: Get.theme.textTheme
                                                      .bodyLarge,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                    CurrentUser.isEnglish
                                                        ? widget
                                                                .car
                                                                .insuranceCompany
                                                                ?.enName ??
                                                            ''
                                                        : widget
                                                                .car
                                                                .insuranceCompany
                                                                ?.arName ??
                                                            '',
                                                    style: Get.theme.textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                      color: appDarkGrey,
                                                    )),
                                              ],
                                            ),
                                          ),
                                          // SizedBox(
                                          //   width: 20,
                                          // ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                widget.car.plateNo != null ||
                                        widget.car.plateNo != ""
                                    ? SizedBox(
                                        width:
                                            widget.car.insuranceCompany != null
                                                ? Get.width * .7
                                                : Get.width * .5,
                                        child: Row(
                                          children: [
                                            Text(
                                              "Plate No.".tr,
                                              style:
                                                  Get.theme.textTheme.bodyLarge,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                                widget.car.plateNo != null
                                                    ? '${sRBloc.convertEnglishNumbersToArabic(input: widget.car.plateNo!.split(' ').first)}'
                                                    : "",
                                                textDirection:
                                                    ui.TextDirection.ltr,
                                                style: Get
                                                    .theme.textTheme.bodyLarge!
                                                    .copyWith(
                                                  color: appDarkGrey,
                                                )),
                                          ],
                                        ),
                                      )
                                    : Container()
                              ]),
                          widget.car.insuranceCompany != null
                              ? widget.car.package?.insuranceCompanyId != null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          CurrentUser.isArabic
                                              ? widget
                                                  .car.package!.arDescription
                                              : widget
                                                  .car.package!.enDescription,
                                          style: GoogleFonts.tajawal(
                                            textStyle: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          ' ${DateFormat("dd/MM/yyyy").format(DateTime.parse(widget.car.clientPackage!.endDate!))}',
                                          style: GoogleFonts.tajawal(
                                            textStyle: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )
                                  : widget.car.carPackages != null &&
                                          widget.car.carPackages!.length != 0 &&
                                          widget.car.carPackages!.any(
                                              (element) => DateTime.parse(
                                                      element.clientPackage!
                                                          .endDate!)
                                                  .isAfter(DateTime.now()))
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Insured Text'.tr,
                                              style: GoogleFonts.tajawal(
                                                textStyle: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 13.0,
                                                ),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              ' ${DateFormat("dd/MM/yyyy").format(DateTime.parse(widget.car.carPackages!.first.clientPackage!.endDate!))}',
                                              style: GoogleFonts.tajawal(
                                                textStyle: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        )
                                      : Container()
                              : widget.car.carPackages!.isNotEmpty
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Insured Text'.tr,
                                          style: GoogleFonts.tajawal(
                                            textStyle: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 13.0,
                                            ),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          ' ${DateFormat("dd/MM/yyyy").format(DateTime.parse(widget.car.carPackages!.first.clientPackage!.endDate!))}',
                                          style: GoogleFonts.tajawal(
                                            textStyle: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )
                                  : Container(),
                          widget.car.active == false
                              ? RoundButton(
                                  onPressed: () {
                                    Get.to(() => activateVehicle(
                                          vehicle: widget.car,
                                        ));
                                  },
                                  padding: true,
                                  text: 'Confirm'.tr,
                                  color: mainColor)
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    widget.car.package == null
                                        ? ElevatedButton(
                                            child: Text("Add to Package".tr,
                                                style: TextStyle(fontSize: 12)),
                                            style: widget.car.carPackages!
                                                        .length ==
                                                    0
                                                ? style
                                                : disabledStyle,
                                            onPressed: () async {
                                              if (widget.car.carPackages!
                                                      .length ==
                                                  0) {
                                                Get.to(() => editVehicle(
                                                      vehicle: widget.car,
                                                      packageCar: true,
                                                    ));
                                              }
                                              // } else {
                                              //   Get.bottomSheet(
                                              //     Container(
                                              //         height: Get.height * .4,
                                              //         color: white,
                                              //         child: Padding(
                                              //           padding:
                                              //               const EdgeInsets.all(
                                              //                   8.0),
                                              //           child: Column(
                                              //             children: [
                                              //               Text(
                                              //                 'No Active Package'
                                              //                     .tr,
                                              //                 style: GoogleFonts
                                              //                     .tajawal(
                                              //                   textStyle:
                                              //                       TextStyle(
                                              //                     color: appBlack,
                                              //                     fontWeight:
                                              //                         FontWeight
                                              //                             .w800,
                                              //                     fontStyle:
                                              //                         FontStyle
                                              //                             .normal,
                                              //                     fontSize: 20.0,
                                              //                   ),
                                              //                 ),
                                              //               ),
                                              //               SizedBox(
                                              //                 width: Get.width * .8,
                                              //                 child: Text(
                                              //                   'You Can Explore our Packages and Select the best for you'
                                              //                       .tr,
                                              //                   style: GoogleFonts
                                              //                       .tajawal(
                                              //                     textStyle:
                                              //                         TextStyle(
                                              //                       color: Color
                                              //                           .fromARGB(
                                              //                               255,
                                              //                               131,
                                              //                               130,
                                              //                               130),
                                              //                       fontWeight:
                                              //                           FontWeight
                                              //                               .w500,
                                              //                       fontStyle:
                                              //                           FontStyle
                                              //                               .normal,
                                              //                       fontSize: 18.0,
                                              //                     ),
                                              //                   ),
                                              //                   textAlign: TextAlign
                                              //                       .center,
                                              //                 ),
                                              //               ),
                                              //               SizedBox(
                                              //                 width:
                                              //                     Get.width * .35,
                                              //                 child: Image.asset(
                                              //                     'assets/imgs/package.png'),
                                              //               ),
                                              //               RoundButton(
                                              //                 onPressed: () {
                                              //                   Get.to(() =>
                                              //                       choosePackage(
                                              //                           register:
                                              //                               false));
                                              //                 },
                                              //                 padding: false,
                                              //                 text:
                                              //                     'Avaliable Package'
                                              //                         .tr,
                                              //                 color: mainColor,
                                              //               ),
                                              //             ],
                                              //           ),
                                              //         )),
                                              //     isDismissible: true,
                                              //     enableDrag: true,
                                              //   );
                                              // }
                                            })
                                        : Container(),
                                    ElevatedButton(
                                        child: Text("Edit".tr,
                                            style: TextStyle(fontSize: 12)),
                                        style: style,
                                        onPressed: () => widget
                                                        .car.insuranceCompany !=
                                                    null ||
                                                widget.car.package != null
                                            ? HelpooInAppNotification
                                                .showMessage(
                                                    message:
                                                        "You Can't Edit This Car"
                                                            .tr)
                                            // Get.snackbar("Helpoo",
                                            //     "You Can't Edit This Car")
                                            : widget.clickAction()),
                                    ElevatedButton(
                                        child: Text("Add Users".tr,
                                            style: TextStyle(fontSize: 12)),
                                        style: style,
                                        onPressed: () {
                                          HelpooInAppNotification
                                              .showErrorMessage(
                                                  message:
                                                      "Not Avaliable Yet".tr);
                                          // Get.snackbar("Helpoo".tr,
                                          // "Not Avaliable Yet".tr);
                                        }),
                                  ],
                                ),
                          widget.car.insuranceCompany != null
                              ? widget.car.carPackages != null &&
                                      widget.car.carPackages!.length != 0 &&
                                      widget.car.carPackages!.any((element) =>
                                          DateTime.parse(element
                                                  .clientPackage!.endDate!)
                                              .isAfter(DateTime.now()))
                                  ? Text(
                                      'Only Insurance Company Can Edit'.tr,
                                      style: GoogleFonts.tajawal(
                                        textStyle: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  : Container()
                              : Container()
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.isSelected,
                    child: CircleAvatar(
                      backgroundColor: mainColor,
                      radius: 13,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        widget.car.carPackages != null &&
                widget.car.carPackages!.length != 0 &&
                widget.car.carPackages!.any((element) =>
                    DateTime.parse(element.clientPackage!.endDate!)
                        .isAfter(DateTime.now()))
            ? Positioned(
                // top: -1,
                right: Get.width * .05,
                child: Container(
                    height: Get.height * .05,
                    width: Get.width / 1.2,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                      color: mainColor,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.car.carPackages!.first.package != null
                                ? CurrentUser.isArabic
                                    ? widget
                                        .car.carPackages!.first.package!.arName
                                    : widget
                                        .car.carPackages!.first.package!.enName
                                : "",
                            style: GoogleFonts.tajawal(
                              textStyle: TextStyle(
                                color: appWhite,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          // ...List<Widget>.from(
                          //   widget.car.carPackages!.map(
                          //     (p) => Text(
                          //       widget.car.carPackages.first.package != null
                          //           ? CurrentUser.isArabic
                          //               ? widget.car.carPackages.first.package!.arName
                          //               : widget.car.carPackages.first.package!.enName
                          //           : "",
                          //       style: GoogleFonts.tajawal(
                          //         textStyle: TextStyle(
                          //           color: appWhite,
                          //           fontWeight: FontWeight.w500,
                          //           fontStyle: FontStyle.normal,
                          //           fontSize: 14.0,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    )
                    //  Center(
                    //   // child: Text(
                    //   //     widget.car.carPackages![0].package != null
                    //   //         ? CurrentUser.isArabic
                    //   //             ? widget.car.carPackages![0].package!.arName
                    //   //             : widget.car.carPackages![0].package!.enName
                    //   //         : "",
                    //   //     style: GoogleFonts.tajawal(
                    //   //       textStyle: TextStyle(
                    //   //         color: appWhite,
                    //   //         fontWeight: FontWeight.w500,
                    //   //         fontStyle: FontStyle.normal,
                    //   //         fontSize: 14.0,
                    //   //       ),
                    //   //     )
                    //   //     ),

                    // ),

                    ))
            : Container()
      ],
    );
  }
}
