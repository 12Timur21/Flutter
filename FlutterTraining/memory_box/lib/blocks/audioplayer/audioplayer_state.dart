part of 'audioplayer_bloc.dart';

class AudioplayerState {
  final TaleModel taleModel;
  final Duration currentPlayDuration;
  final bool isPlay;
  final bool isPlayerInit;
  final bool isTaleInit;
  final bool isTaleEnd;
  final String? errorText;

  AudioplayerState({
    required this.taleModel,
    required this.currentPlayDuration,
    this.isPlay = false,
    this.isPlayerInit = false,
    this.isTaleInit = false,
    this.isTaleEnd = false,
    this.errorText,
  });

  AudioplayerState copyWith({
    TaleModel? newTaleModel,
    Duration? newPlayDuration,
    bool? isPlay,
    bool? isPlayerInit,
    bool? isTaleInit,
    bool? isTaleEnd,
    String? errorText,
  }) {
    return AudioplayerState(
      taleModel: newTaleModel ?? taleModel,
      currentPlayDuration: newPlayDuration ?? currentPlayDuration,
      isPlay: isPlay ?? this.isPlay,
      isPlayerInit: isPlayerInit ?? this.isPlayerInit,
      isTaleInit: isTaleInit ?? this.isTaleInit,
      isTaleEnd: isTaleEnd ?? this.isTaleEnd,
      errorText: errorText ?? this.errorText,
    );
  }
}
