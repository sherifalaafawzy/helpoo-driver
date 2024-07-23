import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import '../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../../../main.dart';
import '../../widgets/willPopScopeWidget.dart';
import '../user_home_content/FNOL/chooseAccidentType.dart';
import 'activateVehicle.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../dataLayer/models/currentUser.dart';
import '../../../dataLayer/models/insuranceCompany.dart';
import '../../../dataLayer/models/vehicle.dart';
import '../../widgets/round_button.dart';
import '../../../dataLayer/bloc/app/app_bloc.dart';
import '../../../dataLayer/constants/variables.dart';

class mainPackageInsurance extends StatefulWidget {
  final bool fromFnol;

  mainPackageInsurance({
    Key? key,
    this.fromFnol = true,
  }) : super(key: key);

  @override
  State<mainPackageInsurance> createState() => _mainPackageInsuranceState();
}

class _mainPackageInsuranceState extends State<mainPackageInsurance> {
  var formKey = GlobalKey<FormState>();
  String? selectedItems;
  String? value;
  InsuranceCompany? insuranceCompanies;
  TextEditingController VINCtrl = TextEditingController();
  bool clickable = true;

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<FnolBloc>(navigatorKey.currentContext!);

    var cubit = BlocProvider.of<AppBloc>(context);
    return BlocBuilder<AppBloc, AppBlocState>(builder: (context, state) {
      return willPopScopeWidget(
        onWillPop: () async {
          Get.back();
          return true;
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: mainColor,
              actionsIconTheme: const IconThemeData(
                color: mainColor,
              ),
              elevation: 0,
              centerTitle: true,
              leading: Container(
                height: 48,
                width: 48,
                margin: const EdgeInsets.symmetric(horizontal: 8),
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
              title: Text('Choose insurance company'.tr,
                  maxLines: 3,
                  style: GoogleFonts.tajawal(
                    textStyle: const TextStyle(
                      color: appWhite,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 18.0,
                    ),
                  )),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 150,
                        child: Image.asset('assets/imgs/package.png'),
                      ),
                      Text(
                        'Choose the insurance company and add a VIN Number'.tr,
                        style: GoogleFonts.tajawal(
                          textStyle: const TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Insurance Company'.tr,
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
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: Get.height * 0.06,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          border: Border.all(
                            color: mainColor,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: DropdownButton(
                            isExpanded: true,
                            underline: Container(
                              color: Colors.transparent,
                            ),
                            dropdownColor: appWhite,
                            hint: Text(
                              'Select Company'.tr,
                            ),
                            style: GoogleFonts.tajawal(
                              textStyle: const TextStyle(
                                color: mainColor,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 18.0,
                              ),
                            ),
                            value: selectedItems,
                            items: cubit.insuranceCompany.map((item) {
                              return DropdownMenuItem(
                                child: Text(
                                  CurrentUser.isArabic ? item.arName! : item.enName!,
                                  style: GoogleFonts.tajawal(
                                    textStyle: const TextStyle(
                                      color: mainColor,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                                value: item.arName!,
                                onTap: () {
                                  insuranceCompanies = item;
                                  debugPrint('selectedItems ${insuranceCompanies!.id}');
                                  selectedItems = item.arName;
                                },
                              );
                            }).toList(),
                            onChanged: (item) => setState(() {}),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      (widget.fromFnol ? bloc.fnol.selectedCar!.chassisNo == null : true)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: 'VIN Number'.tr,
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
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      (widget.fromFnol ? bloc.fnol.selectedCar!.chassisNo == null : true)
                          ? Container(
                              height: Get.height * 0.08,
                              child: TextFormField(
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]'))
                                ],
                                // keyboardType: TextInputType.number,
                                textAlign: TextAlign.start,
                                controller: VINCtrl,
                                decoration: appInput.copyWith(
                                  hintText: "Insert VIN that return in the vehicle license".tr,
                                  hintStyle: GoogleFonts.tajawal(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                onChanged: (v) {
                                  setState(() {});
                                },
                                // validator: (value) {
                                //   if (value == null || value.isEmpty) {
                                //     return 'required field'.tr;
                                //   } else if (value.length < 5) {
                                //     return 'Please enter at least 5 characters'
                                //         .tr;
                                //   }
                                //   return null;
                                // },
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: Get.width,
                        child: RoundButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              // if (VINCtrl.text.length < 6) {}
                              if (insuranceCompanies != null) {
                                if (widget.fromFnol) {
                                  if (bloc.fnol.selectedCar!.chassisNo == null && VINCtrl.text.isEmpty) {
                                    HelpooInAppNotification.showErrorMessage(
                                        message: "You Have to enter policy number".tr);
                                  } else {
                                    setState(() {
                                      clickable = false;
                                    });

                                    bloc.fnol.selectedCar!.insuranceCompany = insuranceCompanies;
                                    if (bloc.fnol.selectedCar!.chassisNo == null) {
                                      bool updateVinSuccess = await Vehicle.updateCarVinNumber(
                                          carId: bloc.fnol.selectedCar!.id!, vinNumber: VINCtrl.text);
                                      if (updateVinSuccess) {
                                        Get.to(() => chooseAccidentType());
                                      }
                                    } else {
                                      Get.to(() => chooseAccidentType());
                                    }
                                  }
                                } else {
                                  Vehicle? car = await cubit.insurancePackage(
                                      insuranceCompanies!.id, VINCtrl.text.trim().substring(VINCtrl.text.length - 5));
                                  if (car != null) {
                                    Get.to(
                                      () => activateVehicle(
                                        vehicle: car,
                                        // packageCar: true,
                                      ),
                                    );
                                  }
                                }
                              } else {
                                HelpooInAppNotification.showErrorMessage(message: "You Have to enter company ".tr);
                                // Get.snackbar(
                                //     "Helpoo",
                                //     "You Have to enter company and policy number"
                                //         .tr);
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
                      )
                    ],
                  ),
                ),
              ),
            )),
      );
    });
  }
}
