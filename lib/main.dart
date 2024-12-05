import 'package:entebbe_dramp_web/src/app_with_go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'firebase_options.dart';
import 'services/notificationservice.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // NotificationService().initNotification();
  setUrlStrategy(PathUrlStrategy());
  runApp(const ProviderScope(child: AppWithGoRouter()));
}
