import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mvvm/news/controller_news.dart';
import 'package:mvvm/news/model_news.dart';
import 'package:mvvm/news/widgets/category_tile.dart';
import 'package:mvvm/news/widgets/android_full_screen_tile.dart';
import 'package:mvvm/profile/view_profile.dart';
import 'package:provider/provider.dart';

import '../../const.dart';
import '../../settings/controller_settings.dart';
import '../../settings/view_settings.dart';
import '../widgets/card_tile.dart';

class AndroidNewsView extends StatelessWidget with WidgetsBindingObserver {
  const AndroidNewsView({super.key});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        if (kDebugMode) {
          print("Resumed");
        }
        break;
      case AppLifecycleState.paused:
        if (kDebugMode) {
          print("Pause");
        }
        break;
      case AppLifecycleState.inactive:
        if (kDebugMode) {
          print("Inactive");
        }
        break;
      case AppLifecycleState.detached:
        if (kDebugMode) {
          print("Detached");
        }
        break;
      default:
        if (kDebugMode) {
          print("Default");
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    int platform = context.watch<SettingsController>().platform;
    NewsController newsController = context.watch<NewsController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff252525),
        elevation: 0.0,
        title: const Text("News"),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => const [
              PopupMenuItem(value: 0, child: Text("Profile")),
              PopupMenuItem(value: 1, child: Text("Setting")),
            ],
            child: const Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: Icon(Icons.more_vert),
            ),
            onSelected: (value) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    value == 1 ? const SettingView() : const ProfileView(),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.07),
          child: Container(
            height: size.height * 0.07,
            width: size.width,
            padding: const EdgeInsets.only(
              top: 10.0,
              left: 5.0,
              right: 5.0,
              bottom: 10.0,
            ),
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoryList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) => CategoryTile(
                category: categoryList[index],
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => context
            .read<NewsController>()
            .callApi(category: newsController.category, platform: platform),
        child: Stack(
          children: [
            Consumer<NewsController>(
              builder: (context, provider, child) => Stack(
                children: [
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: provider.newsList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      NewsModel news = provider.newsList[index];
                      return InkWell(
                        onTap: () => provider.showCard(news),
                        child: CardTile(newsModel: news),
                      );
                    },
                  ),
                  provider.selectedNews != null
                      ? AndroidFullScreenCard(
                          newsModel: provider.selectedNews!,
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            newsController.loading
                ? BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      height: size.height,
                      width: size.width,
                      color: Colors.transparent,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
