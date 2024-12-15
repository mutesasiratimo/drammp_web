import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:toastification/toastification.dart';
import '../services/messageprovider.dart';
import 'views/app_router/app_router.dart';

class AppWithGoRouter extends ConsumerWidget {
  const AppWithGoRouter({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return provider.MultiProvider(
      providers: [
        provider.ChangeNotifierProvider(
          create: (_) => MessageNotifierProvider(),
        ),
      ],
      builder: (context, child) {
        return ToastificationWrapper(
          child: MaterialApp.router(
            // scaffoldMessengerKey: scaffoldMessengerKey,
            debugShowCheckedModeBanner: false,
            title: 'DRAMMP Dashboard',
            routerConfig: goRouter,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                toolbarHeight: 50,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
