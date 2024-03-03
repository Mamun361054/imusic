import 'package:dhak_dhol/screens/home/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:dhak_dhol/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class SplashScreenProvider extends ChangeNotifier {
  String? userEmail;

  SplashScreenProvider(context) {
    initFunction(context);
  }

  initFunction(context) {
    Future.delayed(const Duration(seconds: 2), () async {
      // ignore: unused_local_variable
      final userId = await SharedPref.getValue(SharedPref.keyId);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavigationScreen(),
          ));
    });
  }
}
