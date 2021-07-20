import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/audius_api.dart';
import '../../models/playlist_model.dart';
import '../../models/artist_model.dart';

part 'explore_states.dart';

const excludedPlaylistsId = ['DOPRl', 'eY9Yk'];

class ExploreCubit extends Cubit<ExploreStates> {
  AudiusAPI _api;

  ExploreCubit(this._api) : super(LoadingState());

  void init() async {
    _fetchTrendingPlaylists();
    _fetchTopPlaylists();
    _fetchTopArtists();
  }

  void _fetchTrendingPlaylists() async {
    _api.trendingPlaylists().then((playlistsJson) {
      List<PlaylistModel> playlists = [];
      for (var playlist in playlistsJson) {
        if (excludedPlaylistsId.contains(playlist['id']))
          continue;
        else
          playlists.add(PlaylistModel.fromJson(playlist));
      }
      emit(TrendingPlaylistsSuccessState(playlists));
    }).catchError((_) => emit(ErrorState()));
  }

  void _fetchTopPlaylists() async {
    _api.topPlaylistsAlbums(type: 'playlist', limit: 15).then((playlistsJson) {
      List<PlaylistModel> playlists = [];
      for (var playlist in playlistsJson) {
        if (excludedPlaylistsId.contains(playlist['id']))
          continue;
        else
          playlists.add(PlaylistModel.fromJson(playlist));
      }
      emit(TopPlaylistsSuccessState(playlists));
    }).catchError((_) => emit(ErrorState()));
  }

  void _fetchTopArtists() async {
    _api.topArtists().then((artistsJson) {
      List<ArtistModel> artists =
          artistsJson.map((artist) => ArtistModel.fromJson(artist)).toList();
      emit(TopArtistsSuccessState(artists));
    }).catchError((_) => emit(ErrorState()));
  }
}
