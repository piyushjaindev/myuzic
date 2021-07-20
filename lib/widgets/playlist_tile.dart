import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/audius_api.dart';
import '../blocs/tracks_cubit/tracks_cubit.dart';
import '../models/playlist_model.dart';
import '../screens/playlist_screen.dart';

class PlaylistTile extends StatelessWidget {
  final PlaylistModel playlist;
  final String? subtitle;

  PlaylistTile({required this.playlist, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider<TracksCubit>(
                  create: (context) => TracksCubit(context.read<AudiusAPI>()),
                  child: PlaylistScreen(playlist),
                )));
      },
      leading: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
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
      title: Text(playlist.name),
      subtitle: Text(
        subtitle ?? 'Playlist',
        style: Theme.of(context).textTheme.subtitle2,
      ),
    );
  }
}
