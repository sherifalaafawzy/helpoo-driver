import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../dataLayer/models/currentUser.dart';
import '../../dataLayer/bloc/app/app_bloc.dart';

import '../../dataLayer/models/vehicle.dart';
import '../../dataLayer/models/serviceReqest.dart';
import 'shared/waitingPage.dart';
import '../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../../dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';
import '../../dataLayer/constants/variables.dart';
import '../../dataLayer/models/FNOL.dart';
import '../widgets/FNOL/latestFnol.dart';
import '../widgets/serviceRequest/latestRequests.dart';
import '../widgets/help_buttons.dart';
import 'user_home_content/service_type.dart';

class userHome extends StatefulWidget {
  const userHome({Key? key}) : super(key: key);

  @override
  State<userHome> createState() => userHomeState();
}

class userHomeState extends State<userHome> {
  bool fnol = false;
  bool working = true;
  List<ServiceRequest> requests = [];
  List<FNOL> fNOLList = [];

  bool isGetHomeDataLoading = false;

  @override
  void initState() {
    super.initState();
    Vehicle.addVehicle = false;
    var bloc = BlocProvider.of<FnolBloc>(context);
    var cubit = BlocProvider.of<ServiceRequestBloc>(context);
    var appBloc = BlocProvider.of<AppBloc>(context);

    getLatestFNOL(bloc);
    getLatestRequests(cubit, appBloc);
    Vehicle.modelList = [];
    Vehicle.returnedSelectedModel = false;
  }

  void getLatestRequests(cubit, appBloc) async {
    if (mounted) {
      setState(() {
        isGetHomeDataLoading = true;
      });
    }
    if (CurrentUser.isCorporate) {
      requests = await cubit.getLatestCorporate();
    } else {
      requests = await cubit.getLatestClient();
    }
    if (mounted) {
      setState(() {
        working = false;
      });
    }
    if (mounted) {
      setState(() {
        isGetHomeDataLoading = false;
      });
    }
  }

  void getLatestFNOL(bloc) async {
    if (mounted) {
      setState(() {
        isGetHomeDataLoading = true;
      });
    }
    fNOLList = await bloc.getLatest(bloc);
    if (mounted) {
      setState(() {
        fNOLList = fNOLList;
        working = false;
      });
    }
    if (mounted) {
      setState(() {
        isGetHomeDataLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<FnolBloc>(context);
    var cubit = BlocProvider.of<ServiceRequestBloc>(context);
    var appBloc = BlocProvider.of<AppBloc>(context);

    if (working) {
      return waitingWidget();
    } else {
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            if (!CurrentUser.isCorporate) getLatestFNOL(bloc);
            getLatestRequests(cubit, appBloc);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 10),
              Container(
                width: Get.width,
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  'please select service'.tr,
                  style: GoogleFonts.tajawal(
                    textStyle: const TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.normal,
                      fontSize: 18.0,
                    ),
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              chooseYourServices(),
              helpButtons(),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 12.0, end: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: mainColor,
                            border: !fnol
                                ? Border.all(
                                    color: appBlack,
                                    width: 3,
                                  )
                                : Border.all(color: appDarkGrey, width: 2),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5))),
                        width: 150,
                        height: 40,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              fnol = false;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'latest request'.tr,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: GoogleFonts.tajawal(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (!CurrentUser.isCorporate)
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: mainColor,
                              border: fnol
                                  ? Border.all(
                                      color: appBlack,
                                      width: 3,
                                    )
                                  : Border.all(color: appDarkGrey, width: 2),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5))),
                          width: 150,
                          height: 40,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                fnol = true;
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'latest reports'.tr,
                                  style: GoogleFonts.tajawal(
                                    textStyle: TextStyle(
                                      color: appWhite,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                  color: fnol ? Colors.transparent : mainColor,
                                ))
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: isGetHomeDataLoading
                    ? Center(
                        child: CupertinoActivityIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : SizedBox(
                        height: Get.height * .3,
                        child: Column(
                          children: [
                            Expanded(
                              child: !fnol
                                  ? requests.isEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            "no requests to show".tr,
                                            style: GoogleFonts.tajawal(
                                              textStyle: const TextStyle(
                                                color: appBlack,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 15.0,
                                              ),
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        )
                                      : ListView.separated(
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          itemCount: requests.length,
                                          itemBuilder: (context, index) {
                                            return latestRequests(
                                              requests[index],
                                              index: index,
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return Divider(
                                              color: appGrey,
                                              thickness: 1,
                                              indent: 10,
                                              endIndent: 10,
                                            );
                                          }
                                          // children: [
                                          //   ...List<Widget>.from(requests
                                          //       .map((req) => latestRequests(req)))
                                          // ],
                                          )
                                  : fNOLList.isEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            "no reports to show".tr,
                                            style: GoogleFonts.tajawal(
                                              textStyle: const TextStyle(
                                                color: appBlack,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 15.0,
                                              ),
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        )
                                      : ListView(
                                          children: [
                                            ...List<Widget>.from(fNOLList.map(
                                                (fnol) => latestFnol(fnol)))
                                          ],
                                        ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
