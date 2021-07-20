import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../audio_player_task.dart';
import '../../models/track_model.dart';

part 'player_states.dart';

backgroundTaskEntrypoint() {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

class PlayerCubit extends Cubit<PlayerStates> {
  PlayerCubit() : super(PlayerStates.stopped) {
    init();
  }
  int? _currentIndex;
  late StreamSubscription _audioServiceRunningSubscription;
  late StreamSubscription _customEventSubscription;
  late StreamSubscription _queueStreamSubscription;

  Stream<PlayerQueueState> get playerQueueStream =>
      Rx.combineLatest2<List<MediaItem>?, MediaItem?, PlayerQueueState>(
        AudioService.queueStream,
        AudioService.currentMediaItemStream,
        (queue, mediaItem) => PlayerQueueState(queue, mediaItem),
      );

  Stream<PlayerPlaybackState> get playerPlaybackStream =>
      AudioService.playbackStateStream.map(
        (playbackState) => PlayerPlaybackState(
          playing: playbackState.playing,
          processingState: {
            AudioProcessingState.connecting: PlayerProcessingState.connecting,
            AudioProcessingState.buffering: PlayerProcessingState.buffering,
            AudioProcessingState.ready: PlayerProcessingState.ready,
            AudioProcessingState.completed: PlayerProcessingState.completed
          }[playbackState.processingState],
        ),
      );

  Stream<Duration> get playerPostionStream => AudioService.positionStream;

  int? get currentIndex => _currentIndex;

  void init() {
    _audioServiceRunningSubscription =
        AudioService.runningStream.listen((isRunning) {
      if (isRunning)
        emit(PlayerStates.ready);
      else
        emit(PlayerStates.stopped);
    });

    _customEventSubscription = AudioService.customEventStream.listen((event) {
      if (event == 'error') emit(PlayerStates.error);
    });

    _queueStreamSubscription = playerQueueStream.listen((queueState) {
      _currentIndex = queueState.currentIndex;
    });
  }

  @override
  Future<void> close() async {
    _audioServiceRunningSubscription.cancel();
    _customEventSubscription.cancel();
    _queueStreamSubscription.cancel();
    return super.close();
  }

  Future<void> playTracks(List<TrackModel> tracks,
      {bool shuffle = false, int initialIndex = 0}) async {
    // shuffle the tracks list if true
    if (shuffle) tracks.shuffle();
    // check if audio_service is connect
    if (!AudioService.connected) await AudioService.connect();
    // stop audio_service if already running
    if (AudioService.running) {
      AudioService.customAction('initialIndex', initialIndex - 1);
      AudioService.updateQueue(
          tracks.map((track) => track.toMediaItem()).toList());
    } else
      //start the background audio_service
      await AudioService.start(
          backgroundTaskEntrypoint: backgroundTaskEntrypoint,
          androidEnableQueue: true,
          //androidStopForegroundOnPause: true,
          params: {
            'data':
                tracks.map((track) => track.toMediaItem().toJson()).toList(),
            'initialIndex': initialIndex - 1,
          }).catchError((_) => emit(PlayerStates.error));
  }

  void stop() => AudioService.stop();
  void pause() => AudioService.pause();
  void play() => AudioService.play();
  void skipToNext() => AudioService.skipToNext();
  void skipToPrevious() => AudioService.skipToPrevious();
  void replay() => AudioService.customAction('replay');
  void seekTo(int value) => AudioService.seekTo(Duration(milliseconds: value));
  void skipTo(TrackModel track) => AudioService.skipToQueueItem(track.id);

  void removeTrack(TrackModel track) =>
      AudioService.removeQueueItem(track.toMediaItem());

  void addToQueue(TrackModel track) =>
      AudioService.addQueueItem(track.toMediaItem());

  void playNext(TrackModel track) {
    AudioService.addQueueItemAt(track.toMediaItem(), _currentIndex! + 1);
  }
}
