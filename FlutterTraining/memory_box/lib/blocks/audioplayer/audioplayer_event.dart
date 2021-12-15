part of 'audioplayer_bloc.dart';

@immutable
abstract class AudioplayerEvent {}

class InitPlayer extends AudioplayerEvent {
  final String soundUrl;
  final String soundTitle;
  InitPlayer({
    required this.soundUrl,
    required this.soundTitle,
  });

  @override
  List<Object> get props => [soundUrl, soundTitle];
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

class StartTimer extends AudioplayerEvent {}

class StopTimer extends AudioplayerEvent {}

class UpdateSoundTitle extends AudioplayerEvent {
  String title;

  UpdateSoundTitle(this.title);
}

class LocalSaveSound extends AudioplayerEvent {}

class DeleteSound extends AudioplayerEvent {}

class ShareSound extends AudioplayerEvent {}
