import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mvvm/auth/controller_auth.dart';
import 'package:mvvm/auth/repo_auth.dart';
import 'package:mvvm/auth/view_auth.dart';
import 'package:mvvm/local_auth/controller_local_auth.dart';
import 'package:mvvm/local_auth/repo_local_auth.dart';
import 'package:mvvm/local_auth/view_local_auth.dart';
import 'package:mvvm/locator.dart';
import 'package:mvvm/news/controller_news.dart';
import 'package:mvvm/news/repo_news.dart';
import 'package:mvvm/news/views/android_view_news.dart';
import 'package:mvvm/news/views/ios_view_news.dart';
import 'package:mvvm/news/views/web_view_news.dart';
import 'package:mvvm/settings/controller_settings.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'firebase_options.dart';

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator();
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsController>(
          create: (context) => SettingsController()..getPlatform(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (context) => AuthController(
            repo: locator<AuthRepo>(),
          )..checkSignInStatus(),
          lazy: false,
        ),
        // ChangeNotifierProvider<AdsController>(
        //   create: (context) => AdsController().init(),
        //   lazy: false,
        // )
      ],
      builder: (context, child) {
        bool isLoggedIn = context.watch<AuthController>().isLoggedIn;
        int platform = context.watch<SettingsController>().platform;
        return MaterialApp(
          title: 'MVVM',
          debugShowCheckedModeBanner: false,
          home: !isLoggedIn
              ? const AuthView()
              : platform == 1 || platform == 4
                  ? MultiProvider(
                      providers: [
                        ChangeNotifierProvider(
                          create: (context) => NewsController(
                            repo: locator<NewsRepo>(),
                          )..init(
                              context: context,
                              category: "",
                              platform: platform),
                          lazy: false,
                        ),
                      ],
                      child: const WebNewsView(),
                    )
                  : ChangeNotifierProvider<LocalAuthController>(
                      create: (context) =>
                          LocalAuthController(repo: locator<LocalAuthRepo>())
                            ..checkLocalAuth(platform: platform),
                      builder: (context, child) {
                        bool localAuth =
                            context.watch<LocalAuthController>().localAuth;
                        bool isActiveBiometric = context
                            .watch<LocalAuthController>()
                            .isActiveBiometric;
                        bool isBiometricAvailable = context
                            .watch<LocalAuthController>()
                            .isBiometricAvailable;
                        return MaterialApp(
                          title: 'MVVM',
                          debugShowCheckedModeBanner: false,
                          home: localAuth ||
                                  !isActiveBiometric ||
                                  !isBiometricAvailable
                              ? MultiProvider(
                                  providers: [
                                    ChangeNotifierProvider(
                                      create: (context) => NewsController(
                                        repo: locator<NewsRepo>(),
                                      )..init(
                                          context: context,
                                          category: "",
                                          platform: platform),
                                      lazy: false,
                                    ),
                                  ],
                                  child: platform == 2
                                      ? const AndroidNewsView()
                                      : const IosNewsView(),
                                )
                              : const LocalAuthView(),
                        );
                      },
                    ),
        );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cret, String host, int port) => true;
  }
}
