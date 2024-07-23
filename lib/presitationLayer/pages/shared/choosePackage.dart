import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import '../../../dataLayer/models/package.dart';
import '../../widgets/serviceRequest/selectPaymentSheet.dart';
import '../onlinePayment.dart';
import 'mainPackageInsurance.dart';
import '../register/accountSuccess.dart';
import '../../../dataLayer/bloc/app/app_bloc.dart';
import '../../../dataLayer/constants/variables.dart';
import 'package:get/get.dart';
import '../../widgets/activePackages.dart';
import '../homeScreen.dart';
import '../../widgets/round_button.dart';
import '../../../dataLayer/models/currentUser.dart';
import '../../widgets/staticPackageCard.dart';

class choosePackage extends StatefulWidget {
  final bool register;

  // final bool thereIsPackagePromoCode;
  // final String promoCode;

  choosePackage({
    super.key,
    required this.register,
    // this.thereIsPackagePromoCode = false,
    // this.promoCode = "",
  });

  @override
  State<choosePackage> createState() => _choosePackageState();
}

class _choosePackageState extends State<choosePackage> {
  String? paymentGroup;
  List<Package> notActivePackages = [];
  TextEditingController promoCodeCtrl = TextEditingController();
  bool isLoading = false;

  getNotActivePackages() {
    debugPrint("CurrentUser.packages.length ${notActivePackages}");
    notActivePackages = Package.packages;
    debugPrint("CurrentUser.packages.length ${notActivePackages}");

    // if (CurrentUser.packages != []) {
    //   for (var i = 0; i < CurrentUser.packages.length; i++) {
    //     for (var x = 0; x < Package.packages.length; x++) {
    //       if (CurrentUser.packages[i].packageId ==
    //           int.parse(Package.packages[x].id!)) {
    //         notActivePackages.remove(Package.packages[x]);
    //       }
    //     }
    //   }
    // }
  }

  @override
  void initState() {
    super.initState();
    var appBloc = BlocProvider.of<AppBloc>(context);

    CurrentUser.selectedPackage = Package();
    CurrentUser.selectedPackage.id = "";
    getNotActivePackages();
    appBloc.clearPromoPackage();
    if (sRBloc.packagePromoCode.isNotEmpty) {
      promoCodeCtrl.text = sRBloc.packagePromoCode;
      appBloc.validatePromoPackage(sRBloc.packagePromoCode);
    }
  }

  @override
  void dispose() {
    super.dispose();
    sRBloc.packagePromoCode = '';
  }
  @override
  Widget build(BuildContext context) {
    var appBloc = BlocProvider.of<AppBloc>(context);
    return BlocBuilder<ServiceRequestBloc, ServiceRequestState>(
      builder: (context, state) {
        return BlocConsumer<AppBloc, AppBlocState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                backgroundColor: appWhite,
                appBar: widget.register == true
                    ? AppBar(
                        iconTheme: IconThemeData(color: appWhite),
                        backgroundColor: mainColor,
                        centerTitle: true,
                        leading: SizedBox(),
                        title: Text(
                          "Package Subscription".tr,
                          style: GoogleFonts.tajawal(
                            textStyle: const TextStyle(
                              color: appWhite,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      )
                    : null,
                body: appBloc.isPromoPackageLoading
                    ? Center(
                        child: CupertinoActivityIndicator(),
                      )
                    : Padding(
                        padding: EdgeInsets.only(right: 15, left: 15),
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Center(
                                        child: Image.asset(
                                            'assets/imgs/package.png')),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    activePackages(register: widget.register),
                                    InkWell(
                                      onTap: () {
                                        debugPrint("alreadyHaveOne");
                                        setState(() {
                                          CurrentUser.selectedPackage =
                                              Package();
                                          CurrentUser.selectedPackage.id =
                                              "alreadyHaveOne";
                                        });
                                      },
                                      child: staticPackageCard(
                                        title: 'I Already have Package'.tr,
                                        description:
                                            'With car Insurance Policy'.tr,
                                        fees: 'With car Insurance Policy'.tr,
                                        value: "alreadyHaveOne",
                                        originalFees: "0",
                                        isDiscount: false,
                                        active: false,
                                        register: widget.register,
                                        packageBenefits: [],
                                        onChanged: (v) {
                                          setState(() {
                                            CurrentUser.selectedPackage =
                                                Package();
                                            CurrentUser.selectedPackage.id = v;
                                          });
                                        },
                                      ),
                                    ),
                                    ...notActivePackages.map<Widget>(
                                      (Package c) => InkWell(
                                        onTap: () {
                                          setState(() {
                                            CurrentUser.selectedPackage =
                                                Package();
                                            CurrentUser.selectedPackage = c;
                                          });
                                        },
                                        child: staticPackageCard(
                                          title: CurrentUser.isArabic
                                              ? c.arName
                                              : c.enName,
                                          description: CurrentUser.isArabic
                                              ? c.arDescription
                                              : c.enDescription,
                                          originalFees: c.fees.toString(),
                                          isDiscount:
                                              appBloc.isPromoPackageActive,
                                          // && CurrentUser.selectedPackage.id == c.id,
                                          fees: appBloc.isPromoPackageActive
                                              // && CurrentUser.selectedPackage.id == c.id
                                              ? (c.fees -
                                                          ((c.fees *
                                                                  appBloc
                                                                      .promoPackagePercentage) /
                                                              100))
                                                      .toString() +
                                                  " LE / Yearly".tr
                                              : c.fees.toString() +
                                                  " LE / Yearly".tr,
                                          active: false,
                                          packageBenefits: c.packageBenefits,
                                          value: c.id,
                                          register: widget.register,
                                          onChanged: (v) {
                                            setState(() {
                                              CurrentUser.selectedPackage =
                                                  Package();
                                              CurrentUser.selectedPackage = c;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: widget.register,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            CurrentUser.selectedPackage =
                                                Package();

                                            CurrentUser.selectedPackage.id =
                                                "noPackage";
                                          });
                                        },
                                        child: staticPackageCard(
                                          isOneLine: true,
                                          title: 'Continue Without Subscribtion'
                                              .tr,
                                          description: '',
                                          originalFees: "0",
                                          isDiscount: false,
                                          fees: 0.toString(),
                                          active: false,
                                          value: "noPackage",
                                          register: widget.register,
                                          packageBenefits: [],
                                          onChanged: (v) {
                                            setState(() {
                                              CurrentUser.selectedPackage =
                                                  Package();
                                              CurrentUser.selectedPackage.id =
                                                  v;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            appBloc.isPromoPackageActive
                                                ? "Vaild Promo Code".tr
                                                : "Have Promo Code?".tr,
                                            style: GoogleFonts.tajawal(
                                              textStyle: const TextStyle(
                                                color: mainColor,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 20.0,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                  width: Get.width * .55,
                                                  height: Get.height * .055,
                                                  child: TextField(
                                                    inputFormatters: <TextInputFormatter>[
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                              '[a-z A-Z 0-9]'))
                                                    ],
                                                    controller: promoCodeCtrl,
                                                    enabled: !appBloc
                                                        .isPromoPackageActive,
                                                    decoration: InputDecoration(
                                                      prefixIcon: Image.asset(
                                                          'assets/imgs/coupon.png'),
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      hintText: "Promo Code".tr,
                                                      isDense: true,
                                                      hintStyle:
                                                          GoogleFonts.tajawal(
                                                        fontSize: 14,
                                                      ),
                                                      // suffixIcon:
                                                      // appBloc
                                                      //         .isPromoPackageLoading
                                                      //     ? CupertinoActivityIndicator(
                                                      //         color: Theme.of(context)
                                                      //             .primaryColor,
                                                      //       )
                                                      //     : appBloc.isPromoPackageActive
                                                      //         ? MaterialButton(
                                                      //             onPressed: () {
                                                      //               setState(() {
                                                      //                 promoCodeCtrl
                                                      //                     .clear();
                                                      //               });
                                                      //               appBloc
                                                      //                   .clearPromoPackage();
                                                      //             },
                                                      //             child: Text(
                                                      //               "Change".tr,
                                                      //               style: TextStyle(
                                                      //                   color: Colors
                                                      //                       .white),
                                                      //             ),
                                                      //             color: mainColor)
                                                      //         : MaterialButton(
                                                      //             onPressed: () {
                                                      //               // HelpooInAppNotification
                                                      //               //     .showMessage(
                                                      //               //         message:
                                                      //               //             "This Feature Underdevelopment"
                                                      //               //                 .tr);

                                                      //               if (CurrentUser
                                                      //                           .selectedPackage
                                                      //                           .id ==
                                                      //                       "" ||
                                                      //                   CurrentUser
                                                      //                           .selectedPackage
                                                      //                           .id ==
                                                      //                       null) {
                                                      //                 HelpooInAppNotification
                                                      //                     .showErrorMessage(
                                                      //                   message:
                                                      //                       "Please Select one Option to Continue"
                                                      //                           .tr,
                                                      //                 );
                                                      //               } else if (promoCodeCtrl
                                                      //                       .text !=
                                                      //                   "") {
                                                      //                 appBloc.validatePromoPackage(
                                                      //                     promoCodeCtrl
                                                      //                         .text);
                                                      //               }
                                                      //             },
                                                      //             child: Text(
                                                      //               "Submit".tr,
                                                      //               style: TextStyle(
                                                      //                 color:
                                                      //                     Colors.white,
                                                      //               ),
                                                      //             ),
                                                      //             color: mainColor)
                                                    ),
                                                  )),
                                              Spacer(),
                                              appBloc.isPromoPackageLoading
                                                  ? CupertinoActivityIndicator(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    )
                                                  : appBloc.isPromoPackageActive
                                                      ? MaterialButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              promoCodeCtrl
                                                                  .clear();
                                                            });
                                                            appBloc
                                                                .clearPromoPackage();
                                                          },
                                                          child: Text(
                                                            "Change".tr,
                                                            style: GoogleFonts
                                                                .tajawal(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          color: mainColor)
                                                      : MaterialButton(
                                                          onPressed: () {
                                                            // HelpooInAppNotification
                                                            //     .showMessage(
                                                            //         message:
                                                            //             "This Feature Underdevelopment"
                                                            //                 .tr);

                                                            // if (CurrentUser
                                                            //             .selectedPackage
                                                            //             .id ==
                                                            //         "" ||
                                                            //     CurrentUser
                                                            //             .selectedPackage
                                                            //             .id ==
                                                            //         null) {
                                                            //   HelpooInAppNotification
                                                            //       .showErrorMessage(
                                                            //     message:
                                                            //         "Please Select one Option to Continue"
                                                            //             .tr,
                                                            //   );
                                                            // } else
                                                            if (promoCodeCtrl
                                                                    .text !=
                                                                "") {
                                                              appBloc.validatePromoPackage(
                                                                  promoCodeCtrl
                                                                      .text);
                                                            }
                                                          },
                                                          child: Text(
                                                            "Submit".tr,
                                                            style: GoogleFonts
                                                                .tajawal(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          color: mainColor)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: Get.height * 0.06,
                              width: Get.width,
                              child: isLoading
                                  ? CupertinoActivityIndicator(
                                      color: mainColor,
                                    )
                                  : RoundButton(
                                      onPressed: () async {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        if (CurrentUser.selectedPackage.id ==
                                            "alreadyHaveOne") {
                                          if (widget.register == true) {
                                            bool success = await appBloc
                                                .getInsuranceCompany();
                                            if (success) {
                                              Get.to(
                                                  () => mainPackageInsurance(
                                                    fromFnol: false,
                                                  ));
                                            }
                                          } else {
                                            Get.to(
                                                () => mainPackageInsurance(
                                                  fromFnol: false,
                                                ));
                                          }
                                        } else if (CurrentUser
                                                .selectedPackage.id ==
                                            "noPackage") {
                                          if (widget.register == true) {
                                            Get.to(() => accountSuccess());
                                          } else {
                                            setState(() {});
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        homeScreen(index: 0)));
                                          }
                                        } else if (CurrentUser
                                                .selectedPackage.id ==
                                            "0") {
                                          HelpooInAppNotification
                                              .showErrorMessage(
                                            message:
                                                "Please Select one Option to Continue"
                                                    .tr,
                                          );
                                        } else {
                                          if (CurrentUser.selectedPackage.id !=
                                                  "" &&
                                              CurrentUser.selectedPackage.id !=
                                                  null) {
                                            if (appBloc.isPromoPackageActive) {
                                              int newFees = await appBloc
                                                  .usePromoPackage();
                                              if (newFees != 0) {
                                                CurrentUser.selectedPackage
                                                    .fees = newFees;
                                                String url = await appBloc
                                                    .getPaymentTokenPackage();
                                                Get.to(() => onlinePayment(
                                                    url: url, type: "package"));
                                              }
                                            } else {
                                              Get.bottomSheet(
                                                selectPaymentSheet(
                                                  type: 'package',
                                                  bloc: appBloc,
                                                ),
                                              );
                                            }
                                          } else {
                                            HelpooInAppNotification
                                                .showErrorMessage(
                                              message:
                                                  "Please Select one Option to Continue"
                                                      .tr,
                                            );
                                          }
                                        }
                                        setState(() {
                                          isLoading = false;
                                        });
                                      },
                                      padding: false,
                                      text: CurrentUser.selectedPackage.id ==
                                              "noPackage"
                                          ? 'Continue'.tr
                                          : 'Activate'.tr,
                                      color: mainColor),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
              ),
            );
          },
        );
      },
    );
  }
}
