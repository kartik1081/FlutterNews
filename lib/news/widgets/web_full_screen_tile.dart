// import 'dart:html' as html;

import 'package:flutter/material.dart';

import '../model_news.dart';

class WebFullScreenTile extends StatefulWidget {
  final NewsModel newsModel;
  const WebFullScreenTile({super.key, required this.newsModel});

  @override
  State<WebFullScreenTile> createState() => _WebFullScreenTileState();
}

class _WebFullScreenTileState extends State<WebFullScreenTile>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      margin:
          const EdgeInsets.only(top: 30.0, bottom: 30.0, right: 60.0, left: 30),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(
              20.0,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(5, 5),
              blurRadius: 15,
              spreadRadius: 0.5,
            ),
            // BoxShadow(
            //   color: Colors.black26,
            //   offset: Offset(-5, -5),
            //   blurRadius: 15,
            //   spreadRadius: 0.5,
            // ),
          ]),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
            child: SizedBox(
              height: size.height * 0.5,
              width: size.width,
              child: Image.network(
                filterQuality: FilterQuality.high,
                loadingBuilder: (context, child, loadingProgress) => child,
                widget.newsModel.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5.0),
                        child: Text(
                          widget.newsModel.title,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
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
                                  fontSize: 17.0, color: Colors.black54),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: VerticalDivider(
                    color: Colors.grey,
                    width: 1.0,
                    thickness: 1.0,
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Open in: ",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500),
                            ),
                            InkWell(
                              // onTap: () => html.window.confirm(
                              //         "Are you sure, want to open on Inshorts?")
                              //     ? html.window
                              //         .open(widget.newsModel.url, "_blank")
                              //     : null,
                              child: SizedBox(
                                height: size.width * 0.05,
                                child: Image.asset(
                                  "assets/inshorts.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          // onTap: () =>
                          // context.watch<SettingsController>().platfrome==1 ?
                          // html.window
                          //         .confirm("Are you sure, want to read more?")
                          //     ? html.window
                          //         .open(widget.newsModel.readMoreUrl, "_blank")
                          //     : null:
                          // context
                          //     .read<NewsController>()
                          //     .launchUrl(widget.newsModel.readMoreUrl),
                          child: Container(
                            height: size.height * 0.05,
                            width: size.width,
                            color: Colors.black87,
                            child: const Center(
                              child: Text(
                                "Read more about article...",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
