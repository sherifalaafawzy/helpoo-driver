import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../dataLayer/constants/variables.dart';

class selectPaymentMethod extends StatefulWidget {
  final String icon;
  final String title;
  final onChanged;
  final String value;
  final String? paymentGroup;
  selectPaymentMethod(
      {super.key,
      required this.title,
      required this.icon,
      required this.onChanged,
      required this.value,
      required this.paymentGroup});

  @override
  State<selectPaymentMethod> createState() => _selectPaymentMethodState();
}

class _selectPaymentMethodState extends State<selectPaymentMethod> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        height: 35,
        child: Image.asset(widget.icon),
      ),
      title: Column(
        children: [
          Text(
            widget.title,
            style: GoogleFonts.tajawal(
              textStyle: const TextStyle(
                color: appBlack,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 14,
              ),
            ),
          ),
          widget.value == "card-to-driver" || widget.value == "online-card"
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
      trailing: Radio(
          value: widget.value,
          groupValue: widget.paymentGroup,
          onChanged: widget.onChanged),
      onTap: () {
        widget.onChanged;
        debugPrint(widget.value);
      },
    );
  }
}
