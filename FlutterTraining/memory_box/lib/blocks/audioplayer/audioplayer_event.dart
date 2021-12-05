part of 'audioplayer_bloc.dart';

@immutable
abstract class AudioplayerEvent {}

class InitPlayer extends AudioplayerEvent {
  final String title;
  // final Duration songDuration;
  final String soundUrl;

  InitPlayer({
    required this.title,
    // required this.songDuration,
    required this.soundUrl,
  });

  @override
  List<Object> get props => [title, soundUrl];
}

class Play extends AudioplayerEvent {}

class Pause extends AudioplayerEvent {}

class Seek extends AudioplayerEvent {}

class MoveForward15Sec extends AudioplayerEvent {}

class MoveBackward15Sec extends AudioplayerEvent {}

class DisposePlayer extends AudioplayerEvent {}

class UpdatePlayDuration extends AudioplayerEvent {}
