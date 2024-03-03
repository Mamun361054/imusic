// ignore_for_file: avoid_print

import 'package:dhak_dhol/data/Repository/repositor.dart';
import 'package:dhak_dhol/data/model/artist_model.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ArtistsProvider extends ChangeNotifier {
  bool isError = false;
  Repository repository = Repository();
  List<Artists> mediaList = [];
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 1;

  void loadItems() async {
    refreshController.requestRefresh();
    page = 1;
    fetchItems();
  }

  void loadMoreItems() async {
    page = page + 1;
    fetchItems();
  }

  void setItems(item) {
    mediaList.clear();
    mediaList = item;
    refreshController.refreshCompleted();
    isError = false;
    notifyListeners();
  }

  void setMoreItems(List<Artists> item) {
    mediaList.addAll(item);
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> fetchItems() async {
    try {
      // var data = {"page": page.toString()};
      // debugPrint(data.toString());
      final response = await repository.fetchArtists(page);

      if (response?.isNotEmpty == true) {
        if (page == 1) {
          setItems(response);
        } else {
          setMoreItems(response!);
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        setFetchError();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
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
