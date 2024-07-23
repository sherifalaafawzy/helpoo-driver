import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../dataLayer/constants/variables.dart';

import '../../../../../dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';

class RequestIdWidget extends StatelessWidget {
  const RequestIdWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ServiceRequestBloc>(context);

    return Container(
      width: 150,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(13)),
        border: Border.all(color: mainColor, width: 1),
        color: appWhite,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Request ID : '.tr,
            style: GoogleFonts.tajawal(
              textStyle: const TextStyle(
                color: mainColor,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontSize: 18.0,
              ),
            ),
          ),
          Text(
            '${cubit.request.id}',
            style: GoogleFonts.tajawal(
              textStyle: const TextStyle(
                color: mainColor,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
