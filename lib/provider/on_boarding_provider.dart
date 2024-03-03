import 'package:dhak_dhol/utils/shared_pref.dart';
import 'package:flutter/foundation.dart';

class OnBoardingProvider extends ChangeNotifier {
  String? userEmail;

  OnBoardingProvider() {
    getUser();
  }

  getUser() async {
    userEmail = await SharedPref.getValue(SharedPref.keyEmail);
    notifyListeners();
  }
}
