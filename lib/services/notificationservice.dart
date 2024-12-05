import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:http/http.dart' as http;

import '../models/notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("A bg message just showed up" + message.toString());
}

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final prefs = await SharedPreferences.getInstance();
    final fcmToken = await _firebaseMessaging.getToken(
        vapidKey:
            "BAzmYxl_BrkYFKUg9jFEtT6wUlGUD5zNaa96940LUvmCCCa_5EhzBkLMi6AX8kcP6tejQ_vCWjmt0ZWY45zhfNg");
    debugPrint("Token : ++++++++++++= $fcmToken");
    prefs.setString('fcmToken', fcmToken!);

    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // ON RECIEVING NOTIFICATION WITH APP IN BACKGROUND
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // ON RECEIVING NOTIFICATION WITH APP IN FOREGROUND (OPEN AND ACTIVE)
    FirebaseMessaging.onMessage.listen((message) async {
      debugPrint('Got a message whilst in the foreground!');
      //CONVERT NEW NOTIFICATION ITEM TO JSON OBJECT
      // var bodyString = {
      //   "id": message.messageId,
      //   "title": message.notification!.title,
      //   "body": message.notification!.body,
      //   "status": false, //read status
      // };

      // final prefs = await SharedPreferences.getInstance();
      //CHECK IF ANY LOCALLY STORED NOTIFICATIONS
      // final notificationDrammpWeb =
      //     jsonDecode(prefs.getString('notificationDrammpWeb') ?? '[]');
      // List<NotificationModel> notificationsmodel =
      //     (notificationDrammpWeb as List)
      //         .map((data) => NotificationModel.fromJson(data))
      //         .toList();
      // debugPrint("${jsonEncode(notificationsmodel)} MODEL BEFORE");
      // notificationsmodel.add(NotificationModel.fromJson(bodyString));
      // debugPrint("${jsonEncode(notificationsmodel)} MODEL AFTER");
      //ADD NEW NOTIFICATION TO OLD OBJECT
      // prefs.setString('notificationDrammpWeb', jsonEncode(notificationsmodel));

      final notification = message.notification;
      if (notification == null) return;

      debugPrint('Message data: ${message.notification!.body}');
      // flutterLocalNotificationsPlugin.show(
      //     notification.hashCode,
      //     notification.title,
      //     notification.body,
      //     const NotificationDetails(
      //       android: AndroidNotificationDetails(
      //           'high_importance_channel', 'High Importance Channel',
      //           channelDescription: 'Main channel notifications',
      //           importance: Importance.max,
      //           priority: Priority.max,
      //           icon: '@mipmap/launcher_icon'),
      //       iOS: DarwinNotificationDetails(
      //         sound: 'default.wav',
      //         presentAlert: true,
      //         presentBadge: true,
      //         presentSound: true,
      //       ),
      //     ),
      //     payload: jsonEncode(message.toMap()));
    });

    //ON OPENING A NOTIFICATION IN APP BAR
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint("onMessageOpenedApp: $message");
    });

    //INITIALIZE OS SETTINGS
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);

    if (kIsWeb) {
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    }
  }
}
