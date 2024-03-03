import 'dart:async';

import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:flutter/material.dart';
import '../data/Repository/repositor.dart';
import '../data/model/search_model.dart';
import '../utils/shared_pref.dart';

class SearchProvider extends ChangeNotifier {
  final searchController = TextEditingController();
  List<Media> medias = <Media>[];
  SearchModel? searchModel;
  bool isLoading = false;
  Repository repository = Repository();
  final debounce = Debounce(milliseconds: 500);
  int filterIndex = -1;

  Future<void> searchMedia(String query) async {
    isLoading = true;
    notifyListeners();

    final email = await SharedPref.getValue(SharedPref.keyEmail);

    final query = searchController.text;

    debugPrint("query: ${searchController.text}");
    debugPrint("email: $email");

    searchModel = await repository.searchMediaData(query);

    isLoading = false;
    notifyListeners();
  }

  void updateFilterViewIndex({required int index}) {
    filterIndex = index;
    notifyListeners();
  }
}

class Debounce {
  final int milliseconds;
  Timer? _timer;

  Debounce({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
