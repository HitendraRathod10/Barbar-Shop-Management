import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_color.dart';
import 'app_prefrence_key.dart';

class AppUtils{
  AppUtils._privateConstructor();
  static final AppUtils instance = AppUtils._privateConstructor();

  void showToast({String? toastMessage, Color? backgroundColor, Color? textColor}) {
    Fluttertoast.showToast(
        msg: toastMessage!,
        backgroundColor: backgroundColor ?? AppColor.appColor,
        textColor: textColor ?? AppColor.whiteColor,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  showSnackBar(GlobalKey<ScaffoldState>? scaffoldKey, BuildContext? context,
      String msg, {Color? color, int? duration}) {
    return ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color??AppColor.blackColor,
        duration: Duration(seconds: duration ?? 3),
      ),
    );
  }

  getPreferenceValueViaKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (key == PreferenceKey.prefMobile) {
      return prefs.getString(key);
    } else if (key == PreferenceKey.prefEmail) {
      return prefs.getString(key);
    } else if (key == PreferenceKey.prefFirstName) {
      return prefs.getString(key);
    } else if (key == PreferenceKey.prefLastName) {
      return prefs.getString(key);
    } else if (key == PreferenceKey.prefUserId) {
      return prefs.getString(key);
    } else if (key == PreferenceKey.prefLogin) {
      return prefs.getBool(key);
    }else if (key == PreferenceKey.prefLanguage) {
      return prefs.getString(key);
    } else if (key == PreferenceKey.prefFullName) {
      return prefs.getString(key);
    }else if (key == PreferenceKey.prefToken) {
      return prefs.getString(key);
    }else if(key == PreferenceKey.prefPageSkip){
      return prefs.getString(key);
    }else if(key == PreferenceKey.prefGetStarted){
      return prefs.getString(key);
    }else if(key == PreferenceKey.prefPassword){
      return prefs.getString(key);
    }else if(key == PreferenceKey.prefInDisable){
      return prefs.getString(key);
    }else if(key == PreferenceKey.prefInDisableBTN){
      return prefs.getBool(key);
    }
  }

  setPref(String type, String key, var value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (type == "String") {
      prefs.setString(key, value);
    } else if (type == "Bool") {
      prefs.setBool(key, value);
    } else if (type == "Double") {
      prefs.setDouble(key, value);
    }else if(type=="StringList"){
      prefs.setStringList(key, value);
    }else {
      prefs.setInt(key, value);
    }
  }

  Future<void> clearPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
