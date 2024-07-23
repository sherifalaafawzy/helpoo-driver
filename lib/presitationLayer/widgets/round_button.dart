// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../dataLayer/constants/variables.dart';

class RoundButton extends StatelessWidget {
  RoundButton({
    Key? key,
    required this.onPressed,
    required this.padding,
    required this.text,
    required this.color,
    this.isWaiting = false,
    this.isLoading = false,
  }) : super(key: key);
  final Function onPressed;
  final bool padding;
  final String text;
  final Color color;
  final bool isWaiting;
  final bool isLoading;

  DateTime? tappedTime;

  @override
  Widget build(BuildContext context) {
    bool isRedundentClick(DateTime currentTime) {
      if (tappedTime == null) {
        tappedTime = currentTime;
        debugPrint("first click");

        return false;
      }
      debugPrint('secoend click');
      if (currentTime.difference(tappedTime!).inSeconds < 10) {
        return true;
      }
      tappedTime = currentTime;
      debugPrint('secoend click');

      return false;
    }

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: padding ? 39.0 : 0),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: color,
            width: 1,
          ),
        ),
        height: 48,
        color: color,
        elevation: 0,
        onPressed: () async {
          if (isWaiting) {
            if (isRedundentClick(DateTime.now())) {
              debugPrint('hold on, processing');
              return;
            }
          }

          await onPressed();
        },
        child: isLoading
            ? CupertinoActivityIndicator(
                color: appWhite,
              )
            : Text(
                text.tr,
                style: GoogleFonts.tajawal(
                  textStyle: const TextStyle(
                    color: appWhite,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}

class RoundButtonUnchecked extends StatefulWidget {
  const RoundButtonUnchecked({
    Key? key,
    required this.onPressed,
    required this.padding,
    required this.text,
    required this.color,
  }) : super(key: key);
  final Function onPressed;
  final bool padding;
  final String text;
  final Color color;

  @override
  State<RoundButtonUnchecked> createState() => _RoundButtonUncheckedState();
}

class _RoundButtonUncheckedState extends State<RoundButtonUnchecked> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.all(widget.padding ? 16.0 : 0),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: mainColor,
            width: 1,
          ),
        ),
        // height: 48,
        color: widget.color,
        elevation: 0,
        onPressed: () async {
          await widget.onPressed();

          setState(() {});
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  MdiIcons.checkboxBlank,
                  color: appWhite,
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    widget.text.tr,
                    style: GoogleFonts.tajawal(
                      textStyle: const TextStyle(
                        color: appWhite,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoundButtonChecked extends StatefulWidget {
  const RoundButtonChecked({
    Key? key,
    required this.onPressed,
    required this.padding,
    required this.text,
    required this.color,
  }) : super(key: key);
  final Function onPressed;
  final bool padding;
  final String text;
  final Color color;

  @override
  State<RoundButtonChecked> createState() => _RoundButtonCheckedState();
}

class _RoundButtonCheckedState extends State<RoundButtonChecked> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.all(widget.padding ? 16.0 : 0),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: widget.color,
            width: 1,
          ),
        ),
        // height: 48,
        color: widget.color,
        elevation: 0,
        onPressed: () async {
          await widget.onPressed();
        },
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  MdiIcons.checkboxMarked,
                  color: appWhite,
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    widget.text.tr,
                    style: GoogleFonts.tajawal(
                      textStyle: const TextStyle(
                        color: appWhite,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OutlineButton extends StatelessWidget {
  var function;
  String title;
  OutlineButton({Key? key, required this.function, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: Get.height * 6 / 100,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            side: BorderSide(
              width: 1,
              color: mainColor,
              style: BorderStyle.solid,
            ),
          ),
          onPressed: function,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: GoogleFonts.tajawal(),),
            ],
          ),
        ),
      ),
    );
  }
}
