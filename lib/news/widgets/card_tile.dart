import 'package:flutter/material.dart';
import 'package:mvvm/news/model_news.dart';
import 'package:mvvm/settings/controller_settings.dart';
import 'package:provider/provider.dart';

class CardTile extends StatefulWidget {
  final NewsModel newsModel;
  const CardTile({super.key, required this.newsModel});

  @override
  State<CardTile> createState() => _CardTileState();
}

class _CardTileState extends State<CardTile> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    int platform = context.watch<SettingsController>().platform;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) => Opacity(
        opacity: _animation.value,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
          elevation: 1.0,
          shadowColor: Colors.black,
          surfaceTintColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                child: SizedBox(
                  height: platform == 1 || platform == 4
                      ? size.height * 0.2
                      : size.width * 0.5,
                  width: size.width,
                  child: Image.network(
                    filterQuality: FilterQuality.high,
                    widget.newsModel.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Author: ",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: context
                                                  .watch<SettingsController>()
                                                  .platform ==
                                              1 ||
                                          context
                                                  .watch<SettingsController>()
                                                  .platform ==
                                              4
                                      ? 12.0
                                      : 13.0),
                            ),
                            Text(
                              widget.newsModel.author,
                              style: TextStyle(
                                  fontSize: context
                                                  .watch<SettingsController>()
                                                  .platform ==
                                              1 ||
                                          context
                                                  .watch<SettingsController>()
                                                  .platform ==
                                              4
                                      ? 13.0
                                      : 15.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Time: ",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: context
                                                  .watch<SettingsController>()
                                                  .platform ==
                                              1 ||
                                          context
                                                  .watch<SettingsController>()
                                                  .platform ==
                                              4
                                      ? 12.0
                                      : 13.0),
                            ),
                            Text(
                              widget.newsModel.time,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: context
                                                .watch<SettingsController>()
                                                .platform ==
                                            1 ||
                                        context
                                                .watch<SettingsController>()
                                                .platform ==
                                            4
                                    ? 13.0
                                    : 15.0,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const Divider(
                      height: 10.0,
                      thickness: 1,
                    ),
                    SizedBox(
                      width: size.width,
                      child: Text(
                        widget.newsModel.title,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: platform == 1 || platform == 4
                          ? 0
                          : size.height * 0.01,
                    ),
                    Text(
                      widget.newsModel.content,
                      overflow: platform == 1 || platform == 4
                          ? TextOverflow.visible
                          : TextOverflow.fade,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
