import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/search_cubit/search_cubit.dart';

class ViewMoreResultsScreen extends StatelessWidget {
  final String query;
  final String type;

  ViewMoreResultsScreen({required this.query, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search:$query in $type'),
      ),
      body: BlocConsumer<SearchCubit, SearchStates>(
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
          if (state is SearchSpecificSuccessState)
            return ListView.builder(
              padding: const EdgeInsets.all(15.0),
              itemCount: state.models.length,
              itemBuilder: (context, index) => state.models[index].toTile(''),
            );
          else
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
