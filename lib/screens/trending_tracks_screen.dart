import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/tracks_cubit/tracks_cubit.dart';
import '../widgets/gradient_cover.dart';
import 'tracks_list_subscreen.dart';

class TrendingTracksScreen extends StatefulWidget {
  final Color color1, color2;
  final int limit;
  final String timePeriod, genre;

  TrendingTracksScreen(
      {required this.color1,
      required this.color2,
      required this.limit,
      this.timePeriod = 'Week',
      this.genre = ''});

  @override
  _TrendingTracksScreenState createState() => _TrendingTracksScreenState();
}

class _TrendingTracksScreenState extends State<TrendingTracksScreen> {
  @override
  void initState() {
    super.initState();
    fetchTracks();
  }

  void fetchTracks() {
    context.read<TracksCubit>().fetchTrendingTracks(
        limit: widget.limit,
        timePeriod: widget.timePeriod,
        genre: widget.genre);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        children: [
          FractionallySizedBox(
            widthFactor: 0.45,
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GradientCover(
                  color1: widget.color1,
                  color2: widget.color2,
                  limit: widget.limit,
                  timePeriod: widget.timePeriod,
                  genre: widget.genre,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          BlocConsumer<TracksCubit, TracksStates>(
            listener: (context, state) {
              if (state is ErrorState) {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Something went wrong.'),
                  duration: Duration(seconds: 2),
                ));
              }
            },
            builder: (context, state) {
              if (state is SuccessTracksState)
                return TracksListSubScreen(state.tracks);
              else if (state is ErrorState)
                return Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.4,
                    child: OutlinedButton(
                      onPressed: fetchTracks,
                      child: Text('Retry'),
                    ),
                  ),
                );
              else
                return Center(child: CircularProgressIndicator());
            },
          ),
          SizedBox(height: 30)
        ],
      ),
    );
  }
}
