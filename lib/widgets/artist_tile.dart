import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/artist_model.dart';
import '../blocs/tracks_cubit/tracks_cubit.dart';
import '../api/audius_api.dart';
import '../screens/artist_screen.dart';

class ArtistTile extends StatelessWidget {
  final ArtistModel artist;
  final String? subtitle;

  ArtistTile({required this.artist, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider<TracksCubit>(
                  create: (context) => TracksCubit(context.read<AudiusAPI>()),
                  child: ArtistScreen(artist),
                )));
      },
      leading: AspectRatio(
        aspectRatio: 1,
        child: CircleAvatar(
          backgroundImage: NetworkImage(artist.cover),
        ),
      ),
      title: Text(artist.name),
      subtitle: Text(
        subtitle ?? 'Artist',
        style: Theme.of(context).textTheme.subtitle2,
      ),
    );
  }
}
