import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';
import 'package:helpoo/presitationLayer/pages/homeScreen.dart';
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:helpoo/service_request/core/util/prints.dart';
import 'package:intl/intl.dart' as intl;
import '../../../dataLayer/constants/variables.dart';
import '../../../dataLayer/models/currentUser.dart';

class profileScreen extends StatefulWidget {
  profileScreen({Key? key}) : super(key: key);

  @override
  State<profileScreen> createState() => _ProfileState();
}

class _ProfileState extends State<profileScreen> {
  bool promoCode = CurrentUser.promoCode.value != "" ? true : false;
  TextEditingController promoCodeCtrl = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController mailCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  bool loaded = false;
  bool isClickable = true;

  @override
  void initState() {
    setState(() {
      nameCtrl.text = CurrentUser.name!;
      mailCtrl.text = CurrentUser.email;
      phoneCtrl.text = CurrentUser.phoneNumber!;
      promoCodeCtrl.text = CurrentUser.promoCode.value;
      CurrentUser.promoCode.id == null
          ? CurrentUser.promoVisibility = false
          : CurrentUser.promoVisibility = true;
      // CurrentUser.promoVisibility =
      //     CurrentUser.promoCode.value != "" ? true : false;
    });

    super.initState();
  }

  var _formKey = GlobalKey<FormState>();

  bool isAddPromoLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceRequestBloc, ServiceRequestState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: appWhite,
            body: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                width: Get.width * .9,
                height: Get.height * .75,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CircleAvatar(
                          child: Image.asset(
                            "assets/imgs/person.jpg",
                          ),
                          radius: 50,
                        ),
                        // SizedBox(
                        //   height: Get.height * .12,
                        // ),
                        SizedBox(
                          width: Get.width * .8,
                          child: TextField(
                            onChanged: (v) {
                              CurrentUser.name = v;
                            },
                            controller: nameCtrl,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * .02,
                        ),
                        SizedBox(
                          width: Get.width * .8,
                          child: TextField(
                            // inputFormatters: <TextInputFormatter>[
                            //   FilteringTextInputFormatter.allow(
                            //       RegExp('[a-z A-Z 0-9]'))
                            // ],
                            textAlign: Get.locale!.languageCode == "ar"
                                ? TextAlign.right
                                : TextAlign.left,
                            textDirection: TextDirection.ltr,
                            controller: phoneCtrl,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              enabled: false,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * .02,
                        ),
                        SizedBox(
                          width: Get.width * .8,
                          child: TextFormField(
                            onChanged: (v) {
                              CurrentUser.email = v;
                            },
                            validator: (v) {
                              if (v!.length > 0 &&
                                  (!(v.contains("@")) || !(v.contains(".")))) {
                                return "Email is not valid".tr;
                              }
                              return null;
                            },
                            controller: mailCtrl,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.mail),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              hintText: "Enter Email Address".tr,
                              hintStyle: GoogleFonts.tajawal(
                                textStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * .03,
                        ),
                        Container(
                          width: Get.width * .8,
                          height: Get.height * .18,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: .5,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: CurrentUser.promoVisibility!
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: Get.width * .7,
                                      child: Column(
                                        children: [
                                          Text(
                                            "Promo Code Valid till".tr,
                                            style: GoogleFonts.tajawal(
                                              textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                          Text(intl.DateFormat("dd/MM/yyyy")
                                              .format(DateTime.parse(CurrentUser
                                                  .promoCode.expiryDate
                                                  .toString()))),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: Get.height * .02),
                                    InkWell(
                                      onTap: () async {
                                        setState(() {
                                          // CurrentUser.promoCode = null;
                                          CurrentUser.promoVisibility = false;
                                        });
                                      },
                                      child: Container(
                                        width: Get.width * .7,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          color: mainColor,
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Replace Promo Code'.tr,
                                            style: GoogleFonts.tajawal(
                                              textStyle: const TextStyle(
                                                color: appWhite,
                                                fontWeight: FontWeight.w400,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: Get.width * .7,
                                      child: TextField(
                                        decoration: InputDecoration(
                                          prefixIcon: Image.asset(
                                              'assets/imgs/coupon.png'),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          hintText: "Enter Promo Code".tr,
                                          hintStyle: GoogleFonts.tajawal(
                                            textStyle: TextStyle(
                                              color: Colors.grey[400],
                                              fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          suffixIcon:
                                              CurrentUser.promoCode.id != null
                                                  ? InkWell(
                                                      onTap: () async {
                                                        setState(
                                                          () {
                                                            if (CurrentUser
                                                                    .promoCode
                                                                    .id !=
                                                                null) {
                                                              CurrentUser
                                                                      .promoVisibility =
                                                                  true;
                                                            } else {
                                                              promoCodeCtrl
                                                                  .text = "";
                                                            }
                                                          },
                                                        );
                                                      },
                                                      child: Icon(
                                                        Icons.close,
                                                        color: mainColor,
                                                        size: 20,
                                                      ),
                                                    )
                                                  : SizedBox.shrink(),
                                        ),
                                        onChanged: (v) {
                                          setState(() {
                                            promoCodeCtrl.text = v;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(height: Get.height * .02),
                                    InkWell(
                                      onTap: isAddPromoLoading
                                          ? null
                                          : () async {
                                              setState(() {
                                                isAddPromoLoading = true;
                                              });

                                              ///* 1- if user inter promo => check if promo package or normal
                                              if (promoCodeCtrl
                                                  .text.isNotEmpty) {
                                                await sRBloc
                                                    .checkPromoIfPackageOrNormal(
                                                        promoCode:
                                                            promoCodeCtrl.text);

                                                ///* 2- if normal promo => apply promo code
                                                if (!sRBloc.isPromoPackage) {
                                                  bool isSuccess =
                                                      await CurrentUser
                                                          .applyPromoCode(
                                                              promoCodeCtrl
                                                                  .text);

                                                  if (isSuccess) {
                                                    setState(() {
                                                      promoCode = true;
                                                    });
                                                  } else {
                                                    HelpooInAppNotification
                                                        .showErrorMessage(
                                                            message:
                                                                "promoCodeError"
                                                                    .tr);
                                                  }
                                                  setState(() {
                                                    isAddPromoLoading = false;
                                                  });
                                                } else {
                                                  printMeLog(
                                                      'isPromoPackage *******************');
                                                  printMeLog(
                                                      'isPromoPackage11 ${promoCodeCtrl.text}');

                                                  sRBloc.packagePromoCode =
                                                      promoCodeCtrl.text;

                                                  printMeLog(
                                                      'isPromoPackage22 ${sRBloc.packagePromoCode}');
                                                  setState(() {
                                                    isAddPromoLoading = false;
                                                  });
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          homeScreen(
                                                        index: 2,
                                                      ),
                                                    ),
                                                  );

                                                  // Get.off(
                                                  //   () => homeScreen(
                                                  //     index: 2,
                                                  //   ),
                                                  // );
                                                }
                                              }
                                            },
                                      child: isAddPromoLoading
                                          ? Center(
                                              child: CupertinoActivityIndicator(
                                                  color: mainColor),
                                            )
                                          : Container(
                                              width: 120,
                                              height: 40,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                color: mainColor,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Add'.tr,
                                                  style: GoogleFonts.tajawal(
                                                    textStyle: const TextStyle(
                                                      color: appWhite,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                        ),
                        SizedBox(
                          height: Get.height * .04,
                        ),
                        InkWell(
                          onTap: isClickable
                              ? () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      isClickable = false;
                                    });
                                    bool x = await CurrentUser.updateUser();
                                    if (x) {
                                      bool success =
                                          await CurrentUser.getUser();
                                      if (success) {
                                        setState(() {
                                          isClickable = true;
                                        });
                                      }
                                      // setState(() {});
                                    } else {
                                      setState(() {
                                        isClickable = true;
                                      });
                                    }
                                  }
                                }
                              : null,
                          child: Container(
                            width: Get.width * .7,
                            height: Get.height * .06,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: mainColor,
                            ),
                            child: Center(
                              child: Text(
                                isClickable ? "save".tr : "Loading......".tr,
                                style: GoogleFonts.tajawal(
                                  textStyle: const TextStyle(
                                    color: appWhite,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
