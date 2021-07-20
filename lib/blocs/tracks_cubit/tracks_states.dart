part of 'tracks_cubit.dart';

abstract class TracksStates {}

class LoadingState extends TracksStates {}

class ErrorState extends TracksStates {}

class SuccessTracksState extends TracksStates {
  final List<TrackModel> tracks;
  SuccessTracksState(this.tracks);
}
