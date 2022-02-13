import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/services/soundPlayer.dart';

part 'audioplayer_event.dart';
part 'audioplayer_state.dart';

class AudioplayerBloc extends Bloc<AudioplayerEvent, AudioplayerState> {
  AudioplayerBloc() : super(const AudioplayerState()) {
    SoundPlayer _soundPlayer = SoundPlayer();
    StreamSubscription? _soundNotifyerController;

    on<InitPlayer>((event, emit) async {
      bool _isPlayerInit = await _soundPlayer.initPlayer();

      if (_isPlayerInit) {
        emit(
          state.copyWith(
            isPlayerInit: true,
          ),
        );

        //Каждые n секунд обновляем позицию Duration и position сказки
        _soundNotifyerController =
            _soundPlayer.soundDurationStream?.listen((e) {
          print('${e.position.inMilliseconds} - ${e.duration.inMilliseconds}}');
          add(
            UpdateAudioPlayerDuration(
              currentPlayPosition: Duration(
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

    on<EnablePositionNotifyer>((event, emit) async {
      _soundNotifyerController?.resume();
    });
    on<DisablePositionNotifyer>((event, emit) async {
      _soundNotifyerController?.pause();
    });

    on<DisposePlayer>((event, emit) async {
      if (state.isPlay) await _soundPlayer.pausePlayer();
      await _soundPlayer.dispose();
      _soundNotifyerController?.cancel();
    });
    on<InitTale>((event, emit) async {
      final Completer<void> whenFinished = Completer<void>();

      Duration? taleDuration = await _soundPlayer.initTale(
          taleModel: event.taleModel,
          isAutoPlay: event.isAutoPlay,
          whenFinished: () async {
            whenFinished.complete();
          });
      print('4 init here');
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
        print('5 end play');
        emit(
          state.copyWith(
            isTaleEnd: true,
            newPlayDuration: Duration.zero,
            isPlay: false,
          ),
        );
      });
    });

    on<Play>((event, emit) async {
      print('3');
      //Если модель уже была инициализирована, то плеер продолжит с прошлого места
      if (state.isTaleInit && state.taleModel?.ID == event.taleModel.ID) {
        if (_soundPlayer.isSoundPlay) {
          return;
        }
        print('3 resune');
        await _soundPlayer.resumePlayer();
        emit(
          state.copyWith(
            isPlay: true,
          ),
        );
      } else {
        print('4 init');
        add(
          InitTale(
            taleModel: event.taleModel,
            isAutoPlay: event.isAutoPlay,
          ),
        );
      }
    });
    on<Pause>((event, emit) async {
      print('3.2');
      await _soundPlayer.pausePlayer();

      emit(
        state.copyWith(
          isPlay: false,
        ),
      );
    });
    on<Seek>((event, emit) {
      int currentPlayTimeInSec = event.currentPlayTimeInSec.toInt();
      _soundPlayer.seek(
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
          taleModel: state.taleModel!,
          isAutoPlay: false,
        ),
      );
    });
    on<UpdateAudioPlayerDuration>((event, emit) {
      emit(
        state.copyWith(
          newPlayDuration: event.currentPlayPosition,
          newTaleModel: state.taleModel?.copyWith(
            duration: event.taleDuration,
          ),
        ),
      );
    });
    on<MoveBackward15Sec>((event, emit) async {
      Duration newPlayDuration = await _soundPlayer.moveBackward15Sec(
        currentPlayDuration: state.currentPlayPosition!,
      );

      emit(
        state.copyWith(
          newPlayDuration: newPlayDuration,
        ),
      );
    });
    on<MoveForward15Sec>((event, emit) async {
      Duration newPlayDuration = await _soundPlayer.moveForward15Sec(
        currentPlayDuration: state.currentPlayPosition!,
        taleDuration: state.taleModel!.duration,
      );

      emit(
        state.copyWith(
          newPlayDuration: newPlayDuration,
        ),
      );
    });
  }
}
