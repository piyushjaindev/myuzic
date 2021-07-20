import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/explore_cubit/explore_cubit.dart';
import '../models/playlist_model.dart';
import '../widgets/cards_list_view.dart';
import '../widgets/genre_card.dart';
import '../widgets/playlist_card.dart';
import '../widgets/trending_gradient_card.dart';

class ExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        //Listens for errors while fetching contents from explore_cubit and shows snackbar if there is any error.
        child: BlocListener<ExploreCubit, ExploreStates>(
          listener: (context, state) {
            if (state is ErrorState) {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Something went wrong.'),
                duration: Duration(seconds: 2),
              ));
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
            child: Column(
              children: [
                // Trending playlists of the week section
                ListTile(
                  title: Text(
                    'Playlist Picks',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                SizedBox(
                  height: 225,
                  child: BlocBuilder<ExploreCubit, ExploreStates>(
                      buildWhen: (previous, current) =>
                          current is TrendingPlaylistsSuccessState,
                      builder: (context, state) {
                        if (state is TrendingPlaylistsSuccessState)
                          return CardsListView(state.playlists);
                        else
                          return Center(child: CircularProgressIndicator());
                      }),
                ),
                //Highlights Section
                ListTile(
                  title: Text(
                    'Highlights',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                SizedBox(
                  height: 225,
                  child: _buildHighlightsSection(),
                ),
                //Horizontal ListView of genres
                ListTile(
                  title: Text(
                    'Browse',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  subtitle: Text(
                    'Explore by genres',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
                SizedBox(
                  height: 125,
                  child: _buildGenreListView(),
                ),
                //All time top playlists section
                ListTile(
                  title: Text(
                    'Popular playlists',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                SizedBox(
                  height: 225,
                  child: BlocBuilder<ExploreCubit, ExploreStates>(
                      buildWhen: (previous, current) =>
                          current is TopPlaylistsSuccessState,
                      builder: (context, state) {
                        if (state is TopPlaylistsSuccessState)
                          return CardsListView(state.playlists);
                        else
                          return Center(child: CircularProgressIndicator());
                      }),
                ),
                //All time top artists section
                ListTile(
                  title: Text(
                    'Top Artists',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                SizedBox(
                  height: 225,
                  child: BlocBuilder<ExploreCubit, ExploreStates>(
                      buildWhen: (previous, current) =>
                          current is TopArtistsSuccessState,
                      builder: (context, state) {
                        if (state is TopArtistsSuccessState)
                          return CardsListView(state.artists);
                        else
                          return Center(child: CircularProgressIndicator());
                      }),
                ),
                SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightsSection() {
    return ListView(
      padding: EdgeInsets.only(left: 12, top: 10, bottom: 20),
      children: [
        PlaylistCard(
          playlist: PlaylistModel(
            name: 'Hot & New🔥',
            cover:
                'https://usermetadata.audius.co/ipfs/Qmc7RFzLGgW3DUTgKK49LzxEwe3Lmb47q85ZwJJRVYTXPr/150x150.jpg',
            id: 'DOPRl',
          ),
        ),
        SizedBox(width: 15),
        TrendingGradientCard(
            color1: Color(0xFFCD98FF),
            color2: Color(0xFF2AF59A),
            title: 'Trending This Week',
            limit: 30,
            timePeriod: 'Week'),
        SizedBox(width: 15),
        TrendingGradientCard(
            color1: Color(0xFF2AF59A),
            color2: Color(0xFF08AEEA),
            title: 'Trending This Month',
            limit: 100,
            timePeriod: 'Month'),
        SizedBox(width: 15),
        TrendingGradientCard(
            color1: Color(0xFFFFA73B),
            color2: Color(0xFFFF2525),
            title: 'Underground Trending',
            limit: 50,
            genre: 'Underground')
      ],
      scrollDirection: Axis.horizontal,
    );
  }

  Widget _buildGenreListView() {
    return ListView.separated(
      padding: EdgeInsets.only(left: 12, top: 10, bottom: 20),
      itemBuilder: (context, index) => GenreCard(genres[index]),
      separatorBuilder: (context, index) => SizedBox(width: 15),
      itemCount: genres.length,
      scrollDirection: Axis.horizontal,
    );
  }
}

const genres = [
  'Electronic',
  'Pop',
  'Rock',
  'Alternative',
  'Jazz',
  'Hip-Hop/Rap',
  'Metal',
  'R&B/Soul',
  'Punk',
  'Country',
  'Classical',
  'Folk'
];
