import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:helpoo/service_request/core/util/extensions/build_context_extension.dart';
import 'package:helpoo/service_request/core/util/widgets/primary_padding.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:io' as io;
import '../../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../../../../dataLayer/constants/variables.dart';
import '../../../../dataLayer/models/FNOL.dart';
import '../../../../dataLayer/models/FNOLMedia.dart';
import '../../../../dataLayer/models/currentUser.dart';
import '../../shared/waitingPage.dart';
import 'FNOLComment.dart';
import 'FNOLMapPicker.dart';
import 'FNOLStepDone.dart';
import '../../../widgets/round_button.dart';

class extraShooting extends StatefulWidget {
  final FNOL accidentReport;
  final String fileNamePrefix;

  extraShooting(this.accidentReport, this.fileNamePrefix, {Key? key})
      : super(key: key);

  @override
  State<extraShooting> createState() => _extraShootingState();
}

class _extraShootingState extends State<extraShooting> {
  CameraController? controller;
  int idx = 0;

  @override
  void initState() {
    bloc = BlocProvider.of<FnolBloc>(context);

    init(bloc);

    if (this.widget.fileNamePrefix == "air_bag_images") {
      idx = this.widget.accidentReport.airBagImages.length;
    } else if (this.widget.fileNamePrefix == "police") {
      idx = this.widget.accidentReport.policeReportImages.length;
    } else if (this.widget.fileNamePrefix == "repair_before") {
      idx = this.widget.accidentReport.repairReportImages.length;
    } else if (this.widget.fileNamePrefix == "supplement") {
      idx = this.widget.accidentReport.supplementImages.length;
    } else if (this.widget.fileNamePrefix == "resurvey") {
      idx = this.widget.accidentReport.resurveyImages.length;
    } else {
      debugPrint("error in file name prefix");
    }
    super.initState();
  }

  bool landscape = false;
  var bloc;

  init(bloc) async {
    if (this.widget.fileNamePrefix == "air_bag_images") {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
      ]);
      landscape = true;
    }
    if (bloc.camera.cameras.isEmpty) {
      await bloc.camera.init();
    }
    if (controller != null) {
      return;
    }
    controller = CameraController(bloc.camera.cameras[0], ResolutionPreset.max);
    controller?.initialize().then((_) {
      if (widget.fileNamePrefix == "police" ||
          widget.fileNamePrefix == "repair_before" ||
          widget.fileNamePrefix == "supplement" ||
          widget.fileNamePrefix == "resurvey") {
        controller!.lockCaptureOrientation(DeviceOrientation.portraitUp);
      } else {
        controller!.lockCaptureOrientation(DeviceOrientation.landscapeRight);
      }

      if (!mounted) {
        return;
      }
      setState(() {});
    });
    // await controller?.initialize();
    if (this.widget.fileNamePrefix == "air_bag_images") {
      controller!.lockCaptureOrientation(DeviceOrientation.landscapeLeft);
    } else {
      controller!.lockCaptureOrientation(DeviceOrientation.portraitUp);
    }
    setState(() {});
    debugPrint("camera ready");
  }

  bool imageTaken = false;
  String path = "";

  @override
  Widget build(BuildContext context) {
    if (this.controller == null) {
      return waitingWidget();
    }
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);

        return true;
      },
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: imageTaken
                  ? Image.file(io.File(path))
                  : CameraPreview(this.controller!),
            ),
            landscape
                ? Container(
                    padding: EdgeInsets.all(10),
                    child: Column(children: [
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildTakePhotoButton(),
                          buildNextPhotoButton(),
                          buildRetakePhotoButton(),
                          buildDoneButton()
                        ],
                      ),
                    ]))
                : SizedBox(
                    height: Get.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(child: buildTakePhotoButton()),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: buildRetakePhotoButton()),
                            Expanded(child: buildNextPhotoButton()),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: buildDoneButton()),
                          ],
                        )
                      ],
                    ),
                  ),
            PrimaryPadding(
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () {
                  context.pop;
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown,
                  ]);
                },
                child: Icon(
                  CurrentUser.isArabic
                      ? MdiIcons.arrowRightThin
                      : MdiIcons.arrowLeftThin,
                  // Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDoneButton() {
    var bloc = BlocProvider.of<FnolBloc>(context);

    return Visibility(
      visible: imageTaken,
      maintainSize: false,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RoundButton(
          onPressed: () async {
            if (this.widget.fileNamePrefix == "air_bag_images") {
              await bloc.fnol.upload(
                  idx: idx, fileNamePrefix: widget.fileNamePrefix, bloc: bloc);
              setState(() {
                bloc.fnol.mediaController = MediaController();
                bloc.fnol.mediaController.audio64 == null;
                bloc.fnol.allImagesCounter++;
              });
              Get.to(() => fnolComment(widget.accidentReport));
            } else {
              if (this.widget.fileNamePrefix == "police") {
                await bloc.fnol.upload(
                    idx: idx,
                    fileNamePrefix: widget.fileNamePrefix,
                    bloc: bloc);
                await bloc.updateStatus("policeReport", bloc.fnol.id);
                Get.to(() => fnolStepDone(widget.accidentReport,from: this.widget.fileNamePrefix,));
              }
              if (this.widget.fileNamePrefix == "repair_before" ||
                  this.widget.fileNamePrefix == "supplement" ||
                  this.widget.fileNamePrefix == "resurvey") {
                await bloc.fnol.upload(
                    idx: idx,
                    fileNamePrefix: widget.fileNamePrefix,
                    bloc: bloc);
                // BlocProvider.of<FnolBloc>(context).emit(GetCurrentPosition());
                Get.to(() => fnolMapPicker(fnolType: widget.fileNamePrefix));
              }
            }
          },
          padding: false,
          text: this.widget.fileNamePrefix == "repair_before" ||
                  this.widget.fileNamePrefix == "supplement" ||
                  this.widget.fileNamePrefix == "resurvey"
              ? "Done and Confirm Repair Location".tr
              : "Done".tr,
          color: mainColor,
        ),
      ),
    );
  }

  Widget buildNextPhotoButton() {
    var bloc = BlocProvider.of<FnolBloc>(context);

    return Visibility(
      visible: imageTaken && idx < 10,
      maintainSize: false,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RoundButton(
            onPressed: () async {
              await bloc.fnol.upload(
                  idx: idx, fileNamePrefix: widget.fileNamePrefix, bloc: bloc);
              setState(() {
                idx++;
                imageTaken = false;
                bloc.fnol.allImagesCounter++;
                path = "";
              });
            },
            padding: false,
            text: "next photo",
            color: mainColor),
      ),
    );
  }

  Widget buildRetakePhotoButton() {
    var bloc = BlocProvider.of<FnolBloc>(context);

    return Visibility(
      visible: imageTaken,
      maintainSize: false,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RoundButton(
            onPressed: () async {
              setState(() {
                imageTaken = false;
                path = "";
                // bloc.fnol.imageCounter--;
                bloc.fnol.allImagesCounter--;
                bloc.changeStateTo(counterUpdate());
                bloc.changeStateTo(imageTake());
              });
            },
            padding: false,
            text: "Retake".tr,
            color: mainColor),
      ),
    );
  }

  Widget buildTakePhotoButton() {
    var bloc = BlocProvider.of<FnolBloc>(context);

    return Visibility(
      visible: !imageTaken,
      maintainSize: false,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RoundButton(
            onPressed: () async {
              await bloc.fnol.uploadMultipleImages(
                  controller: this.controller,
                  idx: idx,
                  fileNamePrefix: widget.fileNamePrefix,
                  bloc: bloc);
              setState(() {
                imageTaken = true;
                path = bloc.fnol.picture!.path;
                bloc.changeStateTo(imageTake());
                bloc.changeStateTo(counterUpdate());
              });
            },
            padding: false,
            text: "take photo".tr,
            color: mainColor),
      ),
    );
  }
}
