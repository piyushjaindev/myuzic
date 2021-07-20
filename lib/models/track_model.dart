import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import '../widgets/track_card.dart';
import '../widgets/track_tile.dart';
import 'artist_model.dart';
import 'base_model.dart';

class TrackModel extends BaseModel {
  final Duration duration;
  final String streamURL;
  final ArtistModel artist;

  TrackModel({
    required String id,
    required String name,
    required String cover,
    required this.duration,
    required this.streamURL,
    required this.artist,
  }) : super(id: id, name: name, cover: cover);

  factory TrackModel.fromJson(Map trackJson, String streamURL) {
    Map? cover = trackJson['artwork'];
    return TrackModel(
        id: trackJson['id'],
        name: trackJson['title'],
        cover: cover?.values.first ?? '',
        streamURL: streamURL,
        duration: Duration(seconds: trackJson['duration']),
        artist: ArtistModel.fromJson(trackJson['user']));
  }

  factory TrackModel.fromMediaItem(MediaItem mediaItem) {
    return TrackModel(
      id: mediaItem.id,
      name: mediaItem.title,
      cover: mediaItem.artUri?.toString() ?? '',
      duration: mediaItem.duration!,
      streamURL: mediaItem.extras!['streamURL'],
      artist: ArtistModel(name: mediaItem.artist!, id: '', cover: ''),
    );
  }

  MediaItem toMediaItem() {
    return MediaItem(
      id: id,
      album: 'album',
      title: name,
      artUri: Uri.parse(cover),
      duration: duration,
      artist: artist.name,
      extras: {'streamURL': streamURL},
    );
  }

  @override
  Widget toCard() {
    return TrackCard(track: this);
  }

  @override
  Widget toTile([String? subtitle]) {
    return TrackTile(track: this);
  }
}
