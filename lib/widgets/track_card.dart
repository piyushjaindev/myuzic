import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/player_cubit/player_cubit.dart';
import '../models/track_model.dart';

class TrackCard extends StatelessWidget {
  final TrackModel track;

  TrackCard({required this.track});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<PlayerCubit>(context).playTracks([track]);
      },
      child: AspectRatio(
        aspectRatio: 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: track.cover.isNotEmpty
                        ? FadeInImage(
                            image: NetworkImage(
                              track.cover,
                            ),
                            placeholder: AssetImage('assets/images/logo.png'),
                            fit: BoxFit.fill,
                          )
                        : Image.asset('assets/images/logo.png'),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.4),
                  child: Icon(Icons.play_arrow),
                )
              ],
            ),
            SizedBox(height: 5),
            Expanded(
              child: Text(
                track.name,
                style: Theme.of(context).textTheme.bodyText1,
                overflow: TextOverflow.clip,
                maxLines: 1,
              ),
            ),
            Text(
              track.artist.name,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
