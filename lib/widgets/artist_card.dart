import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/artist_model.dart';
import '../blocs/tracks_cubit/tracks_cubit.dart';
import '../api/audius_api.dart';
import '../screens/artist_screen.dart';

class ArtistCard extends StatelessWidget {
  final ArtistModel artist;

  ArtistCard({required this.artist});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider<TracksCubit>(
                  create: (context) => TracksCubit(context.read<AudiusAPI>()),
                  child: ArtistScreen(artist),
                )));
      },
      child: Column(
        children: [
          SizedBox(
            width: 160,
            child: AspectRatio(
              aspectRatio: 1,
              child: CircleAvatar(
                backgroundImage: NetworkImage(artist.cover),
              ),
            ),
          ),
          SizedBox(height: 5),
          Expanded(
            child: Text(
              artist.name,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ],
      ),
    );
  }
}
