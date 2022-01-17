part of 'audioplayer_bloc.dart';

class AudioplayerState {
  final TaleModel taleModel;
  final Duration currentPlayDuration;
  final bool isPlay;
  final bool isPlayerInit;
  final bool isTaleInit;
  final String? errorText;

  AudioplayerState({
    required this.taleModel,
    required this.currentPlayDuration,
    this.isPlay = false,
    this.isPlayerInit = false,
    this.isTaleInit = false,
    this.errorText,
  });

  AudioplayerState copyWith({
    TaleModel? newTaleModel,
    Duration? currentPlayDuration,
    bool? isPlay,
    bool? isPlayerInit,
    bool? isTaleInit,
    String? errorText,
  }) {
    return AudioplayerState(
      taleModel: newTaleModel ?? this.taleModel,
      currentPlayDuration: currentPlayDuration ?? this.currentPlayDuration,
      isPlay: isPlay ?? this.isPlay,
      isPlayerInit: isPlayerInit ?? this.isPlayerInit,
      isTaleInit: isTaleInit ?? this.isTaleInit,
      errorText: errorText ?? this.errorText,
    );
  }
}
