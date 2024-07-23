import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../widgets/FNOL/cameraWaitniginit.dart';
import '../../../widgets/FNOL/imageFilePreview.dart';
import '../../../widgets/FNOL/nextImageButton.dart';
import '../../../widgets/FNOL/retakeImageButton.dart';
import '../../../widgets/FNOL/submittedImageView.dart';
import '../../../widgets/FNOL/uploadImageButton.dart';
import '../../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../../../../dataLayer/constants/variables.dart';
import '../../../widgets/FNOL/instructionCameraImage.dart';

class imageInput extends StatefulWidget {
  final String requiredImage;
  final int idx;

  const imageInput({Key? key, required this.idx, required this.requiredImage})
      : super(key: key);

  @override
  imageInputState createState() => imageInputState();
}

class imageInputState extends State<imageInput> {
  CameraController? controller;
  String? img;
  String? imagePath;
  bool cameraMode = true;
  FlashMode flashMode = FlashMode.off;

  init(bloc) async {
    loadImage(bloc);

    if (bloc.camera.cameras.isEmpty) {
      await bloc.camera.init();
      debugPrint("no camera available");
    }
    if (controller != null) {
      return;
    }
    controller =
        CameraController(bloc.camera.cameras[0], ResolutionPreset.veryHigh);
    controller?.initialize().then((_) {
      controller!.lockCaptureOrientation(DeviceOrientation.landscapeRight
          // GetPlatform.isIOS
          // ? DeviceOrientation.landscapeRight
          // : DeviceOrientation.landscapeLeft
          );
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    SystemChrome.setPreferredOrientations([
      // DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  loadImage(bloc) async {
    img = bloc.fnol.getImageObject(widget.requiredImage);
    imagePath = await bloc.fnol.getImage(widget.requiredImage);
    Future.delayed(const Duration(seconds: 1));
  }

  void setCameraMode() {
    setState(() {
      imagePath = null;
      cameraMode = true;
    });
  }

  void resetCameraMode() async {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        cameraMode = false;
        flashMode = flashMode;
      });
    });
  }

  void onFlashModeButtonPressed() {
    setState(() {
      if (flashMode == FlashMode.off) {
        flashMode = FlashMode.always;
      } else if (flashMode == FlashMode.always) {
        flashMode = FlashMode.torch;
      } else if (flashMode == FlashMode.torch) {
        flashMode = FlashMode.auto;
      } else {
        flashMode = FlashMode.off;
      }
      controller!.setFlashMode(flashMode);
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<FnolBloc>(context);

    init(bloc);
    return
        // WillPopScope(
        // onWillPop: () async {
        //   SystemChrome.setPreferredOrientations([
        //     DeviceOrientation.portraitUp,
        //   ]);
        //   Get.to(() => shootingNotes());
        //   return true;
        // },
        // child:
        cameraMode && controller != null
            ? WillPopScope(
                onWillPop: () async => false,
                child: Scaffold(
                  backgroundColor: Colors.black,
                  body: Stack(
                    children: [
                      Positioned.fill(child: CameraPreview(controller!)),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: FloatingActionButton(
                              backgroundColor: mainColor,
                              child: const Icon(
                                MdiIcons.cameraOutline,
                                color: appWhite,
                              ),
                              onPressed: () async {
                                await bloc.fnol.takeRequiredImage(
                                  controller: controller!,
                                  fnol: bloc.fnol,
                                  requiredImage: widget.requiredImage,
                                  idx: widget.idx,
                                  bloc: bloc,
                                );
                                loadImage(bloc);
                                resetCameraMode();
                              },
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: FloatingActionButton(
                              backgroundColor: mainColor,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.flash_on,
                                    color: appWhite,
                                  ),
                                  Text(
                                    flashMode.toString().split(".")[1],
                                    style: TextStyle(color: appWhite),
                                  )
                                ],
                              ),
                              onPressed: onFlashModeButtonPressed,
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: instructionsCameraImage(
                            requiredImage: widget.requiredImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: img != null
                                ? submittedImageView(img: img)
                                : controller == null ||
                                        !controller!.value.isInitialized
                                    ? cameraWaitinginit(init: init)
                                    : imagePath != null && imagePath!.isNotEmpty
                                        ? imageFilePreview(
                                            imagePath: imagePath,
                                            requiredImage: widget.requiredImage,
                                          )
                                        : instructionsCameraImage(
                                            requiredImage: widget.requiredImage,
                                          ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: img != null
                                  ? nextImageButton(
                                      bloc: bloc,
                                      report: bloc.fnol,
                                      idx: widget.idx,
                                      img: img)
                                  : Row(children: [
                                      uploadImageButton(
                                        imagePath: imagePath,
                                        accidentReport: bloc.fnol,
                                        idx: widget.idx,
                                        requiredImage: widget.requiredImage,
                                      ),
                                      retakeImageButton(
                                        clearImagePath: setCameraMode,
                                        imagePath: imagePath,
                                      ),
                                    ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ),
                    // )
                  ],
                ),
              );
    // );
  }
}
