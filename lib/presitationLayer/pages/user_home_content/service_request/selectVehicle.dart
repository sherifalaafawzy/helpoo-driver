// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/main.dart';
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';
import 'package:helpoo/service_request/core/util/cubit/state.dart';
import 'package:helpoo/service_request/core/util/extensions/build_context_extension.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:helpoo/service_request/core/util/routes.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../widgets/willPopScopeWidget.dart';
import '../../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../../../../dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';
import '../../../../dataLayer/constants/variables.dart';
import '../../../../dataLayer/models/currentUser.dart';
import '../../../../dataLayer/models/vehicle.dart';
import '../../../widgets/addFirstCar.dart';
import '../../../widgets/carCard.dart';
import '../../../widgets/round_button.dart';
import '../../shared/editVehicle.dart';
import '../../shared/mainPackageInsurance.dart';
import '../FNOL/chooseAccidentType.dart';

class selectVehicle extends StatefulWidget {
  final bool FNOL;
  final bool packageCar;

  const selectVehicle({
    Key? key,
    required this.FNOL,
    required this.packageCar,
  }) : super(key: key);

  @override
  State<selectVehicle> createState() => _selectVehicleState();
}

class _selectVehicleState extends State<selectVehicle> {
  List<Vehicle> vehicles = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      BlocProvider.of<FnolBloc>(navigatorKey.currentContext!).fnol.selectedCar =
          null;
    });
    setState(() {
      vehicles = CurrentUser.cars
          .where((element) =>
              element.policyEnd != "" || element.carPackages!.length != 0)
          .toList();
      Vehicle.addVehicle = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ServiceRequestBloc>(context);
    var bloc = BlocProvider.of<FnolBloc>(context);

    setState(() {
      if (cubit.request.selectedCar == null && CurrentUser.cars.isNotEmpty) {
        cubit.request.selectedCar = CurrentUser.cars[0];
        sRBloc.selectedCarId = CurrentUser.cars[0].id ?? 0;
        sRBloc.selectedCar = CurrentUser.cars[0] ?? Vehicle();
      }
      if (bloc.fnol.selectedCar == null && vehicles.isNotEmpty) {
        bloc.fnol.selectedCar = vehicles[0];
      }
      cubit.request.clientName = CurrentUser.name;
      cubit.request.clientPhone = CurrentUser.phoneNumber;
    });
    return BlocListener<ServiceRequestBloc, ServiceRequestState>(
      listener: (context, state) {
        if (state is changeCarState || state is changeCarTwiceState) {
          setState(() {});
        }
      },
      child: willPopScopeWidget(
        onWillPop: () async {
          if (Vehicle.addVehicle) {
            setState(() {
              Vehicle.addVehicle = false;
            });
            return false;
          } else {
            debugPrint('back pressed');
            context.pop;
            return true;
          }

          // Get.to(() => homeScreen(index: 0));

          // context.pop;

          // return true;
        },
        child: Scaffold(
          backgroundColor: appWhite,
          appBar: AppBar(
            iconTheme: IconThemeData(color: appWhite),
            backgroundColor: mainColor,
            centerTitle: true,
            leading: Container(
              height: 48,
              width: 48,
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: IconButton(
                  onPressed: () {
                    // setState(() {
                    //   Vehicle.addVehicle = false;
                    // });
                    // debugPrint('back pressed');
                    // context.pop;

                    // Get.to(() => homeScreen(index: 0));
                    if (Vehicle.addVehicle) {
                      setState(() {
                        Vehicle.addVehicle = false;
                      });
                    } else {
                      debugPrint('back pressed');
                      context.pop;
                    }
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
              widget.FNOL
                  ? "Choose Damaged Vehicle".tr
                  : CurrentUser.isCorporate || widget.packageCar
                      ? "Add Vehicle".tr
                      : "Select vehicle".tr,
              style: GoogleFonts.tajawal(
                textStyle: TextStyle(
                  color: appWhite,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          body: Container(
            color: Colors.transparent,
            child: Vehicle.addVehicle ||
                    CurrentUser.isCorporate ||
                    widget.packageCar
                ? addFirstCar(
                    vehicleRegister: false,
                    packageCar: widget.packageCar,
                    car: null,
                    serviceCar: true,
                  )
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 51.0,
                                  vertical: 14,
                                ),
                                child: Image.asset(
                                  widget.FNOL
                                      ? 'assets/imgs/reports.png'
                                      : 'assets/imgs/wench12.png',
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        CurrentUser.isCorporate
                                            ? SizedBox()
                                            : Text(
                                                'Select vehicle'.tr,
                                                style: GoogleFonts.tajawal(
                                                  textStyle: TextStyle(
                                                    color: mainColor,
                                                    fontWeight: FontWeight.w800,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 20.0,
                                                  ),
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                      ],
                                    ),
                                  ]),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                child: widget.FNOL && vehicles.isNotEmpty
                                    ? Column(
                                        children: [
                                          ...vehicles
                                              .where((element) =>
                                                  element.id != null &&
                                                  element.id! >= 0)
                                              .map<Widget>(
                                                (Vehicle c) => InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  onTap: () {
                                                    setState(() {
                                                      bloc.fnol.selectedCar = c;
                                                    });
                                                  },
                                                  child: carCard(
                                                    c,
                                                    () {
                                                      Get.to(
                                                        () => editVehicle(
                                                          vehicle: c,
                                                          packageCar: false,
                                                        ),
                                                      );
                                                    },
                                                    (bloc.fnol.selectedCar ==
                                                        c),
                                                  ),
                                                ),
                                              ),
                                        ],
                                      )
                                    : widget.FNOL && vehicles.isEmpty
                                        ? Text(
                                            "You don't have registered insured vehicle"
                                                .tr,
                                            style: GoogleFonts.tajawal(
                                              textStyle: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          )
                                        : Column(
                                            children: [
                                              ...CurrentUser.cars
                                                  .where((element) =>
                                                      element.id != null &&
                                                      element.id! >= 0)
                                                  .map<Widget>(
                                                    (Vehicle c) => InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      onTap: () {
                                                        setState(() {
                                                          sRBloc.selectedCarId =
                                                              c.id!;
                                                          cubit.request
                                                              .selectedCar = c;
                                                          sRBloc.selectedCar =
                                                              c;
                                                        });
                                                      },
                                                      child: carCard(
                                                        c,
                                                        () {
                                                          Get.to(
                                                            () => editVehicle(
                                                                vehicle: c,
                                                                packageCar:
                                                                    false,
                                                                serviceCar:
                                                                    true),
                                                          );
                                                        },
                                                        (cubit.request
                                                                .selectedCar ==
                                                            c),
                                                      ),
                                                    ),
                                                  ),
                                              Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        Vehicle.addVehicle =
                                                            true;
                                                      });
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          MdiIcons
                                                              .plusCircleOutline,
                                                          color: mainColor,
                                                        ),
                                                        Text(
                                                          CurrentUser
                                                                  .isCorporate
                                                              ? 'add vehicle corporate'
                                                                  .tr
                                                              : 'Add Vehicle'
                                                                  .tr,
                                                          style: GoogleFonts
                                                              .tajawal(
                                                            textStyle:
                                                                TextStyle(
                                                              color: mainColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 20.0,
                                                            ),
                                                          ),
                                                          textAlign:
                                                              TextAlign.start,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 107,
                                                    height: 2,
                                                    decoration: BoxDecoration(
                                                      color: mainColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: RoundButton(
                              onPressed: () {
                                if (widget.FNOL) {
                                  if (vehicles.isNotEmpty) {
                                    if (bloc.fnol.selectedCar!.policyEnd ==
                                            "" &&
                                        bloc.fnol.selectedCar!.carPackages!
                                                .length !=
                                            0) {
                                      Get.to(() => mainPackageInsurance());
                                    } else {
                                      Get.to(() => chooseAccidentType());
                                    }
                                  } else {
                                    HelpooInAppNotification.showErrorMessage(
                                        message:
                                            "You don't have registered insured vehicle"
                                                .tr);
                                  }
                                } else {
                                  if (CurrentUser.cars.isNotEmpty) {
                                    if (sRBloc.currentPosition == null) {
                                      sRBloc.startLocationServiceOnce();
                                    } else {
                                      sRBloc.fireLocationAlreadyHere();
                                    }

                                    // Get.to(() => serviceRMapPicker());

                                    // context.pushNamed = Routes.serviceRequestMap;
                                  } else {
                                    HelpooInAppNotification.showMessage(
                                        message: "Please add vehicle first".tr);
                                    // Get.snackbar(
                                    //     "Helpoo", "Please add vehicle first");
                                  }
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
          ),
        ),
      ),
    );
  }
}
