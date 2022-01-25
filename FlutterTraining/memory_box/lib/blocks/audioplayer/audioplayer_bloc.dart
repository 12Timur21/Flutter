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
          isTaleEnd: false,
        );

        //Каждые n секунд обновляем позицию Duration
        _soundPlayer?.soundDurationStream?.listen((e) {
          emit(
            state.copyWith(
              newTaleModel: state.taleModel.copyWith(duration: e.duration),
              newPlayDuration: Duration(
                milliseconds: e.position.inMilliseconds,
              ),
              isTaleEnd: false,
            ),
          );
        });

        //При окончании песни
        _soundPlayer?.whenFinishedStream?.listen((event) {
          print('tale cz');
          emit(
            state.copyWith(
              isTaleEnd: true,
              isTaleInit: false,
              isPlay: false,
            ),
          );
        });
      } else {
        yield state.copyWith(errorText: 'Не удалось провести инициализацию');
      }
    }

    if (event is DisposePlayer) {
      if (state.isPlay) await _soundPlayer?.pausePlayer();
      await _soundPlayer?.dispose();
    }

    if (event is InitTale) {
      Duration? taleDuration = await _soundPlayer?.initTale(
        taleModel: event.taleModel,
        isAutoPlay: event.isAutoPlay,
      );

      yield state.copyWith(
        isPlay: event.isAutoPlay,
        isTaleInit: true,
        isTaleEnd: false,
        newTaleModel: event.taleModel.copyWith(
          duration: taleDuration,
        ),
      );
    }

    if (event is Play) {
      if (state.isTaleInit && state.taleModel.ID == event.taleModel.ID) {
        if (_soundPlayer?.isSoundPlay ?? false) {
          return;
        }

        await _soundPlayer?.resumePlayer();
        yield state.copyWith(
          isTaleEnd: false,
          isPlay: true,
        );
      } else {
        add(
          InitTale(
            taleModel: event.taleModel,
            isAutoPlay: event.isAutoPlay,
          ),
        );
      }
    }

    if (event is Pause) {
      await _soundPlayer?.pausePlayer();

      yield state.copyWith(
        isTaleEnd: false,
        isPlay: false,
      );
    }

    if (event is Seek) {
      int currentPlayTimeInSec = event.currentPlayTimeInSec.toInt();
      _soundPlayer?.seek(
        currentPlayTime: Duration(seconds: currentPlayTimeInSec),
      );
      yield state.copyWith(
        newPlayDuration: Duration(
          seconds: currentPlayTimeInSec,
        ),
      );
    }

    if (event is MoveBackward15Sec) {
      Duration newPlayDuration = await _soundPlayer?.moveBackward15Sec(
            currentPlayDuration: state.currentPlayDuration,
          ) ??
          Duration.zero;

      emit(
        state.copyWith(
          newPlayDuration: newPlayDuration,
        ),
      );
    }

    if (event is MoveForward15Sec) {
      Duration newPlayDuration = await _soundPlayer?.moveForward15Sec(
            currentPlayDuration: state.currentPlayDuration,
            taleDuration: state.taleModel.duration ?? Duration.zero,
          ) ??
          Duration.zero;

      emit(
        state.copyWith(
          newPlayDuration: newPlayDuration,
        ),
      );
      // int currentPlayTimeInSec = state.currentPlayDuration?.inSeconds ?? 0;
      // _soundPlayer?.moveForward15Sec(
      //   currentPlayTimeInSec: currentPlayTimeInSec,
      // );
      // add(UpdatePlayDuration());
    }

    if (event is UpdateTaleModel) {
      yield state.copyWith(
        newTaleModel: state.taleModel.copyWith(
          title: event.newTitle,
        ),
      );
    }
  }
}
