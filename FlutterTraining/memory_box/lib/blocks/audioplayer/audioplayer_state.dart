part of 'audioplayer_bloc.dart';

class AudioplayerState {
  String? title;
  Duration? songDuration;
  Duration? currentPlayDuration;
  String? songUrl;
  bool isPlay = false;

  AudioplayerState({
    this.title,
    this.songDuration,
    this.currentPlayDuration,
    this.songUrl,
  });

  AudioplayerState.initial() {
    title = '';
    songDuration = Duration.zero;
    currentPlayDuration = Duration.zero;
    songUrl = '';
    isPlay = false;
  }
}

// class AudioplayerInitial extends AudioplayerState {}

// class StopState extends AudioplayerState {}

class PlayState extends AudioplayerState {}
