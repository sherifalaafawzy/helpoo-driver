import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/constants.dart';

class DiscountWidget extends StatelessWidget {
  final double percentage;
  const DiscountWidget({
    super.key,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/imgs/discount.png',
          height: 30,
        ),
        space10Vertical(),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: Colors.grey.withOpacity(0.5),
              width: 1,
            ),
            color: Colors.green.withOpacity(0.4),
          ),
          child: Text(
            '${'discount'.tr} ${percentage.ceil()} %',
            style: GoogleFonts.tajawal(
              textStyle: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontStyle: FontStyle.normal,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
