part of 'explore_cubit.dart';

abstract class ExploreStates {}

class LoadingState extends ExploreStates {}

class ErrorState extends ExploreStates {}

class TrendingPlaylistsSuccessState extends ExploreStates {
  final List<PlaylistModel> playlists;
  TrendingPlaylistsSuccessState(this.playlists);
}

class TopPlaylistsSuccessState extends ExploreStates {
  final List<PlaylistModel> playlists;
  TopPlaylistsSuccessState(this.playlists);
}

class TopArtistsSuccessState extends ExploreStates {
  final List<ArtistModel> artists;
  TopArtistsSuccessState(this.artists);
}
