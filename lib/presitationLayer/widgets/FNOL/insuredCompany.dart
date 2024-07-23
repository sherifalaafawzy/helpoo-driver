import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../dataLayer/constants/variables.dart';

class fNOLDataCard extends StatelessWidget {
  const fNOLDataCard(
    this.title,
    this.subtitle, {
    Key? key,
  }) : super(key: key);
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: mainColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            isThreeLine: true,
            title: Text(
              title,
              style: GoogleFonts.tajawal(
                textStyle: const TextStyle(
                  color: appBlack,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 4.0,
                    right: 4.0,
                  ),
                  child: Text(
                    subtitle,
                    style: GoogleFonts.tajawal(
                      textStyle: const TextStyle(
                        color: appBlack,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
