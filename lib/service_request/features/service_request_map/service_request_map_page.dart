// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/dataLayer/models/currentUser.dart';
import 'package:helpoo/presitationLayer/pages/homeScreen.dart';
import 'package:helpoo/service_request/core/util/constants.dart';
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';
import 'package:helpoo/service_request/core/util/prints.dart';
import 'package:helpoo/service_request/core/util/widgets/main_scaffold.dart';
import 'package:helpoo/service_request/features/service_request_map/widgets/service_request_map_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ServiceRequestMapPage extends StatefulWidget {
  const ServiceRequestMapPage({Key? key}) : super(key: key);

  @override
  State<ServiceRequestMapPage> createState() => _ServiceRequestMapPageState();
}

class _ServiceRequestMapPageState extends State<ServiceRequestMapPage> {
  @override
  void initState() {
    super.initState();
    debugPrint('ServiceRequestMapPage --- initState');

    if (sRBloc.serviceRequestModel != null) {
      debugPrint('serviceRequestModel is not null');
      sRBloc.handleCurrentRequestUi(isFirstTime: true);
    }

    if (sRBloc.serviceRequestModel == null) {
      debugPrint('serviceRequestModel is null');
      sRBloc.clearOnStart();
    }

    // if (sRBloc.currentPosition == null && sRBloc.serviceRequestModel == null) {
    //   // sRBloc.setMyLocation();
    //   sRBloc.getConfig();
    // }

    // sl<CacheHelper>().clear('CURRENT_REQUEST_ID');

    // if (sRBloc.timer != null) {
    //   sRBloc.timer!.cancel();
    // }
    // sl<CacheHelper>().clear('CURRENT_REQUEST_ID');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        sRBloc.countOpenedBottomSheets = 0;
        if (sRBloc.timer != null) {
          sRBloc.timer!.cancel();
        }

        if (sRBloc.serviceRequestModel != null) {
          if (sRBloc.serviceRequestModel!.serviceRequestDetails.status ==
              ServiceRequestStatusEnum.open.name) {
            sRBloc.cancelServiceRequest();
          }
        }

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => homeScreen(
              index: 0,
            ),
          ),
          (Route<dynamic> route) => false,
        );

        return false;
      },
      child: MainScaffold(
        scaffold: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
            leading: Container(
              height: 48,
              width: 48,
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: IconButton(
                  onPressed: () async {
                    sRBloc.countOpenedBottomSheets = 0;
                    if (sRBloc.timer != null) {
                      sRBloc.timer!.cancel();
                    }
                    if (sRBloc.serviceRequestModel != null) {
                      if (sRBloc.serviceRequestModel!.serviceRequestDetails
                              .status ==
                          ServiceRequestStatusEnum.open.name) {
                        sRBloc.cancelServiceRequest();
                      }
                    }
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => homeScreen(
                          index: 0,
                        ),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  icon: Icon(
                    CurrentUser.isArabic
                        ? MdiIcons.arrowRightThin
                        : MdiIcons.arrowLeftThin,
                    color: whiteColor,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  sRBloc.getCurrentActiveServiceRequest(
                      reqID:
                          sRBloc.serviceRequestModel!.serviceRequestDetails.id);
                },
                icon: Icon(
                  Icons.refresh,
                  color: whiteColor,
                ),
              ),
            ],
            title: Text(
              true ? 'Select Your Location'.tr : 'status'.tr,
              style: GoogleFonts.tajawal(
                textStyle: const TextStyle(
                  color: whiteColor,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          body: ServiceRequestMapWidget(),
        ),
      ),
    );
  }
}
