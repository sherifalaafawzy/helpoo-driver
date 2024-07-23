// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/constants.dart';
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';
import 'package:helpoo/service_request/core/util/cubit/state.dart';
import 'package:helpoo/service_request/core/util/extensions/build_context_extension.dart';
import 'package:helpoo/service_request/core/util/routes.dart';
import 'package:intl/intl.dart' as intl;
import '../../../dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';
import '../../../dataLayer/constants/enum.dart';
import '../../../dataLayer/models/serviceReqest.dart';
import '../../../dataLayer/constants/variables.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../pages/user_home_content/service_request/sRMapPicker.dart';

class latestRequests extends StatefulWidget {
  final ServiceRequest req;
  final int index;

  const latestRequests(
    this.req, {
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<latestRequests> createState() => latestRequestsState();
}

class latestRequestsState extends State<latestRequests> {
  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ServiceRequestBloc>(context);
    initializeDateFormatting('');
    return BlocConsumer<NewServiceRequestBloc, NewServiceRequestState>(
      listener: (context, state) {
        if (state is GetCurrentActiveServiceRequestSuccessState) {
          if (sRBloc.currentLoadingIndex == widget.index) {
            context.pushNamedAndRemoveUntil = Routes.serviceRequestMap;
          }

          // debugPrint("------------------ 1");
          // if (mounted) {
          //   context.pushNamedAndRemoveUntil =
          //       Routes.serviceRequestMap;
          // }
        }

        if (state is CancelServiceRequestSuccessState) {
          setState(() {
            widget.req.status = ServiceRequestStatus.canceled;
          });
        }
      },
      builder: (context, state) {
        return Container(
            // height: Get.height * .12,
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
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Wench Service".tr,
                        style: GoogleFonts.tajawal(
                          textStyle: const TextStyle(
                            color: Color(0xff53A948),
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.normal,
                            fontSize: 18.0,
                          ),
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        widget.req.status.toString().split(".")[1].tr,
                        style: GoogleFonts.tajawal(
                          textStyle: const TextStyle(
                            color: Color(0xff53A948),
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        widget.req.createdAt != null
                            ? intl.DateFormat("dd / M / yyyy  hh:mm a",
                                    Get.locale!.languageCode)
                                .format(widget.req.createdAt!.toLocal())
                            : "",
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
                          widget.req.destinationAddress ?? "",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
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
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      child: Container(
                        height: 38,
                        width: 90,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 2,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: TextButton(
                          onPressed: () async {
                            if (widget.req.canceled || widget.req.done) {
                              cubit.request = widget.req;
                              if (cubit.request.driver == null) {
                                await cubit.getDriver();
                              }
                              cubit.changeStateTo(GetMap());
                              // cubit.emit(GetMap());
                              Get.to(() => serviceRMapPicker(
                                    isUpdatedRequest: true,
                                  ));
                            } else {
                              // sRBloc.CORPORATE_REQUEST_ID = widget.req.id!;
                              // context.pushNamed = Routes.serviceRequestMap;

                              // sRBloc.clearOnStart();
                              sRBloc.currentLoadingIndex = widget.index;
                              sRBloc.getCurrentActiveServiceRequest(
                                reqID: widget.req.id!,
                              );
                            }
                          },
                          child: sRBloc.isGetSRLoading &&
                                  widget.index == sRBloc.currentLoadingIndex
                              ? Center(
                                  child: CupertinoActivityIndicator(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )
                              : Text(
                                  (widget.req.canceled || widget.req.done)
                                      ? "Details".tr
                                      : "Update".tr,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: appBlack,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: !widget.req.canceled &&
                          !widget.req.done &&
                          !widget.req.arrived &&
                          !widget.req.started
                      //  && !widget.req.pending
                      ,
                      child: Container(
                        height: 38,
                        width: 90,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 2,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: TextButton(
                          onPressed: () {
                            // showDialog(
                            //     context: context,
                            //     builder: (BuildContext context) {
                            //       return Dialog(
                            //         shape: RoundedRectangleBorder(
                            //             borderRadius:
                            //                 BorderRadius.circular(20.0)),
                            //         child: Container(
                            //           height: Get.height * 0.2,
                            //           child: Padding(
                            //             padding: const EdgeInsets.all(20),
                            //             child: Column(
                            //               mainAxisAlignment:
                            //                   MainAxisAlignment.spaceAround,
                            //               crossAxisAlignment:
                            //                   CrossAxisAlignment.center,
                            //               children: [
                            //                 Text(
                            //                   "Are You Sure to Cancel This Request?"
                            //                       .tr,
                            //                   style: TextStyle(
                            //                     fontSize: 14.0,
                            //                     color: appBlack,
                            //                     fontWeight: FontWeight.w700,
                            //                   ),
                            //                 ),
                            //                 Row(
                            //                   mainAxisAlignment:
                            //                       MainAxisAlignment.center,
                            //                   children: [
                            //                     RoundButton(
                            //                         onPressed: () async {
                            //                           bool success = await cubit
                            //                               .cancelRequest(
                            //                                   widget.req);
                            //                           if (success) {
                            //                             setState(() {
                            //                               widget.req.status =
                            //                                   ServiceRequestStatus
                            //                                       .canceled;
                            //                             });
                            //                             cubit.request =
                            //                                 ServiceRequest();
                            //                             Get.back();
                            //                           } else {
                            //                             Get.snackbar("Error",
                            //                                 "Please try again");
                            //                             Get.back();
                            //                           }
                            //                         },
                            //                         padding: false,
                            //                         text: 'yes'.tr,
                            //                         color: mainColor),
                            //                     SizedBox(
                            //                       width: Get.width * .1,
                            //                     ),
                            //                     RoundButton(
                            //                         onPressed: () async {
                            //                           Get.back();
                            //                         },
                            //                         padding: false,
                            //                         text: 'NO'.tr,
                            //                         color: appBlack),
                            //                   ],
                            //                 ),
                            //               ],
                            //             ),
                            //           ),
                            //         ),
                            //       );
                            //     });

                            showDeleteDialog(
                              function: () {
                                sRBloc.cancelServiceRequest(id: widget.req.id!);
                              },
                            );
                          },
                          child: Text(
                            "Cancel".tr,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.red,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ));
      },
    );
  }
}
