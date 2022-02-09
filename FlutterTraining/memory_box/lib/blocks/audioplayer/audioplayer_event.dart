part of 'audioplayer_bloc.dart';

abstract class AudioplayerEvent {}

class InitPlayer extends AudioplayerEvent {}

class InitTale extends AudioplayerEvent {
  final TaleModel taleModel;
  final bool isAutoPlay;
  InitTale({
    required this.taleModel,
    this.isAutoPlay = true,
  });
}

class DisposePlayer extends AudioplayerEvent {}

class Play extends AudioplayerEvent {
  final TaleModel taleModel;
  final bool isAutoPlay;
  Play({
    required this.taleModel,
    this.isAutoPlay = false,
  });
}

class Pause extends AudioplayerEvent {}

class Seek extends AudioplayerEvent {
  double currentPlayTimeInSec;
  Seek({
    required this.currentPlayTimeInSec,
  });
}

class EnablePositionNotifyer extends AudioplayerEvent {}

class DisablePositionNotifyer extends AudioplayerEvent {}

class MoveForward15Sec extends AudioplayerEvent {}

class MoveBackward15Sec extends AudioplayerEvent {}

class AnnulAudioPlayer extends AudioplayerEvent {}

class UpdateAudioPlayerDuration extends AudioplayerEvent {
  final Duration currentPlayPosition;
  final Duration taleDuration;

  UpdateAudioPlayerDuration({
    required this.currentPlayPosition,
    required this.taleDuration,
  });
}
