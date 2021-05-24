import 'package:http/http.dart' as http;
import 'package:news/modles/articlemodle.dart';
import 'dart:convert';

class News {
  List<ArticleModle> news = [];

  Future<void> getNews() async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=bf8cb42751554c4ab9ee89bd708a88cb";

    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null &&
            element['description'] != null &&
            element['content'] != null) {
          ArticleModle article = ArticleModle(
            title: element['title'],
            description: element['description'],
            urlToImage: element['urlToImage'],
            content: element["content"],
            articleUrl: element["url"],
          );
          news.add(article);
        }
      });
    }
  }
}

class NewsForCategorie {
  List<ArticleModle> news = [];

  Future<void> getNewsForCategory(String category) async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=in&category=$category&apiKey=bf8cb42751554c4ab9ee89bd708a88cb";

    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          ArticleModle article = ArticleModle(
            title: element['title'],
            description: element['description'],
            urlToImage: element['urlToImage'],
            content: element["content"],
            articleUrl: element["url"],
          );
          news.add(article);
        }
      });
    }
  }
}
