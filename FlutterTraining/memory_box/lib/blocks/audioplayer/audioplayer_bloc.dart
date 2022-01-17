import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/services/soundPlayer.dart';

part 'audioplayer_event.dart';
part 'audioplayer_state.dart';

class AudioplayerBloc extends Bloc<AudioplayerEvent, AudioplayerState> {
  AudioplayerBloc()
      : super(
          AudioplayerState(
            taleModel: TaleModel(),
            currentPlayDuration: Duration.zero,
          ),
        );

  SoundPlayer? _soundPlayer;

  // StreamSubscription<void>? timerController;

  @override
  Stream<AudioplayerState> mapEventToState(
    AudioplayerEvent event,
  ) async* {
    if (event is InitPlayer) {
      _soundPlayer = SoundPlayer.instance;

      bool _isPlayerInit = await _soundPlayer?.initPlayer() ?? false;

      if (_isPlayerInit) {
        yield state.copyWith(
          isPlayerInit: true,
        );

        _soundPlayer?.soundDurationStream?.listen((e) {
          // state.taleModel.duration = e.duration.inMilliseconds

          emit(
            state.copyWith(
              currentPlayDuration: Duration(
                milliseconds: e.position.inMilliseconds,
              ),
            ),
          );
        });
      } else {
        yield state.copyWith(errorText: 'Не удалось провести инициализацию');
      }

      // _soundPlayer.
      // TaleModel soundModel = event.soundModel;

      // String? url = event.soundModel.url;
      // if (url != null) {
      //   await _soundPlayer?.init(
      //     soundUrl: url,
      //   );
      //   soundModel.duration = _soundPlayer?.songDuration;

      //   yield AudioplayerState.initial().copyWith(
      //     newSoundModel: soundModel,
      //     currentPlayDuration: _soundPlayer?.currentPlayDuration,
      //     isInit: true,
      //   );

      //   timerController = Stream.periodic(
      //     const Duration(seconds: 1),
      //   ).listen((event) {
      //     add(UpdatePlayDuration());
      //   });
      //   timerController?.pause();
      // } else {
      //   yield AudioplayerState.initial().copyWith(
      //     isInit: false,
      //   );
      // }
    }

    // if (event is SetTaleModel) {
    //   await _soundPlayer?.setTaleModel(
    //     taleModel: event.taleModel,
    //   );
    // }

    if (event is InitTale) {
      state.taleModel.duration = await _soundPlayer?.initTale(
        taleModel: event.taleModel,
      );

      yield state.copyWith(
        isPlay: true,
        isTaleInit: true,
        newTaleModel: state.taleModel,
      );

      // timerController?.cancel();

    }

    if (event is DisposePlayer) {
      if (state.isPlay) await _soundPlayer?.pausePlayer();
      await _soundPlayer?.dispose();

      //!! init timerController?.cancel();
      // yield AudioplayerState.initial();
    }

    if (event is Play) {
      if (state.isTaleInit) {
        await _soundPlayer?.resumePlayer();
        yield state.copyWith(
          isPlay: true,
        );
      } else {
        add(
          InitTale(taleModel: event.taleModel),
        );
      }

      // add(StartTimer());
    }

    if (event is Pause) {
      await _soundPlayer?.pausePlayer();
      // add(StopTimer());
      yield state.copyWith(
        isPlay: false,
      );
    }

    if (event is Seek) {
      // int currentPlayTimeInSec = event.currentPlayTimeInSec.toInt();
      // _soundPlayer?.seek(
      //   currentPlayTimeInSec: currentPlayTimeInSec,
      // );
      // yield state.copyWith(
      //   currentPlayDuration: Duration(
      //     seconds: currentPlayTimeInSec,
      //   ),
      // );
    }

    if (event is MoveBackward15Sec) {
      // int currentPlayTimeInSec = state.currentPlayDuration?.inSeconds ?? 0;
      // _soundPlayer?.moveBackward15Sec(
      //   currentPlayTimeInSec: currentPlayTimeInSec,
      // );
      // add(UpdatePlayDuration());
    }

    if (event is MoveForward15Sec) {
      // int currentPlayTimeInSec = state.currentPlayDuration?.inSeconds ?? 0;
      // _soundPlayer?.moveForward15Sec(
      //   currentPlayTimeInSec: currentPlayTimeInSec,
      // );
      // add(UpdatePlayDuration());
    }

    if (event is UpdatePlayDuration) {
      // yield state.copyWith(
      //   // songDuration: _soundPlayer?.songDuration,
      //   currentPlayDuration: _soundPlayer?.currentPlayDuration,
      // );
    }

    if (event is StartTimer) {
      // timerController?.resume();
    }

    if (event is StopTimer) {
      // timerController?.pause();
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
      // _soundPlayer?.deleteSound();
    }

    if (event is UpdateSoundModel) {
      // yield state.copyWith(
      //   title: event.title,
      // );
    }
  }
}
