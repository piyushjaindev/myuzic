import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/audius_api.dart';
import '../blocs/explore_cubit/explore_cubit.dart';
import '../blocs/search_cubit/search_cubit.dart';
import '../theme.dart';
import 'explore_screen.dart';
import 'search_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int currentIndex = 0;

  void changeCurrentIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  final _navKeys = [
    GlobalKey<NavigatorState>(debugLabel: 'navkey1'),
    GlobalKey<NavigatorState>(debugLabel: 'navkey2'),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !await Navigator.maybePop(
            _navKeys[currentIndex].currentState!.context);
      },
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: [
            BlocProvider<ExploreCubit>(
              create: (context) =>
                  ExploreCubit(context.read<AudiusAPI>())..init(),
              child: NavItem(
                navKey: _navKeys[0],
                child: ExploreScreen(),
              ),
            ),
            BlocProvider<SearchCubit>(
              create: (context) => SearchCubit(context.read<AudiusAPI>()),
              child: NavItem(
                navKey: _navKeys[1],
                child: SearchScreen(),
              ),
              //child: SearchScreen(),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: changeCurrentIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.library_music_outlined), label: 'Explore'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          ],
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  const NavItem({required this.child, required this.navKey});

  final Widget child;
  final navKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navKey,
      onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
        builder: (context) => child,
        settings: settings,
      ),
    );
  }
}
