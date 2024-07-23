import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../dataLayer/bloc/driver/driver_cubit.dart';
import '../../dataLayer/constants/variables.dart';
import '../../dataLayer/models/currentUser.dart';
import '../widgets/driver_widgits/getDriverRequests.dart';
import 'shared/errorPage.dart';
import 'shared/setting.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({Key? key}) : super(key: key);

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  String appVersion = "";

  // String? IMEI;

  getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  // getIMEI() async {
  //   IMEI = await UniqueIdentifier.serial;
  //   await Driver.setIMEIFcm(IMEI);
  // }

  // getDeviceId() async {
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   // if (Platform.isAndroid) {
  //   AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
  //   debugPrint(androidDeviceInfo.id);
  //
  //   IMEI = androidDeviceInfo.id;
  //   // }
  //   // else {
  //   //   // MAC address is not supported on iOS or other platforms
  //   //   return "";
  //   // }
  // }

  Timer? _timer;

  @override
  void initState() {
    var cubit = driverCubit;
    // if (GetPlatform.isAndroid) {
    //   getDeviceId();
    // }

    cubit.location.isBackgroundModeEnabled().then((value) {
      if (value == false) {
        cubit.location.enableBackgroundMode(enable: true);
      }
      HelpooInAppNotification.showMessage(
          message: 'تحدبث الموقع ${value ? '' : 'غير'} مفعل في الخلفية',
          duration: Duration(seconds: 5));
    });

    cubit.getRequests();
    cubit.getLocation();

    if(_timer == null) {
      _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) async {
        if (CurrentUser.isLoggedIn) {
          if(CurrentUser.isDriver) {
            debugPrint("=====>> Timer ");
            if(cubit.currentAddressLatLng != null) {
              cubit.updateLocation();
            }
          }
        } else {
          timer.cancel();
        }
      });
    }

    getAppVersion();

    // Timer.periodic(Duration(seconds: 5), (Timer timer) async {
    //   if (CurrentUser.isLoggedIn) {
    //     debugPrint("=====>> Timer ");
    //     cubit.getRequests();
    //     // cubit.getLocation();
    //   } else {
    //     timer.cancel();
    //   }
    // });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<DriverCubit>(context);
    if (CurrentUser.blocked == true) {
      return ErrorPage("You are blocked");
    }
    return RefreshIndicator(
      onRefresh: () async {
        cubit.getRequests();

        cubit.location.isBackgroundModeEnabled().then((value) {
          if (value == false) {
            cubit.location.enableBackgroundMode(enable: true);
          }
          HelpooInAppNotification.showMessage(
              message: 'تحدبث الموقع ${value ? '' : 'غير'} مفعل في الخلفية',
              duration: Duration(seconds: 5));
        });

        cubit.getLocation();
      },
      child: BlocBuilder<DriverCubit, DriverState>(
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              backgroundColor: appWhite,
              appBar: AppBar(
                backgroundColor: appWhite,
                actionsIconTheme: const IconThemeData(
                  color: appBlack,
                ),
                elevation: 1,
                leading: Container(
                  height: 48,
                  width: Get.width * .4,
                  child: Center(
                      child: Text(
                    "V " + appVersion,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: appBlack,
                    ),
                  )),
                ),
                title: Center(
                  child: Text(
                    "  " + CurrentUser.name.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: appBlack,
                    ),
                  ),
                ),
                actions: [
                  Container(
                    height: 48,
                    width: 48,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          cubit.getRequests();
                        },
                        child: const Icon(
                          Icons.refresh,
                          color: appBlack,
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(8),
                          backgroundColor: appOffWhite,
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 48,
                    width: 48,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () => Get.to(() => setting()),
                        child: const Icon(
                          MdiIcons.cogOutline,
                          color: appBlack,
                        ),
                        style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(8),
                            backgroundColor: appOffWhite,
                            elevation: 0),
                      ),
                    ),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  bottom: 8.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(),
                    ),
                    // ToggleStatus(),
                    GetDriverRequests(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
