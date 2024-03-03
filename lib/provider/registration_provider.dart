import 'package:dhak_dhol/data/Repository/repositor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../data/model/user_model.dart';
import '../screens/home/bottom_navigation_bar/bottom_navigation_bar.dart';
import '../utils/app_const.dart';
import '../utils/shared_pref.dart';

class RegistrationProvider extends ChangeNotifier {
  Repository repository = Repository();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void toggle() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future registration(context) async {
    FormData fromData = FormData.fromMap({
      "name": nameController.text,
      "email": emailController.text,
      "password": passwordController.text
    });

    try {
      toggle();

      final response = await repository.registrationUser(fromData);
      print("register response : .....${response?.user?.email}");

      if (response?.user?.email != null) {
        storeRegisterUserData(response);
        // FirebaseService().createAndUpdateUserInfo(
        //     response!.toJson(), '${response.user?.id}');
        Fluttertoast.showToast(
            msg: 'Registration Successfully Done!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: AppColor.backgroundColor2,
            textColor: Colors.white,
            fontSize: 12.0);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => SignInScreen(),
        //     ));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const BottomNavigationScreen()),
            (Route<dynamic> route) => false);
      } else {
        Fluttertoast.showToast(
            msg: 'Wrong Information',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: AppColor.backgroundColor2,
            textColor: Colors.white,
            fontSize: 12.0);
      }
      debugPrint(response.toString());
      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Wrong Information',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }

    toggle();

    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const SignInScreen(),
    //     ));
    // debugPrint(response.toString());
    // notifyListeners();
  }

  storeRegisterUserData(UserModel? response) async {
    await SharedPref.setValue(SharedPref.keyId, '${response!.user?.id}');
    await SharedPref.setValue(SharedPref.keyName, response.user?.name);
    await SharedPref.setValue(SharedPref.keyEmail, response.user?.email);
    await SharedPref.setValue(SharedPref.keyToken, response.user?.token);
    await SharedPref.setValue(
        SharedPref.keyProfileImage, response.user?.thumbnail);
    notifyListeners();
  }
}
