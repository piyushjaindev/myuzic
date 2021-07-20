import 'package:flutter/material.dart';

class GradientCover extends StatelessWidget {
  final Color color1, color2;
  final int limit;
  final String timePeriod, genre;

  GradientCover(
      {required this.color1,
      required this.color2,
      required this.limit,
      this.timePeriod = 'Week',
      this.genre = ''});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color1.withOpacity(1),
                  color2.withOpacity(0.3),
                ],
              )),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 12, right: 35),
                child: Text(
                  genre == 'Underground'
                      ? 'Top $limit Underground'
                      : 'Top $limit ${timePeriod}ly',
                  style: Theme.of(context).textTheme.headline6,
                  //textAlign: TextAlign.center,
                ),
              ),
              alignment: Alignment.topLeft,
            ),
          ],
        ),
      ),
    );
  }
}
