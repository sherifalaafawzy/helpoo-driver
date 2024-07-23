// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:helpoo/main.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../widgets/willPopScopeWidget.dart';
import '../../shared/waitingPage.dart';
import 'chooseAccidentType.dart';
import 'shootingNotes.dart';
import '../../../../dataLayer/models/currentUser.dart';
import '../../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../../../../dataLayer/constants/variables.dart';
import '../../../widgets/FNOL/fnolCarCard.dart';
import '../../../widgets/FNOL/insuredCompany.dart';
import '../../../widgets/round_button.dart';

class createFNOL extends StatefulWidget {
  const createFNOL({Key? key}) : super(key: key);

  @override
  State<createFNOL> createState() => createFNOLState();
}

class createFNOLState extends State<createFNOL> {
  GlobalKey<FormState> createAccidentFormKey = GlobalKey<FormState>();
  var bloc = BlocProvider.of<FnolBloc>(navigatorKey.currentContext!);

  @override
  void initState() {
    super.initState();
    bloc.getLocation("createFnol");
  }

  bool isWorking = true;

  @override
  Widget build(BuildContext context) {
    // bloc.getLocation("createFnol");
    return BlocBuilder<FnolBloc, FnolState>(
      builder: (context, state) {
        if (state is GetCurrentPosition) {
          return willPopScopeWidget(
            onWillPop: () async {
              setState(() {
                bloc.fnol.selectedTypes = [];
              });
              Get.to(() => chooseAccidentType());
              return true;
            },
            child: Stack(
              children: [
                Scaffold(
                  backgroundColor: appWhite,
                  appBar: AppBar(
                    iconTheme: const IconThemeData(color: appWhite),
                    backgroundColor: mainColor,
                    centerTitle: true,
                    title: Text(
                      "accident report ".tr,
                      style: GoogleFonts.tajawal(
                        textStyle: const TextStyle(
                          color: appWhite,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    leading: Container(
                      height: 48,
                      width: 48,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              bloc.fnol.selectedTypes = [];
                            });
                            Get.to(() => chooseAccidentType());
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
                  ),
                  body: Form(
                    key: createAccidentFormKey,
                    child: ListView(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          fNOLCarCard(false),
                          fNOLDataCard("insurance company".tr,
                              bloc.fnol.selectedCar!.insuranceCompany!.name),
                          fNOLDataCard(
                              "damaged parts".tr,
                              bloc.fnol.selectedTypes
                                  .map((t) => t.name)
                                  .join('\n')),
                          fNOLDataCard(
                              "accident location".tr, bloc.fnol.currentAddress),
                          // fNOLDataCard(
                          //     "accident location".tr,
                          //     bloc.fnol.currentAddress ??
                          //         "getting your address".tr),
                          Visibility(
                            visible: bloc.fnol.currentLocation != null &&
                                bloc.fnol.currentAddress != null,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: RoundButton(
                                isLoading: !isWorking,
                                onPressed: () async {
                                  if (bloc.fnol.currentLocation == null) {
                                    HelpooInAppNotification.showErrorMessage(
                                        message:
                                            "Please enable location service"
                                                .tr);

                                    return;
                                  }
                                  if (createAccidentFormKey.currentState
                                          ?.validate() !=
                                      true) {
                                    return;
                                  }
                                  if (bloc.fnol.selectedCar == null) {
                                    Get.back();
                                    return;
                                  }
                                  if (bloc.fnol.selectedTypes.isEmpty) {
                                    Get.back();
                                    return;
                                  }
                                  setState(() {
                                    isWorking = false;
                                  });
                                  bool success = await bloc.createFNOL(bloc,);
                                  if (success) {
                                    setState(() {
                                      isWorking = true;
                                    });
                                    setState(() {
                                      bloc.fnol.allImagesCounter = 0;
                                      bloc.fnol.imageCounter = 0;
                                    });
                                    Get.to(
                                      () => shootingNotes(),
                                    );
                                  } else {
                                    setState(() {
                                      isWorking = true;
                                    });
                                    HelpooInAppNotification.showErrorMessage(
                                      message: "FNOL Creating Failed".tr,
                                    );
                                  }
                                },
                                padding: false,
                                text: "confirm entered data".tr,
                                color: mainColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Material(
                      child: SizedBox(
                        height: 54,
                        width: 70,
                        child: InkWell(
                            child: Container(
                              color: Colors.transparent,
                            ),
                            onTap: () {}),
                      ),
                    )),
              ],
            ),
          );
        } else {
          return waitingWidget();
        }
      },
    );
  }
}
