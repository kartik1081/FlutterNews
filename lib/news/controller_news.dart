import 'package:flutter/material.dart';
import 'package:mvvm/news/model_news.dart';
import 'package:mvvm/news/repo_news.dart';

class NewsController extends ChangeNotifier {
  final NewsRepo repo;
  NewsController({required this.repo});

  bool _loading = true;
  bool _checkNet = false;
  String _category = "Init";
  NewsModel? _selectedNews;
  List<NewsModel> _newsList = [];
  Widget _banner = const SizedBox();

  // final plugin = MvvmPlugin();

  bool get loading => _loading;
  bool get checkNet => _checkNet;
  String get category => _category;
  List<NewsModel> get newsList => _newsList;
  NewsModel? get selectedNews => _selectedNews;
  Widget get banner => _banner;

  void init({
    required BuildContext context,
    required String category,
    required int platform,
  }) {
    getBanner();
    network(platform: platform)
        .whenComplete(() => callApi(category: category, platform: platform));
  }

  void callApi({required String category, required int platform}) async {
    _loading = true;
    _selectedNews = null;
    repo.fetchData(category: category, platform: platform).then(
      (newsList) async {
        repo.showToast(
          content: category == ""
              ? "All news"
              : "${category[0].toUpperCase()}${category.substring(1).toLowerCase()} news",
          platform: platform,
        );
        _newsList = newsList;
        _loading = false;
        notifyListeners();
        await Future.delayed(
          const Duration(
            milliseconds: 100,
          ),
        );
        _category = category;
        notifyListeners();
      },
    );
    notifyListeners();
  }

  void showCard(NewsModel newsModel) {
    _selectedNews = newsModel;
    notifyListeners();
  }

  void disposeCard() {
    _selectedNews = null;
    notifyListeners();
  }

  void launchUrl({required String uri, required int platform}) async {
    _loading = true;
    repo.launchURL(uri: uri, platform: platform).whenComplete(() {
      _loading = false;
      notifyListeners();
    });
    notifyListeners();
  }

  Future<void> network({required int platform}) async {
    repo.checkNetwork(platform: platform).then((value) {
      _checkNet = value!;
      notifyListeners();
    });
  }

  Future<void> storeNewsCard(
      {required GlobalKey key, required int platform}) async {
    repo.storeNewsCard(key: key, platform: platform);
  }

  Future<void> payWithUpi(
      {required String upiId,
      required String name,
      required String amount,
      String cur = "INR",
      String note = "",
      required int platform}) async {
    repo.payWithUpi(
        upiId: upiId,
        name: name,
        amount: amount,
        cur: cur,
        note: note,
        platform: platform);
  }

  void getBanner() {
    repo.initializeConfig().then((value) {
      _banner = value;
      notifyListeners();
    });
  }
}
