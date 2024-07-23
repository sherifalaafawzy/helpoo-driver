import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/presitationLayer/pages/homeScreen.dart';
import 'package:helpoo/service_request/core/util/constants.dart';
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';
import 'package:helpoo/service_request/core/util/cubit/state.dart';
import 'package:helpoo/service_request/core/util/widgets/bottom_sheets/discount_widget.dart';
import 'package:helpoo/service_request/core/util/widgets/bottom_sheets/order_cost_with_payment_status_widget.dart';
import 'package:helpoo/service_request/core/util/widgets/bottom_sheets/order_details_text_widget.dart';
import 'package:helpoo/service_request/core/util/widgets/primary_button.dart';
import 'package:helpoo/service_request/core/util/widgets/primary_divider.dart';
import 'package:helpoo/service_request/core/util/widgets/primary_form_field.dart';
import 'package:helpoo/service_request/core/util/widgets/primary_padding.dart';

class OrderDoneSheet extends StatefulWidget {
  const OrderDoneSheet({super.key});

  @override
  State<OrderDoneSheet> createState() => _OrderDoneSheetState();
}

class _OrderDoneSheetState extends State<OrderDoneSheet> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewServiceRequestBloc, NewServiceRequestState>(
        listener: (context, state) {
      if (state is RateRequestSuccess) {
        sRBloc.countOpenedBottomSheets = 0;
        if (sRBloc.timer != null) {
          sRBloc.timer!.cancel();
        }

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => homeScreen(
              index: 0,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      }
    }, builder: (context, state) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: PrimaryPadding(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'please rate the driver'.tr,
                    style: GoogleFonts.tajawal(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor,
                        fontStyle: FontStyle.normal,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  space20Vertical(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                          image: DecorationImage(
                            image: AssetImage('assets/imgs/person.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      space20Horizontal(),
                      Text(
                        'Driver Name'.tr,
                        style: GoogleFonts.tajawal(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  space20Vertical(),
                  RatingBar.builder(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 30,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.green,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                      sRBloc.rateValue = rating.toInt();
                    },
                  ),
                  space20Vertical(),
                  PrimaryFormField(
                    controller: sRBloc.rateRequestRateCommentController,
                    validationError: '',
                    label: "Add Your Comment Here".tr,
                    infiniteLines: true,
                  ),
                  space20Vertical(),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: 'enter'.tr,
                      isLoading: state is RateRequestLoading,
                      onPressed: () {
                        sRBloc.rateRequest();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          PrimaryDivider(),
          PrimaryPadding(
            child: Column(
              children: [
                OrderCostWithPaymentStatus(
                  isOrderAccepted: true,
                ),
                space10Vertical(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OrderDetailsTextWidget(
                      text: 'total cost'.tr,
                      value:
                          '${sRBloc.serviceRequestModel != null ? sRBloc.serviceRequestModel!.serviceRequestDetails.fees.toString() : ''} ${'EGP'.tr}',
                      isBold: true,
                      textColor: Theme.of(context).primaryColor,
                    ),
                    DiscountWidget(
                      percentage: sRBloc.serviceRequestModel != null ||
                              sRBloc.serviceRequestModel?.serviceRequestDetails
                                      .originalFees !=
                                  sRBloc.serviceRequestModel!
                                      .serviceRequestDetails.fees
                          ? (sRBloc.serviceRequestModel!.serviceRequestDetails
                                      .originalFees -
                                  sRBloc.serviceRequestModel!
                                      .serviceRequestDetails.fees) /
                              sRBloc.serviceRequestModel!.serviceRequestDetails
                                  .originalFees *
                              100
                          : 0,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      );
    });
  }
}
