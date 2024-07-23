import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../dataLayer/bloc/app/app_bloc.dart';
import '../../../dataLayer/models/package.dart';
import '../../widgets/willPopScopeWidget.dart';
import '../shared/choosePackage.dart';
import '../../../dataLayer/models/currentUser.dart';
import '../../../dataLayer/constants/variables.dart';
import '../../widgets/round_button.dart';
import '../welcome.dart';

class setPassword extends StatefulWidget {
  final bool forgetPass;
  final bool integration;

  const setPassword(
      {Key? key, required this.forgetPass, required this.integration})
      : super(key: key);

  @override
  State<setPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<setPassword> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  TextEditingController confirmPassCtrl = TextEditingController();
  TextEditingController promoCodeCtrl = TextEditingController();
  final GetStorage prefs = GetStorage();

  bool showPass = false;
  bool showConfirmPass = false;

  bool clickable = true;

  @override
  Widget build(BuildContext context) {
    var appBloc = BlocProvider.of<AppBloc>(context);

    return willPopScopeWidget(
      onWillPop: () async {
        Get.to(() => welcome());
        return true;
      },
      child: Scaffold(
        backgroundColor: appWhite,
        appBar: AppBar(
          leading: Container(
            height: 48,
            width: 48,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: IconButton(
                onPressed: () {
                  Get.to(() => welcome());
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
          iconTheme: const IconThemeData(color: appWhite),
          backgroundColor: mainColor,
          centerTitle: true,
          title: Text(
            "set password".tr,
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
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 5),
                Center(
                  child: SizedBox(
                    height: 210,
                    width: 210,
                    child: Image.asset('assets/imgs/password.png'),
                  ),
                ),
                widget.forgetPass == false || widget.integration == true
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 3,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 39.0,
                            ),
                            child: RichText(
                              text: TextSpan(
                                text: 'Full Name'.tr,
                                style: GoogleFonts.tajawal(
                                  textStyle: const TextStyle(
                                    color: mainColor,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                                children: const <TextSpan>[
                                  TextSpan(
                                    text: " *",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 13,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 38.0,
                            ),
                            child: TextFormField(
                              // inputFormatters: <TextInputFormatter>[
                              //   FilteringTextInputFormatter.allow(
                              //       RegExp('[a-z A-Z 0-9]'))
                              // ],
                              controller: nameCtrl,
                              validator: (v) {
                                if (v == null || v.length < 1) {
                                  return "Name Required".tr;
                                }
                                return null;
                              },
                              onChanged: (v) {
                                setState(() {
                                  CurrentUser.name = v;
                                });
                              },
                              decoration: appInput.copyWith(
                                counterText: '',
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(
                  height: 26,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 39.0,
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: 'password'.tr,
                      style: GoogleFonts.tajawal(
                        textStyle: const TextStyle(
                          color: mainColor,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
                        ),
                      ),
                      children: const <TextSpan>[
                        TextSpan(
                          text: " *",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 13,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 38.0,
                  ),
                  child: TextFormField(
                    textDirection: TextDirection.ltr,
                    controller: passCtrl,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: !showPass,
                    validator: (v) {
                      if (v == null || v.length < 8) {
                        return "password length".tr;
                      }
                      return null;
                    },
                    onChanged: (v) {
                      setState(() {
                        CurrentUser.password = v;
                      });
                    },
                    decoration: appInput.copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPass ? Icons.visibility : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            showPass = !showPass;
                          });
                        },
                      ),
                      counterText: '',
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 26,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 39.0,
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: 'password confirmation'.tr,
                      style: GoogleFonts.tajawal(
                        textStyle: const TextStyle(
                          color: mainColor,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
                        ),
                      ),
                      children: const <TextSpan>[
                        TextSpan(
                          text: " *",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 13,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 38.0,
                  ),
                  child: TextFormField(
                    textDirection: TextDirection.ltr,
                    controller: confirmPassCtrl,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: !showConfirmPass,
                    validator: (v) {
                      if (v == null || v.length < 8) {
                        return "password length".tr;
                      }
                      if (v != passCtrl.text) {
                        return "password mismatch".tr;
                      }
                      return null;
                    },
                    decoration: appInput.copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          showConfirmPass
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            showConfirmPass = !showConfirmPass;
                          });
                        },
                      ),
                      counterText: '',
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                widget.forgetPass == false
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 26,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 39.0,
                            ),
                            child: Text(
                              "If you Have Promo Code, Please insert (optional)"
                                  .tr,
                              style: GoogleFonts.tajawal(
                                textStyle: const TextStyle(
                                  color: mainColor,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0,
                                ),
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 38.0,
                            ),
                            child: TextField(
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp('[a-z A-Z 0-9]'))
                              ],
                              controller: promoCodeCtrl,
                              onChanged: (val) {
                                setState(() {
                                  CurrentUser.promoCode.value = val;
                                });
                              },
                              decoration: InputDecoration(
                                prefixIcon:
                                    Image.asset('assets/imgs/coupon.png'),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                hintText: "Enter Promo Code".tr,
                                hintStyle: GoogleFonts.tajawal(
                                  textStyle: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: Get.width,
                  child: RoundButton(
                    onPressed: clickable
                        ? () async {
                            if (CurrentUser.password == confirmPassCtrl.text &&
                                widget.forgetPass == true) {
                              setState(() {
                                clickable = false;
                              });
                              bool done = await CurrentUser.newPass();
                              if (done) {
                                String login = await CurrentUser.userSignIn();
                                if (login == "Done") {
                                  setState(() {
                                    clickable = true;
                                  });

                                  debugPrint(
                                      "packages from register screen : ==> ${Package.packages.length}");

                                  Package.packages =
                                      await appBloc.getAllPackages();

                                  Get.to(() => choosePackage(
                                        register: true,
                                      ));
                                }
                              }
                            } else {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  clickable = false;
                                });
                                bool success = await CurrentUser.userSignUp();
                                if (success) {
                                  String login = await CurrentUser.userSignIn();

                                  if (login == "Done") {
                                    ///* 1- if user inter promo => check if promo package or normal
                                    if (CurrentUser
                                        .promoCode.value.isNotEmpty) {
                                      await sRBloc.checkPromoIfPackageOrNormal(
                                          promoCode:
                                              CurrentUser.promoCode.value);

                                      ///* 2- if normal promo => apply promo code
                                      if (!sRBloc.isPromoPackage) {
                                        bool isSuccess =
                                            await CurrentUser.applyPromoCode(
                                                CurrentUser.promoCode.value);

                                        if (isSuccess) {
                                          HelpooInAppNotification
                                              .showSuccessMessage(
                                                  message:
                                                      "promoApplySuccess".tr);
                                        } else {
                                          HelpooInAppNotification
                                              .showErrorMessage(
                                                  message: "promoCodeError".tr);
                                        }
                                      } else {
                                        sRBloc.packagePromoCode =
                                            CurrentUser.promoCode.value;
                                      }
                                    }

                                    setState(() {
                                      clickable = true;
                                    });
                                    Package.packages =
                                        await appBloc.getAllPackages();

                                    Get.to(() => choosePackage(
                                          register: true,
                                          // thereIsPackagePromoCode:
                                          //     sRBloc.isPromoPackage,
                                          // promoCode:
                                          //     CurrentUser.promoCode.value,
                                        ));
                                  }
                                } else {
                                  HelpooInAppNotification.showErrorMessage(
                                      message: "something Wrong".tr);
                                }
                                setState(() {
                                  clickable = true;
                                });
                              }
                            }
                          }
                        : () {},
                    padding: true,
                    text: clickable ? 'confirm'.tr : "Loading......".tr,
                    color: mainColor,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
