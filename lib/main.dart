import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme.dart';
import 'api/audius_api.dart';
import 'screens/main_screen.dart';
import 'blocs/init_cubit/init_cubit.dart';
import 'blocs/player_cubit/player_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AudiusAPI _api = AudiusAPI();
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
        value: _api,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<InitCubit>(
              create: (context) => InitCubit(_api)..init(),
            ),
            BlocProvider<PlayerCubit>(
              create: (context) => PlayerCubit(),
            ),
          ],
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: AppTheme.appTheme,
            home: AudioServiceWidget(child: MainScreen()),
          ),
        ));
  }
}
