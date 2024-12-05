// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAL9jKF_sVyy3BAg97lk1o3kgjQ5J9XkvU',
    appId: '1:1048620869448:web:46488b00a5398c1058f57d',
    messagingSenderId: '1048620869448',
    projectId: 'spesho-entebbe-drammp',
    authDomain: 'spesho-entebbe-drammp.firebaseapp.com',
    storageBucket: 'spesho-entebbe-drammp.appspot.com',
    measurementId: 'G-M3PS6VDZBQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDARD7iUyM-xYjSlI1BK6Rszpb7ZAJBjIc',
    appId: '1:1048620869448:android:f1caf1223467b81558f57d',
    messagingSenderId: '1048620869448',
    projectId: 'spesho-entebbe-drammp',
    storageBucket: 'spesho-entebbe-drammp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAaGjzsqUD7V9Ww3URbe11iz6DCXqAUug8',
    appId: '1:1048620869448:ios:5f11a12b9cf4e5d558f57d',
    messagingSenderId: '1048620869448',
    projectId: 'spesho-entebbe-drammp',
    storageBucket: 'spesho-entebbe-drammp.appspot.com',
    iosBundleId: 'co.ug.speshotaxi.drammp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAaGjzsqUD7V9Ww3URbe11iz6DCXqAUug8',
    appId: '1:1048620869448:ios:9cc676f94240893058f57d',
    messagingSenderId: '1048620869448',
    projectId: 'spesho-entebbe-drammp',
    storageBucket: 'spesho-entebbe-drammp.appspot.com',
    iosBundleId: 'com.example.drammpMobile',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAL9jKF_sVyy3BAg97lk1o3kgjQ5J9XkvU',
    appId: '1:1048620869448:web:e3ba344a84de796258f57d',
    messagingSenderId: '1048620869448',
    projectId: 'spesho-entebbe-drammp',
    authDomain: 'spesho-entebbe-drammp.firebaseapp.com',
    storageBucket: 'spesho-entebbe-drammp.appspot.com',
    measurementId: 'G-C0FKP24WQM',
  );
}
