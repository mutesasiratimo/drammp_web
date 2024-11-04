import 'package:entebbe_dramp_web/config/constants.dart';
import 'package:entebbe_dramp_web/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:paged_datatable/paged_datatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/signin.dart';
import 'config/base.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        PagedDataTableLocalization.delegate
      ],
      supportedLocales: const [
        Locale("es"),
        Locale("en"),
        Locale("de"),
        Locale("it"),
      ],
      locale: const Locale("en"),
      title: 'Entebbe DRAMMP Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppConstants.primaryColor),
        // textTheme: kIsWeb ? GoogleFonts.robotoTextTheme() : null,
      ),
      home: const SessionCheck(),
    );
  }
}

class SessionCheck extends StatefulWidget {
  const SessionCheck({Key? key}) : super(key: key);

  @override
  State<SessionCheck> createState() => _SessionCheckState();
}

class _SessionCheckState extends Base<SessionCheck> {
  void checkLoggedin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("userid") != null) {
      pushAndRemoveUntil(HomePage());
      // Navigator.push(
      //   context,
      //   MaterialPageRoute<void>(
      //     builder: (BuildContext context) => MultiProvider(
      //       providers: [
      //         ChangeNotifierProvider(
      //           create: (context) => mc.MenuController(),
      //         ),
      //       ],
      //       child: const MainScreen(),
      //     ),
      //   ),
      // );
    } else {
      pushAndRemoveUntil(const SignInPage());
    }
  }

  @override
  void initState() {
    super.initState();
    checkLoggedin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            CupertinoActivityIndicator(
              radius: 50,
            ),
          ],
        ),
      ),
    );
  }
}
