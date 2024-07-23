import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpoo/service_request/core/util/helpoo_in_app_notifications.dart';

import '../../../../dataLayer/constants/variables.dart';

class audioFilePlayer extends StatefulWidget {
  final String audio;
  const audioFilePlayer(this.audio, {key}) : super(key: key);

  @override
  _audioFilePlayerState createState() => _audioFilePlayerState();
}

class _audioFilePlayerState extends State<audioFilePlayer> {
  AssetsAudioPlayer player = AssetsAudioPlayer();
  @override
  void initState() {
    super.initState();
    player.currentPosition.listen((event) {
      setState(() {
        this.position = event;
        debugPrint(event.toString());
      });
    });
  }

  @override
  void dispose() {
    if (playing) {
      player.stop();
    }
    player.dispose();
    super.dispose();
  }

  Duration position = Duration(seconds: 0);
  bool get playing => player.playerState.value == PlayerState.play;
  double get progress => playing ? position.inSeconds * 1.0 / recordLength : 0;
  double get recordLength => playing
      ? (player.current.value?.audio.duration.inSeconds ?? 0) * 1.0
      : 11111.0;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        child: playing
            ? IconButton(
                icon: Icon(
                  Icons.stop,
                  color: mainColor,
                ),
                onPressed: () async {
                  try {
                    await player.stop();
                  } catch (e) {
                    print(e);
                  }
                },
              )
            : IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  color: mainColor,
                ),
                onPressed: () async {
                  try {
                    // widget.audio.contains("cache")
                    //     ? await player.open(Audio.file(widget.audio))
                    //     :
                    await player.open(Audio.network(assetsUrl + widget.audio));
                  } catch (e) {
                    HelpooInAppNotification.showErrorMessage(
                        message: e.toString());
                    // Get.snackbar('error', e.toString());
                    return;
                  }
                  player.play();
                  Timer.periodic(Duration(seconds: 1), (timer) {
                    if (!playing) {
                      timer.cancel();
                    }
                    setState(() {});
                  });
                },
              ),
      ),
      Container(
        height: 10,
        width: Get.width * .35,
        child: Slider(
          value: progress.toDouble(),
          onChanged: (progress) {
            if (playing) {
              player.seek(Duration(seconds: (recordLength * progress).toInt()));
            }
          },
        ),
      ),
    ]);
  }
}
