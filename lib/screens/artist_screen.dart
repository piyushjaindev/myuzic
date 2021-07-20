import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/tracks_cubit/tracks_cubit.dart';
import '../models/artist_model.dart';
import 'tracks_list_subscreen.dart';

class ArtistScreen extends StatefulWidget {
  final ArtistModel _artist;
  ArtistScreen(this._artist);
  @override
  _ArtistScreenState createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  @override
  void initState() {
    super.initState();
    fetchTracks();
  }

  void fetchTracks() {
    context.read<TracksCubit>().fetchArtistTracks(widget._artist.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        children: [
          FractionallySizedBox(
            widthFactor: 0.4,
            child: AspectRatio(
              aspectRatio: 1,
              child: CircleAvatar(
                  backgroundImage: NetworkImage(widget._artist.cover)),
            ),
          ),
          SizedBox(height: 10),
          Text(
            widget._artist.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(height: 10),
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
