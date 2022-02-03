import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:memory_box/blocks/list_builder/list_builder_bloc.dart';
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
        ) {
    SoundPlayer? _soundPlayer;
    on<InitPlayer>((event, emit) async {
      _soundPlayer = SoundPlayer.instance;

      bool _isPlayerInit = await _soundPlayer?.initPlayer() ?? false;

      if (_isPlayerInit) {
        emit(
          state.copyWith(
            isPlayerInit: true,
            isTaleEnd: false,
          ),
        );

        //Каждые n секунд обновляем позицию Duration сказки
        _soundPlayer?.soundDurationStream?.listen((e) {
          add(
            UpdateAudioPlayerDuration(
              currentPlayDuration: Duration(
                milliseconds: e.position.inMilliseconds,
              ),
              taleDuration: e.duration,
            ),
          );
        });
      } else {
        emit(
          state.copyWith(errorText: 'Не удалось провести инициализацию'),
        );
      }
    });
    on<DisposePlayer>((event, emit) async {
      if (state.isPlay) await _soundPlayer?.pausePlayer();
      await _soundPlayer?.dispose();
    });
    on<InitTale>((event, emit) async {
      final Completer<void> whenFinished = Completer<void>();

      Duration? taleDuration = await _soundPlayer?.initTale(
          taleModel: event.taleModel,
          isAutoPlay: event.isAutoPlay,
          whenFinished: () async {
            whenFinished.complete();
          });

      emit(
        state.copyWith(
          isPlay: event.isAutoPlay,
          isTaleInit: true,
          isTaleEnd: false,
          newTaleModel: event.taleModel.copyWith(
            duration: taleDuration,
          ),
        ),
      );

      await whenFinished.future.then((_) {
        emit(
          state.copyWith(
            isTaleEnd: true,
            // newPlayDuration: Duration.zero,
            isTaleInit: false,
            isPlay: false,
          ),
        );
      });
    });

    on<Play>((event, emit) async {
      if (state.isTaleInit && state.taleModel.ID == event.taleModel.ID) {
        if (_soundPlayer?.isSoundPlay ?? false) {
          return;
        }

        await _soundPlayer?.resumePlayer();
        emit(
          state.copyWith(
            isTaleEnd: false,
            isPlay: true,
          ),
        );
      } else {
        add(
          InitTale(
            taleModel: event.taleModel,
            isAutoPlay: event.isAutoPlay,
          ),
        );
      }
    });
    on<Pause>((event, emit) async {
      await _soundPlayer?.pausePlayer();

      emit(
        state.copyWith(
          isTaleEnd: false,
          isPlay: false,
        ),
      );
    });
    on<Seek>((event, emit) {
      int currentPlayTimeInSec = event.currentPlayTimeInSec.toInt();
      _soundPlayer?.seek(
        currentPlayTime: Duration(seconds: currentPlayTimeInSec),
      );
      emit(
        state.copyWith(
          newPlayDuration: Duration(
            seconds: currentPlayTimeInSec,
          ),
        ),
      );
    });
    on<AnnulAudioPlayer>((event, emit) {
      add(
        InitTale(
          taleModel: state.taleModel,
          isAutoPlay: false,
        ),
      );
    });
    on<UpdateAudioPlayerDuration>((event, emit) {
      emit(
        state.copyWith(
          newPlayDuration: event.currentPlayDuration,
          newTaleModel: state.taleModel.copyWith(
            duration: event.taleDuration,
          ),
        ),
      );
    });
    on<MoveBackward15Sec>((event, emit) async {
      Duration newPlayDuration = await _soundPlayer?.moveBackward15Sec(
            currentPlayDuration: state.currentPlayDuration,
          ) ??
          Duration.zero;

      emit(
        state.copyWith(
          newPlayDuration: newPlayDuration,
        ),
      );
    });
    on<MoveForward15Sec>((event, emit) async {
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
    });
  }
}
