import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/track_model.dart';
import '../../api/audius_api.dart';

part 'tracks_states.dart';

class TracksCubit extends Cubit<TracksStates> {
  AudiusAPI _api;

  TracksCubit(this._api) : super(LoadingState());

  void fetchTrendingTracks({int? limit, String? timePeriod, String? genre}) {
    emit(LoadingState());
    if (genre == 'Underground')
      _api.undergroundTrending().then((tracksJson) {
        List<TrackModel> tracks = tracksJson
            .map((track) =>
                TrackModel.fromJson(track, _api.streamTrack(track['id'])))
            .toList();
        emit(SuccessTracksState(tracks));
      }).catchError((_) => emit(ErrorState()));
    else
      _api
          .trendingTracks(limit: limit!, timePeriod: timePeriod!, genre: genre!)
          .then((tracksJson) {
        List<TrackModel> tracks = tracksJson
            .map((track) =>
                TrackModel.fromJson(track, _api.streamTrack(track['id'])))
            .toList();
        emit(SuccessTracksState(tracks));
      }).catchError((_) => emit(ErrorState()));
  }

  void fetchPlaylistTracks(String playlistId) {
    emit(LoadingState());
    _api.playlistTracks(playlistId).then((tracksJson) {
      List<TrackModel> tracks = tracksJson
          .map((track) =>
              TrackModel.fromJson(track, _api.streamTrack(track['id'])))
          .toList();

      emit(SuccessTracksState(tracks));
    }).catchError((_) => emit(ErrorState()));
  }

  void fetchArtistTracks(String artistId) {
    emit(LoadingState());
    _api.artistTracks(artistId).then((tracksJson) {
      List<TrackModel> tracks = tracksJson
          .map((track) =>
              TrackModel.fromJson(track, _api.streamTrack(track['id'])))
          .toList();
      emit(SuccessTracksState(tracks));
    }).catchError((_) => emit(ErrorState()));
  }
}
