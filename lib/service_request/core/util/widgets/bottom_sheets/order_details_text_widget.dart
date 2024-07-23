import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDetailsTextWidget extends StatelessWidget {
  final String text;
  final String value;
  final bool isBold;
  Color? textColor;

  OrderDetailsTextWidget({
    super.key,
    required this.text,
    required this.value,
    this.isBold = false,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.tajawal(
            textStyle: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontStyle: FontStyle.normal,
              fontSize: 14.0,
            ),
          ),
        ),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.tajawal(
            textStyle: TextStyle(
              color: textColor == null
                  ? isBold
                      ? Colors.grey[600]
                      : Colors.grey
                  : textColor,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
              fontStyle: FontStyle.normal,
              fontSize: isBold ? 16.0 : 14.0,
            ),
          ),
        ),
      ],
    );
  }
}
