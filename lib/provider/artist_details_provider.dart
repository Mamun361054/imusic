import 'package:dhak_dhol/data/Repository/repositor.dart';
import 'package:dhak_dhol/data/model/artist_model.dart';
import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ArtistDetailsProvider extends ChangeNotifier {
  Repository repository = Repository();
  List<Media> mediaList = <Media>[];
  Artists? artists;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 1;
  int albumDuration = 0;
  bool isError = false;

  ArtistDetailsProvider(this.artists) {}

  loadItems() {
    refreshController.requestRefresh();
    page = 1;
    fetchItems();
  }

  loadMoreItems() {
    page = page + 1;
    fetchItems();
  }

  void setItems(List<Media> item) {
    mediaList.clear();
    mediaList = item;
    refreshController.refreshCompleted();
    isError = false;
    albumDuration = 0;
    for (var element in item) {
      albumDuration += element.duration ?? 0;
    }
    notifyListeners();
  }

  void setMoreItems(List<Media> item) {
    mediaList.addAll(item);
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> fetchItems() async {
    final response = await repository.fetchArtisMedia(
        artistId: artists?.id.toString(), page: page);
    if (response?.isNotEmpty == true) {
      // mediaList = response!;
      if (page == 1) {
        setItems(response!);
      } else {
        setMoreItems(response!);
      }
      notifyListeners();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      // setFetchError();
    }
  }
}
