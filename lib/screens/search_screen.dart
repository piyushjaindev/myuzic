import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/search_cubit/search_cubit.dart';
import '../models/base_model.dart';
import 'view_more_results_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late String query;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          child: Column(
            children: [
              //Search bar
              TextField(
                textInputAction: TextInputAction.search,
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 14,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                    hintText: 'Search Tracks, Playlists, Artists',
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    )),
                onSubmitted: (value) {
                  setState(() {
                    query = value.trim();
                  });

                  if (query.isNotEmpty)
                    BlocProvider.of<SearchCubit>(context).searchAll(query);
                },
              ),
              SizedBox(height: 20),
              //Search results
              Expanded(
                child: BlocConsumer<SearchCubit, SearchStates>(
                    listener: (context, state) {
                      if (state is ErrorState) {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Something went wrong.'),
                          duration: Duration(seconds: 2),
                        ));
                      }
                    },
                    buildWhen: (_, current) =>
                        current is SearchAllSuccessState ||
                        current is LoadingState,
                    builder: (context, state) {
                      if (state is LoadingState)
                        return Center(child: CircularProgressIndicator());
                      else if (state is SearchAllSuccessState) {
                        return ListView(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          children: [
                            //Tracks matching search query
                            ..._buildResultSection(
                                models: state.tracks,
                                title: 'Tracks',
                                onTap: () {
                                  BlocProvider.of<SearchCubit>(context)
                                      .searchTracks(query);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ViewMoreResultsScreen(
                                              query: query, type: 'Tracks')));
                                }),
                            //Playlists matching search query
                            ..._buildResultSection(
                                models: state.playlists,
                                title: 'Playlists',
                                onTap: () {
                                  BlocProvider.of<SearchCubit>(context)
                                      .searchPlaylists(query);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ViewMoreResultsScreen(
                                              query: query,
                                              type: 'Playlists')));
                                }),
                            //Artists matching search query
                            ..._buildResultSection(
                                models: state.artists,
                                title: 'Artists',
                                onTap: () {
                                  BlocProvider.of<SearchCubit>(context)
                                      .searchArtists(query);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ViewMoreResultsScreen(
                                              query: query, type: 'Artists')));
                                }),
                            SizedBox(height: 30)
                          ],
                        );
                      } else
                        return Container();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildResultSection(
      {required List<BaseModel> models,
      required String title,
      required Function onTap}) {
    return [
      ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(title),
        trailing: GestureDetector(
          child: Text(
            'View More>',
            style: Theme.of(context).textTheme.subtitle2,
          ),
          onTap: onTap as void Function()?,
        ),
      ),
      for (BaseModel model in models) model.toTile(),
    ];
  }
}
