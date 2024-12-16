import 'package:flutter/material.dart';

class AppConstants {
  static const primaryColor = Color(0xff3629B7);
  // static const secondaryColor = Color(0xff6F1D71);
  static const secondaryColor = Color(0xfffaac18);
  static const String baseUrl = "https://drammp.space/apidrammp/";
  //ssh -i /home/mutesasira/gcp mutesasira@35.225.77.49
  // static String baseUrl = "http://35.238.60.172/apidrammp/";
  // static String baseUrl = "http://35.225.77.49/apidrammp/";
  static const String googleApiKey = "AIzaSyDV-HAZxiJPvVuwnBEL-8V6_vhtkuFAi4w";
  static const String weatherApiKey = "14000a1f22ff9be80023f1cd831920f2";

  // PAYMENT INTEGRATION CONSTANTS
  //MTN
  // static const String MOMO_USER_ID = "97fdb804-598a-4f29-b393-2a94f9dc7eb6";
  // static const String MOMO_API_KEY = "13f02f2810fa48bfb4e99505cd1b196e";

  static const String MOMO_USER_ID = "ffd84c9a-92fd-412b-b28d-34c80dfd3950";
  static const String MOMO_API_KEY = "d50288f0883d4970832f5a7a26a3e447";

  static const String MOMO_REQUEST_TO_PAY =
      "https://sandbox.momodeveloper.mtn.com/collection/v1_0/requesttopay";
  static const String MOMO_TOKEN_URL =
      "https://sandbox.momodeveloper.mtn.com/collection/token/";
  // static const String MTN_COLLECTION_PRIMARY_URL =
  //     "7ed8b69354114944ab4ce6f4f31bdd16";
  // static const String MTN_COLLECTION_SECONDARY_URL =
  //     "03844d2b851d4a899537f9a1d20d15df";
  static const String MTN_COLLECTION_PRIMARY_URL =
      "3ec95c377b894c9281fe1a8f52732d78";
  static const String MTN_COLLECTION_SECONDARY_URL =
      "962b48888ebe48dfb04126d044873031";
//AIRTEL
  static const String AIRTEL_PAY_BASE_URL_SANDBOX =
      "https://openapiuat.airtel.africa/";
  static const String AIRTEL_PAY_BASE_URL = "https://openapi.airtel.africa/";
  static const AIRTEL_TOKEN_EXTENSION = "auth/oauth2/token";
  static const AIRTEL_REQUEST_TO_PAY = "merchant/v1/payments/";
  static const AIRTEL_CLIENT_ID = "acc95eca-0794-4784-9cd5-37e0e5af4b45";
  static const AIRTEL_CLIENT_ID_PROD = "b55069a7-2a54-46c4-a696-e4fa45f1a07a";
  static const AIRTEL_CLIENT_SECRET_KEY_PROD =
      "59b2050b-6e33-4f30-af3e-eeafb54cf055";
  static const AIRTEL_PUBLIC_KEY_SPOUTS =
      "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCkq3XbDI1s8Lu7SpUBP+bqOs/MC6PKWz6n/0UkqTiOZqKqaoZClI3BUDTrSIJsrN1Qx7ivBzsaAYfsB0CygSSWay4iyUcnMVEDrNVOJwtWvHxpyWJC5RfKBrweW9b8klFa/CfKRtkK730apy0Kxjg+7fF0tB4O3Ic9Gxuv4pFkbQIDAQAB";
  static const AIRTEL_PUBLIC_KEY =
      "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArUj2SQKLCdTqJ3/ZL6nkh1N3rtjXBBM+0hBUrhJ/VNSMTBixpD+JjeNaHbONcrvJGSstC2tcVfD04s9xGIKr9TT6hCYaqGojLeuLimVdXzaP5DzDyrHY8mYgHL+/EGRDh+/7B56Gw8UZxOBPtF6Wjjq0TWGcw5YOW1lSPUeaD+kupmDFlMRk26fASELwkYo5NkHgL/w+XzXw8gDZtrNS6L8UX2mfqdQ9qKpdMP3ztfOUPjmTvIbTKrGLx0U2sUSQINtMxZQzsYaXIGoZ2thvbIhJMDFBNbznuv1n8b03Q3MAnEK/xCduQBUkUg1syy7jZMT4ETDeFuW2NMZhteaadwIDAQAB";
}

class StorageKeys {
  static const String appLanguageCode = 'APP_LANGUAGE_CODE';
  static const String appThemeMode = 'APP_THEME_MODE';
  static const String username = 'USERNAME';
  static const String userProfileImageUrl = 'USER_PROFILE_IMAGE_URL';
}
