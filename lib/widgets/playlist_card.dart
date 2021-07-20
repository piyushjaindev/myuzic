import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/audius_api.dart';
import '../blocs/tracks_cubit/tracks_cubit.dart';
import '../models/playlist_model.dart';
import '../screens/playlist_screen.dart';

class PlaylistCard extends StatelessWidget {
  final PlaylistModel playlist;

  PlaylistCard({required this.playlist});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider<TracksCubit>(
                  create: (context) => TracksCubit(context.read<AudiusAPI>()),
                  child: PlaylistScreen(playlist),
                )));
      },
      child: AspectRatio(
        aspectRatio: 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: playlist.cover.isNotEmpty
                    ? FadeInImage(
                        image: NetworkImage(
                          playlist.cover,
                        ),
                        placeholder: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.fill,
                      )
                    : Image.asset('assets/images/logo.png'),
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              child: Text(
                playlist.name,
                style: Theme.of(context).textTheme.bodyText1,
                overflow: TextOverflow.clip,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
