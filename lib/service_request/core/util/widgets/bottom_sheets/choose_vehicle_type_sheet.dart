import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/constants.dart';
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';
import 'package:helpoo/service_request/core/util/cubit/state.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:helpoo/service_request/core/util/widgets/bottom_sheets/vehicle_type_item.dart';
import 'package:helpoo/service_request/core/util/widgets/primary_button.dart';
import 'package:helpoo/service_request/core/util/widgets/primary_padding.dart';

class ChooseVehicleTypeBottomSheet extends StatefulWidget {
  const ChooseVehicleTypeBottomSheet({super.key});

  @override
  State<ChooseVehicleTypeBottomSheet> createState() =>
      _ChooseVehicleTypeBottomSheetState();
}

class _ChooseVehicleTypeBottomSheetState
    extends State<ChooseVehicleTypeBottomSheet> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sRBloc.serviceRequestPromoCodeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewServiceRequestBloc, NewServiceRequestState>(
      listener: (context, state) {
        if (state is ApplyVoucherCodeSuccess) {
          sRBloc.calculateServiceFees();
          HelpooInAppNotification.showSuccessMessage(
              message: 'Promo Code Applied Successfully'.tr);
          // Get.snackbar('Promo Code'.tr, 'Promo Code Applied Successfully'.tr);
        }
      },
      builder: (context, state) {
        return PrimaryPadding(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Container(
              //   height: 50,
              //   width: double.infinity,
              //   clipBehavior: Clip.hardEdge,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //     border: Border.all(color: Theme.of(context).primaryColor),
              //   ),
              //   child: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       const Spacer(),
              //       Container(
              //         height: 50,
              //         width: 70,
              //         decoration: BoxDecoration(
              //           color: Theme.of(context).primaryColor,
              //           // borderRadius: BorderRadius.circular(10),
              //         ),
              //         alignment: Alignment.center,
              //         child: Text(
              //           'ادخال',
              //           textAlign: TextAlign.center,
              //           style: GoogleFonts.tajawal(
              //             textStyle: TextStyle(
              //               fontWeight: FontWeight.w600,
              //               color: Colors.white,
              //               fontStyle: FontStyle.normal,
              //               fontSize: 14.0,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // PrimaryFormField(
              //   validationError: '',
              //   label: 'هل لديك قسيمة خصم ؟',
              //   borderColor: Theme.of(context).primaryColor,
              //   prefixIcon: Padding(
              //     padding: const EdgeInsets.only(left: 10),
              //     child: Image.asset(
              //       'assets/imgs/coupon.png',
              //       height: 20,
              //     ),
              //   ),
              //   suffixIcon: Container(
              //     width: 70,
              //     decoration: BoxDecoration(
              //       color: Theme.of(context).primaryColor,
              //       borderRadius: BorderRadius.only(
              //         bottomLeft: Radius.circular(10),
              //         topLeft: Radius.circular(10),
              //       ),
              //     ),
              //     alignment: Alignment.center,
              //     child: Text(
              //       'ادخال',
              //       textAlign: TextAlign.center,
              //       style: GoogleFonts.tajawal(
              //         textStyle: TextStyle(
              //           fontWeight: FontWeight.w600,
              //           color: Colors.white,
              //           fontStyle: FontStyle.normal,
              //           fontSize: 14.0,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 43.0,
              //   child: TextFormField(
              //     maxLines: 1,
              //     enabled: true,
              //     controller: sRBloc.serviceRequestPromoCodeController,
              //     decoration: InputDecoration(
              //       isDense: true,
              //       hintText: 'Have Voucher Code?'.tr,
              //       hintStyle: GoogleFonts.tajawal(
              //         textStyle: TextStyle(
              //           fontWeight: FontWeight.w600,
              //           color: Colors.black,
              //           fontStyle: FontStyle.normal,
              //           fontSize: 14.0,
              //         ),
              //       ),
              //       prefixIcon: Padding(
              //         padding: const EdgeInsets.symmetric(
              //           horizontal: 10,
              //         ),
              //         child: Image.asset(
              //           'assets/imgs/coupon.png',
              //           height: 20,
              //         ),
              //       ),
              //       suffixIcon: InkWell(
              //         onTap: () {
              //           sRBloc.applyVoucherCode();
              //         },
              //         child: Container(
              //           width: 70,
              //           decoration: BoxDecoration(
              //             color: Theme.of(context).primaryColor,
              //             borderRadius: BorderRadiusDirectional.only(
              //               bottomEnd: Radius.circular(10),
              //               topEnd: Radius.circular(10),
              //             ),
              //           ),
              //           alignment: Alignment.center,
              //           child: sRBloc.isApplyPromoCodeLoading
              //               ? Center(
              //                   child: CupertinoActivityIndicator(
              //                     color: Colors.white,
              //                   ),
              //                 )
              //               : Text(
              //                   'enter'.tr,
              //                   textAlign: TextAlign.center,
              //                   style: GoogleFonts.tajawal(
              //                     textStyle: TextStyle(
              //                       fontWeight: FontWeight.w600,
              //                       color: Colors.white,
              //                       fontStyle: FontStyle.normal,
              //                       fontSize: 14.0,
              //                     ),
              //                   ),
              //                 ),
              //         ),
              //       ),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //         borderSide: BorderSide(
              //           color: Theme.of(context).primaryColor,
              //         ),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //         borderSide: BorderSide(
              //           color: Theme.of(context).primaryColor,
              //         ),
              //       ),
              //       enabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //         borderSide: BorderSide(
              //           color: Theme.of(context).primaryColor,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // space20Vertical(),
              Text(
                'choose towing service'.tr,
                style: GoogleFonts.tajawal(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    fontSize: 18.0,
                  ),
                ),
              ),
              space10Vertical(),
              VehicleTypeItem(
                title: 'basic towing'.tr,
                isDiscount: sRBloc.calculateFeesModel!.normalOriginalFees !=
                    sRBloc.calculateFeesModel!.normalFees,
                priceBeforeDiscount:
                    sRBloc.calculateFeesModel!.normalOriginalFees.toString(),
                price: sRBloc.calculateFeesModel!.normalFees.toString(),
                image: 'basicTowing',
                isSelected: sRBloc.isNormalTowingSelected,
                onTap: () {
                  sRBloc.isNormalTowingSelected = true;
                },
              ),
              Divider(
                color: Theme.of(context).primaryColor,
              ),
              VehicleTypeItem(
                title: 'premium towing'.tr,
                price: sRBloc.calculateFeesModel!.euroFees.toString(),
                isDiscount: sRBloc.calculateFeesModel!.euroOriginalFees !=
                    sRBloc.calculateFeesModel!.euroFees,
                priceBeforeDiscount:
                    sRBloc.calculateFeesModel!.euroOriginalFees.toString(),
                image: 'premiumTowing',
                isSelected: !sRBloc.isNormalTowingSelected,
                onTap: () {
                  sRBloc.isNormalTowingSelected = false;
                },
              ),
              space20Vertical(),
              PrimaryButton(
                text: "Submit".tr,
                isLoading: sRBloc.isTowingSelectingLoading,
                onPressed: () {
                  debugPrint(
                      'countOpenedBottomSheets--: ${sRBloc.countOpenedBottomSheets}');

                  sRBloc.countOpenedBottomSheets--;

                  debugPrint(
                      'countOpenedBottomSheets--: ${sRBloc.countOpenedBottomSheets}');

                  sRBloc.towingSelectedAction();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
