import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'request_details_container_widget.dart';
import '../../../dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';
import '../../../dataLayer/constants/variables.dart';
import '../../pages/user_home_content/service_request/shared/basic_fees_widget.dart';
import '../../pages/user_home_content/service_request/shared/discount_widget.dart';

class serviceDoneCancelled extends StatelessWidget {
  const serviceDoneCancelled({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ServiceRequestBloc>(context);

    return RequestDetailsContainerWidget(
      height: 240,
      child: cubit.request.done
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                BasicFeesWidget(),
                const SizedBox(height: 18),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'total cost'.tr,
                              style: GoogleFonts.tajawal(
                                textStyle: const TextStyle(
                                  color: appBlack,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              cubit.request.fees.toString() + " " + "egp".tr,
                              style: GoogleFonts.tajawal(
                                textStyle: const TextStyle(
                                  color: mainColor,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ]),
                      const SizedBox(width: 30),
                      DiscountWidget(),
                    ]),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: Center(
                    child: Text(
                      'canceled'.tr,
                      style: GoogleFonts.tajawal(
                        textStyle: const TextStyle(
                          color: mainColor,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 18.0,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
