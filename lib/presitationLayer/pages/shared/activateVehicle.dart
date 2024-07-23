import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import '../../../dataLayer/bloc/app/app_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../widgets/willPopScopeWidget.dart';
import '../homeScreen.dart';
import '../../../dataLayer/constants/variables.dart';
import '../../../dataLayer/models/currentUser.dart';
import '../../../dataLayer/models/manufactur.dart';
import '../../../dataLayer/models/vehicle.dart';
import '../../widgets/colorInput.dart';
import '../../widgets/modelInput.dart';
import '../../widgets/plateNumberInput.dart';
import '../../widgets/round_button.dart';
import '../../widgets/vehicleVinInput.dart';
import '../../widgets/yearInput.dart';
import 'dart:io' as io;

class activateVehicle extends StatefulWidget {
  final Vehicle vehicle;

  activateVehicle({super.key, required this.vehicle});

  @override
  State<activateVehicle> createState() => activateVehicleState();
}

class activateVehicleState extends State<activateVehicle> {
  var formKey = GlobalKey<FormState>();
  bool working = false;
  bool loaded = true;
  List<Manufacture> manufactureList = [];

  getAllManufacture() async {
    var bloc = BlocProvider.of<AppBloc>(context);
    manufactureList = await bloc.getAllManufacture();
    if (widget.vehicle.manufacture != null) {
      Vehicle.modelList = await bloc.getAllModels(widget.vehicle.manufacture!);
    }
    setState(() {
      working = false;
      loaded = false;
    });
  }

  bool licensetaked1 = false;
  bool licensetaked2 = false;
  bool enableManufacture = false;
  bool enableModel = false;
  bool enablePlate = false;
  bool enableColor = false;
  bool enableYear = false;

  @override
  void initState() {
    super.initState();
    if (widget.vehicle.plateNo == null) {
      enablePlate = true;
    }
    if (widget.vehicle.color == null || (!colorsList.contains(widget.vehicle.color!))) {
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
    Vehicle.clearVehicle();
    setState(() {
      Vehicle.updatedCar = widget.vehicle;
    });
    getAllManufacture();
  }

  @override
  void dispose() {
    Vehicle.updatedCar = Vehicle();
    super.dispose();
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
            iconTheme: const IconThemeData(color: appWhite),
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
                    CurrentUser.isArabic ? MdiIcons.arrowRightThin : MdiIcons.arrowLeftThin,
                    color: appWhite,
                  ),
                ),
              ),
            ),
            title: Text(
              "Vehicle Confirmation Data".tr,
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
          body: loaded
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
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
                                                  fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18),
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
                                                contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                                                border: InputBorder.none,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(12),
                                              ),
                                              hint: Text(
                                                widget.vehicle.manufacture == null
                                                    ? ""
                                                    : widget.vehicle.manufacture!.name,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              icon: Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.black45,
                                              ),
                                              // iconSize: 30,
                                              // buttonHeight: 60,
                                              // buttonPadding: EdgeInsets.only(
                                              //     left: 20, right: 10),
                                              // dropdownDecoration: BoxDecoration(
                                              //   borderRadius:
                                              //       BorderRadius.circular(15),
                                              // ),
                                              items: manufactureList
                                                  .map((item) => DropdownMenuItem<Manufacture>(
                                                        value: item,
                                                        child: Text(
                                                          item.name,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ))
                                                  .toList(),
                                              onChanged: enableManufacture
                                                  ? (Manufacture? v) async {
                                                      setState(() {
                                                        Vehicle.updatedCar.manufacture = v;
                                                        Vehicle.modelList = [];
                                                        Vehicle.selectedModel = null;
                                                      });
                                                      Vehicle.modelList =
                                                          await bloc.getAllModels(Vehicle.updatedCar.manufacture!);
                                                      setState(() {
                                                        Vehicle.selectedModel = null;
                                                        Vehicle.modelList = Vehicle.modelList;
                                                      });
                                                    }
                                                  : null,
                                            ),
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
                            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              SizedBox(width: 20.0),
                              Expanded(
                                  child: yearInput(
                                      enable: enableYear,
                                      value: widget.vehicle.year,
                                      callbackfun: (v) {
                                        setState(() {
                                          Vehicle.updatedCar.year = v;
                                        });
                                      })),
                              SizedBox(width: 35.0),
                              Expanded(
                                child: colorInput(
                                  enable: enableColor,
                                  value: colorsList.contains(widget.vehicle.color!) ? widget.vehicle.color : null,
                                  callbackfun: (v) {
                                    setState(
                                      () {
                                        Vehicle.updatedCar.color = v;
                                      },
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 20),
                            ]),
                          ),
                          SizedBox(height: 18),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: plateNumberInput(vehicle: widget.vehicle, packageCar: true, enable: enablePlate),
                          ),
                          SizedBox(height: 16),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: vehicleVinInput(
                              vehicle: widget.vehicle,
                              packageCar: true,
                            ),
                          ),
                          SizedBox(height: 18),
                          widget.vehicle.active == false && widget.vehicle.plateNo == null
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: SizedBox(
                                        height: licensetaked1 ? Get.height * .24 : Get.height * .15,
                                        child: Column(
                                          children: [
                                            Text(
                                              'Please capture the front side of the vehicle licence'.tr,
                                              style: GoogleFonts.tajawal(
                                                textStyle: const TextStyle(
                                                  color: mainColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: DottedBorder(
                                                strokeWidth: 1,
                                                radius: Radius.circular(1),
                                                child: Center(
                                                  child: licensetaked1
                                                      ? Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            SizedBox(
                                                              width: Get.width * .7,
                                                              height: Get.height * .17,
                                                              child: Image.file(io.File(img.first), fit: BoxFit.cover),
                                                            )
                                                          ],
                                                        )
                                                      : Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                              IconButton(
                                                                onPressed: () async {
                                                                  selectImages();
                                                                },
                                                                icon: Icon(Icons.camera_alt_rounded),
                                                                color: mainColor,
                                                              ),
                                                              SizedBox(
                                                                width: Get.width * 0.3,
                                                                child: Image.asset('assets/report/id_img3.png'),
                                                              ),
                                                            ]),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: SizedBox(
                                        height: licensetaked2 ? Get.height * .24 : Get.height * .15,
                                        child: Column(
                                          children: [
                                            Text(
                                              'Please capture the back side of the vehicle licence'.tr,
                                              style: GoogleFonts.tajawal(
                                                textStyle: const TextStyle(
                                                  color: mainColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: DottedBorder(
                                                strokeWidth: 1,
                                                radius: Radius.circular(1),
                                                child: Center(
                                                  child: licensetaked2
                                                      ? Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            SizedBox(
                                                              width: Get.width * .7,
                                                              height: Get.height * .17,
                                                              child: Image.file(io.File(img.last), fit: BoxFit.cover),
                                                            )
                                                          ],
                                                        )
                                                      : Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                              IconButton(
                                                                onPressed: () async {
                                                                  selectImages();
                                                                },
                                                                icon: Icon(Icons.camera_alt_rounded),
                                                                color: mainColor,
                                                              ),
                                                              SizedBox(
                                                                width: Get.width * 0.3,
                                                                child: Image.asset('assets/report/id_img4.png'),
                                                              ),
                                                            ]),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : Container(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: RoundButton(
                              onPressed: () async {
                                setState(() {
                                  working = true;
                                });
                                if (widget.vehicle.plateNo == null) {
                                  if (Vehicle.plateNumber == "---") {
                                    HelpooInAppNotification.showMessage(message: "Plate Number is Required");
                                    // Get.snackbar("Helpoo".tr,
                                    // "Plate Number is Required");
                                  } else if (licensetaked1 == false) {
                                    HelpooInAppNotification.showMessage(message: "Front license Side is Required".tr);
                                    // Get.snackbar(
                                    // "Helpoo".tr, "Front side is Required");
                                  } else if (licensetaked2 == false) {
                                    HelpooInAppNotification.showMessage(message: "Back license Side is Required".tr);
                                    // Get.snackbar(
                                    // "Helpoo".tr, "Back side is Required");
                                  } else {
                                    debugPrint('1111111111');
                                    widget.vehicle.active = true;
                                    await Vehicle.activateCar(widget.vehicle.active);
                                    await bloc.getMyCars();
                                    Get.to(() => homeScreen(index: 1));
                                  }
                                } else {
                                  debugPrint('22222222');
                                  widget.vehicle.active = true;

                                  if (Vehicle.updatedCar.model == null ||
                                      Vehicle.updatedCar.color == null ||
                                      Vehicle.updatedCar.year == null ||
                                      Vehicle.updatedCar.chassisNo == null) {
                                    HelpooInAppNotification.showMessage(message: "please complete missing data".tr);
                                    // Get.snackbar('Helpoo'.tr,
                                    //     'please complete missing data'.tr);
                                  } else {
                                    debugPrint('33333333');
                                    await Vehicle.activateCar(widget.vehicle.active);
                                    await bloc.getMyCars();
                                    Get.to(() => homeScreen(index: 1));
                                  }
                                }
                                setState(() {
                                  working = false;
                                });
                              },
                              padding: false,
                              text: !working ? "confirm".tr : "Loading......".tr,
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
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      Uint8List imagebytes = await pickedFile.readAsBytes();
      String _base64String = base64.encode(imagebytes);
      imgs.add(_base64String);
      if (imgs.length == 1) {
        Vehicle.updatedCar.frontLicense = imgs[0];
        setState(() {
          licensetaked1 = true;
        });
      }
      if (imgs.length == 2) {
        Vehicle.updatedCar.backLicense = imgs[1];
        setState(() {
          licensetaked2 = true;
        });
      }
      img.add(pickedFile.path);
      if (img.length == 2) {}
    } else {
      debugPrint('No Image Selected');

      return [];
    }

    return imgs;
  }
}
