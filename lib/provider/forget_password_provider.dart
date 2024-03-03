import 'package:dhak_dhol/data/Repository/repositor.dart';
import 'package:dhak_dhol/screens/auth/verification/verification.dart';
import 'package:flutter/material.dart';

class ForgetPasswordProvider extends ChangeNotifier {
  Repository repository = Repository();
  TextEditingController emailController = TextEditingController();

  Future forgetPassword(context) async {
    var data = {
      {"email": emailController.text}
    };

    final response = await repository.forgetPassword(data);
    if (response?.user?.email != null) {
      response;
      // Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const VerificationScreen()),
          (Route<dynamic> route) => false);
    }
    debugPrint(response.toString());
    notifyListeners();
  }
}
