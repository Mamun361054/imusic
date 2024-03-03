import 'package:dhak_dhol/data/Repository/repositor.dart';
import 'package:dhak_dhol/data/model/home_model.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  String? profileImage;
  HomeModel? homeModel;
  Repository repository = Repository();

  HomeProvider() {
    fetchDashboardData();
  }

  getLoginInfo() async {
    // final userId = await SharedPref.getValue(SharedPref.keyId);
    // profileImage = await SharedPref.getValue(SharedPref.keyEmail);
    // ignore: todo
    // TODO: need to to profile image from login info
  }

  Future<HomeModel?> fetchDashboardData() async {
    homeModel = await repository.fetchDashBoard();

    print('homeModel ${homeModel?.albums?.first.byAndroidUser}');

    notifyListeners();
    return homeModel;
  }
}
