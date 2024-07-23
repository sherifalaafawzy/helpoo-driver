// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/dataLayer/models/package.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../widgets/choosePublicPackage.dart';
import '../../widgets/willPopScopeWidget.dart';
import '../homeScreen.dart';
import '../../../dataLayer/bloc/app/app_bloc.dart';
import '../../../dataLayer/constants/variables.dart';
import '../../../dataLayer/models/currentUser.dart';
import '../../../dataLayer/models/manufactur.dart';
import '../../../dataLayer/models/vehicle.dart';
import '../../widgets/colorInput.dart';
import '../../widgets/modelInput.dart';
import '../../widgets/nameInput.dart';
import '../../widgets/phoneInput.dart';
import '../../widgets/plateNumberInput.dart';
import '../../widgets/round_button.dart';
import '../../widgets/vehicleVinInput.dart';
import '../../widgets/yearInput.dart';
import '../user_home_content/service_request/selectVehicle.dart';

class editVehicle extends StatefulWidget {
  final Vehicle vehicle;
  bool packageCar;
  final bool serviceCar;

  editVehicle(
      {super.key,
      required this.vehicle,
      required this.packageCar,
      this.serviceCar = false});

  @override
  State<editVehicle> createState() => _editVehicleState();
}

class _editVehicleState extends State<editVehicle> {
  var formKey = GlobalKey<FormState>();
  bool working = true;
  List<Manufacture> manufactureList = [];
  bool clickable = true;

  getAllManufacture() async {
    manufactureList =
        await BlocProvider.of<AppBloc>(context).getAllManufacture();
    Vehicle.modelList = await BlocProvider.of<AppBloc>(context)
        .getAllModels(Vehicle.updatedCar.manufacture!);
    setState(() {
      working = false;
    });
  }

  bool licensetaked = false;
  bool enableManufacture = false;
  bool enableModel = false;
  bool enablePlate = false;
  bool enableColor = false;
  bool enableYear = false;

  @override
  void initState() {
    super.initState();
    if (widget.vehicle.insuranceCompany != null) {
      if (widget.vehicle.plateNo == null) {
        enablePlate = true;
      }
      if (widget.vehicle.color == null) {
        enableColor = true;
      }
      if (widget.vehicle.year == null) {
        enableYear = true;
      }
      if (widget.vehicle.manufacture == null) {
        enableManufacture = true;
        enableModel = true;
      }
      if (widget.vehicle.model == null) {
        enableModel = true;
      }
    } else {
      enableManufacture = true;
      enableModel = true;
      enablePlate = true;
      enableColor = true;
      enableYear = true;
    }

    Vehicle.clearVehicle();
    setState(() {
      Vehicle.updatedCar = widget.vehicle;
    });
    getAllManufacture();
    CurrentUser.selectedPackage = Package();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<AppBloc>(context);
    return willPopScopeWidget(
      onWillPop: () async {
        Get.back();
        return true;
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
                    Get.back();
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
              widget.packageCar ? "Add Package".tr : "Edit vehicle data".tr,
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
                    CurrentUser.isCorporate
                        ? Column(
                            children: [
                              nameInput(),
                              phoneInput(),
                            ],
                          )
                        : Container(),
                    SizedBox(height: 18),
                    SizedBox(
                      width: Get.width,
                      child: Row(
                        children: [
                          SizedBox(width: 20.0),
                          Expanded(
                              child: Theme(
                            data: ThemeData(canvasColor: Colors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: 'vehicle type'.tr,
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
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      border: Border.all(
                                        color: mainColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 6, vertical: 0),
                                            border: InputBorder.none,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                          hint: Text(
                                            widget.vehicle.manufacture!.name,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          icon: const Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.black45,
                                          ),
                                          validator: (value) {
                                            if (value == null) {
                                              return 'please select type'.tr;
                                            }
                                            return null;
                                          },
                                          items: manufactureList
                                              .map((item) =>
                                                  DropdownMenuItem<Manufacture>(
                                                    value: item,
                                                    child: Text(
                                                      item.name,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                          onChanged: enableManufacture
                                              ? (Manufacture? v) async {
                                                  setState(() {
                                                    Vehicle.updatedCar
                                                        .manufacture = v;
                                                    Vehicle.updatedCar.model =
                                                        null;
                                                    Vehicle.modelList = [];
                                                    Vehicle.selectedModel =
                                                        null;
                                                  });
                                                  Vehicle.modelList =
                                                      await BlocProvider.of<
                                                              AppBloc>(context)
                                                          .getAllModels(Vehicle
                                                              .updatedCar
                                                              .manufacture!);
                                                  setState(() {
                                                    // Vehicle.updatedCar.model = null;
                                                    Vehicle.modelList =
                                                        Vehicle.modelList;
                                                  });
                                                }
                                              : null),
                                    ))
                              ],
                            ),
                          )),
                          SizedBox(width: 35.0),
                          Expanded(
                              child: modelInput(
                                  enable: enableModel,
                                  value: widget.vehicle.model,
                                  callbackfun: (v) {
                                    setState(() {
                                      Vehicle.updatedCar.model = v;
                                    });
                                  })),
                          SizedBox(width: 20.0),
                        ],
                      ),
                    ),
                    SizedBox(height: 18),
                    SizedBox(
                      width: Get.width,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 20.0),
                            Expanded(
                                child: yearInput(
                                    enable: enableYear,
                                    value: widget.vehicle.year!,
                                    callbackfun: (v) {
                                      setState(() {
                                        Vehicle.updatedCar.year = v;
                                      });
                                    })),
                            SizedBox(width: 35.0),
                            Expanded(
                                child: colorInput(
                                    enable: enableColor,
                                    value: widget.vehicle.color!,
                                    callbackfun: (v) {
                                      setState(() {
                                        Vehicle.updatedCar.color = v;
                                      });
                                    })),
                            SizedBox(width: 20.0),
                          ]),
                    ),
                    SizedBox(height: 18),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: plateNumberInput(
                          packageCar: widget.packageCar,
                          vehicle: widget.vehicle,
                          enable: enablePlate),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: vehicleVinInput(
                        vehicle: widget.vehicle,
                        packageCar: false,
                      ),
                    ),
                    SizedBox(height: 18),
                    choosePublicPackage(
                      packageCar: widget.packageCar,
                      vehicle: widget.vehicle,
                    ),
                    SizedBox(height: 18),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: RoundButton(
                        onPressed: () async {
                          setState(() {
                            clickable = false;
                          });
                          if (widget.packageCar) {
                            if (CurrentUser.selectedPackage.id != "0") {
                              bool carSubscribed = await bloc.subscribeCar(
                                  CurrentUser.selectedPackage.id,
                                  widget.vehicle.id.toString());
                              if (carSubscribed) {
                                Package.packages = await bloc.getAllPackages();
                                CurrentUser.packages =
                                    await bloc.getActivePackages();
                                await bloc.getMyCars();
                                Get.offAll(() => homeScreen(index: 1));
                              } else {
                                setState(() {
                                  clickable = true;
                                });
                              }
                            } else {
                              HelpooInAppNotification.showErrorMessage(
                                  message: "Please Choose Package".tr);

                              setState(() {
                                clickable = true;
                              });
                            }
                          } else {
                            if (widget.vehicle.active == false) {
                              widget.vehicle.active = true;
                            }
                            bool success =
                                await Vehicle.updateCar(widget.vehicle.active);
                            await bloc.getMyCars();
                            if (success) {
                              if (widget.serviceCar) {
                                Get.to(() => selectVehicle(
                                    FNOL: false, packageCar: false));
                              } else {
                                Get.offAll(() => homeScreen(index: 1));
                              }
                            } else {
                              setState(() {
                                clickable = true;
                              });
                            }
                          }
                        },
                        padding: false,
                        text: clickable ? "confirm".tr : "Loading......".tr,
                        color: mainColor,
                      ),
                    ),
                    SizedBox(height: 18),
                  ],
                )),
          )),
    );
  }

  List<String> imgs = [];
  List<String> img = [];
  final ImagePicker picker = ImagePicker();

  Future<List<String>> selectImages() async {
    imgs.clear();
    img.clear();
    for (int i = 0; i < 2; i++) {
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        Uint8List imagebytes = await pickedFile.readAsBytes();
        String _base64String = base64.encode(imagebytes);
        imgs.add(_base64String);
        if (i == 0) {
          Vehicle.updatedCar.frontLicense = imgs[0];
        }
        if (i == 1 && imgs.length > 2) {
          Vehicle.updatedCar.backLicense = imgs[1];
        }
        img.add(pickedFile.path);
        setState(() {
          licensetaked = true;
        });
      } else {
        debugPrint('No Image Selected');

        return [];
      }
    }
    return imgs;
  }
}
