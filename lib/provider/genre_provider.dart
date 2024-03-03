import 'package:dhak_dhol/data/Repository/repositor.dart';
import 'package:dhak_dhol/data/model/genres_model.dart';
import 'package:dhak_dhol/data/model/home_model.dart';
import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:flutter/material.dart';

class GenreProvider extends ChangeNotifier {
  Repository repository = Repository();
  Genres? genres;
  HomeModel? homeModel;
  int? genreId;
  List<Media> medias = <Media>[];

  GenreProvider(name) {
    genreId = name;
    fetchGenreMedia();
  }

  Future<void> fetchGenreMedia() async {
    medias = await repository.genreMedia(genreId);
    notifyListeners();
  }
}
