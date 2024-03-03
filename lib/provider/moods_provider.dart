import 'package:dhak_dhol/data/Repository/repositor.dart';
import 'package:dhak_dhol/data/model/moods_model.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MoodsProvider extends ChangeNotifier {
  bool isError = false;
  List<Moods> moodsList = [];
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 1;
  Repository repository = Repository();

  MoodsProvider();

  loadItems() {
    refreshController.requestRefresh();
    page = 1;
    fetchItems();
  }

  loadMoreItems() {
    page = page + 1;
    fetchItems();
  }

  void setItems(List<Moods> item) {
    moodsList.clear();
    moodsList = item;
    refreshController.refreshCompleted();
    isError = false;
    notifyListeners();
  }

  void setMoreItems(List<Moods> item) {
    moodsList.addAll(item);
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> fetchItems() async {
    try {
      final response = await repository.fetchMoods(page);

      if (response?.isNotEmpty == true) {
        if (page == 1) {
          setItems(response!);
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
