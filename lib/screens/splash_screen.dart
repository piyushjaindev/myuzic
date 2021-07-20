import 'package:flutter/material.dart';
/*
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          //adds background image
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/BG.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          //actual content
          Center(child: CircularProgressIndicator())
        ],
      ),
    );
  }
}
*/

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
