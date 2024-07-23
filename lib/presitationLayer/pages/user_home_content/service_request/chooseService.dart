
// ignore_for_file: dead_code, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/dataLayer/models/currentUser.dart';
import 'package:helpoo/presitationLayer/pages/homeScreen.dart';
import 'package:helpoo/presitationLayer/pages/user_home_content/service_request/selectVehicle.dart';
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';
import 'package:helpoo/service_request/core/util/cubit/state.dart';
import 'package:helpoo/service_request/core/util/extensions/build_context_extension.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:helpoo/service_request/core/util/routes.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../dataLayer/bloc/app/app_bloc.dart';
import '../../../../dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';
import '../../../../dataLayer/constants/variables.dart';
import '../../../widgets/willPopScopeWidget.dart';
import '../../../widgets/round_button.dart';

class chooseService extends StatefulWidget {
  const chooseService({super.key});

  @override
  State<chooseService> createState() => _chooseServiceState();
}

class _chooseServiceState extends State<chooseService> {
  // bool isLoading = false;

  // @override
  // void dispose() {
  //   var bloc = BlocProvider.of<ServiceRequestBloc>(context);
  //   bloc.close();
  //   super.dispose();
  // }

  getCurrentLocation() async {
    var bloc = BlocProvider.of<ServiceRequestBloc>(context);

    await bloc.getLocation();
  }

  @override
  void initState() {
    var cubit = BlocProvider.of<AppBloc>(context);
    getCurrentLocation();

    setState(() {
      cubit.selected = false;
      cubit.emit(UnSelected());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<ServiceRequestBloc>(context);
    bloc.getLocation();
    return willPopScopeWidget(
      onWillPop: () async {
        // Get.to(() => selectVehicle(FNOL: false, packageCar: false));
        Get.to(() => homeScreen(index: 0));

        return true;
      },
      child: Scaffold(
        backgroundColor: appWhite,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: appWhite),
          backgroundColor: mainColor,
          centerTitle: true,
          leading: Container(
            height: 48,
            width: 48,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: IconButton(
                onPressed: () {
                  Get.to(() => homeScreen(index: 0));

                  // Get.to(() => selectVehicle(FNOL: false, packageCar: false));
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
          title: Text(
            "road services".tr,
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
        body: BlocBuilder<AppBloc, AppBlocState>(
          builder: (context, state) {
            AppBloc cubit = BlocProvider.of<AppBloc>(context);
            return Container(
                color: Colors.transparent,
                child: SizedBox(
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 17,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 46.0),
                        child: SizedBox(
                          height: 57,
                          child: Image.asset('assets/imgs/newLogo.png'),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Center(
                        child: Text(
                          'road services'.tr,
                          style: GoogleFonts.tajawal(
                            textStyle: const TextStyle(
                              color: mainColor,
                              fontWeight: FontWeight.w800,
                              fontStyle: FontStyle.normal,
                              fontSize: 30.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 51.0),
                        child: Image.asset('assets/imgs/wench12.png'),
                      ),
                      const SizedBox(
                        height: 28,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Row(
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Builder(builder: (context) {
                                    // bool selected = cubit.selected;
                                    return GestureDetector(
                                      onTap: () {
                                        // cubit.CheckBox();
                                        if (cubit.selected) {
                                          cubit.CheckBox();
                                        } else if (!cubit.selected) {
                                          cubit.CheckBox();
                                        }
                                      },
                                      child: Row(children: [
                                        Icon(
                                          cubit.selected
                                              ? MdiIcons.checkboxBlank
                                              : MdiIcons.checkboxBlankOutline,
                                          color: mainColor,
                                        ),
                                        Text(
                                          'Wench'.tr,
                                          style: GoogleFonts.tajawal(
                                            textStyle: const TextStyle(
                                              color: mainColor,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ]),
                                    );
                                  }),
                                  const SizedBox(height: 19),
                                  Builder(builder: (context) {
                                    bool selected = false;
                                    return GestureDetector(
                                      onTap: () {
                                        Get.dialog(
                                          AlertDialog(
                                            title: Text(
                                              'please Call 17000'.tr,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.tajawal(
                                                textStyle: const TextStyle(
                                                  color: black,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              SizedBox(
                                                width: double.infinity,
                                                child: RoundButton(
                                                  onPressed: () async {
                                                    if (!await launchUrl(
                                                      Uri.parse('tel:17000'),
                                                    )) {
                                                      HelpooInAppNotification
                                                          .showErrorMessage(
                                                              message:
                                                                  "Could not Make Call"
                                                                      .tr);
                                                    }
                                                    Get.back();
                                                  },
                                                  padding: false,
                                                  text: 'Call 17000'.tr,
                                                  color: mainColor,
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      child: Row(children: [
                                        Icon(
                                          selected
                                              ? MdiIcons.checkboxBlank
                                              : MdiIcons.checkboxBlankOutline,
                                          color: mainColor,
                                        ),
                                        Text(
                                          'Battery'.tr,
                                          style: GoogleFonts.tajawal(
                                            textStyle: const TextStyle(
                                              color: mainColor,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ]),
                                    );
                                  }),
                                ]),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Builder(builder: (context) {
                                  bool selected = false;
                                  return GestureDetector(
                                    onTap: () {
                                      Get.dialog(
                                        AlertDialog(
                                          title: Text(
                                            'please Call 17000'.tr,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.tajawal(
                                              textStyle: const TextStyle(
                                                color: black,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 20.0,
                                              ),
                                            ),
                                          ),
                                          actions: [
                                            SizedBox(
                                              width: double.infinity,
                                              child: RoundButton(
                                                onPressed: () async {
                                                  if (!await launchUrl(
                                                      Uri.parse('tel:17000'))) {
                                                    HelpooInAppNotification
                                                        .showErrorMessage(
                                                            message:
                                                                "Could not Make Call"
                                                                    .tr);
                                                  }
                                                  Get.back();
                                                },
                                                padding: false,
                                                text: 'Call 17000'.tr,
                                                color: mainColor,
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    child: Row(children: [
                                      Icon(
                                        selected
                                            ? MdiIcons.checkboxBlank
                                            : MdiIcons.checkboxBlankOutline,
                                        color: mainColor,
                                      ),
                                      Text(
                                        'Tire'.tr,
                                        style: GoogleFonts.tajawal(
                                          textStyle: const TextStyle(
                                            color: mainColor,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                    ]),
                                  );
                                }),
                                const SizedBox(height: 19),
                                Builder(
                                  builder: (context) {
                                    bool selected = false;
                                    return GestureDetector(
                                      onTap: () {
                                        Get.dialog(
                                          AlertDialog(
                                            title: Text(
                                              'please Call 17000'.tr,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.tajawal(
                                                textStyle: const TextStyle(
                                                  color: black,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              SizedBox(
                                                width: double.infinity,
                                                child: RoundButton(
                                                  onPressed: () async {
                                                    if (!await launchUrl(
                                                        Uri.parse(
                                                            'tel:17000'))) {
                                                      HelpooInAppNotification
                                                          .showErrorMessage(
                                                              message:
                                                                  "Could not Make Call"
                                                                      .tr);
                                                    }
                                                    Get.back();
                                                  },
                                                  padding: false,
                                                  text: 'Call 17000'.tr,
                                                  color: mainColor,
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            selected
                                                ? MdiIcons.checkboxBlank
                                                : MdiIcons.checkboxBlankOutline,
                                            color: mainColor,
                                          ),
                                          Text(
                                            'Fuel'.tr,
                                            style: GoogleFonts.tajawal(
                                              textStyle: const TextStyle(
                                                color: mainColor,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      // if(isLoading)
                      //   Padding(
                      //     padding: const EdgeInsets.all(20.0),
                      //     child: const CupertinoActivityIndicator(
                      //       color: mainColor,
                      //     ),
                      //   ),
                      // if(!isLoading)
                      BlocListener<NewServiceRequestBloc,
                          NewServiceRequestState>(
                        listener: (context, state) {
                          if (state is SetMyLocationSuccess) {
                            // debugPrint("SetMyLocationSuccessStateFired");
                            debugPrint("SetMyLocationCountFired");
                            context.pushNamedAndRemoveUntil =
                                Routes.serviceRequestMap;
                          }
                        },
                        child: Container(
                          color: Colors.transparent,
                          width: Get.width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: RoundButton(
                              onPressed: () {
                                if (cubit.selected == false) {
                                  HelpooInAppNotification.showErrorMessage(
                                      message:
                                          "please select Service first".tr);
                                  // Get.snackbar("error".tr,
                                  // "please select Service first".tr);
                                  // setState(() {
                                  //   isLoading = false;
                                  // });
                                } else {
                                  // await bloc.getLocation();
                                  // Get.to(() => serviceRMapPicker());

                                  if (CurrentUser.isCorporate) {
                                    // sRBloc.CORPORATE_REQUEST_ID = null;
                                    if (sRBloc.currentPosition == null) {
                                      sRBloc.startLocationServiceOnce();
                                    } else {
                                      sRBloc.fireLocationAlreadyHere();
                                    }
                                  } else {
                                    Get.to(() => selectVehicle(
                                        FNOL: false, packageCar: false));
                                  }

                                  // setState(() {
                                  //   isLoading = true;
                                  // });
                                }
                              },
                              padding: true,
                              text: 'next'.tr,
                              color: mainColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ));
          },
        ),
      ),
    );
  }
}
