import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/dataLayer/models/currentUser.dart';
import 'package:helpoo/service_request/core/util/constants.dart';
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';
import 'package:helpoo/service_request/core/util/cubit/state.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:helpoo/service_request/core/util/prints.dart';
import 'package:helpoo/service_request/core/util/widgets/bottom_sheets/payment_item.dart';
import 'package:helpoo/service_request/core/util/widgets/primary_button.dart';
import 'package:helpoo/service_request/core/util/widgets/primary_padding.dart';

class PaymentWayBottomSheet extends StatefulWidget {
  const PaymentWayBottomSheet({super.key});

  @override
  State<PaymentWayBottomSheet> createState() => _PaymentWayBottomSheetState();
}

class _PaymentWayBottomSheetState extends State<PaymentWayBottomSheet> {
  @override
  void initState() {
    super.initState();
    if (CurrentUser.isCorporate) {
      sRBloc.getPaymentMethodsList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewServiceRequestBloc, NewServiceRequestState>(
      builder: (context, state) {
        printWarning(
            'Available Payments : ${sRBloc.paymentMethodsList.length}');
        return PrimaryPadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'choose Payment Method'.tr,
                style: GoogleFonts.tajawal(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    fontSize: 18.0,
                  ),
                ),
              ),
              space20Vertical(),
              // PaymentItem(
              //   image: 'defered',
              //   title: 'الدفع اجل',
              //   isSelected: false,
              //   onTap: () {},
              // ),
              // space10Vertical(),
              if (CurrentUser.isCorporate) ...[
                ...List.generate(
                  sRBloc.paymentMethodsList.length,
                  (index) => PaymentItem(
                    image: sRBloc.paymentMethodsList[index] == 'cash'
                        ? 'cash'
                        : sRBloc.paymentMethodsList[index] == 'cardToDriver'
                            ? 'pos'
                            : 'credit-card',
                    title: sRBloc.paymentMethodsList[index] == 'cash'
                        ? 'pay driver using cash'.tr
                        : sRBloc.paymentMethodsList[index] == 'cardToDriver'
                            ? 'pay driver using credit card'.tr
                            : 'deferredPayment'.tr,
                    isSelected: sRBloc.paymentMethodsList[index] == 'cash'
                        ? sRBloc.paymentMethod == ServicePaymentMethods.cash
                        : sRBloc.paymentMethodsList[index] == 'cardToDriver'
                            ? sRBloc.paymentMethod ==
                                ServicePaymentMethods.cardToDriver
                            : sRBloc.paymentMethod ==
                                ServicePaymentMethods.deferred,
                    onTap: () {
                      sRBloc.paymentMethodsList[index] == 'cash'
                          ? sRBloc.paymentMethod = ServicePaymentMethods.cash
                          : sRBloc.paymentMethodsList[index] == 'cardToDriver'
                              ? sRBloc.paymentMethod =
                                  ServicePaymentMethods.cardToDriver
                              : sRBloc.paymentMethod =
                                  ServicePaymentMethods.deferred;
                    },
                  ),
                ),
              ] else ...[
                if (!sRBloc.isOnlinePaymentOnly) ...[
                  PaymentItem(
                    image: 'cash',
                    title: 'pay driver using cash'.tr,
                    isSelected:
                        sRBloc.paymentMethod == ServicePaymentMethods.cash,
                    onTap: () {
                      sRBloc.paymentMethod = ServicePaymentMethods.cash;
                    },
                  ),
                  space10Vertical(),
                  PaymentItem(
                    image: 'pos',
                    // title: 'دفع بكارت للسائق\n(ميزة - فيزا - ماستر كارد)',
                    title: 'pay driver using credit card'.tr,
                    isSelected: sRBloc.paymentMethod ==
                        ServicePaymentMethods.cardToDriver,
                    onTap: () {
                      sRBloc.paymentMethod = ServicePaymentMethods.cardToDriver;
                    },
                  ),
                  space10Vertical(),
                ],
                PaymentItem(
                  image: 'credit-card',
                  // title: 'دفع بكارت\n(ميزة - فيزا - ماستر كارد)',
                  title: 'Online Payment With Visa'.tr,
                  isSelected:
                      sRBloc.paymentMethod == ServicePaymentMethods.onlineCard,
                  onTap: () {
                    sRBloc.paymentMethod = ServicePaymentMethods.onlineCard;
                  },
                ),
                // space10Vertical(),
                // PaymentItem(
                //   image: 'wallet',
                //   title: 'محفظة الكترونية',
                //   isSelected: false,
                //   onTap: () {},
                // ),
              ],

              space20Vertical(),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'confirm'.tr,
                    isLoading: state is GetIFrameUrlLoadingState ||
                        state is UpdateServiceRequestLoadingState,
                    onPressed: () {
                      if (sRBloc.paymentMethod ==
                          ServicePaymentMethods.nothing) {
                        HelpooInAppNotification.showErrorMessage(
                            message: 'please select payment method'.tr);
                      } else {
                        if (sRBloc.paymentMethod ==
                            ServicePaymentMethods.onlineCard) {
                          sRBloc.getIFrameUrl();

                          return;
                        }
                        sRBloc.updateServiceRequest();
                        if (sRBloc.serviceRequestModel != null) {
                          // sRBloc.getCurrentServiceRequestStatus();
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
