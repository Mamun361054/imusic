import 'package:dhak_dhol/data/model/artist_model.dart';
import 'package:dhak_dhol/data/model/user_model.dart';
import '../../model/search_playlist.dart';
import 'album_model.dart';
import 'genres_model.dart';
import 'media_model.dart';

class SearchModel {
  final List<Media> musics;
  final List<SearchPlayList> playlists;
  final List<Albums> albums;
  final List<Artists> artists;
  final List<User> users;
  final List<Genres> genres;

  SearchModel(
      {required this.musics,
      required this.playlists,
      required this.albums,
      required this.artists,
      required this.users,
      required this.genres});

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      musics: json['Musics'] != null
          ? json["Musics"] == null
              ? []
              : List<Media>.from(json["Musics"]!.map((x) => Media.fromJson(x)))
          : [],
      playlists: json['Playlists'] != null
          ? json["Playlists"] == null
              ? []
              : List<SearchPlayList>.from(
                  json["Playlists"]!.map((x) => SearchPlayList.fromJson(x)))
          : [],
      albums: json['Albums'] != null
          ? json["Albums"] == null
              ? []
              : List<Albums>.from(
                  json["Albums"]!.map((x) => Albums.fromJson(x)))
          : [],
      artists: json['Artists'] != null
          ? json["Artists"] == null
              ? []
              : List<Artists>.from(
                  json["Artists"]!.map((x) => Artists.fromJson(x)))
          : [],
      users: json['Users'] != null
          ? json["Users"] == null
              ? []
              : List<User>.from(json["Users"]!.map((x) => User.fromJson(x)))
          : [],
      genres: json['Genres'] != null
          ? json["Genres"] == null
              ? []
              : List<Genres>.from(
                  json["Genres"]!.map((x) => Genres.fromJson(x)))
          : [],
    );
  }
}
