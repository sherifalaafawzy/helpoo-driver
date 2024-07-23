// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/dataLayer/models/packageBenefitsModel.dart';
import 'package:helpoo/presitationLayer/pages/homeScreen.dart';
import 'package:helpoo/presitationLayer/pages/shared/packagePenefits.dart';
import '../../dataLayer/bloc/app/app_bloc.dart';
import '../../dataLayer/models/currentUser.dart';
import '../../dataLayer/constants/variables.dart';
import '../../dataLayer/models/package.dart';
import 'round_button.dart';

class choosePackageCard extends StatefulWidget {
  choosePackageCard({
    super.key,
    required this.package,
    required this.onChanged,
    required this.active,
    required this.register,
    required this.value,
    required this.packageBenefits,
  });

  Package package;

  bool active;
  bool register;
  final onChanged;
  var value;
  List<PackageBenefitsModel> packageBenefits;

  @override
  State<choosePackageCard> createState() => _choosePackageCardState();
}

class _choosePackageCardState extends State<choosePackageCard> {
  @override
  Widget build(BuildContext context) {
    var appBloc = BlocProvider.of<AppBloc>(context);

    return BlocBuilder<AppBloc, AppBlocState>(
      builder: (context, state) {
        return Container(
          height: Get.height * .10,
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
                // widget.package.packageId == "20"
                //     ? Padding(
                //         padding: EdgeInsets.symmetric(horizontal: 10),
                //         child: Row(
                //           children: [
                //             // widget.register
                //             //     ? Radio(
                //             //         value: widget.value,
                //             //         groupValue: CurrentUser.selectedPackage.id,
                //             //         onChanged: widget.onChanged,
                //             //       )
                //             //     : Container(),
                //             Container(
                //               width: Get.width * .1,
                //               height: Get.height * .1,
                //               child: Image.asset("assets/imgs/deltaLogo.png"),
                //             ),
                //           ],
                //         ),
                //       )

                // :
                SizedBox(
                  width: 20,
                ),
                widget.active
                    ?
                    // appBloc.isPromoPackageActive &&
                    // CurrentUser.selectedPackage.id == widget.value &&
                            // appBloc.PromoPackageImage != ""
                            appBloc.getCompanyLogoForPackage(package: widget.package).isNotEmpty
                        ? Container(
                            width: Get.width * .1,
                            height: Get.height * .1,
                            child:
                                Image.network(appBloc.getCompanyLogoForPackage(package:  widget.package)),
                          )
                        // : widget.package.usedPromosPackages.isNotEmpty
                        //     ? Container(
                        //         width: Get.width * .1,
                        //         height: Get.height * .1,
                        //         child: Image.network(widget
                        //                 .package.usedPromosPackages[0].packagePromoCode!.corporateCompany!.photo!
                        //                 .startsWith("http")
                        //             ? widget.package.usedPromosPackages[0].packagePromoCode!.corporateCompany!.photo!
                        //             : assetsUrl +
                        //                 widget
                        //                     .package.usedPromosPackages[0].packagePromoCode!.corporateCompany!.photo!),
                        //       )
                            : Container()
                    : Radio(
                        value: widget.value,
                        groupValue: CurrentUser.selectedPackage.id,
                        onChanged: widget.onChanged,
                      ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          CurrentUser.isArabic ? widget.package.arName : widget.package.enName,
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
                          visible: widget.package.enDescription != "",
                          child: Text(
                            widget.package.usedPromosPackages.isNotEmpty
                                ? widget.package.usedPromosPackages[0].fees.toString() +
                                    " LE / Yearly".tr +
                                    "    " +
                                    widget.package.numberOfCars.toString() +
                                    "/" +
                                    widget.package.assignedCars.toString()
                                : widget.package.fees.toString() +
                                    " LE / Yearly".tr +
                                    "    " +
                                    widget.package.numberOfCars.toString() +
                                    "/" +
                                    widget.package.assignedCars.toString(),
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
                ),
                // Spacer(),
                Visibility(
                  visible: widget.value != "noPackage",
                  child: OutlineButton(
                    function: () {
                      if (widget.package.packageId == "20") {
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
                        //           ...widget.package.packageBenefits.map<Widget>(
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
                        //                 Text(
                        //                  c.name,
                        //                   overflow: TextOverflow.ellipsis,
                        //                   maxLines: 2,
                        //                   style: GoogleFonts.tajawal(
                        //                     textStyle: const TextStyle(
                        //                       color: appDarkGrey,
                        //                       fontWeight: FontWeight.normal,
                        //                       fontStyle: FontStyle.normal,
                        //                       fontSize: 16.0,
                        //                     ),
                        //                   ),
                        //                 )
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
                    title: widget.package.packageId == "20" ? "Activate".tr : 'More'.tr,
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
