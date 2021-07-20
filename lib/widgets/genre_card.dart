import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/genre_cubit/genre_cubit.dart';
import '../screens/genre_screen.dart';
import '../api/audius_api.dart';

class GenreCard extends StatelessWidget {
  final String genre;
  GenreCard(this.genre);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider<GenreCubit>(
                  create: (context) =>
                      GenreCubit(context.read<AudiusAPI>())..init(genre),
                  child: GenreScreen(genre),
                )));
      },
      child: AspectRatio(
        aspectRatio: 1.7,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFF500AF).withOpacity(0.6),
                Color(0xFFBB27FF).withOpacity(0.6),
              ],
            )),
            child: Text(
              genre,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
