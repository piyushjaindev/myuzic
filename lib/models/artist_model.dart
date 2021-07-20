import 'package:flutter/material.dart';

import '../widgets/artist_card.dart';
import '../widgets/artist_tile.dart';
import 'base_model.dart';

class ArtistModel extends BaseModel {
  ArtistModel({
    required String id,
    required String name,
    required String cover,
  }) : super(id: id, name: name, cover: cover);

  factory ArtistModel.fromJson(Map json) {
    Map? profilePicture = json['profile_picture'];
    return ArtistModel(
        name: json['name'],
        id: json['id'],
        cover: profilePicture?.values.first ?? '');
  }

  @override
  Widget toCard() {
    return ArtistCard(artist: this);
  }

  @override
  Widget toTile([String? subtitle]) {
    return ArtistTile(
      artist: this,
      subtitle: subtitle,
    );
  }
}
