import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:memory_box/services/soundPlayer.dart';
import 'package:meta/meta.dart';

part 'audioplayer_event.dart';
part 'audioplayer_state.dart';

class AudioplayerBloc extends Bloc<AudioplayerEvent, AudioplayerState> {
  AudioplayerBloc() : super(AudioplayerState());

  SoundPlayer? _soundPlayer;
  StreamSubscription<void>? timerController;

  @override
  Stream<AudioplayerState> mapEventToState(
    AudioplayerEvent event,
  ) async* {
    if (event is InitPlayer) {
      _soundPlayer = SoundPlayer();
      await _soundPlayer?.init(
        soundUrl: event.soundUrl,
      );
      yield AudioplayerState.initial().copyWith(
        title: event.soundTitle,
        songDuration: _soundPlayer?.songDuration,
        currentPlayDuration: _soundPlayer?.currentPlayDuration,
        songUrl: event.soundUrl,
        isInit: true,
      );

      timerController = Stream.periodic(
        Duration(seconds: 1),
      ).listen((event) {
        add(UpdatePlayDuration());
      });
      timerController?.pause();
    }

    if (event is DisposePlayer) {
      _soundPlayer?.dispose();
      timerController?.cancel();
      yield AudioplayerState.initial();
    }

    if (event is Play) {
      _soundPlayer?.play();

      yield state.copyWith(
        isPlay: true,
      );
      add(StartTimer());
    }

    if (event is Pause) {
      await _soundPlayer?.pause();
      add(StopTimer());
      yield state.copyWith(
        isPlay: false,
      );
    }

    if (event is Seek) {
      int currentPlayTimeInSec = event.currentPlayTimeInSec.toInt();
      _soundPlayer?.seek(
        currentPlayTimeInSec: currentPlayTimeInSec,
      );
      yield state.copyWith(
        currentPlayDuration: Duration(
          seconds: currentPlayTimeInSec,
        ),
      );
    }

    if (event is MoveBackward15Sec) {
      int currentPlayTimeInSec = state.currentPlayDuration?.inSeconds ?? 0;
      _soundPlayer?.moveBackward15Sec(
        currentPlayTimeInSec: currentPlayTimeInSec,
      );
      add(UpdatePlayDuration());
    }

    if (event is MoveForward15Sec) {
      int currentPlayTimeInSec = state.currentPlayDuration?.inSeconds ?? 0;
      _soundPlayer?.moveForward15Sec(
        currentPlayTimeInSec: currentPlayTimeInSec,
      );
      add(UpdatePlayDuration());
    }

    if (event is UpdatePlayDuration) {
      yield state.copyWith(
        songDuration: _soundPlayer?.songDuration,
        currentPlayDuration: _soundPlayer?.currentPlayDuration,
      );
    }

    if (event is StartTimer) {
      timerController?.resume();
    }

    if (event is StopTimer) {
      timerController?.pause();
    }

    if (event is ShareSound) {
      String? songUrl = state.songUrl;
      if (songUrl != null) {
        _soundPlayer?.shareSound(songUrl);
      }
    }

    if (event is LocalSaveSound) {
      //   String? songUrl = state.songUrl;
      //   if (songUrl != null) {
      //      File pathToAudio = File(songUrl);

      // try {
      //   await pathToAudio.rename(songUrl);
      // } catch {

      // }
      //      _soundPlayer?.localDownloadSound(pathToSaveAudio)
      //   }

    }

    if (event is DeleteSound) {
      _soundPlayer?.deleteSound();
    }

    if (event is UpdateSoundTitle) {
      yield state.copyWith(
        title: event.title,
      );
    }
  }
}
