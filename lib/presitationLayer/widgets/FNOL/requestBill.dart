// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/main.dart';
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';
import 'package:helpoo/service_request/core/util/cubit/state.dart';
import 'package:helpoo/service_request/core/util/extensions/days_extensions.dart';
import 'package:helpoo/service_request/core/util/utils.dart';
import 'package:helpoo/service_request/core/util/widgets/show_primary_pop_up.dart';
import 'package:intl/intl.dart' as intl;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../../../dataLayer/constants/variables.dart';
import '../../../dataLayer/models/currentUser.dart';
import '../../pages/user_home_content/FNOL/FNOLStepDone.dart';
import '../../pages/user_home_content/FNOL/billDeliverySearch.dart';
import '../round_button.dart';
import '../willPopScopeWidget.dart';

ScrollController scrollController = ScrollController();

class requestBill extends StatefulWidget {
  const requestBill({Key? key}) : super(key: key);

  @override
  State<requestBill> createState() => requestBillState();
}

class requestBillState extends State<requestBill> {
  DateTime selectedDate = DateTime.now().add(Duration(
    days: 1,
  ));
  String selectedTime = '';
  bool showDate = false;
  bool showTime = false;
  bool showDateTime = false;
  String billDeliveryNotes = '';
  bool requestBillConfirmation = false;

  // Select for Date
  Future<DateTime> _selectDate(BuildContext context, bloc) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
      bloc.fnol.billDeliveryDate = selectedDate;
      // bloc.fnol.billDeliveryTimeRange = selectedTime;
    }
    return selectedDate;
  }

  String getDateTime() {
    if (selectedDate == null) {
      return 'select date timer';
    } else {
      return intl.DateFormat('yyyy-MM-dd').format(selectedDate) +
          "   " +
          this.selectedTime;
    }
  }

  GlobalKey<State<StatefulWidget>> _popupKey = GlobalKey();

  var bloc = BlocProvider.of<FnolBloc>(navigatorKey.currentContext!);

  @override
  void initState() {
    super.initState();
    bloc.getLocation("bill");
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FnolBloc, FnolState>(
      listener: (context, state) {
        if (state is billLocationAdded) {
          debugPrint('billLocationAdded :::::');
          debugPrint('state :: ${state.isSelectFromPopUp}');
          // setState(() {});
        }
      },
      builder: (context, state) {
        debugPrint('billingAddress ::==>> ${bloc.fnol.billingAddress}');
        debugPrint('currentAddress ::==>> ${bloc.fnol.currentAddress}');
        return willPopScopeWidget(
          onWillPop: () async {
            Get.back();
            return true;
          },
          child: Scaffold(
            // resizeToAvoidBottomInset: true,
            backgroundColor: appWhite,
            appBar: AppBar(
              iconTheme: const IconThemeData(color: appWhite),
              backgroundColor: mainColor,
              centerTitle: true,
              title: Text(
                "bill delivery request".tr,
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
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Image.asset('assets/imgs/report.png',
                          height: 80, width: Get.width),
                    ),
                    requestBillConfirmation
                        ? Container(
                            decoration: BoxDecoration(
                                color: appGrey,
                                border: Border.all(
                                  color: appBlack,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                )),
                            child: Column(
                              children: [
                                Text(
                                  "Final Data".tr,
                                  style: GoogleFonts.tajawal(
                                    textStyle: const TextStyle(
                                      color: mainColor,
                                      fontWeight: FontWeight.w800,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Bill Will Deliver At".tr +
                                      "  " +
                                      bloc.fnol.billDeliveryDate.toString(),
                                  style: GoogleFonts.tajawal(
                                    textStyle: const TextStyle(
                                      color: mainColor,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                Text(
                                  "At time Range".tr +
                                      "  " +
                                      bloc.fnol.billDeliveryTimeRange
                                          .toString(),
                                  style: GoogleFonts.tajawal(
                                    textStyle: const TextStyle(
                                      color: mainColor,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Bill Delivery Location".tr,
                                  style: GoogleFonts.tajawal(
                                    textStyle: const TextStyle(
                                      color: mainColor,
                                      fontWeight: FontWeight.w800,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 10, top: 4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        MdiIcons.mapMarker,
                                        color: mainColor,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: Get.width * .8,
                                        child: Text(
                                          bloc.fnol.billingAddress,
                                          style: GoogleFonts.tajawal(
                                            textStyle: const TextStyle(
                                              color: appBlack,
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 13.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Text(
                            "bill delivery description".tr,
                            style: GoogleFonts.tajawal(
                              textStyle: const TextStyle(
                                color: appBlack,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 18.0,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                    SizedBox(height: 16),
                    Visibility(
                      visible: !showDateTime,
                      child: RoundButton(
                        onPressed: () async {
                          await this._selectDate(context, bloc);
                          showDateTime = true;
                        },
                        padding: true,
                        text: 'pickup date'.tr,
                        color: mainColor,
                      ),
                    ),
                    showDateTime
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "pickup date and time".tr,
                                  style: GoogleFonts.tajawal(
                                    textStyle: const TextStyle(
                                      color: mainColor,
                                      fontWeight: FontWeight.w800,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Center(
                                  child: Text(
                                    getDateTime().tr,
                                    style: GoogleFonts.tajawal(
                                      textStyle: const TextStyle(
                                        color: appBlack,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'choose delivery time interval'.tr,
                            style: GoogleFonts.tajawal(
                              textStyle: const TextStyle(
                                color: mainColor,
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.normal,
                                fontSize: 18.0,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              RoundButton(
                                onPressed: () {
                                  setState(() {
                                    selectedTime = '01:00 PM - 05:00 PM';
                                  });
                                  bloc.fnol.billDeliveryTimeRange =
                                      selectedTime;
                                },
                                padding: false,
                                text: '01:00 PM - 05:00 PM'.tr,
                                color: selectedTime == '01:00 PM - 05:00 PM'
                                    ? mainColor
                                    : Colors.grey,
                              ),
                              RoundButton(
                                onPressed: () {
                                  setState(() {
                                    selectedTime = '09:00 AM - 01:00 PM';
                                  });
                                  bloc.fnol.billDeliveryTimeRange =
                                      selectedTime;
                                },
                                padding: false,
                                text: '09:00 AM - 01:00 PM'.tr,
                                color: selectedTime == '09:00 AM - 01:00 PM'
                                    ? mainColor
                                    : Colors.grey,
                              ),
                            ]),
                        SizedBox(
                          height: 24,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Billing Delivery Location'.tr,
                            style: GoogleFonts.tajawal(
                              textStyle: const TextStyle(
                                color: mainColor,
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.normal,
                                fontSize: 18.0,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        //TODO OPEN POPUP
                        showPrimaryPopUp(
                          body: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Billing Delivery Location'.tr,
                                          style: GoogleFonts.tajawal(
                                            textStyle: const TextStyle(
                                              color: mainColor,
                                              fontWeight: FontWeight.w800,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: Icon(
                                            Icons.close,
                                            color: mainColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  billDeliveryLocation(),
                                ],
                              ),
                            ),
                          ],
                          popUpWidth: Get.width * 0.90,
                          isDismissible: true,
                          context: context,
                        );
                      },
                      child: BlocBuilder<NewServiceRequestBloc,
                          NewServiceRequestState>(
                        builder: (context, state) {
                          return Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: 5.br,
                              border: Border.all(color: mainColor),
                            ),
                            child: Text(
                                '${sRBloc.billingAddress.isEmpty ? bloc.fnol.currentAddress : sRBloc.billingAddress}'),
                          );
                        },
                      ),
                    ),
                    Visibility(
                        visible:
                            bloc.fnol.billingAddress != null && showDateTime,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  'additional info'.tr,
                                  style: GoogleFonts.tajawal(
                                    textStyle: const TextStyle(
                                      color: mainColor,
                                      fontWeight: FontWeight.w800,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                TextFormField(
                                  minLines: 3,
                                  maxLines: 5,
                                  initialValue:
                                      bloc.fnol.billDeliveryNotes.isEmpty
                                          ? ""
                                          : bloc.fnol.billDeliveryNotes[0],
                                  onChanged: (v) {
                                    setState(() {
                                      billDeliveryNotes = v;
                                    });
                                    bloc.fnol.billDeliveryNotes =
                                        billDeliveryNotes;
                                  },
                                  decoration: appInput,
                                ),
                              ]),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: showDateTime &&
                          bloc.fnol.billingAddress != null &&
                          selectedTime.isNotEmpty &&
                          bloc.fnol.billDeliveryDate != null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        child: SizedBox(
                          width: Get.width,
                          child: RoundButton(
                            onPressed: () async {
                              Utils.closeKeyboard(context);
                              if (requestBillConfirmation == false) {
                                setState(() {
                                  requestBillConfirmation = true;
                                });
                              } else {
                                bloc.submitBill();
                                await bloc.updateStatus(
                                    "billing", bloc.fnol.id);
                                Get.to(() => fnolStepDone(bloc.fnol));
                              }
                            },
                            padding: false,
                            text: 'Send Request'.tr,
                            color: mainColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // bottomNavigationBar: Visibility(
            //   visible: showDateTime &&
            //       bloc.fnol.billingAddress != null &&
            //       selectedTime.isNotEmpty &&
            //       bloc.fnol.billDeliveryDate != null,
            //   child: Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: RoundButton(
            //       onPressed: () async {
            //         if (requestBillConfirmation == false) {
            //           setState(() {
            //             requestBillConfirmation = true;
            //           });
            //         } else {
            //           bloc.submitBill();
            //           await bloc.updateStatus("billing", bloc.fnol.id);
            //           Get.to(() => fnolStepDone(bloc.fnol));
            //         }
            //       },
            //       padding: false,
            //       text: 'Send Request'.tr,
            //       color: mainColor,
            //     ),
            //   ),
            // ),
          ),
        );
      },
    );
  }
}
