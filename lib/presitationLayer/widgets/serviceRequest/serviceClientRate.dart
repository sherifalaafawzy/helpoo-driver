import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';
import '../../../dataLayer/constants/variables.dart';
import '../../pages/homeScreen.dart';
import '../round_button.dart';

class serviceClientRate extends StatelessWidget {
  const serviceClientRate({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ServiceRequestBloc>(context);

    return Center(
      child: SizedBox(
        width: Get.width * .9,
        height: 330,
        child: Card(
            color: appWhite,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "please rate the driver".tr,
                    style: GoogleFonts.tajawal(
                      textStyle: const TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      cubit.request.driver.photo == null
                          ? Icon(
                              MdiIcons.accountCircle,
                              color: mainColor,
                              size: 32,
                            )
                          : Container(
                              width: 48,
                              height: 48,
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(0)),
                                    border:
                                        Border.all(color: mainColor, width: 2),
                                    color: appWhite,
                                  ),
                                  child: Image.network(
                                      cubit.request.driver.photo!)),
                            ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10.0, right: 5, left: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              cubit.request.driver.name!,
                              style: GoogleFonts.tajawal(
                                textStyle: const TextStyle(
                                  color: appBlack,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0,
                                ),
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  RatingBar.builder(
                    initialRating: 0,
                    itemSize: 22,
                    minRating: 1,
                    maxRating: 5,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    updateOnDrag: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: mainColor,
                    ),
                    onRatingUpdate: (rating) {
                      cubit.request.rating = rating;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    onChanged: (v) {
                      cubit.request.comment = v;
                    },
                    maxLines: 3,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(13),
                        ),
                        borderSide: BorderSide(
                          color: Color(0xff707070),
                          width: 1,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(8),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(13),
                        ),
                        borderSide: BorderSide(
                          color: Color(0xff707070),
                          width: 1,
                        ),
                      ),
                      hintText: "add comment".tr,
                    ),
                  ),
                  const SizedBox(height: 16),
                  RoundButton(
                      onPressed: () async {
                        bool success = await cubit.rateRequest();
                        if (success) {
                          Get.to(() => homeScreen(
                                index: 0,
                              ));
                        } else {
                          HelpooInAppNotification.showErrorMessage(
                              message: "Submit rate again".tr);
                          // Get.snackbar("Error".tr, "Submit rate again".tr);
                        }
                      },
                      padding: true,
                      text: "Submit".tr,
                      color: mainColor)
                ],
              ),
            )),
      ),
    );
  }
}
