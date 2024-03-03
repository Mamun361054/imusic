import 'package:dhak_dhol/data/Repository/repositor.dart';
import 'package:dhak_dhol/data/model/album_model.dart';
import 'package:dhak_dhol/utils/shared_pref.dart';
import 'package:flutter/foundation.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AlbumProvider extends ChangeNotifier {
  Repository repository = Repository();
  List<Albums> mediaList = <Albums>[];
  Albums? albums;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 1;
  bool isError = false;

  AlbumProvider() {
    // fetchAlbum();
  }

  loadItems() {
    refreshController.requestRefresh();
    page = 1;
    fetchAlbum();
  }

  loadMoreItems() {
    page = page + 1;
    fetchAlbum();
    refreshController.loadComplete();
  }

  void setItems(List<Albums> item) {
    mediaList.clear();
    mediaList = item;
    refreshController.refreshCompleted();
    // isError = false;
    notifyListeners();
  }

  void setMoreItems(List<Albums> item) {
    mediaList.addAll(item);
    refreshController.loadComplete();
    notifyListeners();
  }

  Future fetchAlbum() async {
    final response = await repository.fetchAlbum(page);
    if (response?.isNotEmpty == true) {
      // mediaList = response!;
      if (page == 1) {
        setItems(response!);
      } else {
        setMoreItems(response!);
      }
    } else {
      setFetchError();
    }
    debugPrint(mediaList.length.toString());
    notifyListeners();
    return;
  }

  Future artistAlbum() async {
    final response = await repository.artistAlbum(page);
    if (response?.isNotEmpty == true) {
      // mediaList = response!;
      if (page == 1) {
        setItems(response!);
      } else {
        setMoreItems(response!);
      }
    } else {
      setFetchError();
    }
    debugPrint(mediaList.length.toString());
    notifyListeners();
    return;
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
