import 'package:dhak_dhol/data/Repository/repositor.dart';
import 'package:dhak_dhol/data/model/user_model.dart';
import 'package:dhak_dhol/screens/home/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:dhak_dhol/utils/shared_pref.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignInProvider extends ChangeNotifier {
  bool isLoading = false;
  Repository repository = Repository();

  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();

  void toggle() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future doSignIn(context) async {
    FormData formData = FormData.fromMap(
        {"email": nameController.text, "password": passController.text});

    try {
      toggle();

      final userData = await repository.loginUser(formData);

      if (userData?.user?.email != null) {
        storeUserData(userData);

        // FirebaseService().createAndUpdateUserInfo(
        //     userData!.toJson(), '${userData.user?.id}');

        Fluttertoast.showToast(
            msg: 'Successfully Login!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: AppColor.backgroundColor2,
            textColor: Colors.white,
            fontSize: 12.0);
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
      debugPrint(userData.toString());
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
  }

  storeUserData(UserModel? response) async {
    await SharedPref.setValue(SharedPref.keyId, '${response!.user?.id}');
    await SharedPref.setValue(SharedPref.keyRoleId, '${response.user?.roleId}');
    await SharedPref.setValue(SharedPref.keyName, response.user?.name);
    await SharedPref.setValue(SharedPref.keyEmail, response.user?.email);
    await SharedPref.setValue(SharedPref.keyToken, response.user?.token);
    await SharedPref.setValue(SharedPref.keyProfileImage, response.user?.thumbnail);
    notifyListeners();
  }
}
