import 'dart:convert';

import 'package:entebbe_dramp_web/src/app_with_go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:toastification/toastification.dart';
import 'firebase_options.dart';
import 'services/push_notifications.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

// function to lisen to background changes
Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("Background notification Received");
  }
}

// to handle notification on foreground on web platform
void showNotification({required String title, required String body}) {
  if (navigatorKey.currentContext != null) {
    debugPrint("context is not null");
  } else {
    debugPrint("context is null");
  }

  toastification.show(
    context: navigatorKey.currentContext!,
    // context: context,
    // optional if you use ToastificationWrapper
    type: ToastificationType.info,
    style: ToastificationStyle.minimal,
    autoCloseDuration: const Duration(seconds: 10),
    title: Text('$title',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    // you can also use RichText widget for title and description parameters
    description: RichText(
        text: TextSpan(
            text: '$body', style: TextStyle(color: Colors.indigo.shade900))),
    alignment: Alignment.topCenter,
    direction: TextDirection.ltr,
    animationDuration: const Duration(milliseconds: 300),
    animationBuilder: (context, animation, alignment, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    icon: const Icon(Icons.notifications),
    showIcon: true, // show or hide the icon
    primaryColor: Colors.indigo.shade900,
    backgroundColor: Colors.indigo.shade50,
    foregroundColor: Colors.indigo.shade900,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(
        color: Color(0x07000000),
        blurRadius: 16,
        offset: Offset(0, 16),
        spreadRadius: 0,
      )
    ],
    showProgressBar: false,
    closeButtonShowType: CloseButtonShowType.onHover,
    closeOnClick: false,
    pauseOnHover: true,
    dragToClose: true,
    applyBlurEffect: true,
    callbacks: ToastificationCallbacks(
      onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
      onCloseButtonTap: (toastItem) =>
          debugPrint('Toast ${toastItem.id} close button tapped'),
      onAutoCompleteCompleted: (toastItem) =>
          debugPrint('Toast ${toastItem.id} auto complete completed'),
      onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
    ),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // name: 'spesho-entebbe-drammp',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // on background notification tapped
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      print("Background Notification Tapped");
      navigatorKey.currentState!.pushNamed("/", arguments: message);
    }
  });

  PushNotifications.init();
  // // only initialize if platform is not web
  // if (!kIsWeb) {
  //   PushNotifications.localNotiInit();
  // }
  // // Listen to background notifications
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

  // to handle foreground notifications
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadData = jsonEncode(message.data);
    print("Got a message in foreground");
    if (message.notification != null) {
      if (kIsWeb) {
        debugPrint("Notification body: ${message.notification!.body!}");
        debugPrint("Notification title: ${message.notification!.title!}");
        showNotification(
            title: message.notification!.title!,
            body: message.notification!.body!);
      } else {
        PushNotifications.showSimpleNotification(
            title: message.notification!.title!,
            body: message.notification!.body!,
            payload: payloadData);
      }
    }
  });

  // // for handling in terminated state
  // final RemoteMessage? message =
  //     await FirebaseMessaging.instance.getInitialMessage();

  // if (message != null) {
  //   print("Launched from terminated state");
  //   Future.delayed(Duration(seconds: 1), () {
  //     navigatorKey.currentState!.pushNamed("/message", arguments: message);
  //   });
  // }
  setUrlStrategy(PathUrlStrategy());
  runApp(const ProviderScope(child: AppWithGoRouter()));
}
