
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'package:anki/V1/V1Result.dart';
import 'package:audio_session/audio_session.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart' as ja;
import '../AdManager.dart';
import '../その他/mail.dart';
import 'package:timezone/timezone.dart' as tz;

class Coin extends StatefulWidget {

  @override
  State<Coin> createState() => _CoinState();
}

class _CoinState extends State<Coin> {
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  InterstitialAdManager interstitialAdManager = InterstitialAdManager();
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
  var ID  = "";
  var sele = false;var visi = false;
  var date = "";var ticket = "";var ticketText = "";
  var coin = 0;
  var coinAll = 0;
  var item = ["英単語", "英熟語",  "漢字", "古文", "漢文単語", "世界史", "日本史", "地理","生物",]; //Icons.history
  var item1 = [LineIcons.font,LineIcons.info, LineIcons.pen,LineIcons.torah,LineIcons.fileInvoice, LineIcons.globe, LineIcons.map,LineIcons.mapMarker, LineIcons.bug, ];
  var item2 = ["約3200個", "約720個",  "約820個", "約400個", "約90個", "約1500問", "約1420問", "約2000問","約450問",]; //Icons.history

  void initState() {
    super.initState();
    sign();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(iconTheme: IconThemeData(color: Colors.black),backgroundColor: Colors.white, title:  Text(ticketText, style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center,), centerTitle: true,elevation: 0,),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(height: 50,color: Colors.white,),
          Container(margin: EdgeInsets.only(top:0), child: Text("広告非表示コイン", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,  fontSize: 20,),)),
          Container(margin: EdgeInsets.all(10), child: Text("100コインでその日の暗記機能の広告を非表示\n問題生成や質問機能時の広告は削除できません\n日付毎になるので24時を過ぎるとリセットするのでご注意!", style: TextStyle(color: Colors.black,  fontSize: 10,),textAlign: TextAlign.center,)),
          Container(margin: EdgeInsets.only(top:10), child: Text("現在"+ coinAll.toString()+"コイン", style: TextStyle(color: Colors.black,  fontSize: 10,),)),
          Container(margin: EdgeInsets.only(top:0), child: Text("今日残り"+ coin.toString()+"コインGET可能", style: TextStyle(color: Colors.black,  fontSize: 10,),)),
          Container(margin: EdgeInsets.only(top:20,right:20),child: IconButton(onPressed:sele? null : () {coinAdd ();}, icon: Icon(LineIcons.copyright,color:Colors.orange,size: 50,))),
          Container(margin: EdgeInsets.only(top:100,right:20),child:visi ==true? IconButton(onPressed:() {ticketAdd ();}, icon: Icon(LineIcons.checkSquare,color:Colors.green,size: 50,)):Container()),
          Container(margin: EdgeInsets.only(top:10), child: visi ==true? Text("100コイン使い広告非表示にする", style: TextStyle(color: Colors.black,  fontSize: 10,),):Container()),
          Container(margin: EdgeInsets.only(top:20), child: Text("Ankiplusではこんなのを学べるよ", style: TextStyle(color: Colors.black,  fontSize: 10,),)),
          Container(margin: EdgeInsets.only(top: 10, bottom: 30),
              child: GridView.count(padding: EdgeInsets.only(left: 20.0,right:  20.0),
                  crossAxisCount: 3, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0, childAspectRatio: 1.5, shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                  children: List.generate(item.length, (index) {
                    return GestureDetector(onTap: () {},
                        child: Container(alignment: Alignment.center,decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), ),
                          child: Column(children: <Widget>[
                             Container(child: Icon(item1[index], color: Colors.black, size: 35,)),
                             Container(margin: EdgeInsets.only(top:0), child: Text(item[index], style: TextStyle(color: Colors.black,  fontSize: 10,),)),
                            Container(margin: EdgeInsets.only(top:0), child: Text(item2[index], style: TextStyle(color: Colors.blueGrey[800],  fontSize: 7,),)),
                          ]),));}))), ],),),);
  }

  void sign() async {interstitialAd();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    coin = prefs.getInt(date +"コイン") ?? 100;
    coinAll = prefs.getInt("Allコイン") ?? 0;
    ticket = prefs.getString(date+"広告非表示チケット")??"";
    if (ticket == "あり"){ticketText = "今日は暗記機能の広告の表示はありません";}
  coinBool ();
    setState(() {});}

  Future<void> coinAdd () async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      showDialog(context: context, builder: (context) => AlertDialog(title:Container(child: Column(children: [
        Container(child:  Text("インターネット接続が必要です",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center)),
      ],),)  ));} else{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    coinAll = coinAll +1 ;coin = coin -1;print(coin);
    prefs.setInt(date +"コイン", coin);
    prefs.setInt("Allコイン", coinAll);
    if (coin==  95 ||coin==  85 ||coin==  75 ||coin==  65 ||coin==  55 ||coin==  45 ||coin==  35 ||coin==  25 ||coin==  15 ||coin==  5 ){showInterstitialAd();}
    coinBool ();
    setState(()  { });}}
  void coinBool (){if (coinAll >= 100){visi = true;}if (coin == 0){sele = true;}}

  Future<void> ticketAdd () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    coinAll = coinAll -100 ;prefs.setInt("Allコイン", coinAll);
    prefs.setString(date+"広告非表示チケット", "あり");ankert();
    setState(()  {visi = false; ticketText = "今日は暗記機能の広告の表示はありません";});}

  void interstitialAd() {
    if (ID != "FAP3jZy3pSTEmqJQN1ow"){
      InterstitialAd.load(adUnitId: Platform.isAndroid ? 'ca-app-pub-4716152724901069/2563672557' : 'ca-app-pub-4716152724901069/7560014210',
        request: AdRequest(),//ca-app-pub-4716152724901069/7560014210
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {_interstitialAd = ad;_isAdLoaded = true;},
          onAdFailedToLoad: (error) {
            print('Interstitial ad failed to load: $error');},),);}}

  void showInterstitialAd() {
    if (_isAdLoaded) {_interstitialAd?.fullScreenContentCallback;_interstitialAd?.show();
    } else {print('Interstitial ad is not yet loaded.');}interstitialAd();}
  @override
  FullScreenAdLoadErrorCallback get onAdFailedToLoad => throw UnimplementedError();
  @override
  GenericAdEventCallback<InterstitialAd> get onAdLoaded => throw UnimplementedError();

  Future<void> ankert() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();ID =  prefs.getString("ID")!;
    DateTime now = DateTime.now();DateFormat outputFormat = DateFormat('yyyy年MM月dd日');date = outputFormat.format(now);
    FirebaseFirestore.instance.collection('レポート').doc(date).update({"Coin": FieldValue.arrayUnion([ ID ]),});
  }

}
