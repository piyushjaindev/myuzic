import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as HTTP;

const appName = 'app_name=dev.piyushjain.myuzic';

class AudiusAPI {
  late String _hostname;

// selecting a hostname
  Future<void> init() async {
    return HTTP.get(Uri.parse('https://api.audius.co')).then((response) {
      if (response.statusCode == 200) {
        List hostnames = jsonDecode(response.body)['data'];
        _hostname = hostnames[Random().nextInt(hostnames.length)];
        return;
      } else
        throw Exception();
    }).catchError((e) => throw e);
  }

// fetching trending tracks by time and genre
  Future<List> trendingTracks(
      {required int limit,
      required String timePeriod,
      String genre = ''}) async {
    genre = sanitizeGenre(genre);
    return HTTP
        .get(Uri.parse(
            '$_hostname/v1/tracks/trending?time=$timePeriod&genre=$genre&$appName'))
        .then((response) {
      if (response.statusCode == 200) {
        List tracks = jsonDecode(response.body)['data'];
        return tracks.sublist(0, limit);
      } else
        throw Exception();
    }).catchError((e) => throw e);
  }

// fetching underground trending tracks(uses different endpoint)
  Future<List> undergroundTrending() async {
    return HTTP
        .get(Uri.parse(
            '$_hostname/v1/full/tracks/trending/underground?limit=50&$appName'))
        .then((response) {
      if (response.statusCode == 200) {
        List tracks = jsonDecode(response.body)['data'];
        return tracks;
      } else
        throw Exception();
    }).catchError((e) => throw e);
  }

//fetching tracks of given playlist or album id
  Future<List> playlistTracks(String playlistId) async {
    return HTTP
        .get(Uri.parse('$_hostname/v1/playlists/$playlistId/tracks?$appName'))
        .then((response) {
      if (response.statusCode == 200) {
        List tracks = jsonDecode(response.body)['data'];
        return tracks;
      } else
        throw Exception();
    }).catchError((e) => throw e);
  }

//fetching 10 trending playlists this week
  Future<List> trendingPlaylists() async {
    return HTTP
        .get(Uri.parse('$_hostname/v1/playlists/trending?time=week&$appName'))
        .then((response) {
      if (response.statusCode == 200) {
        List playlists = jsonDecode(response.body)['data'];
        return playlists.sublist(0, 10);
      } else
        throw Exception();
    }).catchError((e) => throw e);
  }

//fetching top playlists or albums of all time
  Future<List> topPlaylistsAlbums(
      {String type = 'playlist', int limit = 50}) async {
    return HTTP
        .get(Uri.parse(
            '$_hostname/v1/playlists/top?type=$type&limit=$limit&$appName'))
        .then((response) {
      if (response.statusCode == 200) {
        List playlists = jsonDecode(response.body)['data'];
        return playlists;
      } else
        throw Exception();
    }).catchError((e) {
      throw e;
    });
  }

//fetching recommended songs by genre (default limit=10)
  Future<List> recommendedTracks(String genre) async {
    genre = sanitizeGenre(genre);
    return HTTP
        .get(
            Uri.parse('$_hostname/v1/tracks/recommended?genre=$genre&$appName'))
        .then((response) {
      if (response.statusCode == 200) {
        List tracks = jsonDecode(response.body)['data'];
        return tracks;
      } else
        throw Exception();
    }).catchError((e) => throw e);
  }

//fetching top 10 artists
  Future<List> topArtists([String genre = '']) async {
    genre = sanitizeGenre(genre);
    return HTTP
        .get(Uri.parse(
            '$_hostname/v1/full/users/genre/top?limit=10&genre=$genre&$appName'))
        .then((response) {
      if (response.statusCode == 200) {
        List artists = jsonDecode(response.body)['data'];
        return artists;
      } else
        throw Exception();
    }).catchError((e) => throw e);
  }

// fetching list of playlists by genre
  Future<List> playlistsByGenre(String genre) async {
    genre = sanitizeGenre(genre);
    return HTTP
        .get(Uri.parse('$_hostname/v1/playlists/search?query=$genre&$appName'))
        .then((response) {
      if (response.statusCode == 200) {
        List playlists = jsonDecode(response.body)['data'];
        return playlists;
      } else
        throw Exception();
    }).catchError((e) => throw e);
  }

  //fetching tracks of given artist id
  Future<List> artistTracks(String artistId) async {
    return HTTP
        .get(Uri.parse('$_hostname/v1/users/$artistId/tracks?$appName'))
        .then((response) {
      if (response.statusCode == 200) {
        List tracks = jsonDecode(response.body)['data'];
        return tracks;
      } else
        throw Exception();
    }).catchError((e) => throw e);
  }

  Future<Map> search(
      {required String query, int limit = 5, String type = 'all'}) async {
    return HTTP
        .get(Uri.parse(
            '$_hostname/v1/full/search/autocomplete?query=$query&limit=$limit&kind=$type&$appName'))
        .then((response) {
      if (response.statusCode == 200) {
        Map result = jsonDecode(response.body)['data'];
        return result;
      } else
        throw Exception();
    }).catchError((e) => throw e);
  }

  String streamTrack(String trackId) {
    return '$_hostname/v1/tracks/$trackId/stream?$appName';
  }

  String sanitizeGenre(String genre) {
    if (genre == 'R&B/Soul')
      return 'R%26B%2FSoul';
    else if (genre == 'Hip-Hop/Rap')
      return 'Hip-Hop%2FRap';
    else
      return genre;
  }
}
