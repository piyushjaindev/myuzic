import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'gradient_cover.dart';
import '../blocs/tracks_cubit/tracks_cubit.dart';
import '../api/audius_api.dart';
import '../screens/trending_tracks_screen.dart';

class TrendingGradientCard extends StatelessWidget {
  final Color color1, color2;
  final int limit;
  final String title, timePeriod, genre;

  TrendingGradientCard(
      {required this.color1,
      required this.color2,
      required this.title,
      required this.limit,
      this.timePeriod = 'Week',
      this.genre = ''});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider<TracksCubit>(
                  create: (context) => TracksCubit(context.read<AudiusAPI>()),
                  child: TrendingTracksScreen(
                    color1: color1,
                    color2: color2,
                    limit: limit,
                    timePeriod: timePeriod,
                    genre: genre,
                  ),
                )));
      },
      child: AspectRatio(
        aspectRatio: 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientCover(
              color1: color1,
              color2: color2,
              limit: limit,
              timePeriod: timePeriod,
              genre: genre,
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}
