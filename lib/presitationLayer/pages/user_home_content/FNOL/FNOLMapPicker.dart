// ignore_for_file: must_be_immutable, invalid_use_of_visible_for_testing_member
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:helpoo/main.dart';
import 'package:helpoo/presitationLayer/pages/homeScreen.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:helpoo/service_request/core/util/utils.dart';
import 'package:map_picker/map_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../../../../dataLayer/constants/variables.dart';
import '../../../widgets/FNOL/inspectionAddressSearch.dart';
import '../../../widgets/FNOL/locationName.dart';
import '../../../widgets/willPopScopeWidget.dart';
import '../../shared/waitingPage.dart';
import '../FNOL/FNOLStepDone.dart';

class fnolMapPicker extends StatefulWidget {
  String fnolType;

  fnolMapPicker({
    Key? key,
    required this.fnolType,
  }) : super(key: key);

  @override
  State<fnolMapPicker> createState() => fnolMapPickerState();
}

class fnolMapPickerState extends State<fnolMapPicker> {
  MapPickerController mapPickerController = MapPickerController();
  // var textController = TextEditingController();
  // var textController2 = TextEditingController(text: 'ssss');

  TextEditingController currnertLocCntl = TextEditingController();
  List<Placemark> placemarks = [];
  var fnolBloc = BlocProvider.of<FnolBloc>(navigatorKey.currentContext!);

  @override
  void initState() {
    super.initState();
    // fnolBloc.getLocation("");
    if(widget.fnolType == "supplement") {
      fnolBloc.fnol.supplementLocation = '';
    } else if(widget.fnolType == "resurvey") {
      fnolBloc.fnol.resurveyLocation = '';
    } else if(widget.fnolType == "aRepair") {
      fnolBloc.fnol.aRepairLocation = '';
    } else if(widget.fnolType == "rightSave") {
      fnolBloc.fnol.rightSaveLocation = '';
    } else {
      fnolBloc.fnol.bRepairLocation = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FnolBloc, FnolState>(
      listener: (context, state) {
        // if (state is GetCurrentPosition) {
        //   if (!state.isFirstTime) {
        //     fnolBloc.mapController!.animateCamera(
        //       fnolBloc.cameraUpdate ??
        //           CameraUpdate.newCameraPosition(
        //             fnolBloc.cameraPosition ??
        //                 CameraPosition(
        //                   target: LatLng(0, 0),
        //                 ),
        //           ),
        //     );
        //   }
        // }
      },
      builder: (context, state) {
        if (state is GetCurrentPosition) {
          debugPrint("GetCurrentPosition Success");
          return willPopScopeWidget(
            onWillPop: () async {
              setState(() {
                currnertLocCntl.text = "";
              });

              Get.back();
              return true;
            },
            child: Scaffold(
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
                        setState(() {
                          currnertLocCntl.text = "";
                        });

                        Get.to(
                          () => homeScreen(
                            index: 0,
                          ),
                        );
                      },
                      icon: Icon(
                        Get.locale!.languageCode != "en"
                            ? MdiIcons.arrowRightThin
                            : MdiIcons.arrowLeftThin,
                        color: appWhite,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  'Inspection Location'.tr,
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
              body: Stack(
                alignment: Alignment.topCenter,
                children: [
                  MapPicker(
                    // pass icon widget
                    showDot: true,
                    iconWidget: Image.asset(
                      'assets/imgs/pin.png',
                      height: 60,
                    ),
                    //add map picker controller
                    mapPickerController: mapPickerController,
                    child: GoogleMap(
                      markers: fnolBloc.googleMapsModel.markers,
                      circles: fnolBloc.googleMapsModel.circle,
                      polylines: fnolBloc.googleMapsModel.polylines,
                      myLocationEnabled: true,
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      mapType: MapType.normal,
                      initialCameraPosition: fnolBloc.cameraPosition!,
                      onMapCreated: (GoogleMapController controller) async {
                        fnolBloc.mapController = controller;

                        fnolBloc.mapController!.animateCamera(
                          fnolBloc.cameraUpdate ??
                              CameraUpdate.newCameraPosition(
                                fnolBloc.cameraPosition ??
                                    CameraPosition(
                                      target: LatLng(
                                        30.1345425,
                                        31.3863626,
                                      ),
                                    ),
                              ),
                        );
                      },
                      onCameraMoveStarted: () async {
                        mapPickerController.mapMoving!();
                      },
                      onCameraMove: (cameraPosition) async {
                        fnolBloc.cameraPosition = cameraPosition;
                      },
                      onCameraIdle: () async {
                        if (fnolBloc.ableToUsePicker) {
                          GeocodingResponse geocodingResponse =
                              await GoogleMapsGeocoding(apiKey: MapApiKey)
                                  .searchByLocation(fnolBloc
                                      .cameraPosition!.target.toGoogleLocation);
                          GeocodingResult geocodingResult =
                              geocodingResponse.results.first;
                          setState(() {
                            fnolBloc.address =
                                geocodingResult.formattedAddress ?? '';
                            fnolBloc.addressLatLng =
                                fnolBloc.cameraPosition!.target;
                          });

                          // placemarks = await placemarkFromCoordinates(
                          //   fnolBloc.cameraPosition!.target.latitude,
                          //   fnolBloc.cameraPosition!.target.longitude,
                          // );
                          // setState(() {
                          //   fnolBloc.address =
                          //       '${placemarks.first.name}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}';
                          //   fnolBloc.addressLatLng =
                          //       fnolBloc.cameraPosition!.target;
                          // });
                        }
                        mapPickerController.mapFinishedMoving!();
                      },
                    ),
                  ),
                  Positioned(
                      top: 20,
                      left: 5,
                      right: 5,
                      child: inspectionAddressSearch(
                        currentLocCntl: currnertLocCntl,
                        fnolType: widget.fnolType,
                      )),
                  Positioned(
                      top: 80,
                      left: 5,
                      right: 5,
                      child: locationName(
                        fnolType: widget.fnolType,
                      )),
                  Positioned(
                    bottom: 24,
                    left: 24,
                    right: 24,
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          FloatingActionButton(
                            mini: true,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: const Icon(
                              Icons.my_location,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              fnolBloc.getLocation("", isFirstTime: false);
                              // setState(() {});
                            },
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: TextButton(
                              child: Text(
                                'Submit'.tr,
                                style: GoogleFonts.tajawal().copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 19,
                                ),
                              ),
                              onPressed: () async {
                                Utils.closeKeyboard(context);
                                debugPrint(
                                    "fnolBloc.address: ${widget.fnolType}");
                                if (fnolBloc.address == "") {
                                  HelpooInAppNotification.showErrorMessage(
                                      message: "Please Choose Location".tr);

                                  return;
                                }
                                if (widget.fnolType == "supplement" &&
                                    fnolBloc.fnol.supplementLocation == null) {
                                  HelpooInAppNotification.showErrorMessage(
                                      message: "Please Enter Name".tr);

                                  return;
                                }

                                if (widget.fnolType == "supplement" &&
                                    fnolBloc.fnol.supplementLocation!.isEmpty) {
                                  debugPrint(
                                      "-------- supplementLocation name ----------");

                                  HelpooInAppNotification.showErrorMessage(
                                      message: "Please Enter Name".tr);

                                  return;
                                }

                                //
                                if (widget.fnolType == "resurvey" &&
                                    fnolBloc.fnol.resurveyLocation == null) {
                                  HelpooInAppNotification.showErrorMessage(
                                      message: "Please Enter Name".tr);

                                  return;
                                }

                                if (widget.fnolType == "resurvey" &&
                                    fnolBloc.fnol.resurveyLocation!.isEmpty) {
                                  HelpooInAppNotification.showErrorMessage(
                                      message: "Please Enter Name".tr);

                                  return;
                                }
                                //

                                //
                                if (widget.fnolType == "aRepair" &&
                                    fnolBloc.fnol.aRepairLocation == null) {
                                  HelpooInAppNotification.showErrorMessage(
                                      message: "Please Enter Name".tr);

                                  return;
                                }

                                if (widget.fnolType == "aRepair" &&
                                    fnolBloc.fnol.aRepairLocation!.isEmpty) {
                                  HelpooInAppNotification.showErrorMessage(
                                      message: "Please Enter Name".tr);

                                  return;
                                }
                                //

                                //
                                if (widget.fnolType == "rightSave" &&
                                    fnolBloc.fnol.rightSaveLocation == null) {
                                  HelpooInAppNotification.showErrorMessage(
                                      message: "Please Enter Name".tr);

                                  return;
                                }

                                if (widget.fnolType == "rightSave" &&
                                    fnolBloc.fnol.rightSaveLocation!.isEmpty) {
                                  HelpooInAppNotification.showErrorMessage(
                                      message: "Please Enter Name".tr);

                                  return;
                                }

                                if (widget.fnolType == "repair_before" &&
                                    fnolBloc.fnol.bRepairLocation == null) {
                                  HelpooInAppNotification.showErrorMessage(
                                      message: "Please Enter Name".tr);

                                  return;
                                }

                                if (widget.fnolType == "repair_before" &&
                                    fnolBloc.fnol.bRepairLocation!.isEmpty) {
                                  HelpooInAppNotification.showErrorMessage(
                                      message: "Please Enter Name".tr);

                                  return;
                                }
                                //

                                if (widget.fnolType == "supplement") {
                                  fnolBloc.requestSupplement();
                                } else if (widget.fnolType == "resurvey") {
                                  fnolBloc.requestresurvey();
                                } else if (widget.fnolType == "aRepair") {
                                  fnolBloc.requestARepair();
                                } else if (widget.fnolType == "rightSave") {
                                  fnolBloc.requestRightSave();
                                } else {
                                  fnolBloc.requestBeforeRepair();
                                }

                                fnolBloc.emit(locationAdded());

                                Get.to(() => fnolStepDone(fnolBloc.fnol,from: widget.fnolType,));
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(mainColor),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return waitingWidget();
        }
      },
    );
  }
}
