part of 'genre_cubit.dart';

abstract class GenreStates {}

class LoadingState extends GenreStates {}

class ErrorState extends GenreStates {}

class RecommendedTracksSuccessState extends GenreStates {
  final List<TrackModel> tracks;
  RecommendedTracksSuccessState(this.tracks);
}

class PlaylistSuccessState extends GenreStates {
  final List<PlaylistModel> playlists;
  PlaylistSuccessState(this.playlists);
}

class ArtistSuccessState extends GenreStates {
  final List<ArtistModel> artists;
  ArtistSuccessState(this.artists);
}
