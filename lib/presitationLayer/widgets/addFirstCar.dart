import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../dataLayer/bloc/app/app_bloc.dart';
import '../pages/register/registerVehicle.dart';
import '../pages/homeScreen.dart';
import 'modelInput.dart';
import '../../dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';
import '../../dataLayer/models/currentUser.dart';
import '../../dataLayer/models/vehicle.dart';
import '../pages/shared/waitingPage.dart';
import '../../dataLayer/constants/variables.dart';
import '../../dataLayer/models/manufactur.dart';
import '../pages/user_home_content/service_request/chooseService.dart';
import 'colorInput.dart';
import 'nameInput.dart';
import 'phoneInput.dart';
import 'plateNumberInput.dart';
import 'round_button.dart';
import 'vehicleVinInput.dart';
import 'yearInput.dart';

class addFirstCar extends StatefulWidget {
  final bool vehicleRegister;
  final bool packageCar;
  final Vehicle? car;
  final bool serviceCar;

  addFirstCar({this.car, Key? key, required this.vehicleRegister, required this.packageCar, this.serviceCar = false}) : super(key: key);

  @override
  State<addFirstCar> createState() => _AddFirstCarState();
}

class _AddFirstCarState extends State<addFirstCar> {
  List img = [];
  bool licensetaked = false;
  var formKey = GlobalKey<FormState>();
  bool working = true;
  List<Manufacture> manufactureList = [];

  getAllManufacture() async {
    manufactureList = await BlocProvider.of<AppBloc>(context).getAllManufacture();
    if (widget.car != null) {
      // Vehicle.selectedManufacturer = widget.car!.manufacture;
    }
    // for (var i = 0; i < manufactureList.length; i++) {
    //   if (widget.car!.manufacture == manufactureList[i]) {
    //     debugPrint('in list now');
    //   }
    // }
    setState(() {
      working = false;
    });
  }

  @override
  void initState() {
    super.initState();
    Vehicle.clearVehicle();
    getAllManufacture();
    Vehicle.updatedCar = Vehicle();
    Vehicle.modelList = [];
    Vehicle.returnedSelectedModel = false;
  }

  bool clickable = true;

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ServiceRequestBloc>(context);

    if (working == true) {
      return waitingWidget();
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: appWhite,
        // appBar: AppBar(
        //   iconTheme: IconThemeData(color: appWhite),
        //   backgroundColor: mainColor,
        //   centerTitle: true,
        //   leading: SizedBox(),
        //   title: Text(
        //     "my vehicles".tr,
        //     style: GoogleFonts.tajawal(
        //       textStyle: const TextStyle(
        //         color: appWhite,
        //         fontWeight: FontWeight.w400,
        //         fontStyle: FontStyle.normal,
        //         fontSize: 18.0,
        //       ),
        //     ),
        //   ),
        // ),
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
                                children: <TextSpan>[
                                  TextSpan(
                                    text: " *",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
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
                                    child: DropdownButtonFormField<Manufacture>(
                                  // underline: SizedBox(),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'please select type'.tr;
                                    }
                                    return null;
                                  },
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                  value: Vehicle.selectedManufacturer,
                                  isExpanded: true,
                                  items: List<DropdownMenuItem<Manufacture>>.from(
                                      manufactureList.map<DropdownMenuItem<Manufacture>>((e) => DropdownMenuItem(
                                            child: Text(
                                              overflow: TextOverflow.ellipsis,
                                              e.name,
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            value: e,
                                          ))),
                                  onChanged: (v) async {
                                    setState(() {
                                      Vehicle.selectedManufacturer = v;
                                      Vehicle.modelList = [];
                                      Vehicle.selectedModel = null;
                                      // Vehicle.returnedSelectedModel = true;
                                    });
                                    Vehicle.modelList = await BlocProvider.of<AppBloc>(context).getAllModels(Vehicle.selectedManufacturer!);
                                    setState(() {
                                      Vehicle.selectedModel = null;
                                      Vehicle.modelList = Vehicle.modelList;
                                    });
                                  },
                                )))
                          ],
                        ),
                      )),
                      SizedBox(width: 35.0),
                      Expanded(
                          child: modelInput(
                              enable: true,
                              value: Vehicle.selectedModel,
                              callbackfun: (v) {
                                setState(() {
                                  Vehicle.selectedModel = v;
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
                            enable: true,
                            value: Vehicle.selectedYear,
                            callbackfun: (v) {
                              setState(() {
                                Vehicle.selectedYear = v;
                              });
                            })),
                    SizedBox(width: 35.0),
                    Expanded(
                        child: colorInput(
                            enable: true,
                            value: Vehicle.selectedColor,
                            callbackfun: (v) {
                              setState(() {
                                Vehicle.selectedColor = v;
                              });
                            })),
                    SizedBox(width: 20.0),
                  ]),
                ),
                SizedBox(height: 18),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: plateNumberInput(packageCar: widget.packageCar, enable: true),
                ),
                SizedBox(height: 18),
                widget.packageCar
                    ? Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Checkbox(
                            value: widget.packageCar,
                            onChanged: (v) {
                              setState(() {
                                // this.value = v!;
                              });
                            },
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Add this Car to The Active Package'.tr,
                            style: GoogleFonts.tajawal(
                              textStyle: TextStyle(
                                color: mainColor,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: vehicleVinInput(
                    packageCar: false,
                  ),
                ),
                SizedBox(height: 18),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: RoundButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          clickable = false;
                        });
                        if (CurrentUser.isCorporate) {
                          bool success = await BlocProvider.of<ServiceRequestBloc>(context).createCorporateCar();

                          if (success) {
                            Get.to(() => chooseService());
                          }
                        } else if (widget.vehicleRegister == true) {
                          bool success = await BlocProvider.of<AppBloc>(context).addVehicle();
                          await BlocProvider.of<AppBloc>(context).getMyCars();
                          if (success) {
                            setState(() {
                              Vehicle.anotherVehicle = false;
                            });
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => registerVehicle()));
                          }
                        } else {
                          bool success = await Vehicle.addCar(widget.vehicleRegister);
                          await BlocProvider.of<AppBloc>(context).getMyCars();
                          if (success) {
                            setState(() {
                              Vehicle.addVehicle = false;
                            });
                            if (widget.serviceCar) {
                              cubit.changeCar();
                            } else {
                              Get.offAll(() => homeScreen(index: 1));
                            }
                          }
                        }
                        setState(() {
                          clickable = true;
                        });
                      }
                    },
                    padding: false,
                    text: clickable ? 'confirm'.tr : "Loading......".tr,
                    color: mainColor,
                  ),
                ),
                SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
