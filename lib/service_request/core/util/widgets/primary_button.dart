import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/constants.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isDisabled;
  final bool isIconButton;
  final IconData? icon;
  final Color? backgroundColor;
  final double? width;

  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isIconButton = false,
    this.isDisabled = false,
    this.icon,
    this.backgroundColor,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: 43.0,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: MaterialButton(
        onPressed: isDisabled
            ? null
            : () {
                if (!isLoading) {
                  onPressed();
                }
              },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading && isIconButton)
              const CupertinoActivityIndicator(
                color: Colors.white,
              ),
            if (isIconButton) const Spacer(),
            Text(
              text,
              style: GoogleFonts.tajawal(
                textStyle: const TextStyle(
                  color: whiteColor,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 16.0,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            if (isLoading && !isIconButton)
              const SizedBox(
                width: 10,
              ),
            if (isLoading && !isIconButton)
              const CupertinoActivityIndicator(
                color: Colors.white,
              ),
            if (isIconButton) const Spacer(),
            if (isIconButton)
              Icon(
                icon,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}
