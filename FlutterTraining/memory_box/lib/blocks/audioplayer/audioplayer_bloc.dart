import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:memory_box/services/soundPlayer.dart';
import 'package:meta/meta.dart';

part 'audioplayer_event.dart';
part 'audioplayer_state.dart';

class AudioplayerBloc extends Bloc<AudioplayerEvent, AudioplayerState> {
  AudioplayerBloc() : super(AudioplayerState());

  SoundPlayer? _soundPlayer;

  @override
  Stream<AudioplayerState> mapEventToState(
    AudioplayerEvent event,
  ) async* {
    if (event is InitPlayer) {
      yield* _initPlayer(event);
    }

    if (event is DisposePlayer) {
      yield* _disposePlayer();
    }

    if (event is Play) {
      yield* _play();
    }

    if (event is Pause) {
      yield* _pause();
    }

    if (event is Seek) {
      yield* _seek();
    }

    if (event is MoveBackward15Sec) {
      yield* _moveBackward15Sec();
    }

    if (event is MoveForward15Sec) {
      yield* _moveForward15Sec();
    }
    int z = 1;
    if (event is UpdatePlayDuration) {
      yield* _updatePlayDuration();
    }
  }

  Stream<AudioplayerState> _initPlayer(InitPlayer event) async* {
    _soundPlayer = SoundPlayer();
    await _soundPlayer?.init(soundUrl: event.soundUrl);
    yield state;
  }

  Stream<AudioplayerState> _disposePlayer() async* {
    _soundPlayer?.dispose();
    state.isPlay = false;
    state.songDuration = null;
    state.currentPlayDuration = null;
    state.songUrl = null;
    state.title = null;
    yield state;
  }

  Stream<AudioplayerState> _play() async* {
    _soundPlayer?.play();
    state.isPlay = true;
    print('wtf ${state.isPlay}');
    yield PlayState();
  }

  Stream<AudioplayerState> _pause() async* {
    await _soundPlayer?.pause();
    state.isPlay = false;
    yield state;
  }

  Stream<AudioplayerState> _seek() async* {}

  Stream<AudioplayerState> _moveForward15Sec() async* {
    // _soundPlayer?.pause();
    // state.isPlay = false;
    print('object-3');
    yield state;
  }

  Stream<AudioplayerState> _moveBackward15Sec() async* {}

  Stream<AudioplayerState> _updatePlayDuration() async* {
    state.songDuration = _soundPlayer?.maxDuration;
    state.currentPlayDuration = _soundPlayer?.position;
    yield state;
  }
}
