// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/presitationLayer/pages/homeScreen.dart';
import '../../dataLayer/bloc/app/app_bloc.dart';
import '../../dataLayer/models/currentUser.dart';
import '../../dataLayer/constants/variables.dart';
import '../../dataLayer/models/packageBenefitsModel.dart';
import '../pages/shared/packagePenefits.dart';
import 'round_button.dart';

class staticPackageCard extends StatefulWidget {
  staticPackageCard({
    super.key,
    required this.title,
    required this.fees,
    required this.isDiscount,
    required this.originalFees,
    required this.description,
    required this.packageBenefits,
    required this.onChanged,
    required this.active,
    required this.register,
    this.packageId,
    this.isOneLine = false,
    this.alreadyHavePackage = false,
    required this.value,
  });

  String title;
  String fees;
  String originalFees;
  String description;
  String? packageId;
  List<PackageBenefitsModel> packageBenefits;
  bool active;
  bool isDiscount;
  bool register;
  bool isOneLine;
  final onChanged;
  var value;
  bool alreadyHavePackage;

  @override
  State<staticPackageCard> createState() => _staticPackageCardState();
}

class _staticPackageCardState extends State<staticPackageCard> {
  @override
  Widget build(BuildContext context) {
    var appBloc = BlocProvider.of<AppBloc>(context);

    return BlocBuilder<AppBloc, AppBlocState>(
      builder: (context, state) {
        return Container(
          height: widget.value == "noPackage" ? null : (widget.isDiscount ? Get.height * .13 : Get.height * .10),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: mainColor,
              width: 2,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            color: widget.active ? appGrey : appWhite,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                widget.packageId == "20"
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            // widget.register
                            //     ? Radio(
                            //         value: widget.value,
                            //         groupValue: CurrentUser.selectedPackage.id,
                            //         onChanged: widget.onChanged,
                            //       )
                            //     : Container(),
                            Container(
                              width: Get.width * .1,
                              height: Get.height * .1,
                              child: Image.asset("assets/imgs/deltaLogo.png"),
                            ),
                          ],
                        ),
                      )
                    : widget.active
                        ? SizedBox(
                            width: 40,
                          )
                        : Radio(
                            value: widget.value,
                            groupValue: CurrentUser.selectedPackage.id,
                            onChanged: widget.onChanged,
                          ),
                Expanded(
                  child: Row(
                    children: [
                      appBloc.isPromoPackageActive &&
                              (
                                  // CurrentUser.selectedPackage.id == widget.value &&
                                  widget.value != "noPackage" &&
                                      widget.value != "alreadyHaveOne") &&
                              appBloc.PromoPackageImage != ""
                          ? Container(
                              width: Get.width * .1,
                              height: Get.height * .1,
                              child: Image.network(
                                  assetsUrl + appBloc.PromoPackageImage),
                            )
                          : Container(),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: GoogleFonts.tajawal(
                                textStyle: const TextStyle(
                                  color: mainColor,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 18.0,
                                ),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Visibility(
                              visible: widget.isDiscount,
                              child: Text(
                                widget.originalFees.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: appDarkGrey,
                                  decoration: TextDecoration.lineThrough,
                                  fontWeight: FontWeight.normal,
                                  // decorationColor: Colors.red,
                                  // decorationThickness: 2.0,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,
                                ),
                                // GoogleFonts.tajawal(
                                //   textStyle: TextStyle(
                                //       color: appDarkGrey,
                                //       decoration: TextDecoration.lineThrough,
                                //       // fontWeight: FontWeight.bold,
                                //       decorationColor: Colors.red,
                                //       decorationThickness: 2.0,
                                //       fontStyle: FontStyle.normal,
                                //       fontSize: 16.0,
                                //       ),
                                // ),
                              ),
                            ),
                            Visibility(
                              visible: widget.description != "",
                              child: Text(
                                widget.fees.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.tajawal(
                                  textStyle: const TextStyle(
                                    color: appDarkGrey,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Spacer(),
                Visibility(
                  visible: widget.value != "noPackage" &&
                      widget.value != "alreadyHaveOne",
                  child: OutlineButton(
                    function: () {
                      if (widget.packageId == "20") {
                        Get.to(() => homeScreen(
                              index: 1,
                            ));
                      } else {
                        appBloc.changePackageBenefits(widget.packageBenefits);
                        Get.to(() => PackageBenefits());

                        // Get.defaultDialog(
                        //     title: 'Details'.tr,
                        //     titleStyle: GoogleFonts.tajawal(
                        //       textStyle: const TextStyle(
                        //         color: black,
                        //         fontWeight: FontWeight.bold,
                        //         fontStyle: FontStyle.normal,
                        //         fontSize: 20.0,
                        //       ),
                        //     ),
                        //     content: Padding(
                        //       padding: const EdgeInsets.all(4),
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           ...widget.packageBenefits.map<Widget>(
                        //             (c) => Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.start,
                        //               children: [
                        //                 Icon(
                        //                   Icons.star,
                        //                   color: mainColor,
                        //                   size: 12,
                        //                 ),
                        //                 SizedBox(
                        //                   width: 5,
                        //                 ),
                        //                 Expanded(
                        //                   child: Text(
                        //                     CurrentUser.isArabic
                        //                         ? c['arName']
                        //                         : c['enName'],
                        //                     overflow: TextOverflow.ellipsis,
                        //                     maxLines: 2,
                        //                     style: GoogleFonts.tajawal(
                        //                       textStyle: const TextStyle(
                        //                         color: appDarkGrey,
                        //                         fontWeight: FontWeight.normal,
                        //                         fontStyle: FontStyle.normal,
                        //                         fontSize: 16.0,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //     confirm: RoundButton(
                        //         onPressed: () {
                        //           Get.back();
                        //         },
                        //         padding: false,
                        //         text: 'Okay'.tr,
                        //         color: mainColor));
                      }
                    },
                    title: widget.packageId == "20" ? "Activate".tr : 'More'.tr,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
