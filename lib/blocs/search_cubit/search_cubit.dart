import 'package:bloc/bloc.dart';

import '../../api/audius_api.dart';
import '../../models/artist_model.dart';
import '../../models/base_model.dart';
import '../../models/playlist_model.dart';
import '../../models/track_model.dart';

part 'search_states.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit(this._api) : super(InitialState());

  final AudiusAPI _api;

  void searchAll(String query) async {
    emit(LoadingState());
    try {
      final result = await _api.search(query: query);
      List<TrackModel> tracks = result['tracks']
          .map<TrackModel>((track) =>
              TrackModel.fromJson(track, _api.streamTrack(track['id'])))
          .toList();
      List<PlaylistModel> playlists = result['playlists']
          .map<PlaylistModel>((playlist) => PlaylistModel.fromJson(playlist))
          .toList();
      List<ArtistModel> artists = result['users']
          .where((user) => user['is_creator'] as bool)
          .map<ArtistModel>((artist) => ArtistModel.fromJson(artist))
          .toList();
      emit(SearchAllSuccessState(
          artists: artists, tracks: tracks, playlists: playlists));
    } catch (e) {
      emit(ErrorState());
    }
  }

  void searchArtists(String query) async {
    emit(MoreResultsLoadingState());
    try {
      final result = await _api.search(query: query, limit: 50, type: 'users');
      List<ArtistModel> artists = result['users']
          .where((user) => user['is_creator'] as bool)
          .map<ArtistModel>((artist) => ArtistModel.fromJson(artist))
          .toList();
      emit(SearchSpecificSuccessState(artists));
    } catch (e) {
      emit(ErrorState());
    }
  }

  void searchTracks(String query) async {
    emit(MoreResultsLoadingState());
    try {
      final result = await _api.search(query: query, limit: 30, type: 'tracks');
      List<TrackModel> tracks = result['tracks']
          .map<TrackModel>((track) =>
              TrackModel.fromJson(track, _api.streamTrack(track['id'])))
          .toList();
      emit(SearchSpecificSuccessState(tracks));
    } catch (e) {
      emit(ErrorState());
    }
  }

  void searchPlaylists(String query) async {
    emit(MoreResultsLoadingState());
    try {
      final result =
          await _api.search(query: query, limit: 20, type: 'playlists');
      List<PlaylistModel> playlists = result['playlists']
          .map<PlaylistModel>((playlist) => PlaylistModel.fromJson(playlist))
          .toList();
      emit(SearchSpecificSuccessState(playlists));
    } catch (e) {
      emit(ErrorState());
    }
  }
}
