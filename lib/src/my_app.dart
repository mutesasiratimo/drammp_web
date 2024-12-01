import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/base.dart';
import 'views/admin_panel/home_page.dart';
import 'views/auth/signin.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DRAMMP Dashboard',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            toolbarHeight: 50,
            backgroundColor: Colors.white,
          )),
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
      setState(() {
        pushAndRemoveUntil(const HomePage());
      });
    } else {
      setState(() {
        pushAndRemoveUntil(const SignInPage());
      });
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
