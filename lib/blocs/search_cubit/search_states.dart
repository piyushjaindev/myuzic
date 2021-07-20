part of 'search_cubit.dart';

abstract class SearchStates {}

class InitialState extends SearchStates {}

class LoadingState extends SearchStates {}

class MoreResultsLoadingState extends SearchStates {}

class ErrorState extends SearchStates {}

class SearchAllSuccessState extends SearchStates {
  final List<ArtistModel> artists;
  final List<TrackModel> tracks;
  final List<PlaylistModel> playlists;
  SearchAllSuccessState(
      {required this.artists, required this.playlists, required this.tracks});
}

class SearchSpecificSuccessState extends SearchStates {
  final List<BaseModel> models;
  SearchSpecificSuccessState(this.models);
}
