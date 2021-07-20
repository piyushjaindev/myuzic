import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/player_cubit/player_cubit.dart';
import '../models/track_model.dart';
import '../screens/player_screen.dart';
import 'player_buttons.dart';

class PlayerTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlayerCubit, PlayerStates>(
      listener: (context, state) {
        if (state == PlayerStates.error) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Unable to play this track.'),
            duration: Duration(seconds: 2),
          ));
        }
      },
      buildWhen: (previous, current) => current != PlayerStates.error,
      builder: (context, state) {
        if (state == PlayerStates.ready)
          return Positioned(
              left: 3,
              right: 3,
              bottom: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.bottom +
                  3,
              child: StreamBuilder<PlayerQueueState>(
                  stream: context.read<PlayerCubit>().playerQueueStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.currentTrack != null)
                      return _createPlayerTile(snapshot.data!, context);
                    else
                      return Container(
                        height: 60,
                        color: Color(0xFF303033),
                        child: Center(child: CircularProgressIndicator()),
                      );
                  }));
        else
          return Container();
      },
    );
  }

  Widget _createPlayerTile(
      PlayerQueueState playerQueueState, BuildContext context) {
    TrackModel currentTrack = playerQueueState.currentTrack!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Dismissible(
        key: Key('Some Key'),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) => context.read<PlayerCubit>().stop(),
        child: Container(
          color: Color(0xFF303033),
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PlayerScreen(),
                fullscreenDialog: true,
              ));
            },
            contentPadding: EdgeInsets.only(left: 5),
            dense: true,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Hero(
                tag: currentTrack.id,
                child: currentTrack.cover.isNotEmpty
                    ? FadeInImage(
                        image: NetworkImage(
                          currentTrack.cover,
                        ),
                        placeholder: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.fill,
                      )
                    : Image.asset('assets/images/logo.png'),
              ),
            ),
            title: Text(currentTrack.name, maxLines: 1),
            subtitle: Text(
              currentTrack.artist.name,
              maxLines: 1,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PlayButton(),
                SizedBox(width: 5),
                NextButton(playerQueueState.hasNext),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
