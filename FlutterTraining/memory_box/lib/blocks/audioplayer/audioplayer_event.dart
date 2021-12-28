part of 'audioplayer_bloc.dart';

abstract class AudioplayerEvent {}

class InitPlayer extends AudioplayerEvent {
  TaleModel soundModel;
  InitPlayer({
    required this.soundModel,
  });
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

class UpdateSoundModel extends AudioplayerEvent {
  String? title;

  UpdateSoundModel({this.title});
}

class LocalSaveSound extends AudioplayerEvent {}

class DeleteSound extends AudioplayerEvent {}

class ShareSound extends AudioplayerEvent {}
