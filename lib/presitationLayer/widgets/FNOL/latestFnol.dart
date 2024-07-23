import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import '../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../../../dataLayer/constants/variables.dart';
import '../../../dataLayer/models/FNOL.dart';
import '../../pages/user_home_content/FNOL/FNOLSummary.dart';
import '../../pages/user_home_content/FNOL/fnolSteps.dart';
import 'package:intl/date_symbol_data_local.dart';

class latestFnol extends StatefulWidget {
  final FNOL req;

  const latestFnol(
    this.req, {
    Key? key,
  }) : super(key: key);

  @override
  State<latestFnol> createState() => latestFnolState();
}

class latestFnolState extends State<latestFnol> {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<FnolBloc>(context);
    initializeDateFormatting();

    return Container(
        // height: Get.height * .13,
        padding: const EdgeInsetsDirectional.only(
          start: 10,
          end: 10,
          top: 6,
          bottom: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: Get.height * .07,
                  width: Get.width * .15,
                  child: Stack(
                    children: [
                      Image.asset('assets/imgs/Ellipse.png'),
                      Positioned.fill(
                          child: Image.asset('assets/imgs/ic_build.png')),
                    ],
                  ),
                ),
                Text(
                  "# " + widget.req.id.toString(),
                  style: GoogleFonts.tajawal(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0,
                    ),
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.req.selectedCar?.manufacture!.name ?? ''} ${widget.req.selectedCar?.model!.name ?? ''}',
                  style: GoogleFonts.tajawal(
                    textStyle: const TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0,
                    ),
                  ),
                  textAlign: TextAlign.start,
                ),
                Text(
                  intl.DateFormat(
                          "dd / M / yyyy  hh:mm a", Get.locale!.languageCode)
                      .format(widget.req.createdAt!.toLocal()),
                  style: GoogleFonts.tajawal(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 13.0,
                    ),
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  width: Get.width * .53,
                  child: Text(
                    widget.req.addressLatLng!.address.toString(),
                    style: GoogleFonts.tajawal(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 12.0,
                      ),
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 38,
                  width: 90,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: TextButton(
                    onPressed: () {
                      Get.to(() => fnolSummary(
                            fnol: widget.req,
                          ));
                    },
                    child: Text(
                      "Details".tr,
                      style: GoogleFonts.tajawal().copyWith(
                        fontSize: 13.0,
                        color: appBlack,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 38,
                  width: 90,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: TextButton(
                    onPressed: () {
                      bloc.fnol = widget.req;

                      Get.to(() => fNOLSteps(
                            fnol: bloc.fnol,
                          ));
                    },
                    child: Text(
                      "Continue".tr,
                      style: GoogleFonts.tajawal().copyWith(
                        fontSize: 13.0,
                        color: appBlack,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
