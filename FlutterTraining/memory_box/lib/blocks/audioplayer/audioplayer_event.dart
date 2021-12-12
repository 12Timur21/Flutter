part of 'audioplayer_bloc.dart';

@immutable
abstract class AudioplayerEvent {}

class InitPlayer extends AudioplayerEvent {
  final String title;
  final String soundUrl;

  InitPlayer({
    required this.title,
    required this.soundUrl,
  });

  @override
  List<Object> get props => [title, soundUrl];
}

class Play extends AudioplayerEvent {}

class Pause extends AudioplayerEvent {}

class Seek extends AudioplayerEvent {
  double currentPlayTimeInSec;
  Seek({
    required this.currentPlayTimeInSec,
  });
}

class MoveForward15Sec extends AudioplayerEvent {}

class MoveBackward15Sec extends AudioplayerEvent {}

class DisposePlayer extends AudioplayerEvent {}

class UpdatePlayDuration extends AudioplayerEvent {}

class DeleteSong extends AudioplayerEvent {}

class StartTimer extends AudioplayerEvent {}

class StopTimer extends AudioplayerEvent {}
