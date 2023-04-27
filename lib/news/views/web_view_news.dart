import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mvvm/news/widgets/web_full_screen_tile.dart';
import 'package:provider/provider.dart';

import '../../const.dart';
import '../../settings/controller_settings.dart';
import '../controller_news.dart';
import '../model_news.dart';
import '../widgets/card_tile.dart';
import '../widgets/category_tile.dart';

class WebNewsView extends StatelessWidget {
  const WebNewsView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    int platform = context.watch<SettingsController>().platform;
    String category = context.read<NewsController>().category;
    bool loading = context.watch<NewsController>().loading;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: size.height * 0.05,
                  width: size.width,
                  margin: const EdgeInsets.only(
                    top: 10.0,
                    left: 5.0,
                    right: 5.0,
                    bottom: 5.0,
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => CategoryTile(
                      category: categoryList[index],
                    ),
                  ),
                ),
                Expanded(
                  child: Consumer<NewsController>(
                    builder: (context, provider, child) => Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10.0),
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: provider.newsList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    NewsModel news = provider.newsList[index];
                                    // if (index == 0) {
                                    //   provider.showCard(news);
                                    // }
                                    return InkWell(
                                      onTap: () => provider.showCard(news),
                                      child: CardTile(newsModel: news),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: FloatingActionButton(
                                  onPressed: () =>
                                      // print(context
                                      //     .read<NewsController>()
                                      //     .category),
                                      context.read<NewsController>().callApi(
                                          category: category,
                                          platform: platform),
                                  backgroundColor: Colors.black87,
                                  child: const Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: VerticalDivider(
                            color: Colors.grey,
                            width: 5.0,
                            thickness: 1.0,
                          ),
                        ),
                        Expanded(
                          flex: 9,
                          child: provider.selectedNews != null
                              ? WebFullScreenTile(
                                  newsModel: provider.selectedNews!)
                              : const Center(
                                  child: Text("Select News"),
                                ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            loading
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
