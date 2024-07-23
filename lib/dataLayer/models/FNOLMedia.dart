// ignore_for_file: body_might_complete_normally_nullable

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:record/record.dart';

class MediaController {
  String? audioFilePath;
  String? audio64;
  bool working = false;
   int recordDuration = 0;
   Timer? timer;
   final audioRecorder = Record();
   StreamSubscription<RecordState>? recordSub;
   RecordState recordState = RecordState.stop;
   StreamSubscription<Amplitude>? amplitudeSub;
   Amplitude? amplitude;

  convertAudioTo64(path, bloc) async {
    debugPrint('convertAudioTo64');
    debugPrint('convertAudioTo64 : $path');
    // Directory tempDir = await getTemporaryDirectory();

    File tempFile = File('${path}');

    tempFile.readAsBytes().then((fileBytes) {
      debugPrint('fileBytes: $fileBytes');
      bloc.fnol.mediaController.audio64 = base64Encode(fileBytes);
      debugPrint('audio64: ${bloc.fnol.mediaController.audio64}');
    }).catchError((error) {
      debugPrint('onErrorReadBytes: $error');
    });

    // File file = File(path);
    // // file.openRead();
    // debugPrint('fileBytes: $file');
    // // List<int> fileBytes= await file.readAsBytesSync();
    // List<int> fileBytes = await file.readAsBytes().then((value) {
    //   debugPrint('value: $value');
    //   return value;
    //
    // }).catchError((onError) {
    //   debugPrint('onErrorReadBytes: $onError');
    //
    //   return onError;
    // });

  }
}