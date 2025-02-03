import 'package:entebbe_dramp_web/config/sessionlister.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as provider;
import 'package:toastification/toastification.dart';
import '../provider/app_preferences_provider.dart';
import '../provider/messageprovider.dart';
import '../provider/user_data_provider.dart';
import '../theme/themes.dart';
import 'views/app_router/app_router.dart';

class AppWithGoRouter extends StatefulWidget {
  const AppWithGoRouter({super.key});

  @override
  State<AppWithGoRouter> createState() => _AppWithGoRouterState();
}

class _AppWithGoRouterState extends State<AppWithGoRouter> {
  GoRouter? _appRouter;

  Future<bool>? _future;

  Future<bool> _getScreenDataAsync(
      AppPreferencesProvider appPreferencesProvider,
      UserDataProvider userDataProvider) async {
    await appPreferencesProvider.loadAsync();
    await userDataProvider.loadAsync();

    return true;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SessionTimeoutListener(
      onCallBack: () {
        debugPrint("Timeout");
        _appRouter!.go("/logout");
      },
      duration: Duration(seconds: 600),
      child: provider.MultiProvider(
        providers: [
          // App prefs like dark mode
          provider.ChangeNotifierProvider(
              create: (context) => AppPreferencesProvider()),
          // User profile prefs
          provider.ChangeNotifierProvider(
              create: (context) => UserDataProvider()),
          // Socket provider
          provider.ChangeNotifierProvider(
              create: (_) => MessageNotifierProvider()),
        ],
        child: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () {
                // Tap anywhere to dismiss soft keyboard.
                // AppFocusHelper.instance.requestUnfocus();
              },
              child: FutureBuilder<bool>(
                initialData: null,
                future: (_future ??= _getScreenDataAsync(
                    context.read<AppPreferencesProvider>(),
                    context.read<UserDataProvider>())),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!) {
                    return provider.Consumer<AppPreferencesProvider>(
                      builder: (context, provider, child) {
                        _appRouter ??=
                            goRouterProvider(context.read<UserDataProvider>());

                        return ToastificationWrapper(
                          child: MaterialApp.router(
                            debugShowCheckedModeBanner: false,
                            routeInformationProvider:
                                _appRouter!.routeInformationProvider,
                            routeInformationParser:
                                _appRouter!.routeInformationParser,
                            routerDelegate: _appRouter!.routerDelegate,
                            onGenerateTitle: (context) => "",
                            theme: AppThemeData.instance.light(),
                            darkTheme: AppThemeData.instance.dark(),
                            themeMode: provider.themeMode,
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
