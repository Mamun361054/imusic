import 'package:dhak_dhol/data/model/album_model.dart';
import 'package:dhak_dhol/data/model/artist_model.dart';
import 'package:dhak_dhol/data/model/genres_model.dart';
import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:dhak_dhol/data/model/moods_model.dart';

class HomeModel {
  List<Albums>? albums;
  List<Artists>? artists;
  List<Moods>? moods;
  List<Genres>? genres;
  List<Media>? sliderMedias;
  List<Media>? latestAudios;
  List<Media>? trendingAudios;

  HomeModel(
      {this.albums,
      this.artists,
      this.moods,
      this.genres,
      this.sliderMedias = const [],
      this.latestAudios,
      this.trendingAudios});

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      albums: List<Albums>.from(json['albums'].map((x) => Albums.fromJson(x))),
      artists:
          List<Artists>.from(json['artists'].map((x) => Artists.fromJson(x))),
      moods: List<Moods>.from(json['moods'].map((x) => Moods.fromJson(x))),
      genres: List<Genres>.from(json['genres'].map((x) => Genres.fromJson(x))),
      sliderMedias:
          List<Media>.from(json['slider_media'].map((x) => Media.fromJson(x))),
      latestAudios:
          List<Media>.from(json['latest_audios'].map((x) => Media.fromJson(x))),
      trendingAudios: List<Media>.from(
          json['trending_audios'].map((x) => Media.fromJson(x))),
    );
  }
}
