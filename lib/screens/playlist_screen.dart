import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/tracks_cubit/tracks_cubit.dart';
import '../models/playlist_model.dart';
import 'tracks_list_subscreen.dart';

class PlaylistScreen extends StatefulWidget {
  final PlaylistModel _playlist;
  PlaylistScreen(this._playlist);

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  @override
  void initState() {
    super.initState();
    fetchTracks();
  }

  void fetchTracks() {
    context.read<TracksCubit>().fetchPlaylistTracks(widget._playlist.id);
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
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage(
                    image: NetworkImage(widget._playlist.cover),
                    placeholder: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.fill,
                  )),
            ),
          ),
          SizedBox(height: 10),
          Text(
            widget._playlist.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(height: 15),
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
