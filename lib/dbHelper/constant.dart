import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static String sharedPreferenceUserLoggedInKey = "false";
  static String sharedPreferenceUserTypeKey = "USERTYPEKEY";
  static String sharedPreferenceUserTokenKey = "USERTOKEN";
  static String sharedPreferenceUserMailKey = "USERMAIL";
  static String sharedPreferenceUserProgramKey = "USERPROGRAM";
  static String sharedPreferenceUserSchoolKey = "USERSCHOOL";
  static String sharedPreferenceUserChannelKey = "USERCHANNEL";
  static String sharedPreferenceFirebaesTokenChannelKey = "FIREBASETOKEN";
  static String sharedPreferenceFirebaesTopicByProgramChannelKey =
      "FIREBASETOPICBYPROGRAM";

  // ignore: missing_return
  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences saveLocal = await SharedPreferences.getInstance();
    saveLocal.setBool(
        Constants.sharedPreferenceUserLoggedInKey, isUserLoggedIn);
    return isUserLoggedIn;
  }

  static Future<bool?> getUerLoggedInSharedPreference() async {
    SharedPreferences saveLocal = await SharedPreferences.getInstance();
    final bool? isUserLoggedIn =
        saveLocal.getBool(Constants.sharedPreferenceUserLoggedInKey);
    return isUserLoggedIn;
  }

  static Future<String> saveFirebaseTokenLoggedInSharedPreference(
      String fireToken) async {
    SharedPreferences saveLocal = await SharedPreferences.getInstance();
    saveLocal.setString(
        Constants.sharedPreferenceFirebaesTokenChannelKey, fireToken);
    return fireToken;
  }

  static Future<String> saveFirebaseTopicByProgramInSharedPreference(
      String fireTopic) async {
    SharedPreferences saveLocal = await SharedPreferences.getInstance();
    saveLocal.setString(
        Constants.sharedPreferenceFirebaesTopicByProgramChannelKey, fireTopic);
    return fireTopic;
  }

  static Future<Object?> getFirebaseTokenSharedPreference() async {
    SharedPreferences saveLocal = await SharedPreferences.getInstance();
    return saveLocal.get(Constants.sharedPreferenceFirebaesTokenChannelKey);
  }

  static Future<Object?> getFirebaseTopicByProgramSharedPreference() async {
    SharedPreferences saveLocal = await SharedPreferences.getInstance();
    return saveLocal
        .get(Constants.sharedPreferenceFirebaesTopicByProgramChannelKey);
  }

  // ignore: missing_return
  static Future<String> saveUserTokenSharedPreference(String token) async {
    SharedPreferences saveLocal = await SharedPreferences.getInstance();
    saveLocal.setString(Constants.sharedPreferenceUserTokenKey, token);
    return token;
  }

  static Future<Object?> getUserTokenSharedPreference() async {
    SharedPreferences saveLocal = await SharedPreferences.getInstance();
    return saveLocal.get(Constants.sharedPreferenceUserTokenKey);
  }

  // ignore: missing_return
  static Future<String> saveUserTypeSharedPreference(String userType) async {
    SharedPreferences saveLocal = await SharedPreferences.getInstance();
    saveLocal.setString(Constants.sharedPreferenceUserTypeKey, userType);
    return userType;
  }

  static Future<Object?> getUserTypeSharedPreference() async {
    SharedPreferences saveLocal = await SharedPreferences.getInstance();
    return saveLocal.get(Constants.sharedPreferenceUserTypeKey);
  }

  // ignore: missing_return
  static Future<String> saveUserMailSharedPreference(String email) async {
    SharedPreferences saveLocal = await SharedPreferences.getInstance();
    saveLocal.setString(Constants.sharedPreferenceUserMailKey, email);
    return email;
  }

  static Future<Object?> getUserMailSharedPreference() async {
    SharedPreferences saveLocal = await SharedPreferences.getInstance();
    return saveLocal.get(Constants.sharedPreferenceUserMailKey);
  }

  // ignore: missing_return
  static Future<String> saveUserProgramSharedPreference(
      String programCode) async {
    SharedPreferences saveLocal = await SharedPreferences.getInstance();
    saveLocal.setString(Constants.sharedPreferenceUserProgramKey, programCode);
    return programCode;
  }

  static Future<Object?> getUserProgramSharedPreference() async {
    SharedPreferences saveLocal = await SharedPreferences.getInstance();
    return saveLocal.get(Constants.sharedPreferenceUserProgramKey);
  }

  // ignore: missing_return
  static Future<String> saveUserSchoolSharedPreference(
      String schoolCode) async {
    SharedPreferences saveLocal = await SharedPreferences.getInstance();
    saveLocal.setString(Constants.sharedPreferenceUserSchoolKey, schoolCode);
    return schoolCode;
  }

  static Future<Object?> getUserSchoolSharedPreference() async {
    SharedPreferences saveLocal = await SharedPreferences.getInstance();
    return saveLocal.get(Constants.sharedPreferenceUserSchoolKey);
  }

  // ignore: missing_return
  static Future<String> saveUserChannelSharedPreference(String channel) async {
    SharedPreferences saveLocal = await SharedPreferences.getInstance();
    saveLocal.setString(Constants.sharedPreferenceUserChannelKey, channel);
    return channel;
  }

  static Future<Object?> getUserChannelSharedPreference() async {
    SharedPreferences saveLocal = await SharedPreferences.getInstance();
    return saveLocal.get(Constants.sharedPreferenceUserChannelKey);
  }
}
