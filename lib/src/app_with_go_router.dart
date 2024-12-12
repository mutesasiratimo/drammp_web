import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';
import 'views/app_router/app_router.dart';

class AppWithGoRouter extends ConsumerWidget {
  const AppWithGoRouter({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return ToastificationWrapper(
      child: MaterialApp.router(
        // scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: 'DRAMMP Dashboard',
        routerConfig: goRouter,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            // appBarTheme: Theme.of(context).appBarTheme.copyWith(
            //       color: Colors.red,
            //     ),
            appBarTheme: const AppBarTheme(
              toolbarHeight: 50,
              backgroundColor: Colors.white,
            )),
      ),
    );
  }
}
