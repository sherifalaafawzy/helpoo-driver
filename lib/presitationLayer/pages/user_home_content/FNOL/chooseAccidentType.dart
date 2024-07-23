import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/extensions/build_context_extension.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../../../../dataLayer/constants/variables.dart';
import '../../../../dataLayer/models/currentUser.dart';
import '../../../widgets/fNOLTypeButton.dart';
import '../../../widgets/round_button.dart';
import '../../../widgets/willPopScopeWidget.dart';
import '../../shared/waitingPage.dart';
import 'createFNOL.dart';

class chooseAccidentType extends StatefulWidget {
  const chooseAccidentType({Key? key}) : super(key: key);

  @override
  State<chooseAccidentType> createState() => _SelectAccidentTypesPageState();
}

class _SelectAccidentTypesPageState extends State<chooseAccidentType> {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<FnolBloc>(context);
    bloc.getAllAccidentTypes();
    bloc.fnol.selectedTypes = [];
    return BlocBuilder<FnolBloc, FnolState>(
      builder: (context, state) {
        if (state is FnolInitial || bloc.working) {
          return waitingWidget();
        } else {
          return Stack(
            children: [
              willPopScopeWidget(
                onWillPop: () async {
                  context.pop;
                  // Get.to(() => selectVehicle(
                  //       FNOL: true,
                  //       packageCar: false,
                  //     ));
                  return true;
                },
                child: Scaffold(
                  backgroundColor: appWhite,
                  appBar: AppBar(
                    iconTheme: const IconThemeData(color: appWhite),
                    backgroundColor: mainColor,
                    centerTitle: true,
                    title: Text(
                      "Choose one or more Accident Type".tr,
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
                            context.pop;
                            // Get.to(
                            //   () => selectVehicle(
                            //     FNOL: true,
                            //     packageCar: false,
                            //   ),
                            // );
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
                  body: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            typeButton(bloc.fnol.frontAccident),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                RotatedBox(
                                  quarterTurns: 3,
                                  child:
                                      typeButton(bloc.fnol.rightSideAccident),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    height: Get.height * 0.3,
                                    child: Image.asset(
                                      "assets/imgs/car-top.png",
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: RotatedBox(
                                        quarterTurns: 3,
                                        child: typeButton(
                                            bloc.fnol.carRoofAccident),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                RotatedBox(
                                  quarterTurns: 3,
                                  child: typeButton(bloc.fnol.leftSideAccident),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            typeButton(bloc.fnol.backAccident),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            typeButton(bloc.fnol.frontGlassAccident),
                            Spacer(),
                            typeButton(bloc.fnol.rearGlassAccident),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: typeButton(bloc.fnol.fullCarAccident),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: RoundButton(
                            onPressed: () {
                              if (bloc.fnol.selectedTypes.isEmpty) {
                                HelpooInAppNotification.showErrorMessage(
                                    message:
                                        "Please select one or more type".tr);
                                // Get.snackbar("error".tr,
                                // "Please select one or more type".tr);
                              } else {
                                Get.to(() => const createFNOL());
                              }
                            },
                            padding: false,
                            text: "Next".tr,
                            color: mainColor),
                      ),
                    ],
                  ),
                ),
              ),
              // Positioned(
              //     bottom: 0,
              //     right: 0,
              //     child: Material(
              //       child: SizedBox(
              //         height: 54,
              //         width: 70,
              //         child: InkWell(
              //             child: Container(
              //               color: Colors.transparent,
              //             ),
              //             onTap: () {
              //             }),
              //       ),
              //     )
              //     ),
            ],
          );
        }
      },
    );
  }
}
