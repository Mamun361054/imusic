import 'dart:core';
import 'dart:math';
import 'package:dhak_dhol/data/Repository/repositor.dart';
import 'package:flutter/material.dart';
import '../data/model/ads_model.dart';

class AdsProvider extends ChangeNotifier {
  Repository repository = Repository();
  List<AdModel> ads = <AdModel>[];

  AdsProvider() {
    fetchAdvertiseData();
  }

  int get random => Random().nextInt(ads.length);

  AdModel? get item => ads.isNotEmpty ? ads.elementAt(random) : null;

  Future<void> fetchAdvertiseData() async {
    final response = await repository.getAdvertise();
    if (response?.statusCode == 200) {
      ads = List<AdModel>.from(
          (response?.data['data'] as List).map((e) => AdModel.fromJson(e)));
    }
    notifyListeners();
  }
}
