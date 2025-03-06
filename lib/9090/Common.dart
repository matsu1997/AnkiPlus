// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// class Common {
//
//   // 全画面で共通のドロワーを表示
//   static Drawer drawer(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         children: <Widget>[
//           const DrawerHeader(
//             child: Text(
//               'FlutterAdMobStudy',
//               style: TextStyle(
//                 fontSize: 24,
//                 color: Colors.white,
//               ),
//             ),
//             decoration: BoxDecoration(
//               color: Colors.blue,
//             ),
//           ),
//           ListTile(
//             title: const Text('インタースティシャル広告'),
//             onTap: () {
//               Navigator.of(context).pushReplacementNamed(InterstitialPage.route);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
// const maxFailedLoadAttempts = 3;
//
// class InterstitialPage extends StatefulWidget {
//   const InterstitialPage({Key? key}) : super(key: key);
//
//   static String route = '/interstitial';
//
//   @override
//   _InterstitialPageState createState() => _InterstitialPageState();
// }
//
// class _InterstitialPageState extends State<InterstitialPage> {
//
//   InterstitialAd? _interstitialAd;
//   int _numInterstitialLoadAttempts = 0;
//
//   static String get adUnitId {
//     // if (Platform.isAndroid) {
//     //   return '[android interstitial adUnitId]';
//     // } else if (Platform.isIOS) {
//     //   return '[ios interstitial adUnitId]';
//     // } else {
//     return InterstitialAd.testAdUnitId;
//     // }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _createInterstitialAd();
//   }
//
//   void _createInterstitialAd() {
//     InterstitialAd.load(
//         adUnitId: adUnitId,
//         request: const AdRequest(),
//         adLoadCallback: InterstitialAdLoadCallback(
//           onAdLoaded: (InterstitialAd ad) {
//             debugPrint('Ad loaded');
//             _interstitialAd = ad;
//             _numInterstitialLoadAttempts = 0;
//             _interstitialAd!.setImmersiveMode(true);
//           },
//           onAdFailedToLoad: (LoadAdError error) {
//             debugPrint('Ad failed to load: $error');
//             _numInterstitialLoadAttempts += 1;
//             _interstitialAd = null;
//             if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
//               _createInterstitialAd();
//             }
//           },
//         )
//     );
//   }
//
//   void _showInterstitialAd() {
//     if (_interstitialAd == null) {
//       debugPrint('Warning: attempt to show interstitial before loaded.');
//       return;
//     }
//     _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
//       onAdShowedFullScreenContent: (InterstitialAd ad) {
//         debugPrint('$ad onAdShowedFullScreenContent.');
//       },
//       onAdDismissedFullScreenContent: (InterstitialAd ad) {
//         debugPrint('$ad onAdDismissedFullScreenContent.');
//         ad.dispose();
//         // インタースティシャル広告を閉じた後でコンテンツ表示
//         showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: const Text('Interstitial After'),
//                 content: const SizedBox.shrink(),
//                 actions: [
//                   TextButton(
//                     child: const Text("Close"),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ],
//               );
//             }
//         );
//         _createInterstitialAd();
//       },
//       onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
//         debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
//         ad.dispose();
//         _createInterstitialAd();
//       },
//     );
//     _interstitialAd!.show();
//     _interstitialAd = null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Interstitial Ad Test'),
//         ),
//         drawer: Common.drawer(context),
//         body: Container(
//             margin: const EdgeInsets.fromLTRB(0, 30, 0, 30),
//             child: Center(
//               child: ElevatedButton(
//                 child: const Text('showInterstitialAd'),
//                 onPressed: () {
//                   _showInterstitialAd();
//                 },
//               ),
//             )
//         )
//     );
//   }
// }