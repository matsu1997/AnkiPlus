
import 'dart:ffi';
import 'dart:ffi';
import 'dart:io';

import 'package:anki/V1/V1Result.dart';
import 'package:audio_session/audio_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:url_launcher/url_launcher.dart';
import '../AdManager.dart';
import '../その他/mail.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:math' as math;


class CreateQ4 extends StatefulWidget {
  CreateQ4(this.ID,this.ID2);
  String ID;String ID2;
  @override
  State<CreateQ4> createState() => _CreateQ4State();
}

class _CreateQ4State extends State<CreateQ4>with TickerProviderStateMixin , WidgetsBindingObserver {

  var boo = true;
  var item = [];
  var item1 = [];
  var uid = "";
  var co = 0;
  var reCo = 0;
  var _counter = 15.0;
  var textSize = 20.0;
  int mistake = 0;int corect = 0;
  var case1 = 0;
  var Id = "";var ID = "";
  var answer = "";
  var start = "スタート";
  var barText = "";
  var mailText = "";
  var QALabel = "問題";
  var color = Colors.blue;
  var colorB1 = Colors.blue;
  var colorB2 = Colors.blue;
  var colorB3 = Colors.blue;
  var colorB4 = Colors.blue;
  var color1 = Colors.white;
  var color2 = Colors.white;
  var color3 = Colors.white;
  var color4 = Colors.white;
  bool KaisetuB = true;
  bool reB = true;
  bool EditB = true;
  bool NextB = true;
  bool AnswerL = true;
  bool _A1B = true;
  bool _A2B = true;
  bool _A3B = true;
  bool _A4B = true;
  bool _NextB = true;

  bool A1B = false;
  bool A2B = false;
  bool A3B = false;
  bool A4B = false;
  var itemAll = [];
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
itemSet();

  }

  @override
  void dispose() {
    super.dispose();
  }

  void set4 (){

    var item4 = []; var random = math.Random();
    for (int i = 0; i < item.length ; i++) {
      var ran0 = random.nextInt(4);
      var a1 = item[i];
      item.removeAt(i);
      var r1 = random.nextInt(item.length );

      var a2 = item[r1];
      item.removeAt(r1);
      var r2 = random.nextInt(item.length );

      var a3 = item[r2];
      item.removeAt(r2);
      var r3 = random.nextInt(item.length );

      var a4 = item[r3];
      item.removeAt(r3);
      var r4 = random.nextInt(item.length );

      switch (ran0){
        case 0: item4.add([a1["問題"],a1["答え"],a2["答え"],a3["答え"],a4["答え"],1]); break;
        case 1: item4.add([a1["問題"],a2["答え"],a1["答え"],a3["答え"],a4["答え"],2]); break;
        case 2: item4.add([a1["問題"],a2["答え"],a3["答え"],a1["答え"],a4["答え"],3]); break;
        case 3: item4.add([a1["問題"],a2["答え"],a3["答え"],a4["答え"],a1["答え"],4]); break;
      }

     if (case1 == 0){itemSet ();case1 = 1;}
    } item4.shuffle();setState(() { item = item4;next();});
  }

  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
  void interstitialAd() {
    if (ID != "FAP3jZy3pSTEmqJQN1ow"){
      InterstitialAd.load(adUnitId: Platform.isAndroid ? 'ca-app-pub-4716152724901069/2563672557' : 'ca-app-pub-4716152724901069/1060944650',
        request: AdRequest(),//ca-app-pub-4716152724901069/7560014210
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {_interstitialAd = ad;_isAdLoaded = true;},
          onAdFailedToLoad: (error) {
            print('Interstitial ad failed to load: $error');},),);}}

  void showInterstitialAd() {
    if (_isAdLoaded) {_interstitialAd?.fullScreenContentCallback;_interstitialAd?.show();
    } else {print('Interstitial ad is not yet loaded.');}}
  @override
  FullScreenAdLoadErrorCallback get onAdFailedToLoad => throw UnimplementedError();
  @override
  GenericAdEventCallback<InterstitialAd> get onAdLoaded => throw UnimplementedError();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text(barText, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: _counter,), textAlign: TextAlign.center,),
        centerTitle: true, backgroundColor: color, actions: [],),
      floatingActionButton: FloatingActionButton(child: Text("次"), onPressed: () {if(item.length == 0){}else{co += 1;start = "次";
      if(co < item.length){next();
      } else{  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateQ4Result(item1,corect,mistake,"")),);
      }}},
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(height: 50,),
            Container(height: 200, width: double.infinity,
                child: Column(children: <Widget>[
                  Expanded(child: Stack(children: <Widget>[
                    new Center(child: Container(margin: EdgeInsets.all(10), width: double.infinity,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.grey.shade300, spreadRadius: 5, blurRadius: 5, offset: Offset(1.5, 1.5),),], color: Colors.white,),
                      alignment: Alignment.center,
                      child:Text(item[co][0],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: _counter), textAlign: TextAlign.center,),
                    )),])),//https://line.me/ti/g2/tqfeu7x4tj8AovbYoFgse_qLhNt5aZKTxXEwOw?utm_source=invitation&utm_medium=link_copy&utm_campaign=default
                ])),
            Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(child: Visibility(visible: A1B,
                    child: Container(width: double.infinity,
                      margin: EdgeInsets.only(top:5,bottom: 5,left: 10,right: 10),
                      child: OutlinedButton(style: OutlinedButton.styleFrom(foregroundColor: color, backgroundColor: color1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),), side:  BorderSide(color: colorB1 ,width: 5 ),),
                        onPressed: !_A1B ? null :() {setState(() {
                          if(1 == item[co][5]){color1 = Colors.blue;barText = "◯";corect = corect +1;}
                          else{barText = "✖︎";mistake = mistake + 1;color = Colors.red;}
                          answer = item[co][1];judge(item[co][5]);});},
                        child:FittedBox(fit: BoxFit.fitWidth,
                          child: Text(item[co][1], style: TextStyle(fontSize: _counter,color: Colors.black,fontWeight: FontWeight.bold,),
                          ),),),),)),
                  Expanded(child: Visibility(visible: A2B,
                    child: Container(width: double.infinity,
                      margin: EdgeInsets.only(top:5,bottom: 5,left: 10,right: 10),
                      child: OutlinedButton(style: OutlinedButton.styleFrom(foregroundColor: color, backgroundColor: color2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),), side: BorderSide(color: colorB2,width: 5),),
                        onPressed:!_A2B ? null : () {
                          if(2 == item[co][5]){color2 = Colors.blue;barText = "◯";corect = corect +1;}
                          else{barText = "✖︎";mistake = mistake + 1;color = Colors.red;}
                          answer = item[co][2];judge(item[co][5]);},
                        child:Container(child: Text(item[co][2], style: TextStyle(fontSize: _counter,color: Colors.black,fontWeight: FontWeight.bold,),),),),),)),
                  Expanded(child: Visibility(visible: A3B,
                    child: Container(width: double.infinity,
                      margin: EdgeInsets.only(top:5,bottom: 5,left: 10,right: 10),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(foregroundColor: color, backgroundColor: color3, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),), side:  BorderSide(color: colorB3,width: 5),),
                        onPressed:!_A3B ? null : () {
                          if(3 == item[co][5]){color3 = Colors.blue;barText = "◯";corect = corect +1;}
                          else{barText = "✖︎";mistake = mistake + 1;color = Colors.red;}
                          answer = item[co][3];judge(item[co][5]);},
                        child:Container(child: Text(item[co][3], style: TextStyle(fontSize: _counter,color: Colors.black,fontWeight: FontWeight.bold,),),),),),)),
                  Expanded(
                      child: Visibility(
                        visible: A4B,
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top:5,bottom: 5,left: 10,right: 10),
                          child: OutlinedButton(style: OutlinedButton.styleFrom(foregroundColor: color, backgroundColor: color4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),), side:  BorderSide(color:colorB4,width: 5),),
                            onPressed:!_A4B ? null : () {
                              if(4 == item[co][5]){color4 = Colors.blue;barText = "◯";corect = corect +1;}
                              else{barText = "✖︎";mistake = mistake + 1;color = Colors.red;}
                              answer = item[co][4];judge(item[co][5]);},
                            child:Container(child: Text(item[co][4], style: TextStyle(fontSize: _counter,color: Colors.black,fontWeight: FontWeight.bold,),),),),),)),
                  Container(height: 110,),
                ])),
          ],
        ),
      ),
    );
  }



  void next() {
    reCo = 0;textSize = 20;
    setState(() {
      AnswerL = false;reB = false;KaisetuB = false;EditB = false;NextB = false;
      _A1B  = true;_A2B  = true;_A3B  = true;_A4B  = true;
      A1B  = true;A2B  = true;A3B  = true;A4B  = true;
      color = Colors.blue;color1 = Colors.white;color2 = Colors.white;color3 = Colors.white;color4 = Colors.white;
      barText = "";
      QALabel = "問題";
      if(item.length != 0){
        if(co < item.length){
        } else{  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateQ4Result(itemAll,corect,mistake,"")),);
        }
      }else{
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //       builder: (context) => Result(item)),
        // );
      }});}

  void judge (index){
    setState(() {
      KaisetuB = true;NextB = true;AnswerL = true;
      _A1B  = false;_A2B  = false;_A3B  = false;_A4B  = false;
      if (item.length != 0){}else{}
      switch(index){
        case 1:color1 = Colors.blue;break;
        case 2:color2 = Colors.blue;break;
        case 3:color3 = Colors.blue;break;
        case 4:color4 = Colors.blue;break;
      }});}

  void itemSet(){
    FirebaseFirestore.instance.collection('users').doc(widget.ID).collection("問題集").where("ID" ,isEqualTo: widget.ID2).get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {item = doc["問題"]??[];itemAll = doc["問題"]??[]; item.shuffle();set4();//if(widget.co == 1){item.shuffle();}
      ;});});
  }

}





class CreateQ4Result extends StatefulWidget {
  CreateQ4Result(this.item,this.correct,this.misstake,this.name);
  List item; int correct;int misstake;String name;

  @override
  State<CreateQ4Result> createState() => _CreateQ4ResultState();
}

class _CreateQ4ResultState extends State<CreateQ4Result> {

  FlutterTts flutterTts = FlutterTts();

  void initState() {
    super.initState();print(widget.item);
  }

  @override
  void dispose() {
    flutterTts.pause();
    flutterTts.stop();
    super.dispose();
  }

  NativeAd? _nativeAd;

  //アプリの広告ユニットIDを入れる
  //今回の場合Androidのネイティブテスト広告ID
  final String _adUnitId = "ca-app-pub-3940256099942544/2247696110";

  void _loadNativeAd() {
    NativeAd(
      adUnitId: _adUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            //広告が読み込まれたことを通知
            _nativeAd = ad as NativeAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('failed');
          print(error);
          ad.dispose();
          _nativeAd = null;
        },
      ),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: Colors.white,
        cornerRadius: 10.0,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: const Color(0xFFECE9F3),
          backgroundColor: Colors.black,
          style: NativeTemplateFontStyle.monospace,
          size: 16.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black,
          backgroundColor: const Color(0xFFECE9F3),
          style: NativeTemplateFontStyle.italic,
          size: 16.0,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.green,
          backgroundColor: Colors.black,
          style: NativeTemplateFontStyle.bold,
          size: 16.0,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black,
          backgroundColor: const Color(0xFFECE9F3),
          style: NativeTemplateFontStyle.normal,
          size: 16.0,
        ),
      ),
    ).load();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async => false,
        child: Scaffold(backgroundColor: Colors.white,
          appBar: AppBar(backgroundColor: Colors.white,
            title: Text(
              widget.name, style: TextStyle(color: Colors.black, fontSize: 15),
              textAlign: TextAlign.center,),
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(icon: Icon(
                Icons.highlight_off, color: Colors.blueGrey, size: 30,),
                onPressed: () {Navigator.pop(context); Navigator.pop(context);},)
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Container(margin: EdgeInsets.all(10),
                  child: ListView.builder(
                    shrinkWrap: true, physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.item.length, itemBuilder: (context, index) {
                    return Card(
                      elevation: 0, color: Colors.grey[200], child: ListTile(
                      title: Text(widget.item[index]["問題"], style: TextStyle(
                          color: Colors.blueGrey[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 15), textAlign: TextAlign.center),
                      onTap: () {
                        report(widget.name);
                        showDialog(context: context, builder: (context) =>
                            AlertDialog(
                                title: Column(children: [
                                  Text(widget.item[index]["答え"], style: TextStyle(
                                      color: Colors.blueGrey[900],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                      textAlign: TextAlign.center),
                                  // Container(margin:EdgeInsets.only(top:200),child: _nativeAd != null ? ConstrainedBox(constraints: const BoxConstraints(minWidth: 100, minHeight: 100, maxWidth: 100, maxHeight: 100,),
                                  //     child: AdWidget(ad: _nativeAd!),)
                                  //       : const Column(mainAxisAlignment: MainAxisAlignment.center,
                                  //     children: [Text('ネイティブ広告を読み込み中'), SizedBox(height: 15), CircularProgressIndicator(color: Colors.black,),],),),
                                ],)
                            )); //_loadNativeAd();
                      },
                    ),);
                  },),),
              ],
            ),
          ),));
  }

  Future<void> _speak() async {
    flutterTts.setLanguage("ja-JP");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);
    await flutterTts.setVolume(1.0);
    for (int i = 0; i < widget.item.length; i++) {
      if (widget.name == "英単語") {
        flutterTts.setLanguage("en-US");
        await flutterTts.speak(widget.item[i][0] + "  ");
        flutterTts.setLanguage("ja-JP");
        await flutterTts.speak(widget.item[i][1]);
      } else {
        if (widget.name == "漢文単語") {
          await flutterTts.speak(widget.item[i][1]);
        } else {
          if (widget.name == "漢字") {
            await flutterTts.speak(widget.item[i][1]);
          } else {
            await flutterTts.speak(widget.item[i][0] + " // ////");
            await flutterTts.speak(widget.item[i][1]);
          }
        }
      }
    }
  }


  Future<void> report(text) async {
    var ran = randomString(4);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var ID = prefs.getString("ID") ?? "";
    DateTime now = DateTime.now();
    DateFormat outputFormat = DateFormat('yyyy年MM月dd日');
    var date = outputFormat.format(now);
    DocumentReference ref = FirebaseFirestore.instance.collection('レポート')
        .doc(date);
    ref.update({
      "ResultAll": FieldValue.arrayUnion(
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






