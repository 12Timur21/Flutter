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
}

// class AudioplayerInitial extends AudioplayerState {}

// class StopState extends AudioplayerState {}

// class StopState extends AudioplayerState {}
