import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';
import 'package:helpoo/dataLayer/bloc/serviceRequest/bloc/service_request_bloc.dart';
import 'package:helpoo/pdf/pdf_controller.dart';
import 'package:helpoo/service_request/core/util/cubit/cubit.dart';
import 'package:helpoo/service_request/core/util/cubit/state.dart';
import 'package:helpoo/service_request/core/util/enums.dart';
import '../../../../dataLayer/constants/variables.dart';
import '../../../../dataLayer/models/FNOL.dart';
import '../../../widgets/willPopScopeWidget.dart';
import '../../homeScreen.dart';
import '../../../widgets/round_button.dart';

class fnolStepDone extends StatefulWidget {
  final FNOL report;
  final String from;

  const fnolStepDone(
    this.report, {
    Key? key,
    this.from = '',
  }) : super(key: key);

  @override
  State<fnolStepDone> createState() => fnolStepDoneState();
}

class fnolStepDoneState extends State<fnolStepDone> {
  @override
  void initState() {
    super.initState();
    sRBloc.getAccidentDetails(accidentId: widget.report.id);
  }

  @override
  Widget build(BuildContext context) {
    return willPopScopeWidget(
      onWillPop: () async {
        return false;
      },
      child: BlocConsumer<NewServiceRequestBloc, NewServiceRequestState>(
        listener: (context, state) async {
          if (state is AccidentDetailsSuccess) {
            /// 1- create pdf and get it in base64
            /// 2- send it to the server
            if (widget.from == 'police') {
              String pdf = await PdfController.getPdfBase64(
                pdf: await PdfController.generateStepFnolPdf(
                  context: context,
                  generatePdfStepDto: GeneratePdfStepDto(
                    userName: sRBloc.accidentDetailsModel?.report?.clientModel?.user?.name ?? '',
                    fnolNumber: '${sRBloc.accidentDetailsModel?.report?.id ?? ''}',
                    carPlateNumber: sRBloc.accidentDetailsModel?.report?.car?.plateNumber ?? '',
                    insuranceCompany: sRBloc.accidentDetailsModel?.report?.car?.insuranceCompany?.name ?? '',
                    policyNumber: sRBloc.accidentDetailsModel?.report?.car?.policyNumber ?? '',
                    carManufacturer: sRBloc.accidentDetailsModel?.report?.car?.manufacturer?.name ?? '',
                    carModel: sRBloc.accidentDetailsModel?.report?.car?.carModel?.name ?? '',
                    vinNumber: sRBloc.accidentDetailsModel?.report?.car?.vinNumber ?? '',
                    images: sRBloc.accidentDetailsModel?.policeImages ?? [],
                    step: FNOLSteps.policeReport,
                  ),
                ),
              );
              sRBloc.sendFnolStepPdf(
                  pdfReportId: '2',
                  accidentId: widget.report.id.toString(),
                  pdf: pdf,
                  type: 'police',
                  carId: sRBloc.accidentDetailsModel?.report?.car?.id.toString() ?? '');
            } else if (widget.from == 'repair_before') {
              String pdf = await PdfController.getPdfBase64(
                  pdf: await PdfController.generateStepFnolPdf(
                context: context,
                generatePdfStepDto: GeneratePdfStepDto(
                  userName: sRBloc.accidentDetailsModel?.report?.clientModel?.user?.name ?? '',
                  fnolNumber: '${sRBloc.accidentDetailsModel?.report?.id ?? ''}',
                  carPlateNumber: sRBloc.accidentDetailsModel?.report?.car?.plateNumber ?? '',
                  insuranceCompany: sRBloc.accidentDetailsModel?.report?.car?.insuranceCompany?.name ?? '',
                  policyNumber: sRBloc.accidentDetailsModel?.report?.car?.policyNumber ?? '',
                  carManufacturer: sRBloc.accidentDetailsModel?.report?.car?.manufacturer?.name ?? '',
                  carModel: sRBloc.accidentDetailsModel?.report?.car?.carModel?.name ?? '',
                  vinNumber: sRBloc.accidentDetailsModel?.report?.car?.vinNumber ?? '',
                  images: sRBloc.accidentDetailsModel?.bRepairImages ?? [],
                  step: FNOLSteps.bRepair,
                ),
              ));
              sRBloc.sendFnolStepPdf(
                  pdfReportId: '1',
                  accidentId: widget.report.id.toString(),
                  pdf: pdf,
                  type: 'beforeRepair',
                  carId: sRBloc.accidentDetailsModel?.report?.car?.id.toString() ?? '');
            } else if (widget.from == 'supplement') {
              String pdf = await PdfController.getPdfBase64(
                pdf: await PdfController.generateStepFnolPdf(
                  context: context,
                  generatePdfStepDto: GeneratePdfStepDto(
                    userName: sRBloc.accidentDetailsModel?.report?.clientModel?.user?.name ?? '',
                    fnolNumber: '${sRBloc.accidentDetailsModel?.report?.id ?? ''}',
                    carPlateNumber: sRBloc.accidentDetailsModel?.report?.car?.plateNumber ?? '',
                    insuranceCompany: sRBloc.accidentDetailsModel?.report?.car?.insuranceCompany?.name ?? '',
                    policyNumber: sRBloc.accidentDetailsModel?.report?.car?.policyNumber ?? '',
                    carManufacturer: sRBloc.accidentDetailsModel?.report?.car?.manufacturer?.name ?? '',
                    carModel: sRBloc.accidentDetailsModel?.report?.car?.carModel?.name ?? '',
                    vinNumber: sRBloc.accidentDetailsModel?.report?.car?.vinNumber ?? '',
                    images: sRBloc.accidentDetailsModel?.supplementImages ?? [],
                    step: FNOLSteps.supplement,
                  ),
                ),
              );
              sRBloc.sendFnolStepPdf(
                  pdfReportId: '5',
                  accidentId: widget.report.id.toString(),
                  pdf: pdf,
                  type: 'supplement',
                  carId: sRBloc.accidentDetailsModel?.report?.car?.id.toString() ?? '');
            } else if (widget.from == 'resurvey') {
              String pdf = await PdfController.getPdfBase64(
                pdf: await PdfController.generateStepFnolPdf(
                  context: context,
                  generatePdfStepDto: GeneratePdfStepDto(
                    userName: sRBloc.accidentDetailsModel?.report?.clientModel?.user?.name ?? '',
                    fnolNumber: '${sRBloc.accidentDetailsModel?.report?.id ?? ''}',
                    carPlateNumber: sRBloc.accidentDetailsModel?.report?.car?.plateNumber ?? '',
                    insuranceCompany: sRBloc.accidentDetailsModel?.report?.car?.insuranceCompany?.name ?? '',
                    policyNumber: sRBloc.accidentDetailsModel?.report?.car?.policyNumber ?? '',
                    carManufacturer: sRBloc.accidentDetailsModel?.report?.car?.manufacturer?.name ?? '',
                    carModel: sRBloc.accidentDetailsModel?.report?.car?.carModel?.name ?? '',
                    vinNumber: sRBloc.accidentDetailsModel?.report?.car?.vinNumber ?? '',
                    images: sRBloc.accidentDetailsModel?.resurveyImages ?? [],
                    step: FNOLSteps.resurvey,
                  ),
                ),
              );
              sRBloc.sendFnolStepPdf(
                  pdfReportId: '7',
                  accidentId: widget.report.id.toString(),
                  pdf: pdf,
                  type: 'resurvey',
                  carId: sRBloc.accidentDetailsModel?.report?.car?.id.toString() ?? '');
            } else if (widget.from == 'rightSave') {
              String pdf = await PdfController.getPdfBase64(
                pdf: await PdfController.generateStepFnolPdf(
                  context: context,
                  generatePdfStepDto: GeneratePdfStepDto(
                    userName: sRBloc.accidentDetailsModel?.report?.clientModel?.user?.name ?? '',
                    fnolNumber: '${sRBloc.accidentDetailsModel?.report?.id ?? ''}',
                    carPlateNumber: sRBloc.accidentDetailsModel?.report?.car?.plateNumber ?? '',
                    insuranceCompany: sRBloc.accidentDetailsModel?.report?.car?.insuranceCompany?.name ?? '',
                    policyNumber: sRBloc.accidentDetailsModel?.report?.car?.policyNumber ?? '',
                    carManufacturer: sRBloc.accidentDetailsModel?.report?.car?.manufacturer?.name ?? '',
                    carModel: sRBloc.accidentDetailsModel?.report?.car?.carModel?.name ?? '',
                    vinNumber: sRBloc.accidentDetailsModel?.report?.car?.vinNumber ?? '',
                    images: [],
                    step: FNOLSteps.rightSave,
                  ),
                ),
              );
              sRBloc.sendFnolStepPdf(
                  pdfReportId: '6',
                  accidentId: widget.report.id.toString(),
                  pdf: pdf,
                  type: 'rightSave',
                  carId: sRBloc.accidentDetailsModel?.report?.car?.id.toString() ?? '');
            } else if (widget.from == 'aRepair') {
              String pdf = await PdfController.getPdfBase64(
                pdf: await PdfController.generateStepFnolPdf(
                  context: context,
                  generatePdfStepDto: GeneratePdfStepDto(
                    userName: sRBloc.accidentDetailsModel?.report?.clientModel?.user?.name ?? '',
                    fnolNumber: '${sRBloc.accidentDetailsModel?.report?.id ?? ''}',
                    carPlateNumber: sRBloc.accidentDetailsModel?.report?.car?.plateNumber ?? '',
                    insuranceCompany: sRBloc.accidentDetailsModel?.report?.car?.insuranceCompany?.name ?? '',
                    policyNumber: sRBloc.accidentDetailsModel?.report?.car?.policyNumber ?? '',
                    carManufacturer: sRBloc.accidentDetailsModel?.report?.car?.manufacturer?.name ?? '',
                    carModel: sRBloc.accidentDetailsModel?.report?.car?.carModel?.name ?? '',
                    vinNumber: sRBloc.accidentDetailsModel?.report?.car?.vinNumber ?? '',
                    images: [],
                    step: FNOLSteps.aRepair,
                  ),
                ),
              );
              sRBloc.sendFnolStepPdf(
                  pdfReportId: '3',
                  accidentId: widget.report.id.toString(),
                  pdf: pdf,
                  type: 'afterRepair',
                  carId: sRBloc.accidentDetailsModel?.report?.car?.id.toString() ?? '');
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: appWhite,
            appBar: AppBar(
              iconTheme: const IconThemeData(color: appWhite),
              backgroundColor: mainColor,
              centerTitle: true,
              title: Text(
                "FNOL Follow Up".tr + " # " + widget.report.id.toString(),
                style: GoogleFonts.tajawal(
                  textStyle: const TextStyle(
                    color: appWhite,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 18.0,
                  ),
                ),
              ),
              leading: Container(),
              // leading: Container(
              //   height: 48,
              //   width: 48,
              //   margin: const EdgeInsets.symmetric(horizontal: 8),
              //   child: Center(
              //     child: IconButton(
              //       onPressed: () {
              //         Get.back();
              //       },
              //       icon: Icon(
              //         CurrentUser.isArabic
              //             ? MdiIcons.arrowRightThin
              //             : MdiIcons.arrowLeftThin,
              //         color: appWhite,
              //       ),
              //     ),
              //   ),
              // ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Image.asset('assets/imgs/report.png', height: 190, width: Get.width),
                ),
                SizedBox(
                  width: Get.width * .8,
                  child: Text(
                    "Your Request has Recieved Successfully and it will be Submitted within 24 hours".tr,
                    style: GoogleFonts.tajawal(
                      textStyle: const TextStyle(
                        color: appBlack,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 24.0,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: Get.width * .4,
                        child: RoundButton(
                            onPressed: () async {
                              ///* send Pdf

                              if (widget.from == 'police') {
                              } else if (widget.from == 'repair_before') {
                              } else if (widget.from == 'supplement') {
                              } else if (widget.from == 'resurvey') {
                              } else if (widget.from == 'rightSave') {
                              } else if (widget.from == 'aRepair') {}
                              Get.to(
                                () => homeScreen(
                                  index: 0,
                                ),
                              );
                            },
                            padding: false,
                            text: 'Done',
                            color: mainColor),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}

///* 1- police [images]
///* 2- before repair [images + location]
///* 3- supplement [images + location]
///* 4- resurvey [images + location]
///* 5- after repair [location]
///* 6- right Save [location]
///

/*
1- Get Current FNOL
2- Create Pdf With Details
* */
