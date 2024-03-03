import 'package:dhak_dhol/data/Repository/repositor.dart';
import 'package:dhak_dhol/data/model/album_model.dart';
import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:dhak_dhol/utils/shared_pref.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AlbumDetailsProvider extends ChangeNotifier {
  Repository repository = Repository();
  List<Media> mediaList = <Media>[];
  Albums? albums;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 1;
  int albumDuration = 0;
  bool isError = false;

  AlbumDetailsProvider(this.albums) {}

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
    final response = await repository.fetchAlbumMedia(
        albumId: albums?.id.toString(), page: page);
    if (response?.isNotEmpty == true) {
      if (page == 1) {
        setItems(response!);
      } else {
        setMoreItems(response!);
      }
      notifyListeners();
    }
  }
}
