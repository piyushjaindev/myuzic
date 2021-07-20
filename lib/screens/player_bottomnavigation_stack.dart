import 'package:flutter/material.dart';

import '../widgets/player_tile.dart';
import 'bottom_navigation_screen.dart';

class PlayerBottomNavigationStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BottomNavigationScreen(),
        PlayerTile(),
      ],
    );
  }
}
