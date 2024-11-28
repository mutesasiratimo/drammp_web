import 'package:flutter/material.dart';

class AppConstants {
  static const primaryColor = Color(0xff3629B7);
  // static const secondaryColor = Color(0xff6F1D71);
  static const secondaryColor = Color(0xfffaac18);
  static const String baseUrl = "http://0.0.0.0:8000/";
  //ssh -i /home/mutesasira/gcp mutesasira@35.225.77.49
  // static String baseUrl = "http://35.238.60.172/apidrammp/";
  // static String baseUrl = "http://35.225.77.49/apidrammp/";
  static const String googleApiKey = "AIzaSyDV-HAZxiJPvVuwnBEL-8V6_vhtkuFAi4w";
  static const String weatherApiKey = "14000a1f22ff9be80023f1cd831920f2";
}

class StorageKeys {
  static const String appLanguageCode = 'APP_LANGUAGE_CODE';
  static const String appThemeMode = 'APP_THEME_MODE';
  static const String username = 'USERNAME';
  static const String userProfileImageUrl = 'USER_PROFILE_IMAGE_URL';
}
