import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerTask extends BackgroundAudioTask {
  AudioPlayer _audioPlayer = AudioPlayer();
  List<MediaItem> _items = [];
  int _currentIndex = -1;
  bool playing = true;
  //MediaItem mediaItem;

  //StreamSubscription _currentIndexSubscription;
  //StreamSubscription _currentPositionStreamSubscription;
  late StreamSubscription _playerStateSubscription;

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    _items.clear();
    List mediaItems = params!['data'];
    for (int i = 0; i < mediaItems.length; i++) {
      MediaItem mediaItem = MediaItem.fromJson(mediaItems[i]);
      _items.add(mediaItem);
    }
    _currentIndex = params['initialIndex'];

    await AudioServiceBackground.setQueue(_items);

    onSkipToNext();

    // _currentPositionStreamSubscription =
    //     _audioPlayer.positionStream.listen((position) {
    //   AudioServiceBackground.setState(position: position);
    // });

    _playerStateSubscription =
        _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed)
        _handleProcessingCompleted();
      else
        AudioServiceBackground.setState(
          playing: playerState.playing,
          processingState: {
            ProcessingState.loading: AudioProcessingState.connecting,
            ProcessingState.buffering: AudioProcessingState.buffering,
            ProcessingState.ready: AudioProcessingState.ready,
          }[playerState.processingState],
        );
    });

    // await AudioServiceBackground.setState(
    //     controls: _getControls(),
    //     systemActions: [MediaAction.seekTo],
    //     playing: true,
    //     processingState: AudioProcessingState.ready);
  }

  @override
  Future<void> onStop() async {
    await AudioServiceBackground.setState(
        controls: [],
        playing: false,
        processingState: AudioProcessingState.ready);
    //_currentIndexSubscription?.cancel();
    //_currentPositionStreamSubscription?.cancel();
    _playerStateSubscription.cancel();
    await _audioPlayer.dispose();
    await super.onStop();
  }

  @override
  Future<void> onPlay() async {
    _audioPlayer.play();
    playing = true;
    await AudioServiceBackground.setState(
        controls: _getControls(),
        systemActions: [MediaAction.seekTo],
        position: _audioPlayer.position,
        playing: true,
        processingState: AudioProcessingState.ready);
  }

  @override
  Future<void> onPause() async {
    _audioPlayer.pause();
    playing = false;
    await AudioServiceBackground.setState(
        controls: _getControls(),
        systemActions: [MediaAction.seekTo],
        position: _audioPlayer.position,
        playing: false,
        processingState: AudioProcessingState.ready);
  }

  @override
  Future<void> onSkipToNext() async {
    if (_currentIndex < _items.length - 1) {
      _skipToIndex(_currentIndex + 1);
    }
  }

  @override
  Future<void> onSkipToPrevious() async {
    if (_currentIndex > 0) {
      _skipToIndex(_currentIndex - 1);
    }
  }

  @override
  Future<void> onSeekTo(Duration position) async {
    await _audioPlayer.seek(position);
    await AudioServiceBackground.setState(position: position);
  }

  @override
  Future<void> onSkipToQueueItem(String mediaId) async {
    _skipToIndex(_items.indexWhere((item) => item.id == mediaId));
  }

  @override
  Future<void> onTaskRemoved() async {
    await onPause();
  }

  @override
  Future<void> onClose() async {
    await onPause();
  }

  @override
  Future<void> onAddQueueItem(MediaItem mediaItem) async {
    _items.add(mediaItem);
    await AudioServiceBackground.setQueue(_items);
    await AudioServiceBackground.setState(
      controls: _getControls(),
    );
  }

  @override
  Future<void> onAddQueueItemAt(MediaItem mediaItem, int index) async {
    _items.insert(index, mediaItem);
    await AudioServiceBackground.setQueue(_items);
    await AudioServiceBackground.setState(
      controls: _getControls(),
    );
  }

  @override
  Future<void> onRemoveQueueItem(MediaItem mediaItem) async {
    _items.remove(mediaItem);
    await AudioServiceBackground.setQueue(_items);
    await AudioServiceBackground.setState(
      controls: _getControls(),
    );
  }

  @override
  Future<void> onUpdateQueue(List<MediaItem> queue) async {
    _items.clear();
    _items = queue;
    onSkipToNext();
    await AudioServiceBackground.setQueue(_items);
  }

  @override
  Future onCustomAction(String name, arguments) async {
    if (name == 'replay') {
      _skipToIndex(0);
    } else if (name == 'initialIndex') {
      _currentIndex = arguments;
    }
  }

  Future<void> _skipToIndex(int index) async {
    _currentIndex = index;
    await AudioServiceBackground.setMediaItem(_items[index]);
    _audioPlayer.setUrl(_items[index].extras!['streamURL']).then((value) async {
      await AudioServiceBackground.setState(position: Duration.zero);
      onPlay();
    }).catchError((_) {
      AudioServiceBackground.sendCustomEvent('error');
      if (_currentIndex < _items.length - 1) onSkipToNext();
    });
  }

  void _handleProcessingCompleted() {
    playing = false;
    AudioServiceBackground.setState(position: Duration.zero, playing: false);
    if (_currentIndex < _items.length - 1) {
      onSkipToNext();
    } else {
      AudioServiceBackground.setState(
          processingState: AudioProcessingState.completed);
    }
  }

  List<MediaControl> _getControls() {
    return [
      if (0 < _currentIndex) MediaControl.skipToPrevious,
      playing ? MediaControl.pause : MediaControl.play,
      if (_currentIndex < _items.length - 1) MediaControl.skipToNext,
    ];
  }
}
