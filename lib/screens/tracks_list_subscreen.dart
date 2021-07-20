import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/player_cubit/player_cubit.dart';
import '../models/track_model.dart';
import '../widgets/gradient_button.dart';
import '../widgets/track_tile.dart';

class TracksListSubScreen extends StatelessWidget {
  final List<TrackModel> _tracks;
  TracksListSubScreen(this._tracks);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  if (_tracks.length > 0)
                    BlocProvider.of<PlayerCubit>(context)
                        .playTracks(_tracks, shuffle: true);
                },
                child: Text('Shuffle Play'),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: GradientButton(
                onPressed: () {
                  if (_tracks.length > 0)
                    BlocProvider.of<PlayerCubit>(context).playTracks(_tracks);
                },
                label: 'Play All',
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
        for (int i = 0; i < _tracks.length; i++)
          TrackTile(
            track: _tracks[i],
            onTap: () {
              BlocProvider.of<PlayerCubit>(context)
                  .playTracks(_tracks, initialIndex: i);
            },
          )
      ],
    );
  }
}
