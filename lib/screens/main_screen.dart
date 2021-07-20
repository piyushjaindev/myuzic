import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/init_cubit/init_cubit.dart';
import 'error_screen.dart';
import 'player_bottomnavigation_stack.dart';
import 'splash_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<InitCubit, InitStates>(
        builder: (context, state) {
          if (state is ErrorState)
            return ErrorScreen();
          else if (state is SuccessState)
            return PlayerBottomNavigationStack();
          else
            return SplashScreen();
        },
      ),
    );
  }
}
