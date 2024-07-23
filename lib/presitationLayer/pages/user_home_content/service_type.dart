// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/presitationLayer/pages/user_home_content/service_request/chooseService.dart';
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';
import 'package:helpoo/service_request/core/util/cubit/state.dart';
import 'package:helpoo/service_request/core/util/extensions/build_context_extension.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:helpoo/service_request/core/util/routes.dart';
import '../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../../../dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';
import '../../../dataLayer/constants/variables.dart';
import '../../../dataLayer/models/currentUser.dart';
import 'service_request/selectVehicle.dart';

class chooseYourServices extends StatefulWidget {
  chooseYourServices({
    super.key,
  });

  @override
  State<chooseYourServices> createState() => _chooseYourServicesState();
}

class _chooseYourServicesState extends State<chooseYourServices> {
  clearRequest(cubit) async {
    cubit.googleMapsModel.clearMapModel();
    await cubit.request.clearRequest();
  }

  @override
  void initState() {
    super.initState();
    var cubit = BlocProvider.of<ServiceRequestBloc>(context);
    clearRequest(cubit);
  }

  bool working = false;

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<FnolBloc>(context);
    var cubit = BlocProvider.of<ServiceRequestBloc>(context);
    return SizedBox(
      height: Get.width * 0.8 * 0.85,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                BlocConsumer<NewServiceRequestBloc, NewServiceRequestState>(
                  listener: (context, state) {
                    if (state is CheckServiceRequestSuccessState) {
                      debugPrint(
                          "================= CheckServiceRequestSuccessState ====================");
                      setState(() {
                        working = false;
                      });
                      if (state.isRequestActive) {
                        debugPrint("==== isRequestActive =====");
                        context.pushNamedAndRemoveUntil =
                            Routes.serviceRequestMap;
                      } else {
                        Get.to(
                          () => chooseService(),
                        );
                      }
                    }
                  },
                  builder: (context, state) {
                    return InkWell(
                      onTap: working
                          ? null
                          : () async {
                              if (CurrentUser.isCorporate) {
                                Get.to(
                                  () => selectVehicle(
                                    FNOL: false,
                                    packageCar: false,
                                  ),
                                );
                              } else {
                                sRBloc.checkServiceRequest();

                                setState(() {
                                  working = true;
                                });

                                // sl<CacheHelper>()
                                //     .get('CURRENT_REQUEST_ID')
                                //     .then((value) {
                                //   if (value != null) {
                                //     debugPrint(
                                //         "=====================================");
                                //     // context.pushNamed = Routes.serviceRequestMap;
                                //     // sRBloc.clearOnStart(isFromTopButton: true);
                                //   } else {
                                //     debugPrint(
                                //         "++++++++++++++++++++++++++++++++++++++");
                                //     // sRBloc.CURRENT_REQUEST_ID = 0;
                                //     Get.to(() => chooseService());
                                //   }
                                // });

                                // setState(() {
                                //   working = true;
                                // });
                                //
                                // bool exist = await cubit.getActiveRequest(cubit);
                                //
                                // if (exist) {
                                //   if (cubit.request.driver == null) {
                                //     await cubit.getDriver();
                                //   }
                                //
                                //   Get.to(() => serviceRMapPicker(
                                //         isUpdatedRequest: true,
                                //       ));
                                // } else {
                                //   debugPrint("not exist");
                                //
                                //   // Get.to(
                                //   //     () => selectVehicle(FNOL: false, packageCar: false));
                                //
                                //   Get.to(() => chooseService());
                                // }
                                //
                                // setState(() {
                                //   working = false;
                                // });
                              }
                            },
                      child: Column(
                        children: [
                          Container(
                            width: Get.width * 0.8,
                            height: Get.width * 0.8 * 9 / 16,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: mainColor,
                                width: 3,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  12,
                                ),
                              ),
                              color: appWhite,
                            ),
                            child: false
                                ? Center(
                                    child: CupertinoActivityIndicator(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  )
                                : Image.asset(
                                    'assets/imgs/wench12.png',
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                if (working)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: const CupertinoActivityIndicator(
                      color: mainColor,
                    ),
                  ),
                if (!working)
                  BlocConsumer<NewServiceRequestBloc, NewServiceRequestState>(
                    listener: (context, state) {
                      if (state is CheckServiceRequestSuccessState) {
                        setState(() {
                          working = false;
                        });

                        if (state.isRequestActive) {
                          context.pushNamedAndRemoveUntil =
                              Routes.serviceRequestMap;
                        } else {
                          Get.to(
                            () => chooseService(),
                          );
                        }
                      }
                    },
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () async {
                          if (CurrentUser.isCorporate) {
                            Get.to(() =>
                                selectVehicle(FNOL: false, packageCar: false));
                          } else {
                            sRBloc.checkServiceRequest();

                            setState(() {
                              working = true;
                            });

                            // sl<CacheHelper>()
                            //     .get('CURRENT_REQUEST_ID')
                            //     .then((value) {
                            //   if (value != null) {
                            //     debugPrint(
                            //         "=====================================");
                            //     // context.pushNamed = Routes.serviceRequestMap;
                            //
                            //     // sRBloc.clearOnStart(isFromTopButton: true);
                            //   } else {
                            //     // sRBloc.CURRENT_REQUEST_ID = 0;
                            //     debugPrint(
                            //         "++++++++++++++++++++++++++++++++++++++");
                            //     Get.to(() => chooseService());
                            //   }
                            // });

                            // if (await sl<CacheHelper>().get('CURRENT_REQUEST_ID') !=
                            //     null) {
                            //   debugPrint("=====================================");
                            //   context.pushNamed = Routes.serviceRequestMap;
                            // } else {
                            //   debugPrint("++++++++++++++++++++++++++++++++++++++");
                            //   Get.to(() => chooseService());
                            // }

                            // setState(() {
                            //   working = true;
                            // });
                            //
                            // bool exist = await cubit.getActiveRequest(cubit);
                            //
                            // if (exist) {
                            //   if (cubit.request.driver == null) {
                            //     await cubit.getDriver();
                            //   }
                            //
                            //   Get.to(() => serviceRMapPicker(
                            //         isUpdatedRequest: true,
                            //       ));
                            // } else {
                            //   debugPrint("not exist");
                            //
                            //   // Get.to(
                            //   //     () => selectVehicle(FNOL: false, packageCar: false));
                            //
                            //   Get.to(() => chooseService());
                            // }
                            //
                            // setState(() {
                            //   working = false;
                            // });
                          }

                          // else {
                          //   setState(() {
                          //     working = true;
                          //   });
                          //   bool exist = await cubit.getActiveRequest(cubit);
                          //   if (exist) {
                          //     if (cubit.request.driver == null) {
                          //       await cubit.getDriver();
                          //     }
                          //     Get.to(() => serviceRMapPicker(
                          //           isUpdatedRequest: true,
                          //         ));
                          //   } else {
                          //     Get.to(() => chooseService());
                          //
                          //     // Get.to(
                          //     //     () => selectVehicle(FNOL: false, packageCar: false));
                          //   }
                          //   setState(() {
                          //     working = false;
                          //   });
                          // }
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Container(
                            width: Get.width * .56,
                            height: Get.height * .055,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: mainColor,
                            ),
                            child: false
                                ? Center(
                                    child: CupertinoActivityIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      'road services'.tr,
                                      style: GoogleFonts.tajawal(
                                        textStyle: const TextStyle(
                                          color: appWhite,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 22.0,
                                        ),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
            if (!CurrentUser.isCorporate)
              Column(
                children: [
                  InkWell(
                    onTap: (() async {
                      if (CurrentUser.isCorporate) {
                        HelpooInAppNotification.showErrorMessage(
                            message:
                                'This feature is not available for corporate users'
                                    .tr);
                      } else {
                        await bloc.camera.init();
                        Get.to(
                            () => selectVehicle(FNOL: true, packageCar: false));
                      }
                    }),
                    child: Container(
                      width: Get.width * 0.8,
                      height: Get.width * 0.8 * 9 / 16,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: mainColor,
                          width: 3,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            12,
                          ),
                        ),
                        color: appWhite,
                      ),
                      child: Image.asset(
                        'assets/imgs/reports.png',
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (() async {
                      await bloc.camera.init();
                      Get.to(
                          () => selectVehicle(FNOL: true, packageCar: false));
                    }),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Container(
                        width: Get.width * .56,
                        height: Get.height * .055,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: mainColor,
                        ),
                        child: Center(
                          child: Text(
                            'Notify An Accident (FNOL)'.tr,
                            style: GoogleFonts.tajawal(
                              textStyle: const TextStyle(
                                color: appWhite,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 18.0,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
