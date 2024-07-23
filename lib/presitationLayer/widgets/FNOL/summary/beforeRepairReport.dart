import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../imageView.dart';
import 'repairReport.dart';
import '../../../../dataLayer/Constants/variables.dart';
import '../../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import 'dart:io' as io;

class beforeRepairReport extends StatelessWidget {
  const beforeRepairReport({super.key});

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<FnolBloc>(context);

    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Text(
                "before repair report".tr,
                style: GoogleFonts.tajawal(
                  textStyle: const TextStyle(
                    color: appBlack,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontSize: 18.0,
                  ),
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Spacer(),
            bloc.fnol.repairReportImages.length > 0 &&
                    bloc.fnol.beforeRepairAddress != null
                ? SizedBox()
                : InkWell(
                    onTap: () {
                      Get.to(() => repairReport(
                            bloc.fnol,
                            type: 'beforeRepair',
                          ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: Text(
                        "request report".tr,
                        style: GoogleFonts.tajawal(
                          textStyle: const TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0,
                          ),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
          ],
        ),
        SizedBox(height: 8),
        bloc.fnol.repairReportImages.length == 0
            ? SizedBox(
                height: 60,
                child: Center(
                  child: Text(
                    'no repair report yet'.tr,
                    style: GoogleFonts.tajawal(
                      textStyle: const TextStyle(
                        color: appBlack,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(height: 116, child: buildListView(bloc)
                    // ListView.builder(
                    //   scrollDirection: Axis.horizontal,
                    //   itemCount: 10,
                    //   // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //   //     crossAxisCount: 2),
                    //   itemBuilder: (_, idx) =>
                    //       bloc.fnol.repairReportImages.length > idx
                    //           ? Padding(
                    //               padding:
                    //                   const EdgeInsets.symmetric(horizontal: 8.0),
                    //               child: submittedImages(
                    //                   img: bloc.fnol.repairReportImages[idx]),
                    //             )
                    //           : Container(),
                    // ),
                    ),
              ),
        bloc.fnol.beforeRepairAddress == null
            ? SizedBox()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'repair location'.tr,
                      style: GoogleFonts.tajawal(
                        textStyle: const TextStyle(
                          color: appBlack,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      bloc.fnol.beforeRepairAddress ??
                          'no location name'.tr,
                      style: GoogleFonts.tajawal(
                        textStyle: const TextStyle(
                          color: mainColor,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    // Text(
                    //   bloc.fnol.beforeRepairAddress ??
                    //       'not submitted' +
                    //           " " +
                    //           (bloc.fnol.beforeRepairAddress ?? ''),
                    //   style: GoogleFonts.tajawal(
                    //     textStyle: const TextStyle(
                    //       color: appBlack,
                    //       fontWeight: FontWeight.w400,
                    //       fontStyle: FontStyle.normal,
                    //       fontSize: 15.0,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
      ],
    );
  }
}

Widget buildListView(bloc) {
  if (bloc.fnol.repairReportImages.isEmpty) {
    return Container();
  }
  return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: bloc.fnol.repairReportImages.length,
      itemBuilder: (ctx, idx) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: buildImageItem(idx, bloc),
        );
      });
}

Widget buildImageItem(int idx, bloc) {
  if (bloc.fnol.repairReportImages == null) {
    return Container();
  }
  var key = bloc.fnol.repairReportImages![idx];
  String? img = bloc.fnol.getImageObject(key);
  // String desc = bloc.fnol.getImageDescription(key);
  if (img == null) {
    return FutureBuilder<String?>(
      future: bloc.fnol.getImage('repair_before' + (idx).toString()),
      builder: (ctx, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if ((snapshot.data == null || snapshot.data!.isEmpty) &&
            bloc.fnol.getImageDescription(key) == "air_bag_images") {
          return const SizedBox();
        }
        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return Text(bloc.fnol.getImageDescription(key));
        } else {
          return Column(
            children: [
              // Text(key),
              Container(
                  height: 100,
                  child:
                      //  Text('desc')
                      Image.file(
                    io.File(snapshot.data!),
                    fit: BoxFit.cover,
                  )),
              // Text(desc),
              // Image.asset(snapshot.data!),
            ],
          );
        }
      },
    );
  }
  return GestureDetector(
    onTap: () {
      Get.to(imageView(img: img));
      // showImageViewer(context, NetworkImage(img.data.attributes.url));
      // showImageViewer(context, AssetImage('asstes/imgs/City driver-amico.png'));
    },
    child: Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            12,
          ),
        ),
        color: appWhite,
      ),
      child: Column(
        children: [
          Container(
            width: 263,
            height: 182,
            decoration: BoxDecoration(
              border: Border.all(
                color: mainColor,
                width: 3,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(
                  12,
                ),
              ),
              image: DecorationImage(
                image: AssetImage('asstes/imgs/City driver-amico.png'),
                //  NetworkImage(
                //   img.data.attributes.url,
                // ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 4),
          Text(
            bloc.fnol.getImageDescription(key),
            style: GoogleFonts.tajawal(
              textStyle: const TextStyle(
                color: mainColor,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontSize: 15.0,
              ),
            ),
            textAlign: TextAlign.right,
          )
        ],
      ),
    ),
  );
}
