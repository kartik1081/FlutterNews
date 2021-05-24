import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:news/helper/data.dart';
import "package:news/helper/widgets.dart";
import 'package:news/modles/categorymodle.dart';
import 'package:news/views/profile.dart';
import 'package:news/views/signin.dart';
import 'package:news/views/categorynews.dart';
import '../helper/news.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late bool _loading;
  var newslist;

  List<CategorieModel> categories = List<CategorieModel>.empty(growable: true);

  void getNews() async {
    News news = News();
    await news.getNews();
    newslist = news.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    _loading = true;
    super.initState();

    categories = getCategories();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Flutter",
              style:
                  TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
            ),
            Text(
              "News",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            )
          ],
        ),
        actions: <Widget>[
          Opacity(
            opacity: 0,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.share,
                )),
          )
        ],
        // backgroundColor: Colors.transparent,
        elevation: 7.0,
      ),
      drawer: Drawer(
        child: new ListView(
          children: [
            new UserAccountsDrawerHeader(
              decoration: new BoxDecoration(color: Colors.red),
              accountName: new Text(
                "Kartik Nakrani",
                style: new TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              accountEmail: new Text(
                "knakrani.1081@gmail.com",
                style: new TextStyle(color: Colors.white),
              ),
              onDetailsPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => new Profile(),
                  ),
                );
              },
            ),
            new ListTile(
              leading: new Icon(Icons.logout),
              trailing: new Icon(Icons.arrow_right),
              title: new Text("Log Out"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => new LogIn(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      /// Categories
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 15.0, 0.0, 0.0),
                        height: 80,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return CategoryCard(
                                imageAssetUrl: categories[index].imageAssetUrl,
                                categoryName: categories[index].categoryName,
                              );
                            }),
                      ),

                      /// News Article
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        child: ListView.builder(
                            itemCount: newslist.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return NewsTile(
                                imgUrl: newslist[index].urlToImage ?? "",
                                title: newslist[index].title ?? "",
                                desc: newslist[index].description ?? "",
                                content: newslist[index].content ?? "",
                                posturl: newslist[index].articleUrl ?? "",
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String imageAssetUrl, categoryName;

  CategoryCard({required this.imageAssetUrl, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryNews(
                      newsCategory: categoryName.toLowerCase(),
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(right: 14),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                imageUrl: imageAssetUrl,
                height: 60,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 60,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black26),
              child: Text(
                categoryName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}
