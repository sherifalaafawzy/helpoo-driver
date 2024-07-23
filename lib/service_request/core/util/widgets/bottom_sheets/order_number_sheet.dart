import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/constants.dart';
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';
import 'package:helpoo/service_request/core/util/cubit/state.dart';
import 'package:helpoo/service_request/core/util/prints.dart';
import 'package:helpoo/service_request/core/util/widgets/bottom_sheets/discount_widget.dart';
import 'package:helpoo/service_request/core/util/widgets/bottom_sheets/order_cost_with_payment_status_widget.dart';
import 'package:helpoo/service_request/core/util/widgets/bottom_sheets/order_details_text_widget.dart';
import 'package:helpoo/service_request/core/util/widgets/primary_button.dart';
import 'package:helpoo/service_request/core/util/widgets/primary_divider.dart';
import 'package:helpoo/service_request/core/util/widgets/primary_padding.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderNumberBottomSheet extends StatefulWidget {
  final bool isOrderAccepted;
  final bool isServiceInProgress;
  VoidCallback? onOrderAccepted;
  VoidCallback? onOrderCanceled;
  final bool isSlidingUpPanel;
  final bool isCollapsed;
  final bool isShowDriverData;

  OrderNumberBottomSheet({
    super.key,
    this.isOrderAccepted = false,
    this.isServiceInProgress = false,
    this.onOrderAccepted,
    this.onOrderCanceled,
    this.isSlidingUpPanel = false,
    this.isCollapsed = false,
    this.isShowDriverData = false,
  });

  @override
  State<OrderNumberBottomSheet> createState() => _OrderNumberBottomSheetState();
}

class _OrderNumberBottomSheetState extends State<OrderNumberBottomSheet> {
  @override
  Widget build(BuildContext context) {
    if (widget.isSlidingUpPanel) {
      return BlocBuilder<NewServiceRequestBloc, NewServiceRequestState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isCollapsed)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 80.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadiusDirectional.only(
                            topStart: Radius.circular(6),
                            topEnd: Radius.circular(6),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              sRBloc.driverPolylineResult != null
                                  ? sRBloc.driverPolylineResult!.durationInSec
                                      .toString()
                                  : '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.tajawal(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                            Text(
                              'min'.tr,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.tajawal(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadiusDirectional.only(
                              topEnd: Radius.circular(20),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Container(
                                width: 40,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              space5Vertical(),
                              Text(
                                ServiceRequestStatusEnum.values
                                    .firstWhere((element) =>
                                        element.name ==
                                        sRBloc.serviceRequestModel!
                                            .serviceRequestDetails.status)
                                    .value,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.tajawal(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
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
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      top: widget.isCollapsed ? 0 : 45,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadiusDirectional.only(
                          topStart: Radius.circular(20),
                          topEnd: Radius.circular(20),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!widget.isCollapsed) space30Vertical(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // order number area
                              if (!widget.isOrderAccepted ||
                                  !widget.isShowDriverData)
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                      width: 1,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 6,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Request ID'.tr,
                                        style: GoogleFonts.tajawal(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        sRBloc.serviceRequestModel!
                                            .serviceRequestDetails.id
                                            .toString(),
                                        style: GoogleFonts.tajawal(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              // driver details area
                              if (widget.isOrderAccepted &&
                                  widget.isShowDriverData)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Theme.of(context).primaryColor,
                                          width: 1,
                                        ),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/imgs/person.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    space5Horizontal(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          sRBloc
                                                  .serviceRequestModel!
                                                  .serviceRequestDetails
                                                  .driverRequestDetailsModel
                                                  ?.driverUserModel
                                                  .name ??
                                              'Driver Name'.tr,
                                          style: GoogleFonts.tajawal(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ),
                                        RatingBar.builder(
                                          initialRating: double.parse(sRBloc
                                              .serviceRequestModel!
                                              .serviceRequestDetails
                                              .driverRequestDetailsModel!
                                              .averageRating),
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: false,
                                          itemCount: 5,
                                          itemSize: 18,
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.green,
                                          ),
                                          onRatingUpdate: (rating) {
                                            debugPrint(rating.toString());
                                          },
                                        ),
                                        Text(
                                          '${'wench number'.tr}: ${(sRBloc.serviceRequestModel!.serviceRequestDetails.vehicle?.VecName ?? '')}-${(sRBloc.serviceRequestModel!.serviceRequestDetails.vehicle?.VecNum ?? '')}',
                                          style: GoogleFonts.tajawal(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    space5Horizontal(),
                                    InkWell(
                                      onTap: () async {
                                        if (sRBloc
                                                .serviceRequestModel!
                                                .serviceRequestDetails
                                                .driverRequestDetailsModel
                                                ?.driverUserModel
                                                .PhoneNumber !=
                                            null) {
                                          if (!await launchUrl(
                                            Uri.parse(
                                                'tel:${sRBloc.serviceRequestModel!.serviceRequestDetails.driverRequestDetailsModel!.driverUserModel.PhoneNumber}'),
                                          )) {
                                            throw 'Could not launch url'.tr;
                                          }
                                        }
                                      },
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        child: Icon(
                                          Icons.phone,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    //
                                    // if (!await launchUrl(Uri.parse('tel:17000'))) {
                                    // throw 'Could not launch url';
                                    // }

                                    // space20Horizontal(),
                                    // InkWell(
                                    //   child: Image.asset(
                                    //     'assets/imgs/callCenter.png',
                                    //     width: 30,
                                    //     height: 30,
                                    //   ),
                                    // ),
                                  ],
                                ),

                              // discount area
                              DiscountWidget(
                                percentage: double.parse(
                                  sRBloc.getHighestDiscount(
                                    [
                                      sRBloc
                                              .serviceRequestModel!
                                              .serviceRequestDetails
                                              .adminDiscount ??
                                          0,
                                      sRBloc
                                              .serviceRequestModel!
                                              .serviceRequestDetails
                                              .discountPercentage ??
                                          0,
                                      // serviceRequestModel.policyAndPackage!.packageDiscountPercentage ?? 0
                                    ],
                                  ),
                                ),
                                // sRBloc.serviceRequestModel != null ||
                                //         sRBloc
                                //                 .serviceRequestModel!
                                //                 .serviceRequestDetails
                                //                 .originalFees !=
                                //             sRBloc.serviceRequestModel!
                                //                 .serviceRequestDetails.fees
                                //     ? (sRBloc
                                //                 .serviceRequestModel!
                                //                 .serviceRequestDetails
                                //                 .originalFees -
                                //             sRBloc
                                //                 .serviceRequestModel!
                                //                 .serviceRequestDetails
                                //                 .fees) /
                                //         sRBloc
                                //             .serviceRequestModel!
                                //             .serviceRequestDetails
                                //             .originalFees *
                                //         100
                                //     : 0,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: PrimaryDivider(),
                          ),
                          if (sRBloc.serviceRequestModel?.serviceRequestDetails
                                  .isWaitingTimeApplied ??
                              false) ...{
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.5),
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 1,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Text(
                                '${"Waiting Time".tr} : ${sRBloc.serviceRequestModel != null ? sRBloc.serviceRequestModel!.serviceRequestDetails.waitingTime : ''} ${"min".tr}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                            space20Vertical(),
                          },

                          // order details area
                          OrderCostWithPaymentStatus(
                            isOrderAccepted: widget.isOrderAccepted,
                          ),
                          space20Vertical(),

                          // order details area
                          Row(
                            children: [
                              Expanded(
                                child: OrderDetailsTextWidget(
                                  text: 'arrival time'.tr,
                                  value:
                                      '${sRBloc.driverPolylineResult != null ? sRBloc.driverPolylineResult!.durationInSec : ''} ${'min'.tr}',
                                ),
                              ),
                              Expanded(
                                child: OrderDetailsTextWidget(
                                  text: 'distance'.tr,
                                  value:
                                      '${sRBloc.driverPolylineResult != null ? sRBloc.driverPolylineResult!.distanceInKm : ''} ${'km'.tr}',
                                ),
                              ),
                              Expanded(
                                child: OrderDetailsTextWidget(
                                  isBold: true,
                                  text: 'total cost'.tr,
                                  value:
                                      '${sRBloc.serviceRequestModel != null ? sRBloc.serviceRequestModel!.serviceRequestDetails.fees.toString() : ''} ${'EGP'.tr}',
                                ),
                              ),
                            ],
                          ),
                          space20Vertical(),
                          if (!widget.isOrderAccepted)
                            Row(
                              children: [
                                Expanded(
                                  child: PrimaryButton(
                                    text: 'confirm'.tr,
                                    onPressed: () {},
                                  ),
                                ),
                                space10Horizontal(),
                                Expanded(
                                  child: PrimaryButton(
                                    text: 'cancel request'.tr,
                                    backgroundColor: Colors.black,
                                    onPressed: widget.onOrderAccepted ??
                                        () {
                                          showDeleteDialog(
                                            function: () {
                                              sRBloc.cancelServiceRequest();
                                            },
                                          );
                                        },
                                  ),
                                ),
                              ],
                            ),
                          if (widget.isOrderAccepted &&
                              !widget.isServiceInProgress) ...{
                            SizedBox(
                              child: PrimaryButton(
                                text: 'cancel request'.tr,
                                backgroundColor: Colors.black,
                                onPressed: widget.onOrderCanceled ??
                                    () {
                                      showDeleteDialog(
                                        function: () {
                                          sRBloc.cancelServiceRequest();
                                        },
                                      );
                                    },
                              ),
                            ),
                            space20Vertical(),
                          }
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80.0,
                          height: 60.0,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.isSlidingUpPanel
                                    ? sRBloc.driverPolylineResult != null
                                        ? sRBloc
                                            .driverPolylineResult!.durationInSec
                                            .toString()
                                        : ''
                                    : sRBloc.driverPolylineResult != null
                                        ? sRBloc
                                            .driverPolylineResult!.durationInSec
                                            .toString()
                                        : '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.tajawal(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                              Text(
                                'min'.tr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.tajawal(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadiusDirectional.only(
                                topEnd: Radius.circular(20),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 5),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Container(
                                  width: 40,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                space5Vertical(),
                                Text(
                                  ServiceRequestStatusEnum.values
                                      .firstWhere((element) =>
                                          element.name ==
                                          sRBloc.serviceRequestModel!
                                              .serviceRequestDetails.status)
                                      .value,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.tajawal(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0,
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
                ],
              ),
            ],
          );
        },
      );
    }

    return BlocBuilder<NewServiceRequestBloc, NewServiceRequestState>(
      builder: (context, state) {
        return PrimaryPadding(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // order number area
                  if (!widget.isOrderAccepted || !widget.isServiceInProgress)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 6,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Request ID'.tr,
                            style: GoogleFonts.tajawal(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).primaryColor,
                                fontStyle: FontStyle.normal,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          Text(
                            sRBloc.serviceRequestModel != null
                                ? sRBloc.serviceRequestModel!
                                    .serviceRequestDetails.id
                                    .toString()
                                : '',
                            style: GoogleFonts.tajawal(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).primaryColor,
                                fontStyle: FontStyle.normal,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // driver details area
                  if (widget.isOrderAccepted && widget.isServiceInProgress)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
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
                        space5Horizontal(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Driver Name'.tr,
                              style: GoogleFonts.tajawal(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                            RatingBar.builder(
                              initialRating: 3,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemSize: 20,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.green,
                              ),
                              onRatingUpdate: (rating) {
                                debugPrint(rating.toString());
                              },
                            ),
                          ],
                        ),
                        space20Horizontal(),
                        InkWell(
                          child: Image.asset(
                            'assets/imgs/callCenter.png',
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ],
                    ),

                  // discount area
                  DiscountWidget(
                    percentage: sRBloc.serviceRequestModel != null
                        ? sRBloc.serviceRequestModel?.serviceRequestDetails
                                    .originalFees !=
                                sRBloc.serviceRequestModel!
                                    .serviceRequestDetails.fees
                            ? (sRBloc.serviceRequestModel!.serviceRequestDetails
                                        .originalFees -
                                    sRBloc.serviceRequestModel!
                                        .serviceRequestDetails.fees) /
                                sRBloc.serviceRequestModel!
                                    .serviceRequestDetails.originalFees *
                                100
                            : 0
                        : 0,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: PrimaryDivider(),
              ),

              if (sRBloc.serviceRequestModel?.serviceRequestDetails
                      .isWaitingTimeApplied ??
                  false) ...{
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1,
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    '${"Waiting Time".tr} : ${sRBloc.serviceRequestModel != null ? sRBloc.serviceRequestModel!.serviceRequestDetails.waitingTime : ''} ${"min".tr}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.white),
                  ),
                ),
                space20Vertical(),
              },

              // order details area
              OrderCostWithPaymentStatus(
                isOrderAccepted: widget.isOrderAccepted,
              ),
              if (sRBloc.serviceRequestModel?.serviceRequestDetails
                      .isWaitingTimeApplied ??
                  false) ...{
                space20Vertical(),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1,
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    '${"Waiting Time".tr} : ${sRBloc.serviceRequestModel != null ? sRBloc.serviceRequestModel!.serviceRequestDetails.waitingTime : ''} ${"min".tr}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.white),
                  ),
                ),
              },

              space20Vertical(),

              // order details area
              Row(
                children: [
                  Expanded(
                    child: OrderDetailsTextWidget(
                      text: 'arrival time'.tr,
                      value:
                          '${sRBloc.driverPolylineResult != null ? sRBloc.driverPolylineResult!.durationInSec : ''} ${'min'.tr}',
                    ),
                  ),
                  Expanded(
                    child: OrderDetailsTextWidget(
                      text: 'distance'.tr,
                      value:
                          '${sRBloc.driverPolylineResult != null ? sRBloc.driverPolylineResult!.distanceInKm : ''} ${'km'.tr}',
                    ),
                  ),
                  Expanded(
                    child: OrderDetailsTextWidget(
                      isBold: true,
                      text: 'total cost'.tr,
                      value:
                          '${sRBloc.serviceRequestModel != null ? sRBloc.serviceRequestModel!.serviceRequestDetails.fees.toString() : ''} ${'EGP'.tr}',
                    ),
                  ),
                ],
              ),
              space20Vertical(),
              if (!widget.isOrderAccepted)
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        text: 'confirm'.tr,
                        isLoading: sRBloc.isUpdateServiceRequestLoading,
                        onPressed: () {
                          printWarning(
                              'Driver distance ==>> ${sRBloc.driverPolylineResult!.distance}');
                          printWarning(
                              'Driver duration ==>> ${sRBloc.driverPolylineResult!.duration}');

                          double driverDistance = sRBloc
                                      .driverPolylineResult!.distance
                                      .split(' ')[1] ==
                                  'm'
                              ? (double.parse(sRBloc
                                      .driverPolylineResult!.distance
                                      .split(' ')
                                      .first) /
                                  1000)
                              : double.parse(sRBloc
                                  .driverPolylineResult!.distance
                                  .split(' ')
                                  .first);

                          double configDistance =
                              double.parse(sRBloc.config!.distanceLimit!);

                          double driverDuration = sRBloc
                              .convertTimeToMins(
                                  time: sRBloc.driverPolylineResult!.duration)
                              .toDouble();
                          double configDuration =
                              double.parse(sRBloc.config!.durationLimit!);

                          printWarning(
                              '***************************************************');
                          printWarning(
                              'Driver distance ==> ${driverDistance} ');

                          printWarning('config distance ${configDistance}');

                          printWarning('Driver duration ==> ${driverDuration}');

                          printWarning('config duration ${configDuration}');
                          printWarning(
                              '***************************************************');
                          if ((driverDistance < configDistance) &&
                              (driverDuration < configDuration)) {
                            debugPrint('isOnlinePaymentOnly ==>> false');
                            sRBloc.isOnlinePaymentOnly = false;
                          } else {
                            debugPrint('isOnlinePaymentOnly ==>> true');
                            sRBloc.isOnlinePaymentOnly = true;
                          }

                          ///* 1- if (fees > 0 && there is a package ) => then show payment bottom sheet
                          if (sRBloc.serviceRequestModel!.serviceRequestDetails
                                      .fees >
                                  0 &&
                              sRBloc.selectedCar?.carPackages != null) {
                            sRBloc.isFeesEqualZero = false;
                            // sRBloc.isDiscountBiggerThanAmount = false;
                            sRBloc.showPaymentBottomSheet();
                          } else if (sRBloc.serviceRequestModel!
                                      .serviceRequestDetails.fees ==
                                  0 &&
                              sRBloc.selectedCar?.carPackages != null) {
                            ///* 2- if (fees == 0 && there is a package ) => then update service request without payment
                            sRBloc.isFeesEqualZero = true;
                            // sRBloc.isDiscountBiggerThanAmount = true;
                            debugPrint('isDiscountBiggerThanAmount ==>> true');
                            sRBloc.updateServiceRequest();
                            sRBloc.countOpenedBottomSheets += 1;
                          } else {
                            ///* 3- else Normal payment
                            printWarning('Normal payment');
                            sRBloc.isFeesEqualZero = false;
                            // sRBloc.isDiscountBiggerThanAmount = false;
                            sRBloc.showPaymentBottomSheet();
                          }
                        },
                      ),
                    ),
                    space10Horizontal(),
                    Expanded(
                      child: PrimaryButton(
                        text: 'cancel request'.tr,
                        backgroundColor: Colors.black,
                        isLoading: state is CancelServiceRequestLoadingState,
                        onPressed: widget.onOrderAccepted ??
                            () {
                              showDeleteDialog(
                                function: () {
                                  sRBloc.cancelServiceRequest();
                                },
                              );
                            },
                      ),
                    ),
                  ],
                ),
              if (widget.isOrderAccepted && !widget.isServiceInProgress)
                SizedBox(
                  child: PrimaryButton(
                    text: 'cancel request'.tr,
                    backgroundColor: Colors.black,
                    onPressed: widget.onOrderCanceled ??
                        () {
                          showDeleteDialog(
                            function: () {
                              sRBloc.cancelServiceRequest();
                            },
                          );
                        },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
