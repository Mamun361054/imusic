import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static String keyId = "user_id";
  static String keyRoleId = "role_id";
  static String keyEmail = "user_email";
  static String keyName = "name";
  static String isFirstTimeLogin = "is_first_time_login";
  static String keyToken = "key_token";
  static String keyProfileImage = "key_profile_image";

  static setValue(String key, String? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value!);
  }

  static Future<String?> getValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var value = prefs.getString(key);
      return value;
    } catch (error) {
      return null;
    }
  }

  static setBoolValue(String key, bool? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value!);
  }

  static Future<bool?> getBoolValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var value = prefs.getBool(key);
      return value;
    } catch (error) {
      return null;
    }
  }

  static deleteKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
