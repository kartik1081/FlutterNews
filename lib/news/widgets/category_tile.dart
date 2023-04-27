import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvvm/news/controller_news.dart';
import 'package:mvvm/settings/controller_settings.dart';
import 'package:provider/provider.dart';

class CategoryTile extends StatefulWidget {
  final String category;
  const CategoryTile({
    super.key,
    required this.category,
  });

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    Timer(
      const Duration(milliseconds: 200),
      () => _controller.forward(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int platform = context.watch<SettingsController>().platform;
    String category = context.watch<NewsController>().category;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Opacity(
        opacity: _animation.value,
        child: InkWell(
          onTap: () => category == widget.category
              ? null
              : context
                  .read<NewsController>()
                  .callApi(category: widget.category, platform: platform),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
            ),
            child: category == widget.category ? container2() : container1(),
          ),
        ),
      ),
    );
  }

  Widget container1() => Container(
        key: const ValueKey(1),
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: const Color(0xff252525),
          ),
        ),
        child: Center(
          child: Text(
            widget.category.isEmpty
                ? "All"
                : "${widget.category[0].toUpperCase()}${widget.category.substring(1).toLowerCase()}",
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      );

  Widget container2() => Container(
        key: const ValueKey(2),
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
        decoration: BoxDecoration(
          color: const Color(0xff252525),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Text(
            widget.category.isEmpty
                ? "All"
                : "${widget.category[0].toUpperCase()}${widget.category.substring(1).toLowerCase()}",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
}
