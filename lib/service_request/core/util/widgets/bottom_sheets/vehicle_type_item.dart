import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/constants.dart';

class VehicleTypeItem extends StatefulWidget {
  final String title;
  final String price;
  final String image;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDiscount;
  String? priceBeforeDiscount;

  VehicleTypeItem({
    super.key,
    required this.title,
    required this.price,
    required this.image,
    required this.isSelected,
    required this.onTap,
    this.isDiscount = false,
    this.priceBeforeDiscount,
  });

  @override
  State<VehicleTypeItem> createState() => _VehicleTypeItemState();
}

class _VehicleTypeItemState extends State<VehicleTypeItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Row(
        children: [
          Image.asset(
            'assets/imgs/${widget.image}.png',
            height: 80,
          ),
          space20Horizontal(),
          Expanded(
            child: Text(
              widget.title,
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
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.4),
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            child: widget.isDiscount
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${widget.priceBeforeDiscount}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.tajawal(
                          textStyle: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0,
                            height: 1.5,
                          ),
                        ),
                      ),
                      space5Horizontal(),
                      Text(
                        '/ ${widget.price} ${'EGP'.tr}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.tajawal(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  )
                : Text(
                    '${widget.price} ${'EGP'.tr}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.tajawal(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0,
                        height: 1.5,
                      ),
                    ),
                  ),
          ),
          space30Horizontal(),
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
