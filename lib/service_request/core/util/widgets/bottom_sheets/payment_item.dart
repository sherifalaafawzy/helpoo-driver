import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/constants.dart';

class PaymentItem extends StatefulWidget {
  final String title;
  final String image;
  final bool isSelected;
  final VoidCallback onTap;
  const PaymentItem({
    super.key,
    required this.title,
    required this.image,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<PaymentItem> createState() => _PaymentItemState();
}

class _PaymentItemState extends State<PaymentItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Row(
        children: [
          Image.asset(
            'assets/imgs/${widget.image}.png',
            height: 40,
            width: 40,
          ),
          space20Horizontal(),
          Text(
            widget.title,
            style: GoogleFonts.tajawal(
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontStyle: FontStyle.normal,
                fontSize: 14.0,
              ),
            ),
          ),
          const Spacer(),
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.black.withOpacity(0.7),
                width: 2,
              ),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(2),
            child: Visibility(
              visible: widget.isSelected,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
