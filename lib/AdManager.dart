
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';


class RewardedInterstitialAdManager implements RewardedInterstitialAdLoadCallback{
  // RewardedInterstitialAd クラスのインスタンスを保持する変数
  RewardedInterstitialAd? _rewardedInterstitialAd;
  // 広告の読み込みが完了しているかどうかを示すフラグ
  bool _isAdLoaded = false;
  // 広告の最大読み込み試行回数
  final int maxAdLoadRetries = 3;
  // 広告の読み込み試行間隔(秒単位)
  final int adLoadRetryTimeSeconds = 5;

  // 広告を読み込むメソッド
  void loadAd() {
    RewardedInterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5354046379'
          : "ca-app-pub-3940256099942544/6978759866",
      request: AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          print('Rewarded interstitial ad loaded.');
          _rewardedInterstitialAd = ad;
          _isAdLoaded = true;
        },
        onAdFailedToLoad: (error) {
          print('Rewarded interstitial ad failed to load: $error');
        },
      ),
    );
  }

  // 広告を表示するメソッド
  void showAd() {
    if (_isAdLoaded) {
      _rewardedInterstitialAd?.fullScreenContentCallback;
      _rewardedInterstitialAd?.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        // ユーザーが報酬を獲得した場合に呼び出されるコールバック
        print('User earned reward: ${reward.amount} ${reward.type}');
        // リワード処理をここに実装する
      });
    } else {
      print('Rewarded interstitial ad is not loaded.');
    }
  }

  //広告の読み込みに失敗した場合に呼び出されるコールバック
  @override
  // TODO: implement onAdFailedToLoad
  FullScreenAdLoadErrorCallback get onAdFailedToLoad => throw UnimplementedError();

  //広告の読み込みが完了した場合に呼び出されるコールバック
  @override
  // TODO: implement onAdLoaded
  GenericAdEventCallback<RewardedInterstitialAd> get onAdLoaded => throw UnimplementedError();
}


class RewardedAdManager implements RewardedAdLoadCallback, FullScreenContentCallback {

  RewardedAd? _rewardedAd; // 広告オブジェクト

  // 広告のロード処理
  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5224354917'
          : "ca-app-pub-3940256099942544/1712485313",

      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad; // 広告オブジェクトを保存
        },
        onAdFailedToLoad: (error) {
          print('Ad failed to load: $error');
        },
      ),
    );
  }

  // 広告の表示処理
  void showRewardedAd() {

    // 広告が表示されたときの処理
    _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        print('Ad showed fullscreen content.');
      },
      // 広告が閉じられたときの処理
      onAdDismissedFullScreenContent: (ad) {
        print('Ad dismissed fullscreen content.');
        ad.dispose();
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('Ad failed to show fullscreen content: $error');
        ad.dispose();
        loadRewardedAd();
      },
    );

    _rewardedAd?.setImmersiveMode(true);
    _rewardedAd?.show(
      // リワード広告再生時の処理
      onUserEarnedReward: (ad, reward) {
        print('User earned reward: ${reward.amount} ${reward.type}');
        // TODO: 報酬を与える処理を追加

      },
    );
  }

  // リワード広告のロードが成功した場合のコールバック
  @override
  void onRewardedAdLoaded(RewardedAd ad) {
    _rewardedAd = ad;
  }

  // リワード広告のロードが失敗した場合のコールバック
  @override
  void onRewardedAdFailedToLoad(LoadAdError error) {
    print('Rewarded ad failed to load: $error');
  }

  // リワード広告が閉じられた場合のコールバック
  @override
  void onRewardedAdDismissed(RewardedAd ad) {
    ad.dispose();
    loadRewardedAd();
  }

  // リワード広告が表示できなかった場合のコールバック
  @override
  void onRewardedAdFailedToShow(RewardedAd ad, AdError error) {
    ad.dispose();
    loadRewardedAd();
  }

  // 報酬広告が開いたときに実行されるコールバック
  @override
  void onRewardedAdOpened(RewardedAd ad) {
    print('Rewarded ad opened.');
  }

  // ユーザーが報酬を獲得したときに実行されるコールバック
  @override
  void onUserEarnedReward(RewardedAd ad, RewardItem reward) {
    print('User earned reward: ${reward.amount} ${reward.type}');
  }

  // 広告がクリックされたときに実行されるコールバック
  @override
  // TODO: implement onAdClicked
  GenericAdEventCallback? get onAdClicked => throw UnimplementedError();

  // フルスクリーン広告が閉じられたときに実行されるコールバック
  @override
  // TODO: implement onAdDismissedFullScreenContent
  GenericAdEventCallback? get onAdDismissedFullScreenContent => throw UnimplementedError();

  // 広告の読み込みに失敗したときに実行されるコールバック
  @override
  // TODO: implement onAdFailedToLoad
  FullScreenAdLoadErrorCallback get onAdFailedToLoad => throw UnimplementedError();

  // フルスクリーン広告の表示に失敗したときに実行されるコールバック
  @override
  // TODO: implement onAdFailedToShowFullScreenContent
  void Function(dynamic ad, AdError error)? get onAdFailedToShowFullScreenContent => throw UnimplementedError();

  // 広告が表示されたときに実行されるコールバック
  @override
  // TODO: implement onAdImpression
  GenericAdEventCallback? get onAdImpression => throw UnimplementedError();

  // 広告が読み込まれたときに実行されるコールバック
  @override
  // TODO: implement onAdLoaded
  GenericAdEventCallback<RewardedAd> get onAdLoaded => throw UnimplementedError();

  // フルスクリーン広告が表示されたときに実行されるコールバック
  @override
  // TODO: implement onAdShowedFullScreenContent
  GenericAdEventCallback? get onAdShowedFullScreenContent => throw UnimplementedError();

  // フルスクリーン広告が閉じられる直前に実行されるコールバック
  @override
  // TODO: implement onAdWillDismissFullScreenContent
  GenericAdEventCallback? get onAdWillDismissFullScreenContent => throw UnimplementedError();
}


class InterstitialAdManager implements InterstitialAdLoadCallback{
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  void interstitialAd() {
    InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-3940256099942544/4411468910',

      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;
        },
        onAdFailedToLoad: (error) {
          print('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_isAdLoaded) {
      _interstitialAd?.fullScreenContentCallback;
      _interstitialAd?.show();

    } else {
      print('Interstitial ad is not yet loaded.');
    }
  }

  @override
  // TODO: implement onAdFailedToLoad
  FullScreenAdLoadErrorCallback get onAdFailedToLoad => throw UnimplementedError();

  @override
  // TODO: implement onAdLoaded
  GenericAdEventCallback<InterstitialAd> get onAdLoaded => throw UnimplementedError();
}


class AppOpenAdManager implements AppOpenAdLoadCallback {
  AppOpenAd? _appOpenAd;
  bool _isAdLoaded = false;

  void loadAd() {
    AppOpenAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/3419835294'
          : "ca-app-pub-3940256099942544/5662855259",
      request: AdRequest(),

      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isAdLoaded = true;
          _appOpenAd?.show();
        },
        onAdFailedToLoad: (error) {
          print('App open ad failed to load: $error');
        },
      ), orientation: 0,
    );
  }

  void showAdIfLoaded() {
    if (_isAdLoaded) {
      _appOpenAd?.show();
    } else {
      loadAd();
    }
  }

  void onAppOpenAdLoaded(AppOpenAd ad) {
    _appOpenAd = ad;
    _isAdLoaded = true;
    showAdIfLoaded();
  }

  void onAppOpenAdFailedToLoad(LoadAdError error) {
    print('App open ad failed to load: $error');
  }

  @override
  void onAppOpenAdClosed() {
    _appOpenAd?.dispose();
    _isAdLoaded = false;
    loadAd();
  }

  void dispose() {
    _appOpenAd?.dispose();
  }

  @override
  // TODO: implement onAdFailedToLoad
  FullScreenAdLoadErrorCallback get onAdFailedToLoad => throw UnimplementedError();

  @override
  // TODO: implement onAdLoaded
  GenericAdEventCallback<AppOpenAd> get onAdLoaded => throw UnimplementedError();
}




class MyHomePage2 extends StatefulWidget {


  @override
  State<MyHomePage2> createState() => _MyHomePage2State();
}

class _MyHomePage2State extends State<MyHomePage2> {
  int _counter = 0;

  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  RewardedAdManager rewardedAdManager = RewardedAdManager();
  InterstitialAdManager interstitialAdManager = InterstitialAdManager();
  RewardedInterstitialAdManager rewardedInterstitialAdManager = RewardedInterstitialAdManager();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rewardedAdManager.loadRewardedAd();
    rewardedInterstitialAdManager.loadAd();
    interstitialAdManager.interstitialAd();
    appOpenAdManager.loadAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("widget.title"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Show Interstitial Ad'),
              onPressed: interstitialAdManager.showInterstitialAd,
              // onPressed: showAd,

            ),
            ElevatedButton(
              child: Text('Show Rewarded Ad'),
              onPressed: rewardedAdManager.showRewardedAd,
              // onPressed: showAd,

            ),

            ElevatedButton(
              child: Text('Show RewardedInterstitial Ad'),
              onPressed: rewardedInterstitialAdManager.showAd,
              // onPressed: showAd,

            ),

            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Spacer(),

            const Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
