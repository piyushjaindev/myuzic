import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/player_cubit/player_cubit.dart';

class PlayButton extends StatelessWidget {
  Widget _playerButton(
      PlayerPlaybackState? playbackState, BuildContext context) {
    // 1
    final processingState = playbackState?.processingState;
    if (processingState == PlayerProcessingState.connecting ||
        processingState == PlayerProcessingState.buffering) {
      // 2
      return Container(
        height: 30,
        width: 30,
        child: CircularProgressIndicator(),
      );
    } else if (processingState == PlayerProcessingState.completed) {
      //5
      return IconButton(
        icon: Icon(Icons.replay),
        padding: EdgeInsets.all(0),
        iconSize: 35,
        color: Colors.white,
        onPressed: context.read<PlayerCubit>().replay,
      );
    } else if (playbackState?.playing != true) {
      // 3
      return IconButton(
        padding: EdgeInsets.all(0),
        iconSize: 35,
        color: Colors.white,
        icon: Icon(Icons.play_arrow),
        onPressed: context.read<PlayerCubit>().play,
      );
    } else {
      // 4
      return IconButton(
        padding: EdgeInsets.all(0),
        iconSize: 35,
        color: Colors.white,
        icon: Icon(Icons.pause),
        onPressed: context.read<PlayerCubit>().pause,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerPlaybackState>(
      initialData: PlayerPlaybackState(
        playing: false,
        processingState: PlayerProcessingState.connecting,
      ),
      stream: context.read<PlayerCubit>().playerPlaybackStream,
      builder: (context, snapshot) {
        return _playerButton(snapshot.data, context);
      },
    );
  }
}

class NextButton extends StatelessWidget {
  final bool hasNext;
  NextButton([this.hasNext = false]);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.all(0),
      iconSize: 35,
      color: Colors.white,
      disabledColor: Color(0xFF7A7A7A),
      icon: Icon(Icons.skip_next),
      onPressed: hasNext ? context.read<PlayerCubit>().skipToNext : null,
    );
  }
}

class PreviousButton extends StatelessWidget {
  final bool hasPrevious;
  PreviousButton([this.hasPrevious = false]);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.all(0),
      iconSize: 35,
      color: Colors.white,
      disabledColor: Color(0xFF7A7A7A),
      icon: Icon(Icons.skip_previous),
      onPressed:
          hasPrevious ? context.read<PlayerCubit>().skipToPrevious : null,
    );
  }
}
