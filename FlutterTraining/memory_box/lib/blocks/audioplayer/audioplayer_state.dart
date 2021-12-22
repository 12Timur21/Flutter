part of 'audioplayer_bloc.dart';

class AudioplayerState {
  TaleModel? soundModel;
  Duration? currentPlayDuration;
  bool? isPlay;
  bool? isInit;

  AudioplayerState({
    this.soundModel,
    this.currentPlayDuration,
    this.isPlay = false,
    this.isInit = false,
  });

  AudioplayerState.initial() {
    soundModel?.title = '';
    soundModel?.duration = Duration.zero;
    currentPlayDuration = Duration.zero;
    isPlay = false;
    isInit = false;
  }

  AudioplayerState copyWith({
    TaleModel? newSoundModel,
    String? title,
    Duration? soundDuration,
    Duration? currentPlayDuration,
    String? soundUrl,
    bool? isPlay,
    bool? isInit,
  }) {
    soundModel?.title ??= title;
    soundModel?.duration ??= soundDuration;

    return AudioplayerState(
      soundModel: newSoundModel ?? soundModel,
      currentPlayDuration: currentPlayDuration ?? this.currentPlayDuration,
      isPlay: isPlay ?? this.isPlay,
      isInit: isInit ?? this.isInit,
    );
  }
}
