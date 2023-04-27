import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mvvm/news/controller_news.dart';
import 'package:mvvm/news/model_news.dart';
import 'package:mvvm/settings/controller_settings.dart';
import 'package:provider/provider.dart';

class AndroidFullScreenCard extends StatefulWidget {
  final NewsModel newsModel;
  const AndroidFullScreenCard({super.key, required this.newsModel});

  @override
  State<AndroidFullScreenCard> createState() => _AndroidFullScreenCardState();
}

class _AndroidFullScreenCardState extends State<AndroidFullScreenCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey();
    final size = MediaQuery.of(context).size;
    int platform = context.watch<SettingsController>().platform;
    return InkWell(
      onTap: () {
        _controller.reverse();
        _controller.addListener(() {
          _animation.isDismissed
              ? context.read<NewsController>().disposeCard()
              : null;
        });
      },
      child: Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: RepaintBoundary(
            key: key,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, _) => Opacity(
                opacity: _animation.value,
                child: Container(
                  height: size.height * 0.7,
                  width: size.width * 0.8,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          20.0,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(5, 5),
                          blurRadius: 30,
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(-5, -5),
                          blurRadius: 30,
                          spreadRadius: 1,
                        ),
                      ]),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0)),
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxHeight: size.height * 0.3,
                                    maxWidth: size.width * 0.8,
                                    minHeight: size.height * 0.25,
                                    minWidth: size.width * 0.8,
                                  ),
                                  child: Image.network(
                                    filterQuality: FilterQuality.high,
                                    loadingBuilder:
                                        (context, child, loadingProgress) =>
                                            child,
                                    widget.newsModel.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  height: size.height * 0.03,
                                  width: size.width * 0.3,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.8),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20.0),
                                        bottomRight: Radius.circular(20.0)),
                                  ),
                                  child: Text(
                                    "- ${widget.newsModel.author}",
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 11.0, color: Colors.white60),
                                  ),
                                ),
                              ),
                              widget.newsModel.url == ""
                                  ? const SizedBox()
                                  : Positioned(
                                      bottom: 0,
                                      right: size.width * 0.02,
                                      child: InkWell(
                                        onTap: () => context
                                            .read<NewsController>()
                                            .launchUrl(
                                                uri: widget.newsModel.url,
                                                platform: platform),
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 10.0,
                                              right: 10.0,
                                              top: 5.0),
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(100.0),
                                                  topRight:
                                                      Radius.circular(100.0))),
                                          child: const Text(
                                            "Open on Inshorts",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10.0,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      )),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 5.0),
                            child: Text(
                              widget.newsModel.title,
                              maxLines: 3,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 23.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 5.0),
                                child: Text(
                                  widget.newsModel.content,
                                  style: const TextStyle(
                                      fontSize: 16.0, color: Colors.black54),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        right: 0,
                        child: TextButton(
                          onPressed: () => context
                              .read<NewsController>()
                              .storeNewsCard(key: key, platform: platform),
                          child: const Text("Save card"),
                        ),
                      ),
                      widget.newsModel.readMoreUrl == ""
                          ? const SizedBox()
                          : Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: InkWell(
                                onTap: () => context
                                    .read<NewsController>()
                                    .launchUrl(
                                        uri: widget.newsModel.readMoreUrl,
                                        platform: platform),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  height: size.height * 0.05,
                                  width: size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.8),
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(
                                        20.0,
                                      ),
                                      bottomRight: Radius.circular(
                                        20.0,
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    "Read More about article",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
