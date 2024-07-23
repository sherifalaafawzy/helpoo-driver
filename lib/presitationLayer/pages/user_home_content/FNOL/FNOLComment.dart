import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';
import 'package:record/record.dart';
import '../../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../../../../dataLayer/constants/variables.dart';
import '../../../../dataLayer/models/FNOL.dart';
import '../../../widgets/FNOL/voiceInputWidget.dart';
import '../../../widgets/round_button.dart';
import 'FnolSuccess.dart';

class fnolComment extends StatefulWidget {
  final FNOL report;
  const fnolComment(this.report, {Key? key}) : super(key: key);

  @override
  State<fnolComment> createState() => _CommentPageState();
}

class _CommentPageState extends State<fnolComment> {
  TextEditingController commentController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // var bloc = BlocProvider.of<FnolBloc>(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // setState(() {
    //   bloc.fnol.mediaController= MediaController();
    // });
    // commentController.text = widget.report.comment;
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<FnolBloc>(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: appWhite,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: appWhite),
          backgroundColor: mainColor,
          centerTitle: true,
          title: Text(
            "accident desc".tr,
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
        ),
        body: InkWell(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Form(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Image.asset("assets/imgs/car-top.png",
                      height: 150, width: Get.width),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "please write accident desc".tr,
                      style: GoogleFonts.tajawal(
                        textStyle: const TextStyle(
                          color: appBlack,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.normal,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 32.0,
                    right: 32.0,
                    top: 16,
                  ),
                  child: TextFormField(
                    controller: commentController,
                    minLines: 5,
                    maxLines: 5,
                    decoration: appInput.copyWith(
                      hintText: "please confirm accident desc".tr,
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "or".tr,
                  style: GoogleFonts.tajawal(
                    textStyle: const TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.normal,
                      fontSize: 24.0,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                // bloc.fnol.mediaController.audioFilePath != null
                //     ?
                Column(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "voice description".tr,
                          style: GoogleFonts.tajawal(
                            textStyle: const TextStyle(
                              color: appBlack,
                              fontWeight: FontWeight.w800,
                              fontStyle: FontStyle.normal,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        Container(height: 200, child: voiceInputWidget()),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(8.0),
          child: RoundButton(
              onPressed: () async {
                if (bloc.fnol.mediaController.audioFilePath != null ||
                    commentController.text.isNotEmpty) {
                  debugPrint('record file path>>>>>>>>>: ${bloc.fnol.mediaController.audioFilePath}');
                  if (bloc.fnol.mediaController.recordState ==
                          RecordState.record ||
                      bloc.fnol.mediaController.recordState ==
                          RecordState.pause)
                  if (bloc.fnol.mediaController.audio64 == null)
                  {
                    bloc.fnol.mediaController.timer?.cancel();
                    bloc.fnol.mediaController.recordDuration = 0;
                    final path = await bloc.fnol.mediaController.audioRecorder.stop();
                    debugPrint('Recorded file path>>>>>>>>>: $path');
                    if (path != null) {
                      bloc.fnol.mediaController.audioFilePath = path;
                      await bloc.fnol.mediaController.convertAudioTo64(
                          bloc.fnol.mediaController.audioFilePath, bloc);
                      bloc.fnol.mediaController.amplitudeSub!.cancel();
                    }
                  }

                  bloc.fnol.comment = commentController.text;

                  debugPrint('---------- comment ----------');
                  debugPrint(bloc.fnol.comment);

                  bloc.updateCommentVoiceFNOL(bloc.fnol.id);
                  //
                  Get.to(() => fNOLSuccess());
                } else {

                  HelpooInAppNotification.showErrorMessage(
                      message: "please enter comment or voice description".tr);
                  // Get.snackbar(
                  //   "waring".tr,
                  //   "please enter comment or voice description".tr,
                  //   backgroundColor: Colors.red,
                  //   colorText: Colors.white,
                  // );

                  

                }
              },
              padding: true,
              text: "save".tr,
              color: mainColor),
        ),
      ),
    );
  }
}
