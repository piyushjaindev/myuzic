import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/player_cubit/player_cubit.dart';
import '../models/track_model.dart';
import 'track_options.dart';

class TrackTile extends StatelessWidget {
  final TrackModel track;
  final String? subtitle;
  final Function? onTap;

  TrackTile({required this.track, this.subtitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      onTap: onTap as void Function()? ??
          () {
            BlocProvider.of<PlayerCubit>(context).playTracks([track]);
          },
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
        subtitle ??
            '${track.artist.name} / ${track.duration.inMinutes.toString()}:${track.duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
        style: Theme.of(context).textTheme.subtitle2,
        maxLines: 1,
      ),
      trailing: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => TrackOptions(track),
            useRootNavigator: false,
          );
        },
        child: Icon(
          Icons.more_vert,
          color: Colors.white,
        ),
      ),
    );
  }
}
