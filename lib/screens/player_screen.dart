import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../blocs/player_cubit/player_cubit.dart';
import '../models/track_model.dart';
import '../widgets/player_buttons.dart';
import '../widgets/player_progress_bar.dart';

final PanelController _panelController = PanelController();
final ItemScrollController _itemScrollController = ItemScrollController();

class PlayerScreen extends StatelessWidget {
  void _onPanelOpened(BuildContext context) {
    final index = context.read<PlayerCubit>().currentIndex!;
    _itemScrollController.scrollTo(
      index: index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<PlayerCubit, PlayerStates>(
          listener: (context, state) {
            if (state == PlayerStates.stopped) Navigator.pop(context);
          },
          child: SlidingUpPanel(
            controller: _panelController,
            minHeight: 50 + MediaQuery.of(context).padding.bottom,
            maxHeight: MediaQuery.of(context).size.height -
                MediaQuery.of(context).viewPadding.top -
                AppBar().preferredSize.height,
            //color: Color(0xFF26272C),
            color: Color(0xFF3A3A3D),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            onPanelOpened: () {
              _onPanelOpened(context);
            },
            header: _buildHeader(context),
            panel: TracksListSlidingPanel(),
            collapsed: CollapsedHead(),
            body: SlidingPanelBody(),
          )),
    );
  }

  Container _buildHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2),
      alignment: Alignment.topCenter,
      width: MediaQuery.of(context).size.width,
      child: Icon(
        Icons.maximize,
        size: 50,
        color: Colors.white,
      ),
    );
  }
}

class SlidingPanelBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerQueueState>(
        stream: context.read<PlayerCubit>().playerQueueStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final currentTrack = snapshot.data!.currentTrack!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  _buildTrackCover(currentTrack),
                  SizedBox(height: 30),
                  Text(
                    currentTrack.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(height: 15),
                  Text(
                    currentTrack.artist.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 55),
                  PlayerProgressBar(currentTrack),
                  SizedBox(height: 30),
                  _buildPlayerButtons(snapshot.data!),
                ],
              ),
            );
          } else
            return Container();
        });
  }

  FractionallySizedBox _buildTrackCover(TrackModel track) {
    return FractionallySizedBox(
      widthFactor: 0.7,
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Hero(
              tag: track.id,
              child: track.cover.isNotEmpty
                  ? FadeInImage(
                      image: NetworkImage(track.cover),
                      placeholder: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.fill,
                    )
                  : Image.asset('assets/images/logo.png'),
            )),
      ),
    );
  }

  Widget _buildPlayerButtons(PlayerQueueState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PreviousButton(state.hasPrevious),
        SizedBox(width: 30),
        PlayButton(),
        SizedBox(width: 30),
        NextButton(state.hasNext),
      ],
    );
  }
}

class CollapsedHead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerQueueState>(
        stream: context.read<PlayerCubit>().playerQueueStream,
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return Container(
              decoration: BoxDecoration(
                color: Color(0xFF3A3A3D),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: ListTile(
                title: Text('UpNext: ${snapshot.data!.nextTitle}', maxLines: 1),
                trailing: IconButton(
                  icon: Icon(Icons.keyboard_arrow_up),
                  iconSize: 35,
                  color: Colors.white,
                  onPressed: _panelController.open,
                ),
              ),
            );
          else
            return Center(child: CircularProgressIndicator());
        });
  }
}

class TracksListSlidingPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 25),
        Expanded(
          child: StreamBuilder<PlayerQueueState>(
              stream: context.read<PlayerCubit>().playerQueueStream,
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return ScrollablePositionedList.builder(
                      padding: EdgeInsets.only(
                          bottom:
                              MediaQuery.of(context).viewPadding.vertical + 15),
                      itemCount: snapshot.data!.queue.length,
                      itemScrollController: _itemScrollController,
                      itemBuilder: (context, index) {
                        return _buildTrackTile(
                            indexedTrack: snapshot.data!.queue[index],
                            currentTrack: snapshot.data!.currentTrack!,
                            context: context);
                      });
                else
                  return Center(child: CircularProgressIndicator());
              }),
        ),
      ],
    );
  }

  Widget _buildTrackTile(
      {required TrackModel indexedTrack,
      required TrackModel currentTrack,
      required BuildContext context}) {
    bool same = indexedTrack.id == currentTrack.id;
    return Dismissible(
      key: Key(indexedTrack.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        if (!same) context.read<PlayerCubit>().removeTrack(indexedTrack);
      },
      confirmDismiss: (direction) {
        return Future.value(!same);
      },
      background: !same
          ? Container(
              color: Color(0xFFFF5964),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.delete),
                  SizedBox(width: 5),
                  Text(
                    'Delete',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(width: 10)
                ],
              ),
            )
          : null,
      child: Container(
        color: same ? Color(0xFF161A1A) : Colors.transparent,
        child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            onTap: () {
              context.read<PlayerCubit>().skipTo(indexedTrack);
            },
            selected: same,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                color: Colors.yellow,
                child: Image.network(indexedTrack.cover),
              ),
            ),
            title: Text(indexedTrack.name),
            subtitle: Text(
              '${indexedTrack.artist.name} / ${indexedTrack.duration.inMinutes.toString()}:${indexedTrack.duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.subtitle2,
              maxLines: 1,
            )),
      ),
    );
  }
}
