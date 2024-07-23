import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';
import '../../dataLayer/constants/variables.dart';

class paymentListTile extends StatefulWidget {
  final String title;
  final String value;
  const paymentListTile({
    super.key,
     required this.value,
      required this.title});

  @override
  State<paymentListTile> createState() => _paymentListTileState();
}

class _paymentListTileState extends State<paymentListTile> {
  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ServiceRequestBloc>(context);
    return Visibility(
      // visible: int.parse(ServiceRequest.distanceValue) / 1000 <= 55,
      child: 
      ListTile(
        leading: SizedBox(
          height: 35,
          child: Image.asset(widget.value == "card-to-driver"
              ? 'assets/imgs/pos.png'
              : 'assets/imgs/cash.png'),
        ),
        title: Column(
          children: [
            Text(
              widget.title.tr,
              style: GoogleFonts.tajawal(
                textStyle: const TextStyle(
                  color: appBlack,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0,
                ),
              ),
            ),
            widget.value == "card-to-driver"
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "visa master card".tr,
                      style: GoogleFonts.tajawal(
                        textStyle: const TextStyle(
                          color: appBlack,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 10.0,
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
        trailing: Radio<String>(
          value: widget.value,
          groupValue: cubit.request.paymentMethod,
          onChanged: (String? value) {
            setState(() {
              cubit.request.paymentMethod = value!;
            });
          },
        ),
        onTap: () async {
          setState(() {
            cubit.request.paymentMethod = "cash";
          });
        },
      ),
    );
  }
}
