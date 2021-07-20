import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/audius_api.dart';

part 'init_states.dart';

class InitCubit extends Cubit<InitStates> {
  AudiusAPI _api;

  InitCubit(this._api) : super(LoadingState());

  void init() async {
    emit(LoadingState());
    _api
        .init()
        .then((value) => emit(SuccessState()))
        .catchError((_) => emit(ErrorState()));
  }
}
