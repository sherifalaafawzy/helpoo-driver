// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';
import '../../dataLayer/models/vehicle.dart';
import '../../dataLayer/constants/variables.dart';
import 'round_button.dart';

class plateNumberInput extends StatefulWidget {
  bool visible;
  final bool packageCar;
  final bool enable;
  final Vehicle? vehicle;

  plateNumberInput({
    Key? key,
    this.visible = true,
    required this.packageCar,
    this.vehicle,
    required this.enable,
  }) : super(key: key);

  @override
  State<plateNumberInput> createState() => plateNumberInputState();
}

class plateNumberInputState extends State<plateNumberInput> {
  // bool activation = false;
  final Map<String, String> numeralsMap = {
    '0': '٠',
    '1': '١',
    '2': '٢',
    '3': '٣',
    '4': '٤',
    '5': '٥',
    '6': '٦',
    '7': '٧',
    '8': '٨',
    '9': '٩',
  };

  @override
  void initState() {
    super.initState();
    // if (widget.vehicle != null) {
    if ((widget.vehicle != null && widget.vehicle!.plateNo != "") &&
        (widget.vehicle != null && widget.vehicle!.plateNo != null)) {
      List x = widget.vehicle!.plateNo!.split("-");
      // check if the first index is number
      if (RegExp(r'\d').hasMatch(x.first)) {
        setState(() {
          var firstItem = x.removeAt(0);
          x.add(firstItem);
        });
      }
      if (x.length < 4) {
        setState(() {
          x.add("");
          x[3] = x[2];
          x[2] = "";
          Vehicle.firstCharacter = x[0];
          Vehicle.secondCharacter = x[1];
          Vehicle.thirdCharacter = x[2];
          Vehicle.plateNumberC.text = x[3];
        });
      } else {
        Vehicle.firstCharacter = x[0];
        Vehicle.secondCharacter = x[1];
        Vehicle.thirdCharacter = x[2];
        Vehicle.plateNumberC.text = x[3];
      }
    } else {
      // activation = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(canvasColor: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Visibility(
            visible: widget.visible,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: RichText(
                text: TextSpan(
                  text: 'Vehicle Plate No.'.tr,
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
                      text: widget.packageCar ? " *" : " (optional)".tr,
                      style: TextStyle(
                        color: widget.packageCar ? Colors.red : mainColor,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(7),
                        topRight: Radius.circular(7),
                      ),
                      color: Colors.blue,
                    ),
                    child: Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 32),
                          child: Text(
                            'مصر',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 32),
                          child: Text(
                            'Egypt',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        children: [
                          SizedBox(
                            width: Get.width * .15,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: RoundButton(
                                  padding: false,
                                  color: appBlack,
                                  // text: CurrentUser.isArabic
                                  //     ? Vehicle.firstCharacter ?? "_"
                                  //     : Vehicle.thirdCharacter ?? "_",
                                  text: Vehicle.firstCharacter ?? "_",
                                  onPressed:
                                      // widget.packageCar != false ||
                                      widget.enable
                                          ? () {
                                              Get.bottomSheet(
                                                Material(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(18),
                                                      topRight:
                                                          Radius.circular(18),
                                                    ),
                                                    child: Container(
                                                      color: appWhite,
                                                      height: Get.height * .5,
                                                      child:
                                                          ListView(children: [
                                                        ...List<Widget>.from(
                                                            characterSelectionItems
                                                                .map(
                                                                    (e) =>
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child: RoundButton(
                                                                              onPressed: () {
                                                                                Get.back();
                                                                                setState(() {
                                                                                  Vehicle.firstCharacter = e;
                                                                                  // if (CurrentUser
                                                                                  //     .isArabic) {
                                                                                  //   Vehicle.firstCharacter =
                                                                                  //       e;
                                                                                  // } else {
                                                                                  //   debugPrint('555555555');
                                                                                  //   Vehicle.thirdCharacter =
                                                                                  //       e;
                                                                                  // }
                                                                                });
                                                                              },
                                                                              padding: true,
                                                                              text: e,
                                                                              color: mainColor),
                                                                        )))
                                                      ]),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          : () {}),
                            ),
                          ),
                          SizedBox(
                            width: Get.width * .15,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: RoundButton(
                                  padding: false,
                                  color: appBlack,
                                  text: Vehicle.secondCharacter ?? "_",
                                  onPressed:
                                      // widget.packageCar != false ||
                                      widget.enable
                                          ? () {
                                              Get.bottomSheet(
                                                Material(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(18),
                                                      topRight:
                                                          Radius.circular(18),
                                                    ),
                                                    child: Container(
                                                      color: appWhite,
                                                      height: Get.height * .5,
                                                      child:
                                                          ListView(children: [
                                                        ...List<Widget>.from(
                                                            characterSelectionItems
                                                                .map(
                                                                    (e) =>
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child: RoundButton(
                                                                              onPressed: () {
                                                                                Get.back();
                                                                                setState(() {
                                                                                  if (Vehicle.firstCharacter?.isEmpty ?? true) {
                                                                                    Vehicle.firstCharacter = e;
                                                                                  } else {
                                                                                    Vehicle.secondCharacter = e;
                                                                                  }

                                                                                  // if (CurrentUser.isArabic) {
                                                                                  //   if (Vehicle.firstCharacter?.isEmpty ?? true) {
                                                                                  //     Vehicle.firstCharacter = e;
                                                                                  //   } else {
                                                                                  //     Vehicle.secondCharacter = e;
                                                                                  //   }
                                                                                  // } else {
                                                                                  //   if (Vehicle.thirdCharacter?.isEmpty ?? true) {
                                                                                  //     Vehicle.thirdCharacter = e;
                                                                                  //   } else {
                                                                                  //     Vehicle.secondCharacter = e;
                                                                                  //   }
                                                                                  // }
                                                                                });
                                                                              },
                                                                              padding: true,
                                                                              text: e,
                                                                              color: mainColor),
                                                                        )))
                                                      ]),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          : () {}),
                            ),
                          ),
                          SizedBox(
                            width: Get.width * .15,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: RoundButton(
                                  padding: false,
                                  color: appBlack,
                                  // text: CurrentUser.isArabic
                                  //     ? Vehicle.thirdCharacter ?? "_"
                                  //     : Vehicle.firstCharacter ?? "_",
                                  text: Vehicle.thirdCharacter ?? "_",
                                  onPressed:
                                      // widget.packageCar != false ||
                                      widget.enable
                                          ? () {
                                              Get.bottomSheet(
                                                Material(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(18),
                                                      topRight:
                                                          Radius.circular(18),
                                                    ),
                                                    child: Container(
                                                      color: appWhite,
                                                      height: Get.height * .5,
                                                      child:
                                                          ListView(children: [
                                                        ...List<Widget>.from(
                                                            characterSelectionItems
                                                                .map(
                                                                    (e) =>
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child: RoundButton(
                                                                              onPressed: () {
                                                                                Get.back();
                                                                                setState(() {
                                                                                  if (Vehicle.firstCharacter?.isEmpty ?? true) {
                                                                                    Vehicle.firstCharacter = e;
                                                                                  } else if (Vehicle.secondCharacter?.isEmpty ?? true) {
                                                                                    Vehicle.secondCharacter = e;
                                                                                  } else {
                                                                                    Vehicle.thirdCharacter = e;
                                                                                  }

                                                                                  // if (CurrentUser.isArabic) {
                                                                                  //   if (Vehicle.firstCharacter?.isEmpty ?? true) {
                                                                                  //     Vehicle.firstCharacter = e;
                                                                                  //   } else if (Vehicle.secondCharacter?.isEmpty ?? true) {
                                                                                  //     Vehicle.secondCharacter = e;
                                                                                  //   } else {
                                                                                  //     Vehicle.thirdCharacter = e;
                                                                                  //   }
                                                                                  // } else {
                                                                                  //   Vehicle.firstCharacter = e;
                                                                                  // }
                                                                                });
                                                                              },
                                                                              padding: true,
                                                                              text: e,
                                                                              color: mainColor),
                                                                        )))
                                                      ]),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          : () {}),
                            ),
                          ),
                          Spacer(),
                          BlocBuilder<ServiceRequestBloc, ServiceRequestState>(
                            builder: (context, state) {
                              return SizedBox(
                                width: Get.width * 0.20,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: TextFormField(
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                        RegExp('[a-z A-Z 0-9]'),
                                      )
                                    ],

                                    controller: Vehicle.plateNumberC,
                                    maxLength: 4,
                                    enabled:
                                        // widget.packageCar != false ||
                                        widget.enable,
                                    // enabled: activation && widget.packageCar != false,
                                    keyboardType: TextInputType.number,

                                    decoration: appInput.copyWith(
                                      counterText: '',
                                      hintText: "number".tr,
                                    ),
                                    // onChanged: (v) {
                                    //   debugPrint('-----------VV ${v}');
                                    //   debugPrint(
                                    //       '-----------11 ${Vehicle.plateNumberC.text}');
                                    //   setState(() {
                                    //     Vehicle.plateNumberC.text += sRBloc.replaceEnNumberToAr(sRBloc.replaceArNumToEn(v));
                                    //     debugPrint('5555555 ${sRBloc.replaceEnNumberToAr(v)}');
                                    //     debugPrint('6666666 ${sRBloc.replaceArNumToEn(sRBloc.replaceEnNumberToAr(v))}');
                                    //     debugPrint(
                                    //         '-----------22 ${Vehicle.plateNumberC.text}');
                                    //   });
                                    //
                                    //   // if(v == '1') {
                                    //   //   debugPrint('----------- ${Vehicle.plateNumberC.text}');
                                    //   //   setState(() {
                                    //   //     Vehicle.plateNumberC.text = '۱';
                                    //   //     debugPrint('-----------22 ${Vehicle.plateNumberC.text}');
                                    //   //   });
                                    //   // }
                                    //   // if(v.length == 3||v.length==4){
                                    //   //   setState(() {
                                    //   //     activation=false;
                                    //   //   });
                                    // }

                                    // },
                                    // validator: (val) {
                                    //   if (Vehicle.firstCharacter == null) {
                                    //     return null;
                                    //   }
                                    //   if (val == null) {
                                    //     return "error";
                                    //   }
                                    //   int? num = int.tryParse(val);
                                    //   if (num == null || num < 1 || num > 9999) {
                                    //     return "error, number 10 - 9999".tr;
                                    //   }
                                    //   return null;
                                    // },
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          widget.packageCar
              ? Center(
                  child: Text(
                    'In Case Adding Car to Package you Have to Add Plate Number'
                        .tr,
                    style: GoogleFonts.tajawal(
                      textStyle: const TextStyle(
                        color: appRed,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                )
              : SizedBox(
                  height: 8,
                ),
        ],
      ),
    );
  }

  void convertToArabicNumerals() {
    String numbers = Vehicle.plateNumberC.text;
    debugPrint('------------------- $numbers');
    String arabicNumbers = '';
    for (int i = 0; i < numbers.length; i++) {
      //if i is english number convert it to arabic else keep it as it is
      if (numbers.codeUnitAt(i) >= 48 && numbers.codeUnitAt(i) <= 57) {
        arabicNumbers += String.fromCharCode(numbers.codeUnitAt(i) + 1584);
        continue;
      }
      arabicNumbers += numbers[i];
    }
    print(arabicNumbers);
    Vehicle.plateNumberC.value = TextEditingValue(
      text: Vehicle.plateNumberC.text + arabicNumbers,
      selection: Vehicle.plateNumberC.selection.copyWith(
        baseOffset: 0,
        extentOffset: arabicNumbers.length,
      ),
    );
  }
}
