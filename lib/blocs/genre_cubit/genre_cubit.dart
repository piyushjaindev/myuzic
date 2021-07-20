import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/playlist_model.dart';
import '../../models/track_model.dart';
import '../../models/artist_model.dart';
import '../../api/audius_api.dart';

part 'genre_states.dart';

class GenreCubit extends Cubit<GenreStates> {
  AudiusAPI _api;

  GenreCubit(this._api) : super(LoadingState());

  void init(String genre) {
    _searchPlaylistsByGenre(genre);
    _fetchRecommendedTracks(genre);
    _fetchArtistsByGenre(genre);
  }

  void _searchPlaylistsByGenre(String genre) {
    emit(LoadingState());
    _api.playlistsByGenre(genre).then((playlistsJson) {
      List<PlaylistModel> playlists = playlistsJson
          .map((playlist) => PlaylistModel.fromJson(playlist))
          .toList();
      emit(PlaylistSuccessState(playlists));
    }).catchError((_) => emit(ErrorState()));
  }

  void _fetchRecommendedTracks(String genre) {
    emit(LoadingState());
    _api.recommendedTracks(genre).then((tracksJson) {
      List<TrackModel> tracks = tracksJson
          .map((track) =>
              TrackModel.fromJson(track, _api.streamTrack(track['id'])))
          .toList();
      emit(RecommendedTracksSuccessState(tracks));
    }).catchError((_) => emit(ErrorState()));
  }

  void _fetchArtistsByGenre(String genre) async {
    emit(LoadingState());
    _api.topArtists(genre).then((artistsJson) {
      List<ArtistModel> artists =
          artistsJson.map((artist) => ArtistModel.fromJson(artist)).toList();
      emit(ArtistSuccessState(artists));
    }).catchError((_) => emit(ErrorState()));
  }
}
