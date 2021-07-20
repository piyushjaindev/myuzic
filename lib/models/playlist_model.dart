import 'package:flutter/material.dart';

import '../widgets/playlist_card.dart';
import '../widgets/playlist_tile.dart';
import 'base_model.dart';

class PlaylistModel extends BaseModel {
  PlaylistModel(
      {required String id, required String name, required String cover})
      : super(id: id, name: name, cover: cover);

  factory PlaylistModel.fromJson(Map json) {
    Map? cover = json['artwork'];
    return PlaylistModel(
        id: json['id'],
        name: json['playlist_name'],
        cover: cover?.values.first ?? '');
  }

  @override
  Widget toCard() {
    return PlaylistCard(playlist: this);
  }

  @override
  Widget toTile([String? subtitle]) {
    return PlaylistTile(
      playlist: this,
      subtitle: subtitle,
    );
  }
}
