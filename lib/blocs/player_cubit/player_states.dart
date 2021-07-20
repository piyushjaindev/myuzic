part of 'player_cubit.dart';

enum PlayerStates { stopped, ready, error }

class PlayerQueueState {
  final List<MediaItem?>? _queue;
  final MediaItem? _currentMediaItem;

  int get currentIndex => _queue?.indexOf(_currentMediaItem) ?? 0;
  bool get hasNext => currentIndex < (_queue?.length ?? 0) - 1;
  bool get hasPrevious => currentIndex > 0;
  TrackModel? get currentTrack => _currentMediaItem != null
      ? TrackModel.fromMediaItem(_currentMediaItem!)
      : null;

  String get nextTitle =>
      hasNext ? _queue![currentIndex + 1]!.title : 'End of playlist';

  List<TrackModel> get queue =>
      _queue
          ?.map((mediaItem) => TrackModel.fromMediaItem(mediaItem!))
          .toList() ??
      [];

  PlayerQueueState(this._queue, this._currentMediaItem);
}

enum PlayerProcessingState { connecting, buffering, ready, completed }

class PlayerPlaybackState {
  final PlayerProcessingState? processingState;
  final bool? playing;

  PlayerPlaybackState({this.playing, this.processingState});
}
