// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:mvvm/ads/controller_ads.dart';
// import 'package:provider/provider.dart';

// class AdsView extends StatelessWidget {
//   const AdsView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final size = context.watch<AdsController>().ad!.size;
//     return Center(
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//         child: Container(
//           height: size.height * 0.7,
//           width: size.width * 0.8,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.all(
//               Radius.circular(
//                 20.0,
//               ),
//             ),
//           ),
//           child: Stack(
//             children: [
//               AdWidget(ad: context.watch<AdsController>().ad!),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
