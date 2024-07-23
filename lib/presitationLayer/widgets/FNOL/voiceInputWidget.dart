import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../../dataLayer/bloc/FNOL/bloc/fnol_bloc.dart';
import '../../../dataLayer/Constants/variables.dart';
import 'audio/audioPlayer.dart';
import 'package:record/record.dart';

class AudioRecorder extends StatefulWidget {
  final void Function(String path) onStop;

  const AudioRecorder({Key? key, required this.onStop}) : super(key: key);

  @override
  _AudioRecorderState createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  // int _recordDuration = 0;
  // Timer? _timer;
  // final _audioRecorder = Record();
  // StreamSubscription<RecordState>? _recordSub;
  // RecordState _recordState = RecordState.stop;
  // StreamSubscription<Amplitude>? _amplitudeSub;
  // Amplitude? _amplitude;

  @override
  void initState() {
    var bloc = BlocProvider.of<FnolBloc>(context);

    bloc.fnol.mediaController.recordSub = bloc
        .fnol.mediaController.audioRecorder
        .onStateChanged()
        .listen((recordState) {
      setState(() => bloc.fnol.mediaController.recordState = recordState);
    });

    bloc.fnol.mediaController.amplitudeSub = bloc
        .fnol.mediaController.audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 300))
        .listen(
            (amp) => setState(() => bloc.fnol.mediaController.amplitude = amp));

    super.initState();
  }

  Future<void> _start(bloc) async {
    try {
      if (await bloc.fnol.mediaController.audioRecorder.hasPermission()) {
        // We don't do anything with this but printing
        final isSupported =
            await bloc.fnol.mediaController.audioRecorder.isEncoderSupported(
          AudioEncoder.aacLc,
        );
        if (kDebugMode) {
          debugPrint('${AudioEncoder.aacLc.name} supported: $isSupported');
        }

        // final devs = await _audioRecorder.listInputDevices();
        // final isRecording = await _audioRecorder.isRecording();

        Directory tempDir = await getTemporaryDirectory();

        Record r = bloc.fnol.mediaController.audioRecorder;

        await r.start(
          path: '${tempDir.path}/myFile.m4a',
        );

        bloc.fnol.mediaController.recordDuration = 0;

        _startTimer(bloc);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _stop(bloc) async {
    bloc.fnol.mediaController.timer?.cancel();
    bloc.fnol.mediaController.recordDuration = 0;

    final path = await bloc.fnol.mediaController.audioRecorder.stop();

    if (path != null) {
      widget.onStop(path);
    }
  }

  Future<void> _pause(bloc) async {
    bloc.fnol.mediaController.timer?.cancel();
    await bloc.fnol.mediaController.audioRecorder.pause();
  }

  Future<void> _resume(bloc) async {
    _startTimer(bloc);
    await bloc.fnol.mediaController.audioRecorder.resume();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<FnolBloc>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildRecordStopControl(bloc),
            const SizedBox(width: 20),
            _buildPauseResumeControl(bloc),
            const SizedBox(width: 20),
            _buildText(bloc),
          ],
        ),
        if (bloc.fnol.mediaController.amplitude != null) ...[
          // const SizedBox(height: 40),
          // Text('Current: ${_amplitude?.current ?? 0.0}'),
          // Text('Max: ${_amplitude?.max ?? 0.0}'),
        ],
      ],
    );
  }

  @override
  void dispose() {
    var bloc = BlocProvider.of<FnolBloc>(context);

    bloc.fnol.mediaController.timer?.cancel();
    bloc.fnol.mediaController.recordSub?.cancel();
    bloc.fnol.mediaController.amplitudeSub?.cancel();
    bloc.fnol.mediaController.audioRecorder.dispose();
    super.dispose();
  }

  Widget _buildRecordStopControl(bloc) {
    late Icon icon;
    late Color color;

    if (bloc.fnol.mediaController.recordState != RecordState.stop) {
      icon = const Icon(Icons.stop, color: mainColor, size: 30);
      color = mainColor.withOpacity(0.1);
    } else {
      icon = Icon(Icons.mic, color: mainColor, size: 30);
      color = mainColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            (bloc.fnol.mediaController.recordState != RecordState.stop)
                ? _stop(bloc)
                : _start(bloc);
          },
        ),
      ),
    );
  }

  Widget _buildPauseResumeControl(bloc) {
    if (bloc.fnol.mediaController.recordState == RecordState.stop) {
      return const SizedBox.shrink();
    }
    late Icon icon;
    late Color color;
    if (bloc.fnol.mediaController.recordState == RecordState.record) {
      icon = const Icon(Icons.pause, color: mainColor, size: 30);
      color = mainColor.withOpacity(0.1);
    } else {
      icon = const Icon(Icons.play_arrow, color: mainColor, size: 30);
      color = mainColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            (bloc.fnol.mediaController.recordState == RecordState.pause)
                ? _resume(bloc)
                : _pause(bloc);
          },
        ),
      ),
    );
  }

  Widget _buildText(bloc) {
    if (bloc.fnol.mediaController.recordState != RecordState.stop) {
      return _buildTimer(bloc);
    }

    return Text(
      "voice description".tr,
      style:
          Get.theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTimer(bloc) {
    final String minutes =
        _formatNumber(bloc.fnol.mediaController.recordDuration ~/ 60);
    final String seconds =
        _formatNumber(bloc.fnol.mediaController.recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: const TextStyle(color: mainColor),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }

    return numberStr;
  }

  void _startTimer(bloc) {
    bloc.fnol.mediaController.timer?.cancel();

    bloc.fnol.mediaController.timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => bloc.fnol.mediaController.recordDuration++);
      if (bloc.fnol.mediaController.recordDuration > 300) {
        bloc.fnol.mediaController.audioRecorder.stop();
      }
    });
  }
}

class voiceInputWidget extends StatefulWidget {
  @override
  voiceInputWidgetState createState() => voiceInputWidgetState();
}

class voiceInputWidgetState extends State<voiceInputWidget> {
  bool showPlayer = false;
  String? audioPath;

  @override
  void initState() {
    showPlayer = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<FnolBloc>(context);
    return showPlayer
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: audioPlayer(
              source: audioPath!,
              onDelete: () {
                setState(() => showPlayer = false);
                bloc.fnol.mediaController.audioRecorder.dispose();
              },
            ),
          )
        : AudioRecorder(
            onStop: (path) {
              debugPrint('Recorded file path: $path');
              if (kDebugMode) debugPrint('Recorded file path: $path');
              setState(() {
                audioPath = path;
                bloc.fnol.mediaController.audioFilePath = path;
                showPlayer = true;
              });
              debugPrint('start converting');
              bloc.fnol.mediaController.convertAudioTo64(
                  path, bloc);
            },
          );
  }
}
