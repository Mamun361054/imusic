import 'package:dhak_dhol/data/Repository/repositor.dart';
import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:dhak_dhol/data/model/moods_model.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MoodsMediaProvider extends ChangeNotifier {
  Repository repository = Repository();
  bool isError = false;
  List<Media> mediaList = [];
  Moods? moods;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 1;

  MoodsMediaProvider(this.moods) {
    mediaList = [];
    moods = moods;
  }

  loadItems() {
    refreshController.requestRefresh();
    page = 1;
    fetchItems();
  }

  loadMoreItems() {
    page = page + 1;
    fetchItems();
  }

  void setItems(List<Media>? item) {
    mediaList.clear();
    mediaList = item!;
    refreshController.refreshCompleted();
    isError = false;
    notifyListeners();
  }

  void setMoreItems(List<Media>? item) {
    mediaList.addAll(item!);
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> fetchItems() async {
    final response = await repository.fetchMoodsMedia(page);

    if (response?.isNotEmpty == true) {
      // mediaList = response!;
      if (page == 1) {
        setItems(response);
      } else {
        setMoreItems(response!);
      }
      notifyListeners();
    }
    refreshController.refreshCompleted();
  }

  setFetchError() {
    if (page == 1) {
      isError = true;
      refreshController.refreshFailed();
      notifyListeners();
    } else {
      refreshController.loadFailed();
      notifyListeners();
    }
  }
}
