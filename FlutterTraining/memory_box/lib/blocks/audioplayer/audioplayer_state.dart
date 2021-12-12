part of 'audioplayer_bloc.dart';

class AudioplayerState {
  String? title;
  Duration? songDuration;
  Duration? currentPlayDuration;
  String? songUrl;
  bool? isPlay;
  bool? isInit;

  AudioplayerState({
    this.title,
    this.songDuration,
    this.currentPlayDuration,
    this.songUrl,
    this.isPlay = false,
    this.isInit = false,
  });

  AudioplayerState.initial() {
    title = '';
    songDuration = Duration.zero;
    currentPlayDuration = Duration.zero;
    songUrl = '';
    isPlay = false;
    isInit = false;
  }

  AudioplayerState copyWith({
    String? title,
    Duration? songDuration,
    Duration? currentPlayDuration,
    String? songUrl,
    bool? isPlay,
    bool? isInit,
  }) {
    return AudioplayerState(
      title: title ?? this.title,
      songDuration: songDuration ?? this.songDuration,
      currentPlayDuration: currentPlayDuration ?? this.currentPlayDuration,
      songUrl: songUrl ?? this.songUrl,
      isPlay: isPlay ?? this.isPlay,
      isInit: isInit ?? this.isInit,
    );
  }
}

// class AudioplayerInitial extends AudioplayerState {}

// class StopState extends AudioplayerState {}

class PlayState extends AudioplayerState {}
