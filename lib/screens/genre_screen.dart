import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/trending_gradient_card.dart';
import '../widgets/cards_list_view.dart';
import '../blocs/genre_cubit/genre_cubit.dart';

class GenreScreen extends StatelessWidget {
  final String genre;
  GenreScreen(this.genre);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          genre,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      //Listens for errors while fetching contents from genre_cubit and shows snackbar if there is any error.
      body: BlocListener<GenreCubit, GenreStates>(
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
              //Recommended Tracks Section
              ListTile(
                title: Text(
                  'Recommended Tracks',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              SizedBox(
                height: 225,
                child: BlocBuilder<GenreCubit, GenreStates>(
                    buildWhen: (previous, current) =>
                        current is RecommendedTracksSuccessState,
                    builder: (context, state) {
                      if (state is RecommendedTracksSuccessState)
                        return CardsListView(state.tracks);
                      else
                        return Center(child: CircularProgressIndicator());
                    }),
              ),
              // Genre Trending Tracks Section
              ListTile(
                title: Text(
                  'Trending',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              SizedBox(
                height: 225,
                child: _buildTrendingSection(),
              ),
              //Genre Playlists Section
              ListTile(
                title: Text(
                  'Playlists',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              SizedBox(
                height: 225,
                child: BlocBuilder<GenreCubit, GenreStates>(
                    buildWhen: (previous, current) =>
                        current is PlaylistSuccessState,
                    builder: (context, state) {
                      if (state is PlaylistSuccessState)
                        return CardsListView(state.playlists);
                      else
                        return Center(child: CircularProgressIndicator());
                    }),
              ),
              //Genre Top Artists Section
              ListTile(
                title: Text(
                  'Artists',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              SizedBox(
                height: 225,
                child: BlocBuilder<GenreCubit, GenreStates>(
                    buildWhen: (previous, current) =>
                        current is ArtistSuccessState,
                    builder: (context, state) {
                      if (state is ArtistSuccessState)
                        return CardsListView(state.artists);
                      else
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                    }),
              ),
              SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingSection() {
    return ListView(
      padding: EdgeInsets.only(left: 12, top: 10, bottom: 20),
      children: [
        TrendingGradientCard(
            color1: Color(0xFFCD98FF),
            color2: Color(0xFF2AF59A),
            title: 'Trending This Week',
            limit: 10,
            genre: genre,
            timePeriod: 'Week'),
        SizedBox(width: 15),
        TrendingGradientCard(
            color1: Color(0xFF2AF59A),
            color2: Color(0xFF08AEEA),
            title: 'Trending This Month',
            limit: 25,
            genre: genre,
            timePeriod: 'Month'),
      ],
      scrollDirection: Axis.horizontal,
    );
  }
}
