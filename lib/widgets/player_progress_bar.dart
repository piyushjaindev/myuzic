import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/player_cubit/player_cubit.dart';
import '../models/track_model.dart';

// ignore: must_be_immutable
class PlayerProgressBar extends StatelessWidget {
  final TrackModel currentTrack;
  PlayerProgressBar(this.currentTrack);

  double? _draggedPosition;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
        initialData: Duration.zero,
        stream: context.read<PlayerCubit>().playerPostionStream,
        builder: (context, snapshot) {
          final currentDuration = snapshot.data!;
          final totalDuration = currentTrack.duration;
          return Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                  '${currentDuration.inMinutes.toString()}:${currentDuration.inSeconds.remainder(60).toString().padLeft(2, '0')}'),
              SizedBox(width: 20),
              Expanded(
                child: Slider(
                    min: 0,
                    max: totalDuration.inMilliseconds.toDouble() + 2000,
                    value: _draggedPosition ??
                        currentDuration.inMilliseconds.toDouble(),
                    onChanged: (val) => _draggedPosition = val,
                    onChangeStart: (value) => _draggedPosition = value,
                    onChangeEnd: (value) {
                      context.read<PlayerCubit>().seekTo(value.toInt());
                      _draggedPosition = null;
                    }),
              ),
              Text(
                  '${totalDuration.inMinutes.toString()}:${totalDuration.inSeconds.remainder(60).toString().padLeft(2, '0')}'),
            ],
          );
        });
  }
}
