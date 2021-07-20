import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/audius_api.dart';
import '../blocs/player_cubit/player_cubit.dart';
import '../blocs/tracks_cubit/tracks_cubit.dart';
import '../models/track_model.dart';
import '../screens/artist_screen.dart';

class TrackOptions extends StatelessWidget {
  final TrackModel track;
  TrackOptions(this.track);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: Color(0xFF3A3A3D),
      titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      title: ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
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
          title: Text(track.name),
          subtitle: Text(
            '${track.artist.name} / ${track.duration.inMinutes.toString()}:${track.duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
            style: Theme.of(context).textTheme.subtitle2,
            maxLines: 1,
          )),
      children: [
        _buildSimpleDialogOption(
            context: context,
            onPressed: () {
              context.read<PlayerCubit>().playTracks([track]);
              Navigator.pop(context);
            },
            icon: Icons.play_circle_fill_outlined,
            title: 'Play Now'),
        _buildSimpleDialogOption(
            context: context,
            onPressed: () {
              context.read<PlayerCubit>().playNext(track);
              Navigator.pop(context);
            },
            icon: Icons.queue_music_outlined,
            title: 'Play Next'),
        _buildSimpleDialogOption(
            context: context,
            onPressed: () {
              context.read<PlayerCubit>().addToQueue(track);
              Navigator.pop(context);
            },
            icon: Icons.playlist_add_outlined,
            title: 'Add to Queue'),
        _buildSimpleDialogOption(
            context: context,
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BlocProvider<TracksCubit>(
                        create: (context) =>
                            TracksCubit(context.read<AudiusAPI>()),
                        child: ArtistScreen(track.artist),
                      )));
              Navigator.pop(context);
            },
            icon: Icons.star_border_outlined,
            title: 'Go to Artist'),
      ],
    );
  }

  SimpleDialogOption _buildSimpleDialogOption(
      {required BuildContext context,
      required Function onPressed,
      required IconData icon,
      required String title}) {
    return SimpleDialogOption(
      onPressed: onPressed as void Function()?,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(width: 10),
          Text(title, style: Theme.of(context).textTheme.subtitle1),
        ],
      ),
    );
  }
}
