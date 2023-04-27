// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class AdsController extends ChangeNotifier {
//   BannerAd? _ad;
//   bool _adLoading = true;

//   BannerAd? get ad => _ad;
//   bool get adLoading => _adLoading;

//   init() {
//     _ad = BannerAd(
//         size: AdSize.banner,
//         adUnitId: "ca-app-pub-3940256099942544/6300978111",
//         listener: BannerAdListener(
//           onAdLoaded: (ad) {
//             _adLoading = false;
//             notifyListeners();
//           },
//           onAdFailedToLoad: (ad, error) {
//             ad.dispose();
//             _adLoading = false;
//             notifyListeners();
//           },
//         ),
//         request: const AdRequest());
//   }

//   loadAd() {
//     _ad!.load();
//   }
// }
