import 'package:dhak_dhol/data/Repository/repositor.dart';
import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../utils/shared_pref.dart';


class TracksProvider extends ChangeNotifier {
  bool isError = false;
  List<Media> mediaList = [];
  RefreshController refreshController = RefreshController(initialRefresh: false);
  int page = 1;
  Repository repository = Repository();

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
    notifyListeners();
  }

  void setMoreItems(List<Media> item) {
    mediaList.addAll(item);
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> fetchItems() async {
    try {

      final userData = await SharedPref.getValue(SharedPref.keyEmail);

      FormData data = FormData.fromMap({
        "email": userData ?? "null",
        "media_type": "audio",
        "version": "v2",
        "page": page.toString()
      });

      final list = await repository.fetchItems(page) ?? [];

      if (list.isNotEmpty == true) {
        if (page == 1) {
          setItems(list);
        } else {
          setMoreItems(list);
        }
      } else {
        setFetchError();
      }
    } catch (exception) {
      setFetchError();
    }
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
