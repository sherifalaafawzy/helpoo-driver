import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';
import '../../../dataLayer/constants/variables.dart';
import '../../pages/user_home_content/service_request/shared/basic_fees_widget.dart';
import '../../pages/user_home_content/service_request/shared/discount_widget.dart';
import '../driverData.dart';
import 'cancelWithConfirmBottomSheet.dart';
import 'counters_widget.dart';
import 'request_details_container_widget.dart';

class serviceAcceptedArrivedStarted extends StatelessWidget {
  const serviceAcceptedArrivedStarted({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ServiceRequestBloc>(context);

    return RequestDetailsContainerWidget(
      height: Get.height * .35,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 14.5),
              driverData(
                request: cubit.request,
              ),
              const Spacer(),
              DiscountWidget(),
              const SizedBox(width: 23),
            ],
          ),
          const SizedBox(height: 7),
          BasicFeesWidget(),
          const SizedBox(height: 18),
          CountersWidget(),
          Visibility(
            visible: !cubit.request.arrived && !cubit.request.started,
            child: Expanded(
              child: Center(
                child: SizedBox(
                  width: 175,
                  height: 43,
                  child: MaterialButton(
                      color: appBlack,
                      child: Text(
                        "cancel request".tr,
                        style: GoogleFonts.tajawal(
                          textStyle: const TextStyle(
                            color: appWhite,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                              Get.bottomSheet(cancelWithConfirmBottomSheet());

                      }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
