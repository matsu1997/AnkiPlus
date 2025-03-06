import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:anki/V1/V1Result.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart' as ja;
import '../AdManager.dart';
import '../V1/V1All.dart';
import '../main.dart';
import '../その他/mail.dart';
import 'package:timezone/timezone.dart' as tz;
import '../V1/V1Q.dart';
import '../アカウント/SignUp.dart';


class FirstQ1 extends StatefulWidget {
  @override
  State<FirstQ1> createState() => _FirstQ1State();
}

class _FirstQ1State extends State<FirstQ1> with TickerProviderStateMixin , WidgetsBindingObserver {

 var test = 0;
  @override
  void initState() {
    super.initState();
    test0();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child :Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0,
          automaticallyImplyLeading: false,
          // actions: <Widget>[IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.close, color: Colors.black87,))],
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
              Container(margin :EdgeInsets.only(top:30,bottom: 0,),child:Icon(Icons.quora,color: Colors.green,size: 100,)),
              Container(width:double.infinity,margin :EdgeInsets.only(top: 0),child:Text("アプリ利用テスト",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 22),textAlign: TextAlign.center,)),
              Container(width:double.infinity,margin :EdgeInsets.only(top: 20,bottom:10,left: 20,right: 20),child:Text("次の10英単語を覚えて\nテストで7問以上正解でクリア",style: TextStyle(color: Colors.blueGrey[800],fontSize: 15),textAlign: TextAlign.center,)),
              Container(width:double.infinity,margin :EdgeInsets.only(top: 50,bottom:10,left: 20,right: 20),child:Text("Step1\nまずは一覧でざっくり覚える",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,)),
              Container(margin: EdgeInsets.only(top: 0),width: 200, child: ElevatedButton(child:Text("覚える"), style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.orange, shape: const StadiumBorder(),),
                onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => FirstQAll()),);},),),
              Container(width:double.infinity,margin :EdgeInsets.only(top: 20,bottom:10,left: 20,right: 20),child:Text("Step2\n即答出来るまで繰り返し",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,)),
              Container(margin: EdgeInsets.only(top: 0),width: 200, child: ElevatedButton(child:Text("覚える"), style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.orange, shape: const StadiumBorder(),),
                onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => First1Q()),).then((value) => test0());;},),),
              Container(width:double.infinity,margin :EdgeInsets.only(top: 30,bottom:10,left: 20,right: 20),child:Text("Step3\nテスト",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,)),
              Container(margin: EdgeInsets.only(top: 0),width: 200, child: ElevatedButton(child:Text("テスト"), style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.orange, shape: const StadiumBorder(),),
                onPressed: test == 0 ? null : () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => First1Test()));},),),
            ]))));
  }

 void test0() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();test = prefs.getInt("テスト2") ?? 0;
   setState(() {});}


}






class First1Q extends StatefulWidget {

  @override
  State<First1Q> createState() => _First1QState();
}

class _First1QState extends State<First1Q>with TickerProviderStateMixin , WidgetsBindingObserver {
  final scheduleId = 0;
  final scheduleAddSec = 3;var testCo =0;
  var item = [["corporation","会社"],["code","法典"],["radical","根本的な"],["chairman","議長"],["string","ひも"],["troublesome","面倒な"],["retailer","小売商人"],["unit","ユニット"],["moisture","水分"],["developer","開発者"]];var item1 = [];var item2 = [];var item3 = [];var item4 = [];var itemAll = [];
  var text = "";var text2 = "";var ID = "";var date = "";
  var map = {};
  var count = 0;var itemco = 0;var time = 1;var startTime = "3";var co = 0;var CountTime = 1.0;var CountTime2 = 1.0;
  var OK = false;var _visible = true;
  late TextEditingController _bodyController;
  Color color  = Colors.red;
  FlutterTts flutterTts = FlutterTts();
  final _player = ja.AudioPlayer(handleInterruptions: false, androidApplyAudioAttributes: false, handleAudioSessionActivation: false,);
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  InterstitialAdManager interstitialAdManager = InterstitialAdManager();

  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();co = item.length;
    Future.delayed(Duration(seconds: 3), () {setState(() {startTime = "";_visible = false;OK = true;set();});});
    Future.delayed(Duration(seconds: 2), () {setState(() {startTime = "1";});});
    Future.delayed(Duration(seconds: 1), () {setState(() {startTime = "2";});});
    super.initState();
    interstitialAd();
    appOpenAdManager.loadAd();
    initAudioService();
    AudioSession.instance.then((audioSession) async {
      await audioSession.configure(AudioSessionConfiguration.speech());
      _handleInterruptions(audioSession);
    });


  }
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
  void interstitialAd() {
    InterstitialAd.load(adUnitId: Platform.isAndroid ? 'ca-app-pub-4716152724901069/2563672557' : 'ca-app-pub-4716152724901069/7560014210',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {_interstitialAd = ad;_isAdLoaded = true;},
        onAdFailedToLoad: (error) {
          print('Interstitial ad failed to load: $error');},),);}

  void showInterstitialAd() {
    if (_isAdLoaded) {_interstitialAd?.fullScreenContentCallback;_interstitialAd?.show();
    } else {print('Interstitial ad is not yet loaded.');}}
  @override
  FullScreenAdLoadErrorCallback get onAdFailedToLoad => throw UnimplementedError();
  @override
  GenericAdEventCallback<InterstitialAd> get onAdLoaded => throw UnimplementedError();


  @override
  void dispose() {
    flutterTts.stop;_player.dispose();initAudioService11();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white,
          leading: Container(alignment: Alignment.center,child:Text(startTime.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 30), textAlign: TextAlign.center,),),
           automaticallyImplyLeading: false, centerTitle: true,elevation: 0,
          actions: [IconButton(icon: const Icon(Icons.highlight_off,color: Colors.blueGrey,size: 30,), onPressed: () {Navigator.pop(context);},)],
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
              // Container(child: Visibility(visible: _visible, child: Column(children: <Widget>[
              //   Container(width: double.infinity,margin:EdgeInsets.only(top: 100),child:Text(startTime.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 50), textAlign: TextAlign.center,),)
              // ]))),
              Container(child: Column(children: <Widget>[
                // Container(child: Visibility(visible: _visible, child: Column(children: <Widget>[
                //   Container(width: double.infinity,margin:EdgeInsets.only(top: 20),child:Text(startTime.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 50), textAlign: TextAlign.center,),)
                // ]))),
                Container(margin: EdgeInsets.only(top: 30,bottom: 5, left: 20, right: 20), child:Text('問題',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[500]),),),
                Container(margin: EdgeInsets.only(top: 3, left: 20, right: 20), width: double.infinity,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.grey.shade100, spreadRadius: 5, blurRadius: 5, offset: Offset(1, 1),),], color: Colors.white,),
                    child: Column(children: <Widget>[
                      Container(margin: EdgeInsets.only(top: 30, left: 10, right: 10,bottom:30),width:double.infinity,alignment: Alignment.center, child: Text(text,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20), textAlign: TextAlign.center,),),
                    ])),
                Container(margin: EdgeInsets.only(top:20,bottom: 5, left: 20, right: 20), child:Text('答え',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[500]),),),
                Container(margin: EdgeInsets.only(top: 3, left: 20, right: 20), width: double.infinity,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.grey.shade100, spreadRadius: 5, blurRadius: 5, offset: Offset(1, 1),),], color: color,),
                    child: Column(children: <Widget>[
                      Container(margin: EdgeInsets.only(top: 30, left: 10, right: 10,bottom:30),width:double.infinity,alignment: Alignment.center, child: Text(text2,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.red,fontSize: 20), textAlign: TextAlign.center,),),
                    ])),
                TextButton(child: RichText(text: TextSpan(style: Theme.of(context).textTheme.bodyMedium,
                    children:  [
                      TextSpan(text: "答えまで", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                      TextSpan(text: CountTime.toString(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue)),
                      TextSpan(text: " 秒", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                    ]),), onPressed: () {},
                ),
                Container(width:double.infinity,child:Text("即答出来るまで『まだ』を選択",style: TextStyle(fontSize: 10),textAlign: TextAlign.center,),),
                Container(margin: EdgeInsets.only(top: 30, left: 10, right: 10),
                    child: Row(children: <Widget>[
                      Expanded(
                          child: Container(height: 90, width: 90,
                            child: Visibility(visible: OK,
                              child: ElevatedButton(
                                child: const Text('覚えた',style: TextStyle(fontWeight: FontWeight.bold),),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green,
                                  shape: const CircleBorder(side: BorderSide(color: Colors.green, width: 1, style: BorderStyle.solid,),),),
                                onPressed: () {item.removeAt(itemco);set();},
                              ),),)),
                      Container(width: 10,),
                      Expanded(child: Container(height: 90, width: 90, child: Visibility(visible: OK,
                        child: ElevatedButton(
                          child: const Text('まだ',style: TextStyle(fontWeight: FontWeight.bold),),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red,
                            shape: const CircleBorder(side: BorderSide(color: Colors.red, width: 1, style: BorderStyle.solid,),),),
                          onPressed: () {itemco = itemco + 1;set();},
                        ),),))])),
                Container(margin:EdgeInsets.only(top:20,bottom: 5,left: 100,right: 100),child:
                ClipRRect(borderRadius:  BorderRadius.all(Radius.circular(5)), child: LinearProgressIndicator(
                  value: item.length / co, valueColor: AlwaysStoppedAnimation(getCurrentHpColor(10)),
                  backgroundColor: Colors.grey, minHeight: 10,),),),
                Container(width:double.infinity,child:Text('${item.length.toString().padLeft(0, '  ')}/${co.toString()}',style: TextStyle(fontSize: 10),textAlign: TextAlign.center,),),
                Container(width:double.infinity,child:Text(time.toString() + "周目",style: TextStyle(fontSize: 10),textAlign: TextAlign.center,),),
              ],)),])
        ));}





  Color getCurrentHpColor(int hp) {
    if (hp > co / 2) {return Colors.blueGrey.shade600;}
    if (hp > co / 5) {return const Color(0xFFFFC107);}
    return const Color(0xFFFF0707);
  }

  void set (){setState(() {
    if (item.length != 0){
      if (itemco < item.length){
        color = Colors.red;
        if(testCo == 0){ text = item[itemco][0];text2 = item[itemco][1];}else{text = item[itemco][1];text2 = item[itemco][0];}
        _speak(item[itemco][0]);Future.delayed(Duration(seconds:CountTime.toInt()), () {setState(() {color = Colors.white;});});
      }else{itemco = 0;time = time + 1;
      color = Colors.red;
      if(testCo ==0){ text = item[itemco][0];text2 = item[itemco][1];}else{text = item[itemco][1];text2 = item[itemco][0];}
      _speak(item[itemco][0]); Future.delayed(Duration(seconds: CountTime.toInt()), () {setState(() {color = Colors.white;});});
      }
    }else{ showInterstitialAd();first ();}
  });}
  void first () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();prefs.setInt("テスト2", 1);Navigator.pop(context);}


  // CountTime = prefs.getDouble("time") ?? 1.5;}


  Future<void> _speak(index) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);
    await flutterTts.setVolume(1.0);
    await flutterTts.speak(index);
     }




  Future initAudioService() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.mixWithOthers,
      avAudioSessionMode: AVAudioSessionMode.defaultMode,
      avAudioSessionRouteSharingPolicy:
      AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: AndroidAudioAttributes(
        contentType: AndroidAudioContentType.music,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.media,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransientMayDuck,
      androidWillPauseWhenDucked: true,
    ));
  }
  Future<void> _handleInterruptions(AudioSession audioSession) async {
    bool playInterrupted = false;
    audioSession.becomingNoisyEventStream.listen((_) {
    });
    _player.playingStream.listen((playing) {
      playInterrupted = false;
      if (playing) {
        audioSession.setActive(true);
      }
    });
    audioSession.interruptionEventStream.listen((event) async {
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            if (audioSession.androidAudioAttributes!.usage ==
                AndroidAudioUsage.game) {
              _player.setVolume(_player.volume / 1.5);
            }
            playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            initAudioService();
            break;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            _player.setVolume(min(1.0, _player.volume * 2));
            playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
            if (playInterrupted) _player.play();
            playInterrupted = false;
            break;
          case AudioInterruptionType.unknown:
            playInterrupted = false;
            break;
        }
      }
    });
  }
  Future<void> initializeService1() async {
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart1,
        autoStart: false,
        isForegroundMode: false,
        notificationChannelId: 'my_foreground',
        initialNotificationTitle: 'AWESOME SERVICE',
        initialNotificationContent: 'Initializing',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: onStart1,
      ),);
    service.startService();
  }
  @pragma('vm:entry-point')
  void onStart1(ServiceInstance service) async {
    service.stopSelf();
  }

  Future<void> _handleInterruptions1(AudioSession audioSession) async {
    audioSession.setActive(false);
  }
  Future initAudioService11() async {
    final session = await AudioSession.instance;
    session.setActive(false);
    AudioSession.instance.then((audioSession) async {await audioSession.configure(AudioSessionConfiguration.speech());_handleInterruptions1(audioSession);});
    _player.dispose();_player.stop();
  }

}


class First1Test extends StatefulWidget {

  @override
  State<First1Test> createState() => _First1TestState();
}

class _First1TestState extends State<First1Test>with TickerProviderStateMixin , WidgetsBindingObserver {
  var item = [["corporation","経験","会社","協力","同僚","2"],["code","法典","系","命令","未満","1"],["radical","伝統の","医療の","関係","根本的な","4"],["chairman","議長","上司","課長","裁判官","1"],["string","印刷","道","ひも","教会","3"],["troublesome","状況","面倒な","課題","未遂","2"],["retailer","役者","運転手","税理士","小売商人","4"],["unit","地点","ユニット","最後の","個人の","2"],["moisture","水分","気泡","酸素","塩素","1"],["developer","技術者","経験者","開発者","先駆者","3"]];
  var text = "";var text2 = "";var ID = "";var date = "";var anser = "";var correst = 0;
  var map = {};
  var count = 0;var itemco = 0;var time = 1;var startTime = "3";var co = 0;var CountTime = 1.0;var CountTime2 = 1.0;
  var OK = false;var _visible = true;
  late TextEditingController _bodyController;
  Color color  = Colors.red;
  FlutterTts flutterTts = FlutterTts();


  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();co = item.length;
    Future.delayed(Duration(seconds: 3), () {setState(() {startTime = "";_visible = false;OK = true;_speak(item[0][0]);});});
    Future.delayed(Duration(seconds: 2), () {setState(() {startTime = "1";});});
    Future.delayed(Duration(seconds: 1), () {setState(() {startTime = "2";});});
    super.initState();

  }

  @override
  void dispose() {
    flutterTts.stop;
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white,
          leading: Container(alignment: Alignment.center,child:Text(startTime.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 30), textAlign: TextAlign.center,),),
          title: FittedBox(fit: BoxFit.fitWidth, child: Text(correst.toString() + "問正解", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center,),),
          automaticallyImplyLeading: false, centerTitle: true,elevation: 0,
          actions: [IconButton(icon: const Icon(Icons.highlight_off,color: Colors.blueGrey,size: 30,), onPressed: () {Navigator.pop(context);},)],
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
              // Container(child: Visibility(visible: _visible, child: Column(children: <Widget>[
              //   Container(width: double.infinity,margin:EdgeInsets.only(top: 100),child:Text(startTime.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 50), textAlign: TextAlign.center,),)
              // ]))),
              Container(child: Column(children: <Widget>[
                // Container(child: Visibility(visible: _visible, child: Column(children: <Widget>[
                //   Container(width: double.infinity,margin:EdgeInsets.only(top: 20),child:Text(startTime.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 50), textAlign: TextAlign.center,),)
                // ]))),
                Container(margin: EdgeInsets.only(top: 30,bottom: 5, left: 20, right: 20), child:Text('問題',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[500]),),),
                Container(margin: EdgeInsets.only(top: 3, left: 20, right: 20), width: double.infinity,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.grey.shade100, spreadRadius: 5, blurRadius: 5, offset: Offset(1, 1),),], color: Colors.white,),
                    child: Column(children: <Widget>[
                      Container(margin: EdgeInsets.only(top: 30, left: 10, right: 10,bottom:30),width:double.infinity,alignment: Alignment.center, child: Text(item[itemco][0],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20), textAlign: TextAlign.center,),),
                    ])),
                Container(margin: EdgeInsets.only(top: 70, left: 10, right: 10),
                    child: Row(children: <Widget>[
                      Expanded(child: Container(height: 90, width: 90,
                            child: Visibility(visible: OK,
                              child: ElevatedButton(
                                child:  Text(item[itemco][1] as String,style: TextStyle(fontWeight: FontWeight.bold),),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey,
                                  shape: const CircleBorder(side: BorderSide(color: Colors.blueGrey, width: 1, style: BorderStyle.solid,),),),
                                onPressed: () {anser = "1";;set();},
                              ),),)),
                      Container(width: 10,),
                      Expanded(child: Container(height: 90, width: 90, child: Visibility(visible: OK,
                        child: ElevatedButton(
                          child: Text(item[itemco][2] as String,style: TextStyle(fontWeight: FontWeight.bold),),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey,
                            shape: const CircleBorder(side: BorderSide(color: Colors.blueGrey, width: 1, style: BorderStyle.solid,),),),
                          onPressed: () {anser = "2";set();},
                        ),),))])),
                Container(margin: EdgeInsets.only(top: 30, left: 10, right: 10),
                    child: Row(children: <Widget>[
                      Expanded(child: Container(height: 90, width: 90,
                        child: Visibility(visible: OK,
                          child: ElevatedButton(
                            child:  Text(item[itemco][3] as String,style: TextStyle(fontWeight: FontWeight.bold),),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey,
                              shape: const CircleBorder(side: BorderSide(color: Colors.blueGrey, width: 1, style: BorderStyle.solid,),),),
                            onPressed: () {anser = "3";set();},
                          ),),)),
                      Container(width: 10,),
                      Expanded(child: Container(height: 90, width: 90, child: Visibility(visible: OK,
                        child: ElevatedButton(
                          child:  Text(item[itemco][4] as String,style: TextStyle(fontWeight: FontWeight.bold),),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey,
                            shape: const CircleBorder(side: BorderSide(color: Colors.blueGrey, width: 1, style: BorderStyle.solid,),),),
                          onPressed: () {anser = "4";set();},
                        ),),))])),
               ],)),])
        ));}





  Color getCurrentHpColor(int hp) {
    if (hp > co / 2) {return Colors.blueGrey.shade600;}
    if (hp > co / 5) {return const Color(0xFFFFC107);}
    return const Color(0xFFFF0707);
  }

  void set (){setState(() {
    if (item.length  -1 != itemco ){
      if (item[itemco][5] == anser){
       correst = correst + 1;
       itemco =  itemco + 1;
       _speak(item[itemco][0]);
      }else{
        itemco =  itemco + 1;
        _speak(item[itemco][0]);
        }
    }else{ first ();}
  });}
  void first () async {
    if( correst >= 7){ SharedPreferences prefs = await SharedPreferences.getInstance();prefs.setInt("テスト結果1", 1);  Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyApp()));}
 else{Navigator.pop(context);} }


  // CountTime = prefs.getDouble("time") ?? 1.5;}


  Future<void> _speak(index) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);
    await flutterTts.setVolume(1.0);
    await flutterTts.speak(index);
  }
  }





class FirstQAll extends StatefulWidget {


  @override
  State<FirstQAll> createState() => _FirstQAllState();
}

class _FirstQAllState extends State<FirstQAll> {
  var item = [["corporation","会社"],["code","法典"],["radical","根本的な"],["chairman","議長"],["string","ひも"],["troublesome","面倒な"],["retailer","小売商人"],["unit","ユニット"],["moisture","水分"],["developer","開発者"]];var item1 = [];var item2 = [];var item3 = [];var item4 = [];var itemAll = [];

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async => false,
        child: Scaffold(backgroundColor: Colors.white,
          appBar: AppBar(backgroundColor: Colors.white,
            title: Text(
              "一覧", style: TextStyle(color: Colors.black, fontSize: 15),
              textAlign: TextAlign.center,),
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(icon: const Icon(
                Icons.highlight_off, color: Colors.blueGrey, size: 30,),
                onPressed: () {Navigator.pop(context);},)
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(margin: EdgeInsets.all(10),
                  child: ListView.builder(
                    shrinkWrap: true, physics: NeverScrollableScrollPhysics(),
                    itemCount: item.length, itemBuilder: (context, index) {
                    return Card(
                      elevation: 0, color: Colors.grey[200], child: ListTile(
                      title: Text(item[index][0], style: TextStyle(
                          color: Colors.blueGrey[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 15), textAlign: TextAlign.center),
                      onTap: () {
                        showDialog(context: context,
                            builder: (context) => AlertDialog(title: Text(
                                item[index][1], style: TextStyle(
                                color: Colors.blueGrey[900],
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                                textAlign: TextAlign.center),));
                      },
                    ),);
                  },),),
              ],
            ),
          ),));
  }


  Future<void> report(text, ID) async {
    var ran = randomString(4);
    DateTime now = DateTime.now();
    DateFormat outputFormat = DateFormat('yyyy年MM月dd日');
    var date = outputFormat.format(now);
    DocumentReference ref = FirebaseFirestore.instance.collection('レポート')
        .doc(date);
    ref.update({
      "Result": FieldValue.arrayUnion(
          [ran + ":V:" + text + ID.substring(0, 3)]),
    });
  }

  String randomString(int length) {
    const _randomChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    const _charsLength = _randomChars.length;
    final rand = new Random();
    final codeUnits = new List.generate(
      length, (index) {
      final n = rand.nextInt(_charsLength);
      return _randomChars.codeUnitAt(n);
    },);
    return new String.fromCharCodes(codeUnits);
  }

}
