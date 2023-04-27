import 'package:get_it/get_it.dart';
import 'package:mvvm/auth/repo_auth.dart';
import 'package:mvvm/local_auth/repo_local_auth.dart';
import 'package:mvvm/news/repo_news.dart';

final locator = GetIt.instance;

void setupLocator() async {
  // locator.registerLazySingleton<HomeRepo>(() => HomeRepoImpl());
  locator.registerSingleton<AuthRepo>(AuthRepoImpl(), signalsReady: true);
  locator.registerSingleton<LocalAuthRepo>(LocalAuthRepoImpl(),
      signalsReady: true);
  locator.registerSingleton<NewsRepo>(NewsRepoImpl(), signalsReady: true);
}
