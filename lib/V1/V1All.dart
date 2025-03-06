import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


import '../../AdManager.dart';

class V1All extends StatefulWidget {
  V1All(this.name,this.name2,);
  String name;String name2;

  @override
  State<V1All> createState() => _V1AllState();
}

class _V1AllState extends State<V1All> {
  var item = [];
  FlutterTts flutterTts = FlutterTts();
  List<String> prefItem = [];List<String> prefItem2 = [];
  var compare = true;
  void initState() {
    super.initState();print(widget.name);print(widget.name2);itemSet(); first ();interstitialAd();
   }

  @override
  void dispose() {
    flutterTts.pause();flutterTts.stop();
    super.dispose();
  }

  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
  var co = 0;
  Future<void> interstitialAd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var date1 = DateFormat('yyyy-MM-dd').format(DateTime.now());
    var aa = prefs.getString(date1+"広告非表示チケット")??"";
    if ( aa!= "あり"){
  InterstitialAd.load(adUnitId: Platform.isAndroid ? 'ca-app-pub-4716152724901069/2563672557' : 'ca-app-pub-4716152724901069/7560014210',
  request: AdRequest(),//ca-app-pub-4716152724901069/7560014210
  adLoadCallback: InterstitialAdLoadCallback(
  onAdLoaded: (ad) {_interstitialAd = ad;_isAdLoaded = true;},
  onAdFailedToLoad: (error) {
  print('Interstitial ad failed to load: $error');},),);}}

  void showInterstitialAd() {
  if (_isAdLoaded) {_interstitialAd?.fullScreenContentCallback;_interstitialAd?.show();interstitialAd();
  } else {print('Interstitial ad is not yet loaded.');}}
  @override
  FullScreenAdLoadErrorCallback get onAdFailedToLoad => throw UnimplementedError();
  @override
  GenericAdEventCallback<InterstitialAd> get onAdLoaded => throw UnimplementedError();

  void show ()async{
    co = co +1;
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      Navigator.pop(context);
      showDialog(context: context, builder: (context) => AlertDialog(title:Container(child: Column(children: [
        Container(child:  Text("インターネットに接続されていません。",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center)),
      ],),)  ));} else{ if (co == 5){showInterstitialAd();co = 0;} }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
          appBar: AppBar(backgroundColor: Colors.white,
            title:  Text(widget.name2, style: TextStyle(color: Colors.black,fontSize: 15), textAlign: TextAlign.left,),
            iconTheme: IconThemeData(color: Colors.black), elevation: 0,
            //automaticallyImplyLeading: false,
           actions: [
           Row(children: [
             Container(child: widget.name == "漢文単語" || widget.name == "古文"?Container(): IconButton(icon:  Icon(Icons.volume_up,color: Colors.blueGrey,), onPressed: () {_speak();},)),
             Container(child: IconButton(icon:  Icon(Icons.compare_arrows,color: Colors.blueGrey,), onPressed: () {if(compare == true){compare = false;}else{compare = true;};first();},)),
           ],)     ],),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
              Container(margin: EdgeInsets.all(10),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(),
                  itemCount:item.length, itemBuilder: (context, index) {
                    return compare == true ?
                      Card(elevation: 0,color:Colors.grey[200],child: widget.name == "英単語"||widget.name == "英熟語"?
                   ListTile(
                     trailing: Container(margin: EdgeInsets.only(top: 0), child:prefItem2.contains(item[index]["word"]+item[index]["meaning"]) == true ? Icon(LineIcons.times,color: Colors.black,):Container(child:prefItem.contains(item[index]["word"]+item[index]["meaning"]) == true ? Icon(Icons.circle_outlined,color: Colors.red,):Container(width: 0,))),
                     title: Text(item[index]["word"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), ),
                     subtitle:
                     Text(item[index]["translation"],style: TextStyle(color: Colors.blueGrey[600],fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.left),
                     //  Text("They finally reached the top of the mountain.\nYou can reach me at this number.\nThe scientist’s research reaches into new areas of biology",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center),
                     onTap: (){show ();//report(widget.name2);
                       showDialog(context: context, builder: (context) => AlertDialog(
                         title: Column(children: [
                           Text(item[index]["meaning"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
                           Text(item[index]["example"],style: TextStyle(color: Colors.blueGrey[600],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
                           Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                             Container(margin: EdgeInsets.only(top: 10),width: 50, child: IconButton(
                               onPressed: () {Correct(index);Navigator.pop(context);}, icon: Icon(Icons.circle_outlined,color: Colors.red,), ),),
                             Container(margin: EdgeInsets.only(top: 10),width: 50, child: IconButton(
                               onPressed: () {firebase(index);Navigator.pop(context);}, icon: Icon(LineIcons.times,color: Colors.black,), ),),
                           ],),
                           Text("",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center),
                           // // Container(margin:EdgeInsets.only(top:20),child: _nativeAd != null ? ConstrainedBox(constraints: const BoxConstraints(minWidth: 250, minHeight: 250, maxWidth: 250, maxHeight: 250,),
                           //   child: AdWidget(ad: _nativeAd!),)
                           //     : const Column(mainAxisAlignment: MainAxisAlignment.center,
                           //   children: [Text(''), SizedBox(height: 15), CircularProgressIndicator(color: Colors.black,),],),),
                         ],),
                       ));},
                   ):
                    ListTile(
                      trailing: Container(margin: EdgeInsets.only(top: 0), child:prefItem2.contains(item[index][0]+item[index][1]) == true ? Icon(LineIcons.times,color: Colors.black,):Container(child:prefItem.contains(item[index][0]+item[index][1]) == true ? Icon(Icons.circle_outlined,color: Colors.red,):Container(width: 0,))),
                      title: Text(item[index][0],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), ),
                     // subtitle:
                     //   Text("reach a conclusion \nreach out to someone",style: TextStyle(color: Colors.blueGrey[600],fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.left),
                     //  Text("They finally reached the top of the mountain.\nYou can reach me at this number.\nThe scientist’s research reaches into new areas of biology",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center),
                      onTap: (){show ();//report(widget.name2);
                        showDialog(context: context, builder: (context) => AlertDialog(
                            title: Column(children: [
                              Text(item[index][1],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
                              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                                Container(margin: EdgeInsets.only(top: 10),width: 50, child: IconButton(
                                  onPressed: () {Correct(index);Navigator.pop(context);}, icon: Icon(Icons.circle_outlined,color: Colors.red,), ),),
                                Container(margin: EdgeInsets.only(top: 10),width: 50, child: IconButton(
                                  onPressed: () {firebase(index);Navigator.pop(context);}, icon: Icon(LineIcons.times,color: Colors.black,), ),),
                              ],),
                              // // Container(margin:EdgeInsets.only(top:20),child: _nativeAd != null ? ConstrainedBox(constraints: const BoxConstraints(minWidth: 250, minHeight: 250, maxWidth: 250, maxHeight: 250,),
                              //   child: AdWidget(ad: _nativeAd!),)
                              //     : const Column(mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [Text(''), SizedBox(height: 15), CircularProgressIndicator(color: Colors.black,),],),),
                            ],),
                        ));
                        },
                    )

                    ):
                    Card(elevation: 0,color:Colors.grey[200],child: widget.name == "英単語"||widget.name == "英熟語"?
                    ListTile(
                      trailing: Container(margin: EdgeInsets.only(top: 0), child:prefItem2.contains(item[index]["meaning"]+item[index]["word"]) == true ? Icon(LineIcons.times,color: Colors.black,):Container(child:prefItem.contains(item[index]["meaning"]+item[index]["word"]) == true ? Icon(Icons.circle_outlined,color: Colors.red,):Container(width: 0,))),
                      title: Text(item[index]["meaning"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), ),
                      subtitle:
                      Text(item[index]["example"],style: TextStyle(color: Colors.blueGrey[600],fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.left),
                      //  Text("They finally reached the top of the mountain.\nYou can reach me at this number.\nThe scientist’s research reaches into new areas of biology",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center),
                      onTap: (){show ();//report(widget.name2);
                        showDialog(context: context, builder: (context) => AlertDialog(
                          title: Column(children: [
                            Text(item[index]["word"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
                            Text(item[index]["translation"],style: TextStyle(color: Colors.blueGrey[600],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
                            Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                              Container(margin: EdgeInsets.only(top: 10),width: 50, child: IconButton(
                                onPressed: () {Correct2(index);Navigator.pop(context);}, icon: Icon(Icons.circle_outlined,color: Colors.red,), ),),
                              Container(margin: EdgeInsets.only(top: 10),width: 50, child: IconButton(
                                onPressed: () {firebase2(index);Navigator.pop(context);}, icon: Icon(LineIcons.times,color: Colors.black,), ),),
                            ],),
                            Text("",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center),
                            // // Container(margin:EdgeInsets.only(top:20),child: _nativeAd != null ? ConstrainedBox(constraints: const BoxConstraints(minWidth: 250, minHeight: 250, maxWidth: 250, maxHeight: 250,),
                            //   child: AdWidget(ad: _nativeAd!),)
                            //     : const Column(mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [Text(''), SizedBox(height: 15), CircularProgressIndicator(color: Colors.black,),],),),
                          ],),
                        ));
                      },
                    ):
                    ListTile(
                      trailing: Container(margin: EdgeInsets.only(top: 0), child:prefItem2.contains(item[index][1]+item[index][0]) == true ? Icon(LineIcons.times,color: Colors.black,):Container(child:prefItem.contains(item[index][1]+item[index][0]) == true ? Icon(Icons.circle_outlined,color: Colors.red,):Container(width: 0,))),
                      title: Text(item[index][1],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), ),
                      // subtitle:
                      //   Text("reach a conclusion \nreach out to someone",style: TextStyle(color: Colors.blueGrey[600],fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.left),
                      //  Text("They finally reached the top of the mountain.\nYou can reach me at this number.\nThe scientist’s research reaches into new areas of biology",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center),
                      onTap: (){show ();//report(widget.name2);
                        showDialog(context: context, builder: (context) => AlertDialog(
                          title: Column(children: [
                            Text(item[index][0],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
                            Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                              Container(margin: EdgeInsets.only(top: 10),width: 50, child: IconButton(
                                onPressed: () {Correct2(index);Navigator.pop(context);}, icon: Icon(Icons.circle_outlined,color: Colors.red,), ),),
                              Container(margin: EdgeInsets.only(top: 10),width: 50, child: IconButton(
                                onPressed: () {firebase2(index);Navigator.pop(context);}, icon: Icon(LineIcons.times,color: Colors.black,), ),),
                            ],),
                            // // Container(margin:EdgeInsets.only(top:20),child: _nativeAd != null ? ConstrainedBox(constraints: const BoxConstraints(minWidth: 250, minHeight: 250, maxWidth: 250, maxHeight: 250,),
                            //   child: AdWidget(ad: _nativeAd!),)
                            //     : const Column(mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [Text(''), SizedBox(height: 15), CircularProgressIndicator(color: Colors.black,),],),),
                          ],),
                        ));
                      },
                    )

                    );

                    },),),],),
          ),);
  }

  Future<void> _speak() async {
    flutterTts.setLanguage("ja-JP");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);
    await flutterTts.setVolume(1.0);
    for(int i = 0; i< item.length; i++){
      if (widget.name == "英単語" ||widget.name == "英熟語"){flutterTts.setLanguage("en-US");await flutterTts.speak(item[i]["word"]+ "  ");flutterTts.setLanguage("ja-JP");await flutterTts.speak(item[i]["meaning"]);}else{
        if (widget.name == "漢文単語"){await flutterTts.speak(item[i][1]);}else{
          if (widget.name == "漢字"){await flutterTts.speak(item[i][1]);}else{
          await flutterTts.speak(item[i][0]+ " // ////");await flutterTts.speak(item[i][1]);}}
      }}
  }
  Future<void> first () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {prefItem = prefs.getStringList("Man4単語帳") ?? [];prefItem2 = prefs.getStringList("Man4単語帳バツ") ?? [];});
  }

  Future<void> firebase(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if( widget.name == "英単語"||widget.name == "英熟語"){
      prefItem2 = prefs.getStringList("Man4単語帳バツ") ?? [];
      prefItem2.add(item[index]["word"] + item[index]["meaning"]);
      if (prefItem2.contains(item[index]["word"] + item[index]["meaning"]) ==
          false) {} else {
        prefs.setStringList("Man4単語帳バツ", prefItem2);
      }
    }else {
      prefItem2 = prefs.getStringList("Man4単語帳バツ") ?? [];
      prefItem2.add(item[index][0] + item[index][1]);
      if (prefItem2.contains(item[index][0] + item[index][1]) ==
          false) {} else {
        prefs.setStringList("Man4単語帳バツ", prefItem2);
      }
      //Navigator.pop(context);
    }setState(() {});
  }
  Future<void> Correct(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefItem = prefs.getStringList("Man4単語帳") ?? [];prefItem2 = prefs.getStringList("Man4単語帳バツ") ?? [];
   if( widget.name == "英単語"||widget.name == "英熟語"){
     prefItem.add(item[index]["word"] + item[index]["meaning"]);
     prefItem2.remove(item[index]["word"] + item[index]["meaning"]);
     prefs.setStringList("Man4単語帳バツ", prefItem2);
     if (prefItem.contains(item[index]["word"] + item[index]["meaning"]) == false) {
       print(0);
     } else {
       prefs.setStringList("Man4単語帳", prefItem);
       print(1);
     }
   }else {
     prefItem.add(item[index][0] + item[index][1]);
     prefItem2.remove(item[index][0] + item[index][1]);
     prefs.setStringList("Man4単語帳バツ", prefItem2);
     if (prefItem.contains(item[index][0] + item[index][1]) == false) {
       print(0);
     } else {
       prefs.setStringList("Man4単語帳", prefItem);
       print(1);
     }
   }// Navigator.pop(context);
    setState(() {});
  }

  Future<void> firebase2(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if( widget.name == "英単語"||widget.name == "英熟語"){
      prefItem2 = prefs.getStringList("Man4単語帳バツ") ?? [];
      prefItem2.add(item[index]["meaning"] + item[index]["word"]);
      if (prefItem2.contains(item[index]["meaning"] + item[index]["word"]) ==
          false) {} else {
        prefs.setStringList("Man4単語帳バツ", prefItem2);
      }
    }else {
      prefItem2 = prefs.getStringList("Man4単語帳バツ") ?? [];
      prefItem2.add(item[index][1] + item[index][0]);
      if (prefItem2.contains(item[index][1] + item[index][0]) ==
          false) {} else {
        prefs.setStringList("Man4単語帳バツ", prefItem2);
      }
      //Navigator.pop(context);
    }setState(() {});
  }
  Future<void> Correct2(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefItem = prefs.getStringList("Man4単語帳") ?? [];prefItem2 = prefs.getStringList("Man4単語帳バツ") ?? [];
    if( widget.name == "英単語"||widget.name == "英熟語"){
      prefItem.add(item[index]["meaning"] + item[index]["word"]);
      prefItem2.remove(item[index]["meaning"] + item[index]["word"]);
      prefs.setStringList("Man4単語帳バツ", prefItem2);
      if (prefItem.contains(item[index]["meaning"] + item[index]["word"]) == false) {
        print(0);
      } else {
        prefs.setStringList("Man4単語帳", prefItem);
        print(1);
      }
    }else {
      prefItem.add(item[index][1] + item[index][0]);
      prefItem2.remove(item[index][1] + item[index][0]);
      prefs.setStringList("Man4単語帳バツ", prefItem2);
      if (prefItem.contains(item[index][1] + item[index][0]) == false) {
      } else {
        prefs.setStringList("Man4単語帳", prefItem);
      }
    }// Navigator.pop(context);
    setState(() {});
  }
  // Future<void> report(text) async {
  //   var ran = randomString(4);
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var ID = prefs.getString("ID") ?? "";
  //   DateTime now = DateTime.now();DateFormat outputFormat = DateFormat('yyyy年MM月dd日'); var date = outputFormat.format(now);
  //   DocumentReference ref = FirebaseFirestore.instance.collection('レポート').doc(date);
  //   ref.update({"ResultAll" : FieldValue.arrayUnion([ran + ":V:" + text + ID.substring(0, 3)]),});
  // }
  //
  // String randomString(int length) {
  //   const _randomChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  //   const _charsLength = _randomChars.length;
  //   final rand = new Random();
  //   final codeUnits = new List.generate(
  //     length, (index) {
  //     final n = rand.nextInt(_charsLength);
  //     return _randomChars.codeUnitAt(n);
  //   },);return new String.fromCharCodes(codeUnits);}





void itemSet (){
  switch (widget.name2){
    case "中学英語1" :item = [["time","時\n～回\n～倍"],["journalist","ジャーナリスト"],["reach","到着する\n連絡をする\n領域"],["lunch","昼食"],["orange","オレンジ"],["camera","カメラ"],["earth","地球"],["trick","トリック"],["knee","ひざ"],["did","doの過去形"]];break;;break;
    case "中学英語2" :item = [["crayon","クレヨン"],["pool","水たまり"],["musician","音楽家"],["hour","1時間"],["member","メンバー"],["understand","理解する"],["reduce","減らす\n煮詰める"],["president","大統領"],["ship","船"],["carpenter","大工"],];break;
    case "中学英語3" :item = [["care","世話\n心配"],["worry","心配する"],["mouth","口"],["study","勉強する"],["mistake","誤り"],["condition","状態 \n条件"],["fly","飛ぶ \nハエ"],["favorite","お気に入りの"],["stay","滞在する　\nそのまま"],["carry","運ぶ\n伝える\n保つ"],];break;
    case "中学英語4" :item = [["similar","似ている"],["without","～なしで"],["until","～まで"],["mind","精神\n気にする"],["also","～もまた"],["event","出来事"],["though","～だけれども"],["adventure","冒険"],["lead","導く\nもたらす"],["grandma","おばあちゃん"]];break;;break;
    case "中学英語5" :item = [["beautiful","美しい"],["nervous","緊張している"],["wide","幅の広い"],["decoration","装飾"],["fry","揚げ物"],["social","社会の"],["cat","ネコ"],["hello","こんにちは"],["map","地図"],["insect","昆虫"]];break;;break;
    case "中学英語6" :item = [["even","同等の"],["teamwork","チームワーク"],["choice","選ぶこと"],["bench","ベンチ"],["relax","リラックスする"],["slow","遅い"],["heat","熱"],["schoolyard","校庭"],["teeth","tooth の複数形"],["enough","十分な"]];break;;break;
    case "中学英語7" :item = [["skill","技能"],["everything","すべてのもの"],["full","十分な"],["park","公園"],["candle","ろうそく"],["library","図書館"],["desk","机"],["share","分け合う"],["suddenly","突然に"]];break;;break;
    case "中学英語8" :item = [["subject","主題"],["fish","魚"],["familiar","いつもの"],["doghouse","犬小屋"],["high","高い"],["ride","乗る"],["sea","海"],["leader","先導者"],["dead","死んだ"],["toss","放り投げる"]];break;;break;
    case "中学英語9" :item = [["remind","思い出させる"],["disease","病気"],["boring","退屈な"],["telephone","電話"],["best","最高の"],["born","生まれた"],["clearly","明確に"],["tall","背の高い"],["children","子供たち"],["girl","女の子"]];break;;break;
    case "中学英語10" :item = [["elephant","象"],["cold","寒い"],["chair","いす"],["band","音楽隊"],["fell","fallの過去形"],["ran","runの過去形"],["designer","デザイナー"],["memory","記憶"],["print","印刷"],["week","週"]];break;;break;
    case "中学英語11" :item = [["red","赤"],["glass","ガラス"],["receive","受け取る"],["tradition","伝統"],["suffer","苦しむ"],["crowd","群集"],["bend","曲げる"],["long","長い"],["woman","女性 "],["bag","バッグ"]];break;;break;
    case "中学英語12" :item = [["shopper","買い物客"],["fill","いっぱいにする"],["club","クラブ"],["shyly","恥ずかしがって"],["year","年"],["dance","ダンス"],["kid","子供"],["pick","選び取る"],["field","野原"],["strong","強い"]];break;;break;
    case "中学英語13" :item = [["camp","キャンプ"],["action","活動"],["wash","洗う"],["jacket","ジャケット"],["ear","耳"],["bread","パン"],["surprise","驚かす"],["bathroom","浴室"],["graduate","卒業生"],["dolphin","イルカ"]];break;;break;
    case "中学英語14" :item = [["unfair","不当な"],["evening","晩"],["sorry","申し訳ない"],["ceremony","儀式"],["price","価格"],["sister","姉"],["listen","聞く"],["guest","お客"],["dream","夢"],["stapler","ホッチキス"]];break;;break;
    case "中学英語15" :item = [["teammate","チームメイト"],["alone","孤独な"],["another","もうひとつの"],["point","点"],["example","例"],["fast","速い"],["hurt","傷つける"],["pot","ポット"],["curry","カレー"],["pardon","寛容"]];break;;break;
    case "中学英語16" :item = [["produce","生産する"],["area","地域"],["same","同じ"],["problem","課題"],["student","学生"],["right","右"],["spoil","だめにする"],["when","いつ"],["Wednesday","水曜日"],["shirt","シャツ"]];break;;break;
    case "中学英語17" :item = [["pair","一対"],["meet","会う"],["classmate","同級生"],["Sunday","日曜日"],["answer","答え"],["stage","舞台"],["forest","森林"],["knife","ナイフ"],["rest","休息"],["train","列車"]];break;;break;
    case "中学英語18" :item = [["talk","話す"],["gate","門"],["rabbit","うさぎ"],["discover","発見する"],["delicious","おいしい"],["lose","負ける"],["body","体"],["learn","学ぶ"],["soon","すぐに"],["weather","天気"]];break;;break;
    case "中学英語19" :item = [["left","左"],["spice","香辛料"],["virtual","実質上の"],["themselves","彼ら自身"],["museum","博物館"],["wait","待つ"],["sound","音"],["ago","～前に"],["dictionary","辞書"],["weak","弱い"]];break;;break;
    case "中学英語20" :item = [["scooter","スクーター"],["whose","誰の"],["community","共同体"],["animation","生気"],["grand","壮大な"],["thirsty","のどが渇いた"],["celebrate","祝う"],["shoot","発射する"],["wood","木"]];break;;break;
    case "中学英語21" :item = [["dinner","夕食"],["mine","私のもの"],["statue","像"],["promise","約束"],["need","必要とする"],["through","～を通して"],["proud","誇りに思う"],["arrive","到着する"],["culture","文化"],["use","使う"],];break;
    case "中学英語22" :item = [["habit","習慣"],["class","クラス"],["crowded","混雑した"],["please","どうぞ"],["enjoy","楽しむ"],["ballet","バレエ"],["prepare","準備する"],["radio","ラジオ"],["music","音楽"],["clean","清潔な"]];break;;break;
    case "中学英語23" :item = [["weigh","量る"],["bottle","びん"],["but","しかし"],["page","ページ"],["skirt","スカート"],["hospital","病院"],["pretty","かわいい"],["grandfather","祖父"],["bath","入浴"]];break;;break;
    case "中学英語24" :item = [["go","行く"],["so","そのように"],["perfect","完璧な"],["wave","波"],["prize","賞"],["speed","速度"],["bedroom","寝室"],["central","中心の"],["shark","サメ"],["traditional","伝統の"]];break;;break;
    case "中学英語25" :item = [["recite","暗唱する"],["say","言う"],["look","見る"],["trophy","トロフィー"],["birthday","誕生日"],["moon","月"],["heart","心臓"],["than","～より"],["should","～すべきだ"],["easy","簡単な"]];break;;break;
    case "中学英語26" :item = [["check","点検する"],["crane","鶴"],["solar","太陽の"],["first","第１の"],["star","星"],["cent","セント"],["button","ボタン"],["flight","飛行"],["good","良い"],["angry","怒って"]];break;;break;
    case "中学英語27" :item = [["communication","コミュニケーション"],["active","活動的な"],["rat","ネズミ"],["hers","彼女のもの"],["side","側面"],["label","ラベル"],["seat","座席"],["worse","より悪い"],["lost","失った"],["mask","マスク"]];break;;break;
    case "中学英語28" :item = [["Japanese","日本語"],["candy","あめ"],["sofa","ソファ"],["about","～について"],["captain","船長"],["foreign","外国の"],["cute","可愛い"],["happen","起こる"],["honey","はちみつ"],["roof","屋根"],];break;
    case "中学英語29" :item = [["no","いいえ"],["my","私の"],["duck","カモ"],["those","それら"],["can","できる"],["easily","容易に"],["new","新しい"],["down","～の下へ"],["spread","広がり"],["company","会社"]];break;;break;
    case "中学英語30" :item = [["write","書く"],["absent","不在の"],["snack","軽食"],["comic","喜劇の"],["excited","興奮した"],["we","私たちは"],["respect","敬意"],["abroad","海外の"],["his","彼の"],["textbook","教科書"],];break;
    case "中学英語31" :item = [["yard","庭"],["spell","字をつづる"],["amazing","驚くべき"],["monument","記念建造物"],["die","死ぬ"],["grow","成長"],["five","5"],["run","走る"],["waiter","ウェイター"],["favor","世話"]];break;;break;
    case "中学英語32" :item = [["ourselves","私たち自身"],["plane","飛行機"],["fruit","果物"],["love","愛"],["car","車"],["by","～によって"],["she","彼女は"],["actually","実は"],["wrong","間違った"],["while","する間に"],];break;
    case "中学英語33" :item = [["airport","空港"],["finish","終える"],["secret","秘密の"],["ceiling","天井"],["wallet","財布"],["wonderful","すばらしい"],["contest","競技会"],["climb","登る"],["pan","浅い鍋"],["pen","ペン"]];break;;break;
    case "中学英語34" :item = [["play","遊ぶ"],["white","白"],["bank","銀行"],["lend","貸す"],["butterfly","蝶"],["homestay","ホームステイ"],["daily","毎日の"],["basketball","バスケットボール"],["shell","貝"],["hunting","狩り"]];break;;break;
    case "中学英語35" :item = [["grown","growの過去分詞形"],["American","アメリカの"],["Korean","韓国人"],["past","過去の"],["close","閉める"],["party","パーティー"],["king","王"],["teach","教える"],["rider","ライダー"],["ice","氷"]];break;;break;
    case "中学英語36" :item = [["driver","運転手"],["trainer","トレーナー"],["son","息子"],["thousand","1000"],["raise","上げる"],["month","月"],["room","部屋"],["well","上手に"],["boy","男の子"],["office","オフィス"]];break;;break;
    case "中学英語37" :item = [["aircraft","航空機"],["surprised","驚いた"],["photographer","写真家"],["rope","ロープ"],["however","しかしながら"],["plan","計画"],["differently","異なって"],["oil","油"],["elementary","初歩の"],["photo","写真"]];break;;break;
    case "中学英語38" :item = [["shy","恥ずかしがりの"],["corner","角"],["door","ドア"],["hole","穴"],["or","または"],["school","学校"],["flower","花"],["afternoon","午後"],["question","質問"],["fire","火"]];break;;break;
    case "中学英語39" :item = [["injury","けが"],["wish","望み"],["job","仕事"],["her","彼女に"],["explain","説明する"],["tennis","テニス"],["become","～になる"],["toothpaste","歯磨き粉"],["host","ホスト"],["worst","最悪の"],];break;
    case "中学英語40" :item = [["bay","湾"],["quiet","静かな"],["sometimes","ときどき"],["apartment","アパート"],["joke","冗談"],["save","救う"],["word","単語"],["deep","深い"],["low","低い"],["French","フランス語"]];break;;break;
    case "中学英語41" :item = [["store","店"],["late","遅い"],["someone","だれか"],["bird","鳥"],["hey","おい"],["protect","保護する"],["hand","手"],["have","持っている"],["champion","優勝者"],["calendar","カレンダー"],["able","できる"]];break;;break;
    case "中学英語42" :item = [["website","ウェブサイト"],["horse","馬"],["message","伝言"],["customer","顧客"],["greeting","挨拶"],["business","ビジネス"],["cover","覆う"],["will","～するつもりである"],["most","最も"],["island","島"]];break;;break;
    case "中学英語43" :item = [["our","我々の"],["sharp","鋭い"],["hop","跳ぶ"],["your","あなたの"],["take","取る"],["player","選手"],["get","手に入れる"],["clock","時計"],["actor","俳優"],["solve","解く"]];break;;break;
    case "中学英語44" :item = [["nail","爪"],["change","変える"],["potato","ポテト"],["ring","指輪"],["fishing","釣り"],["journey","旅行"],["bring","持ってくる"],["toast","トースト"],["salt","塩"],["fat","太った"],];break;
    case "中学英語45" :item = [["all","全ての"],["had","haveの過去・過去分詞形"],["lion","ライオン"],["animal","動物"],["zero","ゼロ"],["bake","焼く"],["cycle","周期"],["daughter","娘"],["parent","親"],["classroom","教室"]];break;;break;
    case "中学英語46" :item = [["along","～に沿って"],["tell","話す"],["cheese","チーズ"],["notice","通知"],["blossom","開花"],["fit","適した"],["menu","メニュー"],["for","～のために"],["they","彼（彼女）らは"],["yourselves","あなた方自身"]];break;;break;
    case "中学英語47" :item = [["state","状態"],["convenience","便利さ"],["watch","見る"],["tree","木"],["anyone","だれか"],["shoulder","肩"],["clerk","販売員"],["then","その時"],["morning","朝"],["top","トップ"],];break;
    case "中学英語48" :item = [["medicine","薬"],["him","彼に"],["me","私に"],["thank","感謝する"],["person","人"],["them","彼らを"],["god","神"],["damage","損害"],["hot","熱い"],["test","試験"]];break;;break;
    case "中学英語49" :item = [["lily","ユリ"],["pass","通過する"],["rule","規則"],["mother","母"],["dish","皿"],["bowl","お椀"],["yet","まだ"],["agree","同意する"],["act","行動"],["tour","ツアー"]];break;;break;
    case "中学英語50" :item = [["usual","いつもの"],["why","理由"],["picnic","ピクニック"],["although","～だけれども"],["report","報告（書）"],["singer","歌手"],["career","職業"],["hope","希望"],["experience","経験"]];break;;break;
    case "中学英語51" :item = [["rise","上がる"],["narrow","狭い"],["impress","押印"],["guess","推測する"],["bye","さようなら"],["paint","絵の具"],["forget","忘れる"],["giant","巨人"],["spirit","精神"],["butter","バター"],];break;
    case "中学英語52" :item = [["importance","重要性"],["postcard","はがき"],["separate","分ける"],["German","ドイツ人"],["clear","澄んだ"],["necessary","必要な"],["he","彼は"],["between","～の間に"],["behind","～の後ろに"],["bridge","橋"]];break;;break;
    case "中学英語53" :item = [["herself","彼女自身"],["overseas","海外に "],["shampoo","シャンプー"],["invite","招待する"],["lady","女性"],["laugh","笑う"],["farmer","農場主"],["healthy","健康な"],["floor","床"],["bakery","パン屋さん"]];break;;break;
    case "中学英語54" :item = [["leave","去る"],["volleyball","バレーボール"],["out","外へ"],["track","路線"],["both","両方"],["again","再び"],["bamboo","竹"],["free","自由の"],["phone","電話"],["salad","サラダ"]];break;;break;
    case "中学英語55" :item = [["programmer","プログラマー"],["purpose","目的"],["football","フットボール"],["design","デザイン"],["news","ニュース"],["hate","憎む"],["north","北"],["excuse","許す"],["quickly","速く"],["sport","スポーツ"]];break;;break;
    case "中学英語56" :item = [["hamburger","ハンバーガー"],["attention","注意"],["resource","資源"],["trouble","困難"],["coach","コーチ"],["meter","メートル"],["sightseeing","観光"],["upset","ひっくり返す"],["road","道"],["million","100万"]];break;;break;
    case "中学英語57" :item = [["father","父"],["power","力"],["child","子供"],["rainy","雨降りの"],["ruler","物差し"],["gentlemen","紳士"],["every","すべての"],["Indian","北米インディアン"],["line","線"]];break;;break;
    case "中学英語58" :item = [["smart","利口な"],["eat","食べる"],["catch","捕まえる"],["uniform","同じ形の"],["rich","金持ちの"],["machine","機械"],["sky","空"],["life","人生"],["positive","明白な"],["friendship","友情"],];break;
    case "中学英語59" :item = [["break","壊す"],["lesson","授業"],["toy","おもちゃ"],["computer","コンピュータ"],["noon","正午"],["theirs","彼らのもの"],["usually","ふつうは"],["chew","噛む"],["rice","米"],["pumpkin","カボチャ"]];break;;break;
    case "中学英語60" :item = [["us","私たちを"],["decide","決定する"],["inside","内部"],["sightsee","見回る"],["tournament","トーナメント"],["activity","活動"],["sunshine","日光"],["present","現在"],["table","テーブル"]];break;;break;
    case "中学英語61" :item = [["Monday","月曜日"],["hit","打つ"],["storm","嵐"],["factory","工場"],["booth","仕切り席"],["last","最後の"],["accident","アクシデント"],["broke","壊れた"],["forward","前方の"],["wind","風"]];break;;break;
    case "中学英語62" :item = [["trip","旅"],["spot","地点"],["pilot","パイロット"],["railway","鉄道"],["attend","出席する"],["badly","悪く"],["scene","シーン"],["swim","泳ぐ"],["date","日付"],["science","科学"],["little","少しの"]];break;;break;
    case "中学英語63" :item = [["bury","埋葬"],["count","計算"],["continue","続く"],["stair","階段"],["Saturday","土曜日"],["notebook","ノート"],["government","政府"],["friendly","友好的な"],["success","成功"],["before","～の前に"],];break;
    case "中学英語64" :item = [["beside","～のそばに"],["wing","翼"],["actress","女優"],["luckily","幸運にも"],["silent","静かな"],["view","景色"],["kitchen","台所"],["add","加える"],["diary","日記"],["Thursday","木曜日"]];break;;break;
    case "中学英語65" :item = [["finally","ついに"],["key","鍵"],["who","誰"],["because","なぜなら"],["matter","事柄"],["milk","牛乳"],["newspaper","新聞"],["cry","泣く"],["today","今日"],["effort","努力"]];break;;break;
    case "中学英語66" :item = [["back","後"],["sheep","羊"],["piano","ピアノ"],["believe","信じる"],["meal","食事"],["brush","ブラシ"],["sad","悲しい"],["ocean","大洋"],["bell","ベル"],["other","他の"],];break;
    case "中学英語67" :item = [["keep","保つ"],["teacher","教師"],["food","食べ物"],["worker","働く人"],["must","必ず～"],["important","重要な"],["distance","距離"],["bug","虫"],["support","支え"],["wonder","驚き"]];break;;break;
    case "中学英語68" :item = [["young","若い"],["safely","安全に"],["put","置く"],["treasure","宝物"],["improve","改良する"],["soup","スープ"],["buy","買う"],["sure","確信している"],["color","色"],["air","空気"],];break;
    case "中学英語69" :item = [["especially","特に"],["safe","安全な"],["sing","歌う"],["loud","（音声が）大きい"],["brother","兄"],["pink","ピンク"],["bike","バイク"],["create","創造する"],["original","根源の"],["south","南"]];break;;break;
    case "中学英語70" :item = [["flavor","風味"],["walk","歩く"],["city","都市"],["together","いっしょに"],["hundred","100"],["comfortable","快適な"],["sweater","セーター"],["recycling","再生利用"],["find","見つける"],["lay","水平に置く"]];break;;break;
    case "中学英語71" :item = [["marry","結婚する"],["balcony","バルコニー"],["day","日"],["any","なにか"],["case","事例"],["shall","～しましょうか"],["from","～から"],["speak","話す"],["total","合計"],["grandparent","祖父母"]];break;;break;
    case "中学英語72" :item = [["panic","恐怖"],["draw","引く"],["known","知られている"],["movement","動くこと"],["there","そこ"],["expensive","高価な"],["hair","髪の毛"],["uncle","おじ"],["junior","年下の"],["stone","石"]];break;;break;
    case "中学英語73" :item = [["church","教会"],["holiday","休日"],["kangaroo","カンガルー"],["chance","好機"],["magazine","雑誌"],["surround","取り囲む"],["toward","～の方へ"],["trick","トリック"],["greet","あいさつする"],["smile","微笑む"]];break;;break;
    case "中学英語74" :item = [["sale","販売"],["stomach","胃"],["cloudy","曇った"],["many","多くの"],["suit","スーツ"],["Paralympics","パラリンピック"],["almost","ほとんど"],["each","それぞれの"],["end","終わり"],["stand","立つ"]];break;;break;
    case "中学英語75" :item = [["harvest","収穫"],["big","大きい"],["someday","いつか"],["tool","道具"],["lake","湖"],["else","そのほかの"],["racket","ラケット"],["performance","公演"],["remember","覚えておく"],["gym","体育館"],];break;
    case "中学英語76" :item = [["upset","ひっくり返す"],["fall","落ちる"],["turtle","海亀"],["compare","比較する"],["dessert","デザート"],["youth","若さ"],["festival","祝祭"],["aunt","おば"],["cooking","料理"],["great","偉大な"],];break;
    case "中学英語77" :item = [["police","警察"],["size","サイズ"],["toothbrush","歯ブラシ"],["such","そのような"],["part","一部"],["really","本当に"],["home","家"],["orchestra","オーケストラ"],["highland","高地"],["nursery","保育園"],];break;
    case "中学英語78" :item = [["language","言語"],["sleep","眠る"],["public","公共の"],["everybody","すべての人"],["originally","もともとは"],["depend","依存する"],["lemon","レモン"],["interview","面接"],["age","年齢"],["neighbor","隣人"]];break;;break;
    case "中学英語79" :item = [["fold","折る"],["pull","引く"],["mousetrap","鼠捕り"],["astronaut","宇宙飛行士"],["early","早い"],["kind","親切な"],["near","近い"],["hear","聞く"],["shock","衝撃"],["beef","牛肉"]];break;;break;
    case "中学英語80" :item = [["used","中古の"],["famous","有名な"],["around","～の周りに"],["brave","勇敢な"],["platform","プラットホーム"],["luck","運"],["decision","決定"],["dear","親愛な"],["egg","卵"],["face","顔"]];break;;break;
    case "中学英語81" :item = [["few","わずかの"],["training","訓練"],["upon","～の上に"],["feeling","感じ"],["water","水"],["pollution","汚染"],["cook","料理する"],["window","窓"],["gram","グラム"],["program","プログラム"]];break;;break;
    case "中学英語82" :item = [["quiz","小テスト"],["spaghetti","スパゲティ"],["banana","バナナ"],["coat","コート"],["light","光"],["drugstore","ドラッグストア"],["sense","感覚"],["gather","集める"],["once","一度"]];break;;break;
    case "中学英語83" :item = [["homework","宿題"],["math","数学"],["dress","ドレス"],["chicken","ニワトリ"],["like","好む"],["brown","茶色"],["quite","かなり"],["order","順序"],["interesting","興味深い"],["Friday","金曜日"],];break;
    case "中学英語84" :item = [["smell","臭いがする"],["personal","個人の"],["apple","リンゴ"],["elbow","ひじ"],["bear","クマ"],["borrow","借りる"],["bed","ベッド"],["weekend","週末"],["Europe","ヨーロッパ"],];break;
    case "中学英語85" :item = [["salesclerk","店員"],["touch","触れる"],["supermarket","スーパーマーケット"],["black","黒"],["game","遊び"],["dangerous","危険な"],["move","動く"],["anything","何も"],["situation","状況"]];break;;break;
    case "中学英語86" :item = [["worried","心配そうな"],["fashion","流行"],["burn","燃える"],["dollar","ドル"],["clothes","衣類"],["live","生中継の"],["summer","夏"],["bookstore","本屋"],["college","大学"],["land","陸"]];break;;break;
    case "中学英語87" :item = [["cut","切る"],["unlock","錠を開ける"],["main","主要な"],["half","半分"],["lot","たくさん"],["wear","着る"],["village","村"],["anymore","もう～しない"],["anytime","いつでも"],["native","先住の"]];break;;break;
    case "中学英語88" :item = [["shake","振る"],["addition","付加"],["mirror","鏡"],["energy","エネルギー"],["bright","輝く"],["patient","患者"],["some","幾らかの"],["now","今"],["six","6"],["happy","幸せな"]];break;;break;
    case "中学英語89" :item = [["blind","盲目の"],["feel","感じる"],["research","調査"],["letter","手紙"],["fine","すばらしい"],["cloud","雲"],["jump","ジャンプ"],["entrance","入り口"],["collect","集める"],["gesture","ジェスチャー"],];break;
    case "中学英語90" :item = [["chocolate","チョコレート"],["aquarium","水族館"],["lunchtime","昼休み"],["above","～より上に"],["character","性格"],["address","住所"],["meeting","会議"],["away","離れて"],["begin","始める"],["plant","植物"]];break;;break;
    case "中学英語91" :item = [["let","～させる"],["choose","選ぶ"],["product","製品"],["adult","成人"],["perform","上演する"],["express","急行"],["injure","傷つける"],["certainly","確かに"],["canyon","峡谷"],["alarm","警報"]];break;;break;
    case "中学英語92" :item = [["octopus","タコ"],["thing","もの"],["hall","ホール"],["earthquake","地震"],["short","短い"],["see","見える"],["ticket","チケット"],["sunny","晴れた"],["difficulty","困難"],["stadium","競技場"]];break;;break;
    case "中学英語93" :item = [["vegetable","野菜"],["recycle","リサイクル"],["scare","恐怖"],["heavy","重い"],["headache","頭痛"],["tomorrow","明日"],["hotel","ホテル"],["artist","芸術家"],["you","あなた"],["this","これは"]];break;;break;
    case "中学英語94" :item = [["place","場所"],["grandmother","祖母"],["sandwich","サンドイッチ"],["zookeeper","飼育係"],["level","レベル"],["throw","投げる"],["taste","味"],["speech","話すこと"],["husband","夫"],["middle","中央の"]];break;;break;
    case "中学英語95" :item = [["international","国際的な"],["tourist","旅行者"],["hard","かたい"],["idea","アイデア"],["baby","赤ちゃん"],["nature","自然"],["sugar","砂糖"],["team","チーム"],["eraser","消しゴム"],["start","始める"]];break;;break;
    case "中学英語96" :item = [["grass","草"],["disappear","消える"],["exchange","交換"],["terrible","過酷な"],["cheap","安い"],["show","見せる"],["call","呼ぶ"],["cup","コップ"],["country","国"],["yesterday","昨日"]];break;;break;
    case "中学英語97" :item = [["pig","豚"],["common","よくある"],["dad","パパ"],["welcome","ようこそ"],["athlete","アスリート"],["spend","（金や時間を）使う"],["follow","続く"],["doctor","医師"],["thought","思考"],["beach","海浜"]];break;;break;
    case "中学英語98" :item = [["course","コース"],["gas","ガス"],["are","beの二人称"],["flag","旗"],["piece","一片"],["space","空間"],["later","より遅い"],["doll","人形"],["whale","クジラ"],["east","東"]];break;;break;
    case "中学英語99" :item = [["head","頭"],["natural","自然の"],["century","世紀"],["movie","映画"],["popular","人気のある"],["army","陸軍"],["tight","きつい"],["soft","柔らかい"],["round","丸い"],["tea","茶"]];break;;break;
    case "中学英語100" :item = [["if","もしも"],["book","本"],["skate","スケート"],["leg","脚"],["arm","腕"],["sign","印"],["special","スペシャル"],["finger","指"],["fun","楽しみ"],["discount","割引"],];break;
    case "中学英語101" :item = [["wedding","婚礼"],["sometime","いつか"],["project","計画"],["professional","職業の"],["noise","ノイズ"],["hero","ヒーロー"],["award","賞"],["funny","おかしい"],["serve","仕える"],["very","とても"],];break;
    case "中学英語102" :item = [["how","どうやって"],["garden","庭"],["electricity","電気"],["join","加わる"],["difficult","難しい"],["fan","ファン"],["breakfast","朝食"],["sun","太陽"],["sleepy","眠い"],["simple","単純な"]];break;;break;
    case "中学英語103" :item = [["hungry","お腹がすいた"],["different","異なる"],["twice","2度"],["story","物語"],["dog","犬"],["think","考える"],["possible","可能な"],["second","第２の"],["pay","払う"],["empty","空っぽの"]];break;;break;
    case "中学英語104" :item = [["scientist","科学者"],["passport","パスポート"],["yourself","あなた自身"],["shoe","靴"],["enemy","敵"],["already","既に"],["send","送る"],["successful","成功した"],["powerful","強い"],["increase","増加する"]];break;;break;
    case "中学英語105" :item = [["never","決して～ない"],["make","作る"],["bored","退屈した"],["imagine","想像する"],["control","制御する"],["human","人間"],["dark","闇"],["everywhere","どこにでも"],["shopping","買い物"],["real","本当の"]];break;;break;
    case "中学英語106" :item = [["engineer","エンジニア"],["helpful","助けになる"],["several","いくつかの"],["paper","紙"],["ring","指輪"],["ski","スキー"],["post","ポスト"],["want","欲する"],["does","do の三人称単数現在形"],["shoes","靴"]];break;;break;
    case "中学英語107" :item = [["sink","沈む"],["mouse","マウス"],["juice","ジュース"],["own","自分の"],["world","世界"],["vacation","休暇"],["refrigerator","冷蔵庫"],["longdistance","長距離"],["number","数"],["under","～の下に"],];break;
    case "中学英語108" :item = [["site","位置"],["exciting","刺激的な"],["slope","坂"],["reason","理由"],["box","箱"],["violin","バイオリン"],["built","造られた"],["cookie","クッキー"],["wrap","包む"],["effect","効果"]];break;;break;
    case "中学英語109" :item = [["detective","探偵"],["nurse","看護師"],["dentist","歯科医"],["anywhere","どこでも"],["yen","円"],["as","～として"],["overcome","克服する"],["sailor","船員"],["tail","尾"],["lovely","愛くるしい"]];break;;break;
    case "中学英語110" :item = [["money","金"],["plate","皿"],["noisy","うるさい"],["enter","入る"],["influence","影響"],["drum","ドラム"],["ahead","前に"],["joy","喜び"],["koala","コアラ"],["panda","パンダ"],];break;
    case "中学英語111" :item = [["next","次の"],["night","夜"],["meat","食肉"],["introduce","紹介する"],["small","小さい"],["work","仕事"],["large","大きい"],["during","～の間"],["cherry","サクランボ"],["fox","キツネ"]];break;;break;
    case "中学英語112" :item = [["mountain","山"],["cool","涼しい"],["pencil","えんぴつ"],["saw","seeの過去形"],["snow","雪"],["more","よりいっそう"],["pray","祈る"],["wet","ぬれた"],["system","システム"],["below","～より下に"],];break;
    case "中学英語113" :item = [["northern","北部の"],["stormy","嵐の"],["temple","寺院"],["kilometer","キロメートル"],["here","ここへ"],["much","多くの"],["belong","属する"],["shape","形"],["too","～もまた"],["yes","はい"]];break;;break;
    case "中学英語114" :item = [["board","板"],["global","地球上の"],["try","試す"],["communicate","交信する"],["give","与える"],["airplane","飛行機"],["since","～以来"],["surprising","驚くべき"],["fever","熱"],["travel","旅行"]];break;;break;
    case "中学英語115" :item = [["pizza","ピザ"],["among","(３つ以上の)間に"],["marker","マーカー"],["charity","慈善"],["poor","貧しい"],["careful","注意深い"],["painting","絵"],["pocket","ポケット"],["limit","限界"],["ball","ボール"],];break;
    case "中学英語116" :item = [["lie","うそ"],["difference","違い"],["which","どれ"],["tube","チューブ"],["spring","春"],["advice","アドバイス"],["fix","修理する"],["soldier","兵士"],["plastic","プラスチック"],["push","押す"]];break;;break;
    case "中学英語117" :item = [["bicycle","自転車"],["period","期間"],["Chinese","北京語"],["street","通り"],["health","健康"],["university","大学"],["step","階段"],["information","情報"],["ours","私たちのもの"],["soccer","サッカー"]];break;;break;
    case "中学英語118" :item = [["instead","代わりに"],["come","来る"],["yours","あなたのもの"],["won","winの過去・過去分詞形"],["match","試合"],["cafeteria","カフェテリア"],["guide","ガイド"],["far","遠くへ"],["practice","練習する"],["bomb","爆弾"],];break;
    case "中学英語119" :item = [["war","戦争"],["mom","お母さん"],["cap","帽子"],["invent","発明する"],["basket","バスケット"],["hurry","急ぐ"],["belt","ベルト"],["guy","男"],["western","西の"],["robot","ロボット"],];break;
    case "中学英語120" :item = [["interested","興味のある"],["wild","野生の"],["castle","城"],["interest","興味"],["picture","絵"],["cousin","いとこ"],["pet","ペット"],["tear","涙"],["volunteer","ボランティア"],["writer","作家"],];break;
    case "中学英語121" :item = [["circle","円"],["sit","座る"],["name","名前"],["snowy","雪の降る"],["hunter","狩人"],["refuse","拒む"],["connect","つながる"],["treat","扱う"],["single","ひとり"],["parade","行進"]];break;;break;
    case "中学英語122" :item = [["tower","タワー"],["moment","瞬間"],["theater","劇場"],["meaning","意味"],["serious","真剣な"],["fin","背びれ"],["sleigh","そり"],["stamp","切手"],["kill","殺す"],["third","3番目"]];break;;break;
    case "中学英語123" :item = [["just","正しい"],["hat","帽子"],["blow","吹く"],["publish","出版する"],["rescue","救助する"],["win","勝つ"],["minute","分"],["surf","波に乗る"],["front","最前部"],["weekday","平日"]];break;;break;
    case "中学英語124" :item = [["neck","首"],["open","開ける"],["often","しばしば"],["glove","手袋"],["sheet","シート"],["yellow","黄色"],["spider","クモ"],["camping","キャンプすること"],["Tuesday","火曜日"],["capital","首都"]];break;;break;
    case "中学英語125" :item = [["encourage","励ます"],["knock","ノック"],["schedule","スケジュール"],["boat","ボート"],["old","古い"],["anyway","とにかく"],["against","～に逆らって"],["waterfall","滝"],["slowly","ゆっくり"],];break;
    case "中学英語126" :item = [["ask","質問する"],["across","～を横切って"],["visitor","訪問者"],["something","何か"],["sick","病気の"],["return","戻る"],["visit","訪問する"],["baseball","野球"],["chorus","コーラス"],["biscuit","ビスケット"],];break;
    case "中学英語127" :item = [["role","役割"],["less","より小さい"],["voice","声"],["fight","戦い"],["cancer","がん"],["card","カード"],["tent","テント"],["loser","敗者"],["rose","バラ"],["gift","贈り物"],["season","季節"],];break;
    case "中学英語128" :item = [["over","～の上に"],["exam","試験"],["cake","ケーキ"],["hold","つかむ"],["eye","眼"],["mall","散歩道"],["set","セット"],["pain","痛み"],["tiger","トラ"],["people","人々"]];break;;break;
    case "中学英語129" :item = [["turn","回る"],["perhaps","たぶん"],["family","家族"],["bus","バス"],["restaurant","レストラン"],["kilogram","キログラム"],["style","スタイル"],["local","地元の"],["ever","これまでに"],["tonight","今夜"]];break;;break;
    case "中学英語130" :item = [["himself","彼自身"],["after","～のあとで"],["bad","悪い"],["log","丸太"],["realize","悟る"],["discussion","議論"],["grandpa","おじいちゃん"],["these","これらは"],["guitar","ギター"],["officer","役人"],];break;
    case "中学英語131" :item = [["group","グループ"],["center","中心"],["goodbye","さようなら"],["into","～の中に"],["farm","農場"],["generation","世代"],["tooth","歯"],["house","家"],["tie","結ぶ"],["drive","運転する"],];break;
    case "中学英語132" :item = [["up","上に"],["off","～から外れて"],["strange","奇妙な"],["fresh","新鮮な"],["waste","浪費する"],["national","国の"],["read","読む"],["cheer","喝采"],["foot","足"],["sweet","甘い"]];break;;break;
    case "中学英語133" :item = [["rain","雨"],["useful","役に立つ"],["hill","丘"],["help","助ける"],["drink","飲む"],["blue","青"],["with","～といっしょに"],["dry","乾燥した"],["history","歴史"],["score","得点"]];break;;break;
    case "中学英語134" :item = [["hobby","趣味"],["better","よりよい"],["build","建てる"],["where","どこ"],["ready","準備ができて"],["either","どちらか一方の"],["sell","売る"],["what","何"],["station","駅"],["video","ビデオ"]];break;;break;
    case "中学英語135" :item = [["do","する"],["gray","灰色の"],["umbrella","傘"],["kite","凧"],["friend","友人"],["windy","風の強い"],["winter","冬"],["still","静止した"],["mean","意味"],["myself","私自身"]];break;;break;
    case "中学英語136" :item = [["wife","妻"],["always","いつも"],["warm","暖かい"],["green","緑"],["wake","目が覚める"],["coffee","コーヒー"],["shop","小売店"],["costume","衣装"],["stove","ストーブ"],["everyone","すべての人"]];break;;break;
    case "中学英語137" :item = [["song","歌"],["way","道"],["man","男性"],["lucky","幸運な"],["pharmacist","薬剤師"],["rock","岩"],["river","川"],["town","町"],["nice","良い"],["nothing","何も～ない"]];break;;break;
    case "中学英語138" :item = [["silver","銀"],["art","芸術"],["technology","科学技術"],["billion","（米国で）１０億"],["outside","外側"],["future","未来"],["branch","枝"],["clock","時計"],["recipe","レシピ"],["shout","叫ぶ"]];break;;break;
    case "中学英語139" :item = [["stomachache","腹痛"],["their","彼らの"],["drop","しずく"],["gentleman","紳士"],["final","最後の"],["peace","平和"],["stop","止まる"],["concert","コンサート"],["wall","壁"],["straight","まっすぐな"],];break;
    case "中学英語140" :item = [["fact","事実"],["zoo","動物園"],["building","建物"],["maybe","もしかすると"],["quick","動きの速い"],["know","知っている"],["afraid","恐れて"],["glad","よろこんで"],["only","唯一の"],["environment","環境"]];break;;break;
    case "中学英語141" :item = [["fridge","冷蔵庫"],["opinion","意見"],["reuse","再利用"],["busy","忙しい"],["tired","疲れた"],["toe","足指"],["nose","鼻"],["whole","全部"],["traffic","交通"],["cause","原因"],];break;
//
    case "高校英語1" :item = [["primarily","第一に"],["powerhouse","発電所"],["jumper","ジャンプする人"],["attorney","弁護士"],["construction","建設"],["prestige","威信"],["competition","競争"],["discourage","失望させる"],["guy","男"],["summit","頂上"]];break;;break;
    case "高校英語2" :item = [["industrialize","工業化する"],["filter","フィルタ"],["infrastructure","基盤"],["pence","ペンス"],["grim","気味の悪い"],["airmail","航空郵便"],["transplant","移植"],["gangster","ギャング"],["erupt","噴出する"],["tribe","部族"],];break;
    case "高校英語3" :item = [["indeed","実に"],["opportunity","機会"],["gloomy","暗い"],["seek","探し求める"],["erect","垂直の"],["adolescent","思春期の"],["clause","文節"],["contradict","～と矛盾する"],["columnist","コラムニスト"],["sustain","維持する"]];break;;break;
    case "高校英語4" :item = [["criticize","批判する"],["impact","影響"],["radioactive","放射性の"],["vow","誓い"],["straightforward","まっすぐな"],["outgoing","出ていく"],["foundation","基盤"],["clinical","臨床の"],["environmentalist","環境活動家"],["reaction","反応"],];break;
    case "高校英語5" :item = [["attitude","態度"],["instruction","教え"],["feature","特徴"],["appropriate","適した"],["harmful","有害な"],["whisper","ささやく"],["southern","南の"],["access","行く方法"],["function","機能"],["gallery","画廊"],];break;
    case "高校英語6" :item = [["hardship","苦難"],["endangered","危険にさらされた"],["dimension","次元"],["barely","かろうじて"],["faithful","忠実な"],["recession","景気後退"],["neutral","中立"],["basis","基礎"],["classification","分類"],["spectacular","壮観な"]];break;;break;
    case "高校英語7" :item = [["infect","感染させる"],["superpower","超大国"],["linguistic","言語の"],["aid","援助"],["timid","気の小さい"],["stubborn","頑固な"],["accordingly","それに沿って"],["limitation","制限"],["astronomer","天文学者"],["enable","可能にする"],];break;
    case "高校英語8" :item = [["integrate","統合する"],["partial","一部の"],["operation","操作"],["regarding","～に関して"],["horizontal","水平な"],["migrate","移住する"],["leftover","残り物"],["shallow","浅い"],["absurd","ばかげた"],["admit","許す"],];break;
    case "高校英語9" :item = [["unfortunately","不幸にも"],["admission","入場許可"],["shocked","衝撃を受けた"],["determine","決定する"],["equipment","備品"],["bang","ぶつける"],["spin","回転"],["ballot","投票"],["seaside","海辺"],["completion","完了"],];break;
    case "高校英語10" :item = [["rehearsal","リハーサル"],["shuttle","シャトル"],["basically","基本的に"],["anticipate","予想する"],["escalator","エスカレーター"],["inhabitant","居住者"],["peacefully","平和的に"],["province","州"],["affiliate","支部"],["graze","草を食う"],];break;
    case "高校英語11" :item = [["characteristic","特徴"],["creature","生物"],["entry","入場"],["imitate","～を模倣する"],["register","登録"],["perceive","気づく"],["clothing","衣類"],["indoor","屋内の"],["loose","緩み"],["pale","青白い"],];break;
    case "高校英語12" :item = [["production","生産"],["major","重要な"],["independent","独立した"],["avoid","避ける"],["ceremony","儀式"],["ideal","理想"],["rare","めったにない"],["eventually","結局は"],["lunchtime","昼休み"],["garbage","ごみ"],];break;
    case "高校英語13" :item = [["sector","部門"],["concrete","具体的な"],["revenue","収入"],["malnutrition","栄養失調"],["ultimately","最終的に"],["prominent","目立った"],["suspend","吊るす"],["hazard","危険"],["assessment","評価"],["spark","火花"]];break;;break;
    case "高校英語14" :item = [["spite","悪意"],["unauthorized","権限のない"],["eternity","永遠"],["absolutely","絶対に"],["assorted","分類した"],["consumer","消費者"],["pastime","娯楽"],["gleam","かすかに光る"],["empathy","感情移入"],["dependency","依存"],];break;
    case "高校英語15" :item = [["discomfort","不快"],["overlap","重ねる"],["venture","思い切ってやる"],["claw","かぎ爪"],["feast","祝宴"],["tame","飼いならされた"],["scope","範囲"],["turbulence","乱気流"],["achieve","達成する"],["disagree","同意しない"]];break;;break;
    case "高校英語16" :item = [["salmon","鮭"],["widespread","広げた"],["significance","意味"],["tackle","タックル"],["sequence","連鎖"],["moderate","穏やかな"],["acknowledge","認める"],["instruct","～に指示する"],["fireworks","花火"],["attentive","注意深い"]];break;;break;
    case "高校英語17" :item = [["killer","殺人者"],["continent","大陸"],["stereotypical","型にはまった"],["climate","気候"],["chemical","化学の"],["ancient","古代の"],["display","表示"],["resume","再開する"],["sensation","感覚"],["acting","行為"]];break;;break;
    case "高校英語18" :item = [["structure","構造"],["expand","大きくなる"],["data","データ"],["concern","関係する"],["typical","典型的な"],["credit","信用"],["cancel","取り消す"],["honor","名誉"],["disturb","じゃまをする"],["spill","こぼれる"]];break;;break;
    case "高校英語19" :item = [["supervise","監督する"],["hip","臀部"],["fragment","破片"],["elsewhere","他の場所に"],["hasty","急ぎの"],["immerse","浸す"],["confine","限定する"],["truly","真に"],["bound","縛られた"],["startle","びっくりさせる"],];break;
    case "高校英語20" :item = [["decline","断る"],["geometry","幾何学"],["nominate","指名する"],["oversee","監督する"],["snatch","ひったくる"],["phase","局面"],["slant","傾く"],["curriculum","カリキュラム"],["enrage","激怒させる"],["buyer","買い手"],];break;
    case "高校英語21" :item = [["substantial","かなりの"],["scheme","計画"],["approximately","だいたい"],["gender","性別"],["nerve","神経"],["illustrate","図解する"],["overdo","やり過ぎる"],["colored","色のついた"],["extinct","絶滅した"],["preference","好み"]];break;;break;
    case "高校英語22" :item = [["plead","嘆願する"],["acoustic","アコースティック"],["distort","～をゆがめる"],["acute","激しい"],["transmit","送る"],["missing","行方不明の"],["trait","特徴"],["presumably","多分"],["verse","詩"],["overly","過度に"],];break;
    case "高校英語23" :item = [["vice","悪徳"],["invest","投資する"],["luxury","ぜいたく"],["apparent","見かけの"],["logic","論理"],["distribute","分配する"],["thrill","スリル"],["orbit","軌道"],["aggressive","攻撃的な"],["atom","原子"]];break;;break;
    case "高校英語24" :item = [["perception","知覚"],["exceed","限界を越える"],["recognition","承認"],["indicate","指し示す"],["northern","北部の"],["rotate","回転する"],["stress","圧迫"],["stumble","つまずく"],["transport","輸送"],["fellow","仲間"]];break;;break;
    case "高校英語25" :item = [["description","記述"],["authorize","認定する"],["inner","内部の"],["combination","組み合わせ"],["exploit","功績"],["browse","閲覧する"],["unclear","不明な"],["betray","裏切る"],["riddle","謎"],["operational","運用上の"],];break;
    case "高校英語26" :item = [["quit","やめる"],["guideline","ガイドライン"],["criminal","犯罪の"],["explorer","探検家"],["vitality","活力"],["envision","心に描く"],["household","世帯"],["dramatic","劇的な"],["evolve","進化する"],["league","リーグ"],];break;
    case "高校英語27" :item = [["pesticide","農薬"],["console","慰める"],["county","郡"],["fierce","どう猛な"],["scrap","スクラップ"],["grind","砕く"],["distinguished","目立つ"],["consent","同意"],["clip","切り抜き"],["escalate","段階的に拡大する"],["hospitality","もてなし"]];break;;break;
    case "高校英語28" :item = [["legal","法律の"],["evidence","証拠"],["specialize","専門とする "],["improper","不適切な"],["certify","証明する"],["replicate","複製する"],["endorse","署名する"],["fasten","しっかり固定する"],["calculate","計算する"],["assign","任命する"]];break;;break;
    case "高校英語29" :item = [["muscle","筋肉"],["statement","声明"],["dinosaur","恐竜"],["affair","出来事"],["connection","つながり"],["cave","洞くつ"],["consensus","合意"],["numerous","多数の"],["sweep","掃く"],["sue","訴える"],];break;
    case "高校英語30" :item = [["means","手段"],["overwhelm","圧倒する"],["veterinarian","獣医"],["disrupt","崩壊させる"],["participant","参加者"],["pilgrim","巡礼者"],["terrorist","テロリスト"],["inferior","劣った"],["flock","群れ"],["noticeable","目立つ"]];break;;break;
    case "高校英語31" :item = [["cheaply","安く"],["psychologist","心理学者"],["eagerly","熱心に"],["historical","歴史上の"],["sacrifice","いけにえ"],["monitor","モニター"],["tension","張ること"],["unlucky","不運な"],["transform","変形させる"],["commit","犯す"],];break;
    case "高校英語32" :item = [["tornado","竜巻"],["motion","動き"],["bureau","事務局"],["obey","従う"],["relief","安心"],["bacteria","細菌"],["heal","治す"],["ecosystem","生態系"],["compromise","妥協"],["refugee","難民"],];break;
    case "高校英語33" :item = [["drawing","線描"],["suspect","～を疑う"],["oppose","反対する"],["principle","原則"],["importantly","重要なことに"],["remote","遠い"],["trash","ごみ"],["predict","予測する"],["desire","願う"],["supply","供給"],];break;
    case "高校英語34" :item = [["collapse","崩壊する"],["embarrass","困惑させる"],["outback","奥地"],["particle","粒子"],["folder","フォルダ"],["laboratory","実験室"],["depart","出発する"],["commercial","商業の"],["agriculture","農業"],["childhood","子供時代"]];break;;break;
    case "高校英語35" :item = [["efficient","効率的な"],["philosophy","哲学"],["grant","与える"],["bilingual","バイリンガル"],["expense","費用"],["install","インストールする"],["occasionally","時々"],["advertisement","広告"],["abandon","見捨てる"],["extraordinary","異常な"]];break;;break;
    case "高校英語36" :item = [["yell","わめく"],["cure","治療"],["fancy","空想"],["property","財産"],["grill","直火で焼く"],["moreover","さらに"],["carve","刻む"],["flour","粉末"],["enormous","莫大な"],["insurance","保険"]];break;;break;
    case "高校英語37" :item = [["scramble","スクランブル"],["observation","観察"],["cater","料理を調達する"],["particularly","特に"],["cease","終わる"],["vanish","消える"],["overturn","ひっくり返す"],["conquer","征服する"],["negotiate","交渉する"],["economical","経済的な"],];break;
    case "高校英語38" :item = [["split","分割する"],["delicate","デリケートな"],["session","セッション"],["careless","不注意な"],["invention","発明"],["consume","消費する"],["spicy","辛い"],["plug","プラグ"],["regional","地域の"],["wound","傷"]];break;;break;
    case "高校英語39" :item = [["debt","借金"],["urge","衝動"],["unhealthy","不健康な"],["advanced","前進した"],["absorb","吸収する"],["urban","都会の"],["chemistry","化学"],["minority","少数"],["blank","空白"],["orchestra","オーケストラ"],];break;
    case "高校英語40" :item = [["unlike","似ていない"],["uncover","暴露する"],["suggestion","提案"],["exclusive","排他的な"],["largely","大部分は"],["outsider","部外者"],["alert","警報"],["psychology","心理学"],["reluctant","消極的な"],["weapon","武器"]];break;;break;
    case "高校英語41" :item = [["accord","一致する"],["scan","スキャン"],["convert","変わる"],["smash","粉砕する"],["finance","金融"],["deprive","奪う"],["postpone","延期する"],["entrepreneur","起業家"],["assault","猛攻撃"],["concept","概念"]];break;;break;
    case "高校英語42" :item = [["explanation","説明"],["audio","オーディオ"],["extra","余分な"],["contact","接触"],["proportion","割合"],["persuade","説得する"],["eliminate","除く"],["definitely","明確に"],["surgery","手術"],["emerge","浮かび出る"],];break;
    case "高校英語43" :item = [["offend","感情を害する"],["mental","心の"],["parking","駐車場"],["vehicle","輸送手段"],["mayor","市長"],["define","定義する"],["nowadays","最近は"],["response","応答"],["mushroom","キノコ"],["frighten","怖がらせる"]];break;;break;
    case "高校英語44" :item = [["corporation","会社"],["code","法典"],["radical","根本的な"],["chairman","議長"],["string","ひも"],["troublesome","面倒な"],["retailer","小売商人"],["unit","ユニット"],["moisture","水分"],["developer","開発者"]];break;;break;
    case "高校英語45" :item = [["deposit","預ける"],["entertainment","楽しみ"],["shorten","短縮する"],["awareness","気づき"],["endure","耐える"],["aluminum","アルミニウム"],["stressed","ストレスのある"],["necessity","必要"],["opponent","敵"],["fiber","繊維"]];break;;break;
    case "高校英語46" :item = [["secondhand","中古の"],["administration","管理"],["political","政治の"],["retain","保有する"],["enforce","施行する"],["acid","酸"],["poll","世論調査"],["accept","受け入れる"],["beg","請う"],["quote","引用する"],];break;
    case "高校英語47" :item = [["nearby","すぐ近くの"],["employee","従業員"],["survey","調査"],["senior","年上の"],["whenever","いつでも"],["automatically","自動的に"],["enthusiastic","熱心な"],["massive","とても大きな"],["bounce","弾む"],["cop","警官"]];break;;break;
    case "高校英語48" :item = [["landmark","陸標"],["enhance","増強する"],["pottery","陶器"],["admiration","賞賛"],["totally","全く"],["coincidence","一致"],["sophisticated","洗練された"],["endanger","危険にさらす"],["knowledgeable","博識な"],["involve","含む"]];break;;break;
    case "高校英語49" :item = [["license","免許"],["currently","現在は"],["chase","追いかける"],["additional","付加的な"],["theme","テーマ"],["theory","理論"],["security","安全性"],["somehow","なんとかして"],["pressure","圧力"],["background","背景"],];break;
    case "高校英語50" :item = [["archive","記録保管所"],["dazzle","キラキラ光る"],["recess","休会"],["skyscraper","超高層ビル"],["botanical","植物の"],["sincerity","誠意"],["typically","典型的に"],["foggy","霧がかかった"],["restrain","抑制する"],["respondent","回答者"]];break;;break;
    case "高校英語51" :item = [["representative","代表"],["threat","脅し"],["religious","宗教の"],["bore","退屈なこと"],["accidentally","偶然に"],["extreme","極端な"],["revolution","革命"],["researcher","調査員"],["exaggerate","誇張する"],["motivation","動機"],];break;
    case "高校英語52" :item = [["require","必要とする"],["establish","設立する"],["screen","スクリーン"],["consider","熟考する"],["organize","組織化する"],["argue","論争する"],["chip","かけら"],["correctly","正しく"],["fiction","フィクション"],["confidence","信用"]];break;;break;
    case "高校英語53" :item = [["alliance","同盟"],["bookcase","ブックケース"],["assumption","仮定"],["grave","墓"],["scar","傷跡"],["regret","後悔"],["submit","服従する"],["disc","ディスク"],["complicate","複雑な"],["deceptive","当てにならない"],];break;
    case "高校英語54" :item = [["restore","元の状態に戻す"],["rub","摩擦"],["fingerprint","指紋"],["nonetheless","にもかかわらず"],["aboriginal","先住民の"],["architect","建築家"],["appetite","食欲"],["alien","宇宙人"],["negotiation","交渉"],["exhibit","展示"]];break;;break;
    case "高校英語55" :item = [["implement","実行する"],["boom","ブーム"],["homesick","ホームシック"],["mostly","主に"],["recall","思い出す"],["temper","気分"],["failure","失敗"],["precisely","正確に"],["competitive","競争の"],["squeeze","絞る"]];break;;break;
    case "高校英語56" :item = [["column","柱"],["toothache","歯痛"],["hospitalization","入院"],["bulldozer","ブルドーザー"],["electron","電子"],["due","～することになっている"],["behavior","ふるまい"],["weekday","平日"],["concentrate","集中する"],["suppose","仮定する"],];break;
    case "高校英語57" :item = [["redundant","冗長な"],["coordinate","同等の"],["impair","損なう"],["cherish","大事にする"],["region","地域"],["scale","尺度"],["applicant","志願者"],["agreement","同意"],["swarm","昆虫の群れ"],["disorder","無秩序"]];break;;break;
    case "高校英語58" :item = [["qualify","資格を与える"],["activist","活動家"],["nicely","うまく"],["category","カテゴリー"],["perfume","香水"],["crisis","危機"],["dump","どさりと下ろす"],["primitive","原始の"],["funeral","葬儀"],["tighten","引き締める"]];break;;break;
    case "高校英語59" :item = [["pretend","～のふりをする"],["quantity","量"],["summary","要約"],["meanwhile","その間に"],["separately","別々に"],["physics","物理学"],["substitute","代理人"],["pollute","汚染する"],["transportation","輸送"],["tourism","観光"]];break;;break;
    case "高校英語60" :item = [["fame","名声"],["confess","告白する"],["entertainer","エンターテイナー"],["ambiguous","あいまいな"],["election","選挙"],["negate","否定する"],["checkup","検査"],["controversy","論争"],["technical","技術上の"],["divert","～をそらす"]];break;;break;
    case "高校英語61" :item = [["poverty","貧乏"],["range","範囲"],["marathon","マラソン"],["obvious","明らかな"],["editor","編集者"],["revise","改訂する"],["vague","あいまいな"],["justify","正当化する"],["pastry","ペストリー"],["shift","交代"]];break;;break;
    case "高校英語62" :item = [["thorough","徹底的な "],["adore","崇拝する"],["personality","性格"],["subtract","引き算"],["enterprise","企業"],["talent","才能"],["insight","洞察力"],["intelligence","知能"],["promotion","昇進"],["concerned","関係している"]];break;;break;
    case "高校英語63" :item = [["initiate","始める"],["inscription","碑文"],["highway","高速道路"],["guilty","有罪の"],["relate","関連づける"],["battery","電池"],["horizon","水平線"],["huge","非常に大きい"],["properly","適切に"],["quality","品質"],];break;
    case "高校英語64" :item = [["silently","静かに"],["acquire","獲得する"],["bloom","開花"],["device","考案物"],["overall","全体の"],["radish","大根"],["purchase","購入"],["membership","会員資格"],["cruise","船旅をする"],["accomplish","達成する"],];break;
    case "高校英語65" :item = [["disappoint","失望させる"],["relative","相対的な"],["fragile","壊れやすい"],["motivate","動機づける"],["dignity","威厳"],["intake","摂取"],["visa","ビザ"],["bid","入札"],["tap","軽く打つ"],["producer","プロデューサー"]];break;;break;
    case "高校英語66" :item = [["classify","分類する"],["intensive","集中的な"],["accommodation","適応"],["development","発展"],["concerning","～に関して"],["paralyze","麻痺させる"],["seldom","めったに～しない"],["closet","物置"],["salon","大広間"],["edition","版"]];break;;break;
    case "高校英語67" :item = [["occur","起こる"],["prevail","勝つ"],["discriminate","差別する"],["forthcoming","来たる"],["atomic","原子の"],["lane","レーン"],["leisure","余暇"],["investment","投資"],["advertise","広告する"],["media","メディア"],];break;
    case "高校英語68" :item = [["instructor","インストラクター"],["deer","鹿"],["burden","重荷"],["delight","たのしみ"],["greenhouse","温室"],["bleed","出血"],["vast","広大な"],["novel","小説"],["recognize","見分ける"],["sample","サンプル"],];break;
    case "高校英語69" :item = [["precise","正確な"],["network","ネットワーク"],["associate","仲間"],["surface","表面"],["alternative","代替の"],["conduct","行為"],["accuse","責める"],["angle","角"],["conflict","衝突"],["bother","悩ます"],];break;
    case "高校英語70" :item = [["author","作者"],["bet","賭ける"],["reproduce","再現する"],["amaze","びっくりさせる"],["scratch","ひっかく"],["intense","強烈な"],["relatively","比較的に"],["territory","領土"],["jar","瓶"],["jealous","嫉妬深い"],];break;
    case "高校英語71" :item = [["countryside","片田舎"],["mall","散歩道"],["scary","怖い"],["electronic","電子の"],["trend","風潮"],["unlikely","ありそうもない"],["wisdom","知恵"],["dehydration","脱水"],["upbringing","養育"],["debit","借り方"],];break;
    case "高校英語72" :item = [["singular","単数形"],["widely","広く"],["protective","保護的な"],["mutual","互いの"],["surrender","降伏する"],["exhibition","展示"],["worsen","悪化させる"],["suspicious","疑わしい"],["association","組合"],["extensive","広大な"],];break;
    case "高校英語73" :item = [["embrace","抱擁する"],["relegate","格下げする"],["forum","フォーラム"],["introduction","導入"],["demolish","破壊する"],["screw","ねじ"],["comparable","匹敵する"],["comprise","〜を含む"],["dread","心配"],["convey","伝達する"],];break;
    case "高校英語74" :item = [["military","軍隊"],["release","解放する"],["flavor","風味"],["digital","デジタル"],["tempt","誘惑する"],["driving","運転"],["script","脚本"],["remarkable","並外れた"],["seasonal","季節の"],["assess","評価する"],];break;
    case "高校英語75" :item = [["innovation","革新"],["roam","歩き回る"],["boundary","境界"],["narrative","物語"],["accuracy","正確さ"],["inhabit","住む"],["evergreen","常緑の"],["mixture","混合"],["applause","拍手喝采"],["starve","飢える"],];break;
    case "高校英語76" :item = [["alter","変える"],["extinction","絶滅"],["reference","参照"],["economic","経済の"],["biological","生物学の"],["discipline","規律"],["boost","引き上げる "],["scent","香り"],["conference","会議"],["sore","痛い"],];break;
    case "高校英語77" :item = [["impressive","印象的な"],["humid","湿った"],["bewilder","当惑させる"],["heavily","重く"],["celebrity","有名人"],["displace","移動させる"],["stack","積み重ね"],["cultural","文化の"],["mainstream","主流"],["thriller","怪奇も"],];break;
    case "高校英語78" :item = [["sunglasses","サングラス"],["insert","～を挿入する"],["draft","草稿"],["file","ファイル"],["dioxide","二酸化物"],["peculiar","奇妙な"],["formulate","策定する"],["merit","長所"],["mode","様式"],["applaud","称賛する"],];break;
    case "高校英語79" :item = [["operate","作動する"],["grab","つかむ"],["debate","討論"],["economy","節約"],["emergency","緊急事態"],["classical","古典の"],["jewelry","宝石類"],["factor","要素"],["adapt","適応させる"],["shortage","不足"],];break;
    case "高校英語80" :item = [["technician","技術者"],["informal","気楽な"],["instantly","すぐに"],["dismiss","解散する"],["dedicate","ささげる"],["misunderstanding","誤解"],["cruel","残酷な"],["criticism","批評"],["backer","後援者"],["discrimination","差別"],];break;
    case "高校英語81" :item = [["distinction","区別"],["chat","おしゃべりする"],["reverse","逆の"],["colleague","同僚"],["capable","有能な"],["volume","体積"],["entertain","もてなす"],["contract","契約"],["justice","正義"],["interrupt","邪魔をする"],];break;
    case "高校英語82" :item = [["showdown","対決"],["takeoff","離陸"],["clone","クローン"],["concede","認める"],["comprehensive","理解力のある"],["beneficial","有益な"],["prescribe","処方する"],["humble","謙虚な"],["coalition","連合"],["colonize","植民地化する"],];break;
    case "高校英語83" :item = [["assume","仮定する"],["employ","雇う"],["satisfy","満足させる"],["excerpt","抜粋"],["rarely","めったに〜しない"],["fund","資金"],["document","書類"],["increasingly","ますます"],["planner","計画者"],["source","源"],];break;
    case "高校英語84" :item = [["awkward","不器用な"],["shatter","粉々にする"],["vaccine","ワクチン"],["cautious","注意深い"],["adviser","アドバイザー"],["expertise","専門知識"],["obligation","義務"],["illusion","思い違い"],["crawl","はう"],["profile","プロフィール"],];break;
    case "高校英語85" :item = [["divorce","離婚"],["resign","辞める"],["certificate","証明書"],["growth","成長"],["crucial","決定的な"],["partner","相棒"],["spacecraft","宇宙船"],["legend","伝説"],["controversial","物議を醸す"],["temporary","一時的な"],];break;
    case "高校英語86" :item = [["modernization","近代化"],["dilemma","ジレンマ"],["grip","握ること"],["stern","厳格な"],["duplicate","複製する"],["prosecute","起訴する"],["perfectly","完全に"],["creep","はう"],["fraud","詐欺"],["generosity","気前の良さ"],];break;
    case "高校英語87" :item = [["anytime","いつでも"],["complaint","苦情"],["derive","引き出す"],["spoil","だめにする"],["compose","構成する"],["thankful","感謝している"],["corridor","廊下"],["conservation","保護"],["satellite","衛星"],["scholar","学者"],];break;
    case "高校英語88" :item = [["underwater","水中の"],["arctic","北極の"],["fluid","流体"],["commemorate","記念する"],["transparent","透明な"],["eruption","噴火"],["ugly","醜い"],["repay","返済する"],["united","結ばれた"],["budget","予算"],];break;
    case "高校英語89" :item = [["throughout","全体に"],["ignorance","無知"],["diminish","縮小する"],["hypertension","高血圧"],["concession","譲歩"],["penetrate","突き抜ける"],["hail","あられ"],["collecting","収集"],["lethal","致命的な"],["illegal","非合法の"],];break;
    case "高校英語90" :item = [["canoe","カヌー"],["grocery","食料品"],["acquaintance","知人"],["selfish","利己的な"],["interact","相互に作用する"],["settlement","調停"],["unexpected","予期しない"],["chore","雑用"],["physician","内科医"],["forth","前方へ"],];break;
    case "高校英語91" :item = [["generate","発生させる"],["severe","シビアな"],["guarantee","保証"],["proficient","熟練した"],["innermost","最奥"],["invisible","目に見えない"],["vivid","色鮮やかな"],["intersection","交差点"],["productivity","生産性"],["obstacle","障害（物"],];break;
    case "高校英語92" :item = [["bookshelf","本棚"],["tuition","授業料"],["flu","インフルエンザ"],["anthropologist","人類学者"],["tablespoon","テーブルスプーン"],["groundwater","地下水"],["trivial","ささいな"],["arrogant","横柄な"],["relax","リラックスする"],["review","再調査する"],];break;
    case "高校英語93" :item = [["retail","小売り"],["seize","つかむ"],["vacant","空の"],["spectator","観客"],["overlook","見過ごす"],["initiative","主導権"],["union","結合"],["organism","有機体"],["welfare","福祉"],["fulfill","実行する"],];break;
    case "高校英語94" :item = [["studio","仕事場"],["literature","文学"],["negative","否定的な"],["cell","細胞"],["questionnaire","アンケート"],["contemporary","同時代の"],["institution","協会"],["tend","傾向がある"],["millionaire","百万長者"],["surrounding","周囲のもの"],];break;
    case "高校英語95" :item = [["famine","飢餓"],["meditate","瞑想する"],["extent","広さ"],["babysit","子守をする"],["asset","財産"],["statistics","統計"],["diplomat","外交官"],["shelter","シェルター"],["trigger","引き金"],["addiction","中毒"],];break;
    case "高校英語96" :item = [["exotic","外来の"],["intrude","侵入する"],["reputation","評判"],["investigate","研究する"],["creativity","創造性"],["rural","田舎の"],["announcement","発表"],["rely","信頼する"],["atmosphere","空気"],["extend","伸びる"],];break;
    case "高校英語97" :item = [["internal","内部の"],["magnify","拡大する"],["slavery","奴隷制度"],["additive","付加する"],["cooker","調理器具"],["segment","部分"],["revive","復活する"],["ecology","生態学"],["modest","謙虚な"],["buildup","増強"],];break;
    case "高校英語98" :item = [["romantic","ロマンチック"],["authority","権威"],["lower","下位の"],["initially","最初は"],["rebuild","再構築する"],["resemble","似ている"],["bald","はげた"],["catastrophe","大惨事"],["smuggle","密輸する"],["decent","まともな"],];break;
    case "高校英語99" :item = [["coupon","クーポン"],["restrict","制限する"],["solo","ソロ"],["soil","土壌"],["contrast","対比"],["consequence","結果"],["facility","施設"],["anxiety","不安"],["commonly","普通に"],["hesitate","ためらう"],];break;
    case "高校英語100" :item = [["literally","文字どおりに"],["contaminate","汚染する"],["vision","視覚"],["motive","動機"],["stance","立場"],["complex","複合の"],["argument","議論"],["hint","ヒント"],["shelf","棚"],["confuse","困惑させる"],];break;
    case "高校英語101" :item = [["affectionate","愛情深い"],["modify","修正する"],["personnel","人員"],["implant","移植する"],["inquiry","問い合わせ"],["infant","幼児"],["rating","格付け"],["haunt","出没する"],["behavioral","行動の"],["recruit","採用する"],];break;
    case "高校英語102" :item = [["ban","禁止"],["clue","手掛かり"],["jumbo","特大の"],["wealthy","裕福な"],["intention","意図"],["mission","任務"],["layer","層"],["fur","毛皮"],["considerable","かなりの"],["eagle","ワシ"],];break;
    case "高校英語103" :item = [["extract","引き抜く"],["agonize","苦しむ"],["bind","縛るもの"],["principal","主な"],["vomit","嘔吐"],["refer","言及する"],["insist","強く主張する"],["manual","手の"],["withdraw","退く"],["cassette","カセット"],];break;
    case "高校英語104" :item = [["version","版"],["threaten","脅す"],["pal","仲間"],["campaign","選挙運動"],["attractive","引きつける"],["enjoyable","楽しめる"],["stare","じっと見つめる"],["horror","ホラーの"],["command","命ずる"],["receipt","領収書"],];break;
    case "高校英語105" :item = [["fitness","適合"],["domestic","家庭の"],["cough","せき"],["recording","録音"],["resolve","決心"],["strategy","戦略"],["possess","所有する"],["client","クライアント"],["minimum","最小の"],["immigrant","移民"]];break;;break;
    case "高校英語106" :item = [["mainly","主に"],["current","現在の"],["librarian","司書"],["ensure","保証する"],["entire","全体の"],["newscaster","ニュースキャスター"],["distract","気をそらす"],["utility","実用性"],["rewrite","書き直す"],["coherent","互いに密着する"],];break;
    case "高校英語107" :item = [["deliberate","入念な"],["ignition","点火"],["distinct","異なった"],["tender","柔らかい "],["fry","揚げ物"],["retrieve","取り戻す"],["instance","場合"],["minister","大臣"],["conclude","結論を出す"],["populate","移住する"],];break;
    case "高校英語108" :item = [["workplace","職場"],["currency","貨幣"],["toxic","有毒な"],["technically","技術的に"],["ignorant","無知な"],["undergo","経験する"],["soak","浸す"],["disabled","不具になった"],["submarine","潜水艦"],["fade","弱まる"],];break;
    case "高校英語109" :item = [["oppress","圧迫する"],["liberate","自由にする"],["desperate","絶望的な"],["salesperson","販売員"],["herd","群れ"],["moist","湿った"],["chilly","寒い"],["abundant","豊富な"],["mount","登る"],["democracy","民主主義"],];break;
    case "高校英語110" :item = [["pursue","追跡する"],["acceptable","受け入れられる"],["transfer","移動"],["farming","農業"],["raincoat","レインコート"],["clown","道化師"],["fossil","化石"],["caption","表題"],["sphere","球 "],["boast","自慢する"],];break;
    case "高校英語111" :item = [["trial","裁判"],["nevertheless","それにもかかわらず"],["complicated","複雑な"],["witness","目撃する"],["preserve","保存する"],["council","審議会"],["otherwise","さもなければ"],["requirement","要求されること"],["thus","それゆえに"],["underground","地下"],];break;
    case "高校英語112" :item = [["independence","自立"],["palm","手のひら"],["analysis","分析"],["violence","暴力"],["slash","切り裂く"],["prosper","繁栄する"],["diploma","卒業証書"],["classic","古典"],["scribble","走り書きする"],["conceal","隠す"]];break;;break;
    case "高校英語113" :item = [["blaze","炎"],["petrol","ガソリン(英)"],["viable","実行可能な"],["planning","計画"],["lifelong","生涯の"],["govern","治める"],["contribute","貢献する"],["appreciate","正当に評価する"],["tasty","おいしい"],["compete","競争する"],];break;
    case "高校英語114" :item = [["assert","言い張る "],["thread","糸"],["pose","姿勢"],["glance","ちらりと見る"],["management","経営"],["trek","旅行する "],["disguise","変装する"],["trousers","ズボン"],["garlic","ニンニク"],["conditional","条件付き"],];break;
    case "高校英語115" :item = [["wage","賃金"],["leadership","リーダーシップ"],["circumstance","環境"],["mineral","鉱物"],["liquid","液体"],["amuse","楽しませる"],["lately","最近"],["accurate","正確な"],["agenda","議題"],["proponent","支持者"],];break;
    case "高校英語116" :item = [["enroll","登録する"],["investigation","捜査"],["firefighter","消防士"],["sorrow","悲しみ"],["cuisine","料理"],["congratulate","祝う"],["engage","約束する"],["organic","有機の"],["ease","容易さ"],["patch","継ぎ当て布"],];break;
    case "高校英語117" :item = [["tank","タンク"],["entirely","全く"],["condemn","非難する"],["overtake","追い越す"],["fright","恐怖"],["humiliate","恥をかかせる"],["variable","変数"],["conclusion","結論"],["scatter","ばらまく"],["genuine","本物の"],];break;
    case "高校英語118" :item = [["punctual","時間を厳守する"],["initial","最初の"],["snowboard","スノーボード"],["dominate","支配する"],["neglect","無視する"],["era","時代"],["motorbike","オートバイ"],["priority","優先度"],["habitat","生息地"],["biography","伝記"],];break;
    case "高校英語119" :item = [["chimpanzee","チンパンジー"],["obviously","明らかに"],["available","利用できる"],["tumble","倒れる"],["allocate","割り当てる"],["specialist","スペシャリスト"],["keen","鋭い "],["invasion","侵略"],["triumph","大勝利"],["renew","更新する"],];break;
    case "高校英語120" :item = [["interaction","交流"],["participate","参加する"],["crime","犯罪"],["represent","～を表す"],["gradually","徐々に"],["fried","揚げた"],["demonstrate","デモをする"],["landscape","風景"],["pleasantly","愛想よく"],["furthermore","さらに"],];break;
    case "高校英語121" :item = [["roundabout","回り道の"],["confession","告白"],["obedient","従順な"],["abolish","廃止する"],["mumble","つぶやく"],["depot","停車場 "],["treaty","条約"],["democratic","民主主義の"],["multinational","多国籍の"],["preschool","幼稚園"],];break;
    case "高校英語122" :item = [["profession","職業"],["swell","膨れる"],["cultivate","耕す"],["headline","見出し"],["stem","茎"],["altitude","高さ"],["vital","生命の"],["coverage","対象範囲 "],["formerly","昔は"],["sailboat","帆船"],];break;
    case "高校英語123" :item = [["outstanding","目立った"],["devastate","壊滅させる"],["repeatedly","繰り返して"],["suburb","近郊"],["drag","引く"],["symptom","兆候"],["risk","危険"],["prediction","予測"],["utilize","利用する"],["instinct","本能"],];break;
    case "高校英語124" :item = [["breeze","そよ風"],["basement","地階"],["stable","安定した"],["sensitive","敏感な"],["resist","反抗する"],["overthrow","覆す"],["napkin","ナプキン"],["bargain","バーゲン"],["blueberry","ブルーベリー"],["stock","在庫品"],];break;
    case "高校英語125" :item = [["sufficient","十分な"],["latest","最近の"],["bizarre","奇妙な"],["sandal","サンダル"],["mercy","慈悲"],["irrational","理性のない"],["mediocre","平凡な "],["disgrace","不名誉"],["experimental","実験の"],["heater","暖房器具"],];break;
    case "高校英語126" :item = [["evaluate","評価する"],["genetic","遺伝的な"],["talkative","おしゃべりな"],["component","要素"],["breed","育て"],["innocent","無実の"],["output","生産"],["molecule","分子"],["heritage","遺産"],["constantly","常に"],];break;
    case "高校英語127" :item = [["protest","抗議"],["bark","吠え声"],["scold","しかる"],["regulation","規則"],["fantastic","すばらしい"],["disaster","災害"],["identify","特定する"],["laundry","洗濯物"],["expose","さらす"],["outweigh","上回る"],];break;
    case "高校英語128" :item = [["strengthen","強化する"],["borrower","借り手"],["odd","奇妙な"],["imply","ほのめかす"],["distinguish","区別する"],["latter","後者の"],["substance","物質"],["dull","鈍い"],["dormitory","寮"],["explosion","爆発"],];break;
    case "高校英語129" :item = [["underestimate","過小評価"],["incredible","信じられない"],["effective","効果的な"],["ritual","儀式"],["privilege","特権"],["setback","後退"],["mum","お母さん"],["circuit","巡回"],["diverse","様々な"],["offensive","攻撃 "],];break;
    case "高校英語130" :item = [["advertising","宣伝すること"],["proposal","申出"],["cram","詰め込む"],["parallel","平行な"],["deforestation","森林伐採"],["equivalent","同等の"],["traveler","旅行者"],["allege","断言する"],["inconvenient","不便な"],["superior","優れた"],];break;
    case "高校英語131" :item = [["fairly","公平に"],["average","平均"],["staff","スタッフ"],["permission","許可"],["scholarship","奨学金"],["rob","強奪する"],["frankly","率直に"],["manufacture","製造業"],["percentage","パーセンテージ"],["exception","例外"],];break;
    case "高校英語132" :item = [["reservation","予約"],["institute","設ける"],["gene","遺伝子"],["assistance","援助"],["objective","目的"],["microwave","マイクロ波"],["rude","無礼な"],["ethnicity","民族性"],["virtue","美徳"],["treatment","治療"],];break;
    case "高校英語133" :item = [["recent","最近の"],["simply","単純に"],["artificial","人工の"],["differ","異なる"],["exact","正確な"],["sled","そり"],["educational","教育の"],["undertake","引き受ける"],["acceptance","承認"],["resort","リゾート地"],];break;
    case "高校英語134" :item = [["cartoon","漫画"],["tone","音"],["compliment","讃辞"],["remedy","治療薬"],["ongoing","継続中の"],["donate","寄付する"],["bankrupt","破産者"],["walking","歩行"],["adorable","崇拝すべき"],["wither","枯れる"],];break;
    case "高校英語135" :item = [["theft","盗み"],["rainforest","熱帯雨林"],["yield","降伏する"],["vessel","船"],["furious","激怒した"],["spaceship","宇宙船"],["politics","政治学"],["psychological","心理的な"],["peel","皮をむく"],["capability","能力"],];break;
    case "高校英語136" :item = [["makeup","化粧"],["overcome","克服する"],["context","前後関係"],["trace","形跡"],["honestly","正直に"],["phenomenon","現象"],["pump","ポンプ"],["allergy","アレルギー"],["fascinate","魅了する"],["hurricane","ハリケーン"],];break;
    case "高校英語137" :item = [["maintain","維持する"],["nuclear","原子力の"],["activate","有効化する"],["grasp","握る"],["scarce","乏しい"],["twist","ねじれ"],["forestry","林業"],["refund","払い戻し"],["archaeologist","考古学者"],["compensation","補償"],];break;
    case "高校英語138" :item = [["benefit","有利"],["decrease","減少"],["avenue","大通り"],["appointment","約束"],["attempt","試みる"],["financial","財務の"],["reinforce","強化する"],["physical","物質の"],["pasta","パスタ"],["investor","投資家"],];break;
    case "高校英語139" :item = [["segregate","隔離する"],["influential","影響力のある"],["portray","表現する"],["admittedly","確かに"],["skid","横滑り"],["religion","宗教"],["verbal","言葉の"],["cite","引用する"],["electronics","エレクトロニクス"],];break;
    case "高校英語140" :item = [["screen","スクリーン"],["item","品目"],["specific","具体的な"],["cleaner","クリーナー"],["neighborhood","近所"],["promote","進める"],["search","検索"],["alarm","警報"],["majority","大多数"],["normally","普通は"]];break;;break;
    case "高校英語141" :item = [["feedback","フィードバック"],["semester","学期"],["deserve","値する"],["routine","ルーティン"],["fake","偽の"],["candidate","候補者"],["application","申し込み"],["critic","批評家"],["equally","平等に"],["evolution","進化"]];break;;break;
    case "高校英語142" :item = [["brief","短い"],["tune","曲"],["occupation","占領"],["commitment","確約"],["violate","違反する"],["suspicion","疑念"],["confrontation","対立"],["abortion","中絶"],["download","ダウンロードする"],["furnish","供給する"],];break;
    case "高校英語143" :item = [["subtle","微妙な"],["delete","削除する"],["edit","編集する"],["peer","同格の人"],["agricultural","農業の"],["dissolve","溶かす"],["lodge","宿泊する"],["temporarily","一時的に"],["pullover","かぶり式の服"],["clarify","明らかにする"],];break;
    case "高校英語144" :item = [["crop","作物"],["essential","不可欠な"],["luckily","幸運にも"],["apologize","謝罪する"],["target","標的"],["diet","食事"],["inexpensive","安価な"],["closely","密接に"],["regularly","定期的に"],["stressful","ストレスの多い"]];break;;break;
    case "高校英語145" :item = [["relationship","関係"],["therefore","それゆえに"],["decay","腐る"],["standby","待機者"],["committee","委員会"],["convince","確信させる"],["rapidly","急速に"],["tidy","きれい好きな"],["discovery","発見"],["income","収入"],];break;
    case "高校英語146" :item = [["documentary","文書の"],["emotion","感情"],["focus","焦点"],["resident","居住者"],["dedication","献身"],["trail","追跡する"],["cue","合図"],["drastic","抜本的な"],["zipper","ジッパー"],["preliminary","予備的な"]];break;;break;
    case "高校英語147" :item = [["backbone","背骨"],["troop","軍隊"],["exhaust","排出"],["interpret","通訳する"],["breakthrough","突破口"],["destination","目的地"],["casually","何気なく"],["storage","保管"],["mature","成長しきった"],["shellfish","貝"],];break;
    case "高校英語148" :item = [["minor","少数派の"],["roughly","おおよそ"],["tide","潮"],["souvenir","お土産"],["reliable","信頼できる"],["barbecue","バーベキュー"],["manipulate","操作する"],["cardigan","カーディガン"],["excel","勝る"],["supporter","支持者"]];break;;break;
    case "高校英語149" :item = [["analyze","分析する"],["disadvantage","不利"],["beginner","初心者"],["export","輸出"],["obtain","手に入れる"],["terribly","ひどく"],["advance","前進する"],["cooperate","協力する"],["devise","工夫する"],["minimal","最小の"]];break;;break;
    case "高校英語150" :item = [["affluent","裕福な"],["rebel","反逆者"],["incentive","刺激"],["glimpse","ちらりと見る"],["universe","宇宙"],["climatic","気候の"],["assistant","助手"],["learner","学習者"],["annoyance","いら立たしさ"],["victory","勝利"],];break;
    case "高校英語151" :item = [["compulsory","義務的な"],["valid","正当な"],["faith","信頼"],["necktie,","ネクタイ"],["celebration","祝典"],["whereas","一方で"],["ambitious","大望のある"],["gap","割れ目"],["proudly","誇らしげに"],["wheat","小麦"]];break;;break;
    case "高校英語152" :item = [["bite","かむ"],["select","選ぶ"],["affect","影響を及ぼす"],["reflect","反射する"],["expert","専門家"],["significant","重要な"],["unknown","知られていない"],["locate","位置する"],["trap","罠"],["task","任務"],];break;
    case "高校英語153" :item = [["adopt","養子にする"],["kitten","子猫"],["luggage","荷物"],["refresh","リフレッシュする"],["prime","主要な"],["fluent","流暢な"],["conscious","意識"],["director","監督"],["combine","組合わせる"],["strain","引っ張る"]];break;;break;
    case "高校英語154" :item = [["imperial","帝国の"],["panel","パネル"],["element","成分"],["capacity","収容能力"],["technique","テクニック"],["decorate","飾る"],["rent","賃借料"],["observe","観察する"],["award","賞"],["presentation","発表"],];break;
    case "高校英語155" :item = [["bonus","ボーナス"],["pronunciation","発音"],["primary","主な"],["tights","タイツ"],["underline","下線"],["bond","接着剤 "],["notion","概念"],["outbreak","突発"],["explore","探検する"],["article","記事"],];break;
    case "高校英語156" :item = [["irritate","いらいらさせる"],["shrink","縮む"],["depression","不況"],["possession","所持"],["loyalty","忠誠"],["coaster","コースター"],["sneak","こっそり歩く"],["mediate","仲介する"],["accelerate","加速する"],["linger","長居する"],];break;
    case "高校英語157" :item = [["occupy","占領する"],["timber","木材"],["gross","総計の"],["yearn","憧れる"],["upstage","上段"],["chancellor","大臣"],["dropout","脱落"],["politely","丁寧に"],["spiral","螺旋状の"],["persistent","不屈の"],];break;
    case "高校英語158" :item = [["selective","選択的な"],["precede","先行する"],["evacuate","撤退する"],["rid","取り除く"],["uproot","根絶する"],["granddad","おじいちゃん"],["brand","ブランド"],["retire","引退する"],["discharge","解放する "],["dispute","口論"],];break;
    case "高校英語159" :item = [["explode","爆発する"],["embarrassment","困惑"],["gratitude","感謝"],["venue","開催地"],["portion","部分"],["pedestrian","歩行者"],["suppress","抑える"],["update","更新"],["flexible","柔軟な"],["assignment","任務"],];break;
    case "高校英語160" :item = [["legislation","法律"],["flip","さっとめくる"],["commute","通勤する"],["consist","～から成る"],["jog","ジョギングする"],["apparently","外見上では"],["essay","エッセイ"],["gravity","重力"],["hybrid","混成の"],["emphasize","強調する"]];break;;break;
    case "高校英語161" :item = [["amplify","増幅する"],["emotional","感情の"],["medieval","中世の"],["whatever","何でも"],["publication","出版"],["allowance","容認"],["flatter","平にするもの"],["visual","視覚の"],["presence","存在"],["countless","無数の"]];break;;break;
    case "高校英語162" :item = [["contribution","寄付"],["virus","ウイルス"],["highlight","ハイライト"],["teaching","教えること"],["acquaint","熟知させる"],["journal","新聞"],["dismantle","解体する"],["unusual","異常な"],["despise","軽蔑する"],["conscience","良心"],];break;
    case "高校英語163" :item = [["encounter","遭遇"],["victim","犠牲"],["diver","ダイバー"],["afford","余裕がある"],["secure","安全な"],["software","ソフトウェア"],["location","場所"],["critical","危機の"],["slightly","わずかに"],["estimate","見積もり"],];break;
    case "高校英語164" :item = [["bravery","勇気"],["accumulate","蓄積する"],["pill","錠剤"],["skim","すくい取る"],["nationality","国籍"],["playground","遊び場"],["nuisance","迷惑"],["electrical","電気の"],["lobby","ロビー"],["generous","気前のよい"],];break;
    case "高校英語165" :item = [["react","反応する"],["settle","落ち着く"],["definition","定義"],["merely","ただ単に"],["adjust","調節する"],["organization","組織"],["decade","１０年"],["environmental","環境の"],["farewell","お別れ"],["improvement","改良"],];break;
    case "高校英語166" :item = [["provision","供給"],["ecological","生態学的な"],["beneath","～の真下に"],["status","地位"],["freely","自由に"],["user","使用者"],["tightly","しっかり"],["reward","報酬"],["fortune","財産"],["worldwide","全世界の"],];break;
    case "高校英語167" :item = [["voucher","引換券"],["collaborate","協力する"],["fatal","致命的な"],["fee","費用"],["aspect","局面"],["ruin","破壊"],["curious","好奇心の強い"],["aisle","側廊"],["pronounce","発音する"],["academic","大学の"],];break;
    case "高校英語168" :item = [["grandchild","孫"],["debris","がらくた"],["unemployment","失業"],["lawsuit","訴訟"],["experiment","実験"],["issue","問題"],["slice","スライス"],["recommend","勧める"],["origin","起源"],["extremely","極端に"],];break;
    case "高校英語169" :item = [["approve","承認する"],["potential","潜在的な"],["laptop","膝のせ型の"],["achievement","達成"],["ginger","ショウガ"],["construct","建築する"],["reject","拒絶する"],["pile","積み重ね"],["launch","打ち上げ"],["instant","瞬間"],];break;
    case "高校英語170" :item = [["miniature","ミニチュア"],["contrary","反対の"],["tense","張り詰めた"],["stimulate","刺激する"],["federal","連邦の"],["confirm","確認する"],["harmony","調和"],["psychiatry","精神医学"],["fashionable","流行の"],["facilitate","容易にする"]];break;;break;
    case "高校英語171" :item = [["delay","遅延"],["vary","変わる"],["reveal","暴露"],["logical","論理的な"],["strip","裸にする"],["slam","バタンと閉める"],["equality","平等"],["skeleton","骨格"],["compound","合成物"],["formation","形成"],];break;
    case "高校英語172" :item = [["capture","捕える"],["prohibit","禁止する"],["widen","広げる"],["incident","出来事"],["frontier","未開拓分野"],["trustworthy","信頼できる"],["mammal","哺乳動物"],["executive","幹部"],["ray","放射線"],["overplay","誇張する"],];break;
    case "高校英語173" :item = [["timetable","時刻表"],["ignore","無視する"],["passion","情熱"],["possibly","～かもしれない"],["comedy","喜劇"],["frequently","頻繁に"],["strictly","厳密に"],["flesh","肉"],["unfold","開く"],["automatic","自動の"],];break;
    case "高校英語174" :item = [["clumsy","不器用な"],["employment","雇用"],["reduction","減少"],["abuse","不正利用"],["mentally","精神的に"],["annual","年1回の"],["graduation","卒業"],["confident","自信のある"],["messy","乱雑な"],["steady","安定した"]];break;;break;
    case "高校英語175" :item = [["accompany","同行する"],["frame","骨組み"],["appeal","訴える"],["virtually","実質的には"],["therapy","治療"],["blade","ナイフ"],["detect","見つける"],["adequate","適する"],["aspirin","アスピリン"],["merge","合併する"],];break;
    case "高校英語176" :item = [["responsibility","責任"],["previous","以前の"],["despite","～にもかかわらず"],["defeat","打ち破る"],["audition","オーディション"],["publicity","広報"],["relevant","関連した"],["perspective","展望"],["examine","調べる"],["constitution","憲法"],];break;
    case "高校英語177" :item = [["loan","貸付金"],["sponsor","広告主"],["hopeful","希望に満ちた"],["ingredient","原材料"],["arise","起こる"],["inevitable","避けられないもの"],["abstract","抽象的な"],["existence","存在"],["relation","関係"],["workout","トレーニング"],];break;
    case "高校英語178" :item = [["elderly","お年寄りの"],["option","選択肢"],["population","人口"],["online","オンライン"],["various","多様な"],["civil","市民の"],["chart","図表"],["validation","検証"],["deficit","不足額"],["lean","傾く"],];break;
    case "高校英語179" :item = [["excessive","過度の"],["prompt","即座の"],["appliance","器具"],["nutrition","栄養分"],["pregnant","妊娠した"],["pear","洋ナシ"],["rattle","ガラガラ"],["hesitant","ためらって"],["deem","考える"],["discredit","不信"],];break;

    case "中学英熟語1" :item = [["a series of ～","一連の～"],["As well as","～と同様に"],["Leave a message","伝言を残す"],["be busy with","～で忙しい"],["As soon as","～するとすぐに"],["Belong to","~に所属する"],["Prepare for","～の準備をする"],["A little","少し"],["Take part in","～に参加する"],["At the end of","～の最後に"],];break;
    case "中学英熟語2" :item = [["a great deal of ～","非常に多量の～"],["On your right","あなたの右手に"],["Don't have to","～する必要はない"],["In the future","将来は"],["Next door","となりに"],["Come up","近づく"],["How many","いくつの"],["Throw away","～を捨てる"],["Decide to","～しようと決心する"],["Put down","～を下に置く"],];break;
    case "中学英熟語3" :item = [["For the first time","初めて"],["a variety of ～","さまざまな～"],["Have to","～しなければならない"],["What time","何時に"],["All day","一日中"],["Talk about","～について話す"],["Be impressed with","～に感動する"],["Since then","その時以来"],["Any of","～のどれでも"],["Leave for","～に向けて出発する"],];break;
    case "中学英熟語4" :item = [["Be over","おわる"],["I hear that","～だそうだ。"],["Write down","～を書き留める"],["At the age of","～歳のときに"],["What to do","何をしたら良いか"],["Get on","～に乗る"],["Lose my way","道に迷う"],["At any time","いつでも"],["Too busy to","忙しすぎて～できない"], ["Feel sorry for","～を気の毒に思う"],];break;
    case "中学英熟語5" :item = [["Stay up","起きている"],["A piece of","一枚の"],["Be popular among","～の間で人気～のある"],["Put it in","それを～に入れる"],["above all","特に"],["Once a week","週に一度"],["Go abroad","外国へ行く"],["Sit down","座る"],["Between A and B","AとBの間に"],["Hear about","～について聞く"],];break;
    case "中学英熟語6" :item = [["Talk to","～と話す"],["Deal with","～に対処する"],["Let me see","ええと"],["For some time","しばらくの間"],["lots of","たくさんの"],["according to ～","～によれば"],["Be absent from","～を欠席する"],["How many times","何回"],["Next time","この次は"],["A member of","～の一員"],];break;
    case "中学英熟語7" :item = [["Hear from","～から連絡がある"],["Put on","～を身につける"],["At home","家で"],["Stay with","～の家に泊まる"],["Be supposed to","～することになっている"],["In the middle of","～の真ん中に"],["Like A better than B","BよりもAが好きだ"],["Fill ～with","～でいっぱいにする"],["What's wrong?","どうしましたか？"],["Come back to","～へ帰ってくる"],];break;
    case "中学英熟語8" :item = [["Once more","もう一度"],["Get off","降りる"],["Stop watching","見ることをやめる"],["During my stay in","滞在中に"],["Sit on","～に座る"],["From A to B","AからBまで"],["Make a mistake","間違える"],["A lot of","たくさんの"],["Than before","以前よりも"], ["At night","夜に"],];break;
    case "中学英熟語9" :item = [ ["Try on","～を試着する"],["Be in trouble","～に困っている"],["Put out","～を出す"],["Around the world","世界中で"],["In the morning","午前中に"],["Be used to","～に慣れている"],["Have no idea","わからない"],["One after another","次々と"],["Come from","～の出身である"],];break;
    case "中学英熟語10" :item = [  ["Which do you like better, A or B?","AとBのどちらが好きですか？"],["Go across","～を渡る"],["Listen to","～を聞く"],["Communicate with","～と意思を伝え合う"],["Smile at","～に微笑む"],["Get out","外に出る"],["Put up","～を提示する"],["I hope so.","そうだといいですね。"],["All around","あたり一面に"],["Next to","～のとなりに"],];break;
    case "中学英熟語11" :item = [["Be covered with","～で覆う"],["Go back to","～へ戻る"],["Thanks to","～のおかげで"],["As usual","いつものように"],["Help me with","私の～を手伝う"],["One day","ある日"],["At the same time","同時に"],["How long","どのくらい"],["Such as","～のような"],["A cup of","一杯の"],];break;
    case "中学英熟語12" :item = [ ["Hurry up","急ぐ"],["Turn around","振り向く"],["Any other","他に何か"],["Little by little","少しずつ"],["In this way","このように"],["Be different from","～と違う"],["Make a speech","スピーチをする"],["So that you can","あなたができるように"],["After school","放課後"],["Why don't you","～しませんか？"],];break;
    case "中学英熟語13" :item = [ ["Be surprised at","～に驚く"],["Thank you for","～をありがとう"],["As tall as","～くらい高い"],["Go down","降りる"],["Right away","すぐに"],["Be ready to","～する用意ができている"],["Suffer from","～に苦しむ"],["I mean","～と言う意味である"],["For example","例えば"],["Live in","～に住む"],];break;
    case "中学英熟語14" :item = [  ["By myself","一人で"],["You're kidding.","冗談でしょう"],["Get out of","～から降りる"],["Turn down","弱くする"],["Depend on","に頼る"],["Wish for","～を望む"],["Go to school","学校へ行く"],["No longer","もはや～ない"],["Each of","それぞれの"],["Here and there","あちこちで"],];break;
    case "中学英熟語15" :item = [["That's right","その通りです。"],["Come in","入る"],["So wonderful that","とても素晴らしいので"],["How do you like","～はいかがですか？"],["Go away","立ち去る"],["Go up to","～に近寄る"],["Right now","今すぐ"],["At a time","一度に"],["Go home","帰宅する"],["Long ago","ずっと前に"],];break;
    case "中学英熟語16" :item = [ ["After all","結局"],["With a smile","ほほえみながら"],["Be proud of","～を誇りに思う"],["In those days","そのころは"],["At least","少なくとも"],["Turn off","～を消す"],["Be interested in","～に興味がある"],["take a bath","風呂に入る"],["At once","すぐに"],["Make friends with","～と友達になる"],];break;
    case "中学英熟語17" :item = [ ["Be famous for","～で有名だ"],["Not at all","少しも～ない"], ["A glass of","一杯の"],["Some day","いつか"],["Good luck","幸運を祈る"],["Be happy to","～して嬉しい"],["Run around","走り回る"],["In time","間に合って"],["From now on","これからはずっと"],["The next day","次の日"],];break;
    case "中学英熟語18" :item = [ ["By mistake","間違って"],["I see","わかった"],["No more","もう～ない"],["Far from","～から遠い"],["Look after","～の世話をする"],["One of","～のうち～の一つ"],["For dinner","夕食に"],["Hundreds of","何百もの"],["Make fun of","～をからかう"],["Both A and B","AもBも両方とも"],];break;
    case "中学英熟語19" :item = [  ["Run away","逃げる"],["Find out","～を見つけ出す"],["Look up","見上げる"],["Take a break","ひと休みする"],["Continue to","～しつづける"],["Some of","～のいくつか"],["Get to","～に着く"],["Grow up","成長する"],["Not only A but also B","AだけでなくBも"],["By the way","ところで"],];break;
    case "中学英熟語20" :item = [["Up to","まで"],["Here you are","はいどうぞ"],["Out of","～から外へ"],["Die of","～で死ぬ"],["Make up my mind","決心をする"],["Go into","～に入る"],["The number of","～の数"],["A group of","～の一団"],["Soon after","～のすぐあとに"],["Be able to","～することができる"],];break;
    case "中学英熟語21" :item = [ ["I think so, too","私もそう思います。"],["Say hello to","～によろしくと言う"],["Again and again","何度も"],["Begin to","～し始める"],["Take a look at","～をひとめ見る"], ["Be late for","～に遅れる"],["Without saying","言わないで"],["I　would like to","～したいのですが。"],["No one","だれも～ない。"],["Get together","集まる"],];break;
    case "中学英熟語22" :item = [ ["Need to","～する必要がある"],["Used to","よく～したものだ"],["Could you","～していただけますか？"],["Instead of","～の代わりに"],["Not yet.","まだ～ない。"],["Each other","お互い"],["Say to myself","心の中で思う"],["I think that","私は～だと思う。"],["Come and see","会いに来る"],["Sound like","～のように聞こえる"],];break;
    case "中学英熟語23" :item = [ ["A is to B what C is to D","AとBの関係はCとDの関係と同じだ"],["Finish writing","書き終える"],["On TV","テレビで"],["Introduce A to B","AをBに紹介する"],["Day and night","昼も夜も"],["Look around","見回す"],["The other day","先日"],["Go on","続く"],["Graduate from","卒業する"],["Of all","全ての中で"],];break;
    case "中学英熟語24" :item = [ ["Both of","～の両方とも"],["Many kinds of","いろいろな種類の"],["Go ahead","さあ、どうぞ"],["Take a message","伝言を預かる"],["Come true","実現する"],["I'm afraid that","残念ですが～と思う。"],["Over there","むこうに"],["Get up","起きる"],["Look at","～を見る"],["Go around","～を歩き回る"],];break;
    case "中学英熟語25" :item = [ ["Half of","～の半分"],["Sounds good.","良さそうですね"],["Cut down","～を切り倒す"],["See her off","彼女を見送る"],["Just then","ちょうどその時"], ["Far away","遠くに"],["How much","~はいくら"],["Not ～any more","これ以上～ない"],["Be surprised to","～して驚く"],["Many times","何回も"],];break;
    case "中学英熟語26" :item = [ ["A kind of","一種の"],["The same as","～と同じ"],["Be careful about","～に注意する"],["Take a picture","写真を撮る"],["All right.","いいですよ。"],["Part of","～の一部"],["Go and see","見にいく"],["See a doctor","医者にみてもらう"],["By hand","手製で"],["Look down","見下ろす"],];break;
    case "中学英熟語27" :item = [  ["Go to bed","寝る"],["Of course","もちろん"],["Either A or B","AかBかどちらか"],["Speak to","～に話しかける"],["Exchange A for B","AとBを取り替える"],["Would you like?","～はいかがですか？"],["Happen to","偶然～する"],["Bring back","～を持って帰る"],["Wait for","～を待つ"],["Go on a trip to","～へ旅行に出かける"],];break;
    case "中学英熟語28" :item = [  ["Keep in touch","連絡をとりあう"],["Do my homework","宿題をする"],["You're welcome.","どういたしまして"],["For a long time","長い間"],["Pay for","～の代金を払う"],["Because of","～のために"],["A lot","たくさん"],["Wake up","目を覚ます"],["Be friendly to","～に親切だ"],["Work at","～で働く"],];break;
    case "中学英熟語29" :item = [ ["As long as","～する限りは"],["Take a walk","散歩する"],["Be afraid of","～をこわがる"],["Hold on","お待ちください"],["The way to","～する方法"],["Look for","～を探す"], ["Get along with","～と仲良くやっていく"],["Come on.","元気出して"],["On the way","～へいく途中で"],["Get well","よくなる"],["May I help you?","お手伝いしてもいいですか？"],];break;
    case "中学英熟語30" :item = [["Do my best","全力をつくす"],["Take away","片付ける"],["Go out","外出する"],["A pair of","1組の"],["I'm sure that","きっと～と思う。"],["Pick up","迎えにいく"],["At that time","その時"],["How often","どのくらいの頻度で"],["Keep talking","話し続ける"],["All alone","ひとりぼっちで"],];break;
    case "中学英熟語31" :item = [ ["These days","この頃"],["Be full of","～でいっぱいだ"],["Stand for","～を表す"],["Be kind to","～に親切だ"],["Walk around","～を歩き回る"],["A few","少しの"],["Play catch","キャッチボールをする"],["At last","ついに"],["Take care of","～の世話をする"],["Last year","去年"],];break;
    case "中学英熟語32" :item = [  ["All over","～のいたるところで"],["Work on","～に取り組む"],["How to","～の仕方"],["Give ～a call","～に電話をする"],["Walk to","へ歩いていく"],["Do well","うまくやる"],["How about","～はどうですか？"],["More and more","ますます"],["Call back","電話をかけ直す"],["In fact","実は"],];break;
    case "中学英熟語33" :item = [ ["Come out of","～から出てくる"],["On foot","徒歩で"],["Have a chance to","～する機会がある"],["Enough to","するのに十分"],["Think about","～のことを考える"],["Bring up","～を育てる"], ["Look forward to","～を楽しみに待つ"],["Get angry","怒る"],["Please help yourself.","ご自由にお召し上がりください。"],["Day after day","くる日もくる日も"],];break;
    case "中学英熟語34" :item = [  ["Stand up","立ち上がる"],["Go shopping","買い物に行く"],["Seem to","～のように思われる"],["Arrive at","到着する"],["Want to","～したい"],["Away from","～から離れて"],["Have fun","楽しむ"],["Take it easy.","無理しないで。"],["A sheet of","一枚の"],["On the other hand","他方では"],];break;
    case "中学英熟語35" :item = [ ["Be responsible for","～に責任がある"],["This morning","今朝"],["In front of","～の前に"],["First of all","まず第一に"],["More than","以上"],["Catch a cold","風邪をひく"],["Plenty of","たくさんの"],["Fall down","倒れる"],["Start to learn","学習し始める"],["every day","毎日"],];break;
    case "中学英熟語36" :item = [   ["How old","何歳"],["Shall I?","～しましょうか？"],["At school","学校で"],["Move around","～を動き回る"],["Take me to","私を～に連れていく"],["And so on","～など"],["Believe in","～の存在を信じる"],["Want you try","あなたに～してもらいたい"],["Ask him to","彼に～するように頼む"],["Learn about","～について学ぶ"],];break;
    case "中学英熟語37" :item = [["Be glad to","～で嬉しい"],["Point to","～を指差す"],["Get married","結婚する"],["Look into","覗き込む\n調査する"],["By bus","バスで"],["Get back","戻る"],["On the phone","電話で"], ["Clean up","～をかたづける"],["Welcome to","～へようこそ"],["For a while","しばらくの間"],];break;
    case "中学英熟語38" :item = [ ["Worry about","～について心配する"],["Have a cold","風邪をひいている"],["A great number of","多数の"],["Show you around","あなたに案内する"],["At first","最初は"],["Take off","～を脱ぐ"],["a bit","少し"],["In order to","～するために"],["All the time","ずっと"],["This one","こちらのもの"],];break;
    case "中学英熟語39" :item = [["Be made of","～から作られている"],["Go through","～を通り抜ける"],["What kind of","どんな種類の"],["Agree with","同意する"],["Be sick in bed","病気で寝ている"],["Write back","返事を書く"],["As hard as you can","できるだけ一生懸命"],["Learn to","～するようになる"],["Be good at","～が得意だ"],["Take out","～を取り出す"],];break;
    case "中学英熟語40" :item = [  ["Give up","あきらめる"],["Look like","～のように見える"],["A long time ago","昔"],["In the end","ついに"],["This time","今回は"],["Be born","生まれる"],["Have a headache","頭痛がする"],["On time","時間通りに"],["After a while","しばらく後"],["Most of","～のほとんど"], ["Begin with","～から始める"],];break;
    case "高校英熟語1" :item = [["every other","一つおきの"],["back and forth","前後に"],["in addition to ～","～に付け加えて"],["needless to say","言うまでもなく"],["be engaged in ～","～に従事している"],["once again","もう一度"],["carry out ～","～を実行する"],["as ～ as possible","できる限り～"],["in particular","特に"],["take account of ～","～を考慮に入れる"],];break;
    case "高校英熟語2" :item = [   ["confuse A with B","AをBと混同する"],["reach for ～","～を取ろうと手を伸ばす"],["at any rate","とにかく"],["hit on ～","～を急に思いつく"],["be obliged to …","…することを余儀なくされる"],["cut off ～","～を切り取る"],["as a rule","一般に"],["in advance","前もって"],["be filled with ～","～でいっぱいである"],["It is not until A that B","Aになって初めてBする"],];break;
    case "高校英熟語3" :item = [  ["take advantage of ～","～を利用する"],["be subject to ～","～の支配下にある"],["give way","～に屈する"], ["refer to ～","～に言及する"],["aside from ～","～の他にも"],["neither A nor B","AでもBでもない"],["catch up with ～","～に追いつく"],["once and for all","これを最後に"],["at the cost of ～","～を犠牲にして"],["have yet to …","まだこれから…しなければならない"],];break;
    case "高校英熟語4" :item = [["take after ～","～に似ている"],["break into ～","～に押し入る"],["in case ～","～した場合には"],["in proportion to ～","～に比例して"], ["refuse to …","…することを拒否する"],["apart from ～","～は別として"],["every time ～","～する時はいつでも"],["once upon a time","昔々"],["be worthy of ～","～の価値がある"],["never … without ～ing","…すると必ず～する"],["consist in ～","～にある"],];break;
    case "高校英熟語5" :item = [  ["tell A from B","AをBと区別する"],["be familiar to ～","～によく知られている"],["with ease","容易に"],["for free","無料で"],["make believe ～","～のふりをする"],["regard A as B","AをBと見なす"],["as is often the case (with ～)","（～には）よくあることだが"],["in search of ～","～を捜して"],["by nature","生まれつき"],["in case of ～","～の場合には"],];break;
    case "高校英熟語6" :item = [  ["ought to …","…すべきである"], ["be prepared to …","…する準備ができている"],["hear of ～","～のことを聞く"],["charge A with B","AをBの罪で告訴する"],["remind A of B","AにBを思い出させる"],["for the sake of ～","～のために"],["at first sight","一目見て"],["go by","過ぎ去る"],["tend to …","…する傾向がある"],["be aware of ～","～に気づいている"],];break;
    case "高校英熟語7" :item = [ ["hold ～ back","～を押しとどめる"],["no less than ～","～も"],["break out","勃発する"],["make do with ～","～で間に合わせる"], ["apply for ～","～を申し込む"],["out loud","声を出して"],["except for ～","～を除けば"],["regardless of ～","～に関係なく"],["be going to …","…するつもりである"],["in charge of ～","～の管理をして"],];break;
    case "高校英熟語8" :item = [["before long","間もなく"],["in short","要するに"],["at large","一般の"],["be apt to …","…する傾向がある"],["be made up of ～","～から成る"],["at present","現在は"],["for the time being","当面の間"],["No matter how ～","たとえどんなに～でも"], ["as follows","次のとおり"],["resort to ～","～に頼る"],];break;
    case "高校英熟語9" :item = [ ["give birth to ～","～を生む"],["be likely to …","…する傾向がある"],["be concerned with ～","～と関わりがある"],["out of order","故障して"],["rely on ～","～に依存する"],["keep A from B","AをBから避ける"],["account for ～","～を説明する"],["result from ～","～の結果として生じる"],["fail to …","…できない"],["be familiar with ～","～になじみがある"],];break;
    case "高校英熟語10" :item = [ ["in common (with ～)","（～と）共通に"],["cling to ～","～に執着する"],["in brief","要するに"], ["no more A than B","Bでないのと同様にAでない"],["from ～ on","～からずっと"], ["the last ～ to …","最も…しそうにない～"],["with respect to ～","～に関して"],["make out ～","～を理解する"],["be superior to ～","～より優れている"],["result in ～","結果として～になる"],];break;
    case "高校英熟語11" :item = [   ["consist of ～","～から成る"],["hope for ～","～を願う"],["over and over","繰り返し"],["at the latest","遅くとも"],["deprive A of B","AからBを奪う"],["would rather A (than B)","Bよりも）むしろAしたい"],["be due to …","…する予定である"],["none the less","それにもかかわらず"],["bring about ～","～を引き起こす"],["in conclusion","結論として"],["rob A of B","AからBを強奪する"],];break;
    case "高校英熟語12" :item = [["ahead of ～","～の前方に"],["think much of ～","～のことを重視する"],["close to ～","ほとんど～"],["keep away from ～","～に近寄らない"],["be related to ～","～と関係がある"],["hundreds of ～","数百の～"],["not to say ～","～とは言わないまでも"],["fall asleep","眠る"], ["at the sight of ～","～を見て"],["in spite of ～","～にもかかわらず"],];break;
    case "高校英熟語13" :item = [  ["blame A for B","AをBのことで非難する"],["in detail","詳細に"],["to make matters worse","さらに悪いことには"],["by no means ～","決して～ない"],["owe A to B","AをBのおかげだと思う"],["if any","たとえあるとしても"],["pass away","亡くなる"],["as soon as possible","できるだけ早く"],["derive A from B","BからAを引き出す"],["nothing but ～","～にすぎない"],];break;
    case "高校英熟語14" :item = [ ["but for ～","～がなければ"],["in terms of ～","～という観点では"],["come about","起こる"],["search for ～","～を捜す"],["fall in love with ～","～に恋をする"],["be equal to ～","～に匹敵する"],["if anything","どちらかといえば"],["to say nothing of ～","～は言うまでもなく"],["by virtue of ～","～のおかげで"],["make sense","意味をなす"],];break;
    case "高校英熟語15" :item = [  ["pay attention to ～","～に注意を払う"], ["all at once","突然"],["in exchange for ～","～と交換に"],["cope with ～","～にうまく対処する"],["object to ～","～に反対する"],["in the long run","長い目で見れば"],["second to none","何（誰）にも劣らない"],["in any case","とにかく"],["from ～ point of view","～の観点から"], ["keep off ～","～から離れておく"],];break;
    case "高校英熟語16" :item = [  ["at a loss","途方に暮れて"],["to some extent","ある程度"],["do ～ good","～に利益をもたらす"],["make the best of ～","～を最大限に利用する"],["be about to …","今にも…しようとしている"],["persuade A not to …","Aに…しないように説得する"],["find out ～","～を見つけ出す"],["seek to …","…しようと努める"], ["by way of ～","～経由で"],["in favor of ～","～に賛成して"],];break;
    case "高校英熟語17" :item = [["as for ～","～はというと"],["keep up with ～","～に遅れずついていく"],["by accident","偶然に"],["off duty","非番で"],["generally speaking","一般的に言うと"], ["in the way ","～の邪魔になって"],["along with ～","～と共に"],["to tell the truth","本当のことを言うと"],["come across ～","～に偶然出くわす"],["on account of ～","～が理由で"],];break;
    case "高校英熟語18" :item = [["be independent of ～","～から独立している"],["show up","現れる"],["impose A on B","AをBに課す"],["point out ～","～を指摘する"],["be sure to …","必ず…する"],["translate A into B","AをBに翻訳する"],["give rise to ～","～を生む"],["as such","そのようなものとして"],["do ～ harm","～に害をもたらす"],["turn on ～","～（電気など）をつける"], ["in turn","順番に"],];break;
    case "高校英熟語19" :item = [ ["side by side","横に並んで"],["at the expense of ～","～を犠牲にして"],["make up for ～","～の埋め合わせをする"],["be something of a ～","ちょっとした～である"],["in force","大挙して"],["prefer A to B","BよりAを好む"],["blame A on B","AをBのせいだとする"],["get in ～","～（車など）に乗る"], ["as a result","結果として"],["correspond to ～","～に相当する"],];break;
    case "高校英熟語20" :item = [ ["in a hurry","急いで"],["so to speak","いわば"],["be engaged to ～","～と婚約している"],["turn out ～","～であることが判明する"],["do away with ～","～を廃止する"],["owing to ～","～が理由で"], ["prevent A from ～ing","Aが～するのを防ぐ"],["with regard to ～","～に関して"],["know better than to …","…するほど愚かではない"],];break;
    case "高校英熟語21" :item = [["be fit for ～","～に適している"],["in vain","無駄に"],["by chance","偶然に"],["run across ～","～に偶然出くわす"], ["in a row","連続で"],["sooner or later","遅かれ早かれ"],["all of a sudden","突然"],["give in","屈する"],["be satisfied with ～","～に満足している"],["manage to …","何とか…する"],];break;
    case "高校英熟語22" :item = [  ["call for ～","～を要求する"],["first of all","まず第一に"],["inform A of B","AにBを知らせる"],["at best","せいぜい"],["laugh at ～","～を笑う"],["under ～ circumstances","～の状況で"],["blow up","爆発する"],["on and off","断続的に"],["get lost","道に迷う"], ["as a matter of fact","実際のところ"],];break;
    case "高校英熟語23" :item = [ ["get over ～","～を乗り越える"],["be bound to …","必ず…する"],["in honor of ～","～に敬意を表して"],["call ～ off","～を中止する"],["prove A (to be) B","AがBであると証明する"],["go on ～ing","～し続ける"], ["under construction","建設中である"],["ask for ～","～を要求する"],["come along","ついてくる"],["insist on ～","～を強く主張する"],];break;
    case "高校英熟語24" :item = [ ["stand by ～","～を支援する"],["be free from ～","～がない"],["call on ～","～（人）を訪問する"],["had better …","…したほうがよい"],["apply to ～","～に当てはまる"],["provide A with B","AにBを与える"],["count on ～","～を当てにする"],["in a sense","ある意味で"],["differ from ～","～と異なる"],["mean to …","…するつもりである"],];break;
    case "高校英熟語25" :item = [  ["get rid of ～","～を廃止する"],["in itself","それ自体では"],["urge A to …","Aに…するよう強く勧める"], ["get used to ～","～に慣れる"],["on behalf of ～","～を代表して"],    ["what we call ～","いわゆる～"],["for instance","例えば"], ["at hand","近くに"],["even if ～","たとえ～だとしても"],["at the mercy of ～","～のなすがままに"],];break;
    case "高校英熟語26" :item = [["as to ～","～に関して"],["provide for ～","～を養う"],["to begin with","まず第一に"],["be similar to ～","～と似ている"],["stand out","目立つ"],["come up with ～","～を考えつく"], ["by means of ～","～によって"],["It goes without saying that ～","～は言うまでもないことだ"],["wear out","使い古す"],["as if ～","まるで～であるかのように"],];break;
    case "高校英熟語27" :item = [ ["in a while","しばらくしたら"],["boast of ～","～を自慢する"],["dozens of ～","数十の～"],["all the way","はるばる"],["learn ～ by heart","～を暗記する"],["be true to ～","～に忠実である"],["put off ～","～を延期する"],["cannot afford to …","…する余裕がない"],["more or less","多かれ少なかれ"],["on duty","勤務中で"],];break;
    case "高校英熟語28" :item = [ ["be inferior to ～","～より劣っている"],["succeed in ～","～に成功する"], ["have nothing to do with ～","～と無関係である"],["compare A to B","AをBにたとえる"],["put up with ～","～に耐える"],    ["take ～ for granted","～を当然のことと思う"],["cannot help ～ing","～せざるを得ない"],["It is no use ～ing","～しても無駄である"],["when it comes to ～","～という話になると"], ["approve of ～","～を承認する"],];break;
    case "高校英熟語29" :item = [  ["as far as ～","～する範囲では"],["long for ～","～を切望する"],["call at ～","～（場所）に立ち寄る"],["in accordance with ～","～に従って"],["be certain to …","…するのは確実だ"],["in other words","言い換えると"],["succeed to ～","～を継承する"],["cure A of B","AのBを治す"],["on occasion","時おり"],["break down","故障する"],];break;
    case "高校英熟語30" :item = [  ["put up with ～","～に耐える"],["be typical of ～","～に典型的である"],["on purpose","故意に"],["be liable to …","…（好ましくないことを）しがちである"],["take ～ in","～をだます"],["compare A with B","AとBを比較する"],["be worth ～ing","～する価値がある"],];break;

//
    case "中高漢字1" :item = [["貝塚","かいづか"],["核心","かくしん"],["臭い","くさい"],["肯定する","コウテイする"],["重曹","じゅうそう"],["凹む","へこむ"],["消耗","しょうもう"],["漆","うるし"],["罷免","ひめん"],["誘拐","ゆうかい"],];break;
    case "中高漢字2" :item = [["奴隷","どれい"],["薪","まき"],["経緯","けいい"],["朽ちる","くちる"],["依存","いぞん"],["操る","あやつる"],["項目","こうもく"],["掲載","けいさい"],["却下","きゃっか"],["紹介","しょうかい"],];break;
    case "中高漢字3" :item = [["危篤","きとく"],["遭遇","そうぐう"],["又は","または"],["伸びる","のびる"],["炊飯","すいはん"],["帆船","はんせん"],["覆う","おおう"],["一斤","いっきん"],["概念","がいねん"],["瀬戸際","せとぎわ"],];break;
    case "中高漢字4" :item = [["抵抗","ていこう"],["即興","そっきょう"],["尻尾","しっぽ"],["幅","はば"],["輩","やから"],["近況","きんきょう"],["丘","おか"],["水滴","すいてき"],["儀式","ぎしき"],["店舗","てんぽ"],];break;
    case "中高漢字5" :item = [["箇所","かしょ"],["香り","かおり"],["詰める","つめる"],["獣","けもの"],["名称","めいしょう"],["透ける","すける"],["溶ける","とける"],["猛暑","もうしょ"],["鬼","おに"],["奇妙","きみょう"],];break;
    case "中高漢字6" :item = [["壱","いち"],["恥","はじ"],["桃","もも"],["握力","あくりょく"],["脂肪","しぼう"],["戦闘","せんとう"],["渡る","わたる"],["狭い","せまい"],["恵み","めぐみ"],["尽力","じんりょく"],];break;
    case "中高漢字7" :item = [["慶応","けいおう"],["入江","いりえ"],["画伯","がはく"],["蚊に刺される","カに刺される"],["過剰","かじょう"],["戻る","もどる"],["挟む","はさむ"],["租税","そぜい"],["搭載","とうさい"],["化粧","けしょう"]];break;;break;
    case "中高漢字8" :item = [["淡い","あわい"],["範囲","はんい"],["粒","つぶ"],["殿様","とのさま"],["枯れる","かれる"],["趣味","しゅみ"],["圏内","けんない"],["浮き輪","うきわ"],["鉛","なまり"],["寂しい","さみしい"],];break;
    case "中高漢字9" :item = [["償う","つぐなう"],["財閥","ざいばつ"],["麻酔","ますい"],["斬新","ざんしん"],["茎","くき"],["書斎","しょさい"],["虜","とりこ"],["懲罰","ちょうばつ"],["襟首","えりくび"],["拷問","ごうもん"],];break;
    case "中高漢字10" :item = [["同姓同名","どうせいどうめい"],["堤防","ていぼう"],["吹き矢","ふきや"],["堅い","かたい"],["悩む","なやむ"],["霧","きり"],["峠","とうげ"],["駆逐","くちく"],["舞う","まう"],["壁","かべ"],];break;
    case "中高漢字11" :item = [["酔う","よう"],["悲哀","ひあい"],["紺色","こんいろ"],["請求書","せいきゅうしょ"],["克服","こくふく"],["分泌","ぶんぴつ"],["怠る","おこたる"],["幻滅","げんめつ"],["技巧","ぎこう"],];break;
    case "中高漢字12" :item = [["押す","おす"],["盗む","ぬすむ"],["坊主","ぼうず"],["傾斜","けいしゃ"],["頼る","たよる"],["寝る","ねる"],["征服","せいふく"],["紋章","もんしょう"],["驚く","おどろく"],["彼","かれ"],];break;
    case "中高漢字13" :item = [["休憩","きゅうけい"],["暫く","しばらく"],["野蛮","やばん"],["開催","かいさい"],["緩む","ゆるむ"],["摂取","せっしゅ"],["視聴室","しちょうしつ"],["虚しい","むなしい"],["福祉","ふくし"],];break;
    case "中高漢字14" :item = [["某日","ぼうじつ"],["奉仕する","ほうしする"],["緊張","きんちょう"],["狩猟","しゅりょう"],["袋","ふくろ"],["排出","はいしゅつ"],["鍛錬","たんれん"],["東京湾","東京わん"],["葬式","そうしき"],["騎馬戦","きばせん"],];break;
    case "中高漢字15" :item = [["拍手喝釆","拍手カッサイ"],["惰性","だせい"],["倫理","りんり"],["准教授","ジュン教授"],["窮地","きゅうち"],["弾劾する","ダンガイする"],["蛍","ホタル"],["扉","とびら"],["抹消する","マッショウする"],["交渉する","コウショウする"],];break;
    case "中高漢字16" :item = [["援助","えんじょ"],["畳","たたみ"],["宿泊","しゅくはく"],["暴れる","あばれる"],["惑星","わくせい"],["汗","あせ"],["色彩","しきさい"],["跳ねる","はねる"],["奇数","きすう"],["抱く","いだく"],];break;
    case "中高漢字17" :item = [["輝く","かがやく"],["涙","なみだ"],["俗に","ぞくに"],["年齢","ねんれい"],["派遣","はけん"],["飛躍","ひやく"],["塔","とう"],["絡む","からむ"],["治療","ちりょう"],["響く","ひびく"],];break;
    case "中高漢字18" :item = [["値段が高騰する","値段がコウトウする"],["婚姻","こんいん"],["旋回する","センカイする"],["愉快","ゆかい"],["庶民","しょみん"],["顕著","けんちょ"],["閑散とする","カンサンとする"],["杉の木","スギの木"],["傘をさす","カサをさす"],["網羅","もうら"],];break;
    case "中高漢字19" :item = [["違う","ちがう"],["脚立","きゃたつ"],["陣地","じんち"],["雲","くも"],["恐い","こわい"],["遊戯","ゆうぎ"],["矛盾","むじゅん"],["刺す","さす"],["芋","いも"],["継続","けいぞく"],];break;
    case "中高漢字20" :item = [["床","ゆか"],["潜る","もぐる"],["避難","ひなん"],["狂う","くるう"],["娘","むすめ"],["踏む","ふむ"],["荒波","あらなみ"],["襲う","おそう"],["介入","かいにゅう"],["嘔吐","おうと"],];break;
    case "中高漢字21" :item = [["剣","つるぎ"],["蓄積","ちくせき"],["超える","こえる"],["結婚","けっこん"],["丈夫","じょうぶ"],["根拠","こんきょ"],["扇子","せんす"],["甘い","あまい"],["拍手","はくしゅ"],["傍","かたわら"],];break;
    case "中高漢字22" :item = [["足跡","あしあと"],["腐る","くさる"],["劣る","おとる"],["侵入","しんにゅう"],["雷","かみなり"],["芝生","しばふ"],["鑑定","かんてい"],["税込","ぜいこみ"],["汚い","きたない"],["兼業","けんぎょう"],];break;
    case "中高漢字23" :item = [["掲載","けいさい"],["控える","ひかえる"],["喫茶店","きっさてん"],["促す","うながす"],["苗","なえ"],["疾風","しっぷう"],["承諾","しょうだく"],["藩主","はんしゅ"],["措置","そち"],];break;
    case "中高漢字24" :item = [["優雅","ゆうが"],["獲得","かくとく"],["雄","おす"],["太鼓","たいこ"],["敏感","びんかん"],["還暦","かんれき"],["〜の為に","〜のために"],["刈る","かる"],["黙る","だまる"],["巡る","めぐる"],];break;
    case "中高漢字25" :item = [["船舶","せんぱく"],["刃","やいば"],["頑張る","がんばる"],["窃盗","せっとう"],["洪水","こうずい"],["縄","なわ"],["遂に","ついに"],["追悼","ついとう"],["矯正器具","きょうせい器具"],["頻繁","ひんぱん"],];break;
    case "中高漢字26" :item = [["渓谷を歩く","ケイコクを歩く"],["妃","きさき"],["徹夜","てつや"],["数珠","じゅず"],["洗濯機","せんたくき"],["俊敏","しゅんびん"],["患者","かんじゃ"],["堕落","だらく"],["恐竜","きょうりゅう"],["寮生活","リョウ生活"],];break;
    case "中高漢字27" :item = [["基礎","きそ"],["輪郭","りんかく"],["恨み","うらみ"],["潔癖","けっぺき"],["綱","つな"],["中華","ちゅうか"],["衰弱","すいじゃく"],["伴う","ともなう"],["契約","けいやく"],["記念碑","きねんひ"],];break;
    case "中高漢字28" :item = [["振動","しんどう"],["鋭い","するどい"],["朱色","しゅいろ"],["恋心","こいごころ"],["巨大","きょだい"],["忙しい","いそがしい"],["遅い","おそい"],["罰","ばつ"],["砲弾","ほうだん"],["疲れる","つかれる"],];break;
    case "中高漢字29" :item = [["軒先","のきさき"],["訴える","うったえる"],["緩い","ゆるい"],["雌","メス"],["歳月","さいげつ"],["叫ぶ","さけぶ"],["薄い","うすい"],["乾燥する","かんそうする"],["微熱","びねつ"],["生殖","せいしょく"],];break;
    case "中高漢字30" :item = [["拒む","こばむ"],["訴訟","そしょう"],["戦艦","せんかん"],["儒教","じゅきょう"],["忍","しのぶ"],["媒体","ばいたい"],["披露宴","ひろうえん"],["殉職","じゅんしょく"],["紳士","しんし"],["稼ぐ","かせぐ"],];break;
    case "中高漢字31" :item = [["仙人","せんにん"],["溝","みぞ"],["翁","おきな"],["生涯現役","ショウガイ現役"],["循環","じゅんかん"],["暁","あかつき"],["秩序","ちつじょ"],["病棟","びょうとう"],["貨幣","かへい"],["宣言","せんげん"],];break;
    case "中高漢字32" :item = [["祈る","いのる"],["弾く","はじく"],["珍しい","めずらしい"],["怒鳴る","どなる"],["描く","えがく"],["腰","こし"],["伺う","うかがう"],["眠い","ねむい"],["微妙","びみょう"],["瞬間","しゅんかん"],];break;
    case "中高漢字33" :item = [["抵抗","ていこう"],["尋問","じんもん"],["暇","ひま"],["花柄","はながら"],["寸胴","ずんどう"],["紫","むらさき"],["洗剤","せんざい"],["網","あみ"],["旬","しゅん"],["傾く","かたむく"],];break;
    case "中高漢字34" :item = [["阻止","そし"],["撮影","さつえい"],["閲覧","えつらん"],["卸売","おろしうり"],["在籍","ざいせき"],["胆石","たんせき"],["崩れる","くずれる"],["掛け算","かけざん"],["摩擦","まさつ"],["娯楽","ごらく"],];break;
    case "中高漢字35" :item = [["婿","むこ"],["菊の花","きくのはな"],["海賊","かいぞく"],["双子","ふたご"],["魅力","みりょく"],["嫁","よめ"],["発酵","はっこう"],["紛れる","まぎれる"],["幻","まぼろし"],["啓発","けいはつ"],];break;
    case "中高漢字36" :item = [["塊","かたまり"],["悦楽","えつらく"],["駐車場","ちゅうしゃじょう"],["債務","さいむ"],["墨汁","ぼくじゅう"],["惜しい","おしい"],["抱擁","ほうよう"],["幽霊","ゆうれい"],["搾取","さくしゅ"],["山岳","さんがく"],];break;
    case "中高漢字37" :item = [["海藻を食べる","カイソウを食べる"],["柳","やなぎ"],["泡","あわ"],["疫病","えきびょう"],["疎開","そかい"],["陥る","おちいる"],["拳銃","けんじゅう"],["岩礁","がんしょう"],["煩悩","ぼんのう"],["男爵","だんしゃく"],];break;
    case "中高漢字38" :item = [["監獄","かんごく"],["保釈","ほしゃく"],["髪型","かみがた"],["煙","けむり"],["憎む","にくむ"],["狩人","かりうど"],["飾る","かざる"],["与える","あたえる"],["勧める","すすめる"],["到達","とうたつ"],];break;
    case "中高漢字39" :item = [["大吉","だいきち"],["お腹の胎児","お腹のたいじ"],["孤立","こりつ"],["姫","ひめ"],["侍","さむらい"],["桑","くわ"],["怪しい","あやしい"],["湖畔","こはん"],["膨らむ","ふくらむ"],["津波","つなみ"],];break;
    case "中高漢字40" :item = [["賄賂","わいろ"],["不妊治療","フニン治療"],["統括","とうかつ"],["涼しい","すずしい"],["摩擦","まさつ"],["詩吟","しぎん"],["酷い","ひどい"],["妥協","だきょう"],["別荘","べっそう"],["醸造所","じょうぞう所"],];break;
    case "中高漢字41" :item = [["一坪","一ツボ"],["肌","はだ"],["報酬","ほうしゅう"],["検索","けんさく"],["遮断","しゃだん"],["甚だしい","はなはだしい"],["渦","うず"],["浴槽","よくそう"],["棺","ひつぎ"],["銘柄","めいがら"]];break;;break;
    case "中高漢字42" :item = [["鬼畜","きちく"],["帝王","ていおう"],["隆起","りゅうき"],["特殊","とくしゅ"],["粘る","ねばる"],["廃棄","はいき"],["水晶玉","すいしょうだま"],["脅し","おどし"],["摩天楼","まてんろう"],];break;
    case "中高漢字43" :item = [["磨く","みがく"],["年俸","ねんぽう"],["昆虫","こんちゅう"],["不祥事","ふしょうじ"],["囚人","しゅうじん"],["洗浄器","センジョウ器"],["唇","くちびる"],["但し","ただし"],["累積","るいせき"],["覇権争い","ハケン争い"],];break;
    case "中高漢字44" :item = [["厄介","やっかい"],["貝殻","かいがら"],["栓抜き","せん抜き"],["亭主","ていしゅ"],["据置","すえおき"],["鈴","すず"],["貢献","こうけん"],["酢飯","すめし"],["水筒","すいとう"],["首相官邸","首相カンテイ"],["鉢巻","ハチマキ"],];break;
    case "中高漢字45" :item = [["慰める","なぐさめる"],["碁石","ごいし"],["賠償","ばいしょう"],["痴漢に合う","チカンに合う"],["安泰","あんたい"],["賜物","たまもの"],["盲目","もうもく"],["硝子","ガラス"],["挿入曲","ソウニュウ曲"],["丁寧","ていねい"],];break;
    case "中高漢字46" :item = [["老婆","ろうば"],["滑る","すべる"],["軌道","きどう"],["了解","りょうかい"],["宴","うたげ"],["漏れる","もれる"],["訂正","ていせい"],["寿","ことぶき"],["譲る","ゆずる"],["衝動","しょうどう"],];break;
    case "中高漢字47" :item = [["隔てる","へだてる"],["餓死","がし"],["欧米","おうべい"],["遂に","ついに"],["募集","ぼしゅう"],["地獄","じこく"],["交換","こうかん"],["粗塩","あらじお"],["手の甲","手のこう"],["壮絶","そうぜつ"],];break;
    case "中高漢字48" :item = [["払う","はらう"],["煮る","にる"],["惨敗","ざんぱい"],["濁る","にごる"],["沖縄","おきなわ"],["帽子","ぼうし"],["露呈","ろてい"],["一般","いっぱん"],["攻撃","こうげき"],["奥行き","おくゆき"],];break;
    case "中高漢字49" :item = [["還元する","カンゲンする"],["管轄","かんかつ"],["肉汁","にくじゅう"],["推奨する","スイショウする"],["左遷","させん"],["崇める","アガめる"],["誓う","ちかう"],["今宵","こよい"],["癒す","いやす"],["模擬試験","もぎ試験"],];break;
    case "中高漢字50" :item = [["バイ菌","ばいキン"],["新潟","にいがた"],["土壌","どじょう"],["浦安市","ウラヤス市"],["表彰式","ひょうしょうしき"],["更迭する","コウテツする"],["履修","りしゅう"],["分析","ぶんせき"],["霜降り","シモ降り"],["合併","がっぺい"],];break;
    case "中高漢字51" :item = [["皆無","かいむ"],["詳しい","くわしい"],["破壊","はかい"],["鈍い","にぶい"],["お互い","おたがい"],["浜辺","はまべ"],["踊る","おどる"],["丹後半島","たんごはんとう"],["投稿","とうこう"],["翼","つばさ"],];break;
    case "中高漢字52" :item = [["記憶","きおく"],["沼","ぬま"],["海賊","かいぞく"],["感嘆","かんたん"],["震える","ふるえる"],["掘る","ほる"],["繁栄","はんえい"],["途中","とちゅう"],["自慢","じまん"],["誇る","ほこる"],];break;
    case "中高漢字53" :item = [["警鐘を鳴らす","けいしょうを鳴らす"],["肝臓","かんぞう"],["一斗缶","いっとかん"],["哲学","てつがく"],["疑問","ぎもん"],["潤う","うるおう"],["縛る","しばる"],["慌てる","あわてる"],["縫う","ぬう"],["稲穂","いなほ"],];break;
    case "中高漢字54" :item = [["睡眠","すいみん"],["威嚇","いかく"],["洞穴","ほらあな"],["沸点","ふってん"],["探偵","たんてい"],["一升瓶","いっしょうびん"],["お酌","おしゃく"],["偏り","かたより"],["枯渇","こかつ"],["体の四肢","体のシシ"],];break;
    case "中高漢字55" :item = [["顧客","こきゃく"],["携帯","けいたい"],["彫刻","ちょうこく"],["虐待","ぎゃくたい"],["切符","きっぷ"],["湿度","しつど"],["敢えて","あえて"],["顧問","こもん"],["没収","ぼっしゅう"],["電卓","でんたく"],];break;
    case "中高漢字56" :item = [["海軍の元帥","海軍のゲンスイ"],["偽物","にせもの"],["一緒","いっしょ"],["花瓶の花","カビンの花"],["弔う","とむらう"],["靴","くつ"],["弊害","へいがい"],["蛇口","じゃぐち"],["不貞を犯す","フテイを犯す"],["侮辱","ぶじょく"],];break;
    case "中高漢字57" :item = [["遭遇","そうぐう"],["角膜","かくまく"],["揚げ物","あげもの"],["伏線","ふくせん"],["滞在","たいざい"],["審判","しんぱん"],["貫く","つらぬく"],["骨髄","こつずい"],["犠牲","ぎせい"],["謹慎","きんしん"],];break;
    case "中高漢字58" :item = [["妊娠","にんしん"],["垣根","かきね"],["妄想","もうそう"],["猿年","サル年"],["下駄","げた"],["捜査官","ソウサ官"],["棚","たな"],["懇願","こんがん"],["勲章","くんしょう"],["撤収","てっしゅう"],];break;
    case "中高漢字59" :item = [["揺れる","ゆれる"],["収穫","しゅうかく"],["郊外に住む","こうがいに住む"],["解雇する","かいこする"],["悔しい","くやしい"],["軸","じく"],["陰謀","いんぼう"],["殴る","なぐる"],["掃除","そうじ"],["抽出","ちゅうしゅつ"],];break;
    case "中高漢字60" :item = [["賢い","かしこい"],["既に","すでに"],["破裂","はれつ"],["焦る","あせる"],["邦画","ほうが"],["房","ふさ"],["同胞","どうほう"],["愚か","おろか"],["糧にする","かてにする"],["逮捕","たいほ"],];break;
    case "中高漢字61" :item = [["充血","じゅうけつ"],["眺める","ながめる"],["砕ける","くだける"],["泥","どろ"],["学習塾","学習じゅく"],["柔軟剤","じゅうなんざい"],["憤慨","ふんがい"],["尚且つ","なおかつ"],["推薦状","すいせんじょう"],["購入","こうにゅう"],];break;
    case "中高漢字62" :item = [["綺麗","きれい"],["侵入","しんにゅう"],["路肩","ろかた"],["騒ぐ","さわぐ"],["環境","かんきょう"],["普通","ふつう"],["豪快","ごうかい"],["逃げる","にげる"],["鎖","くさり"],["新鮮","しんせん"],];break;
    case "中高漢字63" :item = [["縁","ふち"],["需要","じゅよう"],["及び","および"],["偉人","いじん"],["峰","みね"],["地盤","じばん"],["祝杯","しゅくはい"],["咲く","さく"],["敷地","しきち"],["茂み","しげみ"],];break;
    case "中高漢字64" :item = [["幾つ","いくつ"],["捕獲","ほかく"],["摘む","つむ"],["隣","となり"],["秀才","しゅうさい"],["陰影","いんえい"],["井戸","いど"],["贈る","おくる"],["濃淡","のうたん"],["突入","とつにゅう"],];break;
    case "中高漢字65" :item = [["扱う","あつかう"],["漫談","まんだん"],["匹敵","ひってき"],["旨い","うまい"],["抜ける","ぬける"],["腕","うで"],["繊維","せんい"],["奴","やつ"],["端っこ","はしっこ"],["仰向け","あおむけ"],];break;
    case "中高漢字66" :item = [["飽きる","あきる"],["施設","しせつ"],["託す","たくす"],["悟","さとる"],["企画","きかく"],["鶏","にわとり"],["裸","はだか"],["海峡","かいきょう"],["豚","ブタ"],["卑怯","ひきょう"],];break;
    case "中高漢字67" :item = [["逸脱","いつだつ"],["懐かしい","なつかしい"],["岬","みさき"],["貢献する","コウケンする"],["喪服","もふく"],["奈良漬け","奈良ヅケ"],["砂漠","さばく"],["哀愁","あいしゅう"],["迅速","じんそく"],["傑作","けっさく"],];break;
    case "中高漢字68" :item = [["窒素","ちっそ"],["乙","おつ"],["奪う","うばう"],["感慨深い","かんがい深い"],["選択肢","せんたくし"],["錯覚","さっかく"],["超越","ちょうえつ"],["容赦","ようしゃ"],["抑制","よくせい"],["誘う","さそう"],];break;
    case "中高漢字69" :item = [["欺く","あざむく"],["偶数","ぐうすう"],["冠","かんむり"],["憂う","うれう"],["侮辱","ぶじょく"],["塗る","ぬる"],["随時","ずいじ"],["討伐","とうばつ"],["封筒","ふうとう"],];break;
    case "中高漢字70" :item = [["拘縮","こうしゅく"],["慰める","なぐさめる"],["魂","たましい"],["慈愛","じあい"],["漂う","ただよう"],["免税","めんぜい"],["鍛える","きたえる"],["炎","ほのお"],["翻訳","ほんやく"],["穏やか","おだやか"],];break;
    case "中高漢字71" :item = [["勘違い","かんちがい"],["辛い","からい"],["硬直","こうちょく"],["刑罰","けいばつ"],["匿名","とくめい"],["召喚","しょうかん"],["憎しみ","にくしみ"],["滝","たき"],["生粋","きっすい"],["絞る","しぼる"],];break;
    case "中高漢字72" :item = [["鯨","クジラ"],["零","ゼロ"],["廊下","ろうか"],["撃墜","げきつい"],["妨げる","さまたげる"],["帳簿","ちょうぼ"],["禁忌","きんき"],["徐行","じょこう"],["冗談","じょうだん"],];break;
    case "中高漢字73" :item = [["ひな壇","ひなだん"],["分岐点","ぶんきてん"],["励ます","はげます"],["貧乏","びんぼう"],["潜る","もぐる"],["浪人","ろうにん"],["上昇","じょうしょう"],["陳謝","ちんしゃ"],["尿","にょう"],["将棋","しょうぎ"],];break;
    case "中高漢字74" :item = [["培養液","ばいようえき"],["唯一","ゆいいつ"],["猫","ねこ"],["一塁","いちるい"],["附属","ふぞく"],["猶予","ゆうよ"],["楽譜","がくふ"],["余裕","よゆう"],["褒美","ほうび"],["金融","きんゆう"],];break;
    case "中高漢字75" :item = [["執念","しゅうねん"],["離れる","はなれる"],["慎重","しんちょう"],["迫る","せまる"],["凡人","ぼんじん"],["盾","たて"],["玄米","げんまい"],["噴水","ふんすい"],["添える","そえる"],["耐える","たえる"],];break;
    case "中高漢字76" :item = [["症候群","しょうこうぐん"],["把握","はあく"],["解剖する","カイボウする"],["亜細亜","アジア"],["部屋の隅","部屋のスミ"],["素朴","そぼく"],["廃業","はいぎょう"],["打撲","だぼく"],["診察","しんさつ"],];break;
    case "中高漢字77" :item = [["巨匠","きょしょう"],["削る","けずる"],["埋葬","まいそう"],["お嬢さん","おじょうさん"],["邪悪","じゃあく"],["錠剤","じょうざい"],["十字架","じゅうじか"],["幼稚","ようち"],["凍る","こおる"],["該当","がいとう"]];break;;break;
    case "中高漢字78" :item = [["嫌悪","けんお"],["論ずる","ロンずる"],["酪農","らくのう"],["中枢","ちゅうすう"],["逝去","せいきょ"],["懸念","けねん"],["監督","かんとく"],["挑む","いどむ"],["遺憾","いかん"],["肖像権","しょうぞうけん"],];break;
    case "中高漢字79" :item = [["恒常性","こうじょうせい"],["皮膚","ひふ"],["屈曲","くっきょく"],["含む","ふくむ"],["警戒","けいかい"],["触る","さわる"],["距離","きょり"],["操る","あやつる"],["唐辛子","とうがらし"],["誉める","ほめる"],];break;
    case "中高漢字80" :item = [["韻を踏む","インを踏む"],["実践","じっせん"],["醜態","しゅうたい"],["雰囲気","ふんいき"],["褐色","かっしょく"],["普遍的","ふへんてき"],["下痢","げり"],["示唆する","シサする"],["駐屯地","ちゅうとんち"],["自粛","じしゅく"],];break;
    case "中高漢字81" :item = [["販売","はんばい"],["更に","さらに"],["菓子","かし"],["隠す","かくす"],["被害","ひがい"],["柔らかい","やわらかい"],["配慮","はいりょ"],["盆地","ぼんち"],["召使い","めしつかい"],["稲","いね"]];break;;break;
    case "中高漢字82" :item = [["脱力","だつりょく"],["歓迎","かんげい"],["占う","うらなう"],["枠組み","ワク組み"],["渋る","しぶる"],["糾弾する","キュウダンする"],["缶ビール","かんビール"],["硫酸","りゅうさん"],["釣り","つり"],["栽培","さいばい"],];break;
//
    case "古文単語1" :item = [["あからめ","よそ見"],["つれづれ","退屈だ"],["さかし","賢い"],["おまへ","御前"],["なのめ","普通"],["ことわる","判断する"],["まらうと","客"],["おぼえ","評判"],["たまはる","いただく"],["むなし","無駄だ"],];break;
    case "古文単語2" :item = [["かこつ","嘆く"],["ば","もし～ならば"],["こうず","困る"],["むくつけし","不気味だ"],["あらは","明白だ"],["たづき","手段"],["らうらうじ","洗練されている"],["おぼゆ","思われる"],["ひねもす","終日"],["つきなし","ふさわしくない"],];break;
    case "古文単語3" :item = [["あそび","遊戯"],["いぶせし","うっとうしい"],["さかしら","こざかしい"],["おとど","御殿"],["しほたる","涙を流す"],["はべり","～です"],["かた","方向"],["らうがはし","乱雑だ"],["ごせ","来世"],["つかさ","役所"],];break;
    case "古文単語4" :item = [["いはく","言うことには"],["ほいなし","不本意だ"],["あし","悪い"],["すなわち","すぐに"],["はた","やはり"],["うちつけ","突然だ"],["こころづきなし","不快だ"],["とみ","急"],["いつしか","いつの間にか"],];break;
    case "古文単語5" :item = [["いぎたなし","寝坊だ"],["しるし","はっきり分かる"],["れい","いつも"],["かげ","姿"],["すごし","物寂しい"],["まゐる","参上する"],["かぎりなし","この上ない"],["まうづ","お参りする"],["さとし","賢い"],["ぐす","連れて行く"],];break;
    case "古文単語6" :item = [["からし","辛い"],["ども","けれども"],["あいぎゃう","かわいらしさ"],["ねんごろなり","親切である"],["こころなし","思いやりがない"],["いかめし","厳かだ"],["なめげ","失礼だ"],["けうとし","よそよそしい"],["めづ","心がひかれる"],["かしこまる","恐縮する"],];break;
    case "古文単語7" :item = [["あへなし","がっかりだ"],["つらし","薄情"],["いはけなし","幼い"],["やまがつ","山里の人"],["きこしめす","お聞きになる"],["ものうし","気がすすまない"],["いぬ","去る"],["よすがら","一晩中"],["ちご","幼児"],["けう","珍しい"],];break;
    case "古文単語8" :item = [["あいなし","面白くない"],["いぶかし","知りたい"],["よしなし","仕方がない"],["うち","宮中"],["さる","そのような"],["まもる","見守る"],["おこなふ","実行する"],["むつまし","親しい"],["そらごと","うそ"],["かしかまし","やかましい"],];break;
    case "古文単語9" :item = [["こころやすし","安心だ"],["やる","行かせる"],["あり","存在する"],["もどく","まねる/非難する"],["かどかどし","才気がある"],["をこがまし","ばからしい"],["おろか","いい加減"],["なり","～ようだ。"],["くまなし","影がない"],["てうず","整える"],];break;
    case "古文単語10" :item = [["おほけなし","身の程知らずだ"],["まだし","まだ早い"],["あぢきなく","無意味だ"],["おのづから","自然に"],["じ","～しないつもりだ"],["たり","～た。（完了）"],["いつく","大切にする"],["みながら","すべて"],["かしこし","恐れ多い"],["ねぶ","年をとる"],];break;
    case "古文単語11" :item = [["さらば","それならば"],["はしたなし","きまりが悪い"],["あやにく","意地が悪い"],["なにがし","どこそこ"],["けむ","~ただろう(過去推量)"],["つゆ","まったく"],["おきつ","命令する"],["みやび","上品"],["ざえ","学問"],["はづかし","立派だ"],];break;
    case "古文単語12" :item = [["かたち","姿"],["めのと","母親の代わり"],["あらまし","予定"],["すぐる","選び出す"],["なほ","いっそう"],["きよら","汚れなく美しい"],["ゆゆし","不吉だ"],["いまはむかし","今となっては"],["わざ","行為"],["さながら","そのまま"],];break;
    case "古文単語13" :item = [["うれふ","心配する"],["よむ","詩歌を作る"],["こころもとなし","待ち遠しい"],["さ","そのように"],["ながらふ","長生きする"],["いう","優雅だ"],["ひつ","ぬれる"],["きこゆ","申し上げる"],["やむごとなし","大切である"],["あはれ","感動する"],];break;
    case "古文単語14" :item = [["さらなり","言うまでもない"],["わりなし","道理に合わない"],["あからさまなり","ほんのちょっと"],["うとし","よく知らない"],["ゐる","座る"],["けり","～た。（過去）"],["なやまし","具合が悪い"],["かたほ","未熟"],["やすし","容易だ"],];break;
    case "古文単語15" :item = [["いづれ","どっち"],["しる","統治する"],["らうたし","かわいい"],["おきな","老人"],["にくし","憎らしい"],["おとなし","大人びている"],["ひとわろし","みっともない"],["けし","異常だ"],["なべて","一般に"],["かたはらいたし","きまりが悪い"],];break;
    case "古文単語16" :item = [["こ","これ"],["ひとやりならず","強制ではなく、自分の意志でする。"],["あざる","ふざける"],["みゆ","見える"],["しばし","しばらく"],["かたみに","互いに"],["こまやか","繊細で美しい"],["ほど","身分"],["うしろめたし","不安だ"],["よろづ","すべて"],];break;
    case "古文単語17" :item = [["かたくな","頑固だ"],["すべ","方法"],["をさをさし","大人びている"],["あながち","強引だ"],["まうく","準備する/得をする"],["くだる","都から地方へ行く"],["ゆくりなし","思いがけない"],["いと","非常に"],["さすが","やはり"],["ものす","ある"],];break;
    case "古文単語18" :item = [["ながむ","ぼんやり物思いにふける"],["いかなる","どういう"],["ひたぶる","ひたすら/一途"],["かごと","愚痴"],["つ","～た。"],["をかし","趣がある"],["うし","辛い"],["のたまふ","おっしゃる"],["かど","才能"],["なやみ","病気"],];break;
    case "古文単語19" :item = [["さがなし","性格が悪い"],["めづらし","素晴らしい"],["あやなし","不当だ"],["ゆかり","関係"],["さやか","はっきりしている"],["きは","端"],["めやすし","感じがよい"],["うらなし","うっかりしている"],["せめて","強いて"],["ものし","気に入らない"],];break;
    case "古文単語20" :item = [["つごもり","月末"],["あだ","無意味だ"],["やうやう","だんだん"],["うたて","嫌だ"],["こちなし","無作法だ"],["ところせし","窮屈だ"],["おどろく","はっとする"],["なつかし","心惹かれる"],["ここら","たくさん"],["ふびん","都合が悪い"],];break;
    case "古文単語21" :item = [["さがし","険しい"],["ついで","機会"],["おこなひ","振る舞い"],["なやむ","病気になる"],["くもゐ","遠く離れた所"],["をこ","馬鹿げている"],["かたへ","一部"],["たがふ","違う"],["つれなし","平気だ"],["いづ","出る"],];break;
    case "古文単語22" :item = [["ぬ","～た。"],["あな","ああ"],["むねむねし","しっかりしている"],["げに","本当に"],["をりふし","季節"],["うるはし","美しい"],["さうざうし","物足りない"],["わたる","過ぎる"],["かく","このように"],["つつむ","遠慮する"],];break;
    case "古文単語23" :item = [["ことごとし","ものものしい"],["とし","はやい"],["あやし","不思議だ"],["せうそこ","手紙"],["むべ","なるほど"],["うるさし","面倒だ"],["たてまつる","差し上げる"],["みそか","内緒"],["きよげなり","美しい"],["なでふ","どういう"],];break;
    case "古文単語24" :item = [["いにしへ","昔"],["ほどなし","間もない"],["あした","朝"],["まほし","〜したい"],["けさう","化粧"],["ひがごと","間違い"],["かねて","前もって"],["ゆかし","知りたい"],["くちをし","残念だ"],["つきづきし","ふさわしい"],];break;
    case "古文単語25" :item = [["あふ","結婚する"],["まめやかなり","真面目だ"],["おもしろし","美しい"],["よし","理由"],["えうなし","つまらない"],["こととふ","尋ねる"],["やつす","目立たないようにする"],["うつつ","現実"],["すだく","群がる"],["ものぐるほし","気が変になりそうだ"],];break;
    case "古文単語26" :item = [["ふみ","手紙"],["あたらし","惜しい"],["ず","～ない"],["めでたし","すばらしい"],["おぼしめす","お思いになる"],["そぞろ","無関係だ"],["なほざり","いい加減"],["おのれ","自分"],["やさし","恥ずかしい"],["すきずきし","物好きだ"],];break;
    case "古文単語27" :item = [["はかる","推測する"],["いかで","どうして"],["さうぞく","衣装"],["まし","～だろうに"],["いみじ","たいへんだ"],["ごとし","～のようだ"],["べし","～にちがいない"],["おこたる","病気が治る"],["ねたし","憎らしい"],["こころぐるし","つらい"],];break;
    case "古文単語28" :item = [["おくる","先立たれる"],["まさなし","良くない"],["こと","言葉"],["わづらふ","悩む"],["あく","満足する"],["いらふ","答える"],["ばかり","ぐらい"],["かひなし","効果がない"],["ゆゑ","原因"],["いざ","さあ"]];break;;break;
    case "古文単語29" :item = [["ことわり","道理"],["なまめく","若々しくて美しい"],["あて","身分が高い"],["はつか","わずか"],["さうらふ","お仕えする"],["おほやけ","朝廷"],["ちぎり","約束"],["ありがたし","珍しい"],["しのぶ","我慢する"],["ほい","本来の目的"],];break;
    case "古文単語30" :item = [["つぼ","庭"],["あらまほし","理想的"],["むつかし","不快だ"],["けはひ","雰囲気"],["さま","様子"],["まめまめし","実用的だ"],["うそぶく","息をきらす"],["めざまし","気にくわない"],["こころうし","辛い"],["ためし","例"],];break;
    case "古文単語31" :item = [["いづこ","どこ"],["ほだし","足かせ"],["かる","離れる"],["よすが","手段"],["おほかた","一般に"],["ねんず","耐え忍ぶ"],["かしづく","大切に育てる"],["の","～が"],["まじ","～しないつもりだ"],["あかつき","夜明け前"],];break;
    case "古文単語32" :item = [["さが","性質"],["ありく","動き回る"],["たいだいし","面倒だ"],["えん","優雅だ"],["せち","ひたすら"],["よそふ","比べる"],["およすく","成長する"],["やまぎは","空の、山に接する部分"],["くんず","がっかりする"],];break;
    case "古文単語33" :item = [["あるじ","もてなし"],["まばゆし","恥ずかしい"],["きと","急に"],["ののしる","大声で騒ぐ"],["かかる","このような"],["みる","妻とする"],["いたし","ひどい"],["なさけ","思いやり"],["こぞ","昨年"],["やをら","静かに"],];break;
    case "古文単語34" :item = [["あきらむ","はっきりさせる"],["たまふ","お与えになる"],["ときめく","時流に乗って栄える"],["くちおし","惜しい"],["にはか","急に"],["いも","姉・妹・妻・恋人"],["たひらか","無事"],["むげ","まったくひどい"],["かひがひし","効果がある"],["なさけなし","思いやりがない"],];break;
    case "古文単語35" :item = [["あさまし","意外だ"],["ここち","気持"],["り","～た。"],["おはす","いらっしゃる"],["そこら","たくさん"],["をし","かわいい"],["いそぐ","準備する"],["こちたし","大げさだ"],["むねと","主に"],["おほす","おっしゃる"],];break;
    case "古文単語36" :item = [["うす","消える"],["やがて","すぐに"],["いとど","ますます"],["す","する"],["ひがひがし","ひねくれている"],["つとめて","早朝"],["おぼろげ","いい加減だ"],["まめ","真面目だ"],["さぶらふ","あります"],["むすぶ","手ですくう"],];break;
    case "古文単語37" :item = [["うつくし","かわいい"],["たまのを","命"],["かまえて","気をつけて"],["わびし","がっかりする"],["いたづら","役に立たない"],["こころにくし","上品だ"],["なかなか","むしろ"],["おもておこし","面目を施すこと"],["せうと","兄弟"],["なめし","無礼だ"],];break;
    case "古文単語38" :item = [["おぼつかなし","はっきりしない"],["をこなり","愚かだ"],["せむかたなし","方法がない"],["かなし","かわいい"],["たけし","つよい"],["なんぢ","おまえ"],["うしろやすし","安心だ"],["すずろ","当てがない"],["とかく","とにかく"],["まほし","～たい"],];break;
    case "古文単語39" :item = [["なまめかし","若々しい"],["けしき","様子"],["すさまじ","面白くない"],["にほふ","輝く"],["あまた","たくさん"],["びんなし","具合が悪い"],["おとなふ","音を立てる"],["たのむ","あてにする"],["はかなし","むなしい"],["としごろ","長年"],];break;
    case "古文単語40" :item = [["あくがる","さまよう"],["すくせ","宿命"],["など","どうして"],["かたし","難しい"],["つぼね","部屋"],["いとほし","かわいそうだ"],["ひじり","聖人"],["さうなし","この上ない"],["かづく","ほうびを頂く"],];break;
//
    case "世界史年表1" :item = [ ["100万年前","ジャワ原人の出現"],["50万年前","北京原人の出現"],["20万年前","ホモサピエンスの出現"],["16万年前","クロマニヨン人の出現"],["BC7000","メソポタミア文明の形成"],["BC5000年","黄河文明/長江文明の形成"],["BC3000年","シュメール文化/エジプト文明/エーゲ文明の形成"],["BC2530年","ピラミッド造営"],["BC2000年頃","インダス文明の形成"],["BC2000年頃","バビロニア"],];break;
    case "世界史年表2" :item = [ ["BC1800年頃","ハンムラビ王即位"],["BC1500年","殷王朝成立"],["BC1350年頃","ツタンカーメン王即位"],["BC1200年","オルメカ文明の形成"],["BC1003年","ダヴィデ王即位"],["BC1000年","アンデス文明の形成"],["BC960年","ソロモン王が王位継承"],["BC776年","最初のオリンピック"],["BC770年","周の東遷"],["BC750年","ローマ建国"],];break;
    case "世界史年表3" :item = [ ["BC594年","ソロンの改革"],["BC586年","ユダヤ教成立"],["BC552年","孔子誕生"],["BC508年","クレイステネスの改革"],["BC500年","ペルシア戦争"],["BC451年","ローマで十二表法成立"],["BC403年","中国で戦国時代の開始"],["BC334年","アレクサンドロスの東方遠征開始"],["BC333年","イッソスの戦い"],["BC330年","ペルシア帝国滅亡"],];break;
    case "世界史年表4" :item = [ ["BC301年","イプソスの戦い"],["BC264年","第1回ポエニ戦争"],["BC247年","秦の始皇帝が即位"],["BC221年","秦が中国統一"],["BC218年","第2回ポエニ戦争"],["BC202年","前漢の成立"],["BC168年","マケドニア滅亡"],["BC149年","第３回ポエニ戦争"],["BC136年","漢で五経博士が置かれる"],["BC133年","グラックスの改革"],];break;
    case "世界史年表5" :item = [["BC91年","司馬遷が史記を完成/イタリア同盟市戦争"],["BC73年","スパルタクスの反乱"],["BC60年","第１回三頭政治(ポンペイウス、クラックス、カエサル)"],["BC44年","カエサル暗殺"],["BC43年","第２回三頭政治(オクタヴィアヌス、アントニウス、レピドゥス)"],["BC31年","アクティウムの海戦"],["BC5年頃","イエス・キリスト誕生"],["25年","後漢建国"],["30年","イエス・キリスト処刑"],["64年","ネロがキリスト教徒を迫害"],];break;
    case "世界史年表6" :item = [["80年","コロッセウム完成"],["96年","ローマで五賢帝時代"],["105年","蔡倫が紙を発明"],["184年","黄巾の乱"],["207年","劉備が三顧の礼で諸葛亮を迎える"],["208年","赤壁の戦"],["212年","万民法"],["220年","後漢滅亡/三国時代"],["226年","ササン朝ペルシア建国"], ["280年","晋が中国統一"],];break;
    case "世界史年表7" :item = [ ["284年","ディオクレティアヌス帝即位"],["313年","ミラノの勅"],["325年","ニケーア公会議"],["376年","ゲルマン人の大移動"],["392年","ローマ帝国でキリスト教が国教となる"],["395年","ローマ帝国が分裂"], ["420年","宋が建国"],["439年","北魏が華北を統一"], ["476年","西ローマ帝国滅亡"],["485年","北魏で均田制を実施"],];break;
    case "世界史年表8" :item = [["486年","北魏で三長制を実施"],["527年","東ローマ帝国でユスティニアヌス大帝が即位"],["581年","楊堅が隋を建国"],["589年","隋が中国統一"],["604年","煬帝が即位"],["610年","イスラ-ム教創始"],["618年","隋が滅亡し、唐が中国統一"], ["621年","唐が開元通宝を発行"],["626年","唐の太宗が即位"],["627年","貞観の治"],];break;
    case "世界史年表9" :item = [ ["630年","ムハンマドがメッカを征服"],["661年","ウマイヤ朝成立"],["663年","白村江の戦い"],["668年","唐・新羅連合軍により高句麗が滅びる"], ["676年","新羅が朝鮮半島を統一"],["712年","唐の玄宗が即位"], ["713年","唐の開元の治が始まる"],["750年","アッバーズ朝成立"],["751年","製紙法が西方に伝わる"],["755年","安史の乱"],];break;
    case "世界史年表10" :item = [ ["774年","カール大帝がランゴバルド王国征服"],["780年","唐で両税法が施行される"],["786年","アッバース朝カリフにカリフ・ハールーン・アッラーシードが即位"],["843年","ヴェルダン条約"],["862年","ノヴゴロド国成立"], ["870年","メルセン条約"],["875年","黄巣の乱"],["907年","朱全忠により唐滅亡し後梁が成立。"],["918年","王建が高麗を建国"],["923年","李存勗が後唐を建国"],];break;
    case "世界史年表11" :item = [ ["926年","契丹が渤海を滅ぼす"],["936年","高麗が朝鮮を統一/後晋を建国"], ["960年","趙匡胤、宋を建国"],["962年","オットー1世即位"], ["987年","カペー王朝が起こる"],["1000年","ハンガリー王国を建国"],["1009年","李朝成立"],["1016年","デーン朝成立"],["1038年","セルジューク朝成立"],["1054年","キリスト教教会の東西分裂"],];break;
    case "世界史年表12" :item = [ ["1066年","ノルマンディー公ウィリアムがイングランド征服"],["1077年","カノッサの屈辱"],["1096年","ウルバヌス2世が第１回十字軍を派遣"], ["1099年","十字軍がエルサレム王国を建てる"],["1115年","金が建国"],["1125年","金により遼が滅亡"],["1127年","高宗が江南に逃れ、南宋成立"],["1142年","南宋と金の紹興の和が成立"],["1143年","ポルトガル王国が成立"],["1147年","第2回十字軍"],];break;
    case "世界史年表13" :item = [ ["1189年","第3回十字軍"],["1202年","第4回十字軍"], ["1204年","第４回十字軍がコンスタンティノープルを占領しラテン帝国を建設"],["1206年","チンギス・ハン即位/奴隷王朝成立"],["1215年","ジョン王が大憲章（マグナ・カルタ）を承認"],["1228年","第5回十字軍"],["1234年","モンゴル帝国が金を滅ぼす"],["1241年","ワールシュタットの戦い"],["1248年","第6回十字軍"],["1260年","フビライ・ハンが即位"],];break;
    case "世界史年表14" :item = [ ["1261年","ラテン帝国滅亡し、ビザンツ帝国復活"], ["1264年","フビライ・ハンが大都に遷都"],["1265年","イギリスで議員制度が始まる"],["1270年","第7回十字軍"],["1271年","フビライ・ハンが国号を元に改める"],["1274年","文永の役"],["1275年","マルコ・ポーロが大都に入る"],["1279年","元が厓山の戦いで南宋を滅ぼす"], ["1281年","弘安の役"],["1295年","エドワード１世が模範議会を召集"],];break;
    case "世界史年表15" :item = [ ["1299年","オスマン＝ベイがオスマン帝国"],["1302年","フィリップ4世が三部会を招集"],["1303年","アナーニ事件"],["1309年","教皇のバビロン捕囚"],["1328年","ヴァロワ朝成立"],["1339年","イギリス・フランス百年戦争"],["1346年","クレシーの戦い"],["1348年","黒死病が広まる"],["1353年","ボッカチオの「デカメロン」完成"], ["1356年","金印勅書"],];break;
    case "世界史年表16" :item = [ ["1368年","朱元璋が即位し、明を建国"],["1370年","ティムール朝が建国"],["1378年","教会分裂"],["1381年","ワット＝タイラーの乱"],["1392年","李成桂が高麗を滅ぼし、朝鮮王朝を建国"],["1399年","靖難の役/ランカスター朝"], ["1402年","明の永楽帝が即位/アンカラの戦い"],["1404年","勘合貿易"], ["1414年","コンスタンツ公会議"],["1419年","フス戦争"],];break;
    case "世界史年表17" :item = [["1429年","ジャンヌ・ダルクがオルレアンを解放/琉球王国建国"],["1453年","ビザンツ帝国の滅亡"],["1455年","バラ戦争"],["1480年","モスクワ大公国独立"],["1488年","バーソロミュー・ディアスが喜望峰に到達"],["1492年","コロンブスがアメリカ大陸を発見"],["1498年","バスコ・ダ・ガマがインド航路を発見"], ["1510年","ポルトガルがインドのゴアを占領"],["1514年","チャルディランの戦い"],["1517年","ルターが九十五ヶ条の論題を発表"],];break;
    case "世界史年表18" :item = [["1524年","ドイツ農民戦争"],["1526年","インドにムガル帝国成立"],["1534年","イエズス会を結成"],["1534年","ヘンリ8世が首長令を制定し、イギリス国教会成立"], ["1538年","プレヴェザの海戦"],["1543年","コペルニクスが「地動説」を唱える"], ["1546年","ドイツでシュマルカルデン戦争"],["1559年","カトー＝カンブレジ条約/エリザベス１世即位"],["1562年","ユグノー戦争"],  ["1568年","ネーデルラント独立戦争"],];break;
    case "世界史年表19" :item = [["1571年","スペインがマニラ市を建設/レパントの海戦"],["1572年","サンバルテルミの虐殺"],["1580年","スペインがポルトガル併合"],["1581年","オランダ独立宣言"],["1582年","グレゴリウス暦を定める"], ["1588年","アルマダ海戦"],["1597年","丁酉の倭乱"],["1598年","ナントの勅令"],["1600年","イギリス東インド会社設立"],  ["1602年","オランダ東インド会社設立"],];break;
    case "世界史年表20" :item = [["1604年","フランス東インド会社設立"],["1609年","ガリレイが天体望遠鏡を発明/ケプラーが『新天文学』発表"], ["1613年","ロマノフ朝始まる"],["1616年","清成立"], ["1618年","三十年戦争"],["1620年","イギリスの清教徒がメイフラワー号で北米に移住"],["1621年","オランダ西インド会社設立"],["1633年","ガリレイの宗教裁判"],["1640年","カタルーニャの反乱"], ["1642年","イギリスでピューリタン革命"],];break;
    case "世界史年表21" :item = [ ["1643年","ルイ１４世が５歳で即位"],["1648年","フランスでフロンドの乱/ウェストファリア条約"],["1652年","英蘭戦争"], ["1659年","ピレネー条約"],["1660年","イギリスの王政が復活"],["1662年","明が滅亡"],["1667年","南ネーデルラント戦争"],["1672年","オランダ侵略戦争"],["1673年","中国で三藩の乱"],["1679年","イギリス議会で人身保護法が成立"],];break;
    case "世界史年表22" :item = [ ["1685年","ルイ14世がナントの勅令を廃止"],["1687年","ニュートンが「万有引力の法則」を発表"],["1688年","イギリスで名誉革命"],["1689年","イギリスで権利章典公布/ウィリアム王戦争/ネルチンスク条約"],["1697年","ライスワイク条約"],["1699年","カルロヴィッツ条約"],["1700年","北方戦争"],["1701年","スペイン継承戦争"],["1702年","アン女王戦争"],["1707年","大ブリテン王国成立"],];break;
    case "世界史年表23" :item = [["1713年","ユトレヒト条約"],["1714年","ラシュタット条約/ハノーヴァー朝成立"],["1726年","スウィフトがガリバー旅行記を刊行"],["1727年","キャフタ条約"],["1733年","ポーランド継承戦争"],["1740年","オーストリア継承戦争"],["1744年","ジョージ王戦争"],["1748年","アーヘンの和約"],["1756年","イギリス・フランス植民地七年戦争"],["1757年","プラッシーの戦い"],];break;
    case "世界史年表24" :item = [ ["1760年","イギリス産業革命"],["1763年","パリ条約/フベルトゥスブルク条約"],["1772年","第１回ポーランド分割"],["1773年","プガチョフの反乱/ボストン茶会事件"],["1775年","アメリカ独立戦争"],["1776年","アメリカ独立宣言"],["1781年","アメリカ合衆国発足/ヨークタウンの戦い"],["1782年","「四庫全書」なる"],["1783年","パリ条約(アメリカの独立を承認)"], ["1789年","ワシントンが初代大統領に就任/フランス革命"],];break;
    case "世界史年表25" :item = [["1791年","ピルニッツ宣言"],["1792年","ヴァルミーの戦い/エカチェリーナ2世がラクスマンを日本に派遣"],["1793年","第２回ポーランド分割/ヴァンデーの反乱"],["1794年","テルミドールの反動"],["1795年","第３回ポーランド分割"],["1796年","白蓮教徒の乱"], ["1799年","ロゼッタ＝ストーン発見/ブリュメール１８日のクーデタ"],["1804年","ナポレオン１世即位"],["1805年","トラファルガーの海戦"],["1806年","神聖ローマ帝国の消滅"],];break;
    case "世界史年表26" :item = [["1807年","ティルジット条約"],["1812年","ナポレオンのロシア遠征/アメリカ・イギリス戦争"],["1813年","ライプチヒの戦"],["1814年","ウィーン会議開催"],["1815年","ドイツ連邦/ウィーン議定書/ワーテルローの戦い"],["1820年","ミズーリ協定成立"],["1821年","ペルー・メキシコ独立宣言"],["1823年","モンロー宣言"],["1825年","ニコライ１世即位/デカブリストの反乱"],["1827年","ナヴァリノの海戦"],];break;
    case "世界史年表27" :item = [["1830年","フランスで七月革命/ベルギー王国独立宣言"],["1831年","マッツィーニが青年イタリア結成"],["1833年","イギリスが奴隷制度を廃止"],["1840年","アヘン戦争"], ["1842年","南京条約"],["1845年","第１次シク戦争"],["1846年","アメリカ＝メキシコ戦争"],["1848年","ゴールド＝ラッシュ始まる/フランス二月革命/マルクスとエンゲルスが共産党宣言"],["1848年","第２次シク戦争/ウィーン三月革命"],["1850年","洪秀全が広西省に挙兵"],];break;
    case "世界史年表28" :item = [ ["1851年","太平天国の乱"],["1853年","クリミア戦争"],["1854年","日米和親条約"], ["1855年","日露和親条約"],["1856年","アロー戦争"],["1858年","日米修好通商条約"],["1859 年","イタリア統一戦争/ダーウィンが進化論を発表"],["1860年","英仏通商条約/英仏軍が北京占領"],["1861年","イタリア王国成立/アメリカ南北戦争"],["1863年","リンカーンが黒人奴隷解放宣言/ゲティスバーグの戦い"],];break;
    case "世界史年表29" :item = [["1866年","普墺戦争"],["1867年","アメリカがロシアよりアラスカを買収"], ["1869年","スエズ運河が開通"],["1870年","普仏戦争"],["1871年","ドイツ帝国成立(ヴィルヘルム1世即位)/パリ・コミューン/日清修好条規"],["1875年","千島・樺太交換条約/イギリスがスエズ運河株買収"],["1876年","日朝修好条規"],["1877年","露土戦争"],["1879年","独墺同盟"],["1881年","イリ条約"],];break;
    case "世界史年表30" :item = [["1882年","ドイツ・オーストリア・イタリアの三国同盟"], ["1884年","清仏戦争"],["1887年","フランス領インドシナ連邦成立"],["1889年","第２インターナショナル結成"],["1895年","ロシア、フランス、ドイツの三国干渉"],["1896年","第１回近代オリンピック"],["1897年","朝鮮王国、国号を大韓帝国に改める"],["1898年","米西戦争/戊戌の政変"],["1899年","第１回ハーグ万国平和会議/アメリカが中国の門戸開放宣言/南アフリカ戦争"],["1900年","義和団事件"],];break;
    case "世界史年表31" :item = [ ["1902年","日英同盟/キューバ共和国独立"],["1903年","パナマ運河条約締結/ライト兄弟が飛行機を発明"],["1904年","日露戦争"],["1905年","ロシアで血の日曜日事件/孫文らが中国革命同盟会を結成/ポーツマス条約/ベンガル分割令"],["1907年","イギリス･フランス･ロシアの三国協商成立"],["1911年","辛亥革命"],["1912年","中華民国成立"], ["1914年","サラエボ事件/第一次世界大戦/パナマ運河開通"],["1915年","日本が中国に二十一か条要求"],["1917年","ロシア革命（三月革命・十一月革命)/文学革命"],];break;
    case "世界史年表32" :item = [ ["1919年","アメリカで禁酒法/中国で五・四運動/中国国民党を結成"],["1920年","ヴェルサイユ条約/国際連盟成立"],["1921年","中国共産党を結成"],["1922年","ワシントン条約/ソビエト社会主義共和国連邦成立"], ["1925年","日ソ基本条約/中国で五・三〇運動"],["1927年","蒋介石の上海クーデター"], ["1928年","パリ不戦条約/スターリンによる第1次5か年計画"],["1929年","世界経済"],["1930年","ロンドン軍縮会議"],["1931年","満州事変"],];break;
    case "世界史年表33" :item = [ ["1932年","満州国建国宣言"],["1933年","ヒトラー内閣成立"],["1934年","ヒトラーが総統となる"],["1936年","西安事件"],["1937年","盧溝橋事件/日中戦争"], ["1938年","ミュンヘン会談"],["1939年","独ソ不可侵条約/第二次世界大戦"],["1940年","日独伊三国同盟"],["1941年","日ソ中立条約/大西洋憲章/太平洋戦争"],["1943年","カイロ会談"],];break;
    case "世界史年表34" :item = [ ["1945年","ドイツの無条件降伏/ポツダム宣言/国際連合成立"],["1946年","インドシナ戦争"], ["1948年","ガンジー暗殺/大韓民国成立/世界人権宣言"],["1949年","北大西洋条約機構/中華人民共和国成立"],["1950年","朝鮮戦争/インドネシア共和国成立"],["1951年","サンフランシスコ講和会議"],["1953年","エジプト共和国成立/朝鮮休戦協定成立"],["1954年","ジュネーブ会議"],["1955年","ワルシャワ条約機構発足"],["1956年","第２次中東戦争(スエズ戦争)"],];break;
    case "世界史年表35" :item = [ ["1959年","キューバ革命/チベット反乱"],["1962年","キューバ危機"],["1963年","ケネディ暗殺"],["1965年","ベトナム戦争"],["1966年","プロレタリア文化大革命"],["1967年","第3次中東戦争"],["1969年","アポロ１１号が初めて月面着陸"],["1973年","第4次中東戦争/第１次石油危機（オイル＝ショック）"],["1976年","東南アジア友好協力条約"],["1978年","日中平和友好条約調印"],];break;
    case "世界史年表36" :item = [ ["1979年","ソ連軍のアフガニスタン侵攻"],["1980年","イラン＝イラク戦争"], ["1986年","チェルノブイリ原発事故"],["1989年","天安門事件/米ソ首脳マルタ会談"],["1990年","東西ドイツが統合"],["1991年","湾岸戦争/ソ連邦解体"],["1993年","マーストリヒト条約"],["1997年","イギリスが中国に香港返還"],["2001年","９.１１同時多発テロ"],["2003年","イラク戦争"]];break;;break;

    case "先史時代1" :item = [["150万年から180万年前頃に出現した人類は?","原人"],["イタリアで発見された新人は？","グリマルディ人"],["中国で発見された新人は？","周口店上洞人"],["20万年前頃に出現した人類は?","ホモ・サピエンス"],["ドイツで見つかった原人は？","ハイデルベルク人"],["クロマニョン人が洞穴壁画を残したフランス西南部の洞窟遺跡は？","ラスコー"],];break;
    case "先史時代2" :item = [["イギリスで新石器時代に作られた巨石建造物は?","ストーンヘンジ"],["500万年前頃に出現した猿人が狩猟・採集生活で使っていた道具は?","打製石器"],["中国で見つかった原人は？","北京原人"],["南フランスで発見された新人は？","クロマニョン人"],["インドネシアで見つかった原人は？","ジャワ原人"],["スペイン北部で、クロマニョン人が洞穴壁画を残した洞窟遺跡は？","アルタミラ"],["7000年前頃に農耕が始まり使われ始めた石器は◯◯石器","磨製石器"],];break;
    case "古代オリエント1" :item = [["シュメール人が作り、粘土板に記した文字は？","楔形文字"],["シュメール人が作った最古の法典は?","ウル・ナンム法典"],["3000bc頃にメソポタミアに都市国家群を建設したのは◯◯人","シュメール人"],["シュメール人が行った、王を中心とする政治は？","神権政治"],["1800bc頃にメソポタミアで制定された復讐法・身分法の原則を持つ法典は?","ハンムラビ法典"],["1800bc頃にメソポタミアを統一したの王は?","ハンムラビ王"],["2000bc頃にメソポタミアに侵入したアムル人が建設したのは?","バビロン第一王朝"],["1650bc頃小アジアのボアズキョイに都を置き国家建設したのは何人?","ヒッタイト"],["1000bc頃にヘブライ人が建設した王国の都は?","エルサレム"],];break;
    case "古代オリエント2" :item = [["1200bcから800bc頃までダマスクスを中心に内陸貿易していたのは何人?","アラム人"],["世界最古の鋳造貨幣が作られた国は?","リディア"],["722bcにアッシリアによって滅ぼされたのは?","イスラエル王国"],["ヘブライ人が作った唯一神ヤハウェを信仰する宗教は?","ユダヤ教"],["新バビロニアがエルサレムの住民をバビロンに強制移住させたことを何という?","バビロン捕囚"],["586bcに新バビロニアによって滅ぼされたのは?","ユダ王国"],["紀元前7世紀前半に全オリエントを支配したのは?","アッシリア"],["アッシリア崩壊後に成立した四王国は?","メディア・リディア・新バビロニア・エジプト"],["550bcにメディアを滅ぼし建国されたのは?","アケメネス朝"],["アケメネス朝で信仰された宗教は?","ゾロアスター教"],];break;
    case "古代オリエント3" :item = [["525bcにエジプトを征服してオリエント古代世界の統一した王は?","カンビュセス二世"],["アケメネス朝でスサとサルデスの間に建設されたものを何という?","王の道"],["ダレイオス一世が新しく建設した都は?","ペルセポリス"],["アケメネス朝で王の道を整備し整えられた交通・通信制度を何という?","駅伝制"],["アケメネス朝の王で新都ペルセポリス造営や各州にサトラップを置いて統治したのは?","ダレイオス一世"],["ダレイオス一世の戦功を記念した磨崖碑文は?","ベヒストゥーン碑文"],["ベヒストゥーン碑文を解読した人物は?","ローリンソン"],["330bcにアケメネス朝を滅ぼしたのは?","アレクサンドロス大王"],["アレクサンドロスの死後に西アジアを支配下に入れた王朝は?","セレウコス朝"],];break;
    case "古代オリエント4" :item = [["248bc頃にセレウコス朝から独立しローマ帝国と抗争したのは?","パルティア"],["セレウコス朝から独立したギリシア系の王国は?","バクトリア"],["224年にアルダシール1世がパルティアを倒して建設した王朝は?","ササン朝"],["3世紀前半に成立した、ゾロアスター教・キリスト教・仏教が融合した宗教は?","マニ教"],["6世紀頃に、ササン朝のホスロー1世が突厥と結んで滅ぼしたのは?","エフタル"],["ササン朝二代目で、ローマ皇帝を捕虜にした人物は?","シャープール一世"],["642年のササン朝とイスラム教徒との戦いは?","ニハーヴァンドの戦い"],["ゾロアスター教の聖典を何という?","アヴェスター"],];break;
    case "古代エジプト1" :item = [["「エジプトはナイルのたまもの」という言葉を残した歴史家は?","ヘロドトス"],["2700bc頃のピラミッドを建てたエジプト古王国の都は?","メンフィス"],["3000bc頃のエジプトでは王は何と呼ばれていた?","ファラオ"],["世界最古の表音文字でアルファベットの起源となった文字は?","フェニキア文字"],["下エジプトを征服して全エジプトを統一したのは?","ネメス"],["20世紀にカーターとカーナヴォンが発掘した遺跡は?","ツタンカーメン王の遺跡"],["2100bc頃のエジプト中王国の都は?","テーベ"],["1400bc頃のエジプト新王国で、唯一神アトンの信仰を強制した人物は?","アメンホテプ4世"],["古代エジプト人が『肉体は滅んでも霊魂は生き続ける』と信じて作ったものは?","ミイラ"],];break;
    case "古代エジプト2" :item = [["古代エジプトの太陽暦がローマに伝わって出来たのは?","ユリウス暦"],["エジプト中王国に侵入し滅ぼしたアジア系民族は?","ヒクソス"],["古代エジプトで生まれた暦は?","太陽暦"],["1200bc以降に地中海東岸中部に植民市を建設し、地中海貿易に従事したのは何人?","フェニキア人"],["1400bc頃のエジプトで生まれた写実的な美術は?","アマルナ美術"],["ナポレオンが見つけ、神聖文字の解読の手がかりとなったものは?","ロゼッタストーン"],["1300bc頃にモーセにひきいられてエジプトを脱出したのは何人?","ヘブライ人"],["古代エジプト人が死者が死後の世界に行く時に持っていく為に、生前の善行などを記しておいたものは?","死者の書"],];break;
    case "古代ギリシア1" :item = [["2000bcから1400bc頃、クノッソス宮殿を中心に栄えた文明は?","クレタ文明"],["シュリーマンがホメロスの叙事詩『イーリアス』をヒントに発掘した遺跡は?","トロイ遺跡"],["1900年にエヴァンズが発掘したクレタ文明の中心地の遺跡は?","クノッソス宮殿"],["古代ギリシアのポリスで、神殿や砦が築かれた小高い丘を何という?","アクロポリス"],["古代ギリシアのポリスで、市民が所有した私有地のことを何という?","クレーロス"],["1600bcから1200bc頃にミケーネ・ティリンスを中心にアカイア人が築いた青銅器文化は?","ミケーネ文明"],["621bcにアテネで制定された市民に厳しいが市民間における法の平等が実現したものは?","ドラコンの成文法"],["800bc頃のアテネを建設したのは何人?","イオニア人"],["古代ギリシア人が自己の民族を何と呼んだ?","ヘレネス"],["古代ギリシア人が自己の民族の住む土地を何と呼んだ?","ヘラス"],];break;
    case "古代ギリシア2" :item = [["古代ギリシアのポリスで、民会の開催場所となった広場を何という?","アゴラ"],["古代ギリシア人が異民族の総称として用いたの名称は?","バルバロイ"],["594bcにアテネで財産政治を行う改革を行うようにした調停者は?","ソロン"],["アテネの紀元前5世紀半ば頃の指導者で、民会を国政の最高機関として民主主義を完成させたのは人物は?","ペリクレス"],["500bc頃のスパルタがアテネと対立するのに率いていた同盟は?","ペロポネソス同盟"],["スパルタで被征服民のことを何と呼んだ?","ヘイロータイ"],["431bcに始まったアテネとスパルタとの戦いは?","ペロポネソス戦争"],["紀元前6世紀後半にアテネで非合法手段で政権を獲得した僭主は?","ペイシストラトス"],["478bcにアテネが盟主となって結成された同盟を何という?","デロス同盟"],["500bc、アケメネス朝に対するイオニア植民市の反乱にアテネが支援したことから始まった戦いは?","ペルシア戦争"],["第一回ペルシア戦争でギリシア本出に遠征軍を派遣したペルシアの人物は?","ダレイオス一世"],];break;
    case "古代ギリシア3" :item = [["第二回ペルシア戦争で、アテネの重装歩兵部隊がペルシア軍に勝った戦いは?","マラトンの戦い"],["第三回ペルシア戦争で、ペルシアがテミストクレス率いるアテネ海軍に敗北した戦いは?","サラミスの海戦"],["第三回ペルシア戦争で、20万のペルシア軍にスパルタ軍は300人で対抗して破れた戦いは?","テルモピレーの戦い"],["338bcに全ギリシアを制圧したマケドニアの王は?","フィリッポス2世"],["古代のギリシアで、重要な決定もこの神託によって決められるようになった権威のある神託は?","デルフォイの神託"],["フィリッポス2世の息子で東方遠征をはじめてアケメネス朝を滅ぼし大帝国を作った人物は?","アレクサンドロス大王"],["古代ギリシアの女流叙情詩人で恋愛詩を歌ったのは?","サッフォー"],["アレクサンドロス大王の東方遠征の開始からプトレマイオス朝エジプトの滅亡までの時代を何という?","ヘレニズム時代"],["叙事詩「労働と日々」を作ったのは?","ヘシオドス"],["ギリシアの哲学者で客観的真理の存在と知徳合一を説いたが誤解されて刑死したのは?","ソクラテス"],];break;
    case "古代ギリシア4" :item = [["トロイア戦争を題材に叙事詩の「イリアス」や「オデュッセイア」を作ったのは?","ホメロス"],["ソクラテスの弟子でイデア論を唱えたギリシアの哲学者は?","プラトン"],["弁論や修辞の職業教師で相対主義を唱えたギリシアの人物は?","ソフィスト"],["ペルシア戦争を記述したギリシアの歴史家は?","ヘロドトス"],["古代ギリシアの喜劇作家で「女の平和」などの作品がある人物は?","アリストファネス"],["プラトンの弟子でイスラム哲学やスコラ哲学に影響を与えたギリシアの哲学者は?","アリストテレス"],["アテネ指導者のペリクリスと親交があり、パルテノン神殿建築の総監督を務めたのは?","フェイディアス"],["ペロポネソス戦争を記述したギリシアの歴史家は?","トゥキディデス"],["古代ギリシアの三大悲劇詩人の一人で「メディア」などの作品がある人物は?","エウリピデス"],["古代ギリシアの三大悲劇詩人の一人で「アガメムノン」などの作品がある人物は?","アイスキュロス"],];break;
    case "古代ギリシア5" :item = [["古代ギリシアの哲学者で「万物の根源は水」とした人物は?","タレス"],["古代ギリシアの三大悲劇詩人の一人で「オイディプス王」などの作品がある人物は?","ソフォクレス"],["古代ギリシアの哲学者で「万物の根源は火」とした人物は?","ヘラクレイトス"],["ヘレニズム文化期にゼノンが説いた禁欲重視の哲学の派閥を何という?","ストア派"],["古代ギリシアの哲学者で「万物の根源は数」とした人物は?","ピタゴラス"],["ヘレニズム文化期に精神的快楽を重視した哲学の派閥をなんという?","エピクロス派"],["古代ギリシアの哲学者で原子論を確立した人物は?","デモクリトス"],["ヘレニズム文化期に平面幾何学を完成させた人物は?","エウクレイデス"],["ヘレニズム文化期に子午線の長さを測定した人物は?","エラトステネス"],["ヘレニズム文化期に地動説を唱えた人物は?","アリスタルコス"],];break;
    case "古代ローマ1" :item = [["紀元前6世紀末のローマでエルトリア人の王を追放して始まった政治形態は?","共和政"],["500bc頃の共和政ローマで平民保護のために設置されたものは?","護民官"],["紀元前5世紀半ば頃の共和政ローマで慣習法を成文法化して成立したのは?","十二表法"],["共和政ローマで中小農民が主体となって従軍し国防の重要な役割をした兵は?","重装歩兵"],["287bcの共和政ローマで成立した貴族と平民の法的平等が実現することになった法は?","ホルテンシウス法"],["264bcに始まった共和政ローマとフェニキア人の植民市カルタゴとの戦いは?","ポエニ戦争"],["367bcの共和政ローマで成立した執政官の1名を平民から選ぶことなどを定めたものは?","リキニウス・セクスティウス法"],["第1回ポエニ戦争で勝利したローマが最初の属州にしたのはどこ?","シチリア島"],["紀元前2世紀後半の共和政ローマで相次いで護民官に就任し、自作農の創設を図ったが暗殺された兄弟は?","グラックス兄弟"],["紀元前の共和政ローマの中小農民没落した原因の一つの奴隷制大農場のことを何という?","ラティフンディア"],];break;
    case "古代ローマ2" :item = [["紀元前31年にプトレマイオス朝のクレオパトラと結託したアントニウスをオクタウィアヌスが破った戦いは?","アクティウムの海戦"],["紀元前の共和政ローマで、カエサル,ポンペイウス,クラッススが協力して元老院をおさえて行った政治は?","第1回三頭政治"],["27bcにオクタウィアヌスが元老院から受けた称号は?","アウグストゥス"],["紀元前の共和政ローマで、オクタウィアヌスやアントニウスやレピドゥスによって行われた政治は?","第2回三頭政治"],["西ローマ帝国滅亡の背景となったラティフンディアにかわるコロヌスを使役して行う土地経営のとを何という?","コロナートゥス"],["アウグストゥスから五賢帝時代までのローマの最盛期をなんという?","ローマの平和"],["313年にローマ帝国皇帝コンスタンティヌス帝がキリスト教を公認した勅令を何という?","ミラノ勅令"],["3世紀末のローマ帝国皇帝で専制君主制を敷き、帝国の4分統治を実施したのは?","ディオクレティアヌス"],["キリスト教の教父と呼ばれる学者で「告白録」「神の国」を著したのは?","アウグスティヌス"],["ローマ帝国が最大領土を持っていたの時の皇帝は?","トラヤヌス"],["325年にローマ帝国皇帝コンスタンティヌス帝が開きキリスト教の正統をアタナシウス派と決めたのは?","ニケーア公会議"],];break;
    case "古代ローマ3" :item = [["476年に西ローマ帝国はゲルマン人傭兵隊長の誰に滅ぼされた?","オドアケル"],["431年に行われたネストリウス派を異端とした会議をなんという?","エフェソス公会議"],["古代ローマの詩人で叙事詩「アエネイス」などの作品がある人物は?","ウェルギリウス"],["6世紀にローマ法の集大成である「ローマ法大全」を編纂させた東ローマ皇帝は?","ユスティニアヌス"],["ローマ共和制期の政治家で「ローマ史」の著作がある人物は?","ポリビオス"],["古代ローマの政治家・雄弁家であり、「国家論」などの著作がある人物は?","キケロ"],["帝政ローマ時代の政治家で「ゲルマニア」「年代記」の著作がある人物は誰?","タキトゥス"],["ローマ最古の石舗装された軍道を何という?","アッピア街道"],["ゲルマン人の風習や社会を知る重要資料となっている「ガリア戦記」の著者は誰?","カエサル"],["アウグストゥス時代の政治家で「ローマ建国史」の著作がある人物は?","リウィウス"],["帝政ローマ時代の哲学者で「対比列伝」の著作がある人物は?","プルタルコス"],];break;
    case "古代インド1" :item = [["インダス文明を作ったと推定されているのは何人?","ドラヴィダ人"],["2300bc頃のインダス文明の代表的遺跡でインダス川の上・中流にある遺跡をなんとい?","ハラッパー"],["カースト制度の庶民層のことを何という?","ヴァイシャ"],["2300bc頃のインダス文明の代表的遺跡でインダス川下流にある遺跡をなんという?","モヘンジョ・ダロ"],["カースト制度の武士・貴族層のことを何という?","クシャトリヤ"],["1500bc頃インド北西部に侵入を開始した、インド・ヨーロッパ系の人々を何という?","アーリヤ人"],["カースト制度の司祭層のことを何という?","バラモン"],["アーリヤ人が自然現象を神として崇拝して様々な神への賛歌と儀礼をまとめたものをなんという?","ヴェーダ"],["カースト制度の奴隷民のことを何という?","シュードラ"],];break;
    case "古代インド2" :item = [["ヴェーダを根本聖典とし、カースト制度の司祭層が祭儀を司る宗教を何という?","バラモン教"],["ヴェーダの最古のものを何という?","リグ=ヴェーダ"],["ヴェーダの一つで、世界最古の思弁的哲学と呼ばれるものは?","ウパニシャッド"],["シャカ族の王子で、カースト制度を否定し人間の平等を説き仏教を開いたのは誰?","ガウタマ・シッダールタ"],["500bc頃にジャイナ教を開いた人物は?","ヴァルダマーナ"],["317bc頃インド史上初の統一国家マウリヤ朝を建国した人物は?","チャンドラグプタ"],["500bc頃北インドでコーサラ国を併合した国は?","マガダ国"],["マウリヤ朝の都は?","パータリプトラ"],["アショーカ王の行った第3回仏典結集で確立した個人の救済を目的とした仏教を何という?","上座部仏教"],];break;
    case "古代インド3" :item = [["マウリヤ朝の第三代で、南端部を除き全インドを統一した人物は?","アショーカ王"],["クシャーナ朝のもとで生まれた菩薩信仰を中心に万民の救済を目的とした宗教は?","大乗仏教"],["代表にアジャンターやエローラの石窟寺院がある準インド的な美術様式を何という?","グプタ様式"],["クシャーナ朝が都をおいた場所は?","プルシャプラ"],["サンスクリット語の文学で戯曲「シャクンタラー」を著した人物は?","カーリダーサ"],["大乗仏教の理論を確立した人物は?","ナーガールジュナ"],["古代インドの法典で社会的規範や宗教的義務を定めたものは?","マヌ法典"],["グプタ朝時代に設立されたインド仏教の拠点となった施設は?","ナーランダー僧院"],["4世紀前半にパータリプトラを都としてグプタ朝をたてた人物は?","チャンドラグプタ1世"],];break;
    case "古代インド4" :item = [["バラモン教に民間信仰や仏教の要素を取り入れて成立したものは?","ヒンドゥー教"],["グプタ朝の全盛期の王で、中国で超日王として知られる人物は?","チャンドラグプタ2世"],["チャンドラグプタ2世を訪れて、「仏国記」を著した東晋僧は?","法顕"],["グプタ朝を6世紀半ばに滅ぼした遊牧民は?","エフタル"],["南インドで100bcから300年にローマとの交易で栄えた王朝は?","サータヴァーハナ朝"],["南インドで宋と交流し東南アジアに遠征した王朝は?","チョーラ朝"],["7世紀初め北インドを統一しヴァルダナ朝を建設したのは?","ハルシャ・ヴァルダナ"],["ヴァルダナ朝のハルシャ・ヴァルダナを陸路で訪れた唐僧は?","玄奘"],];break;
    case "古代東南アジア1" :item = [["400bc頃の北部ベトナムで現れた中国文化の影響で青銅器や鉄器を使用する文化は?","ドンソン文化"],["1世紀頃、メコン川下流で成立し海上貿易で栄えた国は?","扶南"],["インドシナ半島東南部のチャム人が2世紀末に後漢から独立して作られた国は?","チャンパー"],["6世紀にカンボジアでクメール人が建国した国は?","真臘"],["8世紀半ば、ジャワ島中部に成立し、大乗仏教を保護した国は?","シャイレンドラ朝"],["ベトナムで1009年に成立し、中国文化を受け入れた国は?","李朝"],["11世紀にミャンマー人が建国した上座部仏教が盛んだった国は?","パガン朝"],["7世紀のスマトラに成立した国家を何という?","シュリーヴィジャヤ王国"],["カンボジアで12世紀にスールヤヴァルマン2世によって建設されたヒンドゥー寺院は?","アンコールワット"],["ベトナムで1225年に成立し元の侵攻を撃退した国は?","陳朝"],["シュリーヴィジャヤに滞在した唐僧で「南海寄帰内法伝」を著した人物は?","義浄"],["陳朝で作られた民族文字を何という?","字喃（チュノム）"],];break;
    case "古代南北アメリカ1" :item = [["インカ文明が数量を表すのに文字の代わりに用いたのは?","キープ"],["4から9世紀ごろユカタン半島で最盛期を迎えた文明は?","マヤ文明"],["現在のメキシコシティの北東部に栄えた大ピラミッド神殿を特徴とする文明をなんという?","テオティワカン文明"],["14世紀ごろメキシコで成立した国家を何という?","アステカ王国"],["南アメリカで1200年頃成立し、15世紀には高度な石造技術でマチュピチュを建設した大帝国は?","インカ帝国"],];break;
    case "中国(先史~漢)1" :item = [["5000bc～4000bc頃の黄河中域で使われた彩文土器を何という?","彩陶"],["1600bc頃に黄河中下流域に出現した、現在確認できる中国最古の王朝を何という?","殷"],["中国の春秋戦国時代に性悪説を説いた思想家は?","荀子"],["2000bc～1500bc頃の黄河中域で作られた黒色磨研土器を何という?","黒陶"],["中国の殷で占いに使われ漢字の起源になった亀甲などに刻まれた象形文字を何という?","甲骨文字"],["中国の春秋戦国時代に性善説を説いた思想家は?","孟子"],["1100bc頃に殷を滅ぼして華北地域を支配した国家は?","周"],["中国の春秋後期にあらわられた人物で、周の「礼」を理想として、「仁」の実践を説いた人物は?","孔子"],["周代に行われた氏族制的な政治形態を何という?","封建制"],];break;
    case "中国(先史~漢)2" :item = [["儒家を批判し兼愛という無差別の愛を説いた思想家は?","墨子"],["800bc頃、異民族に鎬京を攻略された周が遷都した都市は?","洛邑"],["800bc頃、異民族に攻略された周の都は?","鎬京"],["中国の周の東遷から403bcまでの期間をなに時代という?","春秋時代"],["法治主義を唱えて、法家と呼ばれた人物は?(2人)","韓非/商鞅"],["法治主義と呼ばれる商鞅などの思想を採用して中国を統一した国家は？","秦"],["中国の403bcから221bcまでの期間をなに時代という?","戦国時代"],["秦の始皇帝による思想言論の弾圧政策はなに?","焚書坑儒"],["秦の始皇帝によって作られた辺境防衛のための建築物は?","万里の長城"],];break;
    case "中国(先史~漢)3" :item = [["秦の統治政策で全国を36群にわけ、中央から地方官を派遣し直轄地とした制度を何という?","郡県制"],["202bcに建国された漢（前漢）の都はどこ?","長安"],["前漢の武帝が匈奴挟撃のために139bcに大月氏国へ派遣された人部は誰?","張騫"],["202bcに漢（前漢）を建国したのは誰?","劉邦"],["前漢の統治政策で、郡県制と封建制の併用で統治した制度を何という?","郡国制"],["前漢の武帝の物価調整政策で物価が下がった時に政府が購入し上昇した時に売却して価格調整する法律を何という?","平準法"],["前漢の武帝の物価調整政策で各地の特産物を強制的に徴収し売却することで価格調整する法律を何という?","均輸法"],["前漢の武帝の時代の地方長官の推薦による官吏登用方法を何という?","郷挙里選"],["前漢の武帝に儒教の官学化を献策したのは誰?","董仲舒"],];break;
    case "中国(先史~漢)4" :item = [["前漢の武帝に仕え、歴史を紀伝体で記した「史記」を編纂したのは誰?","司馬遷"],["8年に前漢を倒して長安に都を置き新を建国したのは誰?","王莽"],["後漢時に前漢の歴史を紀伝体で記した「漢書」を編纂したのは誰?","班固"],["中国の新が滅亡するきっかけとなった農民の反乱を何という?","赤眉の乱"],["後漢の班固が編纂した前漢の正史を何という?","漢書"],["後漢の蔡倫が改良したものは?","製紙法"],["後漢の鄭玄が大成した古典の解釈を行う学問は?","訓詁学"]];break;;break;
    case "中国(魏晋南北朝)1" :item = [["220年に中国で魏を建国した人物は?","曹丕"],["221年に中国で蜀を建国した人物は?","劉備"],["222年に中国で呉を建国した人物は?","孫権"],["中国で265年に西晋を建国した人物は?","司馬炎"],["晋で起きた一族の争いを何という?","八王の乱"],["晋の一族で江南にのがれ東晋を建国したのは?","司馬睿"],["中国で304年から439年の多種の国家が興亡した時代のことを何という?","五胡十六国時代"],["華北を統一して北魏を建国したのは何族の誰?","鮮卑族の拓跋氏"],["5世紀後半に均田制や三長制を導入した北魏の人物は?","孝文帝"],];break;
    case "中国(魏晋南北朝)2" :item = [["三国時代の魏で行われた土地政策を何という?","屯田制"],["三国時代の魏で行われた郷挙里選にかえて行われた官吏任用制度は?","九品中正"],["東晋の僧で、「仏国記」を著した人物は?","法顕"],["北魏で行われた土地政策を何という?","均田制"],["梁の昭明太子が編纂したもの詩文集は?","文選"],["東晋の詩人で「帰去来辞」や「桃花源記」などの作品がある人物は?","陶潜"],["東晋の書家で書聖と呼ばれ「蘭亭序」などの作品がある人物は?","王羲之"],["4世紀初めに楽浪郡を滅ぼし朝鮮半島北部を支配した国は?","高句麗"],["東晋の画家で画聖と呼ばれ「女史箴図」などの作品がある人物は?","顧愷之"],];break;
    case "中国(隋と唐)1" :item = [["南朝の陳を倒して中国を統一し隋を建国した人物は?","楊堅"],["随が導入した西魏から受け継いだ兵制は?","府兵制"],["随の文帝が新しく造営した都を何という?","大興城"],["随が導入した税制は?","租庸調制"],["随の2代目皇帝は?","煬帝"],["随が導入した官吏任官制度は?","科挙"],["随が滅亡する原因ともなる遠征失敗はどこへの遠征?","高句麗"],["随を破り唐を建国した人物は?","李淵"],["唐の二代目皇帝で中国を統一した人物は?","李世民"],["唐の首都はどこ?","長安"],["唐の時代に「五経正義」を編纂した主な人物は?","孔穎達"],];break;
    case "中国(隋と唐)2" :item = [["唐の第3代高宗が668年に滅ぼした国は?","高句麗"],["唐の時代の詩人で「詩聖」と称されている人物は?","杜甫"],["唐の時代の詩人で「詩仙」と称されている人物は?","李白"],["唐の時代の詩人で「長恨歌」などの作品がある人物は?","白居易"],["高句麗が滅亡した後に中国東北地方に建国された国は?","渤海"],["唐と連合し百済・高句麗を滅ぼした国は?","新羅"],["唐の高宗の皇后で国号を周としたのは?","則天武后"],["新羅の氏族的身分制度のことを何という?","骨品制"],["7世紀のチベットでソンツェン・ガンポが建国した国は?","吐蕃"],];break;
    case "中国(隋と唐)3" :item = [["唐の節度使が地方の行政や財政を握って何と言われるようになった?","藩鎮"],["8世紀初めに唐の皇帝に即位して開元の治とよばれる政治を行った人物は?","玄宗"],["唐の募兵制によって集められた指揮官のことを何という?","節度使"],["8世紀半ばに唐の節度使だった安禄山が起こした反乱は?","安史の乱"],["780年に唐が制定した所有する土地に応じて年二回課税する税を何という?","両税法"],["907年に唐を滅ぼした節度使は誰?","朱全忠"],["世紀後半の唐で塩の密売人が起こした大規模な反乱は?","黄巣の乱"],];break;
    case "中世(アジア)1" :item = [["10世紀前半に朝鮮半島で王建が作った国は?","高麗"],["10世紀前半に雲南で成立した国は?","大理"],["10世紀初めにモンゴルで遼を建国した人物は?","耶律阿保機"],["10世紀初めにモンゴルで遼を建国した民族は?","契丹"],["高麗の首都は?","開城"],["11世紀前半にベトナムで李氏が建国した国は?","大越国"],["960年に宋を建国した人物は?","趙匡胤"],["1004年遼と北宋との間で結ばれた盟約は?","セン淵の盟"],];break;
    case "中世(アジア)2" :item = [["11世紀に宋の宰相に起用され新法とよばれる政治改革を行ったのは?","王安石"],["1044年に宋と西夏との間で結ばれた和約は?","慶暦の和約"],["11世紀初めに中国西北部で西夏を建国した人物は?","李元昊"],["11世紀初めに中国西北部でチベット系タングート族が建国した国は?","西夏"],["12世紀初めに中国東北部で女真が完顔阿骨打を皇帝として建国した国は?","金"],["11世紀に宋の宰相に起用された王安石の改革で物資の安定と物価の安定を測ったもの法は","均輸法"],["女真の独自の軍事・社会組織を何という?","猛安・謀克"],["11世紀に宋の宰相に起用された王安石の改革で中小の商人から物資を買い上げて、低利で資金を融資する法は?","市易法"],];break;
    case "中世(アジア)3" :item = [["11世紀に宋の宰相に起用された王安石の改革で中小の農民に低利で銭や穀物を貸し付けた法は?","青苗法"],["金に滅ぼされた宋が逃れて建国された南宋の都は?","臨安"],["儒教の新しい学問体系の朱子学を集大成した人物は?","朱熹"],["宋学の租とよばれる人物は?","周敦頤"],["編年体の中国通史「資治通鑑」を製作した人物は?","司馬光"],["13世紀のタイで建国された最初のタイ人の王朝は?","スコータイ朝"],["1351年にスコータイ朝を滅ぼしてタイに成立した王朝は?","アユタヤ朝"],];break;
    case "中世(モンゴル)1" :item = [["紀元前6世紀ごろに南ロシアの草原地帯に遊牧国家を建国した民族は?","スキタイ"],["紀元前4世紀以降頃に陰山山脈に建国された国は?","匈奴"],["漢の高祖を屈服させるなど紀元前3世紀末に即位した匈奴の全盛期の時の王は?","冒頓単干"],["6世紀に建国された中国東北部から中央アジアを支配した国は何?","突厥"],["751年に起きた中央アジアのイスラーム化が本格化するきっかけとなった戦いは?","タラス河畔の戦い"],["8世紀頃トルコ系で東突厥を滅ぼして建国されたマニ教を信仰する国は?","ウイグル"],["10世紀半ばに建国された中央アジアで初のトルコ系イスラム王朝は?","カラハン朝"],["1206年に諸部族を統一してモンゴル帝国を成立させた人物は?","チンギス・ハン"],["モンゴル帝国2代目の皇帝は?","オゴタイ・ハン"],];break;
    case "中世(モンゴル)2" :item = [["オゴタイ・ハンの命を受けてヨーロッパ遠征をした人物は?","バトゥ"],["バトゥがドイツ・ポーランドの連合軍を破った戦いは?","ワールシュタットの戦い"],["モンゴル帝国から独立した3ハン国のうち中央アジアに出来た国は?","チャガタイ・ハン国"],["モンゴル帝国から独立した3ハン国のうち南ロシアに出来た国は?","キプチャク・ハン国"],["1258年にバグダードを占領しアッバース朝を滅ぼしたモンゴル軍の人物は?","フラグ"],["モンゴル帝国から独立した3ハン国のうちイランに出来た国は?","イル・ハン国"],["モンゴル帝国5代皇帝でカラコルムから大都に遷都して、国名を元とし中国を統一した人物は?","フビライ=ハン"],["フビライ=ハンのベトナム遠征を撃退した王朝は?","陳朝"],["フビライ=ハンが1279年に滅ぼした国は?","南宋"],];break;
    case "中世(モンゴル)3" :item = [["モンゴル帝国に訪問したローマ教皇の使節は?","プラノ=カルピニ"],["モンゴル帝国に訪問し「東方見聞録」を口述したヴェネツィア商人は?","マルコ=ポーロ"],["元が優遇した中央アジアや西アジア系民族は何人?","色目人"],["モンゴル帝国に訪問したルイ9世の使節は?","ルブルック"],["13世紀末に元の大都でカトリックを布教した人物は?","モンテ=コルヴィノ"],["元の時代の庶民文化で、「漢宮秋」「西廂記」などが代表の庶民向け戯曲を何という?","元曲"],["14世紀頃のモロッコの旅行家で「三大陸周遊記」を口述した人物は?","イブン=バットゥータ"],["元の郭守敬などによって作られた暦法を何という?","授時暦"],];break;
    case "中世(イスラム)1" :item = [["イスラム教の唯一神をなんという?","アッラー"],["610年頃イスラム教の布教活動を始めたクライシュ族出身の商人は?","ムハンマド"],["622年にムハンマドが信者を連れて移住したの場所は?","メディナ"],["暗殺された第4代カリフは?","アリー"],["ムアーウィヤがカリフとなり成立したイスラム王朝は?","ウマイヤ朝"],["アリーとその子孫だけをカリフと認める一派を何という?","シーア派"],["ウマイヤ朝の都は?","ダマスクス"],["イスラム諸王朝における人頭税のことを何という?","ジズヤ"],["代々のカリフを認めるイスラム教の多数を占める一派を何という?","スンナ派"],];break;
    case "中世(イスラム)2" :item = [["イスラムにおける地租的な税のことを何という?","ハラージュ"],["732年にウマイヤ朝がフランク王国に侵入し、敗れた戦いは?","トゥール・ポワティエ間の戦い"],["750年成立しアラブ人の特権を廃してイスラーム法にもとづいて統治しイスラーム帝国と呼ばれる王朝は?","アッバース朝"],["アッバース朝全盛期の頃の第5代カリフは?","ハールーン=アッラシード"],["アッバース朝の主都は?","バグダード"],["756年にイベリア半島に成立した王朝は?","後ウマイヤ朝"],["ファーティマ朝が969年にエジプトを征服し建設した新首都は?","カイロ"],["10世紀初めにチュニジアに成立したシーア派の王朝は?","ファーティマ朝"],["962年に成立し北インドに侵入したトルコ系王朝は?","ガズナ朝"],["10世紀半ばに中央アジアに成立した初のトルコ系イスラーム王朝は?","カラ=ハン朝"],];break;
    case "中世(イスラム)3" :item = [["1038年に中央アジアに成立したトルコ系の王朝は?","セルジューク朝"],["セルジューク朝が1055年に滅ぼした王朝は?","ブワイフ朝"],["ブワイフ朝が創始した、軍人の俸給額に応じて分与地の徴税権を付与した制度は?","イクター制"],["セルジューク朝がブワイフ朝を倒したことにより手に入れた称号は?","スルタン"],["モロッコで1056年に成立したベルベル人の王朝は?","ムラービト朝"],["イル=ハン国最盛期の人物でイスラーム教の国教化を行った人物は?","ガザン=ハン"],["イベリア半島のナスル朝のグラナダのスペイン・イスラーム文化を代表する建築物は?","アルハンブラ宮殿"],["エジプトで1169年にアイユーブ朝を建てた人物は?","サラディン"],["1148年ごろに成立し北インドに侵入したイラン系王朝は?","ゴール朝"],];break;
    case "中世(イスラム)4" :item = [["エジプトで1250年に成立した王朝は?","マムルーク朝"],["モロッコで、ムラービト朝を滅ぼし、イベリア半島に進出した王朝は?","ムワッヒド朝"],["イスラームの礼拝堂のことを何という?","モスク"],["13世紀に成立したインド初のイスラーム王朝は?","奴隷王朝"],["「医学典範」の著者でアリストテレス研究の哲学者でもある人物は?","イブン=シーナー"],["「世界史序説」で歴史発展の法則性を説いた人物は?","イブン=ハルドゥーン"],["11世紀のペルシアの詩人で「ルバイヤート」などの作品がある人物は?","ウマル=ハイヤーム"],["モロッコの旅行家で中国まで旅行し「三大陸周遊記」を著した人物は?","イブン=バットゥータ"],];break;
    case "中世(西ヨーロッパ・前半)1" :item = [["5世紀前半にフン人を統合して大帝国を築いた人物は?","アッティラ王"],["ゲルマン人の大移動の原因となった西進してきたのはアジア系の民族は何人?","フン人"],["ゲルマン諸族が415年にイベリア半島に建設した国は?","西ゴート王国"],["ゲルマン諸族が429年に北アフリカに建設した国は?","ヴァンダル王国"],["493年にテオドリックがイタリアに建設した国は?","東ゴート王国"],["原始のゲルマン人が重要問題を決めていた成年男性自由人の集会を何という?","民会"],["ゲルマン諸族が東ゴート王国の故地に北イタリアに建設した国は?","ランゴバルド王国"],["西ローマ帝国を滅ぼした傭兵隊長は?","オドアケル"],["732年にウマイヤ朝がフランク王国に侵入し、敗れた戦い?","トゥール・ポワティエ間の戦い"],["フランク王国の初代の王は?","クローヴィス"]];break;;break;
    case "中世(西ヨーロッパ・前半)2" :item = [["732年ウマイヤ朝のイスラーム軍をトゥール・ポワティエ間の戦いで破ったフランク王国の人物は?","カール・マルテル"],["クローヴィス がフランク王国にて創始した最初の王朝を何という?","メロヴィング朝"],["カール・マルテルの子のピピン3世が作った王朝は?","カロリング朝"],["フランク王国の王クローヴィスはアリウス派から何に改宗した?","アタナシウス派"],["ピピン3世のカロリング朝が教皇にラヴェンナ地方を寄進したことが起源となっているものは?","教皇領"],["ピピン3世の子で、アヴァール人やイスラーム教徒を撃退し、西ヨーロッパの主要部を統一した人物は?","カール大帝"],["800年にカール大帝に帝冠を与えた教皇は?","レオ3世"],["843年、フランク王国を分裂することを定めた条約は?","ヴェルダン条約"],["ロシアにて862年にノウマン人の一派のルーシが建国したのは?","ノヴゴロド国"],["870年のフランク王国の領土の再画定を定めた条約は?","メルセン条約"]];break;;break;
    case "中世(西ヨーロッパ・前半)3" :item = [["ロシアにて882年にノヴゴロト国の一派が南下して建国したのは?","キエフ公国"],["キエフ公国の最盛期の王で、ギリシア正教に改宗した人物は?","ウラディミル1世"],["911年にロロが率いる一派が北イタリアに建国したのは?","ノルマンディー公国"],["962年オットー1世がマジャール人を退け東フランクで成立させた国家は?","神聖ローマ帝国"],["イングランドで、1066年にノルマンディー公ウィリアムがアングロ=サクソン人を征服し建国されたのは?","ノルマン朝"],["西ヨーロッパの10~11世紀の封建制度の起源となったものの一つで、ローマ末期の制度は?","恩貸地制度"],["1077年に神聖ローマ皇帝ハインリヒ4世が聖職叙任権の争いで敗れ、ローマ教皇グレゴリウス7世に謝罪した事件を何という?","カノッサの屈辱"],["西ヨーロッパの10~11世紀の封建制度の起源となったものの一つで、ゲルマン人の制度は?","従土制"],["グレゴリウス7世の出身の修道院を何という?","クリュニー修道院"],["西ヨーロッパの封建制度の経済的基礎となる荘園制度で、君主から保証された所領内で裁判や課税について国王の関与を拒否する権利を何という?","不輸不入権"],["イギリスのジョン王を破門するなどし、教皇の権力の絶頂に到達した時の教皇は?","インノケンティウス3世"],];break;
    case "中世(西ヨーロッパ・後半)1" :item = [["イベリア半島で8世紀頃からおこなわれたイスラーム勢力の駆逐活動のことを何という?","レコンキスタ（国土回復運動）"],["1016年にイングランドを征服したクヌートが開いた国家は?","デーン朝"],["1095年に教皇ウルバヌス2世が招集して開いた会議で十字軍の結成・派遣などを決定したものは何?","クレルモン宗教会議"],["第一回十字軍が聖地を奪回し樹立されたキリスト教王国は?","イェルサレム王国"],["クレルモン宗教会議を招集し十字軍の結成・派遣などを決定した人物は?","ウルバヌス2世"],["第四回十字軍の主導権を握っていた商人は何処の商人?","ヴェネツィア"],["第四回十字軍が陥落させた都市は?","コンスタンティノープル"],["11世紀頃発生した商人ギルドに対抗し、手工業者が結成したのは?","同職ギルド"],["12世紀の北イタリアで結ばれたミラノを中心として結ばれた都市同盟は?","ロンバルディア同盟"],["1204年に第四回十字軍がコンスタンティノープルを陥落させて新たに作られたカトリック国家は?","ラテン帝国"],];break;
    case "中世(西ヨーロッパ・後半)2" :item = [["1215年にイングランド貴族がジョン王に認めさせ立憲政治の基礎とされているものは?","大憲章（マグナ・カルタ）"],["ドイツで1256年から73年までの事実上の皇帝不在時代のことを何という?","大空位時代"],["1295年にイギリスのエドワード1世が招集した典型的な身分制議会のことを何という?","模範議会"],["フランス・カペー朝のフィリップ4世が1302年に招集し、王権を強化したのは?","三部会"],["1303年に起こった協会課税問題を巡る争いで、フランス王フィリップ4世と教皇ボニファティウス8世が争い教皇が憤死した事件は?","アナーニ事件"],["1309年に教皇庁がアヴィニョンに移されフランス王の支配下に置かれた事件は?","教皇のバビロン捕囚"],["1328年にフランスに成立した王朝で、イギリス王のエドワード3世が王位継承を主張し対立した王朝は?","ヴァロア朝"],["1339年に始まった百年戦争のイギリス・フランス対立の原因となった、毛織物工業地帯のある地方は?","フランドル地方"],["1356年に金印勅書を発布し、皇帝選出権を七選帝候に認めたドイツ皇帝は?","カール4世"],["1378年から起こったアヴィニョンとローマに教皇庁が分裂し正当性を主張しあった事件は?","大シスマ（教会大分裂）"],];break;
    case "中世(西ヨーロッパ・後半)3" :item = [["12~17世紀の北ドイツで結ばれたリューベック・ハンブルクを中心に結成された都市同盟は?","ハンザ同盟"],["1397年にデンマーク・スウェーデン・ノルウェーの3国が結んだ同盟は?","カルマル同盟"],["14世紀後半に領主の封建反動に対する抵抗してフランスで起こった反乱は?","ジャックリーの乱"],["14世紀後半に領主の封建反動に対する抵抗してイギリスで起こった反乱は?","ワット・タイラーの乱"],["1414年から1418年にかけて開催されたローマの教皇を正当なものとしたのは〇〇公会議","コンスタンツ公会議"],["イングランドの議会制度の基礎を作ったとされる人物は?","シモン=ド=モンフォール"],["百年戦争中に流行ったため戦争を一時休戦状態にした病気は?","ペスト"],["百年戦争後のイギリスで1455年に起きたバラ戦争で、対立したのは?","ランカスター家とヨーク家"],["1485年にテューダー朝を成立させた人物は?","ヘンリ7世"],["バラ戦争の結果新たに成立した王朝は?","テューダー朝"],];break;
    case "中世(西ヨーロッパ・後半)4" :item = [["ピサ大聖堂など半円状アーチを多用する11世紀に流行した教会の建築様式は何という?","ロマネスク建築"],["中世西ヨーロッパで共通の学術語とされたものは?","ラテン語"],["11世紀イタリアの大学で、主に法学を中心としていた大学は?","ボローニャ大学"],["12世紀フランスの大学で、主に神学を中心としていた大学は?","パリ大学"],["12世紀イタリアの大学で、主に医学を中心としていた大学は?","サレルノ大学"],["12世紀イギリスの大学で、主に神学を中心としていた大学は?","オクスフォード大学"],["中世西ヨーロッパで最高の学問とされたものは?","神学"],["中世西ヨーロッパの哲学と神学を総称して何という?","スコラ哲学"],["13世紀のイタリアのスコラ学の大成者で「神学大全」を著した人物は?","トマス=アクィナス"],["ケルン大聖堂などステンドグラスや尖塔アーチを特色とする12世紀以降の教会の建築様式は何という?","ゴシック建築"],];break;
    case "中世(東ヨーロッパ)1" :item = [["6世紀の東ローマ帝国の皇帝で「ローマ法大全」の編纂やハギア=ソフィア聖堂の建立に力を注いだ人物は?","ユスティニアヌス帝"],["7世紀ごろのビザンツ帝国の地方軍事・行政制度で、全土を管区に分割して屯田兵を置き、司令官が駐屯地の民政を兼ねた制度は?","軍管区制"],["726年東ローマ帝国の皇帝のレオン3世が発布してローマ教会と対立したものは?","聖像禁止令"],["10世紀末にはハンガリー王国を建国し、ローマ=カトリックを受容したのは何人?","マジャール人"],["1328年に成立し、後にモンゴル人の支配から自立したロシアの国家は?","モスクワ大公国"],["13世紀半ば頃からロシアの諸侯を服従させていたモンゴル人が建国した国は?","キプチャク=ハン国"],["1453年にビザンツ帝国を滅ぼしたのは?","オスマン帝国"],["モスクワ大公国の王で、ツァーリの称号を初めて使用し、モンゴルからの自立を実現した人物は?","イヴァン3世"],["南スラヴ人のうち、ギリシア正教に回収し、12世紀にはバルカン北部を支配したのは何人?","セルビア人"],["ポーランド人が、14世紀にリトアニアとの形成した同君連合国家を何という?","ヤゲウォ朝"],["西スラヴ人の内、14世紀にリトアニアとの同君連合国家を形成したのは何人?","ポーランド人"],];break;
    case "交易1" :item = [["狭義のシルクロードであるオアシスの道で匈奴や突厥などの遊牧国家内で交易に従事していたイラン系商人を何という?","ソグド商人"],["中国人の海上進出を妨げた明の政策は?","海禁政策"],["紀元前6世紀ごろに内陸アジアで最初に遊牧国家を作った国は?","スキタイ"],["宋・元の時代に中国商人がジャンク船によって青磁や白磁を交易品として南シナ海やインド洋まで輸出したが、この交易ルートのことを何という?","陶磁の道"],["明との朝貢関係を結びながら、明の解禁政策の結果、東シナ海と南シナ海との交易の接点で繁栄した国は?","琉球王国"],["15世紀はじめ～16世紀初め頃までのイスラム系国家で、マレー半島西南部に位置し、中継貿易、香辛料貿易で繁栄した国は?","マラッカ王国"],["16世紀から17世紀のヨーロッパ諸国のアジア進出で、バタヴィアに拠点を建設した国は?","オランダ"],["16世紀から17世紀のヨーロッパ諸国のアジア進出で、マカオに拠点を建設した国は?","ポルトガル"],];break;
//50
    case "中国(明)1" :item = [["明の洪武帝が廃止した政治の最高機関を何という?","中書省"],["紅巾の乱の指導者で1368年に民を建国した人物は?","朱元璋（洪武帝）"],["明の洪武帝が導入し製作した土地台帳を何という?","魚鱗図冊"],["明の洪武帝が導入した村落行政制度を何という?","里甲制"],["明の洪武帝が定めた民衆教化のための六カ条のことを何という?","六諭"],["明の洪武帝が導入し製作した租税・戸籍台帳を何という?","賦役黄冊"],["明の永楽帝が南海遠征を指示したイスラーム教徒の宦官は?","鄭和"],["14世紀末の朝鮮で李氏朝鮮を打ち立てた武将は?","李成桂"],["李氏朝鮮時代に争いを繰り返し混乱させた特権的身分を何という?","両班"],];break;
    case "中国(明)2" :item = [["明の建文帝の時代に燕王が挙兵して帝位についた事件を何という?","靖難の役"],["一六世紀頃の明で東南海岸に侵入したのは?","倭寇"],["靖難の役で即位した燕王はなんと名乗った?","永楽帝"],["1449年にオイラトのエセン・ハンによって明の第六代正統帝が捕らえられた事件は?","土木の変"],["女真族を統一し1616年に後金を建国した人物は?","ヌルハチ"],["ヌルハチが組織した独自の軍事・行政組織を何という?","八旗"],["後金の2代目で1636年に国号を清に改めた人物は?","ホンタイジ"],["1644年に北京を占領して明を滅ぼした反乱のことを何という?","李自成の乱"],["台湾を拠点として清に抵抗した明の遺臣は?","鄭成功"],];break;
    case "中国(明)3" :item = [["明が16世紀後半に導入した地税と人頭税を銀納する税制を何という?","一条鞭法"],["明の永楽帝が編纂させた四書の注釈書を何という?","四書大全"],["明の末から清の初期にかけて古典の実証的な文献研究を行う考証学を大成させた人物は?","顧炎武"],["明末期から清初期の人物、宋応星が著した図入りの産業技術書を何という?","天工開物"],["明末期の政治家で「農政全書」を著した人物は?","除光啓"],["本草学史上最も充実した薬学書「本草綱目」を著した人物は?","李時珍"],["マテオ・リッチと除光啓が協力して漢訳した本は?","幾何原本"],["マテオ・リッチが作成した中国初の世界地図を何という?","坤輿万国全図"],["16世紀初めに知行合一を説いて陽明学をおこした人物は?","王陽明"],];break;
    case "近世(トルコ)1" :item = [["10世紀頃から北インドに侵入したアフガニスタンのトルコ系イスラム王朝は何?","ガズナ朝"],["1206年ゴール朝のアイバクがたてたインド初のイスラム王朝を何という?","奴隷王朝"],["12世紀頃から北インドを支配下においたアフガニスタンのイラン系イスラム王朝は?","ゴール朝"],["ティムール朝の都は?","サマルカンド"],["南インドで1336年成立したヒンドゥー教徒の国を何という?","ヴィジャヤナガル王国"],["オスマン帝国が1366年に都にした場所は?","アドリアノープル"],["1396年に起きたバヤジット1世が反オスマン十字軍を破った戦いは?","ニコポリスの戦い"],["1402年に起こったティムール朝がオスマン帝国を破った戦いを何という?","アンカラの戦い"],["ティムール朝を滅ぼしたトルコ系遊牧民は何人?","ウズベク人"],["1453年にコンスタンティノープルを攻略しビザンツ帝国を滅ぼしたオスマン皇帝は?","メフメト2世"],["オスマン帝国のメフメト2世の時、遷都して新しい都となったのは?","イスタンブル"],];break;
    case "近世(トルコ)2" :item = [["オスマン帝国最盛期の時の王で、ウィーン包囲やプレヴェザの海戦でスペインなどを破り地中海の制海権を掌握した王は?","スレイマン1世"],["オスマン帝国内に存在した宗教別共同体のことを何と言う?","ミレット"],["1529年オスマン皇帝スレイマン一1世の時に包囲された都市は?","ウィーン"],["1538年に起こった戦いでオスマン帝国が地中海の制海権を獲得することになった戦いは?","プレヴェザの海戦"],["オスマン帝国が外国人に与えた特権でのちの西欧諸国の不平等条約のモデルとなったものは?","カピチュレーション"],["1571年におきたスペインなどの連合艦隊にオスマン帝国が敗れた戦いは?","レパントの海戦"],["1699年にオスマン帝国とヨーロッパ諸国との間で結ばれた条約でハンガリーをオーストリアに割譲するなどしたものは?","カルロヴィッツ条約"],["オスマン帝国で用いられた軍事奉仕の代償として与えられた徴税権を行使できる制度のことを何という?","ティマール制"],["オスマン帝国の軍団でキリスト教徒の少年を訓練して改宗させて編入させていたものを何という?","イェニチェリ"],["オスマン帝国が異教徒の信仰を認める代わりに徴税した人頭税を何という?","ジズヤ"],];break;
    case "近世(アジア、ムガル帝国)1" :item = [["1501年のイランでイスマーイール1世が建国した国は何?","サファヴィー朝"],["イランのサファヴィー朝のイスマーイール1世が王号として用いたのは?","シャー"],["イランのサファヴィー朝が国教化したのは?","シーア派"],["サファヴィー朝アッバース1世の時に遷都し新たな都となったのは?","イスファハーン"],["1736年にサファヴィー朝を滅ぼしたのは?","アフシャール朝"],["1767年にアユタヤ朝を滅ぼしたミャンマーの王朝は?","コンバウン朝"],["タイに1782年に成立した現王朝を何という?","ラタナコーシン朝"],];break;
    case "近世(アジア、ムガル帝国)2" :item = [["ティムールの子孫で、北インドを統一して1526年にムガル帝国を建国したのは?","バーブル"],["ジズヤを廃止しイスラーム・ヒンドゥーとの融和をはかり、アグラに遷都などした、ムガル帝国の王は?","アクバル"],["ムガル帝国の最大の領土を形成した王で、ジズヤを復活し反発を招き、死後ムガル帝国の衰退の原因を作った王は?","アウラングセーブ"],["ムガル帝国などのもとで、イスラム文化とヒンドゥー文化が融合して成立したものは?","インド＝イスラーム文化"],["ムガル帝国のシャー=ジャハーンがアグラ近郊に建てたインド=イスラーム文化を代表する建築物は?","タージ・マハル"],["ナーナクが創始し、偶像崇拝とカースト制を否定した宗教は?","シク教"],];break;
    case "近世(大航海時代)1" :item = [["ポルトガルの人物で「航海王子」と呼ばれ、インド航路開拓を推進した人物は?","エンリケ"],["1488年にアフリカ南端の喜望峰に到達した冒険家は?","バルトロメウ=ディアス"],["1498年にインド西岸のカリカットに到達した冒険家は?","ヴァスコ=ダ=ガマ"],["大地は球体であるという、地球球体説をとなえコロンブスに影響を与えた人物は?","トスカネリ"],["アメリカ航路開拓に援助を与え、コロンブスにも援助を与えていたスペイン女王は?","イサベル"],["コロンブスが上陸し命名したバハマ諸島の一つを何という?","サンサルバドル島"],["1500年に南米・ブラジルに漂着したポルトガル人は?","カブラル"],];break;
    case "近世(大航海時代)2" :item = [["南米を探検して、アジアと思われている大陸はアジアではないと主張した人物は?","アメリゴ=ヴェスプッチ"],["後にスペインに帰着して世界周航をなしとげるマゼラン一行が出港したのは何年?","1519年"],["マゼラン一行が世界周航を達成したが、マゼランが戦死した場所は?","フィリピン"],["インカ帝国を征服しペルーを占領したスペインの人物は?","ピサロ"],["1545年にボリビアで発見された新大陸で最大の銀の埋蔵量を有する銀山は?","ポトシ銀山"],["インド航路の開拓やアメリカ大陸への到達により栄えた、ポルトガルの首都は?","リスボン"]];break;;break;
    case "近世(ルネサンス)1" :item = [["フィレンツェの金融財閥の一家で、学者や芸術家を保護してルネサンスの後押しをした一家は?","メディチ家"],["口語のトスカナ語で叙事詩「神曲」を著述したのは?","ダンテ"],["「デカメロン」で古い権威を風刺したのは誰?","ボッカチオ"],["「叙情詩集」「アフリカ」の作者は?","ペトラルカ"],["政治を宗教や道徳から切り離すことを主張した人物で、統一国家樹立の必要性を解いた「君主論」の著者は?","マキャベリ"],["「ヴィーナスの誕生」で知られるイタリアの画家は?","ボッティチェリ"],["多くの聖母子像で知られるイタリアの画家は?","ラファエロ"],["「最後の審判」で知られ、「ダビデ像」の彫刻の作品もあるイタリアの人物は?","ミケランジェロ"],["「最後の晩餐」や「モナ=リザ」などの作品がある人物は?","レオナルド=ダ=ヴィンチ"],["ルネサンス様式を代表する建築物でブルネレスキが設計したフィレンツェの建物は?","サンタ=マリア大聖堂"],];break;
    case "近世(ルネサンス)2" :item = [["ルネサンス様式を代表する建築物でブラマンテが着手しミケランジェロが継承したローマの建物は?","サン=ピエトロ大聖堂"],["「愚神礼賛」で教会の腐敗を風刺したネーデルランドの人物は?","エラスムス"],["「カンタベリ物語」で社会を風刺したイギリスの人物は?","チョーサー"],["「ハムレット」「マクベス」など4大悲劇などで知られるイギリスの人物は?","シェークスピア"],["ネーデルランドで、油絵画法をはじめたフランドル派の兄弟は?","ファン=アイク兄弟"],["ドイツの人物で「四使徒」で知られ多くの聖書を題材とした版画の作品がある人物は?","デューラー"],["「天球回転論」を著して地動説を主張したポーランドの人物は?","コペルニクス"],["レパントの海戦にも参加した「ドン=キホーテ」の著者は?","セルバンテス"],["活版印刷術を発明したドイツの人物は?","グーテンベルク"],];break;
    case "近世(宗教改革)1" :item = [["フランス王家とハプスブルグ家との対立を背景に1494年から起こった戦争を何という?","イタリア戦争"],["1517年に九十五ヵ条の論題を発表して贖宥状販売を批判したヴィッテンベルク大学教授は?","マルティン=ルター"],["サン=ピエトロ大聖堂新築のために贖宥状を販売した教皇は?","レオ10世"],["ルターの影響で、農奴制の廃止などを求めてドイツ農民戦争を指揮したのは?","トマス=ミュンツァー"],["ルター派と諸都市によって結ばれた反皇帝同盟を何という?","シュマルカルデン同盟"],["1534年に首長法を発布し、イギリス国教会を成立させた国王は?","ヘンリ8世"],["1545年から3回にわたって開かれた会議で、教皇の至上権を再確認し思想統制の強化した会議を何という?","トリエント公会議"],["1555年にルター派と皇帝側との政治的妥協によって結ばれ、信仰の選択権が各諸侯に認められたものは?","アウクスブルクの和議"],["スイスのチューリッヒで宗教改革を始めるが保守派との戦いに敗れた人物は?","ツヴィングリ"],];break;
    case "近世(宗教改革)2" :item = [["スイスのジュネーブで魂の救済は神がすでに決定しているという予定説をとなえ改革を行った人物は?","カルヴァン"],["カルヴァン派をフランスでは何という?","ユグノー"],["カルヴァン派をネーデルランドでは何という?","ゴイセン"],["カルヴァン派をスコットランドでは何という?","プレスビテリアン"],["カルヴァン派をイングランドで何という?","ピューリタン"],["1559年に統一法を発布し、イギリス国教会を確立させた人物は?","エリザベス1世"],["フランスで1562年に起こったユグノー戦争の戦争中に起きた多数のユグノーが虐殺された事件を何という?","サンバルテルミの虐殺"],["イグナティウス=ロヨラが結成したカトリックの海外伝道を推進する組織を何という?","イエズス会"],];break;
    case "近世(イギリス)1" :item = [["イギリスで、テューダー朝が断絶したあとに専制政治を行ったスコットランドの王朝を何という?","ステュアート朝"],["王権神授説を唱え議会を無視し、国教を強制したイギリス・ステュアート朝の初代王は?","ジェームズ1世"],["イギリス・ステュアート朝の2代目の王で後にピューリタン革命で処刑された人物は?","チャールズ1世"],["イギリスでチャールズ1世に対し、1628年に議会が議会の承認なく課税しないことなどを要求したものを何という?","権利の請願"],["スコットランドの反乱に対処する戦費の調達するために開かれた議会を発端にイギリスでおこった革命を何という?","ピューリタン革命"],["ピューリタン革命の議会派で独立派の人間で、鉄騎隊を編成し議会派を勝利に導いた人物は?","クロムウェル"],["クロムウェルの独裁政治の中、1651年に制定され、オランダとの戦争のきっかけになった法は?","航海法"],["1653年にクロムウェルが就任し、軍事独裁を確立したのは?","護国卿"],["クロムウェルの死後、王政復古し1660年にイギリスの王に即位した人物は?","チャールズ2世"],["チャールズ2世の即位後にイギリス議会が1673年に制定した、公職を国教徒に限る法を何という?","審査法"],];break;
    case "近世(イギリス)2" :item = [["チャールズ2世の即位後にイギリス議会が1679年に制定した、国民の不当な逮捕・裁判を禁止した法を何という?","人身保護法"],["ジェームズ2世の即位をきっかけに生まれた、即位を認め国王の権威を重視する政党は?","トーリ党"],["ジェームズ2世の即位をきっかけに生まれた、即位に反対し議会の権利を主張した政党は?","ホイッグ党"],["1688年にジェームズ2世を廃位させた革命を何という?","名誉革命"],["名誉革命によって新たに王として即位したのは?","メアリ2世・ウィリアム3世"],["イギリス議会が「権利の宣言」として提出したものを法文化し、イギリス立憲政治の原点となったものは?","権利の章典"],["1707年のアン女王時代にイングランドとスコットランドの合併によって成立した国は?","大ブリテン王国"],["1714年にハノーヴァー朝の王に即位した人物で英語をあまり理解せず、政務を内閣に任せた人物は?","ジョージ1世"],["アン女王の死去によって1714年に成立した現イギリス王室の祖となる王朝を何という?","ハノーヴァー朝"],["イギリスの初代首相とされるホイッグ党の人物は?","ウォルポール"],];break;
    case "近世(ヨーロッパでの出来事)1" :item = [["フランスのルイ14世が造営した豪華な宮殿を何という?","ベルサイユ宮殿"],["フランスのルイ14世が財務総監に用いた人物で東インド会社の再建などの重商主義政策を行った人物は?","コルベール"],["フランスのルイ14世の時にユグノーの商工業者の亡命を招き産業の衰退を招いたのは何を廃止したから?","ナントの王令"],["フランスがスペイン継承戦争に敗れ結ばれた条約を何という?","ユトレヒト条約"],["オーストリアを支配していたハプスブルグ家の人物で、1740年に即位した女性は?","マリア=テレジア"],["1740年に即位したプロイセン王で、マリア=テレジアの家領継承に反対しシュレジエンを占領した人物は?","フリードリヒ2世"],["マリア=テレジアがプロイセンに奪われたシュレジエンを奪回するために、ロシアや敵対していたフランスと同盟を結び戦ったが、敗れた戦いを何という?","七年戦争"],["ロシアの西欧化政策を推進し、北方戦争でスウェーデンを破りバルト海に進出した人物は?","ピョートル1世"],["ロシアのピョートル1世が清と結んだ条約で、両国の国境線を定めた条約は?","ネルチンスク条約"],];break;
    case "近世(ヨーロッパでの出来事)2" :item = [["ヤゲウォ朝の断絶後弱体していたポーランドはロシア・プロイセン・オーストリアに領土を奪われたが、それに抵抗し1793年に反乱を起こしたが失敗した人物は?","コシューシコ"],["スペインとオーストリアで王家として存在し、神聖ローマ帝国皇帝を世襲するなどしていたのは何家?","ハプスブルク家"],["スペイン王カルロス1世が神聖ローマ皇帝選挙時に資金援助を受けていた南ドイツの大聖人は何家?","フッガー家"],["1568年にネーデルランドがスペインからの独立をはかりおこした独立戦争の首領は?","オラニエ公ウィレム"],["1571年にレパントの海戦でオスマン帝国を破るなどし、1580年にはポルトガルを併合したスペイン王は?","フェリペ2世"],["ネーデルランドの独立戦争で、南部10州の脱落後、北部7州で結んだ軍事同盟を何という?","ユトレヒト同盟"],["15世紀後半からイギリスで牧羊のために行われ毛織物の生産拡大に寄与したことは?","囲い込み"],["イギリスで1600年、エリザベス1世の時に設立され、アジア貿易独占権を与えられたものは?","東インド会社"],];break;
    case "近世(ヨーロッパでの出来事)3" :item = [["フランスでブルボン朝を創始し、ナントの王令でユグノー戦争を終結させた人物は?","アンリ4世"],["ルイ13世に仕えた宰相で、三部会の停止など王権強化をはかり、三十年戦争に介入しフランスの地位向上を測った人物は?","リシュリュー"],["三十年戦争で皇帝側の傭兵隊長として活躍しデンマークを敗北させた人物は?","ヴァレンシュタイン"],["三十年戦争で活躍した、スウェーデン王は?","グスタフ=アドルフ"],["ロシアでイヴァン4世死後の内紛を鎮めて1613年に成立した王朝は?","ロマノフ朝"],["1648年に三十年戦争の講和条約として結ばれた条約を何という?","ウェストファリア条約"],["プロイセンでユンカーの支持のもと絶対王政体制を確立したのは何家?","ホーエンツォレルン家"],["モスクワ大公国の王で、16世紀に専制政治を強化した人物は?","イヴァン4世"],];break;
    case "近世(ヨーロッパの海外進出)1" :item = [["ポルトガルが1510年に占領し、総督府を設置しアジア貿易の拠点にした場所は?","ゴア"],["ポルトガルが1557年に居住権を獲得し、対中国貿易の拠点とした場所は?","マカオ"],["スペインがアジア貿易の拠点にした場所は?","マニラ"],["オランダが東インド総督をおきアジア貿易の拠点にした場所は?","バタヴィア"],["1623年にイギリスの勢力をオランダが駆逐した事件を何という?","アンボイナ事件"],["オランダがアメリカのマンハッタン島に建設し、植民地経営の拠点にした場所は?","ニューアムステルダム"],["フランスがインドの植民地の拠点としてマドラス付近に建設したのは?","ポンディシェリ"],["フランスがインドの植民地の拠点としてカルカッタ付近に建設したのは?","シャンデルナゴル"],["フランスがミシシッピ川流域に建設した植民地は?","ルイジアナ"],["イギリスがインド経営の拠点としてインド東南部に建設したのは?","マドラス"],];break;
    case "近世(ヨーロッパの海外進出)2" :item = [["イギリスがインド経営の拠点としてインド西部に建設したのは?","ボンベイ"],["イギリスがインド経営の拠点としてインドガンジス川下流に建設したのは?","カルカッタ"],["イギリスがアメリカで最初の植民地した場所は?","ヴァージニア"],["七年戦争の一環として戦われ、イギリスがアメリカでの植民地帝国になる基礎が築かれることとなった戦いは?","フレンチ=インディアン戦争"],["17～18世紀にかけて行われた三角貿易で、アメリカ大陸からヨーロッパに輸出されたものは?","砂糖・綿花・タバコ"],["17～18世紀にかけて行われた三角貿易で、ヨーロッパから西アフリカに輸出されたものは?","武器"],["17～18世紀にかけて行われた三角貿易で、西アフリカからアメリカ大陸に輸出されたものは?","黒人奴隷"],["フランスの東インド会社とイギリスの東インド会社の抗争で1744年からインドではじまった戦いは?","カーナティック戦争"],["1757年におこったイギリスのクライヴ率いる東インド会社軍が、フランスの東インド会社とベンガル太守の連合軍を倒した戦いは?","プラッシーの戦い"],["1765年にイギリスの東インド会社が徴税権を得たインドの地方は?","ベンガル地方"],];break;
    case "近世(ヨーロッパの海外進出)3" :item = [["1767年に起こった戦争でイギリス東インド会社が勝利し南インドに進出することになった戦争は?","マイソール戦争"],["1775年に起こった戦争でイギリス東インド会社が勝利し西部インドに進出することになった戦争は?","マラーター戦争"],["1802年にベトナムで阮朝をたてた人物は?","阮福暎"],["イギリスがミャンマーに進出するために1824年以降起こしたビルマ戦争で、滅ぼした王朝は?","コンバウン朝"],["ベトナムで阮福暎が阮朝をたてるのに援助したフランス人宣教師は?","ピニョー"],["1845年に起こった戦争でイギリス東インド会社が勝利し西北インドに進出することになった戦争は?","シク戦争"],["1857年に反乱を起こした、東インド会社のインド人傭兵のことを何と言う?","シパーヒー"],["1877年にイギリスがインドで成立を宣言した国は?","インド帝国"],["1877年に成立したインド帝国のインド皇帝になった人物は?","ヴィクトリア女王"],["オランダが進出したジャワ島で導入された輸出用作物を栽培させる制度は?","強制栽培制度"],];break;
    case "近世(ヨーロッパの海外進出)4" :item = [["18世紀末にマレー半島に進出したのは?","イギリス東インド会社"],["イギリス東インド会社が獲得した、ペナン・マラッカ・シンガポールなどを1826年に一括して何にした?","海峡植民地"],["1886年にイギリスがインド帝国に併合したのは?","ミャンマー"],["宣教師迫害を口実に1858年におこった仏越戦争の結果、結ばれた条約は?","サイゴン条約"],["1863年にフランスが保護国化したのは?","カンボジア"],["1883年にベトナムがフランスの保護国化されることになった条約は?","ユエ条約"],["フランスのベトナム保護国化を認めなかった清朝とフランスとが1884年に起こした戦争は?","清仏戦争"],["1885年に結ばれた、清仏戦争の結果、清がフランスのベトナム保護権を認めた条約は?","天津条約"],["1887年に成立したフランス領インドシナ連邦の総督府がおかれた場所は?","ハノイ"],["1899年にフランス領インドシナ連邦に編入されたのは?","ラオス"],["タイでフランス・イギリスの緩衝地帯として独立を維持した王朝は?","ラタナコーシン朝"],];break;
    case "近世(ヨーロッパ文化)1" :item = [["地動説を立証し、「天文対話」の著があるイタリアの人物は?","ガリレイ"],["惑星運行の法則を発見したドイツの人物は?","ケプラー"],["万有引力の法則を発見したイギリスの人物は?","ニュートン"],["種痘法を開発したイギリスの人物は?","ジェンナー"],["イギリス経験論を確立し、帰納法を主張した人物は?","フランシス=ベーコン"],["社会契約説も唱えた人物で人間の心は白紙と考えたイギリスの人物は?","ロック"],["合理論を説き、「方法序説」などの著書があるフランスの人物は?","デカルト"],["イギリス経験論と合理論を総合したドイツ観念論の祖で、著書にちなんで批判哲学とよばれる思想をもつ人物は?","カント"],];break;
    case "近世(ヨーロッパ文化)2" :item = [["自然状態を「万人の万人に対する闘争」とし、著者「リヴァイアサン」では絶対主義を擁護することになった人物は?","ホッブズ"],["「法の精神」で三権分立をとなえた人物は?","モンテスキュー"],["「哲学書簡」などの著書があり、啓蒙専制君主に影響を与えた人物は?","ヴォルテール"],["「社会契約論」などの著書があり、人民主権を説いた人物は?","ルソー"],["「諸国民の富」の著書があり、古典派経済学の代表的人物は?","アダム=スミス"],["バロック美術の代表的建築物でルイ14世時代に建築されたものは?","ヴェルサイユ宮殿"],["ロココ美術の代表的建築物でフリードリヒ2世によって建築されたものは?","サンスーシ宮殿"],];break;
    case "近世(産業革命)1" :item = [["1710年に蒸気機関を初めて実用化した人物は?","ニューコメン"],["イギリスでの農業革命の原動力となり、多くの中小農民が土地を失うこととなったことは?","第2次囲い込み"],["1733年に飛び杼を発明した人物は?","ジョン=ケイ"],["1764年にジェニー紡績機を発明した人物は?","ハーグリーブス"],["1765年に制定したが「代表なくして課税なし」ととなえた反対運動によって撤廃した法案は?","印紙法"],["1769年に蒸気機関の改良をした人物は?","ワット"],["蒸気船を実用化した人物は?","フルトン"],["1769年に水力紡績機を発明した人物は?","アークライト"],["蒸気機関車を実用化した人物は?","スティーブンソン"],];break;
    case "近世(フランス)1" :item = [["テュルゴーやネッケルを蔵相に登用し、特権身分に課税を行おうとしたが失敗したフランス国王は?","ルイ16世"],["1789年8月4日にバスティーユ牢獄の襲撃から始まった暴動の沈静化をはかるために国民議会が宣言したのは?","封建的特権の廃止"],["1789年にフランスで三部会の混乱から結成された国民議会で、憲法制定まで解散しないことを誓ったことを何という?","球戯場（テニスコート）の誓い"],["1789年8月26日にラ=ファイエットらの起草で国民議会に採択された自由・平等などの精神を明確にしたものは?","人権宣言"],["1789年7月14日に国民議会への武力弾圧に対し市民が蜂起して襲撃した場所は?","バスティーユ牢獄"],["1789年にフランスの特権身分の要求で招集されたが、議決方法で混乱してしまったのは?","三部会"],["フランス国王と王妃マリ=アントワネットが王妃の母国のオーストリアへ逃亡しようとしたが失敗した事件を何という?","ヴァレンヌ逃亡事件"],["1791年に始まったフランスの立法議会で、対立した2つの派閥は?","フイヤン派（立憲君主派）とジロンド派（穏健共和派）"],["1792年のフランスでジロンド派内閣が立憲君主派や反革命勢力に対抗するために国王に宣戦布告させた国は?","オーストリア"],];break;
    case "近世(フランス)2" :item = [["1792年にフランスで、招集された国民公会で台頭してきた急進共和主義の派閥を何という?","ジャコバン派"],["ジャコバン派が国王を処刑するなどしたのに対応し、イギリス首相ピットが提唱しフランスを牽制したものは?","第一回対仏大同盟"],["フランスでジャコバン派が行なっていた公安委員会や革命裁判所の設置などする政治形態を何と呼んでいる?","恐怖政治"],["ジャコバン派の恐怖政治の中心的人物は?","ロベスピエール"],["フランスで男子普通選挙を盛り込んだが実施されなかった憲法は?","ジャコバン憲法"],["ロベスピエールが逮捕され処刑された事件を何という?","テルミドールのクーデター"],["ナポレオンが生まれたのは?","コルシカ島"],["ナポレオンの名声を上げた遠征で、ロゼッタストーンを発見したのは何処への遠征?","エジプト遠征"],["1799年にナポレオンのエジプト遠征に対して結成された同盟は?","第二回対仏大同盟"],];break;
    case "近世(フランス)3" :item = [["ナポレオンが総裁政府を打倒し統領政府の第一統領に就任することになったクーデターを何という?","ブリュメール18日のクーデター"],["1802年フランスのナポレオンとイギリスとの間に結ばれた講和条約は?","アミアンの和約"],["1804年にナポレオンが制定した私有財産の不可侵などを定めたものは?","ナポレオン法典"],["1805年にフランス海軍がネルソン率いるイギリス海軍に大敗した戦いは?","トラファルガーの海戦"],["1805年にフランスがオーストリア・ロシア連合軍を破った戦いは?","アウステルリッツの戦い"],["1806年にナポレオンの保護のもと西南ドイツ諸国をあわせた国家連合を何という?","ライン同盟"],["ライン同盟結成により消滅した962年に成立した国は?","神聖ローマ帝国"],["1807年にナポレオンがロシア・プロイセンを破り結ばせた条約は?","ティルジット条約"],];break;
    case "近世(フランス)4" :item = [["1806年にフランス・ナポレオンが発布した、イギリスとの通商を各国に禁止するようにした命令は?","大陸封鎖令"],["1808年にナポレオンに対して反乱をおこし解放戦争の口火となった国は?","スペイン"],["ナポレオンに敗れたプロイセンで農民開放など近代化をはかった改革を行った人物は?（二人）","シュタイン・ハルデンベルク"],["1813年にロシア・プロイセン・オーストリア連合軍がフランス軍を破り、パリ占領した戦いは?","ライプチヒの戦い"],["ライプチヒの戦いで破れナポレオンが流刑された場所は?","エルバ島"],["ライプチヒの戦い後、即位した人物は?","ルイ18世"],["1815年にナポレオンがイギリス・プロイセン・オランダ連合軍に敗れた戦いは?","ワーテルローの戦い"],["ワーテルローの戦いに敗れたナポレオンが流刑にされた場所は?","セントヘレナ島"],];break;
    case "近世(ウィーン会議以降のヨーロッパ社会)1" :item = [["1814年に始まったウィーン会議の主催者であったオーストリア外相は?","メッテルニヒ"],["ウィーン会議で正統主義の原則を主張したフランス外相は?","タレーラン"],["ラテンアメリカの独立の中心となった植民地生まれの白人のことを何という?","クリオーリョ"],["ラテンアメリカの独立に対しアメリカがヨーロッパ・アメリカの相互不干渉を主張し、メッテルニヒの干渉を失敗させたのは?","モンロー教書"],["1821年からオスマン帝国からの独立を求めて戦い、ロシア・イギリス・フランスの支援を受けた国は?","ギリシア"],["ルイ18世の弟で反動政治を行い七月革命を引き起こした人物は?","シャルル10世"],["七月革命で新たに即位したオルレアン家の人物は?","ルイ=フィリップ"],["七月革命の影響でオランダから新たに独立した国は?","ベルギー"],["イギリスで1829年にアイルランド対策などの理由から、カトリック教徒も公職につけるようにした法は?","カトリック教徒解放法"],];break;
    case "近世(ウィーン会議以降のヨーロッパ社会)2" :item = [["1831年にイタリアでマッツィーニが結成した組織を何という?","青年イタリア"],["1834年にドイツで発足し、経済的統一をはたした機関は?","ドイツ関税同盟"],["イギリスでナポレオン戦争後に地主保護のために制定されたが、1846年に廃止されたものは?","穀物法"],["第一回選挙法改正で選挙権を得られなかった労働者が行った社会運動を何という?","チャーチスト運動"],["イギリスで工場法制定などに尽力した社会主事思想家は?","ロバート=オーウェン"],["マルクスとエンゲルスの共著で、共産主義の目的をと見解を示したのは?","共産党宣言"],["七月王政への不満や選挙法改正運動への弾圧から1848年におきた革命を何という?","二月革命"],["二月革命で新しく成立した政体を何という","第二共和政"],["第二共和政時に行われた選挙で大統領に当選し、後にクーデターで独裁政権樹立する人物は?","ルイ=ナポレオン"],];break;
    case "近世(ウィーン会議以降のヨーロッパ社会)3" :item = [["1848年のドイツで、ドイツ統一と憲法制定のために開かれたのは?","フランクフルト国民会議"],["イギリスで、1849年に廃止され、自由貿易が実現するようになったものは?","航海法"],["南イタリアの両シチリア王国を征服し、1860年にサルデーニャ王に献上した青年イタリアの人物は?","ガリバルディ"],["イタリアが1866年の普墺戦争に参戦して併合した場所は?","ヴェネツィア"],["ヴィクトリア女王時代の議会政党政治で自由党党首で二大政治家の一人だった人物は?","グラッドストン"],["フランスの臨時政府がドイツと結んだ仮講和条約に不満を持ったパリ市民らが反乱を起こし、成立した自治政府を何という?","パリ=コミューン"],["イタリアのサルデーニャ王国が1859年にオーストリアから獲得したのは?","ロンバルディア"],["イタリアが1870年に起こった普仏戦争の際に占領した場所は?","ローマ教皇領"],["1861年に即位したプロイセン王ヴィルヘルム1世が首相に起用したのは?","ビスマルク"],];break;
    case "近世(ウィーン会議以降のヨーロッパ社会)4" :item = [["ドイツ首相になったビスマルクが行った政策を何という?","鉄血政策"],["1866年にビスマルクが、普墺戦争の勝利に伴いドイツ連邦を解体し新たに結成したものは?","北ドイツ連邦"],["1870年の普仏戦争の結果、ドイツに生まれた新しい国家を何という?","ドイツ帝国"],["ヴィクトリア女王時代の議会政党政治で保守党党首で二大政治家の一人だった人物は?","ディズレーリ"],["フランス皇帝で、独裁政治を行ったが1870年の普仏戦争で破れ退位したのは?","ナポレオン3世"],["ビスマルクが制定した社会民主党を弾圧する法を何という?","社会主義者鎮圧法"],["1877年に起こった露土戦争での講和条約を何という?","サン=ステファノ条約"],["1878年に行われた会議で、イギリス・オーストリアの反対っでロシアの南下を挫折させたものを何という?","ベルリン会議"],["1882年にドイツ・オーストリア・イタリアで結ばれた同盟で、フランスの孤立化をはかったものを何という?","三国同盟"],];break;
    case "近世(アメリカ)1" :item = [["1773年に制定した東インド会社に茶の独占販売権を付与した茶法が引き起こしたとされる事件は?","ボストン茶会事件"],["1775年に勃発したアメリカ独立戦争で植民地側の総司令官は?","ワシントン"],["「コモン=センス」を出版し、アメリカ独立の気運を盛り上げた人物は?","トマス=ペイン"],["1776年に発表された独立宣言を起草した主な人物は?","トマス=ジェファソン"],["1780年にロシアのエカチェリーナ2世の提唱で結ばれた同盟で、イギリスが孤立化しアメリカ独立への手助けになった同盟は?","武装中立同盟"],["1779年にミュール紡績機を発明した人物は?","クロンプトン"],["1783年に結ばれた条約でイギリスがアメリカ合衆国の独立を承認し、ミシシッピ川以東のルイジアナを割譲した条約は?","パリ条約"],["1781年に起こった戦いでアメリカ植民地側が勝利し独立への流れを決定的にした戦いは?","ヨークタウンの戦い"],["1785年に力織機を発明した人物は誰?","カートライト"],["1793年に綿繰り機を発明した人物は?","ホイットニー"],];break;
    case "近世(アメリカ)2" :item = [["アメリカ合衆国の初代大統領となったのは?","ワシントン"],["アメリカ第５代大統領でアメリカ大陸とヨーロッパの相互不干渉を宣言した人物は?","モンロー"],["アメリカ第７代大統領で、小市民の側にたった民主政治を行った人物は?","ジャクソン"],["アメリカが1803年にフランスから買収した領土は?","ミシシッピ川以西のルイジアナ"],["アメリカが1819年にスペインから買収した領土は?","フロリダ"],["アメリカで1820年に結ばれた取り決めで、北緯36度30分線を自由州・奴隷州の境界としたものは?","ミズーリ協定"],["1845年にメキシコから独立し、アメリカが併合したのは?","テキサス"],["メキシコとの戦争に勝利し1848年にアメリカが獲得したのは?","カリフォルニア"],["アメリカで奴隷制反対の勢力が1854年に結成したものは?","共和党"],["奴隷制反対のリンカーンが大統領に当選したので、アメリカ南部の11州が合衆国から離脱して結成したのは?","アメリカ連合国"],];break;
    case "近世(アメリカ)3" :item = [["南北戦争最中の1863年にリンカーンがした宣言で、内外から多くの支持を得た宣言は?","奴隷解放宣言"],["南北戦争最大の激戦で、北部が勝利し優勢になった戦いを何という?","ゲティスバーグの戦い"],["1867年にアメリカがロシアより720万ドルで購入したものは?","アラスカ"],["1869年にアメリカで完成し、東部と西部を結び重要な役割をしたものは?","大陸横断鉄道"],["「最大多数の最大幸福」を主張し、功利主義哲学を創始したイギリスの人物は?","ベンサム"],["社会学の祖ともされる実証社会主義哲学を創始したフランスの人物は?","コント"],["古典派の経済学者で「人口論」などの著作があるイギリスの人物は?","マルサス"],["古典派の経済学者で「経済学および課税の原理」などの著作があるイギリスの人物は?","リカード"],["1859年に「種の起源」を刊行して進化論を提唱したイギリスの人物は?","ダーウィン"],["エネルギー保存の法則を発見したドイツの人物は?（2人）","マイヤー・ヘルムホルツ"],];break;
    case "近世(アメリカ)4" :item = [["ドイツの物理学者レントゲンが発見したのは?","X線"],["電磁誘導や電気分解の法則を発見した人物は?","ファラデー"],["フランスのキュリー夫妻が発見したのは?","ラジウム"],["乳酸菌の発見や狂犬病予防接種に成功したフランスの細菌学者は?","パストゥール"],["結核菌やコレラ菌を発見したドイツの学者は?","コッホ"],["伝統や映画や蓄音機を発明したアメリカの人物は?","エジソン"],["18世紀後半に太平洋を探検しニューギニアやニュージーランドやハワイなどの情報を得たイギリスの探検家は?","クック"],["19世紀前半頃のロマン主義の作家で、「レ=ミゼラブル」などの作品があるフランスの人物は?","ユーゴー"],["1837年に電信機を発明したアメリカの人物は?","モールス"],];break;
    case "近世(アメリカ)5" :item = [["アメリカのロマン派詩人で哲学者でもあり、「自然論」の著作がある人物は?","エマーソン"],["19世紀半ば頃の写実主義の作家で、「赤と黒」などの代表作があるフランスの作家は誰?","スタンダール"],["19世紀半ば頃の写実主義の作家で、「人間喜劇」「ゴリオ爺さん」などの代表作があるフランスの作家は?","バルザック"],["「戦争と平和」の作者であるロシアの作家は?","トルストイ"],["弁証法哲学を研究し、ドイツ観念論哲学を完成させた人物は?","ヘーゲル"],["19世紀後半頃の自然主義の作家で、「女の一生」などの代表作があるフランスの作家は?","モーパッサン"],["「罪と罰」の作者であるロシアの作家は?","ドストエフスキー"],["ドイツのロマン派詩人で「青い花」の著作がある人物は?","ノヴァーリス"],["19世紀後半頃の自然主義の作家で、「実験小説論」「居酒屋」などの代表作があるフランスの作家は?","ゾラ"],];break;
    case "近世(中東・エジプトの出来事)1" :item = [["オスマン帝国が致命的な打撃を受けた1863年に起きた軍事的失敗は?","第2次ウィーン包囲"],["1699年にオスマン帝国がオーストリアにハンガリーなどを割譲することになった条約は?","カルロヴィッツ条約"],["イランに1796年に成立した王朝は?","カージャール朝"],["イランのカージャール朝が南下政策のロシアに敗れ、1828年に結ばれた条約は?","トルコマンチャーイ条約"],["オスマン帝国のアブデュル=メジト1世が1839年にはじめた改革は?","タンジマート"],["1848年、外国勢力へ従属するイランのカージャール朝に対し農民が起こした反乱は?","バーブ教徒の乱"],["ロシアがオスマン帝国領内のギリシア正教徒保護を要求したために1853年に起こった戦争は?","クリミア戦争"],["1869年にフランス人のレセップスが完成させたのは?","スエズ運河"],["オスマン帝国の宰相ミドハト=パシャが1876年に制定した二院制議会や責任内閣制を定めたアジア最初の憲法は?","ミドハト憲法"],];break;
    case "近世(中東・エジプトの出来事)2" :item = [["ミドハト憲法が停止されることになった出来事は?","露土戦争"],["1875年にスエズ運河会社株式取得したのは何処の国の何内閣だった?","イギリス・ディズレーリ内閣"],["1878年にオスマン帝国が露土戦争に破れて結んだ条約は?","サン=ステファノ条約"],["18世紀半ばにアラビア半島で、イブン=アブドゥル=ワッハーブが富豪のサウード家と結んで建設した国は?","ワッハーブ王国"],["ナポレオンのエジプト遠征に乗じてエジプトの支配権を得た人物は?","ムハンマド=アリー"],["「エジプト人のためのエジプト」をスローガンに1881年に反乱を起こした人物は?","ウラービー=パシャ"],["1891年にイランでイギリスの利権に反発して起こった反王政運動は?","タバコ=ボイコット運動"],["イギリスがアフガニスタンを保護国化したのはなんの戦争の勝利の時?","第2次アフガン戦争"],["アフガニスタン王国がイギリスから独立したのはなんの戦争の結果?","第3次アフガン戦争"],];break;
    case "中国(清)1" :item = [["1673年に呉三桂らが清に対して起こした反乱を何という?","三藩の乱"],["三藩の乱を鎮圧するなどした清四代目皇帝は?","康熙帝"],["1689年に清とロシアとの間で結ばれた国境などについて定めた条約は?","ネルチンスク条約"],["清の6代皇帝乾隆帝が設置した藩部を統括する漢人で作った組織を何という?","理藩院"],["1727年清とロシアとの間に結ばれた条約でモンゴル方面の国境を定めた条約は?","キャフタ条約"],["清が漢人に強制した満州族の髪型のことを何という?","辮髪"],["清が18世紀はじめに導入した人頭税を地税に含んで徴収する税制を何という","地丁銀制"],["18世紀後半に清の皇帝に仕え、円明園の設計に加わった宣教師は?","カスティリオーネ"],];break;
    case "中国(清)2" :item = [["1757年に清が貿易港を一つに限定したが、そこは何処?","広州"],["1757年に清が貿易制限をした際に、特別に取引を認められた特許商人のことを何という?","公行"],["清に対し自由貿易を求めて18世紀末にイギリスが送った使節は?","マカートニー"],["イギリスのアヘン密輸に対し取り締まりを行った清の人物は?","林則徐"],["アヘン戦争の結果、清とイギリスが結んだ条約は?","南京条約"],["南京条約で清がイギリスに割譲したのは?","香港島"],["南京条約の後の1843年に清とイギリスとの間で結ばれた条約で、治外法権や関税自主権の喪失などを認めた不平等な条約は?","虎門寨追加条約"],["1844年にアメリカと清との間で結ばれた不平等な条約は?","望厦条約"],["1844年にフランスと清との間で結ばれた不平等な条約は?","黄埔条約"],["1856年に貿易拡大を狙ったイギリス・フランスと清との間で起こった戦争は?","アロー戦争"],["1858年、アロー戦争中に一旦結ばれた講和条約は?","天津条約"],];break;
    case "中国(清)3" :item = [["1860年にロシアの調停で結ばれたアロー戦争の講和条約は?","北京条約"],["北京条約で開港するのが定められた場所は?","天津"],["北京条約でイギリスに割譲するのが定められた場所は?","九竜半島の一部"],["キリスト教的結社の拝上帝会を組織し、1851年に太平天国の建国を宣言した人物は?","洪秀全"],["洪秀全が掲げていた清朝を倒すスローガンは?","滅満興漢"],["洪秀全が発布した土地を均分する制度は?","天朝田畝制度"],["太平天国を鎮圧した漢人官僚で、湘軍を組織していた人物は?","曽国藩"],["太平天国を鎮圧した漢人官僚で、淮軍を組織していた人物は?","李鴻章"],["太平天国を鎮圧したイギリス軍人ゴードンが指揮していた軍隊は?","常勝軍"],["1860年代以降に清で行われた西洋の学問や技術の導入による富国強兵策を何という?","洋務運動"],["洋務運動によってむかえた一時的な安定と平和の時期を何という?","同治中興"],];break;
    case "中国(清)4" :item = [["洋務運動の限界の原因となった、中国の伝統や学問を主体として西洋の学問や技術を採用する考え方は?","中体西用"],["朝鮮に日本が進出するきっかけとなった1875年に起きた事件は?","江華島事件"],["1876年に日本と朝鮮との間で結ばれた日本の領事裁判権を認めるなどの不平等な内容を含む条約は?","日朝修好条規"],["1882年に朝鮮で開化派」と「保守派」との争いを背景に起こった事件は?","壬午軍乱"],["1884年に朝鮮で開化派」と「保守派」との争いを背景に起こった事件は?","甲申政変"],["壬午軍乱や甲申政変の頃の朝鮮で親日派の独立党の代表的人物は?","金玉均"],["壬午軍乱や甲申政変の頃の朝鮮で親清派の事大党の代表的人物は?","閔氏"],["1894年におこった日清戦争のきっかけとなった出来事は?","甲午農民戦争"],["清に対し自由貿易を求めて19世紀初めにイギリスが送った使節は?","アマースト"],["日清戦争の講和条約は?","下関条約"],];break;
    case "近世(ロシア)1" :item = [["1762年に即位したロシアの王で、クリミア半島を併合し、日本にラクスマンを派遣するなどした人物は?","エカチェリーナ2世"],["ロシアのエカチェリーナ2世の在位中の出来事で、結果、農奴制を強化し専制政治を強化することになった反乱を何という?","プガチョフの乱"],["1815年にロシア皇帝アレクサンドル1世がキリスト教の友愛精神に基づく平和維持機関として提唱したものは?","神聖同盟"],["1825年にロシアで起きた最初の自由主義運動を何という?","デカブリストの乱"],["1853年にロシアがギリシア正教徒保護を口実に開戦した戦いは?","クリミア戦争"],["ロシアのアレクサンドル2世が1861年に行った改革で、土地をミールに分与し農奴に人格的自由を認めるなどした改革を何という?","農奴解放令"],["ロシアのアレクサンドル2世に対し、都市の知識人階級のインテリゲンツィアで農民を啓蒙する活動する人のことを何と呼ぶ?","ナロードニキ"],["ロシアで1894年に即位して専制政治を続けた皇帝は?","ニコライ2世"],["ロシア社会民主労働党から分裂したレーニンが指導した急進派の団体は?","ボリシェヴィキ"],["ロシア社会民主労働党から分裂したプレハーノフが指導した穏健派の団体は?","メンシェヴィキ"],];break;
    case "近世(ロシア)2" :item = [["ロシアで1905年に起きた事件で、第一次ロシア革命のきっかけになった事件は?","血の日曜日事件"],["ロシアで1906年に首相になりミールの解体など独立自営農の育成を図ったが失敗した人物は?","ストルイピン"],["ロシアが1912年にセルビア・モンテネグロ・ブルガリア・ギリシアに結ばせたのは?","バルカン同盟"],["スイスからロシアに帰国し、四月テーゼを発表し、臨時政府首相ケレンスキーと対立した人物は?","レーニン"],["1917年、第一次世界大戦の長期化に伴う困窮から首都でストライキが起きロシア皇帝の退位につながった出来事は?","二月革命"],["1917年の二月革命で退位したロシア皇帝は?","ニコライ2世"],["1917年にレーニンやトロツキーが指揮するボリシェヴィキが臨時政府を倒した出来事は?","十月革命"],["ロシアのボリシェヴィキが1918年に改称して何になった?","共産党"],["レーニンが世界革命の推進を目指し、1919年にモスクワで創設したのは?","コミンテルン"],["1921年にレーニンが行った経済政策で、資本主義の一部解除で生産活動の向上を計った政策は?","新経済政策"],["1922年にロシア・ウクライナ・ベラルーシ・ザカフカースの共和国が連合して生まれた国は?","ソヴィエト社会主義共和国連邦"],];break;
//49
    case "第一次世界大戦までの世界1" :item = [["スエズ運河の株式を購入するなどの政策を行ったイギリスの保守党の首相は?","ディズレーリ"],["アフリカ西岸で1847年に独立した国は?","リベリア共和国"],["イギリスの植民地相で南アフリカ戦争を遂行した人物は?","ジョセフ=チェンバレン"],["1881年にエジプトで起きた反乱で、イギリスによって鎮圧され保護国化につながった反乱は?","ウラービーの反乱"],["1881年にスーダンで起きた反乱で、イギリスに鎮圧された反乱は?","マフディー派の反乱"],["フランスで1887年におきた軍部によるクーデター未遂事件は?","ブーランジェ事件"],["ドイツのビスマルク首相が1890年に辞任する原因となった対立した皇帝は?","ヴィルヘルム2世"],["フランスで1894年におきたユダヤ系軍人の冤罪事件のことを何という?","ドレフュス事件"],["1896年にイタリアが征服を失敗し、独立を保った国は?","エチオピア帝国"],["18世紀末からイギリスの流刑植民地だったが、金鉱脈発見後急速に発展したのは?","オーストラリア"],];break;
    case "第一次世界大戦までの世界2" :item = [["1897年に就任したアメリカ大統領で、アメリカ=スペイン戦争を遂行し、フィリピン・グアム・プエルトリコを獲得した人物は?","マッキンリー"],["1898年に起こった戦争をきっかけに、アメリカがスペインから買収した国は?","フィリピン"],["1898年にイギリスのアフリカ横断政策とフランスの横断計画が衝突して戦争の危機になったがフランスが譲歩して回避された事件を何という?","ファショダ事件"],["ロシアで1901年に結成されたナロードニキの流れをくむ政党は?","社会革命党"],["イギリスがロシアの極東進出に対抗して1902年に結んだものは?","日英同盟"],["1901年に就任したアメリカ大統領で、革新主義を掲げ反トラスト法を発動したり、カリブ海政策を行った人物は?","セオドア=ルーズベルト"],["1904年に結ばれたもので、ドイツの脅威に対抗し、フランスのモロッコにおける優越権とイギリスのエジプトにおける優越権をそれぞれ認め合ったものは?","英仏協商"],["イギリスで1906年に成立したウェッブ夫妻が結成したフェビアン協会を母体とした団体は?","労働党"],["1907年にイギリスが結び三国協商が成立することになった協約は?","英露協商"],["ケープ植民地首相で、南アフリカ戦争を指示しブール人と戦ったイギリスの人物は?","セシル=ローズ"],];break;
    case "第一次世界大戦までの世界3" :item = [["イギリスの世界政策で、カイロとケープタウンとカルカッタを結ぶ政策は?","3C政策"],["アフリカ進出に遅れたドイツが、フランスとの間に第一次（1905年）・第二次（1911年）と起こした事件は?","モロッコ事件"],["アメリカのカリブ海政策のひとつであり、1914年に完成しアメリカが支配下においたものは?","パナマ運河"],["メキシコの大統領で、独裁政治で外貨導入による近代化をはかったが貧富の差が拡大し、メキシコ革命により亡命することになった人物は?","ディアス"],["メキシコ革命の指導者で自由主義者の人物は?","マデロ"],["メキシコ革命の指導者で農民指導者の人物は?","サパタ"],["ドイツがバグダード鉄道の建設などでイギリスに対抗して行った政策は?","3B政策"],["ドイツの3B政策の3Bとはどこを指す?","ベルリン・バグダード・ビザンティウム"],["オーストリアが青年トルコ革命の混乱に乗じて併合したのは?","ボスニア・ヘルツェゴヴィナ"],["日清戦争後の中国で、変法による制度改革を行おうと光緒帝を動かした公羊学派の人物は?","康有為"],["北京を占拠した義和団に対し、列強各国が出兵し、清に調印させたものは?","北京議定書"],];break;
    case "第一次世界大戦までの世界4" :item = [["辛亥革命の発端となった暴動が起きた場所は?","四川省"],["三国干渉によって日本に遼東半島を返還させた代償にロシアが得た権利は？","東清鉄道敷設権"],["孫文がとなえた民族の独立・民族の伸張・民生の安定からなる理念は?","三民主義"],["孫文と密約し、清朝の最後の皇帝となった宣統帝を退位させ孫文から臨時大統領の地位を譲り受けた人物は?","袁世凱"],["日露戦争の講和条約のポーツマス条約を調停したアメリカ大統領は?","セオドア=ルーズベルト"],["ボンベイで1885年に第一回の会議が行われたイギリス統治下のインドで、インド人の意見を諮問する機関は?","インド国民会議"],["イランで1891年に展開された外国利権に抵抗する運動は?","タバコ=ボイコット運動"],["1896年におきたフィリピン革命での革命軍指導者は?","アギナルド"],["1898年に中国で改革に反対する保守派と西太后がおこしたクーデタは?","戊戌の政変"],["1904年にベトナムで独立を目指す維新会を結成した人物は?","ファン=ボイ=チャウ"],["孫文が1905年に東京で結成した組織は?","中国同盟会"],];break;
    case "第一次世界大戦までの世界5" :item = [["1905年にイギリスがイスラーム教徒とヒンドゥー教徒の分断をはかるために発表したものは?","ベンガル分割令"],["1906年にインドで少数派であったイスラーム教徒が結成した親英的な組織は?","全インド=ムスリム連盟"],["オスマン帝国でミドハト憲法の停止に不満を持った人物らが結成し、1908年には革命を起こしたものは?","青年トルコ"],["インドネシアで1911年に結成され、後にオランダに抵抗するようになった組織は?","サレカット=イスラーム"],["辛亥革命の結果1912年に孫文を大統領として建国を宣言された国は?","中華民国"],["19世紀末に中国でおこった反キリスト教運動で山東省で生まれた義和団のスローガンは?","扶清滅洋"],["19世紀末ごろにイギリスが中国で得た租借地は?","威海衛・九竜半島"],["19世紀末ごろにフランスが中国で得た租借地は?","広州湾"],["19世紀末ごろにドイツが中国で得た租借地は?","膠州湾"],["19世紀末に中国の門戸開放・機会均等・領土保全を提唱したアメリカの国務長官は?","ジョン=ヘイ"],["20世紀前半にベトナムで行われた日本に留学生を送る運動は?","ドンズー運動"],];break;
    case "第一次世界大戦1" :item = [["1914年にオーストラリアの帝位継承者夫妻が暗殺され第一次世界大戦のきっかけとなった場所は?","サライェヴォ"],["1914年の第一次世界大戦中にフランスに侵攻したドイツ軍が進撃を阻止された戦いは?","マルヌの戦い"],["第一次世界大戦中に侵攻してきたロシア軍をドイツ軍が破った戦いは?","タンネンベルクの戦い"],["1916年にイギリスがソンムの戦いで初めて実戦で使用した兵器は?","戦車"],["1917年にイギリスがパレスチナのユダヤ人国家建設を支持すると約束したものを〇〇宣言","バルフォア宣言"],["ドイツが1917年に宣言した指定航路以外の船舶を無警告で攻撃する作戦は?","無制限潜水艦作戦"],["1918年に結ばれたロシアとドイツとの単独講和条約は?","ブレスト=リトフスク条約"],["1918年に起きたドイツ革命につながり第一次世界大戦終結にもつながった水平の暴動が起きた場所は?","キール軍港"],["チェコ兵の捕虜救出を口実にしてアメリカや日本などが1918年に行ったのは?","シベリア出兵"],];break;
    case "第一次世界大戦後1" :item = [["中国で1915年に雑誌「新青年」を刊行し、儒教道徳を批判した人物は?","陳独秀"],["1915年に日本が山東省のドイツ利権などの継承などを要求したことを何という?","二十一ヵ条の要求"],["1912年に南アフリカで創設された政党で人種差別撤廃運動の始まりとなったのは?","アフリカ民族会議"],["インドで1919年にイギリスが制定して政治活動を弾圧し、反英運動の激化を招いた法律は?","ローラット法"],["1919年にドイツで成立した当時では最も民主的な憲法は?","ヴァイマル憲法"],["1919年のパリ講和会議で結ばれたヴェルサイユ条約でドイツがフランスに返還したのは?","アルザス・ロレーヌ地方"],["朝鮮で、日本の朝鮮総督府の武断政治に対する反発で1919年に起きた民族運動は?","三・一独立運動"],["1919年に開かれたパリ講和会議によって生まれたヨーロッパの新しい秩序体制は?","ヴェルサイユ体制"],["二十一ヵ条の要求の取り消しなどを求め、1919年に起きた中国の排日運動は?","五・四運動"],["1919年のパリ講和会議の基本原則となった十四ヵ条を発表したアメリカ大統領は?","ウィルソン"],];break;
    case "第一次世界大戦後2" :item = [["1920年にスイスのジュネーブを本部にし世界の恒久平和を目的に設立されたのは?","国際連盟"],["1921年に結ばれた四カ国条約の四カ国は?","アメリカ・日本・イギリス・フランス"],["1921～22年にアメリカ大統領のハーディングの提唱で開かれた会議は?","ワシントン会議"],["1921年に結ばれた条約で、太平洋の現状維持と日英同盟の解消となった条約は?","四カ国条約"],["1922年に結ばれた条約で、中国の主権尊重と領土保全がはかられ、石井・ランシング協定が破棄されたものは?","九カ国条約"],["1923年にフランスがベルギーを誘って占領したのはドイツのどこ?","ルール工業地域"],["第一次世界大戦の賠償金でインフレーションが発生したためその対策のために、ドイツのシュトレーゼマン内閣が発行した新紙幣は?","レンテンマルク"],["イタリアでムッソリーニが結成し一党独裁体制を築いた政党は?","ファシスト党"],["1922年にイタリアでムッソリーニが政権獲得のために起こしたクーデターは?","ローマ進軍"],["1924年、ドイツにアメリカ資本を導入することによって経済を復興させる案のことを何という?","ドーズ案"],];break;
    case "第一次世界大戦後3" :item = [["ソ連でレーニンの後継者となり一国社会主義論を掲げた人物は?","スターリン"],["第一次世界大戦下の中国で、北京大学を中心に根本的社会変革を主張する啓蒙運動は?","文学革命"],["中国で口語による白話運動を主張した人物は?","胡適"],["中国で「狂人日記」や「阿Q正伝」などを発表した人物は?","魯迅"],["孫文が掲げた打倒軍閥・帝国主義路線の三大政策とは?","連ソ・容共・扶助工農"],["1924年にイギリスで初めて成立した労働党政権は〇〇内閣","マクドナルド内閣"],["1925年に結ばれたドイツと西欧諸国との国境を維持することを定めた条約は?","ロカルノ条約"],["1925年に上海の労働争議をきっかけに起こった反帝国主義の高まりを示した事件は?","五・三〇事件"],["中国統一のために北伐を始めたが、途中で上海クーデターをおこし共産党を弾圧し南京国民政府を樹立した人物は?","蒋介石"],];break;
    case "第一次世界大戦後4" :item = [["蒋介石の北伐にたいして東北に引き上げようとしたが、日本軍に爆殺された人物は?","張作霖"],["1928年にフランス外相ブリアンとアメリカ国務長官ケロッグの提唱で国際紛争解決の手段として戦争を否定した条約は?","不戦条約"],["インドの国民会議派の指導者で、英国に対し非暴力・不服従運動などを展開した人物は?","ガンジー"],["1929年にラホール国民会議でインドの完全独立の宣言を指導するなどした急進派の人物は?","ネルー"],["1927年にインドネシア国民党を成立させ党首になった人物は?","スカルノ"],["後のインドシナ共産党の母体となる、ベトナム青年革命同志会を1925年に結成した人物は?","ホー=チ=ミン"],["トルコ大国民議会を組織し、ギリシアを撃破し、スルタン制の廃止、連合国とローザンヌ条約を結び、トルコ共和国の大統領となった人物は?","ムスタファ=ケマル"],["エジプトで英国からの独立運動の中心になった党は?","ワフド党"],["中国共産党が江西省瑞金に1931年に成立させたのは?","中華ソヴィエト共和国臨時政府"],];break;
    case "第二次世界大戦までの世界1" :item = [["1929年の10月に起きた世界恐慌に対してアメリカが賠償・戦債の支払いを一年停止したことを何という?","フーヴァーモラトリアム"],["ニューディール政策と呼ばれる政策を実行したアメリカの大統領は?","フランクリン=ルーズベルト"],["フランクリン=ルーズベルトの政策で、農業の生産調整を行い生産過剰を抑制し生活を安定させるように定めた法は?","農業調整法"],["フランクリン=ルーズベルトの政策で、政府と企業の協力をすすめ生産過剰を抑制し公正な競争を促そうとした法は?","全国産業復興法"],["フランクリン=ルーズベルトの政策で公共投資による地方の大型開発をした代表的な公社は?","テネシー川流域開発公社"],["フランクリン=ルーズベルトの政策で、労働者の団結権と団体交渉権を認めた法律は?","ワグナー法"],["イギリスがブロック経済政策であるスターリング=ブロックをはじめることを決めた1932年に開かれた会議は?","オタワ連邦会議"],["日本の関東軍が軍事行動を起こすきっかけとなった奉天郊外で鉄道が爆破された事件は?","柳条湖事件"],["日本の関東軍が満州国を建設した際に皇帝に擁立した人物は?","溥儀"],["ヒトラーが1933年に制定した立法権を政府に移譲して独裁体制を実現した法は?","全権委任法"],["1933年にアメリカが承認し、翌年にソ連が加盟したのは?","国際連盟"],["満州事変に対し、国際連盟が調査のために派遣したのは?","リットン調査団"],];break;
    case "第二次世界大戦までの世界2" :item = [["1934年、中国の共産党が国民党からの攻撃で、本拠地を瑞金から延安に移したことを何という?","長征"],["1935年に中国共産党が、内戦を停止し民族統一戦線の結成を提起した宣言は?","八・一宣言"],["1935年にドイツが再軍備宣言をしたのにフランスが対抗して行ったのは?","仏ソ相互援助条約"],["1936年にドイツがロカルノ条約を破棄して進駐したのは?","ラインライト"],["フランスで1936年に成立した人民戦線内閣で首相になった人物は?","ブルム"],["イタリアが1935年に侵攻し1936年に征服した場所は?","エチオピア"],["1936年にスペインで人民戦線内閣が成立したが、保守派の支持を得て反乱を起こした人物は?","フランコ"],["1936年に起きた張学良が蒋介石を幽閉して、抗日と民族統一戦線の結成を呼びかけた事件は?","西安事件"],["1937年7月に北京郊外で起こった事件で日中戦争開始のきっかけとなった事件は?","盧溝橋事件"],["1938年にドイツが割譲を要求したのはチェコスロヴァキアのどこ?","ズデーテン地方"],["ドイツがズデーテン地方の割譲を要求したのを認めた会談は?","ミュンヘン会談"],["1939年にドイツがソ連と結んだポーランドの分割と東欧の戦力範囲を設定した条約は?","独ソ不可侵条約"],];break;
    case "第二次世界大戦1" :item = [["1939年、ドイツが侵攻し第二次世界大戦のきっかけとなった場所は?","ポーランド"],["1940年にドイツがフランスを侵攻しパリを占領したことによって生まれた、南フランスを統治する政府は?","ヴィシー政府"],["1940年に日本が南京に設立した親日政権の首相は?","汪兆銘"],["ヒトラーが共産党弾圧に利用した事件は?","国会議事堂放火事件"],["ドイツのフランス侵攻に対し、ロンドンに亡命し自由フランス政府を組織した人物は?","ド=ゴール"],["1941年にロシアがドイツ対策として日本と結んだ条約は?","日ソ中立条約"],["1941年にアメリカ・イギリス首脳が発表した戦後構想は?","大西洋憲章"],["1943年11月に発表された対日処理の方針を定めたものは?","カイロ宣言"],["1945年2月にイギリス・アメリカ・ソ連首脳が結んだドイツ処理やソ連の対日参戦を定めたものは?","ヤルタ協定"],["1945年にイギリス・アメリカ・ソ連首脳が発表した日本に無条件降伏を求めたものは?","ポツダム宣言"],];break;
    case "第二次世界大戦後(~’54)1" :item = [["国際連合憲章草案が正式に採択され国際連合が発足したのは1945年4月に開かれた会議は?","サンフランシスコ会議"],["インドネシア共和国が1945年に独立宣言した時の指導者は?","スカルノ"],["国際連合の常任理事国5カ国は?","米・英・仏・ソ・中"],["国際連合の常任理事国が持つ強力な権限は?","拒否権"],["関税などの関税障壁をなくし、世界貿易の発展を目指して1947年に結ばれた協定は?","GATT"],["1947年にギリシア・トルコの共産主義化阻止のためにアメリカが宣言したのは?","トルーマン=ドクトリン"],["1947年にアメリカがヨーロッパ諸国への経済援助の意向を示したものを何という?","マーシャル=プラン"],["1947年にマーシャル=プランに対抗して、ソ連・東欧諸国が各国の共産党の情報交換機関として結成したのは?","コミンフォルム"],["1949年にマーシャル=プランに対抗して東欧6カ国が創設して結束の強化をしたのは?","コメコン"],["1948年におこったチェコスロヴァキアのクーデタを契機に、西欧五カ国で結ばれた条約は?","西ヨーロッパ連合条約"],["1949年にヨーロッパ西側12カ国によって結成され東側の動きを牽制する組織は?","北大西洋条約機構"],];break;
    case "第二次世界大戦後(~’54)2" :item = [["1948年にドイツ西側の通貨改革に反対し、ソ連が実施したことは?","ベルリン封鎖"],["国民党の蒋介石が人民解放軍から逃げた場所は?","台湾"],["1949年に成立した中華人民共和国の主席と首相はそれぞれ誰?","主席：毛沢東　　首相：周恩来"],["1950年に中国とソ連の間に結ばれた条約で日本を仮想敵国とし、社会主義陣営に属することを明らかにした条約は?","中ソ友好同盟相互援助条約"],["南朝鮮で大韓民国が成立した際の大統領は?","李承晩"],["北朝鮮で朝鮮民主主義人民共和国が成立した時の首相は?","金日成"],["フランス領インドシナで、ベトナム独立同盟を組織し、ベトナム民主共和国の成立を宣言したのは?","ホー=チ=ミン"],["ホー=チ=ミンの独立宣言を認めないフランスとの間でおこったインドシナ戦争の休戦協定でフランスは撤退し、北緯17度を軍事境界線とすることを定めたものは?","ジュネーブ休戦協定"],["1950年におきた朝鮮戦争で朝鮮民主主義人民共和国を支援した国は?","中華人民共和国"],["1952年のエジプト革命後しばらくして大統領の地位についたナセルがアスワン=ハイダムの建設資金を得るためにした宣言は?","スエズ運河国有化"],["1954年に中国の周恩来首相とインドのネルー首相が会談して発表したのは?","平和五原則"],];break;
    case "第二次世界大戦後(~’68)1" :item = [["1955年に平和十原則を採択した会議は?","バンドン会議"],["エジプトのスエズ運河国有化宣言に対しイスラエル・イギリス・フランスが軍事行動を起こしておきた戦争は?","スエズ戦争"],["1955年にソ連と東欧八カ国が北大西洋条約機構に対抗して結成したのは?","ワルシャワ条約機構"],["1956年にフルシチョフ第一書記がソ連共産党第20回大会で行ったことは?","スターリン批判"],["1957年にガーナが初めての独立を勝ち取った黒人共和国として独立した時の大統領は?","エンクルマ"],["ラッセルとアインシュタインの提唱で1957年に開かれた核兵器実験の禁止と核兵器廃絶を求めた科学者の会議は?","パグウォッシュ会議"],["1959年にキューバで、親米的なバティス政権を倒した人物は?","カストロ"],["1959年に中国で毛沢東にかわって国家主席になった人物は?","劉少奇"],["劉少奇や鄧小平らを修正主義者と批判して、毛沢東や林彪が行った紅衛兵の動員による党幹部や知識人の追放などをおこなった運動は?","文化大革命"],];break;
    case "第二次世界大戦後(~’68)2" :item = [["1960年に結成された南ベトナムにできた親米政権に対しゲリラ戦を仕掛けた組織は?","南ベトナム解放民族戦線"],["1961年にアメリカ大統領に就任し、ニューフロンティア政策を掲げた人物は?","ケネディ"],["1961年にユーゴスラビアの呼びかけで25カ国参加し平和共存・民族解放の支援・植民地主義の打破を宣言した会議は?","非同盟諸国首脳会議"],["1962年にソ連がキューバにミサイル基地を建設することによっておこった核戦争の危機を何という?","キューバ危機"],["1963年にアメリカ・イギリス・ソ連の間で結ばれた条約は?","部分的核実験停止条約"],["1968年に62カ国が調印した核兵器保有を5カ国に限定する条約は?","核拡散防止条約"],["1963年にエチオピアで開かれたアフリカ諸国首脳会議で、アフリカ諸国の連帯と植民地主義の克服を目指して結成されたのは?","アフリカ統一機構"],["1967年にヨーロッパ石炭鉄鋼共同体とヨーロッパ経済共同体とヨーロッパ原子力共同体が統合されて生まれたのは?","ヨーロッパ共同体（EC）"],["チェコスロヴァキアでドプチェクの自由化推進と、そのことに対し1968年にソ連が軍事介入を行った件は?","プラハの春"],];break;
    case "第二次世界大戦後(~’97)1" :item = [["1971年にドルと金の兌換停止を発表したアメリカ大統領は?","ニクソン"],["1972年に中華人民共和国との関係改善を目指し訪中したアメリカ大統領は?","ニクソン"],["1973年にアメリカがベトナムから完全撤退を約束した協定は?","ベトナム和平協定"],["1978年に日本と中国との国交正常化をはたして結ばれた条約は?","日中平和友好条約"],["カンボジアでシハヌークを追放したあとの政府と対立し内戦をおこなった赤色クメールの指導者は?","ポル=ポト"],["大韓民国で李承晩が失脚した後に、クーデタをおこし権力を握った人物は?","朴正煕"],["インドネシアでスカルノ大統領が失脚後に大統領となり工業化や近代化を推進した人物は?","スハルト"],["アメリカのジョンソン大統領が黒人差別撤廃を目的として成立させた法は?","公民権法"],["アメリカのニクソン大統領が辞任するきっかけになった事件は?","ウォーターゲート事件"],["ソ連でフルシチョフ解任後に第一書記の座についた人物は?","ブレジネフ"],["1973年におきた第4次中東戦争が原因で起きた世界的な経済混乱は?","オイルショック"],];break;
    case "第二次世界大戦後(~’97)2" :item = [["先進国では1国で対応できないような問題が発生するようになったため1975年から政治課題や経済政策の相互協力と調整を協議するために毎年開かれる会議は?","サミット"],["1980年にポーランドでワレサを指導者として結成された自主管理労組は?","連帯"],["1981年に中国で指導者の立場に立ち社会主事市場経済の推進を行った人物は?","鄧小平"],["1986年からベトナムではじめられた緩やかな市場経済をおこなう経済政策は?","ドイモイ"],["1987年にアメリカとソ連との間で結ばれたはじめて核兵器削減に同意した条約は?","中距離核戦力全廃条約"],["1989年に開放された東西ドイツの往来を遮断していたものは?","ベルリンの壁"],["1989年に中国で起こった民主化を要求する学生を政府が弾圧した事件は?","天安門事件"],["1992年に結ばれた欧州連合の創設を定めた条約は?","マーストリヒト条約"],["GATTにかわり自由貿易の促進を目指して1995年に創設された機関は?","WTO"],["ソ連のゴルバチョフ書記長が打ち出した政治や社会体制の全面的見直しする改革運動は?","ペレストロイカ"],["1997年にイギリスから中国に返還された場所は?","香港"],];break;
//
    case "日本史年表1" :item = [["10万年前","日本列島に人類の痕跡が見つかる"],["18000年前","浜北人、港川人が出現"],["12000年前","縄文土器が出現"],["1万年前","海面が上昇(縄文海進)し、日本列島が出来る"],["5900～2200年前頃","青森県三内丸山で縄文人が生活"],["5000年前","縄文時代の最盛期"],["3000年前","稲作が伝わり、西日本で稲作が始まる"],["2700年前","東北地方で亀ヶ岡文化が栄え、遮光器土偶が作られる"],["BC100～20年頃","倭国(日本)に100程のクニ(小国)が存在した"],];break;
    case "日本史年表2" :item = [ ["57年","倭の奴国王が光武帝より漢委奴国王の金印を授かる"],["107年","帥升が160人の生口を後漢に献上"],["146年 - 189年","倭国大乱"],["239年","卑弥呼が魏に遣使"],["248年","卑弥呼が死去"],["266年","倭の女王の壱与が西晋に遣使"],["3世紀後半","ヤマト政権の誕生"],["372年","百済が倭王に七支刀を贈る"],["391年","倭の軍が高句麗・新羅の軍を破る"],];break;
    case "日本史年表3" :item = [["421年","倭王讃が宋に使者を派遣"],["478年","武が宋(南朝)に使者を派遣"],["527年","磐井の乱"],["538年","仏教伝来"],["552年","崇仏論争"],["587年","蘇我馬子や厩戸皇子が物部守屋を滅ぼす"],["592年","推古天皇が即位"],["593年","聖徳太子が摂政になる"],["603年","冠位十二階の制度"],["604年","十七条憲法の制定"],];break;
    case "日本史年表4" :item = [ ["607年","小野妹子が遣隋使年て派遣させる"],["630年","１回目の遣唐使を派遣"],["643年","蘇我入鹿が山背大兄王一族を滅ぼす"],["645年","大化改新"],["663年","白村江の戦い"],["668年","天智大王が即位"],["672年","壬申の乱"],["673","大海人皇子が即位して天武天皇となる"],["690年","持統天皇即位"],["694年","藤原京への遷都"],];break;
    case "日本史年表5" :item = [["697年","文武天皇が即位"],["701年","大宝律令が完成"],["708年","和同開珎が発行"],["710年","平城京への遷都"],["712年","古事記が完成"],["720年","日本書紀が完成"],["723","三世一身の法発布"],["729","長屋王の変"],["740年","藤原博嗣の乱"],["743年","墾田永年私財法"],];break;
    case "日本史年表6" :item = [["757年","橘奈良麻呂の変"],["758年","淳仁天皇が即位"],["759年","万葉集成立"],["764年","藤原仲麻呂の乱/称徳天皇が即位"],["781年","桓武天皇が即位"],["784年","長岡京に遷都"],["788年","比叡山に延暦寺を建立"],["794年","平安京への遷都"],["797年","坂上田村麻呂が征夷大将軍に任命"],["866年","応天門の変"],];break;
    case "日本史年表7" :item = [ ["884年","藤原基経が関白になる"],["894年","遣唐使が廃止"],["901年","菅原道真が大宰府に左遷される"],["935年","平将門の乱"],["939年","藤原純友の乱"],["1016年","藤原道長が摂政になる"],["1051年","前九年の役"],["1086年","白河上皇が院政を始める"],["1156年","保元の乱"],["1159年","平治の乱"],];break;
    case "日本史年表8" :item = [["1167年","平清盛が太政大臣になる"],["1180年","源頼朝が挙兵/治承・寿永の乱"],["1184","宇治川の戦い"],["1185年","平家滅亡/鎌倉幕府の成立"],["1192年","源頼朝が征夷大将軍となる"],["1221年","承久の乱"],["1232年","御成敗式目の制定"],["1274年","文永の役"],["1281年","弘安の役"],["1297年","永仁の徳政令を発布"],];break;
    case "日本史年表9" :item = [["1333年","鎌倉幕府の滅亡"],["1334年","建武の新政"],["1336年","南北朝時代の始まり"],["1338年","足利尊氏が征夷大将軍となる"],["1392年","南北朝が統一"],["1404年","勘合貿易が始まる"],["1441年","嘉吉の乱"],["1467年","応仁の乱"],["1485年","山城国一揆"],["1488年","加賀一向一揆"],];break;
    case "日本史年表10" :item = [["1493年","明応の政変"],["1543年","鉄砲伝来"],["1549年","キリスト教の伝来"],["1561年","川中島に戦い"],["1573年","室町幕府滅亡"],["1582年","本能寺の変"],["1588年","刀狩令を発布"],["1590年","豊臣秀吉が天下統一"],["1592年","文禄の役(朝鮮出兵)"],];break;
    case "日本史年表11" :item = [ ["1597年","慶長の役"],["1600年","関ヶ原の戦い"],["1603年","徳川家康が征夷大将軍となる"],["1612年","キリスト教が禁止される"],["1614年","大坂冬の陣"],["1615年","大坂夏の陣/武家諸法度/禁中並公家諸法度"],["1635","参勤交代を命じる"],["1637年","島原の乱"],["1641年","鎖国体制が完成する"],["1651年","由井正雪の乱(慶安の変)"],];break;
    case "日本史年表12" :item = [ ["1657年","明暦の大火"],["1685年","初の生類憐みの令が発布"],["1702","赤穂浪士討ち入り"],["1709年","正徳の治"],["1716年","徳川吉宗が第8代将軍になる/享保の改革"],["1721年","目安箱を設置"],["1742年","公事方御定書"],["1772年","田沼意次が老中に就任"],["1774年","杉田玄白らが『解体新書』を刊行"],["1782年","天明の飢饉"],];break;
    case "日本史年表13" :item = [["1787年","松平定信がに老中に就任/寛政の改革"],["1825年","異国船打払令"],["1834年","水野忠邦が老中に就任"],["1833年","天保の飢饉"],["1837年","大塩平八郎の乱"],["1841年","天保の改革"],["1853年","ペリー来航"],["1854年","日米和親条約"],["1858年","日米修好通商条約を締結/安政の大獄"],["1860年","桜田門外の変(井伊直弼が暗殺)"],];break;
    case "日本史年表14" :item = [ ["1863年","薩英戦争"],["1864年","禁門の変/池田屋事件"],["1866年","薩長同盟成立"],["1867年","明治天皇即位/徳川慶喜が大政を奉還する"],["1868年","戊辰戦争"],["1869年","版籍奉還"],["1871年","廃藩置県"],["1873年","地租改正/徴兵令"],["1874","板垣退助らが民選議員設立建白書を提出"],["1876年","日朝修好条規"],];break;
    case "日本史年表15" :item = [["1877年","西南戦争"],["1885年","内閣制度が成立"],["1889年","大日本帝国憲法が公布"],["1890年","第一回衆議院議員選挙/第一回帝国議会"],["1894年","日清戦争/領事裁判権の撤廃"],["1895年","三国干渉/下関条約"],["1902年","日英同盟締結"],["1904年","日露戦争"],["1905年","ポーツマス条約"],["1910年","韓国併合"],];break;
    case "日本史年表16" :item = [ ["1911年","日米新通商航海条約(関税自主権が回復)/辛亥革命"],["1914年","第一次世界大戦"],["1915年","中国に21カ条の要求"],["1918年","米騒動/シベリアに出兵/原敬内閣が成立"],["1921年","日英同盟が破棄"],["1922年","全国水平社結成"],["1923年","関東大震災"],["1925年","日ソ基本条約/治安維持法/普通選挙法"],["1931年","満州事変"],["1932年","五・一五事件"],];break;
    case "日本史年表17" :item = [["1936年","二・二六事件"],["1937年","日中戦争"],["1938年","国家総動員法が公布"],["1940年","日独伊三国同盟締結"],["1941年","日ソ中立条約/太平洋戦争"],["1945年","日本無条件降伏"],["1946年","日本国憲法が公布"],["1950年","朝鮮戦争/警察予備隊"],["1951年","サンフランシスコ講和会議(日米安全保障条約)"],["1954年","自衛隊創設"],];break;
    case "日本史年表18" :item = [ ["1956年","日ソ共同宣言"],["1964年","東京オリンピック"],["1965年","日韓基本条約"],["1972年","沖縄県発足/日中共同声明"],["1973年","オイルショック"],];break;
    case "旧石器縄文時代・縄文時代1" :item = [["日本列島が南北でアジア大陸と陸続きだった時代は?","更新世"],["石を打欠いただけで作られていた石器は?","打製石器"],["兵庫県で発見された化石人骨は?","明石人"],["更新世の時に南から日本列島に侵入してきた大型動物は?","ナウマンゾウ・オオツノジカ"],["打製石器を利用していた旧石器時代を代表する群馬県の遺跡は?","岩宿遺跡"],["更新世の時に北から日本列島に侵入してきた大型動物は?","マンモス・ヘラジカ"],["岩宿遺跡が発見された地層は?","関東ローム層"],["沖縄県島尻郡で発見された化石人骨はは?","港川人"],["槍の先などにつけられた、先端を鋭く尖らせた打製石器は?","尖頭器"],["更新世が終わったのは今から何年ほど前?","１万年前"],["小型で細かい長さ2、3センチの打製石器を総称して何という?","細石器"],];break;
    case "旧石器縄文時代・縄文時代2" :item = [["静岡県で発見された化石人骨は?","浜北人"],["更新世が終わって温暖になり海面が上昇するようになった時期は?","完新世"],["原料が広く分布し交易してたことをうかがわせる、弓の先端につけたものは?","石鏃"],["完新世の時期に成立した文化は?","縄文文化"],["地面に掘った穴の上に屋根をかけて作った住居は?","竪穴住居"],["石を磨いて作られた縄文時代を代表する石器で新石器時代の到来を意味するものは?","磨製石器"],["漁労の時に釣り針などに使われたものは?","骨角器"],["厚手で黒褐色、低音で焼かれた縄目の模様が特徴の土器は?","縄文土器"],["石鏃の原材料は?","黒曜石"],["縄文文化を代表する青森県の遺跡は?","三内丸山遺跡"],["呪術的風習のものと考えられている死者の体を折り曲げて埋葬することを何という?","屈葬"],["あらゆるものに霊の力が宿るとする信仰は?","アニミズム"],["呪術的な意味から作られたと考えられている女性をかたどった土製品は?","土偶"],];break;
    case "弥生時代1" :item = [["弥生時代の前期に耕作された土地は主にどういう特徴を持っていた?","湿田"],["石包丁を使った特徴的な収穫方法は?","穂首刈り"],["弥生時代はおよそいつ頃の時期?","紀元前4世紀から紀元後3世紀"],["弥生時代で始まった特徴的な食料採取方法は?","水稲耕作"],["縄文土器より高温で焼かれ、薄手で赤褐色が特徴の土器は?","弥生土器"],["弥生時代の時期に北海道で栄えていたサケ・マスを採取していた文化は?","続縄文文化"],["穂を摘むのに使う磨製石器は?","石包丁"],["青草を田に踏み込むための道具は?","大足"],["弥生時代の後期に耕作されるようになった前期とは違った特徴を持つ土地は、主にどういう特徴を持っていたか?","乾田"],["豊作を祈願する祭りに使われた銅鐸・銅剣・銅戈・銅剣などの道具は?","青銅製祭器"],];break;
    case "弥生時代2" :item = [["他の集落からの攻撃に備えて濠や土塁を備えた集落を何というか?","環濠集落"],["環濠集落を代表する佐賀県の遺跡は?","吉野ヶ里遺跡"],["弥生時代の埋葬方法で、体を伸ばした状態で埋葬する方法は?","伸展葬"],["防衛を重視し高台に作られた集落を何という?","高地性集落"],["高地性集落を代表する香川県の遺跡は?","紫雲出山遺跡"],["弥生時代九州北部に出現した地上に石を置くことを特徴とする墓は?","支石墓"],["近畿地方に出現した周囲に堀をめぐらし方形の盛土をした墓を何という?","方形周溝墓"],["紀元57年に倭の使者との外交・紀元107年に献上を受けたことを記している中国の書は?","「後漢書」東夷伝"],["「後漢書」東夷伝に記されている、107年に安帝に献上したのは倭の誰で何か?","帥升が生口160人"],["紀元前1世紀ごろの倭人の様子を記した中国の書は?","「漢書」地理志"],["「漢書」地理志に記されている、倭人が定期的に使者を送っていた前漢の支配地は?","楽浪郡"],];break;
    case "弥生時代3" :item = [["「後漢書」東夷伝に記されてる、中国に使者を送った倭の人物は?","奴国の王"],["邪馬台国の記述がある中国の書は?","「魏志」倭人伝"],["「後漢書」東夷伝に記されてる、奴国の王の使者が訪れた中国の都市は?","洛陽"],["卑弥呼が、銅鏡とともに、魏の皇帝から贈られた称号は?","親魏倭王"],["「魏志」倭人伝に記されている女王卑弥呼が239年に魏の皇帝に使者を送ったのは朝鮮半島の何処を通じてか?","帯方郡"],["247年、邪馬台国と争った集団は?","狗奴国"],["奴国の王の使者が印綬を受け取ったのは誰から?","光武帝"],["邪馬台国の代表的身分を３つ答えよ","大人・下戸・生口"],["奴国の王の使者が光武帝から授かったと思われる金印が発見された場所は?","志賀島"],["志賀島で発見された金印に記されていたのは?","漢委奴国王"],["卑弥呼の死後、邪馬台国の王となったことで争いをおさめた人物は?","壹与"],];break;
    case "古墳時代1" :item = [["大仙陵古墳がある古墳群は何と呼ばれている?","百舌鳥古墳群"],["3世紀後半から4世紀ごろの古墳時代初期の大規模古墳の特徴は?","前方後円墳"],["大阪府にある最大規模の古墳は?","大仙陵古墳"],["大阪府にある第二の規模となる古墳は?","誉田御廟山古墳"],["大規模な古墳が出現してきた初期の時期での最大の古墳は奈良県の古墳は?","箸墓古墳"],["3世紀後半から4世紀ごろの初期の古墳では木棺や石棺はどこにおさめられたか?","竪穴式石室や粘土槨"],["誉田御廟山古墳がある古墳群は何と呼ばれている?","古市古墳群"],["焼いた鹿の骨で吉凶を占うものを何という?","太占の法"],];break;
    case "古墳時代2" :item = [["6世紀から7世紀の後期の古墳に見られる人や動物の埴輪を何という?","形象埴輪"],["5世紀になって朝鮮から伝わった技術で作られた土器を何という?","須恵器"],["6世紀から7世紀の後期の古墳に見られる朝鮮半島と共通する石室は?","横穴式石室"],["3世紀はじめから5世紀ぐらいまで使われた弥生土器に似た赤褐色の土器は?","土師器"],["収穫の感謝として行われる秋の祭りは?","新嘗祭"],["6世紀から7世紀の後期の古墳に見られる地方で円墳が集中してるものは何というか?","群集墳"],["豊作を祈願して行われる春の祭りは?","祈年祭"],["熱湯に手を入れて手が火傷するかどうかで裁判の真偽を確かめる方法を何という?","盟神探湯"]];break;;break;
    case "ヤマト政権1" :item = [["4世紀初め、朝鮮半島で新羅ができた地域は?","辰韓"],["4世紀初め、朝鮮半島で百済が出来た地域は?","馬韓"],["ヤマト政権と密接な関係を持っていた朝鮮半島南部の小国群は?","加羅"],["4世紀初め、朝鮮半島で馬韓に出来た国家は?","百済"],["4世紀初め、朝鮮半島で辰韓に出来た国家は?","新羅"],["大陸から渡って来た人たちを何という?","渡来人"],["渡来人たちを技術者集団として組織したものを何という?","品部"],["4世紀後半に、朝鮮半島北部から南下し、大和政権と戦ったことが記されているものはどこの国の何か?","高句麗・好太王碑文"],["東漢氏の始祖とされている人物は?","阿知使主"],];break;
    case "ヤマト政権2" :item = [["「論語」や「千字文」などを伝え「漢字」を伝来させた人物は?","王仁"],["弓月君は誰の祖先とされている?","秦氏"],["王仁は誰の祖先とされている?","西文氏"],["ヤマト政権で絹織物を作成した渡来人を何という?","錦織部"],["阿知使主は誰の祖先とされている?","東漢氏"],["ヤマト政権で馬具を作成した渡来人を何という?","鞍作部"],["ヤマト政権で記録や外交文書などを作成した渡来人を何という?","史部"],["倭の五王が5世紀初めから1世紀あまり朝貢したと伝える中国の書は?","「宋書」倭国伝"],["ヤマト政権で鍛鉄を担当した渡来人を何という?","韓鍛冶部"],];break;
    case "ヤマト政権3" :item = [["「宋書」倭国伝に記されてる倭の五王は?","讃・珍・済・興・武"],["ヤマト政権で製陶を担当した渡来人を何という?","陶作部"],["ヤマト政権の政治制度をなんという?","氏姓制度"],["倭の五王の最後の「武」とされている人物は?","雄略天皇"],["ヤマト政権の政治制度で豪族を血縁などをもとに組織したものを何という?","氏"],["雄略天皇と思われる「獲加多支鹵大王」と刻まれた鉄剣が出土した埼玉県の古墳は?","稲荷山古墳"],["「獲加多支鹵大王」と刻まれたと推定されている鉄剣が出土した熊本県の古墳は?","江田船山古墳"],];break;
    case "ヤマト政権4" :item = [["ヤマト政権の大王家に直属する部民を何という?","子代・名代"],["ヤマト政権の政治制度で地位を示す称号は?","姓"],["ヤマト政権で地方の豪族が任じられたのは?","国造"],["ヤマト政権の中枢を担った役職は？（二つ）","大臣・大連"],["ヤマト政権の直轄地を何と言う?","屯倉"],["ヤマト政権の大臣・大連の下に置かれ、品部を統率したのは?","伴造"],["ヤマト政権時代の豪族の私有地を何と言う?","田荘"],["ヤマト政権下で6世紀初めに筑紫で起きた反乱は?","磐井の乱"],["ヤマト政権時代の豪族の私有民を何と言う","部曲"],];break;
    case "飛鳥時代1" :item = [["欽明天皇に仏像・経論などを贈ったのはどこの誰か?","百済・聖明王"],["6世紀に儒教・医学を伝えたのはどこの国から来た誰か?","百済・五経博士"],["百済の聖明王が仏像・経論などを贈った人物は?","欽明天皇"],["百済の聖明王の使者が仏像と経論を贈った際、仏教を興隆させようとした人物は?","蘇我稲目"],["602年、百済の観勒が伝えたものは?","暦法"],["「日本書紀」や「古事記」のもとになった大王の系譜を記したものを何という?","帝紀"],["610年、紙・墨・絵具を伝えたのはどこの国の誰か?","高句麗・曇徴"],["ヤマト政権で磐井の乱まで主導権を握っていた豪族は?","大伴氏"],["「日本書紀」や「古事記」のもとになった朝廷の伝承・説話を記したものを何というか?","旧辞"],["大伴氏の後ヤマト政権の主導権を争った豪族で、軍事的力を担っていた豪族は?","物部氏"],];break;
    case "飛鳥時代2" :item = [["587年、蘇我馬子が滅ぼした政敵は?","物部守屋"],["大伴氏の後ヤマト政権の主導権を争った豪族で、渡来人と結びつきを強く持った豪族は?","蘇我氏"],["推古天皇の摂政は?","厩戸王（聖徳太子）"],["592年、蘇我馬子が暗殺したのは?","崇峻天皇"],["推古天皇時代の603年に制定された氏族でなく個人に冠位を与える制度は?","冠位十二階"],["推古天皇時代の604年に制定された道徳的規範を示し、仏教を政治理念として重んじることを定めたものは?","憲法十七条"],["冠位十二階の位で、大小に分けた6種類の位を位の高い順に並べよ","徳・仁・礼・信・義・智"],["推古天皇時代の607年に中国に派遣されたものは?","遣隋使"],["蘇我氏の創建と言われる寺は?","飛鳥寺"],["607年に派遣された遣隋使の使者となったのは?","小野妹子"],];break;
    case "飛鳥時代3" :item = [["小野妹子ら遣隋使の様子を記した中国の書は?","「隋書」倭国伝"],["小野妹子らの遣隋使の答礼使として、608年来日した人物は?","裴世清"],["遣隋使が持参した国書に書かれていて中国の指導者が無礼と感じたとされる記述は?","日出づる処の天子"],["遣隋使の持参した国書の記述「日出づる処の天子」を無礼と感じた中国の指導者は誰?","煬帝"],["舒明天皇の創建と言われる寺は?","百済大寺"],["飛鳥寺式や法隆寺式などがある塔や金堂などの配置形式を何という?","伽藍配置"],["聖徳太子の創建と言われる寺は?","法隆寺"],["飛鳥文化の絵画で光沢を持つ油絵は?","密陀絵"],["北魏様式の「飛鳥寺釈迦如来像」や「法隆寺金堂釈迦三尊像」の作者は?","鞍作鳥"],["乙巳の変の後即位した天皇は?","孝徳天皇"],];break;
    case "飛鳥時代4" :item = [["蘇我入鹿が殺害した厩戸王の子は?","山背大兄王"],["645年、中大兄皇子が中臣鎌足や蘇我倉山田石川麻呂の協力のもと蘇我蝦夷・蘇我入鹿を殺害した政変を何というか?","乙巳の変"],["旻・高向玄理が乙巳の変の後付いた役職は?","国博士"],["645年、中大兄皇子が中臣鎌足や蘇我倉山田石川麻呂の協力のもと殺害した人物は?","蘇我蝦夷・蘇我入鹿"],["646年、孝徳天皇が発した新たな政治方針は?","改新の詔"],["唐と協力して高句麗・百済を滅ぼしたのは?","新羅"],["改新の詔で決めた、豪族の私有地を公のものとする制度は?","公地公民制"],["孝徳天皇のあとを継いだ天皇は?","斉明天皇"],["663年、百済復興のために兵を送り起こった戦いは?","白村江の戦い"],["中大兄皇子は何天皇になった?","天智天皇"],];break;
    case "飛鳥時代5" :item = [["667年、中大兄皇子が都を移した場所は?","近江大津宮"],["天智天皇の時に作られた日本初の戸籍を何という?","庚午年籍"],["672年、天智天皇の子と天智天皇の弟で起こった事件は?","壬申の乱"],["672年に壬申の乱を起こした天智天皇の子は?","大友皇子"],["天智天皇の弟は?","大海人皇子"],["大海人皇子は何天皇になった?","天武天皇"],["天武天皇の政策で豪族たちの身分秩序を作ったものは?","八色の姓"],["天武天皇が遷都した都は?","飛鳥清御原宮"],["天武天皇の皇后は何天皇になった?","持統天皇"],];break;
    case "飛鳥時代(大宝律令)1" :item = [["701年、文武天皇の命令で、刑部親王や藤原不比等が中心となって作ったものは?","大宝律令"],["持統天皇が遷都した場所は?","藤原京"],["大宝律令を中心となって作った人物は?（二人）","刑部親王・藤原不比等"],["持統天皇の時に作られた戸籍を何という?","庚寅年籍"],["大宝律令で定められた、宮中の祭祀を取り扱う機関は?","神祗官"],["大宝律令のモデルとした国は?","唐"],["大宝律令のなかで現在の民法や行政法にあたるものは?","令"],["大宝律令で定められた左弁官の下で詔書の作成をする機関は?","中務省"],["大宝律令のなかで現在の刑法にあたるものは?","律"],["大宝律令で定められた左弁官の下で大学の管理や分館の人事を担当する機関は?","式部省"],];break;
    case "飛鳥時代(大宝律令)2" :item = [["大宝律令で特に厳しく定められた国家や天皇などに対する罪は?","八虐"],["大宝律令で定められた左弁官の下で租税などを扱った機関は?","民部省"],["大宝律令で定められた右弁官の下で裁判などをする機関は?","刑部省"],["大宝律令で定められた左弁官の下で仏事や外交事務をする機関は?","治部省"],["大宝律令で定められた右弁官の下で財政を扱う機関は?","大蔵省"],["大宝律令で里の統治をする人物の役職は?","里長"],["大宝律令で定められた右弁官の下で宮中の業務を扱う機関は?","宮内省"],["大宝律令で定められた右弁官の下で軍事を扱う機関は?","兵部省"],["大宝律令で難波に置かれた役職は?","摂津職"],];break;
    case "飛鳥時代(大宝律令)3" :item = [["大宝律令で中央から派遣された地方を統治する役人は?","国司"],["大宝律令で定められた京に置かれた行政・治安・司法を統括する役職は?","京職"],["大宝律令で郡の統治をする人物の役職をは?","郡司"],["大宝律令で北九州に設置された機関は?","太宰府"],["大宝律令で地方を統治する役所は?","国府"],["官位相当制は何に応じた官職が与えられる?","位階"],["大宝律令の時代、毎年作成された税徴収の基本の台帳となるものは?","計帳"],["大宝律令で6才以上の良民男子には口分田はどれほど与えられた?","2段"],["大宝律令で定められた賤民は五つに区分されたが何という?","五色の賤"],];break;
    case "飛鳥時代(大宝律令)4" :item = [["五色の賤のうち、私有のものは?","家人・私奴婢"],["五色の賤のうち、官有のものは?","陵戸・官戸・公奴婢"],["大宝律令で民衆は大きく二つに分けられた。良民と何?","賤民"],["大宝律令の時代では、戸籍は何年ごとに作られた?","6年"],["大宝律令で6才以上の良民女子には口分田はどれほど与えられた?","1段120歩"],["大宝律令の時代の租税で、各国の産物を中央政府に収める税は?","調"],["大宝律令で家人・私奴婢には良民と比べて口分田はどれほど与えられた?","3分の1"],["大宝律令の時代の租税で、口分田からの収穫の約3％の稲を収める税は?","租"],["大宝律令で21～60才男子は正丁とされたが、61～65才男子と17才～20才男子は何とされた?","61～65才男子　次丁　17才～20才男子　中男"],];break;
    case "飛鳥時代(大宝律令)5" :item = [["人民へ田を与え、代わりに税を徴収する大宝律令以後本格的に成立したと思われる仕組みを何という?","班田収授法"],["大宝律令の時代の租税で、国司の命令で60日を限度に課される労役を何という?","雑徭"],["大宝律令の時代の租税で、労働の代わりに麻布を中央政府に収める税は?","庸"],["大宝律令の兵役の中で、宮門を警備する者は?","衛士"],["白鳳文化期の彫刻で蘇我倉山田石川麻呂の霊を弔うために685年に作られたものは?","興福寺仏頭"],["白鳳文化期の建物で、天武天皇が持統天皇の病気回復祈願で創建したとされるのは?","薬師寺"],["白鳳文化期の壁画で、高句麗の古墳壁画と酷似しているものは?","高松塚古墳壁画"],["舒明天皇が創建した百済大寺を天武天皇が移転した際改名されて名付けられたものは?","大官大寺"],["大宝律令の兵役の中で、東国から多く選ばれた九州北部を警備する者を何という?","防人"],];break;
    case "奈良時代1" :item = [["平城京がモデルとした都市は?","唐の長安"],["平城京に建てられた南都七大寺を全て答えよ","薬師寺・元興寺・大安寺・東大寺・西大寺・法隆寺・興福寺"],["平城京の時代に、地方に置かれた政治の中心地を何という?","国府"],["710年、都を藤原京から平城京に遷都した天皇は?","元明天皇"],["平城京で採用された、道路を碁盤の目のように区画する制度は?","条坊制"],["708年に鋳造され始め、日本で最初の流通貨幣と言われるものは?","和同開珎"],["平城京の右京と左京を分ける道路を何という?","朱雀大路"],["711年に和同開珎の流通を促進させるために発布したものは?","蓄銭叙位令"],["平城京の時代に国府のすぐそばに置かれた寺を何という?","国分寺"],["聖武天皇即位時に左大臣になった皇族を藤原不比等の子らが殺害する政変を何という?","長屋王の変"],];break;
    case "奈良時代2" :item = [["文武天皇に娘を嫁がせた人物は?","藤原不比等"],["聖武天皇に重用された帰国した遣唐使は?（二人）","吉備真備・玄昉"],["後に聖武天皇になる文武天皇の皇子に藤原不比等が嫁がせた娘は?","光明子"],["藤原不比等の子の4兄弟が病死した後権力を握った人物は?","橘諸兄"],["長屋王の変を起こした藤原不比等の子の4兄弟を挙げよ","武智麻呂・房前・宇合・麻呂"],["吉備真備・玄昉を排除を求めて太宰府で起きた反乱は?","藤原広嗣の乱"],["奈良の大仏が完成したときの天皇は?","孝謙天皇"],["孝謙天皇の時、皇太后の光明子の力で勢力を伸ばした藤原の家系の人物は?","藤原仲麻呂"],["聖武天皇が741年に発して全国に僧寺・尼寺を作らせたものは?","国分寺建立の詔"],["藤原仲麻呂が757年橘諸兄の子を滅ぼした政変を何という?","橘奈良麻呂の変"],["孝謙天皇が復位して称徳天皇となった際権力を握り、仏教政治を押し進めた人物は?","道鏡"],];break;
    case "奈良時代3" :item = [["藤原仲麻呂が淳仁天皇を擁立し太政大臣となり賜った名前は?","恵美押勝"],["称徳天皇死後、天智天皇系の光仁天皇を擁立し実権を握った人物は?","藤原百川"],["奈良時代の頃、農民に与えられる口分田以外の公の田を何という?","乗田"],["奈良時代になって広がり始めた住居はどういったものか?","掘立柱住居"],["口分田以外の公の田や貴族の土地を耕し、収穫の五分の一を支払う制度は?","賃租"],["723年に政府の税収アップをねらって定められた法は?","三世一身法"],["奈良時代の盛唐文化の影響を受けている文化は?","天平文化"],["743年に政府の税収アップをねらって定められた法は?","墾田永年私財法"],["墾田永年私財法によって、地方豪族や寺社が積極的に農地開発したことでよって生まれたものは?","初期荘園"],["官吏養成機関として中央に置かれたものは?","大学"],];break;
    case "奈良時代4" :item = [["奈良時代の頃、課税から逃れるために勝手に僧になったものを何という?","私度僧"],["日本で最初の公開図書館とされている施設は?","芸亭"],["官吏養成機関として地方に置かれたものは?","国学"],["712年に古事記を作らせた天皇は?","天武天皇"],["日本で最初の公開図書館とされている芸亭を作った人物は?","石上宅嗣"],["712年、「帝紀」や「旧辞」の誦習で、古事記作成に大きな力となった人物は?","稗田阿礼"],["712年の古事記作成の際、稗田阿礼の誦習を書き留めたとされる人物は?","太安万侶"],["713年成立した日本各国の地理を編纂したものは?","風土記"],["720年成立した日本書紀を中心となって編纂した人物は?","舎人親王"],["720年成立した日本最古の正史は?","日本書紀"],];break;
    case "奈良時代5" :item = [["751年に成立した最古の漢詩集は?","懐風藻"],["山上憶良の農民の苦しい生活を読んだものは?","貧窮問答歌"],["奈良時代に鑑真が創建した寺は?","唐招提寺"],["759年に成立した最古の和歌集は?","万葉集"],["奈良時代に唐招提寺を創建した僧は?","鑑真"],["奈良時代の思想で仏と神が同一であるという考え方は?","神仏習合"],["奈良時代に庶民に仏法の教えを説き、大仏造立に協力した僧は?","行基"],["天平文化期の代表的彫刻で木を芯にして粘土を塗り固めた像は?","塑像"],["天平文化期の代表的彫刻で麻布を漆で張り重ねたりしてつくる像は?","乾漆像"],["天平文化期の代表的建築の東大寺正倉院宝庫の建築方法は?","校倉造"]];break;;break;
    case "平安時代(初期)1" :item = [["784年、桓武天皇が平城京から移した都は?","長岡京"],["長岡京の造営を主導した人物で、暗殺されたのは?","藤原種継"],["780年に蝦夷にて起きた反乱は?","伊治呰麻呂の乱"],["794年、平安京へ都を移すことになったがそれを提案した人物は?","和気清麻呂"],["平安時代の蝦夷討伐の拠点の役所のことを何という?","鎮守府"],["797年にある人物をある役職に任じて蝦夷征討させたがそれは何という役職と誰?","征夷大将軍・坂上田村麻呂"],["桓武天皇が設けた国司の不正など地方行政を監視する役職は?","勘解由使"],["802年に鎮守府は移されるが何処からどこへ移された?","多賀城から胆沢城"],["勘解由使など令に定められていない官職を何という?","令外官"],["平城上皇と嵯峨天皇の政策的衝突で平城上皇が出家することになった政変は?","薬子の変"]];break;;break;
    case "平安時代(初期)2" :item = [["桓武天皇が郡司の子弟など選抜し国内の治安維持に当たらせたのは?","健児"],["薬子の変の藤原薬子の兄で射殺された人物は?","藤原仲成"],["初代の蔵人頭になった人物は?（二人）","藤原冬嗣・巨勢野足"],["嵯峨天皇の政策の一つで810年に設置された令外官で天皇の書記官の役目をしたのは?","蔵人頭"],["嵯峨天皇の政策の一つで、律令を補足するものと施行細則を編纂したものは?","弘仁格式"],["嵯峨天皇の政策の一つで816年に設置された平安京の警察の役目をしたのは?","検非違使"],["弘仁格式で律令の規定を補足修正するものを何という?","格"],["弘仁格式を編纂した人物は?","藤原冬嗣"],["弘仁格式で施行細則にあたるものは?","式"],["天台宗を開いた最澄の弟子で天台宗の密教を確立した人物は?（2人）","円仁・円珍"],];break;
    case "平安時代(初期)3" :item = [["遣唐使で804年に入唐し、天台宗を開いた人物は?","最澄"],["弘仁・貞観文化期に貴族が教育のために設けたものは?","大学別曹"],["9世紀末頃までの文化で唐風の傾向と密教の影響をもつののが特徴の文化は?","弘仁・貞観文化"],["空海が開いた宗教は?","真言宗"],["最澄が開いた宗教は?","天台宗"],["空海が開いた真言宗の中心となる寺は?","高野山金剛峰寺"],["真言宗を開いた空海の代表的漢詩文集は?","性霊集"],["最澄が開いた天台宗の中心となる寺は?","比叡山延暦寺"],["真言宗を開いた空海の代表的詩論は?","文鏡秘府論"],["弘仁・貞観文化期での大学の学問で特に儒教に学ぶ学科のことを何という?","明経道"]];break;;break;
    case "平安時代(初期)4" :item = [["天台宗を開いた最澄の代表的著作は?","顕戒論"],["大学別曹の中で、藤原氏のものは?","勧学院"],["真言宗を開いた空海の代表的論文は?","三教指帰"],["弘仁・貞観文化期の勅撰漢詩集を3つ挙げよ","「凌雲集」「文華秀麗集」「経国集」"],["弘仁・貞観文化期の仏像彫刻の特徴は?","一木造"],["仏教と山岳信仰が結びつき生まれた宗教は?","修験道"],["空海が設けた庶民教育する機関をは?","綜芸種智院"],["弘仁・貞観文化期での大学の学問で特に中国の歴史を学ぶ学科のことを何という?","紀伝道"],["弘仁・貞観文化期に三筆とされた人物は?(3人)","嵯峨天皇・空海・橘逸勢"],["弘仁・貞観文化期の絵画で仏の世界を独特の構図で描いたものは?","曼荼羅"],];break;
    case "平安時代(中期)1" :item = [["842年に起こった、伴健岑や橘逸勢が藤原氏によって排斥された政変は?","承和の変"],["866年に起こった伴善男や紀豊城が排斥された政変は?","応天門の変"],["藤原冬嗣の子で、人臣初の摂政となった人物は?","藤原良房"],["藤原良房の養子で初の関白となった人物は?","藤原基経"],["宇多天皇が藤原基経の力を弱めようとしたが失敗した事件は?","阿衡の紛議"],["延喜の荘園整理令や延喜格式などの政策をすすめ、天皇親政をおこなった天皇は？","醍醐天皇"],["宇多天皇が藤原基経の死後重用し、遣唐使の廃止を進言した人物は？","菅原道真"],["藤原基経の子で、901年には菅原道真を太宰府に左遷させた人物は?","藤原時平"],["901年に菅原道真が太宰府に左遷させられた政変は?","昌泰の変"],["私財を収めることで、収入の多い官職を再び得ることを何という?","重任"],];break;
    case "平安時代(中期)2" :item = [["藤原基経やその子の時平など、平安中期に権力を握ったのは藤原◯家","藤原北家"],["私財を出して朝廷の儀式や寺社の造営を行うかわりに官職を得ることを何という?","成功"],["969年に起こった反乱で、以後摂政か関白が常設されることになった事件は?","安和の変"],["安和の変によって左遷された左大臣は?","源高明"],["藤原家が天皇のこれに該当することで権力を握った、母方の親戚のことを何という?","外戚"],["忌むべく方向を避けて、前日夜に吉方の家に泊まることを何という?","方違"],["平安期の貴族の男性の正装は?","束帯"],["一定期間、特定の建物で謹慎することを何という?","物忌"],["男性貴族の成人式で同時に官職を得るものを何という?","元服"],["往生しようとする人を仏が迎えにくる様子を書いた図を何という?","来迎図"],];break;
    case "平安時代(中期)3" :item = [["聖徳太子などの往生伝を記した「日本往生極楽記」を書いた人物は?","慶滋保胤"],["国風文化期の作品で、清少納言の宮廷のことを書いた随筆は?","枕草子"],["国風文化期の日本絵画の様式で絵巻物に利用されたものは?","大和絵"],["最初の勅撰和歌集である「古今和歌集」はどの天皇の命で作られた?","醍醐天皇"],["藤原道長の「この世をばわが世とぞ思ふ 望月のかけたることもなしと思へば」が収録されている作品は?","小右記"],["醍醐天皇の命で編纂された最初の勅撰和歌集である「古今和歌集」を編纂した人物は?","紀貫之"],["国風文化期の作品で在原業平をモデルとした、かな物語は?","伊勢物語"],["紀貫之の作品で最初のかな日記は?","土佐日記"],["菅原孝標の女が書いた人生を回想した国風文化期の作品は?","更級日記"],["「小右記」の作者は?","藤原実資"],];break;
    case "平安時代(中期)4" :item = [["10世紀半ばに諸国で念仏を唱え「市聖」とよばれた人物は?","空也"],["天台宗の僧侶の源信の著作で念仏往生の教えを説いた書物は?","往生要集"],["10世紀から11世紀の文化でかな文字を象徴とする文化は?","国風文化"],["905年に成立した国風文化期の和歌集で、紀貫之の編纂の和歌集は?","古今和歌集"],["平安中期に生まれた、日本の八百万の神は仏の化身であるとする説は?","本地垂迹説"],["平安中期によく行われた不慮の死などによって生まれた怨霊や疫病神を鎮める祭礼は?","御霊会"],["国風文化期の建築様式で、貴族の住居に使われた白木造・檜皮葺の建築様式は?","寝殿造"],["伊勢物語でモデルにされている人物は?","在原業平"],["書道の和様の名手で三蹟と呼ばれた人物は?","小野道風・藤原行成・藤原佐理"],["藤原道長が建立した寺は?","法成寺"],];break;
    case "平安時代(中期)5" :item = [["藤原頼通が建立した元は別荘だったものは?","平等院鳳凰堂"],["平等院鳳凰堂の本尊の「阿弥陀如来像」を作った人物は?","定朝"],["定朝が完成させた仏像の大量生産を可能にした技法は?","寄木造"],["国風文化期の作品で「源氏物語」の作者は?","紫式部"],["漆で金銀を定着させる技法のことを何という?","蒔絵"],["釈迦の死後、正しい教えが廃りだんだんと世の中が乱れていくという考え方は?","末法思想"],["国司が荘園の調査のために派遣する役人を何という?","検田使"],["律令制度が破綻し始めた頃、徴税請負人の役目をする国司は何といわれた?","受領"],["寄進地系荘園が生まれた頃、耕作の請負人のような役目をした有力農民のことを何という?","田堵"],["欲深い受領とされる人物で「尾張国郡司百姓等解文」でもって役職を解雇された人物は?","藤原元命"],];break;
    case "平安時代(中期)6" :item = [["検田使の立ち入りを拒否する権利のことを何という?","不入の権"],["国司に任じられても現地へ行かずに収入だけを得ることを何という?","遙任"],["遙任した国司のかわりに派遣される代理のことを何という?","目代"],["国司の代わりに実際に実務をする地方官人のことを何という?","在庁官人"],["田堵のなかでも大規模な農民のことを何という?","大名田堵"],["律令制度が崩壊以後、租調庸などに由来する租税のことを何という?","官物"],["領家がさらに、立場が上の貴族や寺社などに寄進する場合、それらを何という?","本家"],["本家や領家の力を利用して税の免除を受け、税を収めない権利のことを何という?","不輸の権"],["政府によって特権が認められた荘園を何という?","官省符荘"],["国司によって特権が認められ、その国司の在任期間のみ特権が与えられる荘園を何という?","国免荘"],["税逃れのため、土地の寄進を受ける代わりに、保護する権力者のことを何という?","領家"],];break;
    case "平安時代(後期)1" :item = [["平安時代に強盗などへ逮捕や制圧を目的に置かれたのは?","追捕使"],["9世紀末頃から蔵人所の下で朝廷警護していたのは?","滝口の武士"],["平安時代にもとは戦乱時の制圧のために定められたが、地方の警察のような役割をするようになったのは?","押領使"],["939年に二つの武士の反乱が起きたが、まとめて何といわれている?","承平・天慶の乱"],["平将門は自らを何と称した?","新皇"],["939年にある武士が関東国府を襲撃して起きた反乱は?","平将門の乱"],["平将門の乱を制圧した藤原秀郷はどんな役職だった?","下野押領使"],["平将門の乱を制圧した武士は?（2人）","平貞盛・藤原秀郷"],["939年に伊予の国司だった人物が起こした反乱は?","藤原純友の乱"],["藤原純友の乱を制圧した清和源氏の家系の租は?","源経基"],];break;
    case "平安時代(後期)2" :item = [["1028年に起きた清和源氏の東国進出のきっかけとなった反乱は?","平忠常の乱"],["平忠常の乱を制圧した人物は?","源頼信"],["1051年に陸奥の国司と豪族安倍氏との争いから起こった戦いは?","前九年の役"],["前九年の役を平定した父子は?","源頼義・義家"],["1083年に清原氏の内紛が元で起こった戦いは?","後三年の役"],["後三年の役の後奥州を支配した人物は?","藤原清衡"],["後三年の役を平定した人物は?","源義家"],["後三条天皇の政策で、摂関家に打撃を与え公領や皇室領の増加につながった政策は?","延久の荘園整理令"],["1068年に即位した藤原氏を外戚としない天皇は?","後三条天皇"],["後三条天皇の時に、近臣として重要な役割をした人物は?","大江匡房"],];break;
    case "平安時代(後期)3" :item = [["延久の荘園整理令を統括する為に作られた役所は?","記録荘園券契所"],["公領や荘園領主から名田の経営を請け負い、領主への納税する役目をした有力農民を何という?","名主"],["名主が下人・作人に労役などの奉仕をさせる税は?","夫役"],["名主が下人・作人に手工業製品や特産物などを収めさせる税は?","公事"],["名主が下人・作人に米・絹などを収めさせる税は?","年貢"],["後三条天皇の次の天皇で後に上皇となり、院政を行った天皇は?","白河天皇"],["白河上皇が作った院庁の警備をするものを何という?","北面の武士"],["白河上皇の命令を伝えるものはどんなものがあった?（２つ）","院庁下文・院宣"],["寺院が僧兵を利用して朝廷に要求を飲まそうとすることを何という?","強訴"],["上皇の側近で収益の豊かな国の国司などに任命された者たちを何という?","院の近臣"],];break;
    case "平安時代(後期)4" :item = [["白河上皇が繰り返し財政逼迫の原因となった参拝は?（２つ）","熊野詣・高野詣"],["六勝寺と総称される寺院のなかで、白河天皇が建立した寺院は?","法勝寺"],["六勝寺と総称される寺院のなかで、堀河天皇が建立した寺院は?","尊勝寺"],["六勝寺と総称される寺院のなかで、鳥羽天皇が建立した寺院は?","最勝寺"],["六勝寺と総称される寺院のなかで、崇徳天皇が建立した寺院は?","成勝寺"],["六勝寺と総称される寺院のなかで、待賢門院が建立した寺院は?","円勝寺"],["六勝寺と総称される寺院のなかで、近衛天皇が建立した寺院は?","延勝寺"],["1156年に皇室や摂関家の内紛から起こった戦乱は?","保元の乱"],["保元の乱で勝った平氏の人物と負けた人物は?","勝ち・平清盛　負け・平忠正"],["保元の乱で勝った摂関家の人物と負けた人物は?","勝ち・藤原忠通　負け・藤原頼長"],];break;
    case "平安時代(後期)5" :item = [["保元の乱で勝った皇室関係の人物と負けた人物は?","勝ち・後白河天皇　負け・崇徳上皇"],["保元の乱で勝った源氏の人物と負けた人物は?","勝ち・源義明　負け・源為義"],["1159年に起き、結果として政治の実権が武士に移っていくことになった戦乱は?","平治の乱"],["平治の乱で鎮圧した平氏側と藤原家の人物は?","平清盛・藤原信西"],["平治の乱で挙兵した源氏側と藤原家の人物は?","源頼朝・藤原信頼"],["院政期文化の絵巻物で藤原隆能が作者とされているのは?","源氏物語絵巻"],["1167年武士ではじめて平清盛が任じられたの役職は?","太政大臣"],["平清盛が力を入れた日宋貿易で日本にもたらされた代表的なものは?","宋銭"],["奥州藤原氏が平泉に建てた院政期文化の代表的建築物は?","中尊寺金色堂"],["日宋貿易推進のために修築された港は?","大輪田泊"],];break;
    case "平安時代(後期)6" :item = [["院政期文化の建築物で現在の大分県・豊後に建てられた阿弥陀堂は?","富貴寺大堂"],["院政期文化の歴史物で摂関家を批判した書は?","大鏡"],["院政期文化の軍記物で平将門の乱を扱ったものは?","将門記"],["院政期文化の歴史物で摂関家を賛美した書は?","栄花物語"],["平清盛らが平家納経を奉納した神社は?","厳島神社"],["院政期文化の軍記物で前九年の役を扱ったものは?","陸奥話記"],["平清盛らが厳島神社に奉納した装飾経は?","平家納経"],["院政期文化の絵巻物で、動物を擬人化したものは?","鳥獣戯画"],["院政期文化の絵巻物で常盤光長が作者とされているのは?","伴大納言絵巻"],["伴大納言絵巻は何を題材に描かれている?","応天門の変"],];break;
    case "鎌倉時代(初期)1" :item = [["1177年に起こった平氏打倒計画で、背後に後白河院がいた事件は?","鹿ヶ谷の陰謀"],["鹿ヶ谷の陰謀を計画した後白河院の側近と僧は?","藤原成親・俊寛"],["1180年に平氏が都を移したものの半年で京に戻ることになったが、その移した先の都は?","福原京"],["1185年に起きた平氏が滅亡した戦いは?","壇ノ浦の戦い"],["1185年に源頼朝が後白河法皇に認めさせた権利のうち、荘園から徴収されるようになったのは何でどれくらい?","反別5升の兵糧米"],["1185年に源頼朝が後白河法皇に認めさせた権利のうち、荘園に置かれたものは?","地頭"],["1185年に源頼朝が後白河法皇に認めさせた権利のうち、全国に置かれたものは?","守護"],["鎌倉幕府の御恩と奉公で結ばれた制度は?","封建制度"],["鎌倉幕府の組織で、御家人を統率して軍事・警察を担当した組織は?","侍所"],["1189年に行われた奥州征討で滅ぼされたのは誰で何氏?","藤原泰衡・奥州藤原氏"],];break;
    case "鎌倉時代(初期)2" :item = [["鎌倉幕府の侍所初代別当になった人物は?","和田義盛"],["鎌倉幕府の制度で、先祖から伝わる領地を保障することを何という?","本領安堵"],["鎌倉幕府の制度で、新たに所領を与えることを何という?","新恩給与"],["鎌倉幕府の組織で、元は公文所で後に改称された一般政務を担当した組織は?","政所"],["鎌倉幕府の政所初代別当になった人物は?","大江広元"],["鎌倉幕府の問注所初代執事になった人物は?","三善康信"],["鎌倉幕府の組織で、裁判訴訟を担当した組織は?","問注所"],["将軍が地頭を補任することが出来た荘園や国衙領のことを何という?","関東進止の地"],["鎌倉時代の守護に与えられた、大番催促・謀反人殺害人の逮捕といった権限をまとめて何という?","大犯三ヵ条"],["平家没官領などの源頼朝の荘園のことを何という?","関東御領"],];break;
    case "鎌倉時代(初期)3" :item = [["伊豆・相模など9ヵ国あった源頼朝の知行国のことを何という?","関東御分国"],["鎌倉幕府2代目将軍は?","源頼家"],["1203年に起こった、結果として源頼家が幽閉されのちに殺害されることになった北条氏打倒の企てを何という?","比企能員の乱"],["比企能員の乱の後、執権として実権を握った人物は?","北条時政"],["北条時政の子で侍所別当を倒し、政所と侍所の別当を兼務して北条一族地位を固めた人物は?","北条義時"],["1213年に北条義時によって倒された、侍所別当をしていた有力御家人は?","和田義盛"],["後鳥羽上皇が院の警護や鎌倉幕府に対抗するためにおいた武士を何という?","西面の武士"],["1221年に後鳥羽上皇が北条義時追討しようとしておきた戦いは?","承久の乱"],["1221年の承久の乱で京都に攻め入った幕府方の人物は?（2人）","北条泰時・北条時房"],];break;
    case "鎌倉時代(初期)4" :item = [["承久の乱の後、朝廷監視や西国の管理のために置かれたのは?","六波羅探題"],["承久の乱の後、隠岐に流された人物は?","後鳥羽上皇"],["承久の乱の後、土佐に流された人物は?","土御門上皇"],["承久の乱の後、佐渡に流された人物は?","順徳上皇"],["承久の乱の後、上皇側から没収した荘園の地頭に新たになった御家人を何という?","新補地頭"],["3代目執権北条泰時の時に設置された執権を補佐する役職は?","連署"],["初代連署になった人物は?","北条時房"],["3代目執権北条泰時の時に設置された重要政務を合議で決める機関は?","評定衆"],["3代目執権北条泰時の時に定められた武家社会にのみ適用される51条からなる初の武家法は?","御成敗式目"],];break;
    case "鎌倉時代(中期)1" :item = [["鎌倉幕府時代の5代目執権は?","北条時頼"],["北条時頼の時に設置された所領裁判迅速化をはかり評定衆の下に設置された機関は?","引付衆"],["北条時頼が宝治合戦で滅ぼした御家人は?","三浦泰村"],["北条時頼が三浦泰村と戦い滅ぼした戦いは?","宝治合戦"],["北条時頼の時はじめて皇族将軍になった人物は?","宗尊親王"],["騎射三物とは具体的には?","犬追物・笠懸・流鏑馬"],["鎌倉時代に行われた、荘園領主が地頭に荘園の管理をさせ決まった年貢を納入させる制度は?","地頭請"],["鎌倉時代に行われた、荘園領主が土地を地頭に分け与える代わりに荘園に干渉しない約束を結ぶことを何という?","下地中分"],["囲いを縮めながら獲物を追いつめて射止める大規模な狩猟で、武士の訓練ともなっていたものは?","巻狩"],["荘園領主に収める年貢とは別に地頭が農民から徴収する米のことを何という?","加徴米"],];break;
    case "鎌倉時代(中期)2" :item = [["フビライが服属させた朝鮮の国家は?","高麗"],["フビライが日本に服属を要求してきた時の執権は?","北条時宗"],["1274年のモンゴルの襲来を何という?","文永の役"],["文永の役の後、異国からの警護のため九州北部に置かれたのは?","異国警固番役"],["文永の役の後、博多湾沿いに築造されたのは?","石塁"],["蒙古襲来の後、北条氏が九州の博多に設置し、西国の支配力を増強させたのは?","鎮西探題"],["1281年のモンゴルの襲来を何という?","弘安の役"],["北条氏総本家当主のことを何という?","得宗"],["1285年に起きた御内人と御家人との争いは?","霜月騒動"],["霜月騒動で負けた将軍側の御家人は?","安達泰盛"],["霜月騒動で勝った北条氏側の御内人は誰で役職は?","平頼綱・内管領"],];break;
    case "鎌倉時代(後期)1" :item = [["鎌倉時代に普及した草木を焼いて灰を肥料にしたものは?","草木灰"],["鎌倉時代に普及した草刈って田畑に敷いて肥料としたものは","刈敷"],["鎌倉時代から普及した同じ土地で一年に米と麦と違う作物を二回耕作することを何という?","二毛作"],["鎌倉時代に存在が大きくなった高利貸業者のことを何という?","借上"],["鎌倉時代に国内通貨として流通した、中国から輸入された貨幣は何という?","宋銭"],["元寇により御家人が貧窮したので、それを救おうとしたが経済が混乱し却って貧窮することになった政策は?","永仁の徳政令"],["永仁の徳政令を出した執権は?","北条貞時"],["天皇家が分裂して皇位継承権を争い、鎌倉幕府が介入し、2つの血統の天皇が交互に帝位につくことになったがそれを何という?","両統迭立"],["北条高時が執権の時に、内管領として専横政治していた人物は?","長崎高資"],["1324年に起こった鎌倉幕府打倒の反乱は?","正中の変"],["1331年に起こった鎌倉幕府打倒の反乱は?","元弘の変"],["元弘の変で隠岐に流されることになった人物は?","後醍醐天皇"],["鎌倉幕府打倒に河内から挙兵した人物は?","楠木正成"],["鎌倉幕府打倒に吉野から挙兵した人物は?","護良親王"],["鎌倉幕府打倒に播磨から挙兵した人物は?","赤松則村"],["鎌倉幕府統治の六波羅探題を攻め落とした人物は?","足利尊氏"],["鎌倉幕府打倒に肥後から挙兵した人物は?","菊池武時"],["1333年、鎌倉を攻め落とした人物は?","新田義貞"]];break;;break;
    case "鎌倉時代(文化)1" :item = [["「蒙古襲来絵巻」を自らの戦功を伝えるために書かせた人物は?","竹崎季長"],["鎌倉時代に平家物語を平曲で語った人物を何という?","琵琶法師"],["鎌倉時代の作者不詳の儒教的説話集は?","十訓抄"],["後鳥羽上皇の命により藤原定家らが撰者で編纂した勅撰和歌集は?","新古今和歌集"],["源実朝の歌集は?","金槐和歌集"],["東大寺大仏殿の修復に参加した宋から来た渡来人は?","陳和卿"],["鎌倉時代の唐様の代表建築物は?","円覚寺舎利殿"],["鴨長明の作の平安社会を描いた作品は?","方丈記"],["鎌倉時代に伝えられた高僧の肖像画のことを何という?","頂相"],["慈円の作で道理の理念に基づいた解釈で綴られたのは?","愚管抄"],["西行が読んだ歌集は?","山家集"],];break;
    case "鎌倉時代(文化)2" :item = [["吉田兼好作の随筆は?","徒然草"],["鎌倉幕府が編纂した歴史書は?","吾妻鏡"],["鎌倉時代に盛んになった朝廷の儀式や先例を研究する学問は?","有職故実"],["北条実時が建てた私設図書館を何という?","金沢文庫"],["度会家行によって作られた神が主で仏が従という独自の理論は?","神本仏迹説"],["東大寺が焼失した南都焼き討ちを行った人物は?","平重衡"],["鎌倉時代の和様の代表建築物は?","三十三間堂（蓮華王院本堂）"],["鎌倉時代の折衷様の代表建築物は?","観心寺金堂"],["東大寺南大門金剛力士像を合作したの人物は(2人)?","運慶・快慶"],["東大寺を寄付を募って再建させた僧は?","重源"],];break;
    case "鎌倉時代(文化)3" :item = [["鎌倉時代の大和絵の肖像画を何という?","似絵"],["鎌倉時代に誕生した新仏教6宗派は?","浄土宗・浄土真宗（一向宗）・時宗・日蓮宗・臨済宗・曹洞宗"],["時宗を開いたのは?","一遍"],["浄土宗を開いたのは?","法然"],["日蓮宗を開いたのは?","日蓮"],["浄土真宗を開いたのは?","親鸞"],["臨済宗を開いたのは?","栄西"],["栄西の著書は?","興禅護国論"],["曹洞宗を開いたのは?","道元"],["法然の著書は?","選択本願念仏集"],["親鸞の著書は?","教行信証"],];break;
    case "鎌倉時代(文化)4" :item = [["多くの難民を救済したり、社会事業を行った律宗の人物は?（2人）","叡尊・忍性"],["時宗の中心寺院は?","清浄光寺"],["南都仏教の復興に力を注いだ法相宗の人物は?","貞慶"],["一遍の門弟たちが編集した著書は?","一遍上人語録"],["浄土宗の中心寺院は?","知恩院"],["道元の著書は?","正法眼蔵"],["日蓮の著書は?","立正安国論"],["南都仏教の復興に力を注いだ華厳宗の人物は?","明恵"],["臨済宗の中心寺院は?","建仁寺"],["浄土真宗の中心寺院は?","本願寺"],["曹洞宗の中心寺院は?","永平寺"],["日蓮宗の中心寺院は?","久遠寺"],];break;
    case "南北朝時代1" :item = [["後醍醐天皇が始めた新しい政治は?","建武の新政"],["これをきっかけとして足利尊氏が挙兵した、北条時行が1335年に起こした反乱は?","中先代の乱"],["京都を脱出した後醍醐天皇が再び拠点を持った場所は?","吉野"],["建武の新政を批判したものは?","二条河原落書"],["足利尊氏が擁立した天皇は?","光明天皇"],["北朝側で足利尊氏が征夷大将軍に任命されたのは何年?","1338年"],["北畠親房の南北朝時代の歴史物語で、南朝の立場から書いたものは?","神皇正統記"],["荘園の争いで強制的に土地の収穫物を刈り取ることで、南北朝時代から動乱が続いたことにより守護が取り締まる権利を獲得したものは?","刈田狼藉"],];break;
    case "南北朝時代2" :item = [["1350年に北朝側で起こった内乱は?","観応の擾乱"],["観応の擾乱で対立した足利一族は?","足利直義"],["観応の擾乱で足利直義に対立した人物は?","高師直"],["南北朝時代から動乱が続いたことで守護が獲得した権限で、幕府の判決を強制執行する権利のことを何という?","使節遵行"],["南北朝時代から動乱が続いたことで守護が獲得した権限で、荘園の年貢の半分を徴収する権利を与えられた法は?","半済令"],["作者不詳の南北朝時代の歴史物語で、公家の立場で源平以後の歴史を書いたものは?","増鏡"],["室町時代の連歌集で二条良基が編纂したものは?","菟玖波集"],["作者不詳の南北朝時代の歴史物語で、室町幕府の正当性を主張したものは?","梅松論"],["南北朝時代の北朝と南朝の皇室の系統はそれぞれ何?","北朝・持明院統　南朝・大覚寺統"],];break;
    case "室町時代(初期)1" :item = [["1392年の南北朝合一の時の北朝の天皇と南朝の天皇は?","北朝・後小松天皇　南朝・後亀山天皇"],["1391年に起きた、六分の一殿と呼ばれた山名氏清の乱は?","明徳の乱"],["1399年に起きた、周防などの守護大名大内義弘が起こした反乱は?","応永の乱"],["室町幕府の組織、三管領に交代で任命された三氏は?","細川・斯波・畠山"],["室町幕府の組織、四職に交代で任命された四氏は?","赤松・一色・山名・京極"],["室町幕府の幕府直轄軍のことを何という?","奉公衆"],["室町幕府の収入のうちの一つの高利貸しを営む土倉・酒屋に対する税をそれぞれ何という?","土倉役・酒屋役"],["室町幕府の収入のうちの一つの田畑と家屋に対する税をそれぞれ何という?","段銭・棟別銭"],["1438年、鎌倉公方と関東管領が戦った戦乱は?","永享の乱"],["永享の乱で戦った鎌倉公方と関東管領はそれぞれ誰?","鎌倉公方・足利持氏　関東管領・上杉憲実"],["1441年、6代将軍義教が赤松満祐に暗殺された事件は?","嘉吉の変"],["応仁の乱で東軍側の足利家の人物は?","足利義視"],];break;
    case "室町時代(初期)2" :item = [["応仁の乱で西軍側の足利家の人物は?","足利義尚"],["応仁の乱で東軍側についた有力守護は?（3人）","細川勝元・畠山政長・斯波義敏"],["応仁の乱で西軍側についた有力守護は?（三人）","山名持豊・畠山義就・斯波義廉"],["寝殿造風と禅僧様の折衷で作られている足利義満が北山に建築したのは?","金閣"],["臨済宗が整備した寺格のうち、別格上位とされた寺は?","南禅寺"],["臨済宗が定めた五山の内、京都五山は?","天竜・万寿・相国・建仁・東福"],["臨済宗が定めた五山の内、鎌倉五山は?","建長・円覚・寿福・浄智・浄妙"],["水墨画の代表的画僧で東福寺の画僧は?","明兆"],["「瓢鮎図」が代表作の相国寺の画僧は?","如拙"],["「寒山拾得図」などが作の相国寺の画僧は?","周文"],["興福寺の大和四座のひとつ観世座から猿能楽を完成させた親子は?","観阿弥・世阿弥"],["世阿弥の著作の能楽書は?","風姿花伝（花伝書）"],];break;
    case "室町時代(中期)1" :item = [["足利義政が東山に建物は?","銀閣"],["近代の和風住宅の原型になる建築様式で「慈照寺東求堂同仁斎」などで利用されている建築様式は?","書院造"],["「龍安寺石庭」や「大徳寺大仙院庭園」など、水を使わずに風景を表現している様式は?","枯山水"],["「秋冬山水図」などを代表作とする水墨画家は?","雪舟"],["大和絵の画家で土佐派の基礎を固めたのは?","土佐光信"],["大和絵の狩野派を創始した父子は?","狩野正信・元信"],["侘茶を創始した人物は?","村田珠光"],["村田珠光の侘茶を継承した人物は?","武野紹鴎"],["六角堂の僧で生花の池坊流の租とされる人物は?","池坊専慶"],["正風連歌を確立した人物とその歌集は?","宗祗　「新撰菟玖波集」"],];break;
    case "室町時代(中期)2" :item = [["俳諧連歌を確立した人物とその歌集は?","山崎宗鑑　「犬筑波集」"],["唯一神道を完成させた人物は?","吉田兼倶"],["室町時代の惣村の山や野原の共同利用地のことを何という?","入会地"],["室町時代に農民でありながら侍身分を獲得した者を何という?","地侍"],["室町時代の祭礼を行う祭祀集団は?","宮座"],["室町時代の惣村で行われる会議は?","寄合"],["室町時代の寄合で定められた規約は?","惣掟"],["室町時代の惣村を守るための警察権の行使のことを何という?","地下検断"],["1428年、足利義教の時に起こった近畿地方一帯に広がった土一揆は?","正長の土一揆"],["1441年、足利義勝の時起こった一揆で、徳政令を出すことにつながった一揆は?","嘉吉の土一揆"],];break;
    case "室町時代(中期)3" :item = [["室町時代の明銭の中でもっとも多く使用されたのは?","永楽通宝"],["勝手に私的に作った粗悪な銭の事を何という?","私鋳銭"],["15世紀中頃に足利学校を再興した関東管領は?","上杉憲実"],["能の間に行われた風刺性の強い喜劇のことを何という?","狂言"],["室町時代の絵の余白に話し言葉で書かれた物語は?","御伽草子"],["薩摩で薩南学派を興した朱子学者は?","桂庵玄樹"],["1325年に元に派遣された貿易船は何を修復するためだった?","建長寺"],["1342年に元に貿易船が派遣されるようになったのは誰の提案から?","夢窓疎石"],["1342年に元に派遣された貿易船のことを何という?","天竜寺船"],["1342年に元に貿易船が派遣されるようになった目的は?","天竜寺の建立"],["14世紀の中頃に、朝鮮半島沿岸部を頻繁に襲った海賊のことを何という?","倭寇"],];break;
    case "室町時代(中期)4" :item = [["1368年に、中国で明を建国した人物は?","朱元璋"],["1401年に足利義満が明に使者を送ったときの正使と副使はそれぞれ誰?","正使・祖阿　副使・肥富"],["1401年に足利義満が明に使者を送ったときの返書の宛名は何だった?","日本国王源道義"],["1401年に足利義満が明に使者を送ったときに返書の他に受け取ったのは?","暦"],["足利義満が始めた日明貿易は利用した証票から何と呼ばれている?","勘合貿易"],["日明貿易が朝貢形式だったため貿易を中断した人物は?","足利義持"],["足利義持によって中断された日明貿易を再開した人物は?","足利義教"],["日明貿易の主導権を争って細川氏と大内氏が争った戦いは?","寧波の乱"],["1419年に起こった日朝貿易が一時的に中断することになった戦乱は?","応永の外寇"],["1510年に起こった現地の日本人が特権の縮小の不満から暴動を起こし、日朝貿易の縮小につながった事件は?","三浦の乱"],["三浦の乱の三浦とはどこを指す?","釜山浦・乃而浦・塩浦"],];break;
    case "戦国時代1" :item = [["松永久秀が自害させた将軍は?","足利義輝"],["足利義輝を自害させた武将は?","松永久秀"],["戦国大名が領国内を統治するために制定した法律は?","分国法"],["陸奥国の伊達氏が定めた分国法は?","塵芥集"],["甲斐国の武田氏が定めた分国法は?","甲州法度之次第"],["駿河国の今川氏が定めた分国法は?","今川仮名目録"],["越前国の朝倉氏が定めた分国法は?","朝倉孝景条々"],["戦国大名が領主や名主に田畑の面積や収穫高・作人などを報告させて行った検地のことを何という?","指出検地"],["1543年にポルトガル人が来たのは日本のどこ?","種子島"],["1543年に種子島に来たポルトガル人が伝えたものは?","鉄砲"],["1543年に種子島にポルトガル人が鉄砲を伝えたときの種子島の領主は?","種子島時尭"],];break;
    case "戦国時代2" :item = [["1584年にスペイン人がやって来たのは日本のどこ?","平戸"],["南蛮貿易での日本の主な輸出品は?","銀"],["南蛮貿易での日本の主な輸入品は?","生糸・火薬"],["キリスト教が伝来したのは西暦〇〇年","1549年"],["キリスト教を伝えた人物とその所属する組織は?","フランシスコ・ザビエル　イエズス会"],["戦国時代、コレジオやセミナリオを設立したイタリア人は?","ヴァリニャーニ"],["1582年ローマ教皇のもとに少年使節団を送ったキリシタン大名は?","大友義鎮・有馬晴信・大村純忠"],["大友義鎮・有馬晴信・大村純忠が、1582年ローマ教皇のもとに送った少年使節団のことを何という?","天正遣欧使節"],["戦国時代、和泉国の有名鉄砲生産地は?","堺"],["戦国時代、紀伊国の有名鉄砲生産地は?","根来"],["1560年織田信長が今川義元を倒した戦いは?","桶狭間の戦い"],];break;
    case "安土桃山時代1" :item = [["1570年、織田・徳川連合軍が浅井・朝倉氏に勝った戦いは?","姉川の戦い"],["1571年に織田信長が焼打ちした場所は?","比叡山延暦寺"],["1575年、織田信長が鉄砲を用いて武田氏を撃破した戦いは?","長篠の戦い"],["長篠の戦いで敗れた武将は?","武田勝頼"],["織田信長が1576年に近江に築城した城は?","安土城"],["明智光秀が裏切り織田信長が戦死した政変は?","本能寺の変"],["秀吉が明智光秀を討伐した戦いは?","山崎の戦い"],["秀吉が元織田家臣の柴田勝家を破った戦いは?","賤ヶ岳の戦い"],];break;
    case "安土桃山時代2" :item = [["秀吉が織田信雄・徳川家康軍と戦った戦いは?","小牧長久手の戦い"],["1585年、秀吉が朝廷から任命されたのは?","関白"],["全国支配の大きな力となった秀吉が出した大名間の私闘を禁じた法令は?","惣無事令"],["秀吉が1588年に京都に築造した邸宅は?","聚楽第"],["秀吉が跡地に大坂城を建築した浄土真宗の寺は?","石山本願寺"],["秀吉政権の直轄地のことを何という?","蔵入地"],["太閤検地で統一された枡を何という?","京枡"],["一揆を未然に阻止し、兵農分離をすすめるための秀吉の政策は?","刀狩り"],];break;
    case "安土桃山時代3" :item = [["秀吉がキリスト教宣教師の国外追放を命じたものは?","バテレン追放令"],["秀吉が朝鮮討伐の際、本陣を置いたのは?","肥前の名護屋城"],["秀吉が1592年に朝鮮に出兵したことを何という?","文禄の役"],["文禄の役の際、日本軍を困らせた朝鮮水軍を率いていた武将は?","李舜臣"],["秀吉が1597年に朝鮮に出兵したことを何という?","慶長の役"],["桃山文化期の画家、狩野永徳の代表作は?","唐獅子図屏風"],["千利休が確立した茶道は?","侘茶"],["「かぶき踊り」を行い女歌舞伎の源流となった人物は?","出雲阿国"],["室町後期に隆達節を創始した人物は?","高三隆達"],];break;
    case "江戸時代(初期)1" :item = [["関ヶ原の戦いの西軍と東軍の大将はそれぞれ誰?","西・石田三成　東・徳川家康"],["徳川家康が息子の秀忠に将軍職を譲った後についた役職は?","大御所"],["1615年に発布された幕府の基本方針を示し武家を厳しく統制する法令は?","武家諸法度（元和令）"],["1615年の武家諸法度を家康の命で起草した人物は?","金地院崇伝"],["1635年の武家諸法度（寛永令）で大名に課せられた義務は?","参勤交代"],["江戸幕府の大名区分で徳川氏一門の大名を何という?","親藩大名"],["江戸幕府の大名区分で関ヶ原の戦い以前から徳川氏に従う大名を何という?","譜代大名"],["江戸幕府の大名区分で関ヶ原の戦い以後から徳川氏に従う大名を何という?","外様大名"],["江戸幕府がつくったはじめて全国統一通貨は?","慶長金銀"],["江戸幕府の役職で、将軍に直属して国政を統轄する職は?","老中"],];break;
    case "江戸時代(初期)2" :item = [["江戸幕府の役職で、臨時に置かれた最高職は?","大老"],["江戸幕府の役職で、老中の補佐と旗本や御家人を観察した職は?","若年寄"],["江戸幕府の役職で、大名や朝廷を監視した職は?","大目付"],["江戸幕府の役職で、御家人を監視した職は?","目付"],["江戸幕府の役職で、江戸の司法・行政・警察権を管轄した職は?","町奉行"],["江戸幕府の役職で、租税徴収などを担当し、幕府財政を運営した職は?","勘定奉行"],["江戸幕府の役職で、寺社の行政を担当した職は?","寺社奉行"],["江戸幕府の役職で、朝廷・公家・西日本大名の監視をした職は?","京都所司代"],["江戸幕府が1615年に制定した、朝廷統制の基準を示したものは?","禁中並公家諸法度"],["後水尾天皇が幕府の許可無く最高の栄誉を与えたことによっておきた事件は?","紫衣事件"],];break;
    case "江戸時代(初期)3" :item = [["紫衣事件によって追放された僧侶は?","沢庵"],["江戸幕府がキリスト教の信仰を禁止した法令は?","禁教令"],["江戸時代の村の運営を中心になって行なった村方三役とは具体的には?","名主・組頭・百姓代"],["江戸時代に田畑に約40パーセントかせられた租税は?","本途物成"],["江戸時代の年貢率の定め方で、その年の収穫応じて決定することを何という?","検見法"],["江戸時代の年貢率の定め方で、毎年決まった率にすることを何という?","定免法"],["江戸時代の副業や山野の利用にかかる税は?","小物成"],["江戸時代の河川工事などを課せられた労役は?","国役"],["1643年に本百姓の没落を防ぎ、豊かな農民に田畑が集中しないようにする為に作られた法令は?","田畑永代売買禁止令"],["1673年に出された百姓の経営維持や年貢の徴収安定化のために分割相続を禁じた法令は?","分地制限令"],];break;
    case "江戸時代(初期)4" :item = [["江戸幕府が定めた商品作物を勝手につくるのを禁じた法令は?","田畑勝手作りの禁"],["江戸時代の町人の年貢にあたる労役は?","町人足役"],["徳川家康が外交貿易の顧問にした1600年豊後に漂着したオランダ船リーフデ号の航海士と水先案内人のイギリス人は?","航海士・ヤン・ヨーステン　水先案内人・ウイリアム・アダムス"],["リーフデ号の漂着後、貿易のための商館が作られた場所は?","平戸"],["幕府が1610年に通商を試みてノビスタン（メキシコ）に派遣した人物は?","田中勝介"],["伊達政宗がヨーロッパとの通商を求めて派遣した人物は?","支倉常長"],["伊達政宗が支倉常長を派遣した使節を何という?","慶長遣欧使節"],["オランダ商人の利益独占の阻止と幕府への収入を狙って定められた特定商人に独占的輸入権と国内商人への独占的卸売権を与えた制度は?","糸割符制度"],["江戸幕府初期の海外との貿易を与えた許可状から何という?","朱印船貿易"],["1616年に中国船以外の外国船の貿易が許可された場所は(２つ)?","平戸・長崎"],];break;
    case "江戸時代(初期)5" :item = [["1633年から貿易するのに義務で必要になった許可証を持った船は?","奉書船"],["1637年にキリスト教徒が中心となって起こった一揆は?","島原の乱"],["1639年に来航禁止となった船は?","ポルトガル船"],["鎖国状態時に貿易が許されていたのは?(２つの国)","中国船・オランダ船"],["1641年に平戸から長崎の出島に移されたのは?","オランダ商館"],["江戸幕府が海外の情報を得るためにオランダ商館長に提出させていたものは?","オランダ風説書"],["1688年に中国人の住居は何処に制限された?","唐人屋敷?"],["江戸時代、琉球国王が変わるたび幕府に送られた使者は?","謝恩使"],["江戸時代、琉球から将軍の代が変わるたびに幕府に送られた使者は?","慶賀使"],["アイヌが1669年蜂起しておきた戦いは?","シャクシャインの戦い"],];break;
    case "江戸時代(初期)6" :item = [["蝦夷で18世紀初頭に成立した流通制度は?","場所請負制度"],["寛永文化はどれくらいの時期の文化?","江戸初期文化"],["日光東照宮にも使われている霊廟建築様式の一つを何という?","権現造"],["桂離宮に使われた茶室風の建築様式は?","数寄屋造"],["寛永期の画家で「大徳寺方丈襖絵」が代表作の人物は?","狩野探幽"],["寛永期の蒔絵の代表的人物で「舟橋蒔絵硯箱」が代表作の人物は?","本阿弥光悦"],["寛永期の有田焼の陶工で赤絵の技術を完成させた人物は?","酒井田柿右衛門"],["狩野派の画家で、代表作が「夕顔棚納涼図屏風」なのは?","久隅守景"],["朱子学者で徳川家康に仕え、将軍4代の侍講となった人物は?","林羅山"],["林羅山とその子が編纂した日本通史は?","本朝通鑑"],];break;
    case "江戸時代(中期)1" :item = [["江戸幕府4代目将軍は?","徳川家綱"],["徳川家綱の補佐をした人物は?","保科正之"],["1651年におきた兵学者がおこした反乱は?","慶安の変（由井正雪の乱)"],["慶安の変や承応の変がおきた原動力となった失業した武士のことを何という?","牢人"],["1657年におきた振袖火事ともいう大火事のことを何という?","明暦の大火"],["徳川5代将軍は?","徳川綱吉"],["徳川綱吉を補佐した大老であった人物は?","堀田正俊"],["堀田正俊が暗殺された後に徳川綱吉を補佐した側用人は?","柳沢吉保"],["徳川綱吉が定めた特に犬を大事にして殺生を禁じた法令は?","生類憐れみの令"],["綱吉の頃、林羅山の孔子廟を移し、設置した学問所を何という?","湯島聖堂"],];break;
    case "江戸時代(中期)2" :item = [["綱吉の頃、大学頭になった人物は?","林鳳岡"],["徳川6代将軍は?","徳川家宣"],["徳川家宣に用いられ7代将軍家継の時も政治を行った朱子学者は?","新井白石"],["徳川家宣に用いられた側用人は?","間部詮房"],["徳川家宣が始めた政治のは?","正徳の治"],["新井白石が創設した新しい親王家は?","閑院宮家"],["新井白石の政策で物価を抑えるために鋳造されたものは?","正徳金銀"],["新井白石の政策で、長崎の貿易を統制したものは?","海舶互市新例"],["元禄文化の中心の時は徳川将軍は誰の時?","徳川綱吉"],["元禄文化期に蕉風俳諧を確立した俳人は?","松尾芭蕉"],];break;
    case "江戸時代(中期)3" :item = [["元禄文化期に浮世草子とよばれる小説を書いたのは?","井原西鶴"],["井原西鶴の書いた好色物で代表作は?","好色一代男"],["井原西鶴の書いた町人物で代表作は?","世間胸算用"],["元禄文化期の人形浄瑠璃の作者として有名な人物は?","近松門左衛門"],["近松門左衛門の代表作は?（2つ）","「曽根崎心中」「国性爺合戦」"],["元禄文化期の歌舞伎で江戸にて荒事で評判を得た人物は?","市川団十郎"],["元禄文化期の歌舞伎で大阪にて和事で評判を得た人物は?","坂田藤十郎"],["元禄期文化に蒔絵で有名で代表作に「八橋蒔絵螺鈿硯箱」などがある人物は?","尾形光琳"],["元禄文化期に垂加神道を創始した人物は?","山崎闇斎"],["元禄文化期の人物で、本草学で有名、「大和本草」の著者は?","貝原益軒"],];break;
    case "江戸時代(中期)4" :item = [["元禄文化期に、「農業全書」を著した人物は?","宮崎安貞"],["元禄文化期に和算で優れた研究結果を残した人物は?","関孝和"],["元禄文化期に貞享暦を作成した人物は?","渋川春海"],["元禄文化期に、「万葉代匠記」を著した人物は?","契沖"],["元禄文化期に「源氏物語」や「枕草子」などの古典を研究した人物は?","北村季吟"],["徳川8代将軍吉宗が始めた政治改革は?","享保の改革"],["1719年に出された金銭訴訟を幕府が受け付けないことを決めた法令は?","相対済し令"],["享保の改革で甘藷を普及させるのに用いた人物は?","青木昆陽"],["享保の改革で庶民の意見を聞くため評定所に設置されたのは?","目安箱"],["目安箱によって設置された貧民を対象とする医療施設は?","小石川養生所"],["享保の改革での1万石につき100石をおさめさせるかわりに参勤交代の負担を軽減させる制度は?","上米の制"],];break;
    case "江戸時代(中期)5" :item = [["享保の改革での、役職に応じて在職時のみに俸禄が上がる制度は?","足高の制"],["享保の改革での年貢の徴収率を一定率にするやり方を何という?","定免法"],["享保の改革で、裁判の基準を明確にしたものは?","公事方御定書"],["江戸中期の、江戸の魚市場といえば?","日本橋"],["江戸中期の、大坂の米市場といえば?","堂島"],["江戸中期の、大坂の魚市場といえば?","雑喉場"],["江戸中期の、大坂の青物市場といえば?","天満"],["徳川10代将軍家治のころ側用人から老中となり政治の実権を握った人物は？","田沼意次"],["田沼意次の政策で株仲間を奨励し、そこから収めさせた税は?（2つ）","運上・冥加"],["田沼意次の政策で、専売制で統制を行った商品の代表は?（四つ）","銅・鉄・朝鮮人参・真鍮"],["田沼意次の政策で鋳造を始めた銀貨初の計数貨幣は?","南鐐二朱銀"],];break;
    case "江戸時代(後期)1" :item = [["徳川11代将軍家斉の補佐として老中になった人物は?","松平定信"],["松平定信の行った政治改革は?","寛政の改革"],["松平定信が行った政策で、義倉・社倉をつくらせ飢饉に備えた政策は?","囲米の制"],["松平定信が行った政策で、都会に出てきた農民を農村へ帰す政策は?","旧里帰農令"],["松平定信が行った政策で、治安維持対策で石川島につくった使節は?","人足寄場"],["松平定信が行った政策で、町費の節約分の7割を積み立て飢饉に備えたのは?","七分金積立"],["松平定信の政策で、直参の借金を帳消しさせた政策は?","棄捐令"],["松平定信の政策で、朱子学のみ正学として湯島聖堂で朱子学以外の学問を禁止した政策は?","寛政異学の禁"],["寛政の改革期に「海国兵談」を書き処罰された人物は?","林子平"],["松平定信が引退後、いわゆる大御所政治をおこなった人物は?","徳川家斉"],];break;
    case "江戸時代(後期)2" :item = [["1792年に根室にやってきたロシア大使は?","ラックスマン"],["1792年根室にやてきたラックスマンが送り届けた人物は?","大黒屋光太夫"],["大黒屋光太夫のロシアでの様子を記した代表する書物は?","北槎聞略"],["1804年に長崎にやって来たロシア使節は?","レザノフ"],["1808年にオランダ船を追ってイギリス軍艦がやって来た事件は?","フェートン号事件"],["1825年に幕府が出した、外国船の撃退を命じたのは?","無二念打払令（異国船打払令）"],["1837年に起きた大坂の陽明学者の起こした反乱は?","大塩平八郎の乱"],["1837年に起きた越後柏崎で国学者が起こした反乱は?","生田万の乱"],["1837年にアメリカ商船が貿易を求めてきたのに対し打ち払った事件をは?","モリソン号事件"],["モリソン号事件を批判した人物を処罰した出来事は?","蛮社の獄"],];break;
    case "江戸時代(後期)3" :item = [["蛮社の獄で処罰された人物で「慎機論」を書いていた人物は?","渡辺崋山"],["蛮社の獄で処罰された人物で「戊戌夢物語」を書いていたのは?","高野長英"],["12代将軍の徳川家慶のもとで老中として天保の改革を行った人物は？","水野忠邦"],["天保の改革で物価を下落させようと解散させたがかえって物価上昇したため後に再興させたのは?","株仲間"],["異国船打払令の方針をアヘン戦争で変化して出した法令は?","天保の薪水給与令"],["天保の改革で処罰された合巻作家は?","柳亭種彦"],["天保の改革で処罰された人情本作家は?","為永春水"],["天保の改革期に百姓の出稼ぎを禁じて、江戸に来た民を帰させる法は?","人返しの法"],["1843年に出された江戸大坂周辺の天領を編入する計画で失敗し水野忠邦が失脚する事になった政策は?","上知令"],["徳川11代将軍家斉の頃の時代を中心とする江戸中心の文化は?","化政文化"],];break;
    case "江戸時代(後期)4" :item = [["洒落本「仕懸文庫」で処罰された作者は?","山東京伝"],["黄表紙「金々先生栄花夢」などの作者は?","恋川春町"],["滑稽本「東海道中膝栗毛」の作者は?","十返舎一九"],["滑稽本「浮世風呂」「当世浮世床」の作者は?","式亭三馬"],["人情本「春色梅児誉美」の作者は?","為永春水"],["読本「雨月物語」「春雨物語」の作者は?","上田秋成"],["読本「南総里見八犬伝」「椿説弓張月」の作者は?","滝沢馬琴"],["ロマンチックな描写をした天明期の京都の俳人は?","与謝蕪村"],["人間味豊かな描写をした化成期の長野の俳人で「おらが春」などの代表作があるのは?","小林一茶"],["天明期の狂歌の作者で御家人であった人物は?","大田南畝"],["化政文化期の浮世絵作家で「弾琴美人」などの作がある浮世絵版画を完成させたのは?","鈴木春信"],];break;
    case "江戸時代(後期)5" :item = [["化政文化期の浮世絵作家で「婦女人相十品」などの作がある人物は?","喜多川歌麿"],["化政文化期の浮世絵作家で「市川鰕蔵」などの作がある人物は?","東洲斎写楽"],["化政文化期の浮世絵作家で「富嶽三十六景」などの作がある人物は?","葛飾北斎"],["化政文化期の浮世絵作家で「東海道五十三次」などの作がある人物は?","歌川広重"],["化政文化期の文人画の作者で与謝蕪村との共作「十便十宜図」があるのは?","池大雅"],["化政文化期の文人画の作者で「鷹見泉石像」などの作があるのは?","渡辺崋山"],["化政文化期の写生画の作者で「雪松図」などの作があるのは?","円山応挙"],["化政文化期の写生画の作者で四条派を創始したのは?","松村呉春"],["化政文化期の西洋画の作者で「不忍池図」などの作があるのは?","司馬江漢"],["1846年に浦賀にやってきたアメリカ東インド艦隊司令長官は?","ビッドル"],];break;
    case "江戸時代(後期)6" :item = [["1853年に浦賀にやってきたアメリカ東インド艦隊司令長官は?","ペリー"],["1853年にやって来たペリーが持っていた親書は誰のものだった?","アメリカ大統領フィルモア"],["1853年にペリーがやって来たときの老中首座は?","阿部正弘"],["1854年にペリーが再度来航したときに結ばれた条約は?","日米和親条約"],["日米和親条約で開港された場所は?","箱館・下田"],["1853年長崎に来航、翌年にも下田に来航したロシア使節は?","プチャーチン"],["1854年にロシアとの間に結ばれた条約は?","日露和親条約"],["1857年にアメリカ総領事ハリスが通商を求めてきたときの老中首座は?","堀田正睦"],["1858年に老中首座・堀田正睦アメリカとの条約の勅許を求めたが拒否した天皇は?","孝明天皇"],["1858年に日米修好通商条約を結んだ時大老だった人物は?","井伊直弼"],];break;
    case "江戸時代(後期)7" :item = [["日米修好通商条約で開港された場所は?","箱館・長崎・新潟・兵庫・神奈川"],["日米修好通商条約での日本に不利とされている条件にはどんなものがあった?","関税自主権欠如・領事裁判権の承認"],["徳川13代将軍家定の後継で争った派閥は?(２つ)","南紀派・一橋派"],["南紀派の推していた将軍候補は?","徳川慶福"],["一橋派が推していた将軍候補は?","一橋慶喜"],["後継争いに勝った徳川慶福が改名して家茂になり14代将軍となるが、反対を押し切ってこれを決めた大老は?","井伊直弼"],["井伊直弼が一橋派を弾圧した事件は?","安政の大獄"],["1860年に尊王攘夷派の水戸藩脱藩浪士に井伊直弼が暗殺された事件は?","桜田門外の変"],["開国後に江戸で品不足が起こったために1860年に出されたが、成果はあまり上がらなかった法令は?","五品江戸廻送令"],["開国によって日本から金が大量流出したが、外国の金銀交換比率は1：いくつだった?","1：15"],];break;
    case "江戸時代(後期)8" :item = [["開国によって日本から金が大量流出したが、日本の金銀交換比率は1：いくつだった?","1：5"],["開国よって大量の金貨流出に対応して新しく作った小判は?","万延小判"],["井伊直弼の後に老中で政治を主導した人物で、公武合体運動を進めた人物は?","安藤信正"],["安藤信正の仕組んだ政略結婚で、徳川14代将軍と結婚した孝明天皇の妹は?","和宮"],["1862年に安藤信正が水戸藩脱藩浪士に斬りつけられた事件は?","坂下門外の変"],["安藤信正が失脚した後に文久の改革を進めた人物は?","島津久光"],["文久の改革で将軍の後見職についた人物は?","一橋慶喜"],["文久の改革で政事総裁職についた人物は?","松平慶永"],["文久の改革で京都守護職についた人物は?","松平容保"],["1862年、島津久光の一行に非礼があったとして、イギリス人が殺傷された事件は?","生麦事件"],];break;
    case "江戸時代(後期)9" :item = [["生麦事件をきっかけとして1863年に起こった戦いで薩摩の攘夷をあきらめるきっかけとなった戦いは?","薩英戦争"],["1863年の八月十八日の政変で京都から追放された尊皇攘夷派の公家は?","三条実美"],["1864年に尊皇攘夷派を新選組がおそった事件は?","池田屋事件"],["1864年に長州藩の兵が京都に上京するが、薩摩・会津・桑名藩に撃退された事件は?","禁門の変"],["1864年に起こった長州藩が攘夷をあきらめるきっかけとなった事件は?","四国艦隊下関砲撃事件"],["1866年に結ばれた関税率を20パーセントから5パーセントにする日本に不利な協定は?","改税約書"],["江戸幕府末期、幕府側に助言したのはどこの国の何という公使?","フランス・ロッシュ"],["江戸幕府末期、薩摩・長州側に助言したのはどこの国の何という公使?","イギリス・パークス"],["奇兵隊を率いて挙兵して長州藩を倒幕論に傾けさせた人物は?","高杉晋作"],["薩長同盟を結ばせるのに尽力した土佐藩出身の人物は?（2人）","坂本龍馬・中岡慎太郎"],];break;
    case "江戸時代(後期)10" :item = [["薩長同盟を結ぶ際の長州側の人物は?","桂小五郎（木戸孝允）"],["薩長同盟を結ぶ際の薩摩側の人物は?","西郷隆盛"],["大政奉還を徳川慶喜に直接提案した人物は?","山内豊信"],["山内豊信に大政奉還の案を託した人物は?","後藤象二郎・坂本龍馬"],["討幕の密勅を薩長両藩に渡した公家は?","岩倉具視"],["1867年に発せられて幕府が廃止され天皇のもとに三職が置かれることになったものは?","王政復古の大号令"],["王政復古の大号令で置かれた三職とは?","総裁・議定・参与"],["徳川慶喜に対し内大臣の辞退と天領の半分を返上させる決定をして、のちの戊辰戦争につながることになった会議は?","小御所会議"],["1867年東海や畿内でおこったん民衆が集団で熱狂的に踊ったを出来事は?","ええじゃないか"],];break;
    case "明治時代(前期)1" :item = [["新政府と幕府側が争った1年以上にわたる国内戦争は?","戊辰戦争"],["1868年1月、幕府軍が京都に進撃して新政府軍に敗北した戦いは?","鳥羽・伏見の戦い"],["新政府軍に対抗するため幕府軍側の東北の諸藩が結成したのは?","奥羽越列藩同盟"],["幕府軍と政府軍とのほぼ最後の戦いとなった箱館での幕府側の拠点は?","五稜郭"],["五稜郭で抵抗していた幕府側の人物は?","榎本武揚"],["1868年に出された政治の基本方針を示したものは?","五箇条の御誓文"],["五箇条の御誓文を最初に起草した人物は?","由利公正"],["由利公正の五箇条の御誓文の案を修正した人物は?","福岡孝弟"],["修正した福岡孝弟の五箇条の御誓文の案をさらに修正した人物は?","木戸孝允"],["1868年に出された民衆統治の方針を公示したものは?","五榜の掲示"],];break;
    case "明治時代(前期)2" :item = [["1868年に出された組織を規定した物は?","政体書"],["1868年に明治に改元されたが、天皇の一世と元号を一致させる制度のことを何という?","一世一元の制"],["政体書を起草した人物は?","福岡孝弟・副島種臣"],["政体書の形態はどこの国を参考にした?","アメリカ"],["政体書の組織規定で権力集中する役職は?","太政官"],["1868年に出された神仏分離令をきっかけに全国で起こった運動は?","廃仏毀釈運動"],["1869年に行われた版籍奉還を建議した人物は?（2人）","木戸孝允・大久保利通"],["版籍奉還の結果、旧藩主が任じられた役職は?","知藩事"],["1871年に行われた廃藩置県で知藩事が罷免され代わりに派遣されたのは?","府知事・県令"],["版籍奉還の際に太政官の上位に置かれた役職は?","神祗官"],];break;
    case "明治時代(前期)3" :item = [["廃藩置県の際に整備された三院のうち、最高機関は?","正院"],["廃藩置県の際に整備された三院のうち、立法の諮問機関は?","左院"],["廃藩置県の際に整備された三院のうち、行政の諮問機関は?","右院"],["徴兵の制度を構想した人物は?","大村益次郎"],["大村益次郎の構想していた徴兵の制度を徴兵令で実行に移した人物は?","山県有朋"],["江戸時代の身分「藩主・公家」「藩士」「町民・農民」は明治ではどのような身分にそれぞれなった?","「華族」「士族」「平民」"],["1871年に成立した、えた・非人も平民と同様とされることを定めたものは?","身分解放令"],["1872年に作られた制度として四民平等の戸籍を何という?","壬申戸籍"],["華族や士族に対して与えていた家禄や賞典禄の支給を止め金禄公債証書を与えた改革は?","秩禄処分"],["1872年に田畑永代売買の禁令が解け、所有者に発行されたものは?","地券"],];break;
    case "明治時代(前期)4" :item = [["1873年に公布された地租改正条例で課税基準は何から何になった?","石高から地価"],["1873年に公布された地租改正条例で金納する税率は地価の何パーセントだった?","3パーセント?"],["1873年の地租改正の後も農民の負担が変わらないために各地で起こった一揆は?","竹槍一揆"],["竹槍一揆の結果、地租の税率は何パーセントになった?","2.5パーセント"],["1872年に最初に引かれた鉄道は何処と何処を結ぶ線路?","新橋～横浜"],["1871年に発足した郵便制度を建議した人物は?","前島密"],["1870年に設立された三菱の前身は?","九十九商会"],["1870年に三菱の前身を設立した人物は?","岩崎弥太郎"],["1872年に群馬に設立された生糸の官営模範工場は?","富岡製糸場"],["1876年に北海道にクラークを招いて開校されたものは?","札幌農学校"],];break;
    case "明治時代(前期)5" :item = [["1868年に由利公正の建議で発行された最初の政府紙幣は?","太政官札"],["1869年に新たに発行されるようになった紙幣は?","民部省札"],["伊藤博文が建議し1871年に成立した金本位制を建前として制定された条例は?","新貨条例"],["アメリカのナショナルバンクを参考に1872年に制定された条例は?","国立銀行条例"],["1872年に制定された国立銀行条例を建議・起草したのはそれぞれ誰?","建議・伊藤博文　起草・渋沢栄一"],["明治初期に広まった、万人が生まれながらにして人間の権利が備わっているという思想は?","天賦人権思想"],["福沢諭吉の代表的著作は?（3つ）","「学問のすゝめ」「文明論之概略」「西洋事情」"],["中村正直がスマイルズの「自助論」を翻訳したものは?","西国立志編"],["中村正直がミルの「自由論」を翻訳したものは?","自由之理"],["1872年に公布された学制はどこの国の制度を参考にした?","フランス"],];break;
    case "明治時代(前期)6" :item = [["福沢諭吉が創設した私学は?","慶應義塾"],["大隈重信が創設した私学は?","東京専門学校"],["新島襄が創設した私学は?","同志社"],["津田梅子が創設した私学は?","女子英学塾"],["「明六雑誌」を発行した明六社を発起した人物は?","森有礼"],["1871年に派遣され条約改正の交渉したものの失敗した使節団は?","岩倉遣外使節団"],["1871年に清と結んだ開国後はじめて結んだ対等な条約は?","日清修好条規"],["1875年にロシアと結ばれた条約で国境を確定した条約は?","樺太・千島交換条約"],["1875年に日本と朝鮮の間で起こった武力衝突事件は?","江華島事件"],["1876年に江華島事件を契機に日本と朝鮮との間で結ばれた条約は?","日朝修好条規"],["1874年におきた佐賀の乱で反乱側のリーダーの役割をした人物は?","江藤新平"],];break;
    case "明治時代(前期)7" :item = [["1877年におきた西南戦争の反乱側の首謀者は?","西郷隆盛"],["1876年に熊本でおきた反乱は?","神風連の乱（敬神党の乱）"],["1876年に福岡でおきた反乱は?","秋月の乱"],["1876年に山口でおきた反乱は?","萩の乱"],["明治政府の徴兵令に反対した一揆は?","血税一揆"],["板垣退助や後藤象二郎が結成した日本最初の政党は?","愛国公党"],["1874年に左院に提出された自由民権運動の端緒となった文書は?","民撰議院設立建白書"],["板垣退助が立志社設立の翌年に設立した全国組織は?","愛国社"],["1875年に政府の大久保利通と、木戸孝允・板垣退助が会談し、木戸と板垣が政府に復帰することになった会議は?","大阪会議"],];break;
    case "明治時代(前期)8" :item = [["1875年の大阪会議の結果、立憲政治を約束するために発布されたのは?","立憲政体樹立の詔"],["1875年に設置された立法機関は?","元老院"],["1875年に設置された司法機関は?","大審院"],["1881年大隈重信が罷免されるきっかけとなった事件は?","開拓使官有物払下げ事件"],["1881年に板垣退助を党首に国会期成同盟を改称して作られた政党は?","自由党"],["1881年に結成された自由党の機関紙は?","自由新聞"],["1882年に結成された大隈重信が結成した政党は?","立憲改進党"],["立憲改進党の機関紙は?","郵便報知新聞"],["1882年に福地源一郎が結成した政党は?","立憲帝政党"],["立憲帝政党の機関紙は?","東京日日新聞"],];break;
    case "明治時代(前期)9" :item = [["1881年に松方正義が大蔵卿になるまでにインフレが起こっていた主な原因は?","不換紙幣の乱発"],["松方正義の政策で1882年に設立した中央銀行は?","日本銀行"],["1885年に兌換紙幣を発行して確立したのは?","銀本位制"],["1882年に起きた福島事件。県令が労役を課そうとして起きたがこの時の県令は?","三島通庸"],["1884年に埼玉の農民が高利貸しや役所などを襲撃し政府が軍隊で鎮圧した事件は?","秩父事件"],["1885年におきた大阪事件の首謀者は?","大井憲太郎"],["後藤象二郎や星亨が中心となって呼びかけた運動は?","大同団結運動"],["片岡健吉が中心となった運動で言論の自由・地租軽減・外交失敗の挽回を要求した運動は?","三大事件建白運動"],["1887年に公布され、自由主義運動者を東京から追放した条例は?","保安条例"],];break;
    case "明治時代(後期)1" :item = [["憲法などの準備として設置された制度取調局で長官だった人物は?","伊藤博文"],["伊藤博文が憲法の講義をうけたベルリン大学の人物は?","グナイスト"],["伊藤博文が憲法の講義をうけたウィーン大学の人物は?","シュタイン"],["貴族院準備の為、爵位を設けて旧公家や大名などに特権的身分を与えた法令は?","華族令"],["私擬憲法のうち立志社が起草したものは?","日本憲法見込案"],["私擬憲法のうち植木枝盛が起草したものは?","東洋大日本国国憲按"],["私擬憲法のうち交詢社が起草したものは?","私擬憲法案"],["私擬憲法のうち福地源一郎が起草したものは?","国憲意見"],["私擬憲法のうち千葉卓三郎が起草したものは?","日本帝国憲法"],["私擬憲法のうち共存同衆社が起草したものは?","私擬憲法意見"],];break;
    case "明治時代(後期)2" :item = [["大日本帝国憲法の憲法草案を起草した主な人物は?","伊藤博文・井上毅・伊東巳代治・金子堅太郎"],["大日本帝国憲法の憲法草案に助言した人物は?","ロエスレル・モッセ"],["1888年に設置され、憲法について審議された天皇諮問機関は?","枢密院"],["帝国議会に設置された二つの院はそれぞれ何?","貴族院・衆議院"],["1880年に制定された刑法を起草したフランス人学者は?","ボアソナード"],["1889年衆議院選挙法による第一回総選挙の有権者になる資格は?","25才以上の男性で直接国税15円納入"],["1889年衆議院選挙法による第一回総選挙で過半数を占めた反政府の党を総称して何という?","民党"],["第一回総選挙の民党を代表する政党は?（2つ）","立憲自由党・立憲改進党"],["1889年衆議院選挙法による第一回総選挙で藩閥政府を支持する政党を総称して何という?","吏党"],["第一回総選挙の吏党を代表する政党は?（2つ）","大成会・国民自由党"],];break;
    case "明治時代(後期)3" :item = [["第一回帝国議会時に総理大臣であり、超然主義の立場で、軍事予算を提出し成立させた人物は?","山県有朋"],["第二回総選挙の際に総理大臣だったのは?","松方正義"],["第二回総選挙の際に選挙に干渉した内務大臣は?","品川弥二郎"],["1871年に治外法権を回復しようとしたが相手にされなかった人物は?","岩倉具視"],["日米関税改定約書を結ぶなど税権回復に力を入れたが、英・独に反対され失敗した外務卿は?","寺島宗則"],["治外法権の回復に力を入れたが、鹿鳴館の建設などの欧化政策や外国人判事の登用が批判され外務大臣を辞任した人物は?","井上馨"],["治外法権の回復に力を入れ外国人判事を大審院に限るなどの条件各国と秘密交渉したが、玄洋社員に襲撃され辞任した人物は?","大隈重信"],["1891年に領事裁判権の撤廃についてイギリスから同意を得るも、大津事件で辞任した外務大臣は?","青木周蔵"],["イギリスとの間に条約を結び治外法権と税権の一部の回復に成功した外務大臣は?","陸奥宗光"],["陸奥宗光外相の時にイギリスと結んだ治外法権と税件の一部の回復をする内容の条約は?","日英通商航海条約"],];break;
    case "明治時代(後期)4" :item = [["1911年に関税自主権の完全回復をした時の外務大臣は?","小村寿太郎"],["1897年に制定された貨幣法によって採用された制度は?","金本位制"],["1883年に渋沢栄一らが設立した紡績会社は?","大阪紡績会社"],["富岡製糸場は何処に払い下げられた?","三井"],["1881年に設立された鉄道会社は?","日本鉄道会社"],["三井汽船会社と共同運輸が合併してできた会社は?","日本郵船会社"],["三池炭鉱はどこに払い下げられた?","三井"],["佐渡金山・生野銀山はどこに払い下げられた?","三菱"],["院内銀山はどこに払い下げられた?","古河"],["排気用蒸気ポンプの導入で日清戦争後国内最大の産炭地になった炭田は?","筑豊炭田"],];break;
    case "明治時代(後期)5" :item = [["1901年に操業を開始した官営の製鉄所は?","八幡製鉄所"],["長崎造船所の払い下げを受けて設立された造船所は?","三菱長崎造船所"],["紡績工場で働く女性労働者の生活を記録した「女工哀史」の著者は?","細井和喜蔵"],["1899年刊行の労働者の過酷な状況を記した「日本之下層社会」の著者は?","横山源之助"],["1903年刊行の農商務省が各産業の工場労働者の実情を調査した報告書は?","職工事情"],["1897年に高野房太郎・片山潜らが結成したのは?","労働組合期成会"],["足尾銅山鉱毒事件に関して天皇に直訴した人物は?","田中正造"],["1901年に安部磯雄・片山潜・幸徳秋水・木下尚江らが結成した日本初の社会主義政党は?","社会民主党"],["1910年に社会主義者が一斉検挙された事件は?","大逆事件"],];break;
    case "明治時代(文化)1" :item = [["平民欧化主義を唱え、民友社を設立し「国民之友」などを著した人物は?","徳富蘇峰"],["国粋主義を唱え、政教社を設立し「日本人」などを著した人物は?","三宅雪嶺"],["雑誌「太陽」で日本主義を唱えた人物は?","高山樗牛"],["岩倉使節団の一員の経験を持ち政教社の同人となり、神仏分離と信仰の自由を主張した僧は?","島地黙雷"],["札幌農学校に赴任した外国人教師は?","クラーク"],["熊本洋学校に赴任した外国人教師は?","シェーンズ"],["1890年に発布された教育勅語で学校教育の基本とされた方針は?","忠君愛国"],["1886年に公布され、小学校・中学校・師範学校・帝国大学などからなる学校体系を整備したものは?","学校令"],["歴史書「日本開化小史」を著した人物は?","田口卯吉"],];break;
    case "明治時代(文化)2" :item = [["ペスト菌発見や破傷風血清療法を発見などの功績をあげた人物は?","北里柴三郎"],["赤痢菌の発見の功績をあげた人物は?","志賀潔"],["オリザニン抽出に成功した人物は?","鈴木梅太郎"],["アドレナリンを発見した人物は?","高峰譲吉"],["北村透谷らが刊行したロマン主義文学の雑誌は?","文学界"],["文明開化の風俗を記した「安愚楽鍋」の著者は?","仮名垣魯文"],["政治小説「経国美談」の著者は?","矢野竜渓"],["「小説神髄」によって写実主義を主張した人物は?","坪内逍遥"],["写実主義の小説「浮雲」の著者は?","二葉亭四迷"],];break;
    case "明治時代(文化)3" :item = [["小説「五重塔」の著者で理想主義の作家と言われる人物は?","幸田露伴"],["「金色夜叉」などの作品がある小説家は?","尾崎紅葉"],["ロマン主義の小説「舞姫」の作者は?","森鴎外"],["ロマン主義の小説「たけくらべ」の作者は?","樋口一葉"],["ロマン主義の小説「高野聖」の作者は?","泉鏡花"],["ロマン主義の詩集「若菜集」や自然主義の小説「破戒」の作者は?","島崎藤村"],["ロマン主義の歌集「みだれ髪」の作者は?","与謝野晶子"],["自然主義の小説「蒲団」の作者は?","田山花袋"],["自然主義の短篇集「武蔵野」の作者は?","国木田独歩"],];break;
    case "明治時代(文化)4" :item = [["自然主義の小説「一握の砂」の著者は?","石川啄木"],["小説「吾輩は猫である」の作者は?","夏目漱石"],["俳句雑誌「ホトトギス」を主宰し、門下に高浜虚子がいるのは?","正岡子規"],["団菊左時代と呼ばれた明治時代に歌舞伎界を牽引したのは3人は?","9代目市川団十郎・5代目尾上菊五郎・初代市川左団次"],["東京音楽学校出身で「荒城の月」などの作曲者は?","滝廉太郎"],["東京美術学校の初代校長で、アメリカ人フェノロサと共に古美術復興運動をしたのは?","岡倉天心"],["日本初の西洋美術団体の明治美術会を結成。代表作に「収穫」などがある人物は?","浅井忠"],["白馬会を設立し、代表作に「湖畔」などがある人物は?","黒田清輝"],];break;
    case "日清・日露戦争1" :item = [["1876年日本と朝鮮との間に結ばれた条約は?","日朝修好条規"],["日朝修好条規の以後、朝鮮で日本に接近して政権を運営していた一族は?","閔氏"],["閔氏の対抗勢力であった大院君が扇動し1882年に朝鮮でおきた反乱は?","壬午事変"],["1884年に日本政府の援助を受けた金玉均らが朝鮮でクーデターを起こしたが清の援助で失敗した事件は?","甲申事変"],["1885年日本と清との間で朝鮮の取りあつかいについて決めた条約は?","天津条約"],["1885年の天津条約の日本と清国の全権大使はそれぞれ誰だった?","伊藤博文・李鴻章"],["1894年に朝鮮でおきた日清戦争のきっかけとなった戦乱は?","甲午農民戦争（東学党の乱）"],["日本が日清戦争勝利した結果結ばれた条約は?","下関条約"],["下関条約を結んだ時の日本側全権と外務大臣はそれぞれ誰?","全権・伊藤博文　外相・陸奥宗光"],["下関条約を結んだ時の清側全権は?","李鴻章"],];break;
    case "日清・日露戦争2" :item = [["下関条約で清が日本に割譲したのは?","台湾・遼東半島・澎湖諸島"],["下関条約で清が日本に支払うことになった賠償金はいくら?","2億両"],["遼東半島を返還するように圧力かけた三国干渉、三国は?","ロシア・フランス・ドイツ"],["1898年に自由党と進歩党が合わさってできた党は?","憲政党"],["憲政党による日本ではじめての政党内閣の総理大臣は?","大隈重信"],["第一次大隈重信内閣の文部大臣で共和演説事件を起こし辞任したのは?","尾崎行雄"],["第一次大隈重信を支えた憲政党が分裂して誕生した旧自由党系と旧進歩党系の政党はそれぞれ?","旧自由→憲政党　旧進歩→憲政本党"],["1900年第二次山県有朋内閣時に成立した政党の力が軍部に及ばないようにするために定めたのは?","軍部大臣現役武官制"],["1900年第二次山県有朋内閣時に成立した社会運動を弾圧する法律は?","治安維持法"],["1900年に伊藤博文を総裁として結成され、旧憲政党を母体とする政治団体は?","立憲政友会"],];break;
    case "日清・日露戦争3" :item = [["1900年に清で「扶清滅洋」を唱えて外国人を排斥しようとした宗教団体によって起こった反乱は?","義和団の乱"],["1900年に義和団の乱から戦争になった清と列強との間に結ばれた協定は?","北京議定書"],["1902年桂太郎内閣時に結ばれた条約は?","日英同盟"],["日露戦争で日本陸軍が勝利を収めた戦いは?","奉天会戦"],["日露戦争で日本海軍が勝利を収めた戦いは?","日本海海戦"],["日露戦争の講和条約は?","ポーツマス条約"],["1905年のポーツマス条約の日本側全権は?","小村寿太郎"],["1905年のポーツマス条約のロシア側全権は?","ヴィッテ"],["1905年のポーツマス条約で賠償金はいくら?","賠償金はなし"],["1905年のポーツマス条約で領有することになった樺太は北緯何度以南?","北緯50度"],];break;
    case "日清・日露戦争4" :item = [["1905年のポーツマス条約で清国から租借権を得たのは?","旅順・大連"],["1905年のポーツマス条約で賠償金が取れなかったことから起きた事件は?","日比谷焼打ち事件"],["1905年に第二次日韓協約で外交権を取り上げ、日本が置いた組織は?","統監府"],["漢城におかれた統監府の初代統監は?","伊藤博文"],["1907年に韓国皇帝・高宗が密使を送り、日本に抗議したが無視された事件は?","ハーグ密使事件"],["1909年に統監府の初代統監を暗殺した人物は?","安重根"],["1910年に韓国併合条約を結び、統治機関としておいたのは?","朝鮮総督府"],["朝鮮総督府の初代総督は誰?","寺内正毅"],["1906年に設置された満州を統治する組織は?","関東都督府"],["1910年の第二次桂太郎内閣時に幸徳秋水などが弾圧された事件は?","大逆事件"],["1911年の第二次桂太郎内閣時に成立した初の労働者保護法は?","工場法"],];break;
    case "第一次世界大戦1" :item = [["第二次西園寺公望内閣時に陸軍二個師団増設問題で辞職した陸相は?","上原勇作"],["第二次西園寺公望内閣が退陣することになった原因の制度は?","軍部大臣現役武官制"],["第二次西園寺公望内閣が退陣し、第三次桂太郎内閣の誕生をきっかけに起こった第一次護憲運動のスローガンは?","「閥族打破・憲政擁護」"],["第一次護憲運動を主導した野党勢力はどの党の誰だった?(2人)","「立憲政友会・尾崎行雄」「立憲国民党・犬養毅」"],["第一次護憲運動に対抗して桂太郎が結成したのは?","立憲同志会"],["大正政変で退陣した桂太郎の後成立した山本権兵衛内閣が退陣することになった事件は?","シーメンス事件"],["第一次世界大戦でドイツに日本が宣戦布告する名目は何?","日英同盟"],["対華二十一条の要求で要求した権益の代表するものは?","山東省（ドイツの権益）・南満州・内蒙古・「旅順・大連・南満州鉄道」の租借権の延長・漢冶萍公司の共同経営"],["1916年に締結され、特殊権益の相互擁護を確認したものは?","第四次日露協約"],["寺内正毅内閣での西原借款で巨額の借款をうけていた人物は?","段祺瑞"],];break;
    case "第一次世界大戦2" :item = [["1918年にロシア革命に干渉するためチェコスロバキア兵救出を名目に行ったことは?","シベリア出兵"],["シベリア出兵を原因として起こった一揆は?","米一揆"],["米一揆で退陣した寺内正毅内閣の後総理となり平民宰相と呼ばれた人物は?","原敬"],["1919年原敬内閣での選挙法改正で納税資格はどう変わった?","10円から3円"],["1919年のパリ講和会議で結ばれた条約は?","ヴェルサイユ条約"],["ヴェルサイユ条約を結ぶ際の日本全権は?","西園寺公望"],["パリ講和会議の際、「民族自決」などの平和原則を提唱したアメリカの大統領は?","ウィルソン"],["パリ講和会議のアメリカ大統領の提案で設立された世界初の国際平和機構は?","国際連盟"],["1919年のヴェルサイユ条約で日本が権益の継承を認められたが、五・四運動で返還をもとめる運動がおきた場所は","山東省"],];break;
    case "第一次世界大戦3" :item = [["朝鮮でヴェルサイユ条約を機にしておきた独立運動は?","三・一独立運動"],["1921年に開催されたワシントン会議の開催を呼びかけた人物は?","アメリカ大統領・ハーディング"],["1921年に調印され、太平洋問題の話し合いによる解決をきめ、日英同盟が破棄されることになった条約は?","四カ国条約"],["四ヵ国条約を結んだ四ヵ国は?","イギリス・アメリカ・フランス・日本"],["1922年に中国の領土と主権尊重した上で門戸開放を約束した条約は?","九ヵ国条約"],["九ヵ国条約に参加した九ヵ国は?","イギリス・アメリカ・フランス・日本・ベルギー・ポルトガル・中国・イタリア・オランダ"],["九ヵ国条約で破棄されて山東省が返還されることになった協定は?","石井・ランシング協定"],["1922年に結ばれた主力艦の保有を制限する条約は?","ワシントン海軍軍縮条約"],["ワシントン海軍軍縮条約での保有比率は、英：米：日：仏：伊でそれぞれいくつ?","5：5：3：1.67：1.67"],];break;
    case "大正時代1" :item = [["天皇機関説を唱え貴族院議員を辞任した人物は?","美濃部達吉"],["民本主義を唱え、1918年には黎明会を組織した人物は?","吉野作造"],["1912年に労働者の地位向上を目的に友愛会を組織した人物は?","鈴木文治"],["友愛会が大日本労働総同盟友愛会を経て1921年に改称し階級闘争した組織は?","日本労働総同盟"],["ロシア革命の影響を受け1922年に非合法に結成された組織は?","日本共産党"],["青鞜社をさきがけとする女性解放運動の代表的指導者は?","平塚らいてう"],["平塚らいてうと市川房枝らが結成して女性の参政権獲得の運動を行った組織は?","新婦人協会"],["第二次山本権兵衛内閣が退陣に追い込まれることになった事件は?","虎の門事件"],["第二次山本権兵衛内閣の後に成立し超然内閣の総理となったのは?","清浦奎吾"],];break;
    case "大正時代2" :item = [["清浦奎吾内閣と激しく対立した護憲三派はそれぞれ?","憲政会・立憲政友会・革新倶楽部"],["清浦奎吾内閣が解散し選挙を行った結果敗北し、新しく総理になった人物は?","加藤高明"],["加藤高明内閣時の1925年にロシアとの国交を樹立するこになった条約は?","日ソ基本条約"],["1925年に成立した普通選挙法の投票資格は?","25歳以上の男子"],["1925年に成立した国体の変革や私有財産否認を目指す結社の取締を定めた法は?","治安維持法"],["記者に石橋湛山らを擁し、大正デモクラシー期に普通選挙や自由主義の立場の新聞は?","東洋経済新報"],["1916年に「貧乏物語」を発表し、マルクス経済学を紹介した人物は?","河上肇"],["黄熱病の研究に尽力した人物は?","野口英世"],["KS磁石鋼の発明をした人物は?","本多光太郎"],];break;
    case "大正時代3" :item = [["哲学書「善の研究」を著した人物は?","西田幾多郎"],["民俗学を確立した人物は?","柳田国男"],["「神代史の研究」の著者は?","津田左右吉"],["白樺派の作家で「或る女」などの著作があるのは?","有島武郎"],["白樺派の作家で「暗夜行路」などの著作があるのは?","志賀直哉"],["白樺派の作家で「人間万歳」などの著作があるのは?","武者小路実篤"],["耽美派の作家で「腕くらべ」などの著作があるのは?","永井荷風"],["耽美派の作家で「痴人の愛」などの著作があるのは?","谷崎潤一郎"],["新思潮派の作家で「羅生門」「鼻」などの著作があるのは?","芥川龍之介"]];break;;break;
    case "大正時代4" :item = [["新感覚派の作家で「伊豆の踊り子」「雪国」などの著作があるのは?","川端康成"],["「蟹工船」の著者は?","小林多喜二"],["「太陽のない街」の著者は?","徳永直"],["児童雑誌「赤い鳥」を創刊したのは?","鈴木三重吉"],["「大菩薩峠」などの著作があるのは?","中里介山"],["「宮本武蔵」などの著作があるのは?","吉川英治"],["「金蓉」などの作品がある画家は?","安井曾太郎"],["「紫禁城」などの作品がある画家は?","梅原竜三郎"],["「麗子微笑」などの作品がある画家は?","岸田劉生"],["「生々流転」などの作品があり日本美術院を再興した人物は?","横山大観"],];break;
    case "昭和時代(初期)1" :item = [["1927年に起きた金融恐慌の引き金となった失言をした第一次若槻礼次郎内閣の蔵相は?","片岡直温"],["台湾で事業を拡大していたが、1927年の金融恐慌で経営破綻した企業は?","鈴木商店"],["鈴木商店への不良債権が問題となった銀行は?","台湾銀行"],["田中義一内閣で行った金融恐慌対策は?","支払猶予令"],["田中義一内閣での蔵相は?","高橋是清"],["1928年に起こった日本共産党員を大量に検挙し、日本労働組合評議会を解散させるなどした事件は?","三・一五事件"],["1929年に共産党員を大量に検挙した事件は?","四・一六事件"],["田中義一内閣が退陣するきっかけとなった事件は?","張作霖爆殺事件"],["浜口雄幸内閣の井上準之助蔵相が1930年に行った金本位制に復帰を意味する政策は?","金解禁"],["金解禁と世界恐慌が重なり日本で起こった恐慌は?","昭和恐慌"],];break;
    case "昭和時代(初期)2" :item = [["1930年に結ばれた、主力艦建造禁止を5年延長し補助艦の保有量を定めたものは?","ロンドン海軍軍縮条約"],["ロンドン海軍軍縮条約の日本の全権は?","若槻礼次郎"],["ロンドン海軍軍縮条約で日本の補助艦保有比率は英米の何割?","7割"],["1931年に関東軍が南満州鉄道の線路を爆破した事件は?","柳条湖事件"],["1931年に成立した犬養毅内閣の蔵相で、金本位制からの離脱をしたのは?","高橋是清"],["1932年に関東軍が満州国を建設した際に執政にした人物は?","溥儀"],["満州国に関し国際連盟が送った調査団は?","リットン調査団"],["1932年に犬養毅総理が海軍青年将校に暗殺された事件は?","五・一五事件"],["1932年に斉藤実内閣で取り交わした満洲国を承認する文書は?","日満議定書"],["1933年に国際連盟からの脱退をした時の外務大臣は?","松岡洋右"],];break;
    case "昭和時代(初期)3" :item = [["1936年の岡田啓介内閣時に、高橋是清・斉藤実・渡辺錠太郎が陸軍皇道派に殺害された事件は?","二・二六事件"],["1933年に京都帝国大学起こった自由主義的学問への弾圧事件は?","滝川事件"],["1936年に成立した広田弘毅内閣で復活した軍部の介入を許す制度は?","軍部大臣現役武官制"],["1936年にドイツと結ばれたソ連を仮想敵国とした協定は?","日独防共協定"],["日独防共協定にイタリアが加わり1937年に結ばれた協定は?","日独伊防共協定"],["1937年に起こった日中戦争のきっかけとなった事件は?","盧溝橋事件"],["日中戦争の最中に発表された第一次近衛声明で和平への道を閉ざす文言は?","国民政府は対手とせず"],["日中戦争の最中に発表された第二次近衛声明で日中戦争の目的とされたのは何の建設?","「東亜新秩序」の建設"],["1940年に南京に誕生した日本の傀儡の新国民政府の首班は?","汪兆銘"],];break;
    case "第二次世界大戦1" :item = [["1938年に成立した政府が議会の承認なしに物資や労働力を調達できるようにした法律は?","国家総動員法"],["1939年に成立した強制的徴発を可能にし、国民を軍需産業に動員する法律は?","国民徴用令"],["1939年に成立した公定価格制で経済を統制しようとした法律は?","価格統制令"],["1939年に成立した法律で後に米の供出制や配給通帳制で米を政府統制下に置いた法律は?","米穀配給統制法"],["1940年に結成された全国組織で労働組合を解散し政府が労働者を監視管理した組織は?","大日本産業報国会"],["「夜明け前」の作者は?","島崎藤村"],["「細雪」の作者は?","谷崎潤一郎"],["日中戦争の従軍体験記「麦と兵隊」の作者は?","火野葦平"],["1939年に突然、独ソ不可侵条約が結ばれ「欧州情勢ハ複雑怪奇ナリ」という声明を出し辞任した総理大臣は?","平沼騏一郎"],["1940年に援蒋ルート遮断のためにフランスの植民地に南進したことを何という?","北部仏印進駐"],["1941年にドイツ式の小学校8年にし名称も国民学校に改めた勅令は?","国民学校令"],["北守南進政策の実施のため、1941年にソ連と結んだ条約は?","日ソ中立条約"],];break;
    case "第二次世界大戦2" :item = [["アメリカが在米日本資産の凍結と対日石油輸出禁止をし、イギリス・中国・オランダとともに行った経済封鎖は?","ABCDライン"],["1941年にアメリカから出された最後通牒を何という?","ハル・ノート"],["1942年に東条英機内閣が行った選挙は?","翼賛選挙"],["1942年に日本が大敗北し制海制空権をなくした戦いは?","ミッドウェー海戦"],["1943年にアメリカ・ルーズベルト、イギリス・チャーチル、中国・蒋介石が会談し発表した日本の処理案などを発表した宣言は?","カイロ宣言"],["1943年に実施された大学生らを徴兵することを何という?","学徒出陣"],["女性を軍需工場に動員して結成された勤労奉仕団体は?","女子挺身隊"],["ソ連・スターリンが対日参戦すること密約した会談は?","ヤルタ会談"],["日本への無条件降伏勧告を要求した宣言は?","ポツダム宣言"],["1945年ミズーリ号上で降伏文書に調印した外務大臣は?","重光葵"],];break;
    case "終戦後1" :item = [["日本占領管理の連合国の最高機関として設置された機関は?","極東委員会"],["GHQの指示した五大改革指令の中身は?","婦人参政権の付与・労働組合の結成の推奨・教育制度の自由主義的改革・圧政の廃止・経済の自由化"],["GHQが命令した戦争犯罪人や職業軍人・国家主義者を公の職から排除するように命令したことを何という?","公職追放"],["GHQの方針で財閥が解体されたが、その株式を公売した組織は?","持株会社整理委員会"],["1947年に成立した持株会社の禁止やカルテル・トラストの禁止を定めた法律は?","独占禁止法"],["1947年に成立した巨大企業分割を目指す目的で定められた法律は?","過度経済力集中排除法"],["戦後の第一次農地改革は不徹底だったために定められ第二次農地改革がすすめられた法律は?","自作農創設特別措置法"],["戦後1945～47年に定められたいわゆる労働三法は?","労働組合法・労働関係調整法・労働基準法"],["1947年に定められた教育の機会均等、義務教育9年などを定めた法律は?","教育基本法"],["1947年に定められた六・三・三・四制の新学制を定めた法律は?","学校教育法"],];break;
    case "終戦後2" :item = [["ソ連・スターリンが対日参戦すること密約した会談は?","ヤルタ会談"],["日本への無条件降伏勧告を要求した宣言は?","ポツダム宣言"],["1945年ミズーリ号上で降伏文書に調印した外務大臣は?","重光葵"],["日本占領管理の連合国の最高機関として設置された機関は?","極東委員会"],["GHQが命令した戦争犯罪人や職業軍人・国家主義者を公の職から排除するように命令したことを何という?","公職追放"],["GHQの方針で財閥が解体されたが、その株式を公売した組織は?","持株会社整理委員会"],["1946年の戦後最初の総選挙で第一党になった党と総理になった人物はそれぞれ何?","日本自由党・吉田茂"],["1947年の日本国憲法のもとでの衆参議院選挙で第一党になった党と総理になった人物は?","日本社会党・片山哲"],["1947年の日本国憲法のもとでの衆参議院選挙で第一党になった日本社会党と連立した党は?","民主党・国民協同党"],];break;
    case "終戦後3" :item = [["第一次吉田茂内閣に有沢広巳の提案ではじめた鉄鋼・石炭に資金投下する政策を何という?","傾斜生産方式"],["第二次吉田茂内閣にGHQが支持した政策で総予算の均衡などインフレ収束策のことを何という?","経済安定九原則"],["経済安定九原則の実施策で経済顧問として銀行家が来日し立案勧告したものは?","ドッジ・ライン"],["アメリカからの財政使節が直接税中心の税制改革を勧告したことを何という?","シャウプ勧告"],["1950年朝鮮戦争を機に新設された、後の自衛隊へつながる部隊は?","警察予備隊"],["1951年に結ばれたサンフランシスコ平和条約の日本全権は?","吉田茂"],["サンフランシスコ平和条約は全部で何カ国と結んだか?","48ヵ国"],["1952年に血のメーデー事件をきっかけに制定された法律は?","破壊活動防止法"],["1954年にアメリカの水爆実験で被曝した船は?","第五福竜丸"],];break;

    case "漢文単語1" :item = [["故人","読み:こじん\n意味:旧友、親友"],["徒ニ","読み:いだづらニ\n意味:無駄に"],["義","読み:ぎ\n意味:人としての正しい道"],["故ニ","読み:ゆえニ\n意味:だから"],["士","読み:し\n意味:学徳のある者、師弟"],["小子","読み:せうし\n意味:おまえ、おまえたち"],["人間","読み:じんかん\n意味:世の中"],["之ク","読み:ゆク\n意味:行く"],["百姓","読み:ひやくせい\n意味:庶民、人々"],["夫子","読み:ふうし\n意味:賢者、先生などへの敬称"],];break;
    case "漢文単語2" :item = [["夜来","読み:やらい\n意味:昨夜"],["過グ","読み:すグ\n意味:通り過ぎる"],["或イハ","読み:あるイハ\n意味:あるもの(時)は、あるいは"],["為リ人","読み:ひとトなり\n意味:人柄"],["一旦","読み:いつたん\n意味:ある朝、ある日"],["雁信","読み:がんしん\n意味:手紙"],["奇","読み:きトス\n意味:珍しい、優れている"],["客舎","読み:がくしゃ\n意味:旅館、宿"],["故ヨリ","読み:もとヨリ\n意味:もともと"],["徐ニ","読み:おもむろニ\n意味:落ち着いて、ゆっくりと"],];break;
    case "漢文単語3" :item = [["傷ム","読み:いたム\n意味:悲しむ、傷つく"],["丈夫","読み:じょうふ\n意味:すぐれた立派な人間"],["則チ","読み:すなはチ\n意味:〜ならば、すぐに"],["直","読み:ただ\n意味:〜だけ"], ["難シ","読み:かたシ\n意味:難しい"],["方ニ","読み:まさニ\n意味:ちょうど"],["巳ダ","読み:はなはダ\n意味:とても"],["易フ","読み:かフ\n意味:とりかえる"],["何則","読み:なんトナレバすなわチ\n意味:なぜならば"],["寡人","読み:かじん\n意味:王が自分を指して言う"]];break;;break;
    case "漢文単語4" :item = [["何如","読み:いかん\n意味:どのようであるか"],["一日","読み:いちじつ\n意味:ある日"],["過ツ","読み:あやまツ\n意味:誤ちを犯す"],["蓋シ","読み:けだシ\n意味:思うに"],["客","読み:かく\n意味:旅人"],["偶","読み:たまたま\n意味:思いがけなく"],["見ハル","読み:あらハル\n意味:現れる"],["師","読み:し\n意味:先生"],["信","読み:しん\n意味:まこと"],["卒ニ","読み:つひニ\n意味:結局"],];break;
    case "漢文単語5" :item = [["如シ是","読み:かくノごとシ\n意味:このとおり"],["能ク","読み:よク\n意味:することができる"],["遊ブ","読み:あそブ\n意味:旅に出る"],["弑ス","読み:しいス\n意味:身分が上の者を殺す"],["寡シ","読み:すくなシ\n意味:少ない"],["宜ナリ","読み:むべナリ\n意味:もっともだ"],["見ル","読み:みル\n意味:会う"],["事フ","読み:つかフ\n意味:仕える"],["乃ち","読み:すなはチ\n意味:そこで"],["夫レ","読み:そレ\n意味:そもそも"],];break;
    case "漢文単語6" :item = [["与ス","読み:くみス\n意味:賛成する、仲間になる"],["与ル","読み:あずかル\n意味:関わる"],["倶ニ","読み:ともニ\n意味:共に"],["君子","読み:くんし\n意味:人徳のすぐれた立派な人"],["後生","読み:こうせい\n意味:自分よりあとに生まれた者"],["市井","読み:しせい\n意味:まち、世の中"],["私ニ","読み:ひそかニ\n意味:こっそり"],["字","読み:あざな\n意味:人の呼び名"],["所以","読み:ゆえん\n意味:理由、手段、方法"],["尽ク","読み:ことごとク\n意味:全部"],];break;
    case "漢文単語7" :item = [["相","読み:しょう\n意味:大臣"],["対フ","読み:こたフ\n意味:目上の人にお答えする"],["過ル","読み:よぎル\n意味:通り過ぎる"],["何者","読み:なんトナレバ\n意味:なぜならば"],["於テ是","読み:ここニおいテ\n意味:そこで、それで"],["俄ニ","読み:にはかニ\n意味:急に"],["干戈","読み:かんか\n意味:戦争"],["見ユ","読み:まみユ\n意味:お目にかかる"],["固ヨリ","読み:もとヨリ\n意味:もともと"],["左右","読み:さゆう\n意味:側近の臣"],];break;
    case "漢文単語8" :item = [["子","読み:し\n意味:あなた(男性に対して)"],["若","読み:なんじ\n意味:あなた"],["所謂","読み:いはゆる\n意味:世間でいうところの"],["名嘗テ","読み:かつテ\n意味:以前に"],["小人","読み:しょうじん\n意味:人徳や身分の低い人"],["頗ル","読み:すこぶル\n意味:非常に"],["素ヨリ","読み:もとヨリ\n意味:もともと"],["卒カニ","読み:にはカニ\n意味:急に"],["他日","読み:たじつ\n意味:他の日、以前"],];break;
    case "漢文単語9" :item = [["中ツ","読み:あツ\n意味:あたる"],["直チニ","読み:ただチニ\n意味:すぐに"],["不肖","読み:ふしょう\n意味:愚か、愚か者"],["凡ソ","読み:およソ\n意味:だいたい"],["吏","読み:り\n意味:役人"],["立ニ","読み:たちどころニ\n意味:すぐに"],["巳ム","読み:やム\n意味:終わる"],["輒チ","読み:すなはチ\n意味:そのたびごとに"],["竟ニ","読み:つひニ\n意味:結局"],];break;


    case "細胞の基礎1" :item = [["細胞を発見した人物は？","フック"],["「生物としての構造と機能の最小単位は細胞である」というのは何説?","細胞説"],["細胞説を唱えた人物は?(2人)","シュワン\nシュライデン"],["細胞膜とそれに囲まれた部分を何という?","原形質"],["人の体はおよそ何個の細胞で出来ている?","37兆個"],["原形質の内、核以外の部分を何という?","細胞質"],["細胞小器官の間を満たしている液状の部分を何という?","細胞質基質"],["細胞膜の仕事は?","細胞内部の状態を維持する\n細胞内に情報を伝える"],["細胞内に見られる構造体の総称を何という?","細胞小器官"],["植物や細菌の細胞の細胞膜の外側をおおう強い構造体は?","細胞壁"],];break;
    case "細胞の基礎2" :item = [["細胞壁は何で出来ている?","セルロース"],["細胞壁の仕事は?","細胞の保護\n生体の形の維持"],["核の中にある遺伝子をもつ本体となる物質は?","DNA"],["細胞内で呼吸を行う細胞小器官は?","ミトコンドリア"],["核膜に空いてある穴を何という?","核膜孔"],["タンパク質の翻訳後に修飾や仕分け、脂質の合成を行う細胞小器官は?","ゴルジ体"],["紡錘糸の形成を行う細胞小器官は?","中心体"],["光合成を行う細胞小器官は?","葉緑体"],["植物細胞や動物細胞などの細胞質が流れるように動く現象を何という?","原形質流動"],["浸透圧の調整を行う細胞小器官は?","液胞"],];break;
    case "細胞の基礎3" :item = [["核を持たない細胞を何という?","原核細胞"],["核を持つ細胞を何という?","真核細胞"],["原核細胞の例を答えよ(２つ)","乳酸菌\n好熱菌"],["植物細胞しか持たない細胞の構造は?(3つ)","細胞壁\n葉緑体\n液胞"],["葉緑体に含まれる色素は?","クロロフィル"],["原核生物の染色体はどこにある?","細胞質中"],["1個の細胞だけからできている生物の総称は?","単細胞生物"],["リボソームの仕事は?","タンパク質合成"],["複数の細胞だけからできている生物の総称は?","多細胞生物"],];break;
    case "細胞の基礎4" :item = [["葉緑体にある膜を何という?","チラコイド膜"],["リボソームで合成されたタンパク質がどこへ行く?","小胞体"],["小胞体にあるタンパク質はどこへ行く?","ゴルジ体"],["クロロフィルは葉緑体のどこにある?","チラコイド膜"],["色素体を5つ答えよ","葉緑体・エチオプラスト・プロプラスチド・黄色体・白色体"],["人の細胞はおよそ何種類ある?","200種類"],["DNAからたんぱく質の情報を受け取り、細胞質へと運ぶのは?","RNA"],["動物細胞にしか持たない細胞小器官は?","中心体"],["卵子の大きさは?","約0.15㎜"],["精子の全長は?","約60μm"],];break;
    case "細胞の基礎5" :item = [["細胞小器官に核は含まれる?","含まれる"],["原核生物にミトコンドリア、ゴルジ体はある?","ない"],["細胞内共生説を唱えたのは?","マーギュリス"],["光のエネルギーを利用して無機炭素から有機化合物を合成する反応は?","光合成"],["液胞に含まれる色素は?","アントシアニン"],["ペプシンは何を何に分解する?","タンパク質→アミノ酸"],["２つの溶液の浸透圧が等しいことを何という?","等張"],["アミラーゼは何を何に分解する?","デンプン→グルコース"],["人の生理食塩水は何%?","0.9%"],["細胞内液よりも浸透圧の低い溶液を何という?","低張液"],];break;
    case "細胞の基礎6" :item = [["人の体の中におよそ何種類の酵素がある?","約3000種類"],["カタラーゼは何を何に分解する?","過酸化水素→水・酸素"],["溶液中に溶けている成分を何という?","溶質"],["ある物質を溶かす液体のことを何という?","溶媒"],["グルコースを生体内で分解するにはphは◯,温度は◯度必要?","ph:7\n36度"],["水に溶けているどんな分子でも選択せず透過可能な膜を何という？","全透膜"],["異なる物質が混在している場合に物質が移動して広がる現象は?","拡散"],["植物の細胞壁は全透膜か半透膜か?","全透膜"],["物質が膜を通して拡散する現象は?","浸透"],["溶媒、または溶媒と一部の溶質のみを透過させる現象は?","半透性"],];break;
    case "細胞の基礎7" :item = [["半透膜を通して物質が浸透する時の圧力を何という?","浸透圧"],["細胞膜は半透膜、全透膜どちら?","半透膜"],["吸水圧を求める式は?","吸水力=浸透圧-膨圧"],["細胞内へ水が進入することによって細胞内に生じる圧力は?","膨圧"],["濃度の高い方から低い方へ物質が輸送される事を何という?","受動輸送"],["特定の物質のみを透過させるような細胞膜の性質を何という?","選択的透過性"],["濃度の低い方から高い方へ物質が輸送される事を何という?","能動輸送"],["細胞呼吸でADPとリン酸から何ができる？","ATP"],["胃に含まれる消化酵素とその最適pHは？","ペプシン\n ph:2"],["唾液に含まれる消化酵素は?","アミラーゼ"],];break;
    case "細胞分裂1" :item = [["同形、同大の染色体を何という?","相同染色体"],["分裂前の細胞を何という?","母細胞"],["分裂後の２つの細胞を何という?","娘細胞"],["生殖細胞を作る時に、情報量がもとの細胞の半分になる分裂を何という?","減数分裂"],["体を作る細胞が増える時の分裂を何という?","体細胞分裂",],["人の染色体は全部で何本?","46本"],["細胞が特定の形態や機能をもつようになる事を何という?","分化"],["核分裂が起きる時期を何という?","分裂期"],];break;
    case "細胞分裂2" :item = [["生物種によって染色体の数や形は変わるか？","同じ"],["核分裂後、次の核分裂が起きるまでの時期を何という?","間期"],["同形、同機能を持った細胞の集まりを何という?","組織"],["細胞分裂の過程を順に答えよ","前期・中期・後期・終期"],["細胞分裂前期に起きる事は?","染色体が現れ、紡錘体ができる"],["細胞分裂中期に起きる事は?","染色体が赤道面に並ぶ"],["細胞質分裂の際に現れる仕切りを何という?","細胞板"],["細胞を観察する時に酢酸オルセインを使う目的は?","染色体を染めるため"],];break;
    case "細胞分裂3" :item = [["細胞分裂後期に起きる事は?","染色体が細胞の両極に移動する"],["細胞分裂終期に起きる事は?","細胞にくびれが出来る"],["動物細胞の細胞分裂はどのようにして起きる?","赤道面で外側からくびれが入って細胞を２つに分ける"],["植物細胞の細胞分裂はどのようにして起きる?","赤道面に仕切りができ、細胞を２つに分ける"],["組織は集まって何になる?","器官"],["染色体が集まってる細胞の中央の面を何という?","赤道面"],["細胞分裂後期に染色体が２つに分かれる場所は?","動原体"],["細胞分裂で最も時間が長いのは何期?","間期"],];break;
    case "単細胞生物と多細胞生物1" :item = [["ゾウリムシにある細胞器官で消化に関わるのは?","食胞"],["細胞1個の生物を何という?","単細胞生物"],["多数の細胞の集合体の生物を何という?","多細胞生物"],["原生動物に見られる細胞器官で、浸透圧の調節をするのは?","収縮胞"],["単細胞生物で、食物を取り込む口を何という?","細胞口"],["ミドリムシにある光刺激を受ける器官は?","眼点"],["ミドリムシの運動器官を何という?","べん毛"],["多細胞生物になる前段階を何という?","細胞群体"],["ゾウリムシの運動器官を何という?","繊毛"],];break;
    case "単細胞生物と多細胞生物2" :item = [["植物内で物質の輸送に関わる組織系を何という?","維管束系"],["植物で細胞分裂を行う部分は?","分裂組織"],["植物の根を作る組織は?","根端分裂組織"],["植物の茎や葉を作る組織は?","茎頂分裂組織"],["根端分裂組織と茎頂分裂組織を合わせて何という?","頂端分裂組織"],["双子葉植物や裸子植物の茎・根にある分裂組織は?","形成層"],["形成層の仕事は?","茎と根の肥大"],["植物の保護と物質の出入りをする組織の集まりを何という?","表皮系"],];break;
    case "単細胞生物と多細胞生物3" :item = [["植物の維管束系を構成するのは?","仮道管・道管・師管"],["植物の表皮系と維管束系以外の部分を何という?","基本組織系"],["植物にある栄養を貯蔵する組織を何という?","貯蔵組織"],["厚い二次壁をもつ細胞からなる機械的に植物体を支持する機能をもつ組織は?","厚壁組織"],["植物の葉にある柔組織は?","さく状組織・海綿状組織"],["植物の葉の気孔の周囲にある細胞を何という?","孔辺細胞"],["動物の組織間を満たして、それらを結合・支持する組織は?","結合組織"],["動物の表面を覆う組織は?","上皮組織"],];break;


    case "無性生殖と有性生殖1" :item = [["卵と精細胞が結合する事を何という?","受精"],["生物が自分自身だけで子孫を作り出す方法を何という?","無性生殖"],["胞子を作り，胞子が単独で発芽する生殖法は?","胞子生殖"],["無性生殖の２つの方法は?","分裂・出芽"],["栄養器官の一部から新個体を作る生殖法は?","栄養生殖"],["親と全く同じ遺伝子を持つ細胞や個体の集まりを何という?","クローン"],["2個の配偶子が接合した結果生まれた1個の細胞を何という?","接合子"],["配偶子が合体することを何という?","接合"],["生殖の為の特別な細胞を何という?","配偶子"],["受精により生まれた接合子を何という?","受精卵"],];break;
    case "無性生殖と有性生殖2" :item = [["形も大きさも同じ配偶子を何という?","同形配偶子"],["大きさの異なる配偶子同士を何という?","異形配偶子"],["異形配偶子で小さい方を何という?","雄性配偶子"],["異形配偶子で大きい方を何という?","雌性配偶子"],["2つの異なる個体の配偶子が結合することにより子孫を作り出す方法を何という?","有性生殖"],["対合によって作られた2本の染色体が接着したものを何という?","二価染色体"],["減数分裂が起きると染色体の数はどうなる?","半分になる"],["減数分裂では1個の母細胞からいくつの娘細胞ができる?","4個"],["減数分裂で染色体の数が半分になるのは、第一分裂or第二分裂?","第一分裂"],];break;
    case "植物と動物の生殖1" :item = [["種子植物の胚珠の中にある雌性配偶体を何という?","胚嚢"],["花粉母細胞が減数分裂を行ってできる４個の半数体細胞を何という?","花粉四分子"],["花粉がめしべの柱頭につくと発芽して伸び出す長い管を何という?","花粉管"],["被子植物の胚嚢細胞の核分裂によって生じた8個の核のうち、ふつう胚嚢の中心にある2個の核を何という?","極核"],["被子植物の胚嚢の中の卵細胞の両側にある二個の小さい細胞を何という?","助細胞"],["受精卵は分裂を繰り返して何になる?","胚"],["植物の胚乳核が分裂すると何ができる?","胚乳"],["植物の胚嚢を包んでいる珠皮は何になる?","種皮"],];break;
    case "植物と動物の生殖2" :item = [["植物の胚と胚乳から何ができる?","種子"],["胚珠を包む子房壁が発達すると何ができる?","果実"],["胚乳に栄養分を蓄えている種子を何という?","有胚乳種子"],["子葉に栄養分を蓄えている種子を何という?","無胚乳種子"],["雌の体内で起きる受精を何という?","体内受精"],["雌の体外で起きる受精を何という?","体外受精"],["卵自体を保護する働きをする層を何という?","ゼリー層"],["精子は精巣のどこで作られる?","精細管"],];break;
    case "発生1" :item = [["たった一つの細胞である卵から親の形を作り上げる過程を何という?","発生"],["受精卵で極体が生じる側を何という?","動物極"],["発生の初期に見られる受精卵の体細胞分裂を何という?","卵割"],["受精卵が二細胞期から胞胚期まで卵割を繰り返して生じた細胞を何という?","割球"],["胚がほぼ同じ大きさの割球に分かれる事を何という?","等割"],["胚が大小の割球に分かれる事を何という?","不等割"],["黄卵が少なく、卵内にほぼ均一に分布している卵を何という?","等黄卵"],["卵黄が一方の極にかたよって分布している卵を何という?","端黄卵"],["卵割によって多くの割球が生じ、クワの実状となった胚を何という?","桑実胚"],];break;
    case "発生2" :item = [["胚の内部に生じた空所を何という?","卵割腔"],["胞胚期の卵割腔を何という?","胞胚腔"],["胚の外側の細胞の一部が内側に取り込まれる現象を何という?","陥入"],["陥入した細胞層と生じた空所を何という?","原腸"],["原腸胚の原腸の入り口を何という?","原口"],["陥入を始めた胚を何という?","原腸胚"],["胚から成体に至る中間の時期で、成体と異なる形態をとるものを何という?","幼生"],["両生類の胚で原口から動物極に向かって伸びる溝を何という?","神経溝"]];break;;break;
    case "発生3" :item = [["神経溝の一部が盛り上がると何ができる?","神経版"],["外胚葉から出来る組織や器官は?","表皮・脳・脊髄・感覚器官"],["中胚葉から出来る組織や器官は?","血管・筋肉・心臓・腎臓"],["内胚葉から出来る組織や器官は?","食道・肺・胃・小腸・大腸・膵臓・肝臓"],["卵の各部分の将来分化する器官や組織が、発生の初期から決められている卵を何という?","モザイク卵"],["割球のいくつかを分離しても、おのおのがまた完全な胚になるよう調整されている卵を何という?","調整卵"],["胚のどの部分が将来どんな組織や器官になるかを胚の〇〇という","予定運命"],["胚の予定運命図を作ったのは誰?","フォークト"]];break;;break;
    case "遺伝1" :item = [["生物種が持つ特有の形や性質を何という?","形質"],["形質が子孫に伝えられる現象を何という?","遺伝"],["子孫の形質が同じになる系を何という?","純系"],["一つの花の中で受粉することを何という?","自家受粉"],["同時に発現することのない対になった形質を何という?","対立形質"],["形質の遺伝子が2本の染色体のどちらか一方にあるだけでも発現するのは◯◯形質","顕性形質"],["形質の遺伝子が対になった染色体の両方にある場合にのみ発現するのは◯◯形質","潜性形質"],["顕性の形質のみが現れ、潜性の形質が現れない現象を何という?","顕性の法則"],["発現する形質のことを〇〇型","表現型"],];break;
    case "遺伝2" :item = [["形質の元になる遺伝子の組み合わせのことを〇〇型","遺伝子型"],["Aaのように異なる遺伝子が対になっている状態を何接合体という?","ヘテロ接合体"],["AAのように同じ遺伝子で構成される状態を何接合体という?","ホモ接合体"],["ある個体の遺伝子型を調べるために、潜性のホモ接合体と戻し交雑を行うことを何という?","検定交雑"],["対立遺伝子に優劣がない場合を何という?","不完全優性"],["両親の形質の中間を示す雑種を何という?","中間雑種"],["その遺伝子を持つ個体を死に至らしめる遺伝子のことを何という?","致死遺伝子"],["遺伝子が染色体に存在するのを発見したのは誰?","サットン"],["ほかの遺伝子のはたらきを抑制する遺伝子を何という?","抑制遺伝子"],];break;
    case "遺伝3" :item = [["一定の条件が満たされたときに表現形が現れるような遺伝子を何という?","条件遺伝子"],["2種類の遺伝子がお互い補い合って1つの表現型を現する遺伝子を何という?","補足遺伝子"],["メンデルの３つの法則は?","分離の法則・独立の法則・優性の法則"],["性を決める特別な染色体を何という?","性染色体"],["ヒトの常染色体の数は?","44本"],["ヒトの性染色体の数は?","2本"],["ヒトの雄の性染色体の組み合わせは?","XY"],["ヒトの雌の性染色体の組み合わせは","XX"],["ヒトは雄ヘテロ型、雌ヘテロ型のどちらか?","雄ヘテロ"],];break;
    case "遺伝4" :item = [["2対以上の対立遺伝子が同ーの相同染色体に存在することを何という?","連鎖"],["遺伝子の組み換えが起きる割合を何という?","組み換え価"],["組み換え価は一般的に何％を超えない?","50%"],["各染色体の位置関係を表した地図を何という?","染色体地図"],["3つの各遺伝子間の組換え価を出すための交雑を何という?","３点交雑"],["DNAの二重らせん構造を発見したのは誰?(2人)","クリック・ワトソン"],["DNAを構成する塩基の組み合わせは?","AとT\nCとG"],["DNAを構成する塩基A,T,C,Gをまとめて何という?","塩基"],["DNAは核のどこにある?","染色体"],];break;
    case "遺伝5" :item = [["DNAが巻き付いているタンパク質を何という?","ヒストン"],["ヒトの遺伝子は約何種類ある?","約22000種類"],["ヒトのDNAの長さは?","2.0m"],["細胞が他の細胞に由来するDNAを入れ、自身のDNAを組換えることにより、その遺伝的な性質を変化させること何という?","形質転換"],["ハツカネズミを用いて，形質転換を発見し，分子生物学の基礎を築いたのは誰?","グリフィス"],["性染色体にある遺伝子により起こる遺伝を何という?","伴性遺伝"],["複数の形質が一緒に遺伝するのを見つけたのは誰?","モーガン"]];break;;break;

    case "神経1" :item = [["目や耳など外部からの情報を集める器官を何という?","受容器"],["受容した感覚情報に反応して働く器官を何という?","効果器"],["受容器と効果器を繋ぐのは何系?","神経系"],["ホルモンを情報伝達物質として用いるのは何系?","内分泌系"],["神経細胞を英語で何という?","ニューロン"],["神経細胞で他の細胞への情報の出力元といて働くのは?","軸索"],["神経細胞で他の細胞からの情報の受け手として働くのは?","樹状突起"],["受容器の情報を伝える神経を何という?","感覚神経"],["指令を効果器に伝える神経を何という?","運動神経"],];break;
    case "神経2" :item = [["神経細胞内で情報が伝わる事を何という?","伝導"],["神経細胞の軸索のまわりを包み込む脂質に富んだ膜構造は?","髄鞘"],["末梢神経の髄鞘を形成する細胞は?","シュワン細胞"],["髄鞘を持つ神経を何という?","有髄神経"],["髄鞘を持たない神経を何という?","無髄神経"],["有髄神経で、髄鞘が中断してくびれている部分を何という?","ランビエ絞輪"],["神経細胞の静止電位はどれくらい?","-60mV ~ -90mV"],["何らかの刺激によって細胞膜に生じる一過性の電位変化を何という?","活動電位"],["活動電位が発生する事を何という?","興奮"],];break;
    case "神経3" :item = [["活動電位が生じた時に流れる電流を何という?","活動電流"],["ランビエ絞輪からランビエ絞輪へと飛ぶ伝導を何という?","跳躍伝導"],["興奮が起きる最小の刺激の強さを何という?","閾値"],["軸索は刺激に対して興奮か無のどちらかしか起きない事を何という?","全か無の法則"],["ニューロンとニューロンをつなぐ接合部のことを何という?","シナプス"],["シナプスで情報が伝わる事を何という?","伝達"],["シナプスで隣の細胞へ情報を運ぶ物質を何という?","神経伝達物質"],["目にある光を感じる細胞を何という?","視細胞"],["水晶体の仕事は?","光を屈折させる"],];break;
    case "神経4" :item = [["網膜の仕事は?","結像"],["虹彩の仕事は?","光の量の調節"],["明るい時に瞳孔はどうなる?","狭くなる"],["遠くを見る時に水晶体はどうなる?","薄くなる"],["網膜にある２種類の細胞は?","錐体細胞・桿体細胞"],["錐体細胞は網膜のどこにある?","黄斑"],["暗いところに段々目が慣れる事を何という?","暗順応"],["明るいところに段々目が慣れる事を何という?","明順応"],["耳のコルチ器官にある感覚細胞は?","聴細胞"],];break;
    case "神経5" :item = [["体の傾きを感知する耳の器官は?","前庭"],["体の回転を感知する耳の器官は?","半規管"],["横紋筋の種類は?","心筋・骨格筋"],["自分の意志で動かす事が出来る筋肉は?","随意筋"],["自分の意志で動かす事が出来ない筋肉は?","不随意筋"],["単発の刺激を断続的に与えたときにみられる収縮を何という?","単収縮"],["横紋筋で不随意筋は?","心筋"],];break;
    case "神経6" :item = [ ["脳と脊髄のことを何という?","中枢神経系"],["体性神経と自律神経を合わせて何という?","末梢神経"],["体性神経の種類は?","感覚神経・運動神経"],["自律神経の種類は?","交感神経・副交感神経"],["大脳の表面に近い部分を◯皮質という","大脳皮質"],["反射弓の経路は?","受容器→感覚神経→反射中枢→運動神経→効果器"],["熱いものに触れると手を引っ込める反射を何という?","屈筋反射"],["生まれながら備わっている行動を何という?","生得的行動"],];break;
    case "血液と循環1" :item = [["外部環境の変化に関わらず、体の内部の環境を一定に保とうとする性質を何という？","ホメオスタシス"],["血液が凝固したものを何という?","血餅"],["血漿からフィブリノゲンを除いたものを何という?","血清"],["異物を排除して自己を守る働きを何という?","生体防御"],["体内に侵入した異物を取り込んで処理することを何という?","食作用"],["病気を免れる抵抗力を何という?","免疫"],["生体に免疫応答をひきおこす物質を何という?","抗原"],["抗体が体を防御する仕組みを何性免疫という?","体液性免疫"],["リンパ球によって抗原を処理する仕組みを何性免疫という?","細胞性免疫"],["動脈と静脈が毛細血管 によりつながっている血管系を何という?","閉鎖血管系"],];break;
    case "血液と循環2" :item = [["毛細血管がなく動脈と静脈がつながっていない血管系を何という?","開放血管系"],["動物の組織の細胞間を満たす液体成分を何という?","組織液"],["リンパ管の中を流れる液体を何という?","リンパ液"],["抗原抗体反応が過剰に働く病気を何という?","アレルギー"],["血液を凝固させる物質を何という?","フィブリン"],["酸素量に対しての酸素ヘモグロビンの割合を表したグラフを何という?","酸素解離曲線"],["赤血球の働きは？","酸素運搬"],["白血球の働きは？","病原体の除去"],["血小板の仕事は?","止血と血液凝固"],];break;
    case "内蔵の働き1" :item = [["肝臓の仕事は?","代謝/エネルギーの貯蔵/解毒/胆汁の生成"],["肝臓でアンモニアは何に変わる?","尿素"],["胆汁が生成される場所は?","肝臓"],["胆汁を蓄える場所は?","胆嚢"],["胆汁の仕事は?","脂肪の乳化とタンパク質を分解"],["腎臓の仕事は?","血液の濾過/水分調節/尿の排泄"],["腎臓の最小単位の構造物を何という?","ネフロン"],["ネフロンを構成するのは?","腎小体と尿細管"],["腎小体を構成するのは?","ボーマン嚢・糸球体"],["糸球体でろ過された尿を何という?","原尿"]];break;;break;
    case "内蔵の働き2" :item = [["原尿に含まれる水・塩分・グルコースはどうなる?","再吸収"],["肝臓を通った後の血液に最も多く含まれるのは?","尿素"],["ボーマン嚢から原尿へ濾過されないのは?","タンパク質"],["原尿と成分が似ているのは?","血漿"],["甲状腺から分泌される血中Ca濃度を下げるホルモンは?","カルシトニン"],["胃から分泌されるセレクチンの作用は?","胃液の分泌促進"],["腎臓で作られた尿を貯蔵する場所は?","膀胱"],["尿にタンパク質が多く含まれる場合、どこの異常と考える?","糸球体"],["人工透析の目的は?","血液から老廃物を除く"],];break;
    case "ホルモンと自律神経1" :item = [["糖尿病患者に行う注射には何というホルモンが含まれる?","インスリン"],["血流に乗って標的器官へ運ばれて生命機能を維持するはたらきをもつ情報伝達物質を何という?","ホルモン"],["多くのホルモンが作られる場所は?","内分泌腺"],["下垂体前葉から出るホルモンをあげよ(3つ)","甲状腺刺激ホルモン・副腎皮質刺激ホルモン・成長ホルモン"],["下垂体後葉から出るホルモンは?","バソプレッシン"],["甲状腺ホルモンは?(２つ)","サイロキシン/トリヨードサイロニン"],["副甲状腺ホルモンは?","パラソルモン"],["膵臓のA細胞から放出されるホルモンは?","グルカゴン"],["膵臓のB細胞から放出されるホルモンは?","インスリン"],["副腎皮質ホルモンは?","コルチゾール、アルドステロン、副腎アンドロゲン"],];break;
    case "ホルモンと自律神経2" :item = [["副腎髄質ホルモンは?","アドレナリン"],["ホルモンを分泌する細胞を何という?","神経分泌細胞"],["交感神経が興奮すると何が分泌される?","ノルアドレナリン"],["副交感神経が興奮すると何が分泌される?","アセチルコリン"],["血糖を上昇させるホルモンは?","チロキシン・グルカゴン・アドレナリン・糖質コルチコイド・成長ホルモン"],["血糖を下げるホルモンは?","インスリン"],["パラソルモンの作用は?","血中のCa濃度の上昇"],["副交感神経が興奮すると排尿はどうなる?","促進する"],["食事後、血糖はどうなる?","上がる"],["バソプレッシンの作用は?","腎臓から排泄される水分量を制御することで体内の水分量を調節する"],["チロキシンの作用は？","全身の細胞の代謝を促す"],];break;

    case "植物の種類と水の吸収1" :item = [["低濃度溶液の溶媒が高濃度溶液の方に拡散しようとする現象を何という?","浸透現象"],["根が水を吸って茎を通して水をおしあげる圧力を何という?","根圧"],["水分子がお互いに引き合う力を何という?","凝集力"],["葉の気孔から水が出ることを何という?","蒸散"],["種子を作る植物を何という?","種子植物"],["胚珠が果実のもとになる子房に覆われ、守られている植物を何という?","被子植物"],["めしべの柱頭に花粉がつく事を何という?","受粉"],["最初に生えてくる葉っぱの枚数が2枚の植物を何という?","双子葉類"],["最初に生えてくる葉っぱの枚数が1枚の植物を何という?","単子葉類"],["被子植物の例は?","タンポポ/りんご"],["裸子植物の例は?","松/イチョウ/スギ"],["単子植物の例は?","トウモロコシ/チューリップ/ユリ"],["双子葉類の例は?","アブラナ/ひまわり"],];break;
    case "光と植物1" :item = [["植物の光合成においてこれ以上光を強くしても光合成の量が増えなくなる点を何という?","光飽和"],["植物の光合成と呼吸作用の大きさが等しくなるときの光の強さを何という?","補償点"],["光飽和点が高い植物を何という?","陽葉植物"],["光飽和点が低い植物を何という?","陰葉植物"],["植物の葉で光を十分に受ける位置にある葉を何という?","陽葉"],["植物の葉で光が当たらない位置にある葉を何という?","陰葉"],["陽性植物の例は?","アカマツ/ハマアカザ/ススキ"],["陰性植物の例は?","シュンラン/カンアオイ/ミズヒキ "],];break;
    case "植物の成長1" :item = [["植物の細胞膜を構成するセルロースの単量体を何という?","β-グルコース"],["インドール酢酸をアルファベットで答えよ","IAA"],["植物が発芽して枯れるまで植物の成長を制御している植物ホルモンは?","オーキシン"],["幼葉鞘の先端を切り取り寒天の上におき、屈性を調べたのは誰?","ウェント"],["マカラスムギの幼葉鞘に雲母を差し込んで屈性を調べたのは誰?","ポイセン＝イェンセン"],["クサヨシの幼葉鞘を使って屈性を調べたのは誰?","ダーウィン"],["光や接触などの刺激に対応して、植物が曲がるように成長することを何という?","屈性"],["植物が外界からの刺激を受けると、その刺激源の方向に関係なく、一定の方向に屈曲する性質を何という?","傾性"],["頂芽の成長が優先される一方で、側芽の成長が抑制される現象を何という?","頂芽優勢"],["植物の細胞分裂を促進するホルモンは?","サイトカイニン"],];break;
    case "植物の成長2" :item = [["植物体内において、植物ホルモンであるオーキシンの移動に方向性があることを何という?","極性移動"],["種子以外から発生する根を何という?","不定根"],["茎の成長を促進するホルモンは?","ジベレリン"],["茎が伸びず、草丈が著しく低い性質を持つ植物を何という?","わい性植物"],["細胞内の膨圧の変化によって起こる可逆的な運動を何という?","膨圧運動"],["果実が成長し柔らかくなるのに関わるホルモンは?","エチレン"],["落葉や落果を促進するホルモンは?","エチレン・アブシジン酸"],["落葉や落果を抑制するホルモンは?","オーキシン"],["刺激が来た方向へ植物が屈曲することを◯の屈性という","正の屈性"],["刺激が来た方向と逆の方向へ植物が屈曲することを◯の屈性という","負の屈性"],["植物の屈性の例を答えよ(3つ)","重力屈性・光屈性・接触屈性"],];break;
    case "発芽1" :item = [["発芽するのに光が必要な種子を何という?","光発芽種子"],["赤色光の波長はどれくらい?","660nm"],["遅赤色光の波長はどれくらい?","730nm"],["ジベレリンが合成する酵素は?","アミラーゼ"],["アミラーゼの仕事は?","デンプンの分解"],["アミラーゼの基質は何?","デンプン"],["アミラーゼの働きが良くなる温度はどれくらい?","40度"],["サイトカイニンはいつ発見された?","1957年"],];break;
    case "発芽2" :item = [["成長すると葉になる芽を何という?","葉芽"],["成長すると花になる芽を何という?","花芽"],["明期が短くなると花芽をつける植物を何という?","短日植物"],["明期が長くなると花芽をつける植物を何という?","長日植物"],["植物が日長に反応する性質を何という?","光周性"],["日長と関係なく花芽をつける植物を何という?","中性植物"],["植物が花芽を形成するために必要とする最大または最小限の暗期の長さを何という?","限界暗期"],["植物に人工的に照明して暗期を短くすることを何という?","長日処理"],];break;
    case "発芽3" :item = [["植物に人工的に照明して暗期を長くすることを何という?","短日処理"],["暗期の途中で赤色光を当てる処理を何という?","光中断"],["花芽の分化を誘発するホルモンを何という?","花成ホルモン"],["秋まき小麦を春に撒き、低温処理することを何という?","春化処理"],["発芽を促進するホルモンを答えよ(2つ)","オーキシン・ジベレリン"],["発芽を抑制するホルモンを答えよ","アブシジン酸"],["植物の発芽に必要な条件は?","温度・酸素・水"],["花が受粉すると何を形成する?","種子"],];break;
    case "植物ホルモン1" :item = [["分化を促進するホルモンを答えよ(2つ)","オーキシン・サイトカイニン"],["結実を促進するホルモンを答えよ(2つ)","オーキシン・ジベレリン"],["成長を促進するホルモンを答えよ","エチレン"],["開花を促進するホルモンを答えよ","フロリゲン"],["成熟を促進するホルモンを答えよ","エチレン"],["落葉を促進するホルモンを答えよ(2つ)","エチレン・アブシジン酸"],["落葉を抑制するホルモンを答えよ","オーキシン"],["休眠を促進するホルモンを答えよ","アブシジン酸"],["アブシジン酸の作用は?","発芽の促進と落葉の促進"],];break;

    case "地球と地図" :item = [["地球の表面積における陸地と海洋の割合は？", "3:7"], ["北半球には陸地の何分のいくつが分布している？", "3分の2"], ["陸地が最大となる半球を何と呼ぶ？", "陸半球"], ["海洋が最大となる半球を何と呼ぶ？", "水半球"], ["陸半球の中心はどこ？", "パリ南西付近"], ["水半球の中心はどこ？", "ニュージーランド南東"], ["陸半球の中心の緯度経度は？", "北緯48度、東経0.5度"], ["水半球の中心の緯度経度は？", "南緯48度、西経179.5度"], ["地球の半径は約何km？", "約6400km"], ["地球の全周は約何km？", "約4万km"], ["プトレマイオスは何をした人？", "2世紀ごろのギリシャの地理学者"], ["TO図は何を中心とする世界地図？", "エルサレム"],];
    case "地球と地図2" :item =[["TO図でOは何を表している？", "オケアノス(oceanの語源)"], ["TO図は何によって３つに分割されている？", "地中海など"], ["TO図で上は何を指している？", "東"], ["陸地の最高峰は？", "ヒマラヤ山脈のエヴェレスト山"], ["海洋の最深点は？", "マリアナ海溝のチャレンジャー海淵"], ["エベレスト山の標高は？", "8848m"], ["チャレンジャー海淵の深さは？", "10920m"], ["大陸別の高度別面積割合でヨーロッパは何m未満の割合が高い？", "200m"], ["アフリカは標高何m以下の割合が低い？", "低い"], ["南アメリカで標高が高いものが少ないのはなぜ？","南極氷河(氷床)に覆われているから"], ["緯度と経度は何を表すのに使われる？", "地球上の位置"], ["図で赤道はどれ？", "緯度0度の線"], ["本初子午線はどれ？", "経度0度の線"],["北極圏は何度?", "北緯66度33分"]];break;;
    case "地球と地図3" :item =[["地球は1日に何度回転する？", "1回転"], ["経度何度で1時間の時差が生じる？", "15度"], ["日付変更線はどこにある？", "経度180度"], ["日本の標準時子午線は何度？", "東経135度"], ["日本の標準時子午線はどこを通る？", "兵庫県明石市"], ["世界標準時(GMT)の基準となる経度は？", "0度"], ["UTCとは何？", "協定世界時"], ["複数の標準時を採用している国は？(例示)", "ロシア、アメリカ合衆国、オーストラリアなど"], ["サマータイムとは何？", "標準時より1時間進んだ時刻"], ["4月1日午後2時に東京から電話を受けたロンドンの時刻は？", "4月1日午前5時"], ["8月2日午前10時に成田を出発しロサンゼルスに到着した時の現地時刻は？", "8月2日午前4時"], ["本初子午線はどこを通る？", "ロンドン"]];break;;
    case "地球と地図4" :item =[["地図投影法とは？", "地球の表面を平面に写し取る方法"], ["正積図法とは？", "地球上での面積関係が正しく表されている図法"], ["正積図法の例は？", "サンソン図法、モルワイデ図法、ホモロサイン(グード)図法"], ["正角図法とは？", "地球上の任意の2点を結ぶ直線が最短コースを示す図法"], ["正角図法の代表例は？", "メルカトル図法"], ["メルカトル図法は何に利用される？", "航海図や航空図"], ["方位図法とは？", "中心からの距離と方位が正しい図法"], ["正距方位図法はどんな地図に使われる？", "航空図"], ["サンソン図法で緯線は何として描かれる？", "等間隔の平行線"], ["モルワイデ図法で経線は何として描かれる？", "楕円曲線"], ["高緯度地方のひずみが小さい図法は？", "モルワイデ図法"], ["高緯度地方のひずみが大きい図法は？", "サンソン図法"]];break;;
    case "地球と地図5" :item =[["メルカトル図法は何図法？", "正角図法"], ["メルカトル図法で、任意の2点を結んだ直線は何になる？", "等角航路"], ["メルカトル図法は何に便利？", "航海図"], ["メルカトル図法の欠点は？", "高緯度ほど面積や距離が拡大される"], ["メルカトル図法で、赤道上の経度1度と他の緯度における経度1度の距離は？", "同じ長さで表される"], ["緯度1度分の距離は約何km？", "約111km"], ["赤道上での経度1度分の距離は約何km？", "約111km"], ["正距方位図法の中心から見た方位は？", "正しい"], ["大圏(大円)コースとは？", "地球の中心を通る平面で切った時の円周(最短経路)"], ["メルカトル図法やミラー図法で見慣れた東京から真東に進むと？", "アメリカ合衆国の西海岸"]];break;;
    case "地球と地図6" :item =[["一般図の代表的なものは？", "地形図"], ["主題図の一つである統計地図とは？", "数値情報を地図化したもの"], ["絶対分布図とは？", "数値の絶対値を示した統計地図"], ["相対分布図とは？", "単位面積当たりや人口1人当たりの割合を示した統計地図"], ["ドットマップとは？", "点(ドット)で分布を表した統計地図"], ["等値線図とは？", "等しい値の地点を線で結んだ統計地図"], ["図形表現図とは？", "図形の大きさや形で数値の大小を表す統計地図"], ["流線図とは？", "移動の方向や量を線の太さで表す統計地図"], ["カルトグラムとは？", "本来の地形を歪めて統計量を示す統計地図"], ["東京からニューヨークへ最短コースで進むと？", "大圏(大円)航路"], ["正距方位図法で、中心から最も遠い外周点は？", "対蹠点"], ["地球全周は約何km？", "約4万km"], ["地図の4要素とは？", "距離、方位、面積、角度(形)"]];break;;
    case "地球と地図7" :item = [["カルトグラムとは？", "地域の統計数値を比較するのに便利な、地形を変化させた地図"], ["階級区分図(コロプレスマップ)とは？", "統計調査地区ごとの比率や密度を色彩や模様で表現した地図"], ["階級区分図は何の割合を示すのに用いられることが多い？", "1人当たりのGNI(国民総所得)や人口密度"], ["GNSSとは？", "全地球測位衛星システム"], ["GNSSは何に利用される？", "カーナビゲーションシステム"], ["リモートセンシングとは？", "人工衛星などから発信する電磁波を地表に反射させて情報を得る技術"], ["GISとは？", "地理情報システム"], ["GISは何に利用される？", "ハザードマップの作成"], ["AMeDASとは？","地域気象観測システム"],];
    case "大地形" :item =[["プレートテクトニクスとは？", "大陸が移動するなどのメカニズムを説明した地球科学の学説"], ["大陸移動説を提唱したのは？", "ウェゲナー"], ["地球の表面は何で覆われている？", "十数枚の固い岩盤(プレート)"], ["プレートの下には何がある？", "流動性のあるマントル"], ["プレートの境界は大きく何種類？", "3つ"], ["広がる境界とは？", "二つのプレートが互いに遠ざかる部分"], ["せばまる境界とは？", "プレートが互いに近づき合う部分"], ["ずれる境界とは？", "プレートが水平にすれ動く部分"], ["海嶺はどこにできる？", "広がる境界"]];break;;
    case "大地形2" :item =[["海嶺とは？", "マントル物質が上昇し、マグマとなって海底から噴出するところ"], ["大西洋を二分している海嶺は？", "大西洋中央海嶺"], ["リフトバレー(大地溝帯)とは？", "大陸が引き裂かれる場所にできる"], ["重いプレートと軽いプレートは？", "重い海洋プレートと軽い大陸プレート"], ["沈み込み型境界で形成される地形は？", "海溝、弧状列島(島弧)、火山脈"], ["海溝の深さは？", "6000m以上の深さ"], ["海溝部分で注意すべきことは？", "地震が発生しやすい、火山が形成される"], ["ずれる境界の例は？", "サンアンドレアス断層"], ["海洋プレートと大陸プレートの衝突でできるものは？", "海溝や弧状列島"], ["大陸プレートどうしが衝突するとできるものは？", "大山脈"], ["地球の表面積の約70%を占めているのは？", "海洋"], ["深海平原とは？", "水深4000m前後の平坦な深海底"], ["大陸棚とは？", "大陸沿いの海底にある、傾斜が緩やかな浅海底"]];break;;
    case "大地形3" :item =[["内的営力とは？", "地球内部の熱エネルギーによる力"], ["外的営力とは？", "太陽エネルギーによる力"], ["内的営力による現象は？", "火山活動、地殻変動(造陸運動、造山運動)"], ["外的営力による現象は？", "風化、侵食、運搬、堆積"], ["褶曲とは？", "地層が横からの圧力によって波状に折り曲げられること"], ["断層とは？", "地殻が断ち切られてその割れ目が生ずること"], ["活断層とは？", "断層のうち比較的最近活動したもので今後も活動が予想され、地震が発生する可能性があるもの"], ["プレートと地殻の関係は？", "プレートは地殻とマントル最上部を合わせた岩石層"], ["海洋プレートと大陸プレートの主な違いは？", "海洋プレートは玄武岩質、大陸プレートは花崗岩質"], ["リフトバレー(アフリカ大地溝帯)は何の境界？", "広がる境界"], ["プレートの中央部はどうなっている？", "安定している"], ["プレートの境界付近はどうなっている？", "地震や火山活動などが活発"]];break;;
    case "大地形4" :item =[["火山地形とは？", "流出する溶岩の粘性、火山ガスの量、噴火の回数などによって決まる地形"], ["火山の例(傾斜が緩やか)？", "ハワイ島やアイスランドなどの盾状火山、インドのデカン高原(溶岩台地)"], ["火山の例(富士山型)？", "成層火山"], ["火山の分布は？", "プレートの「広がる境界」にあたる海嶺や「せばまる境界」の海洋プレートが沈み込む部分"], ["ホットスポットとは？", "プレートの中央部をマグマ(マントル物質)が上昇してくる場所"], ["火山噴火による良い影響は？", "肥沃な土壌、美しい景観、温泉、地熱発電"], ["火山噴火による災害は？", "火砕流、溶岩流、土石流、降灰"], ["侵食とは？", "雨や河川などの流水や氷河の流下によって岩石が削り取られること"], ["外的営力は最終的に何をする？", "地表を平坦化する"], ["侵食輪廻とは？", "河川の侵食作用によって地形が変化していく過程"]];break;;
    case "大地形5" :item =[["侵食輪廻の最終段階は？", "準平原"], ["河川の侵食基準面は？", "海面"], ["V字谷ができるのは侵食輪廻のどの段階？", "幼年期"], ["老年期地形とは？", "侵食によりほとんど高低差がなくなった地形"], ["内的営力による現象の例は？", "造陸運動、造山運動(褶曲・断層)、火山活動"], ["外的営力による現象の例は？", "風化・侵食・運搬・堆積作用"], ["地震が多いプレート境界は？", "広がる境界、せばまる境界、ずれる境界"], ["沈み込み型境界の例は？", "太平洋プレートが北アメリカプレートに沈み込む日本海溝付近"], ["火山が多いプレート境界は？", "広がる境界、せばまる境界"], ["ハザードマップとは？", "災害が想定される地域を予測し地図化したもの"],];
    case "大地形6" :item = [["世界の大地形は、何によって大きく3つに分けられる？", "造山運動を受けた時期"], ["安定陸塊とは？", "プレート境界から離れたところ(プレートの中央部)"], ["古期造山帯とは？", "古生代に造山運動を受け、侵食が進んで低くなだらかになった山脈"], ["古期造山帯の例は？", "アパラチア山脈、ウラル山脈"], ["新期造山帯とは？", "中生代以降に造山運動を受け、高くて険しい山脈"], ["新期造山帯の例は？", "アルプス・ヒマラヤ造山帯、環太平洋造山帯"], ["アルプス・ヒマラヤ造山帯に含まれる山脈は？", "アルプス山脈、ヒマラヤ山脈"], ["環太平洋造山帯に含まれる山脈は？", "ロッキー山脈、アンデス山脈"], ["パンゲアとは？", "かつて一つであった大陸"], ["ローレンシア大陸とは？", "パンゲアが分裂した、北半球の大陸"], ["ゴンドワナ大陸とは？", "パンゲアが分裂した、南半球の大陸"]];break;;
    case "大地形7" :item =[["古期造山帯の山脈の高さは？", "1000~2000mくらいの低くなだらかな山脈"], ["古期造山帯の代表的な山脈は？", "アパラチア山脈、ウラル山脈、ドラケンスバーグ山脈、グレートディヴァイディング山脈"], ["テンシャン山脈やアルタイ山脈は何造山帯？", "例外的に高い古期造山帯"], ["日本はどの造山帯に属する？", "新期造山帯"], ["新期造山帯はプレートのどこに分布？", "「せばまる境界」付近"], ["安定陸塊に多く埋蔵されている資源は？", "鉄鉱石"], ["古期造山帯に多く埋蔵されている資源は？", "石炭"], ["新期造山帯に多く埋蔵されている資源は？", "銅鉱、銀鉱、石油、錫"], ["石油が多く埋蔵されている地域は？", "西アジア、北アフリカ"], ["楯状地とは？", "先カンブリア時代の岩石が地表に露出している安定陸塊"], ["卓状地とは？","先カンブリア時代の岩石の上に古い時代の地層がほぼ水平に堆積している安定陸塊"]];break;;
    case "小地形" :item =[["平野とは？", "農業をはじめとする経済活動に適した平坦面の土地"], ["平野の種類は？", "侵食平野と堆積平野"], ["侵食平野とは？", "山地などの凸部分が削り取られてできた平野"], ["堆積平野とは？", "河川などの侵食により削り取られた岩石や土砂が海底や谷底を埋めてできた平野"], ["準平原とは？", "山地が長い間侵食されて平坦化したもの"], ["構造平野とは？", "古い岩石や地層がほぼ水平に堆積してできた地形"], ["準平原の例は？", "バルト海の沿岸(バルト楯状地)、カナダの北東部(カナダ楯状地)"], ["構造平野の例は？", "東ヨーロッパ平原、北アメリカの中央平原"], ["ケスタとは？", "硬い岩石や地層が侵食に取り残されてできた特殊な地形"], ["日本の平野の大部分は？", "堆積平野"], ["メサとは?", "メサが侵食されて塔状になったもの"]];break;;
    case "小地形2" :item =[["堆積平野は主に何によって形成される？", "河川の侵食・運搬・堆積作用"], ["河川の上流部で働く力は？", "侵食力と運搬力"], ["河川の下流部や河口で働く力は？", "堆積力"], ["沖積平野とは？", "約1万年前から現在までの完新世に形成された平野"], ["沖積平野の種類は？", "扇状地、氾濫原、三角州(デルタ)"], ["山地を流れる河川が削り取るものは？", "岩石"], ["河川が山から平地に流れ出る山麓にできる地形は？", "扇状地"], ["扇状地は主に何で構成される？", "礫(砂より粒径が大きいもの)"], ["扇状地で、扇央では何になることが多い？", "水無川"], ["扇状地で、扇端では何がみられる?", "湧水"],["パリ盆地の地形は?", "ケスタ"]];break;;
    case "小地形3" :item =[["自然堤防とは？", "河川の両側に形成された微高地"], ["後背湿地とは？", "自然堤防の外側の低地"], ["氾濫原とは？", "自然堤防や後背湿地を含む平野"], ["三角州(デルタ)とは？", "河口付近に土砂が堆積してできた地形"], ["三角州の土壌は？", "肥沃な沖積土"], ["三角州は何に適している？", "水田や牧草地"], ["三角州の形成が活発な河川の例は？", "ナイル川、ガンジス川、ミシシッピ川"], ["扇状地、氾濫原、三角州どこに位置してる?", "扇状地は山麓、氾濫原は河川の中下流、三角州は河口付近"],["日本の台地のほとんどは?", "洪積台地"]];break;;
    case "小地形4" :item =[["海岸の地形は何によって分けられる？", "離水海岸と沈水海岸"], ["離水海岸とは？", "陸地の隆起または海面の低下によって形成された海岸"], ["離水海岸の地形の例は？", "海岸平野、海岸段丘"], ["沈水海岸とは？", "陸地の沈降または海面の上昇によって形成された海岸"], ["沈水海岸の地形の例は？", "リアス海岸、フィヨルド、エスチュアリー"], ["最終氷期には海面はどうなっていた？", "100m以上低下していた"], ["ベーリング海峡は最終氷期にどうなっていた？", "陸化していた"], ["河岸段丘とは？", "河川沿いに形成された階段状の地形"], ["台地とは？", "古い扇状地などが隆起してできた地形"], ["海岸段丘のでき方は?", "波の侵食作用によって作られた海食台や海食崖が離水したもの"]];break;;
    case "小地形5" :item =[["沈水海岸の代表的な地形は？", "リアス海岸、フィヨルド、エスチュアリー"], ["リアス海岸とは？", "V字谷を持った険しい山地が沈水してできた地形"], ["リアス海岸の例は？", "スペイン北西部、三陸海岸、若狭湾沿岸"], ["フィヨルドとは？", "U字谷(氷食谷)に海水が浸入してできた地形"], ["フィヨルドの例は？", "ノルウェー西岸、アラスカ〜カナダ太平洋岸、チリ南西岸、ニュージーランド南島西岸"], ["エスチュアリー(三角江)とは？", "河口部が沈水してできた地形"], ["エスチュアリーの例は？", "テムズ川、セーヌ川、エルベ川、ラプラタ川"], ["エスチュアリーができやすい場所は？", "安定陸塊など大河の河口"], ["日本にエスチュアリーが発達しにくい理由は?", "山がちで、しかも河川による侵食も盛んで土砂の生産や運搬・堆積作用が活発な為"]];break;;
    case "小地形6" :item =[["海岸の砂の堆積地形の例は？", "砂嘴、砂州、陸繋砂州(トンボロ)"], ["砂嘴とは？", "湾口を閉じるように伸びる砂州"], ["ラグーン(潟湖)とは？", "砂州によって外海と隔てられた湖"], ["陸繋島とは？", "砂州によって陸地とつながった島"], ["陸繋砂州(トンボロ)とは？", "陸繋島と陸地を結ぶ砂州"], ["サンゴ礁海岸はどこに分布？", "熱帯・亜熱帯の水温が高く、きれいな海"], ["サンゴ礁の種類は？", "裾礁、堡礁、環礁"], ["グレートバリアリーフは何の種類？", "堡礁"], ["エスチュアリーの代表的河川は？", "テムズ川、エルベ川、セーヌ川、ラプラタ川、セントローレンス川"], ["海岸平野と海岸段丘の例は？", "九十九里平野、室戸岬"], ["砂嘴と砂州の例は？","三保の松原、弓ヶ浜、天橋立"]];break;;
    case "小地形7" :item =[["氷河とは？", "万年雪(年間を通じて融けない雪)が圧縮されて氷氷になったもの"], ["氷河の侵食力が大きい理由は？", "上層の雪の圧力によって圧縮されるため"], ["大陸氷河とは？", "広く覆う大陸氷河(氷床)"], ["大陸氷河はどこに分布？", "南極大陸とグリーンランド"], ["山岳氷河(谷氷河)とは？", "高山の山頂付近などで発達する氷河"], ["氷期の最盛期には地球の何分の1が氷河に覆われていた？", "3分の1"], ["氷河の侵食地形の例は？", "カール(圏谷)、ホルン(尖峰)、U字谷"], ["カール(圏谷)とは？", "半椀状の凹地"], ["ホルン(尖峰)とは？", "複数のカールによって削り残された尖った峰"], ["U字谷とは？", "氷河によって削られてU字型になった谷"], ["モレーンとは", "氷河によって削り取られた岩屑が運搬され、高度が低下し氷河が消失するところに岩屑が押し固められたもの"], ["氷河の堆積地形の例は？", "モレーン"]];break;;
    case "小地形8" :item =[["砂漠(desert)とは？", "植物がほとんど生育していない土地"], ["ワジ(涸川)とは？", "降水時のみに流水がある河川"], ["砂漠で、ワジが利用される理由は？", "地下水面が浅く井戸も掘りやすいため、オアシス集落が立地しやすい"], ["カルスト地形とは？", "雨水に含まれる二酸化炭素が石灰岩を溶食してできた地形"], ["カルスト地形の例は？", "ドリーネ、ウバーレ、ポリエ、タワーカルスト、鍾乳洞"], ["ドリーネとは？", "石灰岩の溶食盆地"], ["ウバーレとは？", "複数のドリーネが結合したもの"], ["ポリエ(溶食盆地)とは？", "ドリーネやウバーレより大規模な溶食盆地"], ["タワーカルストとは？", "熱帯から亜熱帯の多雨地域で石灰岩が溶食されてできた塔状の地形"], ["テラロッサとは？", "石灰岩中の不純物が溶食から取り残されてできた赤い土"], ["風化とは?", "岩石が物理的、化学的に破壊されること"]];break;;
    case "小地形9" :item =[["チェルノーゼムの母材は？", "レス(黄土)"], ["外来河川とは？", "湿潤気候地域から流出し乾燥地域を貫流する河川"], ["外来河川の例は？", "ナイル川、ティグリス・ユーフラテス川、インダス川、コロラド川"], ["溶食の化学反応式は？", "CaCO₃ + CO₂ + H₂O → Ca(HCO₃)₂"], ["タワーカルストはどこに分布？", "熱帯や亜熱帯の多雨地域"], ["タワーカルストで有名な場所は？", "中国・コワントンシー壮族自治区のコイリン(桂林)"],];
    case "地形図" :item =[["地形図とは？", "等高線によって地形や水系を表現し、地図記号によって集落、道路、行政界、土地利用などの情報をくわしく記した地図"], ["国土地理院が発行している地形図の種類は？", "2万5千分の1と5万分の1の地形図"], ["2万5千分の1地形図は、何をもとにつくられた？", "実測図"], ["縮尺とは？", "地形図に描く範囲を実際の何分の一に縮めているか"], ["大縮尺の地図とは？", "分母が小さい地図(より詳細な情報)"], ["小縮尺の地図とは？", "分母が大きい地図(より広範囲の情報)"], ["2万5千分の1地形図と5万分の1地形図では、どちらが大縮尺？", "2万5千分の1地形図"], ["2万5千分の1地形図4枚分の範囲を描けるのは？", "5万分の1地形図1枚分"]];break;;
    case "地形図2" :item =[["等高線とは？", "等しい地点を結んだ線"], ["等高線の基準(標高0m)は？", "東京湾の平均海面"], ["等高線の種類は？", "主曲線、計曲線、補助曲線"], ["主曲線とは？", "細実線"], ["計曲線とは？", "太実線"], ["補助曲線とは？", "破線"], ["2万5千分の1地形図で、主曲線は何m間隔？", "10m"], ["2万5千分の1地形図で、計曲線は何m間隔？", "50m"], ["5万分の1地形図で、主曲線は何m間隔？", "20m"], ["5万分の1地形図で、計曲線は何m間隔？", "100m"], ["2万5千分の1地形図で、実際の距離1kmは何cmで表される？", "4cm"], ["5万分の1地形図で、実際の距離1kmは何cmで表される？", "2cm"], ["等高線は〇〇線になる", "閉曲線"], ["閉曲線の内側は必ず外側より〇〇ことを忘れない", "高い"]];break;;
    case "地形図3" :item =[["閉曲線の中に凹地を示す記号がある場合、内側はどうなっている？", "外側より低い"], ["等高線が交わらない例外は？", "土崖や岩崖の記号がある場合"], ["等高線が広く開いている場所の傾斜は？", "緩やか"], ["等高線が狭く閉じている場所の傾斜は？", "急"], ["尾根とは？", "等高線が標高の高いほうから低いほうへ出っ張っているところ"], ["谷とは？", "等高線が標高の高いほうへくい込んでいるところ"], ["実際の地形図で、道路や河川は何色で表されることが多い？", "道路は黒、河川は青"],];
    case "地形図4" :item =[["2万5千分の1地形図で、4cmの実際の距離は？", "1km"], ["5万分の1地形図で、4cmの実際の距離は？", "2km"], ["5万分の1地形図で、2cm四方の水田の面積は？", "1km²"], ["A地点の標高が1,200m、B地点の標高が800mで、A〜B間の水平距離が5,000mの時の平均勾配は？", "2/25"], ["等高線が入っていない場所は何を表す？", "傾斜があまりなく平坦な地形"], ["三角点とは？", "位置(緯度や経度)の基準点"], ["水準点とは？", "海抜高度の基準点"], ["等高線の間隔が密な場所の傾斜は？", "急傾斜地"], ["等高線の間隔が疎である場所の傾斜は?", "緩傾斜地"]];break;;
    case "地形図5" :item =[["河川の右岸と左岸は、どっちから見て判断する？", "河川の上流から下流方向を見て"], ["天井川とは？", "周囲よりも高くなった河川"],["天井川を横切る道路や鉄道はどうなっている？", "トンネルを通る"], ["自然堤防と後背湿地は、等高線の状態で判断できる？", "困難"], ["自然堤防はどこに分布していることが多い？", "河川沿い"], ["後背湿地はどこに利用されていることが多い？", "水田"], ["古い集落と新しい住宅地の違いは？(地形図上の特徴)", "古い集落は地形図上で道路幅が狭い、新しい住宅地は道路幅が広い"], ["扇状地はどんな形?", "緩やかに傾斜しているため等高線がほぼ等間隔の同心円状"], ["氾濫原はどんな地形?", "傾斜が少なく河川の両側に自然堤防がその外側に後背湿地が分布"], ["台地はどんな土地利用?", "乏水地であるため台地上には畑や果樹園、侵食谷では水田"]];break;;
    case "気候要素と気候因子" :item =[["気候とは何か？", "長期間の大気の平均状態を示したもの"], ["気候は何に影響を与えるか？", "地形、動植物の分布、人々の衣食住、経済活動、人口分布など"], ["気候を構成する要素を何というか？", "気候要素"], ["気温や降水量と何がわかれば共通テストでの高得点は間違いないか", "風"], ["気候要素の地理的な分布に影響を与えるものは何か？", "気候因子"], ["気候因子には何があるか？", "緯度、海抜高度（標高）、隔海度（海岸からの距離）、海流、地形など"], ["緯度と気温の関係は？", "低緯度ほど気温は高くなり、高緯度ほど気温は低くなる"], ["海抜高度が100m上がると、気温は約何度低下するか？", "約0.6℃"], ["海に近いと、何が増加し多雨になるか？", "水蒸気の流入"], ["海から離れると、何が減少し少雨となるか？", "水蒸気の流入"], ["山地の何側は多雨になるか？", "風上側"], ["大陸は何より比熱が小さいか？", "海洋"], ["大陸内部は、気温の何が沿岸部より大きくなるか？", "年較差や日較差"], ["何の影響を受けると温暖湿潤になるか？", "暖流"], ["何の影響を受けると冷涼乾燥になるか？", "寒流"], ["低緯度ほど何が高いため、単位面積当たりの受熱量が大きいか？", "太陽高度"], ["気温の等しい地点を結んだ線を何と言うか？","等温線"]];break;;
    case "気候要素と気候因子2" :item =[["海面更正気温度とは何か？", "海抜高度0mの気温に修正した気温"], ["等温線図は何を知ることができる便利な統計地図か？", "世界各地のおおよその気温"], ["海洋は何でできていて、何が大きいか？", "水、比熱"], ["大陸は何で、比熱が小さいか。", "岩石"], ["1月（北半球の冬）の等温線図だということが読み取れるのは、大陸部分と海洋部分のどちらが低温になっていることからか？", "大陸部分"], ["7月（北半球の夏）なら等温線は大陸部分で、どちら側に曲がるか？", "高緯度側"], ["海抜高度（標高）が上昇すると、気温はどうなるか？", "低下する"], ["海抜高度が100m上がるごとに気温は平均して約何度下がるんだ?", "約0.6℃"], ["南アメリカの低緯度地方では、快適な気候を求めて何が発達しているか？", "高山都市"], ["アフリカの低緯度地方でも標高が高い何山や何山では、山頂付近で氷雪や氷河がみられるか？", "キリマンジャロ山(5,895m)、ケニア山(5,199m)"], ["日本の1月の0℃、7月の20℃、そして年平均10℃の等温線はどこを通過しているか？", "日本を通過している"],["等温線に対して平行になるはずなのに大陸部分で低緯度側に曲がっている理由は何ですか？","寒流が流れていて、周囲より低温になるため"]];break;;
    case "気候要素と気候因子3" :item =[["札幌の年平均気温は何度か？", "8.9℃"], ["東京の年平均気温は何度か？", "15.4℃"], ["那覇の年平均気温は何度か？", "23.1℃"], ["気温の日較差とは何か？", "1日の最高気温と最低気温の差"], ["年較差とは何か？", "1年の最暖月と最寒月の平均気温の差"], ["気温の日較差は、どんなところで大きくなったり、小さくなったりするのか？", "低緯度地方、特に砂漠気候(BW)地域"], ["世界最高気温を記録したとされていた場所は？", "イラクのバスラ、リビアのアジージーヤ"], ["2012年にWMOが世界最高気温を記録したと発表したのはどこか？", "アメリカ合衆国のデスヴァレーにあるグリーンランドランチ"], ["グリーンランドランチは、どんな気候か？", "砂漠気候(BW)"], ["世界最低気温を記録したのはどこか?", "南極のヴォストーク基地"], ["人間の常住地域（エクメーネ）として、世界最低気温を記録したのはどこか？", "シベリア北東部のオイミャコン"], ["「北の寒極」と呼ばれているのはどこか？", "オイミャコン"], ["気温は、単位面積当たりの何の違いによって、低緯度ほど高くなるか？", "受熱量"], ["気温は、海抜高度が100m上昇するごとに、約何度ずつ低下するか？", "約0.6℃"], ["気温の年較差は、何が大きい大陸内部で大きくなるか？", "高緯度"], ["気温の年較差は、同緯度の場合、沿岸部より何の方が大きいか？", "大陸内部（乾燥地域）"], ["比熱（熱容量）とは何か？", "ある物質1gの温度を1℃変化させるための熱量"], ["水は、ガス体を除く自然界の物質では何が大きいか？", "最も比熱が大きい"], ["主に岩石からなる大陸は、温度がどうなりやすいか？", "上昇しやすく、低下もしやすい"]];break;
    case "気候要素と気候因子4" :item =[["世界の年平均降水量は約何mmか？", "約800mm"], ["日本の年平均降水量は約何mmか？", "約1,700mm"], ["水蒸気を含んだ空気が暖められて上昇すると、空気はどうなるか？", "膨張し、温度が下がる"], ["飽和水蒸気量は気温にほぼ比例するので、温度が低下すると空気に含まれていた水蒸気は何になるか？", "水滴"], ["水滴が雨になるメカニズムは、何が上昇することか？", "空気が上昇する（上昇気流）"], ["空気が上昇するところは、一般に気圧はどうなるか？", "低気圧"], ["天気予報で「低気圧の影響で雨が降ります」、「高気圧に覆われ晴天になります」というのは、何と何の関係について言っているか？", "気圧と天候"], ["降水のない形をいえ", "降雪"], ["降水の成因別分類で、強い日射で地表が急激に暖められ、積乱雲が発生し、熱帯地域のスコール、夏の夕立。これは何というか？", "対流性降雨"], ["降水の成因別分類で、気圧の低いところに空気が吹き込み、温帯低気圧や熱帯低気圧に伴う風が上昇気流が生じる。これは何というか？", "低気圧(収束)性降雨"], ["降水の成因別分類で、暖かい空気と冷たい空気がぶつかり、梅雨前線、秋雨前線など寒帯前線上の雨。これは何というか？", "前線性降雨"], ["降水の成因別分類で、貿易風、偏西風、季節風などの山地の風上側の雨(ノルウェー西岸、チリ南部、インド南西部など)。これは何というか？", "地形性降雨"], ["熱帯地域が分布する赤道付近は、受熱量がとても大きいので何が発生しやすいか？", "上昇気流"], ["赤道付近で上昇して雨を降らせたあとの空気が、緯度何度付近に下降していくか？", "緯度20～30度付近"], ["砂漠は、成因によって大きく何種類に分けられるか？", "4種類"], ["最も一般的に広くみられる砂漠は、年何の影響を受けてできる中緯度砂漠か？", "年中亜熱帯高圧帯の影響"], ["北アフリカのサハラ砂漠、アラビア半島の何砂漠が代表的な例か？", "ルブアルハリ砂漠"], ["緯度20~30度付近を見ると本当に何が多いか", "砂漠"]];break;;
    case "気候要素と気候因子5" :item =[["水蒸気を含む空気が上昇すれば何ができる", "雲"], ["ゴビ砂漠やタクラマカン砂漠は、水分の供給源の海からめちゃめちゃ離れている。このような砂漠を何というか。", "内陸砂漠"], ["大陸内部のように何が大きいと、水蒸気が供給されにくくなって砂漠になってしまう", "隔海度"], ["南アメリカ南部のパタゴニアは、南緯何～何度付近に位置しているか。", "南緯40～60度"], ["パタゴニアに大量に水蒸気を運んでくるのは何か。", "偏西風"], ["偏西風が何にぶつかって上昇気流になるか。", "アンデス山脈"], ["アンデス山脈の風上側にあたるチリ南部は何気候(Cfb)で、世界的な多雨地域か。", "西岸海洋性気候"], ["多量の雨を降らせた大気は、乾燥大気となって風下側の何に吹き込むか。", "アンデス山脈東側"], ["パタゴニアは地形性何砂漠と呼ばれるか。", "（雨陰）砂漠"], ["寒流の影響を受けて海岸部が砂漠になってしまう海岸砂漠の例は。", "ペルー沿岸～チリ北部のアタカマ砂漠、ベンゲラ海流の影響によるアンゴラ海岸部～ナミブ砂漠"], ["中低緯度の温暖な地域の大陸西岸に優勢な何が流れていると、大気が安定し、降水量は少なくなる。", "寒流"], ["海岸を流れる冷たい寒流によって、地表近くの岩盤や大気が冷やされて何が起こってしまう。", "気温の逆転"], ["中低緯度の大陸西岸では、寒流によって大気が安定し、何が生じにくいか", "上昇気流"], ["海流の影響による砂漠の例として何砂漠があるか", "ペルー沿岸～チリ北部のアタカマ砂漠, ベンゲラ海流の影響によるアンゴラ海岸部～ナミブ砂漠"],["砂漠形成の主要因は何か", "亜熱帯高気圧の影響, 隔海度が大, 半球間の風下側, 寒流の影響"],["水蒸気を含んだ空気が上昇し何が起きると雨が降るか","冷却"],["砂漠はさまざまな要因がからみ合って形成されるが、何の影響などが重要な因子となるか","亜熱帯高気圧,隔海度,山地の風下,寒流"]];break;;
    case "気候要素と気候因子6" :item =[["風は、何から何への空気の移動か？", "高圧部分から低圧部分"], ["年間を通じほぼ一定方向に吹くものを何というか？", "恒常風（惑星風）"], ["恒常風によって何と何の大気交換が行われるか？", "低緯度と高緯度"], ["赤道付近には、何が形成されるか？", "赤道低圧帯（熱帯収束帯）"], ["緯度20～30度付近に何が形成されるか。", "亜熱帯高圧帯（中緯度高圧帯）"], ["亜熱帯高圧帯から赤道低圧帯に向けて何が吹き込むことになるか。", "貿易風"], ["地球の自転の影響（転向力、コリオリの力）を受け、風の進行方向に対して北半球ではどちらに曲がるか。", "右（時計回り）"], ["地球の自転の影響（転向力、コリオリの力）を受け、風の進行方向に対して南半球ではどちらに曲がるか。", "左（反時計回り）"], ["赤道付近だとすると、その逆は極付近となる。極付近では受熱量が小さいため、空気は冷えて重くなる。そこで下降気流が生じ何が形成されることになるんだ。", "極高圧帯"], ["貿易風は、北半球では何風、南半球では何風になるか", "北東風、南東風"], ["恒常風には、貿易風のほかに何と何があるか", "偏西風と極偏東風（極東風）"], ["海洋と大陸の比熱差により、季節によって風向を変える風を何というか。", "季節風"], ["熱帯地域で発生し、高緯度側に移動する。暴風雨を伴う風は。", "熱帯低気圧に伴う風"], ["局地的に発生する風で、寒冷乾燥風や温暖湿潤風などさまざまな風があるのは何というか。", "地方風"], ["亜熱帯高圧帯から高緯度側に吹き出すのが何故か","偏西風"],["極高圧帯からの極東風と偏西風が衝突することによって何が生じるか","低圧帯"],["低圧帯をなんというか。","亜寒帯（高緯度）低圧帯"]];break;;
     case "気候要素と気候因子7" :item =[["気圧帯は7月に何、1月に何するか", "北上, 南下"], ["季節風は、恒常風と違って何によって風向を変える風か", "季節"], ["夏季は比熱の小さい何が温まり、暖められた空気は膨張するため低圧部ができる", "大陸"], ["相対的に高圧な海洋から低圧な大陸に風が吹き込むことになる。これが何の季節風だ。", "夏季"], ["冬季は逆に低温・高圧の何から海洋に吹き出すことになる。", "大陸"], ["つまり夏季の季節風は海洋から吹くため、湿潤な空気を移動させて何の原因となることをしっかり理解しよう。", "降水"], ["季節風の顕著な地域は何アジア、何アジアで、これらの地域は季節風の影響が強いため、何アジアと呼ばれているんだ", "東アジア, 南アジア, モンスーンアジア"], ["次は台風に代表される何気圧の説明をしよう！", "熱帯低気圧"], ["熱帯低気圧は、熱帯地域の何上で発生するか", "海洋"], ["熱帯低気圧は地域によっていろいろな呼び名があるけど、日本や中国などを襲うものを何、ベンガル湾やインドを襲うものを何、カリブ海で発生してメキシコ湾岸など北アメリカを襲うものを何と呼ぶか", "台風, サイクロン, ハリケーン"], ["熱帯低気圧は暴風雨を伴うため、何や何などの気象災害が発生すると、空気が海面を押す力が弱くなるので、海面が上昇する）によって家屋の倒壊や人的被害を与えるんだ。", "洪水, 高潮"], ["世界各地にはいろいろな特徴をもつその地域特有の風があり、これを何と呼んでるよ。", "地方風（局地風）"], ["最も代表的な地方風には何があるね。", "フェーン"],["フェーは何から夏にかけて地中海から吹く風が、アルプス山脈を越える際に生じる高温乾燥風のことを指していたんだけど、現在では何各地で生じる同様の気象現象を何現象と呼ぶよ。", "世界,フェーン現象"],["まず湿潤な空気が山地の風上側で何と何上昇するとするね。飽和状態の空気は海抜高度が100m上昇すると何度ずつ低下（湿潤断熱減率）するのに対し、雨を降らせた後に山を越えた乾燥状態の空気は100m降下する際に何度ずつ上昇（乾燥断熱減率）し、高温乾燥風となるんだよ。果実などの火事を発生させる恐れもあるんだね。", "上昇気流,0.5℃,1℃"],["一方、秋冬から冬にかけてフランスの地中海沿岸に吹く何やアドリア海に吹く何は寒冷乾燥風で、日本の何や何も同様の風だよ。", "ミストラル,ボラ,颪,空っ風"]];break;;
    case "気候要素と気候因子8" :item =[["風は気圧の何から何へ吹くか？", "高圧部から低圧部"], ["恒常風には何があるか、3つ答えよ。", "貿易風、偏西風、極東風"], ["季節風（モンスーン）は、何と何の何の違いによって生じるか？", "海陸の比熱差"], ["夏季に多い季節風は何をもたらすか？", "多くの降水"], ["地方風の例を2つ答えよ。", "フェーン、やませ"], ["温帯低気圧は、何と何の境界面で発生するか？", "温暖な空気塊と寒冷な空気塊"], ["温帯低気圧や温暖前線・寒冷前線は、何によってどちらからどちらへ移動するか？", "偏西風により西から東"], ["日本で冷涼湿潤な風で、冷害をもたらすものは何か？", "やませ（山背）"], ["やませはどこで発生するか？", "オホーツク海高気圧"], ["風は気圧の〇〇部から〇〇部へ吹く空気の移動である。", "高、低"]];break;;
    case "気候区分" :item =[["ケッペンの気候区分は、主に何と何に着目して区分されたか？", "植生と気温"], ["ケッペンは、世界の気候を何と何に大別したか？", "樹林気候と無樹林気候"], ["樹林気候は何と何と何に区分されるか？", "熱帯、温帯、亜寒帯（冷帯）"], ["無樹林気候は何と何に区分されるか？", "乾燥帯、寒帯"], ["乾燥帯は、さらに何と何に区分されるか？", "ステップ気候(BS)と砂漠気候(BW)"], ["寒帯は、さらに何と何に区分されるか？", "ツンドラ気候(ET)と氷雪気候(EF)"], ["熱帯の気候区分の記号は何か？", "A"], ["温帯の気候区分の記号は何か？", "C"], ["亜寒帯(冷帯)の気候区分の記号は何か？", "D"], ["乾燥帯の気候区分の記号は何か？", "B"], ["寒帯の気候区分の記号は何か？", "E"],["熱帯雨林の気候区分の略号は何か？", "Af"]];break;
    case "気候区分2" :item =[["熱帯(A)の、最寒月の平均気温は何度以上か？", "18℃以上"], ["熱帯雨林気候(Af)では、年降水量は多いか少ないか？", "多い"], ["熱帯モンスーン気候(Am)では、最少月降水量は何mm未満か？", "60mm"], ["サバナ気候(Aw)の特徴は何か？", "明瞭な乾季がある"], ["乾燥帯(B)は、降水量と何の関係で決まるか？", "蒸発量"], ["ステップ気候(BS)の年降水量は、およそ何mm程度か？", "250～500mm"], ["砂漠気候(BW)の年降水量は、何mm未満のことが多いか？", "250mm"], ["温帯(C)の最寒月の平均気温は何度未満か？", "-3℃"], ["地中海性気候(Cs)の特徴は？", "夏に少雨"], ["温暖冬季少雨気候(Cw)の特徴は？", "冬に少雨"], ["温暖湿潤気候(Cfa)の特徴は？", "年中多雨"], ["西岸海洋性気候(Cfb, Cfc)の特徴として、月平均気温10℃以上の月は何ヶ月以上あるか？", "4か月以上"], ["亜寒帯(冷帯)(D)の最寒月の平均気温は何度未満か？", "-3℃"], ["亜寒帯湿潤気候(Df)の特徴は？", "年中湿潤"], ["亜寒帯冬季少雨気候(Dw)の特徴は？", "冬に少雨"], ["寒帯(E)の最暖月の平均気温は何度未満か？", "10℃"], ["ツンドラ気候(ET)の最暖月の平均気温は何度以上何度未満か？", "0℃以上10℃未満"], ["氷雪気候(EF)の最暖月の平均気温は何度未満か？", "0℃"]];
    case "気候区分3" :item =[["熱帯は主にどこに分布しているか？", "赤道付近"], ["熱帯雨林気候(Af)はどこに分布しているか？", "赤道低圧帯の影響を受ける地域"], ["熱帯モンスーン気候(Am)は、弱い何があるか？", "乾季"], ["熱帯モンスーン気候(Am)で形成される森林は？", "熱帯季節風林（雨緑林）"], ["サバナ気候(Aw)は、熱帯雨林気候の何に分布しているか？", "周辺"], ["サバナ気候(Aw)は、どの大陸に広く分布しているか？", "アフリカ、南アメリカ"], ["高日季（夏季）には、サバナ気候(Aw)は何の影響を強く受けるか？", "赤道低圧帯"], ["低日季（冬季）には、サバナ気候(Aw)は何の影響を強く受けるか？", "亜熱帯高圧帯"], ["乾燥帯は、およそ南北の何付近に分布しているか？", "回帰線付近（ほぼ緯度25度）"],["砂漠気候(BW)はどこに分布している?", "大陸内部や大河川の流域"],["ステップ気候はどこに分布していますか", "砂漠の周辺部"]];break;;
    case "気候区分4" :item =[["乾燥帯(B)は、年間の何が蒸発量は気温に比例するか", "降水量"],["砂漠気候(BW)は、ほとんど年降水量が何mm未満の地域か？", "250mm"], ["砂漠気候(BW)で、人々は何を建設し、何を行うオアシス農業を営んでいるか？", "灌漑施設、ナツメヤシなどの栽培"], ["ステップ気候(BS)は、年降水量が何mm程度の地域か？", "250～500mm"], ["ステップ気候(BS)で、何が広がっているか？", "短草草原"], ["ステップ気候(BS)の地域では、何が盛んに行われているか？", "牧畜"], ["温帯(C)は、何が明瞭で、人間が最も生活しやすい気候環境にあるか？", "四季"], ["温帯(C)は、およそ緯度何度から何度に当たる地域に分布しているか？", "30～45度"],["大陸西岸には何気候(Cs)が分布していますか", "地中海性気候"], ["大陸東岸には何気候(Cfa)が分布していますか", "温暖湿潤気候"],["西岸海洋性気候は高緯度側に、温暖小雨気候は低緯度側に分布していますか？","はい"],["地中海性気候(Cs)は、夏に何の影響で乾燥し、冬は何の影響を受けるため降水が多くなるか？", "亜熱帯高圧帯、偏西風"], ["地中海性気候(Cs)は、主にどこの地域の何沿岸地方が代表的か？", "ヨーロッパの地中海"], ["温暖冬季少雨気候(Cw)は、主にどこの何部から何部にかけて広く分布するか？", "中国南部からインド北部"], ["Csの高緯度側(緯度45~60度付近)には、年に何の影響を受ける何気候(Cfb)が分布しているか？", "偏西風,西岸海洋性気候"]];break;;
    case "気候区分5" :item =[["亜寒帯(冷帯)は、主にどの大陸の何に分布しているか？", "ユーラシア大陸と北アメリカ大陸の高緯度地域"], ["亜寒帯(冷帯)では、何が形成されているか？", "針葉樹林(タイガ)"], ["シベリアやカナダの地域には、何が残っているところがあるか？", "永久凍土"], ["永久凍土とは何か？", "土や岩が一年中凍結している状態"], ["凍土現象とは何か？", "いったん融解して生じた水分が、冬季に再び凍結する際に、地面が隆起する現象"], ["凍土現象によって、何が放出される問題が生じているか？","温室効果ガスのメタンガス"], ["亜寒帯湿潤気候(Df)は、どこでみられるか？", "ユーラシア大陸や北アメリカ大陸"], ["亜寒帯冬季少雨気候(Dw)は、どこにしか分布していないか？", "冬季に優勢なシベリア高気圧の影響を受けるユーラシア大陸東部"], ["亜寒帯冬季少雨気候(Dw)は、何と呼ばれているか？", "北の寒極"], ["寒帯は、北極や南極のような何(66度33分より高緯度)などに分布するか？", "極圏"], ["寒帯でも何気候(ET)は、海抜高度が非常に高いどこやどこなどに分布しているか？", "ツンドラ、チベット高原やアンデス"], ["ツンドラ気候(ET)は、年間を通じて何が小さいか？", "受熱量"], ["ツンドラ気候(ET)は、主にどこの何沿岸に分布しているか？", "北極海"], ["ツンドラ気候(ET)では、何と何が生育するか？", "コケや小低木"], ["ツンドラ気候の分布地域には、人間は住んでいないということなのか？", "いいえ"], ["氷雪気候(EF)では、何に覆われていて、何もないか？", "年中雪や氷、草木"]];break;
    case "気候区分6" :item =[["高山気候(H)は、主にどこの何と何の内陸部がこれに当たるか？", "南極大陸とグリーンランド"], ["高山気候(H)では、何の影響で降雪は少ないか？", "極高圧帯"], ["高緯度側の極圏では、夏に何が起こり、冬に何が起こるか？", "一日中太陽が沈まない白夜、一日中太陽が昇らない極夜"], ["海抜高度が中緯度で何m以上の森林限界(樹木が生育する限界)より高い地域でみられるか？", "2,000m"], ["低緯度の高山気候では何が小さいか？", "気温の年較差"], ["低緯度の高山気候では何が強いか？", "低く紫外線"], ["ケッペンの気候区分は、何をもとに何と何で決定するか？", "植生、気温の年変化と降水量"], ["ケッペンの気候区分で、A・C・Dは何気候で、B・Eは何気候となるか？", "樹林気候、無樹林気候"], ["気候帯は、赤道を中心にほぼ何に分布しているか？", "南北対称"], ["高山気候(H)は、ケッペン自身が作った気候区分か？", "いいえ"]];break;
    case "気候区分7" :item =[["植生(森林や草地などの植物の集団)は何と何に影響されるか？", "気温と降水量"], ["熱帯(A)地域は熱量、降水量ともに豊富だから、植物の生育はどうか？", "活発"], ["熱帯雨林気候(Af)では、何と呼ばれる密林が形成され、アマゾン川流域では何、東南アジアやアフリカでは何と呼ばれているか？", "常緑広葉樹、セルバ、ジャングル"], ["マングローブ林は、どこの何や何に繁茂する森林で、ほかの樹木と異なり、何が高いか？", "大河川の河口付近や沿岸部、耐塩性"], ["熱帯モンスーン気候(Am)では、何と何が混じった熱帯季節林(雨緑林)がみられるか？", "常緑広葉樹と落葉広葉樹"], ["サバナ気候(Aw)では、強い何があり年降水量もAfよりやや少ないので、何(樹林密度が低い森林)と何が分布しているか？", "乾季、疎林、長草草原"], ["温帯地域の低緯度側には、何(何、何、何などが葉の硬い照葉樹林を形成)が分布しているか？", "常緑広葉樹、クス、カシ、シイ"], ["温帯地域の高緯度側には、何(何、何、何など)と何が分布しているか？", "落葉広葉樹、ブナ、ナラ、カエデ、針葉樹の混合林"], ["地中海沿岸には、何(何、何が、何)が生育しているか？", "硬葉樹、オリーブ、コルクがし、月桂樹"], ["亜寒帯(D)地域では、低温に耐える何(何、何、何)が多く、何と呼ばれる針葉樹林が広がっているか？", "針葉樹、エゾマツ、カラマツ、トウヒ、タイガ"], ["ツンドラ気候(ET)地帯では、樹木は生育できなくなり(森林限界)、何(何)が生える何になるか？", "地衣類、蘚苔類、ツンドラ"], ["乾燥帯(B)は植生に乏しいけど、何気候(BS)では短い何があるため、何と呼ばれる何が分布しているか？", "ステップ、雨季、短草草原"], ["砂漠気候(BW)では何はほとんどみられないことに注意しよう", "植生"]];break;
    case "気候区分8" :item =[["土壌とは、岩石が何してできた砂や粘土のような、細かい粒子になったものか？", "風化"], ["土壌には、何や何などが含まれたものか？", "有機物や腐植"], ["湿潤地域では土壌は何性で、乾燥地域では土壌は何性を帯びることが多いか？", "酸性、アルカリ性"], ["土壌は大きく何と何に大別されるか？", "成帯土壌と間帯土壌"], ["成帯土壌とは、何や何の影響を強く受けた土壌か？", "気候や植生"], ["間帯土壌とは、土壌のもととなる何の影響を強く受けたもので、何に分布する土壌のことか？", "岩石、局地的"], ["熱帯では、激しいスコールにより、栄養塩類のように水に溶かされやすい物質が流され、何や何などの金属が多く残った土壌になるか？", "鉄やアルミニウム"], ["熱帯で、赤色のやせた土壌を何というか？", "ラトソル"], ["ラトソルは、何の原料となる何を含む岩石の産地が、熱帯に多い理由の一つか？", "アルミニウム、ボーキサイト"], ["亜熱帯気候の地域では、主に何色の土壌が分布している", "赤黄色"], ["温帯の、落葉広葉樹林土は主に何色をしていますか", "褐色"], ["温帯湿潤気候地域では落葉の堆積によって、比較的厚い何を含む何色の土ができているか", "腐食層、茶色"], ["亜寒帯では、低温のため微生物があまり活動しないので、有機物の分解が進まず、何が形成されにくいか？", "腐植や栄養塩"], ["亜寒帯で、酸性が強いため、土中の金属成分が溶かされて下方に移動してしまって、酸に溶けにくい石英だけが地表付近に残され白っぽい土になったものを何というか？", "ポドゾル"], ["寒帯のツンドラ気候地域には、コケなどの遺骸が、低温のために分解されないまま堆積して炭化した何を含むやせた何が分布しているか？", "泥炭、ツンドラ土"], ["半乾燥のステップ気候では、一面の何が乾季に枯れ、土中に何を形成するか？", "短草草原、腐植層"], ["半乾燥のステップ気候で、黒色土のことをなんと呼ぶか？", "チェルノーゼム"], ["腐植は何によって適度に分解された微粒子で、何に富むか？", "有機物中の微生物、腐植"]];break;
    case "気候区分9" :item =[["土壌は、何と対応する何と、局地的に分布する何に大別される。", "気候帯、成帯土壌、間帯土壌"], ["土壌には何があって、植物の成長や農業の生産性に影響を与える。", "肥沃度の高低"], ["土壌には何が含まれており、植物の成長や農業の生産性に影響を与えるか", "肥沃度"], ["寒帯には主に何の土が分布しているか", "ツンドラ土"],  ["冷帯には主に何の土が分布しているか", "ポドゾル"], ["温帯には主に何の土が分布しているか", "褐色森林土"],["乾燥帯には主に何の土が分布しているか", "砂漠土、栗色土、黒色土"],["熱帯には主に何の土が分布しているか", "ラトソル"],["砂漠気候の植生は？", "植生なし(オアシスを除く)"],["ステップ気候の植生は？", "短草草原"],["ツンドラ気候の植生は？", "地衣類、蘚苔類"],["氷雪気候の植生は？","植生なし"]];break;
    case "陸水と海洋" :item =[["地球上には約何km³の水があるか？", "14億km³"], ["地球上で、海水の割合は何％か？", "97.5%"], ["陸水の割合は何％か？", "2.5%"], ["陸水のうち、約76.4%は何や何などとして存在するか？", "氷河や氷雪"], ["陸水のうち、約22.8%は何として存在するか？", "地下水"], ["図1によると、地表水はわずか何%にも満たないか？", "1%"]];break;
    case "陸水と海洋2" :item =[["陸水のうち多くを占めているのは何か？", "氷河や氷雪"], ["地下水とは何か？", "降水が地下に浸透し、不透水層(粘土層や岩盤)上に滞留したものを地下水という。"], ["地表に近い不透水層上を流れるものを何と呼ぶか？", "自由地下水"], ["自由地下水の下のさらに不透水層上を流れるものを何と呼ぶか？", "被圧地下水"], ["自由地下水はどこから近いため、取水しやすく、古くから世界中で利用されてきたか？", "地表"], ["乾燥地域では何の影響を受け、水量が乏しいことが多いか？", "気候"], ["被圧地下水の話で、何盆地での利用が有名か？", "オーストラリアのグレートアーテジアン(大鑽井)"], ["被圧地下水は、人が飲んだり、灌漑に使ったりするには何が高いので、人間や農作物より塩分の許容限界が大きい何に使われることになり、大規模な牧畜が行われているか？", "塩分濃度、羊や牛の飲み水"], ["一般的に被圧地下水は水量が豊富で、何や何として利用されているか？", "灌漑などの農業用水や工業用水"], ["被圧地下水は、岩盤を掘り抜いて何(これを掘り抜き井戸、または鑽井と呼ぶんだ)をつくらなければならないので、何が必要になってくるか？", "井戸、技術や資本"], ["不透水層上に局地的にある地下水のことを何と呼び、水が得にくい台地上の集落にとって貴重な水資源になっていたか？", "宙水"], ["1人当たり水資源賦存量とは何か？", "理論上人間が最大限利用可能な水資源量のことで、降水量から蒸発散量を引いたものに面積を乗じてその国の人口で割って求めた値"], ["日本の1人当たり水資源賦存量(m³/人・年)を海外と比較すると、世界平均の何以下か？", "1/2"]];break;;
    case "陸水と海洋3" :item =[["河川水は、何や何として利用されるだけでなく、何にも利用されている。", "生活用水や農業・工業用水、水運"], ["ヨーロッパは低地が広がるので、河川勾配が小さく、気候的にも何(Cfb)の地域では降水が年間を通じて一定だから、何が発達しているか？", "西岸海洋性気候、内陸水路"], ["日本の河川は、河川のある地点における何と何が大きいのが特徴か？", "最大流量と最小流量の比(河況係数)"], ["メコン川はどこを流れる河川で、流域は何が広がり、夏の何の影響で、何月の流量が増加しているのがわかるか？", "インドシナ半島、Aw、モンスーン、7～9月"], ["レナ川はどこを流れる河川で、流域には何が広がっているか？", "シベリア東部を北極海に向かって、Dw"], ["レナ川は、何月に流量のピークを迎えるけど、これは初夏の何による流量の増加か？", "6月、融雪"], ["ライン川はどこからどこに向かって流れる河川か？", "アルプス山脈から北海"], ["ライン川は、流域の大部分が何で、年中平均した降水があるため、何変化も少ないことが読み取れるか。", "Cfb, 流量"],["湖沼水は河川と同じように用水としても利用されてるけど、それ以外にも沿岸の気候をやわらげたり(高緯度にある何や何沿岸に都市が発達しているのはその例)、洪水の調節(何)、何、何などに役立ったりしている。", "五大湖やシベリアのバイカル湖、遊水池、水産業、観光"], ["氷河湖とは何か？", "氷河の侵食作用による凹地に湛水、または堆積作用によるせき止めで形成"], ["断層湖とは何か？", "地溝や断層運動によってできた凹地に形成"], ["カルデラ湖とは何か？", "火山活動によって生じたカルデラ内に形成"], ["海跡湖とは何か？", "かつて海洋であったところが地殻変動などにより閉ざされて形成"], ["氷河湖の例を３つ答えなさい", "五大湖、北欧、ヨーロッパロシア、カナダの湖"], ["断層湖の例を３つ答えなさい", "東アフリカのリフトバレー沿いの湖、バイカル湖、琵琶湖、諏訪湖"], ["カルデラ湖の例を３つ答えなさい", "洞爺湖、支笏湖、十和田湖、田沢湖"], ["海跡湖の例を３つ答えなさい", "カスピ海、アラル海、霞ヶ浦"],["海洋は、何、何、何ヨーロッパ地中海や日本海などの何に大別できる?", "太平洋、大西洋、インド洋の三大洋と、付属海"]];break;;
    case "陸水と海洋4" :item =[["貿易風や偏西風が吹くと、海との間で何が生じるか？", "摩擦"], ["表層の海水を動かす原動力となっているものは何か？", "貿易風や偏西風"], ["地表付近の卓越風の影響を強く受けて流れる海流を何と呼ぶか？", "吹送流"], ["主な海流は、北半球では何回り、南半球では何回りになっているか？", "時計回り、反時計回り"], ["ヨーロッパを見てごらん！何海流は明らかに何に引っ張られて、高緯度まで流れてるのがわかるよね？", "北大西洋海流、偏西風"], ["低緯度から高緯度に向かうものが何で、高緯度から低緯度に向かうものが何か？", "暖流、寒流"],["海流は、何と何によって生じる表層流で、気候因子の一つとして何温度を少なくする働きを行う。", "卓越風、低緯度"],["海流で、大部分は何によって生じる表層流で、何因子の1つとして何温度差を少なくする働きを行う。", "卓越風、気候、低緯度"], ["海流は、大部分は卓越風によって生じる何で、気候因子の1つとして何温度差を少なくする働きを行う", "表層流、低緯"], ["大部分は卓越風によって生じる表層流で、何因子の1つとして何温度を少なくする働きを行う。", "気候、低緯度"],["自由地下水と被圧地下水、浅い不透水層上にある地下水で、ほぼ大気と同じ圧力しか受けていないのは何？","自由地下水"],["自由地下水と被圧地下水、は、不透水層にはさまれ、大気より大きな圧力を受けている地下水で、自噴することもあるのは何？","被圧地下水"],["地中海と沿海、海洋は大洋と何に大別され、付属海は地中海と何(縁)海からなる。", "付属海、沿"],["地中海と沿海、何とは大陸に囲まれた海のことで、何、何、何などが代表的な地中海である。", "地中海、北極海、ヨーロッパ地中海、アメリカ地中海"],["地中海と沿海、何とは半島や島によって限られた海で、日本海、オホーツク海、北海などのように大陸に沿って分布している。", "沿海"],["エルニーニョ現象とは、平年に比べ東太平洋の赤道付近で何温度が高くなる現象のこと", "海面"],["エルニーニョ現象が起こり、何が広がるペルー沿岸やチリ北部(何砂漠)での集中豪雨や洪水、何ネシアの干ばつや何火災、日本の何豪雨、何フォニアでの冬季の降水量増加など世界中の何現象の原因ではないかと考えられている。", "砂漠、アタカマ、インド、森林、集中、カリフォル"],["エルニーニョ現象の反対で、貿易風が強まることにより東太平洋の海面水温が平年より低下する状態を指す現象は?", "ラニーニャ現象"]];break;
    case "自然災害と防災" :item =[["プレートテクトニクスとは何か？","大陸や海洋などの分布を説明している理論"],["日本列島は何枚のプレートの境界付近に位置しているか？","4枚"],["太平洋プレートはどちらの方向に移動しているか？","北西方向"],["日本の国土の約何%が山地か？","約70%"],["日本の国土を大きく3つに分ける際、その境界線となるものは何か？","フォッサマグナと中央構造線"],["フォッサマグナとは、どことどこのプレートの境界に当たるか？","北アメリカプレートとユーラシアプレート"],["中央構造線とは、西南日本を何と何に分ける大規模な構造線か？","西南日本内帯と西南日本外帯"],["太平洋プレートが北西方向に移動することで、何プレートに沈み込んでいるか？","ユーラシアプレート"],["フォッサマグナの東縁は不明瞭だが、西縁はどこからどこまでか？","新潟県糸魚川市から静岡県静岡市"],["フォッサマグナ周辺で、火山が集中している場所はどこか？","日本アルプス"],["日本アルプスを構成する山脈を北から順に3つ答えよ。","飛騨山脈、木曽山脈、赤石山脈"],["水深が200m未満の浅海底を何というか？","大陸棚"],["プレート境界に沿って、何が分布しているか？","海溝やトラフ"]];break;
    case "自然災害と防災2" :item =[["日本はプレート境界に位置しているため、どのような特徴があるか？","変動帯で、国土が山がち"],["日本には安定陸塊周辺にみられるような地形はあるか？","侵食平野はない"],["日本の地形は、主に何によって形成されたか？","侵食された土砂が堆積して形成された台地"],["千島・カムチャツカ海溝は、何プレートが何プレートに沈み込むところに形成されたか？","太平洋プレートが北アメリカプレート"],["千島・カムチャツカ海溝の最大深度は？","9,500mを超える"],["日本海溝は、何プレートが何プレートに沈み込むところに形成されたか？","太平洋プレートが北アメリカプレート"],["日本海溝の最大深度は？","8,000mを超える"],["日本海溝付近を震源とする地震は？","東北地方太平洋沖地震（2011年）"],["相模トラフは、何プレートが何プレートの沈み込むところに形成されたか？","フィリピン海プレートが北アメリカプレート"],["相模トラフ付近で発生した地震は？","関東地震（1923年、関東大震災）"],["伊豆・小笠原海溝は、何プレートが何プレートに沈み込むところに形成されたか？","太平洋プレートがフィリピン海プレート"],["伊豆・小笠原海溝の最大深度は？","9,800m以上"],["南海トラフは、何プレートが何プレートに沈み込むところに形成されたか？","フィリピン海プレートがユーラシアプレート"],["南海トラフ付近で発生が危惧されているものは何か？","近い将来における巨大南海トラフ地震"],["琉球（南西諸島）海溝は、何プレートが何プレートに沈み込むところに形成されたか？","フィリピン海プレートがユーラシアプレート"],["トラフと海溝の違いは何か？","水深6,000m未満の海底盆地がトラフ、6,000m以上が海溝"]];break;
    case "自然災害と防災3" :item =[["日本の国土は、南北と東西どちらに細長いか？","南北"],["北海道を除くほとんどの地域は何気候に属するか？","温暖湿潤気候(Cfa)"],["日本の夏は、何の影響により温暖で湿潤な気候となるか？","南東季節風と小笠原気団（太平洋高気圧）"],["日本の冬は、何の影響により寒冷で乾燥した気候となるか？","北西季節風とシベリア気団（シベリア高気圧）"],["日本における気温の年較差は何度前後か？","だいたい20℃前後"],["日本の地形は、何の影響を受けやすいか？","低気圧や前線"],["日本の特徴として、降水量の何が大きいか？","季節的変化"],["春に、本州付近をたびたび通過するものは何か？","低気圧"],["春に見られる、3日ほど寒い日が続くと4日ほど暖かい日が続くというような現象を何というか？","三寒四温"],["小笠原気団の北上によって、日本付近に発達する停滞前線は何か？","梅雨前線"],["南西諸島では何月に梅雨入りするか？","5月"],["本州では何月に梅雨入りするか？","6月"],["小笠原気団の南下により、シベリア気団が優勢になると発達する停滞前線は何か？","秋雨前線"],["秋雨前線は、何月から何月にかけて発達し、雨をもたらすか？","9月～10月"],["シベリア気団から吹き出す寒冷で乾燥した風を何というか？","北西季節風"],["日本海上で暖流の対馬海流から大量の水蒸気を供給され、雪雲が発生するのはどこか？","北陸、山陰などの日本海側"],["冬に、日本海側と太平洋側で大きく違うものは何か？","降水量"]];break;
    case "自然災害と防災4" :item =[["日本は地形的にも気候的にも何が起こりやすいと言えるか？","自然災害"],["地震は、世界中どこでも発生する可能性があるか？","はい"],["日本のようにプレート境界付近に位置している国・地域では、何が起こりやすいか？","地震などの地殻変動"],["プレートが動くことで何がたまり、そのパワーが地殻を破壊するか？","プレート境界やプレート内部にひずみ"],["岩石が破壊されたり、ずれたりする際の震動を何というか？","地震"],["プレート境界付近で発生する地震を何というか？","海溝型地震"],["海溝型地震では何が発生することがあるか？","津波"],["2011年に日本海溝付近で発生した地震は何か？","東北地方太平洋沖地震"],["東北地方太平洋沖地震のマグニチュードは？","M9.0"],["津波の高さは1mであったとしても、海岸から何km離れていても到達することがあるか？","数km"],["プレート境界だけでなく、プレート内の活断層の動きで発生する地震を何というか？","内陸直下型地震"],["海溝型地震に比べ、内陸直下型地震は何が大きいことが多いか？","マグニチュード（地震発生時のエネルギー）の割に、震度（実際の地表での揺れ）"],["1995年に神戸市付近を中心に発生した地震は何か？","兵庫県南部地震"],["兵庫県南部地震による被害は何というか？","阪神・淡路大震災"],["地震にともなう災害には、何があるか？","液状化"],["液状化とは、地震による震動で、地盤がどうなってしまう現象か？","液体状"],["液状化が起きやすい場所は？","埋め立て地や三角州など"],["津波から陸地を守るために作られた堤防を何というか？","防潮堤"],["津波から港を守る堤防を何というか？","防波堤"],["津波警報を発表するのはどこか？","気象庁"],["日本が多くの恵みを得てきたけど、有史以来なんどもなんども自然の猛威によって、考えられないくらいの被害やつらい思いをしてきたことを何というか？","自然災害伝承碑"]];break;
    case "自然災害と防災5" :item =[["日本は、世界でも有数の何大国か？","火山大国"],["活火山とは、具体的にどのような火山のことか？","概ね過去1万年以内に噴火した火山及び現在活発な噴気活動のある火山"],["現在、日本にはいくつの活火山があるか？","111"],["火山噴火予知連絡会とは何か？","火山噴火に関する情報を交換し、火山の総合的な判断を行う組織"],["東日本火山前線と西日本火山前線は、どこに沿って分布しているか？","それぞれ海溝にほぼ並行して"],["火山から噴出しているものがわかるだろう？それは何を見ればわかるか？","火山から海溝側には火山が分布していないことに注意"],["紀伊半島や四国には活発な火山があるか？", "ない"],["近年、どのような方法で火山噴火に対する避難訓練などが行われているか？","噴火警報・予報（気象庁が噴火災害軽減のために発表）の発令やハザードマップを利用"],["火山灰による被害は何か？","農地の被害や家屋の倒壊、火山灰の浮遊で太陽光が遮られることによる異常気象。"],["溶岩流による被害は何か？", "高温の溶岩が流下し、建造物や農地を破壊。"],["火砕流による被害は何か？","高温のガスを含む火山噴出物が⾼速で流下し、周囲を焼き尽くす。"],["火山泥流による被害は何か？","⼭地に堆積した⽕⼭灰や⽕⼭岩などが、降⾬によって⼟⽯流となって流下し、家屋や建造物を破壊。"],["山体崩壊とは何か？","火山体の一部が大規模に崩壊し、山麓に向かって岩なだれが発生。"],["1923年に発生した地震は？","関東地震"],["1995年に発生した地震は？","兵庫県南部地震"],["2011年に発生した地震は？","東北地方太平洋沖地震"]];break;
    case "自然災害と防災6" :item =[["地震などの自然災害に比べ、何は起こりにくいとされているか？","気象災害"],["冬に、ユーラシア大陸で発達した何から何が吹き出すか？","シベリア高気圧、北西季節風"],["北西季節風が、日本海上で何をもたらし、どこに大雪を降らせるか？","水蒸気を供給し、雪雲を発生させ、日本海側"],["大雪は何を引き起こすか？","交通障害、落雪、家屋や送電塔の倒壊、雪崩など"],["雪によって視界が真っ白になって、周囲の状況が全くつかめなくなることを何というか？","ホワイトアウト"],["北海道、東北、北陸、山陰などの多雪地域では、何のためにどのような工夫を行っているか？","落雪の被害を防ぐため、家の軒を長くしたり、地吹雪よけの防雪柵、道路を示す標識（積雪により、どこまでが道路か分からなくなるのを防ぐ）、消雪パイプ（路面へ地下水を散布し除雪、融雪）"],["夏季に油断は禁物なのはなぜか？","温暖化に伴う猛暑と冷夏"],["猛暑は何を引き起こすか？","熱中症や野菜などの不作"],["冷夏は何を引き起こすか？","米の凶作"],["冷涼湿潤なやませが日本列島に吹き込み、東日本の太平洋岸では何が発生し、農作物に打撃を与えるか？","冷害"],["梅雨期には、何が長いので、何が起こったりするので、困るか？","梅雨が長いので、水不足（渇水）"],["台風の進行方向に対して右側は、台風の渦に何が加わるため、風速がすごく速くなり、何による被害を受けやすくなるか？","偏西風の風速が加わるため、暴風による被害"],["台風による自然災害として、高潮はどのようなときに危険か？","高潮がすごく危険"],["台風による自然災害として、高潮はどのような現象で、何をもたらすか？","熱帯低気圧の吸い上げと強風による海水の吹き寄せで、海面が上昇する現象で、大規模な浸水被害"],["台風や梅雨などによる大雨や集中豪雨は、何を引き起こすか？","河川などの氾濫"],["河川の氾濫には、何と何があるか？","外水氾濫と内水氾濫"],["外水氾濫とは何か？","大雨や融雪によって、大量の水が一気に河川に流れ込むこと（河道から水があふれること）"],["破堤とは何か？","堤防が壊れ、水が堤内に流れ込むこと"],["内水氾濫とは何か？","河川の水が堤内地に流入する氾濫のこと"],["堤内地とは何か？","堤防で守られていて、住宅などが建設されている側の土地、つまり河川から見て、堤防の外側のことで、堤防から河川側のことを堤外地"],["河道が急に曲がるところ、川幅が急に狭くなるところ、河川の合流点などは何が起こりやすいので注意が必要か？","越流や破堤"],["洪水の被害を最小限にするために何が設置されているか？","不連続堤（図５）や遊水池（河川からいったん水をあふれさせ、帯水させるための池）"]];break;
    case "自然災害と防災7" :item =[["内水氾濫とは、どのような状態を指すか？","住宅地などが立地している堤内に降った雨が、河川に排出されず、家屋などが浸水する氾濫のこと"],["短時間の集中豪雨に排水が追いつかない場合と、何が高くなりすぎて、河川に排出されない場合があるか？","河川水位"],["最近、よく耳にする都市型水害とは何か？","都市化が進んだ地域で、地表のほとんどがアスファルト、コンクリート、高層ビルや戸建て住宅などの建築物に覆われているため、降った雨が地下に浸透しないで、あっという間に排水路や小河川に流入し、排水が追いつかない場合に起こる内水氾濫"],["都市型水害が起こりやすい場所はどこか？","地下街、地下鉄、アンダーパス（掘り下げ式の立体交差）など雨水が流れ込みやすいところ"],["都市型水害を防止するためにどのような対策がとられているか？","公園や運動場を洪水調整池（もし想定外の大洪水が起きたら、いったん水をここに貯める）としたり、地下に大規模な空間を設けた地下調整池や地下河川の建設"],["自然災害のテーマの防災・減災と復旧・復興について説明している言葉は何か？","自助・共助・公助"],["自助とは何か？","自ら対応し、自らが自分の身を守ること"],["共助とは何か？","近隣の人々や共同体で助け合うこと"],["公助とは何か？","消防、警察、自衛隊などの公的支援"],["どのような時に、自助・共助、つまり、自らが動き、家族、友人や隣人などの地域住民どうしの助け合いによる救助、避難誘導、避難所運営などを行うことが必要になるか？","大規模な機関自体が被災してしまった場合には全く機能しなくなることがあるので"],["復旧とは何か？","電気、ガス、水道、道路などのライフラインを、被災前の機能に戻すこと"],["復興とは何か？","被災者の生活再建、産業の振興、再び災害に見舞われた時の備えとして災害防御力の強化などを行うこと"],["復旧と復興には、何が必要になるか？","多額の資金と多くの人的支援、長い期間"],["津波は、どのようなときに発生するか？","地震発生による海底の隆起・沈降により"],["東北地方太平洋沖地震では、何m以上の高さまで遡上した地域がみられたか？","40m以上"],["不連続堤と連続堤の違いは何か？","不連続堤は、河川から水を徐々に流出させるため、切れ目を入れた堤防で、霞堤ともよばれる。連続堤は、切れ目がない堤防で、常時氾濫を防ぐのに適しているが、想定外の増水による越流・破堤の際には河道から溢れ出た水が、長期間滞留するため被害が大きくなる。"],["不連続堤は何とも呼ばれるか？","霞堤"]];break;
    case "農業" :item =[["農耕文化と農業の成立条件で、人間は何によって食料を手に入れてきたか？","狩猟・採集"],["農耕を始めたのは最終氷期後から約何万年前か？","1万年前"],["東南アジアでは何を栽培する根栽農耕文化が始まったか？","タロイモやヤムイモ"],["西アジアでは何を栽培する文化が始まったか？","小麦や大麦"],["中南アメリカでは何を栽培する新大陸農耕文化が生まれたか？","トウモロコシやジャガイモ"],["農業を行うには、最暖月平均気温が何度以上必要か？","10℃"],["熱帯での栽培に向いている作物は？","カカオ豆"],["低温に強い作物は？","テンサイ"],["年降水量何mm未満では、農業は難しいか？","250mm"],["年降水量250〜500mmは何気候と呼ばれるか？","ステップ気候(BS)"],["年降水量100mm未満の地域(砂漠気候)で農業を可能にするために利用されている川は？","ナイル川"],["乾燥地域での灌漑用水の蒸発を防ぐために利用された地下水路がある国は？","イラン"],["カナート、北アフリカでは何と呼ばれているか？","フォガラ"]];break;
    case "農業2" :item =[["自然的条件のまとめで、最暖月平均気温は何℃以上が必要とされているか？","10℃"],["自然的条件のまとめで、牧畜は何mm以上の年降水量が必要とされているか？","250mm"],["自然的条件のまとめで、畑作は何mm以上の年降水量が必要とされているか？","500mm"],["自然的条件のまとめで、水田稲作は何mm以上の年降水量が必要とされているか？","1000mm"],["自然的条件のまとめで、地形は何を好むとされているか？","平地"],["自然的条件のまとめで、腐植に富む土壌の例は？","チェルノーゼム、プレーリー土"],["自然的条件のまとめで、生産力が低い土壌の例は？", "ラトソル、ポドゾル"],["社会的条件のうち、市場・交通の発展によって何が可能になるか？","遠隔地への輸送"],["19世紀後半に何が発達し、牧畜を飛躍的に発展させたとされるか？","冷凍船"],["オーストラリアやアルゼンチンは何を輸送できたが、何を輸送できなかったか？","羊毛や牛皮、干し肉 / 生肉"],["資本・技術があれば、何が可能になるとされるか？","灌漑設備の建設"],["土地生産性とは何か？","単位面積(1ha)当たりの収穫量"],["労働生産性とは何か？","農業従事者1人当たりの収穫量"],["土地生産性が高い地域はどこか？","東アジア"],["労働生産性が高い地域はどこか？","アメリカ"]];break;
    case "農業3" :item =[["灌漑とは何か？","作物栽培を行うために雨水の利用以外の方法によって農地に水を供給すること"],["灌漑で利用される水の例は？","河川水、地下水、ため池"],["水田稲作が盛んなアジアでは何が高いか？","灌漑率"],["栽培限界とは何か？","作物栽培が可能な範囲の限界"],["農業の成立には、自然的条件と何が必要か？","社会的条件"],["東アジア諸国では、土地生産性が高いか低いか？","高い"],["アメリカ合衆国やカナダでは、労働生産性が高いか低いか？","高い"],["農業地域区分で、世界の諸地域では何が発達しているか？","さまざまな形態の農業"],["自給的農業から始まった農業の中で、特に何が多いか？","発展途上地域"],["遊牧は、最も伝統的なタイプの何か？","牧畜"],["遊牧が行われている地域の気候は？","ステップ気候(BS)やツンドラ気候(ET)"],["遊牧民が飼育している家畜の例は？(ユーラシア大陸)","羊、山羊"],["遊牧民が飼育している家畜の例は？(西アジア〜北アフリカ)","馬"],["遊牧民が飼育している家畜の例は？(チベット〜ヒマラヤ)","ヤク"],["オアシス農業はどこで行われているか？","砂漠"],["オアシス農業で栽培されている作物の例は？","小麦、大麦、ナツメヤシ、綿花、ブドウ"],["乾燥地域での灌漑で注意すべきことは？","塩害"]];break;
    case "農業4" :item =[["土壌塩類化のしくみで、何が蒸発すると塩類が地表に集積するか？","水分"],["熱帯地域で行われている農業は？","焼畑農業"],["焼畑農業で、何を肥料として利用するか？","草木灰"],["焼畑農業で栽培される作物の例(Af)は？","キャッサバ、ヤムイモ、タロイモ"],["焼畑農業で栽培される作物の例(Aw)は？","モロコシ"],["熱帯の土壌は何が多いか?","ラトソル"],["近年の人口の急増によって何が問題となっているか？","焼畑面積の拡大"],["焼畑の周期を短縮すると、何が起こるか？","環境破壊"],["アジアの伝統的農業は何に恵まれているか？","気温、降水量、土壌"],["アジアでは、何が集約的に発達したか？","労働集約的農業"],["東南アジア、南アジアでは何が中心に行われているか？","稲作農業"],["集約的稲作農業は、年降水量何mm以上の地域を中心に分布しているか？","1,000mm"],["代表的な稲作地域(タイ)は？","チャオプラヤ川流域"],["代表的な稲作地域(中国)は？","長江流域"],["代表的な稲作地域(バングラデシュ)は？","ガンジス川"],["中国の東北・華北やインドの内陸のデカン高原などでは何が栽培されているか？","小麦、トウモロコシ、綿花"],["アジアの農業経営は規模が大きいか小さいか？","小さい"],["世界の農業経営規模(表4)で、農業従事者1人当たりの農地面積が最も大きい国は？","オーストラリア"],["世界の農業経営規模(表4)で、農業従事者1人当たりの農地面積が最も小さい国は？","インド"],["自給的農業の分布(図5)で、アジア式稲作はどこに分布しているか？","アジア"],["自給的農業の分布(図5)で、乾燥地域の灌漑農業はどこに分布しているか？","ゴビ砂漠"]];break;
    case "農業5" :item =[["自給的農業のまとめで、遊牧はどこに分布しているか？", "乾燥地域(BS〜BW)、北極海沿岸地域(ET)"], ["自給的農業のまとめで、オアシス農業はどこに分布しているか？", "アジアやアフリカの乾燥地域(BW)"], ["自給的農業のまとめで、焼畑農業はどこに分布しているか？", "アジア、アフリカ、南米、オセアニアの熱帯地域(Af〜Aw)"], ["自給的農業のまとめで、アジアの伝統的農業はどこに分布しているか？","モンスーン気候下のアジア(東アジア、東南アジア、南アジア)"], ["商業的農業の説明に入る前に、何が発達するにつれて商業的農業が発達したか？","商工業"], ["ヨーロッパでは、何とともに都市が発達したか？", "商工業の発展"], ["商業的農業とは何か？", "都市へ農産物を販売することを目的とした農業"], ["ヨーロッパの農業は何から発展したか？","混合農業"], ["混合農業とは何か？", "小麦やライ麦などの食用穀物と、大麦、カブ、テンサイ、牧草などの飼料作物を輪作し、牛や豚などの家畜を飼育する農業"], ["ヨーロッパでは古くから何が必要だったため、休閑が必要だったか？","輪作"], ["フランスやドイツなど北西ヨーロッパは、何が低く、何に向かないか？","温暖湿潤気候(Cfa)に比べて気温がやや低く、偏西風のため過ごしやすい気温で、降水量も少ない穀物栽培には適した西岸海洋性気候(Cfb)"], ["西岸海洋性気候(Cfb)で、何によって地力を回復させる必要があったか？", "輪作をすることによって地力の低下を防ぎ、休閑によって地力を回復させる必要があった"], ["混合農業で、家畜から得られるもので一石二鳥なものは？","肉や乳製品"], ["現在の混合農業で、何に重点が移りつつあるか？", "家畜飼育"], ["酪農では、何を飼育し、何を出荷するか？","乳牛を飼育し、生乳やバター・チーズなどの乳製品を出荷する"], ["酪農が盛んな地域(ヨーロッパ)は？","北海〜バルト海沿岸や五大湖沿岸、アルプスの山岳地"], ["酪農が盛んな地域(ヨーロッパ以外)は？","デンマークやオランダ"], ["園芸農業とは何か？", "野菜、果実、花卉を都市へ出荷するために成立した農業"], ["近郊農業に対して、輸送機関も発達して何が可能になったか？","輸送園芸"], ["商業的農業の分布(図6)で、混合農業はどこに分布しているか？","アメリカ合衆国東部"],["商業的農業の分布(図6)で、酪農はどこに分布しているか？","アメリカ合衆国北東部"]];break;
    case "農業6" :item =[["ヨーロッパの農業の発達で、二圃式農業とは何か？", "耕地を二つに分け、耕作と休閑を隔年交互に繰り返す(北西ヨーロッパ)"], ["ヨーロッパの農業の発達で、三圃式農業とは何か？", "耕地を三つに分け、これを一年周期で一巡させる"], ["ヨーロッパの農業の発達で、混合農業とは何か？", "作物栽培と家畜飼育を組み合わせ、耕地では穀物栽培も鉄道する"], ["混合農業の特徴は？", "小麦などの食用穀物と飼料作物を輪作しながら、牛、豚を飼育。"], ["酪農の特徴は？", "乳牛を飼育し、乳製品を出荷。"], ["園芸農業の特徴は？", "野菜、果実、花卉を出荷。近郊農業と輸送園芸。"], ["地中海式農業の特徴は？", "耐乾性樹木作物栽培(オリーブなど)、地中海沿岸、冬季には小麦栽培。羊・山羊を飼育。"], ["地中海沿岸では、何と呼ばれる気候か？", "地中海性気候(Cs)"], ["地中海式農業で栽培される耐乾性樹木作物の例は？", "オリーブやコルクがし、オレンジ類"], ["地中海式農業では、何が整備されていないと厳しいか？", "灌漑"], ["移牧とは何か？", "家畜とともに移動しながら飼育する方法"], ["移牧で、ゲル(モンゴル)などで呼ばれるものは何か？","テント式の住居"], ["スイスのアルプス地方では、何と呼ばれる高原の牧場で放牧しているか？","アルプ"], ["スペイン中央部のメセタの場合、夏季にはどこで放牧するか？","海抜高度が高い高原"], ["スペイン中央部のメセタの場合、冬季にはどこで放牧するか？","土壌中に水分が残っている"], ["ヨーロッパ起源の商業的農業は、何が大きかったため、大きな影響力をもっているか？","資本と最新の技術が利用されている"],["企業的穀物農業は、何mm前後の黒色土地帯で発達したか？","年降水量500mm"],["企業的穀物農業で、何を使って、大規模に何を行っているか？","コンバインハーベスター(大型収穫機)などの大型機械を用いて大規模に行っている"]];break;
  case "農業7" :item =[["企業的農業の分布で、企業的穀物農業はどこに分布しているか？", "グレートプレーンズ、プレーリー、パンパ"], ["企業的農業の分布で、企業的牧畜はどこに分布しているか？", "グレートプレーンズ、グランチャコ、パンパ"], ["プランテーション農業はどこに分布しているか？", "南アメリカ"], ["企業的穀物農業の特徴は？", "大型の農業機械を用いて小麦などの大規模栽培。"], ["企業的牧畜の特徴は？", "大規模に肉牛や羊を放牧。"], ["プランテーション農業の特徴は？", "主として欧米など先進国向けに熱帯・亜熱帯性作物を栽培。"],["アメリカ合衆国の小麦地帯やグレートプレーンズでは、何と呼ばれる大規模な灌漑が行われているか？", "センターピボット"], ["センターピボットとは何か？", "地下水をポンプで汲み上げ、360度回転するパイプから散水する灌漑方式"], ["センターピボットで注意すべきことは？", "地下水の枯渇や、塩害(土壌の塩類化)"], ["企業的牧畜で飼育されている家畜は？", "肉牛や羊"], ["企業的牧畜が発達した地域(アメリカ)は？", "グレートプレーンズ"], ["企業的牧畜が発達した地域(アルゼンチン)は？", "パンパ西部"], ["企業的牧畜が発達した地域(オーストラリア)は？","マリー・ダーリング盆地"],["プランテーション農業とは何か？","東南アジア、アフリカ、ラテンアメリカなどの熱帯・亜熱帯地域で、先進国の資本・技術によって開発された大農園"], ["プランテーション農業で、誰が資本を投下し、誰を栽培したか？", "ヨーロッパ人が資本を投下し、現地人や移民の安い労働力を利用して、主に欧米先進国向けの熱帯性作物を栽培した"], ["プランテーション農業で作られる作物の例は？","モノカルチャー(単一耕作)形式"],["小規模の焼畑農業はどこで成立したか？", "アメリカ合衆国からカナダにかけてのプレーリー~アルゼンチンのパンパの奥部、オーストラリアのマリー・ダーリング盆地"]];break;
  case "農業8" :item =[["かつてのソ連や中国では、農場やその経営が何などの管理下に置かれていたか？", "国"], ["集団農業とは何か？", "一部の国を除いてはもうほとんど行われていない"], ["ソ連では集団農場の何と国営農場の何で行われていたか？", "コルホーズ、ソフホーズ"], ["中国では、何が解体し、現在は何に移行しているか？", "人民公社、生産責任制"], ["生産責任制導入後、農家の何が著しいか？", "生産意欲の伸び"], ["三圃式農業とは何か？", "中世ヨーロッパで行われていた農業で、地力低下を防ぐため、耕地を3分割して輪作をした。"], ["放牧と舎飼いのうち、家畜を飼育する際、牧場や牧草地で放牧する飼い方は何か？", "放牧"], ["放牧では何を飼料とするか？", "牧草"], ["放牧の利点は？", "飼料コストの軽減、管理の省力化"], ["等高線耕作とは何か？", "土壌侵食を防ぐため、等高線に沿って耕作をする"], ["アメリカ合衆国で発達したが、大型機械の導入が難しいため、等高線耕作を放棄する地域もあるものは？", "階段耕作"], ["オガララ帯水層とは何か？", "氷期に形成されたグレートプレーンズ付近の大規模な地下水層"], ["階段耕作とは何か？", "山地で農業を行う場合、斜面を等高線に沿って階段状に耕作すること"], ["階段耕作はどこで行われているか？", "日本、インドネシア、フィリピン"], ["日本の棚田は何のために保全が進められているか？", "景観保護"], ["モノカルチャーとは何か？", "ある特定の作物を栽培する農業経営のこと"]];break;
  case "農業9" :item =[["世界の諸地域では、何に適した農作物が栽培されているか？", "自然環境"], ["最初に主食として最も重要な三大穀物は？", "米、小麦、トウモロコシ"], ["米はどこからどこにかけてが原産地か？", "中国南部からインド"], ["米はどのような気候を好む作物か？", "夏の高温多雨(年降水量1,000mm以上)"], ["米の生産上位国で、アジア以外の国は？", "ブラジル、アメリカ合衆国、ナイジェリア"], ["米は、アジアでの生産量が世界の何%以上を占めるか？", "90%以上"], ["米、小麦、トウモロコシを比較して、生産量がほぼ一緒なのは？", "米と小麦"], ["米、小麦、トウモロコシを比較して、輸出量がかなり少ないのは？", "米"], ["インドは人口が多くても何があるため、輸出余力がないか？","輸出量"], ["輸出用の稲作も行われている国は？", "タイやベトナム"], ["エジプトと並びアフリカ最大の生産国で、近年米の生産に力を入れている国は？", "NERICA"], ["小麦の生産上位国(表9)で、1位と2位は？", "中国、インド"], ["小麦はどこが原産地か？", "西アジア"],["小麦は何mm前後の黒色土地域を好むか", "500mm"],["小麦は何に加工され主食となる？", "パンやパスタ"],["小麦の生産量と輸出量が多い国は？","アメリカ合衆国"]];break;
  case "農業10" :item =[["小麦には冬小麦と何小麦があるか？", "春小麦"], ["秋に種を播き、冬に発芽し、翌年の夏に収穫する小麦は？", "冬小麦"], ["春小麦は、何によって生まれた小麦か？", "品種改良"], ["春小麦は、いつ収穫するか？", "秋"], ["春小麦が栽培される地域(アメリカ)は？", "アメリカ合衆国高緯度の寒冷な地域"], ["春小麦が栽培される地域(カナダ)は？", "カナダ"], ["冬小麦が栽培される地域(インド、フランス)は？", "温暖なため冬小麦"], ["ライ麦、大麦が栽培されている地域(ドイツ、ポーランド、ロシア)は？", "寒冷な地域"], ["トウモロコシはどこが原産地か？", "中南米(メキシコ高原付近)"], ["トウモロコシはどのような気候を好むか？", "温暖湿潤気候"], ["トウモロコシは、古くから誰の主食として利用されてきたか？", "先住民(インディオ)"], ["米、小麦とトウモロコシの違いは？", "飼料用、工業用としての用途が多い"], ["トウモロコシの生産量と輸出量が圧倒的に多かった国は？", "アメリカ合衆国"], ["アメリカ合衆国の何に対する影響力がいかに大きいかがわかるか？", "畜産"], ["最近、トウモロコシの生産量が増加しているが、小麦をはるかに上回る約何億t？", "約12億t"], ["温暖化対策になる何などの原料として利用が拡大しているか？","バイオエタノールなどのバイオ燃料"],["主な穀物(表11)で、米の原産地は？","モンスーンアジア"],["米の特徴は？","夏の高温多雨(年降水量1,000mm以上)を好む。アジアが世界総生産量の90%以上を占める。"],["小麦の原産地は？","西アジア"],["小麦の特徴は？","年降水量500mm前後の黒色土を好む。熱帯を除き広範囲で栽培。温暖な地域では冬小麦、寒冷な地域では春小麦。"],["トウモロコシの原産地は？", "メキシコ高原"],["トウモロコシの特徴は？","年降水量1,000mm前後の温暖気候を好む。先進地域では飼料としての重要性が高いが、発展途上地域では重要な食料となる。近年はバイオエタノールの原料としても重要。"],["ライ麦の原産地は？","西アジア"],["ライ麦の特徴は？","耐寒性が強く、やせ地でも栽培が可。黒パンやウイスキーの原料。"],["エン麦の原産地は？","西アジア"],["エン麦の特徴は？","冷涼湿潤な気候を好む。飼料、オートミール。"],["大麦の原産地は？","西アジア"],["大麦の特徴は？","小麦栽培が不可能な寒冷地域でも栽培が可能。乾燥にも強く最も広範囲で栽培が可能な穀物。飼料、ビールの原料。"],["米や小麦、トウモロコシが主食として利用されていることはわかったけど、どこではイモ類が主食になっているんだ？", "アフリカやラテンアメリカの熱帯地域"]];break;
  case "農業11" :item =[ ["コーヒーはどこが原産地か？", "東アフリカ"], ["コーヒーはどのような気候を好むか？", "高温多雨で雨季・乾季が明瞭な気候"], ["コーヒーの栽培適地となっているのは？", "エチオピア高原のような水はけがよい高原"], ["コーヒーの主な生産地は？", "ラテンアメリカ"], ["コーヒーの生産国(近年)は？", "ベトナム、インドネシア"], ["チョコレートの原料となるカカオはどこが原産地か？", "熱帯アメリカ"], ["カカオはどのような気候を好むか？", "高温多雨で乾季がない低地"], ["カカオの主な生産地は？", "アフリカのギニア湾岸低地"], ["カカオの生産国は？", "コートジボワール、ガーナ、カメルーン、ナイジェリア"], ["茶はどこが原産地か？", "中国南部からインドの北部"], ["茶はどのような気候を好むか？", "温暖多雨で排水良好な山麓、丘陵、台地"], ["茶の原産地のアジアが主産地でもあるということはどこか？","中国、インド"],["茶の生産が多い国は？","ケニア、トルコ、スリランカ、ベトナム"], ["イギリス人は茶が大好きだから、旧何植民地だったどこに多くのプランテーションを開いていたか？","旧イギリス植民地だったインド、ケニア、スリランカ"], ["主な嗜好作物(表12)で、コーヒーの原産地は？","エチオピア高原"], ["コーヒーの特徴は？","成長期に高温多雨、収穫期に乾燥を必要とする。"], ["カカオの原産地は？","熱帯アメリカ"], ["カカオの特徴は？","年中高温多雨なAf〜Amの低地を好む。"], ["茶の原産地は？","中国南部〜インド・アッサム地方"], ["茶の特徴は？","温暖多雨で排水良好な高原、丘陵、台地を好む。"],["油ヤシとココヤシは熱帯の何地域を好む？", "多雨地域"],["油ヤシから採取されるものは？", "パーム油"],["パーム油はどこの国で生産が多い？", "インドネシア、マレーシア"],["ココヤシから採取され、洗剤や食用に使われるものは？", "コプラ"],["コプラはどこの国で生産が多い", "フィリピンとインドネシア"]];break;
  case "農業12" :item =[["油などの油脂原料として重要で、油ヤシからとれる油は？", "パーム油"], ["油などの油脂原料として重要で、ココヤシからとれる油は？", "コプラ油"], ["ナツメヤシはどこで栽培されているか？", "高温乾燥に強く、砂漠のオアシスなど"], ["ナツメヤシはどこでの生産が多いか？", "西アジア(イラン、サウジアラビア)や北アフリカ(エジプト、アルジェリア)"], ["大豆の原産地は？", "東アジア"], ["大豆の特徴は？", "夏の高温を好む。油脂原料、飼料として重要。"], ["サトウキビの原産地は？", "熱帯アジア"], ["サトウキビの特徴は？", "Aw〜Cwを好む。砂糖原料の大部分を占める。"], ["綿花の原産地は？", "種類によって原産地が異なる"], ["綿花の特徴は？", "乾燥には強いが、寒さに弱い。"], ["ジャガイモの原産地は？", "アンデス地方"], ["ジャガイモの特徴は？", "冷涼な気候を好む。"], ["天然ゴムの原産地は？", "アマゾン地方"], ["天然ゴムの特徴は？", "高温多雨のAfを好む。"], ["羊はどこで飼育が可能か？", "乾燥地域"], ["牛はどこで飼育が多いか？", "肉牛は混合農業地域や企業的牧畜地域で、乳牛は酪農地域で飼育。"], ["豚はどこで飼育されていないか？", "混合農業との結びつきが強い。北アフリカや西アジアなどイスラーム圏では宗教上の理由から飼育されていない。"], ["ネリカ米とは何か？", "アフリカの食糧事情を改善するために開発された稲の品種"], ["ネリカ米は何を交配させたものか？", "病虫害に強いアフリカイネを交配させた"], ["ネリカ米はどこを中心に普及しているか？", "近年は、ナイジェリアなど西アフリカを中心に普及している。"], ["家畜と宗教で、何教では、牛は神聖な家畜であると考えられているため、インドの牛の飼育頭数は多いが食用とせず、乳製品を多く摂取しているか？", "ヒンドゥー教"], ["家畜と宗教で、何教では豚を不浄と考えるため、飼育せず豚肉も食べないか？", "イスラーム(イスラム教)"],["遺伝子組み換え作物(GMO)とは？","ジーンの発達で、除草剤への耐性を持つ作物、害虫に強い作物、高収量が可能な作"],["三大穀物で、自給的な性格が強いのは？","米"],["三大穀物で、輸出に占める割合が高いのは？","小麦、トウモロコシ"],["コーヒーはどこ原産の嗜好作物？","アフリカ"],["カカオはどこ原産の嗜好作物", "中南アメリカ"],["茶はどこ原産の嗜好作物", "アジア"],["アフリカ、南米の熱帯地域では何が主食となっている", "イモ類"]];break;
  case "林業と水産業" :item =[ ["森林は世界の陸地の約何%を占めているか？","約30%"],["森林の持つ多面的な機能には何があるか？","洪水の防止、水源涵養、土壌侵食の防止、防風林"],["森林が少なくなると、何が起きやすくなるか？","洪水"],["ガンジス川やブラマプトラ川の下流域で洪水が頻発しているのはなぜか？","上流の森林伐採が進んだため"],["古くから人間は薪を何として利用してきたか？","燃料"],["発展途上地域での木材の利用は何が多いか？","薪炭材"],["先進地域での木材の利用は何が多いか？","用材（産業用材）"],["木材伐採高が多い国（上位5カ国）はどこか？","アメリカ合衆国、インド、中国、ブラジル、ロシア"],["先進国で用材として木材の伐採が多い国はどこか？","アメリカ合衆国、カナダ、スウェーデン、日本"],["発展途上国で薪炭材の割合が高い国はどこか？","インド、中国、ブラジル、エチオピア"],["広葉樹と針葉樹の割合に注目すべき国はどこか？","インド、中国、ブラジル"],["冷温帯地域の国で、針葉樹の割合が大きい国はどこか？","ロシア、カナダ"],["熱帯地域に位置する国で、広葉樹の割合が高い国はどこか？","インドネシア、マレーシア"],["世界における森林面積と森林率が大きい地域はどこか？","南アメリカとヨーロッパ"],["南アメリカで森林面積が大きいのはどこか？","アマゾン川流域のセルバ"],["ヨーロッパで森林面積が大きいのはどこか？","ロシア"],["アフリカとアジアの森林を見て感じることは何か？","思ったより低い"],["アフリカで森林率が高いと想像される地域はどこか？","赤道直下の熱帯雨林"],["熱帯の割合があまり高くない地域はどこか？","アフリカ"],["乾燥地域や山岳地帯で、何が広がっているか？","草原"],["森林面積の推移で、減少が大きい地域はどこか？","アフリカ、南アメリカ"],["森林面積の推移で、増加の傾向がある地域はどこか？","ヨーロッパ、アジア"]];break;
  case "林業と水産業2" :item =[["世界の森林は大きく分けて何帯に分類されるか？","熱帯林、温帯林、冷帯林"],["熱帯林の特徴は何か？","蓄積量が大きい、常緑広葉樹林の硬木が多い、多様な樹種"],["温帯林の特徴は何か？","低緯度では常緑広葉樹林、高緯度では混合林や落葉広葉樹林"],["冷帯林の特徴は何か？","針葉樹林（タイガ）、加工しやすい軟木が多い、単一樹種からなる純林を形成"],["熱帯の発展途上地域で人口急増によって何が行われているか？","薪炭材を中心とした過剰な伐採"],["ヨーロッパなどの先進地域では森林伐採はどのように行われているか？","植林をしながら計画的に"],["熱帯地域で森林の再生能力が低いのはなぜか？","激しいスコールによって土壌が流出したり、ラテライト化によって土壌がレンガのように固化してしまうため"],["発展途上国が多いアジアで森林が増加しているのはなぜか？","中国や東南アジア諸国の原木輸出規制などの効果"],["日本は国土面積の約何%が森林か？","約70%"],["森林率が50%以上の主な国はどこか？","フィンランド、日本、コンゴ民主共和国、スウェーデン、ブラジル、マレーシア"],["コンゴ民主共和国、ブラジル、マレーシアに共通する森林は何か？","熱帯雨林"],["フィンランド、スウェーデンに共通する森林は何か？","タイガ"],["日本は世界的な木材の消費国か、自給率が高いか？","消費国"],["日本の木材自給率は1960年には約何%だったか？","約90%"],["日本の木材自給率が低下した理由は何か？","戦後に植林された若木が成木にならなかったこと、バイオマス発電所で使われる燃料材の国内生産量の増加や住宅用の建築に国産材の使用が増えているから"],["日本の木材輸入相手国で、1970年と2022年で大きく変化したのはどこか？","アメリカ合衆国と東南アジアからの輸入割合が減少し、カナダ、ヨーロッパからの輸入割合が増加した"]];break;
  case "林業と水産業3" :item =[["木材（丸太・製材）の輸出が多い国（上位5カ国）はどこか？","ロシア、カナダ、ニュージーランド、ドイツ、チェコ"],["木材（丸太・製材）の輸入が多い国（上位5カ国）はどこか？","中国、アメリカ合衆国、オーストリア、ベルギー、ドイツ"],["日本の木材輸入先（上位5カ国）はどこか？","カナダ、アメリカ合衆国、スウェーデン、フィンランド、ロシア"],["2022年の日本の輸入総量（左端の数値）はいくつか？","5,019 (千m³)"],["近年輸入量が減少しているのはなぜか？","円安や不況によって輸入木材需要が低下していることや国産材の供給が増加しているから"],["降水を森林土壌がいったん貯留することによって、何が形成されるか？","地下水"],["河川へ流れ込む水の量を平準化させることによって、何を防止するか？","洪水"],["ラワン材とは何か？","フタバガキ科の樹木の総称で、東南アジアなどに分布する"],["ラワン材は何に適しているか？","合板"],["森林は、林産資源としてだけでなく、何の役に立っているか？","洪水防止など国土の保全"],["木材の用途には何があるか？","薪炭材と用材"],["薪炭材と用材、どちらが発展途上国での消費が多いか？","薪炭材"],["日本の木材輸入相手国はどこが多いか？","アメリカ合衆国、カナダ、ロシア"],["水産業が成立するためには何が必要か？","好漁場"],["好漁場の条件は何か？","栄養分（栄養塩類）→植物性プランクトン→動物性プランクトン→魚類という食物連鎖を考える"],["栄養分が上昇して、日光が届くところが好漁場になるのはなぜか？","植物性プランクトンが必要とするため"],["湧昇流とは何か？","中深層の海水が表層に上がってくる流れ"],["大陸棚上のバンク（浅堆）とは何か？","浅い海底部分"],["寒流と暖流が出合う場所を何というか？","潮目"],["世界の水域別漁獲量が多いのはどこか？（上位3つ）","太平洋北西部、太平洋南東部、太平洋西部"],["世界の主要漁場（表７）で、中心海域、立地条件、特色、主な漁獲物が全て記載されている漁場はどこか？","北西大西洋、北東大西洋"]];break;
  case "林業と水産業4" :item =[["水産業の発達には何が必要か？","資本と技術"],["発展途上国の経済発展や何によって漁獲量が増えているか？","200海里の経済水域（EEZ）の設定"],["発展途上国では、安価で豊富な労働力をいかした何が増加しているか？","養殖生産量"],["世界の漁獲量上位国の推移を示したグラフで、1990年代から漁獲量を伸ばしている国はどこか？","中国"],["中国の経済発展によって何が増加したか？","国内需要"],["ペルーでは浮き沈みが激しい漁獲物があるが、それは何か？","アンチョビー"],["1960年代に世界的な飼料不足が起こり、何が飼料や肥料として輸出を始めたか？","アンチョビー（カタクチイワシ）"],["1960年代は漁獲量が何になったか？","世界最大"],["日本の水産業が低迷しているのはなぜか？","昔の人が魚を食べなくなったから"],["日本の水産業は、何を除いてすべて漁獲量が減少しているか？","養殖"],["日本の漁獲量で、特に何が1973年をピークに激減しているか？","遠洋漁業"],["遠洋漁業が激減したのはなぜか？","石油危機による燃料費の高騰と、各国が200海里経済水域（EEZ）を設定し始めたから"],["1980年代後半からは、何漁業も各種の国際的な規制、マイワシの不漁や国民の嗜好が高級魚に転換したこともあって低迷しているか？","沖合漁業"],["近年、水産物の消費量は1960年代よりどうなっているか？","増加し、以前より多様化、高級化している"],["水産物の輸入相手国はどこが多いか？","チリ、アメリカ合衆国、ロシア、中国、ノルウェーなど"],["1970年代前半までは、水産物の自給率が何%だったか？","100%"],["現在は、水産物の何%以上を輸入しているか？","50%以上"],["好漁場の条件には何が必要か？","大陸棚上のバンクや潮目"],["日本の水産業は資源保護のため、何が注目されているか？","水産養殖や栽培漁業"]];break;
  case "商業と観光業" :item =[["消費行動の変化について何を認識しよう？","生活の豊かさによる生活スタイルの変化と多様化"],["余暇活動と海外旅行について、何が余暇活動にどのような影響を与えただろうか？","労働時間の短縮"],["商業は、商品を作った生産者から消費者に売る経済活動で、何構成では第3次産業に含まれるか？","産業別人口"],["「生産者→卸売業者→小売業者→消費者」というように商品が販売されていくことを思い出す上で卸売業とは何か？","生産者から工場で生産された商品を仕入れて、小売業者に販売する"],["企業間取引では、何が広く（商品を販売する範囲が広い）、企業が集積している中心地で発達することになるか？","商圏"],["三大都市圏の中心地の国家的中心都市はどこか？","東京、大阪、名古屋"],["地方の中心地の中広域中心都市はどこか？","札幌、仙台、広島、福岡"],["県庁所在地で卸売業が発達しているのはどこか？","準広域中心都市"],["小売業とは何か？","スーパー, コンビニ, 商店などの小売業者が, 一般消費者に商品を販売する"]];break;
  case "商業と観光業2" :item =[["商業販売額は何に比例することになるか？","人口"],["先進国では人々の収入が多く、生活水準も高いので、何などに対する支出が多くなるか？","食費などの生活必需品以外にも、趣味やレジャー"],["経済の発展は、何を引き起こし、新しいタイプの商業・娯楽施設、観光業などを発達させることになるか？","モータリゼーションの進展や生活スタイルの変化"],["発展途上国では、収入の大部分が何にあてられているか？","日常生活に最低限度必要なものの消費"],["消費支出に占める食費の割合と趣味・娯楽費の割合が高い国はどこか？","アメリカ合衆国"],["消費支出に占める食費の割合と趣味・娯楽費の割合が低い国はどこか？","バングラデシュ"],["先進国における工業の発展は、何と所得の増大は大量消費を可能にしたか？","大量生産"],["自動車の普及と道路の整備は、製品を輸送する流通業を発展させただけでなく、人々の行動空間を飛躍的に拡大させ、何を行えるようにしたか？","自分が行きたいときに、行きたいところへ買い物をしに行ける"],["モータリゼーションの進展による行動空間の拡大は、大規模な何を郊外に立地させ、消費行動をますます便利にし、多様化させているか？","ショッピングセンター、ファミリーレストラン"],["日本でも郊外の幹線道路沿いなどには、大きな何ができているか？","ショッピングセンター"],["アメリカ合衆国に代表される郊外型のショッピングセンターとは何か？","郊外は地価が安いため、広い売場に大量の商品を並べることができ、広い駐車場"],["アメリカ合衆国では、郊外に購買力の高い何が多いから、売り上げも見込めるか？","富裕層の住宅地"],["かつては消費行動が集中していた都心部にも何は立地していたか？","ショッピングセンター"],["現在は過密化による交通渋滞や地価の高さ、駐車場が少ないことなどから、都心部には大規模なショッピングセンターは建設しにくいのはなぜか？","過密化による交通渋滞や地価の高さ、駐車場が少ない"],["業態別小売業の単位当たり年間商品販売額（2014年）のうち、就業者1人当たり、売場面積1㎡当たりの額が最も大きい業態は何か？","百貨店"],["百貨店、大型スーパー、コンビニエンスストアの販売額推移で、バブル崩壊以降、何などの需要が低下したこともあり百貨店の販売額が減少し、代わってセルフサービスによる大型スーパー、コンビニエンスストアの販売額が増加しているか？","贈答品・高級品"],["主な国の産業別国内総生産（GDP）の変化で、第1次、第2次、第3次産業の割合が全て示されている国はどこか？","インド、ベトナム、ロシア、ブラジル"]];break;
  case "商業と観光業3" :item =[["2022年の年間労働時間が最も長い国はどこですか？","韓国"],["2022年の年間労働時間が最も短い国はどこですか？","ドイツ"],["2020年の観光客数(百万人)が最も多い国はどこですか？","フランス"],["2020年の観光収入(百億ドル)が最も多い国はどこですか？","アメリカ合衆国"],["観光客数と観光収入の両方で上位3位以内に入っている国はどこですか？","フランス、アメリカ合衆国"],["年次有給休暇の取得日数が最も多い国はどこですか？","フランス"],["ヨーロッパで長期休暇を取ることが多い理由として挙げられているものは何ですか？","夏季に長期休暇を取ること、晴天に恵まれた地中海沿岸に人気が移動すること、比較的安価で長期に宿泊できる宿泊施設が多いこと"],["日本で有給休暇の取得が義務化されたのはいつですか？","2019年"],["海外旅行者の大半は、旅行の主な目的を何にしていますか？","観光"]];break;
  case "商業と観光業4" :item =[["日本人海外旅行者数が急増した主な出来事は何ですか？（複数回答）","プラザ合意、円高"],["2020年以降に日本人海外旅行者数が激減した理由は何ですか？","新型コロナウイルス感染拡大"],["2019年の日本人海外渡航先として最も多かった国はどこですか？","アメリカ合衆国"],["1990年と2019年を比較して、渡航先として増加数が最も大きかった国はどこですか？","中国"],["訪日外国人旅行者のうち、最も多い地域はどこですか？","東アジア"],["訪日外国人旅行者のうち、「その他」を除いて、2番目に多い地域はどこですか？","東南アジア、南アジア"],["日本人の海外渡航先として、アジア諸国が多い理由は何ですか？","近くて旅費が安く、日程も取りやすいため"],["2015年に日本への訪日外国人旅行者数は何人を超えましたか？","2003万人"], ["訪日外国人旅行者数は何年に過去最多を記録しましたか?","2019年"]];break;
  case "エネルギーと鉱山資源" :item =[["18世紀後半にイギリスで何が起こり、エネルギー消費が増大しましたか？","産業革命"],["1960年代にエネルギー革命が起こった主な理由を3つ挙げてください。","多くの油田開発により、安価で安定した供給が可能になったため、パイプラインの敷設や大型タンカーの就航で輸送コストが低下したため、石油のほうが石炭より発熱量も大きい化学工業原料としても利用しやすいため"],["石炭に代わってエネルギーの主役になったのは何ですか？","石油"],["1970年代に世界を驚かせた出来事は何ですか？","石油危機（オイルショック）"],["石油危機は、消費国にどのような影響を与えましたか？","経済危機を招き、消費国は省エネルギー政策をとることになった"],["石油危機後、先進国は何エネルギーの利用拡大を試みましたか？","原子力発電や天然ガス"],["現代において、できるだけ環境負荷が小さいエネルギーとして注目されているのは何ですか？","再生可能エネルギー"],["再生可能エネルギーの例を3つ挙げてください。","バイオマスエネルギー、太陽光、風力"],["2020年に最も生産量の多いエネルギーの種類は何ですか？","固体燃料"],];break;
  case "エネルギーと鉱山資源2" :item =[["世界のエネルギー生産（生産と消費）は、1960年から2020年までの約60年間で、およそ何倍以上になっていますか？","5倍"],["1960年と1970年のデータを比較して、生産量・消費量が逆転したエネルギーは何ですか？","石炭と石油"],["1人当たりエネルギー消費量が最も多い国はどこですか？","カナダ"],["1人当たりエネルギー消費量が最も少ない発展途上国はどこですか？","インド"],["カナダとアメリカ合衆国の1人当たりエネルギー消費量が、ドイツや日本よりもはるかに大きいのはなぜですか？","国土面積が広く、人やモノの輸送距離が長いこと、エネルギー資源も豊富にあるため"],["1次エネルギー消費割合が最も高い国はどこですか？","中国"], ["日本は、何のエネルギーの割合が高いですか？","石油"],["ロシアは、何のエネルギーの割合が高いですか？", "天然ガス"], ["エネルギー資源を生産できるかどうか大きなポイントになるけど、先進国はどこへの依存度が高い傾向にある？","石油"], ["先進地域では、何が盛んなため、大量のエネルギーを消費している？", "商工業などの産業や人々の生活"]];break;
  case "エネルギーと鉱山資源3" :item =[["石炭、石油、天然ガスは、何と呼ばれる資源ですか？", "化石燃料"], ["化石燃料は、どのようにしてできたものですか？", "古い地質時代に動植物が化石化して形成されたもの"], ["石炭生産量が最も多い国はどこですか？", "中国"], ["石炭生産量上位3か国を答えてください。", "中国、インド、インドネシア"], ["石炭輸出量が最も多い国はどこですか？", "インドネシア"], ["石炭輸出量上位3か国を答えてください。", "インドネシア、オーストラリア、ロシア"],["第1次石油危機は西暦何年に起きましたか？", "1973年"], ["第1次石油危機は、何が原因で発生しましたか？", "第4次中東戦争"], ["第2次石油危機は西暦何年に起きましたか？", "1979年"], ["第2次石油危機は、何が原因で発生しましたか？", "イラン革命"], ["カーボンニュートラルとは、どのような考え方ですか？", "農作物などの植物は生長過程で大気中のCO₂を吸収するため、その植物を燃焼させたり、植物から抽出した燃料を燃焼させ、排出したとしても大気中のCO₂総量に影響を与えない"], ["中国が世界の石炭生産量の何%以上を生産していますか？","50%以上"]];break;
  case "エネルギーと鉱山資源4" :item =[["主要な石炭産出国として、オーストラリアは何位にランクインしていますか？", "4位"], ["主要な石炭の主な炭田として、中国の炭田を3つ挙げてください。", "フーシュン炭田、カイロワン炭田、タートン炭田"], ["原油価格が大きく上昇した主な出来事を2つ挙げてください。", "第1次石油危機、第2次石油危機"], ["1960年に設立された、石油輸出国機構の略称をアルファベットで答えてください。", "OPEC"], ["1968年に設立された、アラブ石油輸出国機構の略称をアルファベットで答えてください。", "OAPEC"], ["2022年の原油生産量が最も多い国はどこですか？", "アメリカ合衆国"], ["OPEC加盟国の中で、2022年の原油生産量が最も多い国はどこですか？", "サウジアラビア"], ["2022年の原油輸出量が最も多い国はどこですか？", "サウジアラビア"], ["OPEC加盟国の中で、2022年の原油輸出量が最も多い国はどこですか？", "サウジアラビア"], ["「資源ナショナリズム」とは、どのような考え方ですか？", "自国の資源を自国の発展のために利用しようという考え方"], ["先進国が、自国の利益を優先して、発展途上国の資源を自由に利用できない状況を表す言葉は何ですか？", "資源ナショナリズム"], ["石油の埋蔵や採掘、精製、流通、販売をするには、何が必要ですか？", "巨額な資本と高度な技術"]];break;
  case "エネルギーと鉱山資源5" :item =[["1980年代後半から、逆オイルショックと呼ばれる石油価格の何が起こった？", "下落"], ["2020年に原油輸入量が最も多かった国はどこですか？", "中国"], ["日本は2020年に原油輸入量が世界で何番目に多いですか？", "5番目"], ["ロシアの主要な油田を2つ挙げてください。", "チュメニ油田、ヴォルガ・ウラル油田"], ["アメリカ合衆国の主要な油田を3つ挙げてください。", "内陸油田、メキシコ湾岸油田、カリフォルニア油田"], ["ペルシャ湾岸に面するサウジアラビアは、何という油田で世界最大級の埋蔵量を誇り, OPECのリーダー的存在？", "ガワール油田"], ["2018年以降、サウジアラビアとロシアを追い抜いた、世界最大の消費量と輸入量の国はどこ？", "アメリカ合衆国"], ["世界最大の輸入国だったが、近年は中国が最大の輸入国になっている。ほとんど石油を産出しない日本は何の輸入量が多い？", "原油"], ["図3で、OPECとOAPECの両方に加盟している国を3つ挙げてください。", "サウジアラビア、クウェート、アラブ首長国連邦"], ["天然ガスは、石炭や石油に比べて何が少ない？", "汚染物質やCO₂の排出量"], ["近年需要が伸びている液化天然ガスをアルファベット3文字で何と呼ぶ？", "LNG"], ["メキシコは、いつOPECに加盟していましたか？", "OPEC設立前"]];break;
  case "エネルギーと鉱山資源6" :item =[["ガスの分布で偏りが大きい、アメリカ合衆国とロシアで世界の約何%を生産している？", "約40%"], ["ガスの輸送で、陸上や大陸棚上で使われるものはなに？", "パイプライン"], ["ガスの輸送で、海上輸送で使われるものはなに？", "LNG専用タンカ"], ["最近、アメリカ合衆国とカナダで進められている天然ガスは？", "シェールガス"], ["シェールガスとは、地中の何に閉じ込められた天然ガスのこと？", "頁岩"], ["アメリカ合衆国は、何という原油の開発や生産にも力を入れている？", "シェールオイル"], ["図4から、日本は、石炭、石油、天然ガスを主にどこから輸入している？3つ答えよ", "オーストラリア、サウジアラビア、アラブ首長国連邦"], ["日本が石炭を最も多く輸入している国はどこですか？", "オーストラリア"], ["日本が石油を最も多く輸入している国はどこですか？", "サウジアラビア"], ["日本が天然ガスを最も多く輸入している国はどこですか？", "オーストラリア"], ["電力を作り出すための代表的な発電方法を3つ挙げてください。", "水力発電、火力発電、原子力発電"], ["産業革命後、エネルギー消費の中心となった発電は何ですか？", "火力発電"], ["1970年代の石油危機以後、日本が建設を進めた発電は何ですか？", "原子力発電"], ["表10で、水力発電の主な発電形式で、「流れ込み式」とは何ですか？", "河川を流れる水を直接利用して発電"], ["表10で、水力発電の主な問題点は何ですか？", "森林等の水没など自然環境破壊、ダムの堆砂"]];break;
  case "エネルギーと鉱山資源7" :item =[["2011年3月に発生した東日本大震災によって、日本のどの原子力発電所が事故を起こしましたか？", "福島第一原子力発電所"], ["日本の電力構成で、2022年時点で最も割合が高いのは何ですか？", "火力"], ["日本の電力構成で、2022年時点で2番目に割合が高いのは何ですか？", "原子力"], ["再生可能エネルギーとは、どのようなエネルギーのことですか？", "枯渇の心配がないエネルギー"], ["再生可能エネルギーの例を3つ挙げてください。", "風力発電、太陽光発電、地熱発電"], ["カーボンニュートラルとしての利用が進んでいるバイオマスエネルギーの原料の例を3つ挙げてください", "トウモロコシ、サトウキビ、木くず"], ["風力発電は、何が高いので新エネルギーの中で最も発電量が多いですか？", "エネルギー変換効率"], ["太陽光発電は、何が多い地域で有利ですか？", "日射量"], ["2021年時点で、日本の発電電力量が最も多い発電方法は何ですか？", "LNG火力"], ["2011年以降、原子力発電の割合はどのように変化しましたか？", "大幅に減少"], ["日本の火力発電の燃料消費量が最も多いのは何ですか？", "LNG"], ["図6で、日本の家庭用エネルギー消費の内訳で、最も割合が高いのは何ですか？", "電気"], ["新エネルギーによる発電で、風力発電（設備容量ベース、2022年）は、どこの国で盛んですか（3つ）", "中国、アメリカ合衆国、ドイツ"]];break;
  case "エネルギーと鉱山資源8" :item =[["産業革命以降、工業化が進むと何の需要が高まりましたか？", "鉱産資源"], ["鉄鉱石は、何という産業を支える最も重要な金属資源になっていますか？", "鉄鋼業"], ["鉄鉱石の生産量が最も多い国はどこですか？", "オーストラリア"], ["鉄鉱石の生産量上位3か国を答えてください。", "オーストラリア、ブラジル、中国"], ["銅鉱は、何として重要ですか？", "金属資源、電気伝導性が高いため電線の材料"], ["銅鉱の生産量が最も多い国はどこですか？", "チリ"], ["銅鉱の生産量上位3か国を答えてください。", "チリ、ペルー、中国"], ["アフリカ大陸で銅鉱が産出する地域として、コンゴ民主共和国と、もう一つはどこですか？", "ザンビア"], ["ボーキサイトは何の原料ですか？", "アルミニウム"], ["ボーキサイトの生産量が最も多い国はどこですか？", "オーストラリア"], ["ボーキサイトの生産量上位3か国を答えてください。", "オーストラリア、中国、ギニア"], ["レアメタルとは何ですか？", "先端技術産業で利用される希少金属"], ["中国の生産量が一位の鉱産資源を３つ答えてください","すず鉱、金鉱、タングステン鉱"]];break;
  case "工業" :item =[["工業(Industry)とは何か？","さまざまな製品を手にいれることができるようにするもの"],["世界で最初の工業は何か？","家内制手工業"],["18世紀後半に何が起きたか？","イギリスで紡績機械や蒸気機関の発明などの技術革新による産業革命"],["産業革命はどこで起きたか？","イギリス"],["当初は何工業が発達したか？","綿工業などの軽工業"],["第二次世界大戦後はどこの国が工業の中心となったか？","アメリカ合衆国、ドイツ、日本などの先進国"],["1970年代の石油危機以降、先進工業国で何が停滞したか？","重工業"],["1970年代の石油危機以降、先進工業国で何の産業が中心になったか？","エレクトロニクス産業など知識集約型工業"],["現在、何が進歩により工業も大きく変わろうとしているか？","ICT(情報通信技術)"],["第二次世界大戦後、発展途上国の一部で何が進んだか？","工業化"],["NIESとは何か？","新興工業経済地域"],["NIESにはどんな国・地域が含まれるか？","韓国、シンガポール、台湾、ブラジル、メキシコなど"]];break;
  case "工業2" :item =[["BRICsとは何か？", "ブラジル、ロシア、インド、中国の4カ国の総称"], ["発展途上国が工業を発展させる最初の段階は？", "国産化"], ["輸入代替型工業とは？", "これまで輸入に頼っていた製品を自国生産して、国内で販売すること"], ["輸出指向型工業とは？", "安くて優秀な輸出用製品を製造できる国の安い労働力で、輸出品を生産すること"], ["「世界の工場」と呼ばれるようになった国は？", "中国"], ["工業立地で重要視されるコストは？", "生産費(輸送費と労働費)"], ["工業立地論を最初に考えたのは誰？", "ドイツのウェーバー"], ["原料指向型工業とは？", "原料の重量が大きく、製品の重量が小さい工業"], ["労働力指向型工業とは？", "安価な労働力、または高度な技術を持つ労働力への依存度が大きい工業"], ["市場指向型工業とは？", "製品の重量が大きくなったり、豊富な情報に依存するため、大市場付近に立地する工業"], ["臨海指向型工業とは？", "輸入原料に依存するため、海上輸送に有利な臨海部に立地する工業"],["産業革命後、蒸気機関は何を燃料として利用していた？","石炭"]];break;
  case "工業3" :item =[["産業革命はいつ始まったか？", "18世紀後半"], ["産業革命はどこで始まったか？", "イギリス"], ["フォードシステムとは何か？", "大量生産方式"], ["輸出加工区とは何か？", "外国企業を誘致するため、各種の税金を免除するなど優遇措置をとる地域"], ["中国の経済特区はどこか？", "シェンチェン、チューハイ、アモイ、スワトウ、ハイナン島"], ["工業の集積と分散とは？", "工場は有利な立地条件を備えた特定地域に集積し、工業地域を形成すること"], ["BRICSとは？", "ブラジル、ロシア、インド、中国の頭文字を用いた新語"], ["2024年からBRICSに加わることが検討中とした国は？", "アルゼンチン、エジプト、エチオピア、イラン、サウジアラビア、アラブ首長国連邦"], ["繊維工業とは？", "衣服類などを生産する工業"], ["発展途上国の工業化の初期段階で重要な工業は？", "繊維工業"], ["綿工業で労働力を必要とするのは？", "安価で豊富な労働力"], ["化学繊維の生産一位は？", "中国"], ["羊毛の生産が世界最大級の国は？", "オーストラリア"], ["羊毛の輸出一位は？", "オーストラリア"]];break;
  case "工業4" :item =[["鉄鋼業で必要なものは？", "鉄鉱石と石炭"], ["鉄鉱石の中から何を取り出す？", "金属の鉄"], ["鉄鉱石と石炭から何を作る？", "コークス"], ["取り出した鉄を何というか？", "銑鉄(iron)"], ["銑鉄から不純物を除去したものを何というか？", "鋼鉄(steel)"], ["銑鉄、鋼鉄、圧延までを連続して行える工場は？", "製鉄一貫工場"], ["鉄鉱石の主な産地は？", "ルール炭田"], ["鉄鋼業の立地で多いのは？", "臨海立地"], ["鉄鋼業に必要なものは？", "広い敷地や大規模な装置のための巨額な資本と技術"], ["鉄鋼業が発達していた国は？", "アメリカ合衆国やドイツ、フランス、イギリス、日本"], ["粗鋼生産量が一位の国は？", "中国"], ["20世紀の初め、1トンの鉄を作るのに必要な石炭と鉄鉱石の量は？", "約4トンの石炭と約2トンの鉄鉱石"]];break;;
  case "工業5" :item =[["「粗鋼(crude steel)」の「粗」は何を意味するか？", "鉄鋼などの鋼材とは違うから"], ["アルミニウムは何に使われる？", "航空機、自動車など"], ["アルミニウム1トンを生産するのに必要なボーキサイトの量は？", "約4トン"], ["アルミニウムはどのような立地で作られる？", "電力指向型"], ["アルミニウム生産の上位国に共通する点は？", "電力費が安い"], ["アルミニウム生産の上位5カ国は？", "中国、ロシア、アメリカ合衆国、オーストラリア、"], ["日本は何を輸入している？", "アルミニウム地金や合金"], ["ボーキサイトの主な産出国は？", "中国、オーストラリア、ロシア"], ["機械工業で、研究・開発部門はどこがリードしている？", "先進国"], ["電気機械工業で、量産部門はどこが伸びている？", "安価で豊富な労働力をもつ発展途上国"], ["パーソナルコンピュータ(PC)の生産一位は？", "中国"], ["ハードディスクドライブ(2014年)の生産一位は？", "タイ"], ["携帯電話の生産一位は？", "中国"]];break;
  case "工業6" :item =[["自動車は何の工業の代表？", "総合組立工業"], ["総合組立工業で必要なものは？", "巨額な資本と高度な技術"], ["組立工場の周辺には何が必要？", "下請工場や関連企業"], ["自動車はどこで発明された？", "ヨーロッパ"], ["モータリゼーションが最初に進んだのは？", "アメリカ合衆国"], ["1980年代から急成長した日本の基幹産業は？", "自動車産業"], ["最近、自動車産業で成長が著しいのは？", "中国、インド、メキシコ、ブラジル、タイ"], ["自動車の輸出が多い国は？", "日本、ドイツ、"], ["2009年、自動車の生産で世界最大の国は？", "中国"], ["EVとは？", "電気自動車"], ["集積回路(IC)やコンピュータなどの開発で重要な部門は？", "研究開発部門"], ["自動車の生産、一位の国は？", "中国"], ["1990年自動車の生産、一位の国は？", "アメリカ"]];break;
  case "工業7" :item =[ ["量産部門で安価で良質な労働力があるのは？", "NIESやASEAN, 中国, インド"], ["パーソナルコンピュータの生産台数が多い国は？", "中国"], ["ICTとは？", "情報通信技術"], ["アメリカでエレクトロニクス産業の集積地は？", "シリコンバレー"], ["日本ではどこでエレクトロニクス産業が発達？", "シリコンアイランド(九州)"], ["エレクトロニクス製品の特徴は？", "軽量で高付加価値"], ["造船竣工量一位は？", "中国"], ["GDPに占める研究開発費の割合が高い国は？", "韓国"], ["石油化学工業の立地は？", "石油産出地や輸入港付近"], ["造船工業一位は？", "中国"], ["航空機工業が盛んな国は？", "アメリカ合衆国"], ["製紙・パルプ工業で必要なものは？", "大量に処理用水"], ["セメント工業の原料は？", "石灰石"]];break;;
  case "地域開発と環境問題" :item =[["近代化が進み、地域活性化に大きく貢献したのは？", "アルミニウム工業や原子力工業"], ["世界の河川総合開発で、何を確認しておく？", "河川の位置と、何のために行われた地域開発なのか"], ["テネシー川流域開発、どこの国？", "アメリカ合衆国"], ["テネシー川流域開発、何のため？", "世界恐慌に伴う景気・失業対策と地域経済活性化"], ["TVAとは？", "テネシー川流域開発公社"], ["コロラド川、どこの国？", "アメリカ合衆国"], ["コロンビア川、どこの国？", "アメリカ合衆国"], ["ダモダル川、どこの国？", "インド"], ["黄河、どこの国？", "中国"], ["長江、どこの国？", "中国"], ["ナイル川、どこの国？", "エジプト"], ["ヴォルタ川、どこの国？", "ガーナ"], ["ザンベジ川、どこの国？", "ザンビア〜ジンバブエ"], ["河川総合開発には、どんな側面もある？", "マイナスの側面"],  ["エジプトは何気候？", "砂漠気候(BW)"], ["1971年にエジプトは何を完成させた？", "アスワンハイダム"], ["アスワンハイダムは何を可能にした？", "洪水の防止だけでなく、年間を通じた灌漑"], ["河川総合開発は、何を目的に？", "多目的ダムの建設により、電力や用水の供給"], ["大規模な開発は、何の一因となっている？", "環境の破壊や災害"]];break;;
  case "地域開発と環境問題2" :item =[["環境問題とは何か？", "人間が生活を豊かにするために様々な経済活動を行った代償として地球環境に大きな負担をかけてきたこと"],  ["先進国では何が大量に消費されているか？", "原料やエネルギー資源"], ["1967年に制定された法律は何か？", "公害対策基本法"], ["水俣病の原因物質は？", "有機水銀"], ["イタイイタイ病の原因物質は？", "カドミウム"], ["生活排水による湖沼の環境破壊は何か？", "富栄養化"], ["酸性雨のpHの定義は？", "5.6以下"], ["ヨーロッパで酸性雨の被害が大きい地域はどこか？（国名）", "スカンジナビア半島南部、ドイツ、チェコ、ポーランドなど"], ["偏西風は何の運搬に関係するか？", "汚染物質"], ["酸性雨の原因物質を多く含む物質は？", "石炭"]];break;
  case "地域開発と環境問題3" :item =[["中国も酸性雨に苦しんでいる原因は？", "石炭を大量消費するため硫黄酸化物の排出が多い"], ["日本の気象庁を中心に行われていることは？", "酸性雨の観測"], ["硫黄酸化物の排出を減らすための装置は？", "脱硫排煙装置"], ["自動車の排ガスに含まれる汚染物質は？", "窒素酸化物"], ["酸性雨が発生する仕組みで、工場などから排出されるものは？", "硫黄酸化物"],["フロンは何に使われてきた？", "クーラーの冷媒、スプレーの噴射剤、半導体の洗浄剤"], ["オゾン層の役割は？", "紫外線を吸収する"], ["オゾンホールが最初に観測されたのは？", "南極"], ["モントリオール議定書で原則禁止されたものは？", "フロンの製造と輸出"], ["21世紀に入り何が確認されている？", "オゾンホールの縮小"], ["発展途上国で深刻な問題は？", "人口増加に伴う環境破壊"], ["先進国で沈静化しているが、発展途上国で深刻な公害は？", "大気汚染"], ["熱帯林の破壊の原因は？", "焼畑の拡大や薪炭の過伐採"], ["東南アジアで行われていることは？", "油ヤシなどのプランテーション"]];break;
  case "地域開発と環境問題4" :item =[["2005年から2010年にかけて、森林面積が純増した国は？", "中国"], ["日本の沿岸部で進んでいることは？", "エビ養殖池の造成"], ["ブラジルのアマゾン地方で大規模な何が進んでいる？", "鉱山・道路開発や外国企業などの牧場経営"], ["熱帯林の破壊は何に影響を与えるか？", "地球温暖化や砂漠化"], ["砂漠化とは、砂漠のような何もない土地になってしまうことか？", "不毛の地"], ["砂漠化の原因となる気候は？", "BW(砂漠気候)"], ["砂漠化は、局地的な何の影響もあるか？", "降水量の減少"], ["発展途上地域では何によって過放牧が行われるか？", "人口増加"], ["過放牧で家畜は何を根こそぎ食べてしまうか？", "牧草"], ["サヘル地方は何の南縁地域か？", "サハラ砂漠"], ["砂漠化はどこで起きているか？", "発展途上国と先進国"], ["アメリカ合衆国やオーストラリアで何が行われているため塩害が発生しているか？", "大規模な灌漑農業"], ["砂漠化が進んでいる地域の特徴は？", "半乾燥地域(BS)"], ["地球の人口は増えているのに、砂漠化が進んでいるのは何が拡大しているから？", "生活できない地域"]];break;;
  case "地域開発と環境問題5" :item =[["地球温暖化の原因となるのは？", "温室効果ガスの増加"], ["温室効果ガスには何があるか？", "二酸化炭素、メタン、フロン、一酸化窒素、水蒸気"], ["温室効果ガスがないと地表の温度はどうなる？", "-20℃くらいになる"], ["現在、最も増加が心配されている温室効果ガスは？", "二酸化炭素"], ["産業革命以降、何を大量に消費するようになった？", "石炭、石油、天然ガス"], ["大気中の二酸化炭素が増加すると何が上昇する？", "気温"], ["海面上昇に加えて何が起こるとされている？", "熱膨張"], ["海面上昇により水没の危険性が出てくる島は？", "サンゴ礁島(キリバスやモルディブなど)や三角州(ガンジスデルタなど)"], ["北極海で何が減少している？", "海氷"], ["2020年の二酸化炭素排出量1位の国は？", "中国"], ["1997年に採択されたものは？", "京都議定書"], ["先進国も足並みがそろっているわけではない、その理由は？", "京都議定書から離脱した国がいるため"], ["自動車の排ガスに含まれる窒素酸化物は何を引き起こす？", "光化学スモッグ"], ["近年、中国からの汚染物質流入によりどこで光化学スモッグが発生している？", "西日本"]];break;;
  case "地域開発と環境問題6" :item =[["アグロフォレストリーとは何か？", "農業と林業の複合経営"], ["アグロフォレストリーはどこで行われているか？", "東南アジアなどの熱帯地域"], ["アグロフォレストリーで間作される作物は？", "樹木"], ["地球温暖化の主な原因物質は？", "化石燃料の大量消費による温室効果ガス(CO₂、メタン、フロン)の増加"], ["酸性雨の主な原因物質は？", "工場や自動車から排出される硫黄酸化物・窒素酸化物の増加"], ["森林破壊の主な原因は？", "人口爆発による薪炭材の過剰な伐採、原木輸出、焼畑面積の拡大、道路・ダム建設、放牧地の開発"], ["オゾン層破壊の主な原因物質は？", "クーラー、冷蔵庫、スプレーなどに使用されていたフロンガス"], ["砂漠化の主な原因は？", "自然的要因(気候変動による降水量減少)と人為的要因(人口増加に伴う過放牧、耕地の塩性化)"], ["1972年に開催された国際会議は？", "国連人間環境会議"], ["1992年に開催された国際会議は？", "地球サミット"], ["2002年に開催された国際会議は？", "環境・開発サミット"], ["2012年に開催された国際会議は？", "国連持続可能な開発会議(リオ+20)"], ["地球温暖化の影響で、何が融解している？", "氷河・氷雪"], ["地球温暖化で、何が上昇している？", "海水面"], ["メタンはどこから排出される？", "湿地、水田、家畜の糞"], ["京都議定書が採択されたのはいつ？", "1997年"], ["京都議定書で何が設定された？", "先進国全体の温室効果ガス削減目標値"], ["パリ協定が採択されたのはいつ？", "2015年"]];break;;
  case "人口" :item =[["ブルネイで示している、ドイツやイギリスなどの工業地域から越境汚染の説明で、スウェーデンやフィンランドなどの北欧諸国では深刻な被害が生じたものは何か？","酸性雨"],["インドでは、家畜の糞尿を肥料にして何を行っているか？","耕作"],["マレーシアで伐採し、エビの養殖池に転換しているものは何か？","マングローブ林"],["日本で、循環型社会形成推進基本法に基づき、希少で偏在性が高いレアメタルを、電子機器などから回収し、再資源化する努力が行われており、これは何と呼ばれているか？","都市鉱山(urban mine)"],["アメリカ合衆国では、ペットボトルを返却すると一部返金される制度を導入している州もある。これを何というか？","リサイクルデポジット制度"],["日本のペットボトルの回収率は？","96.7%"],["日本のペットボトルのリサイクル率は？","88.5%"],["人口分布で、世界の人口分布を何で表したものか?","人口密度"],["現在、世界にはどれくらいの人がいるか？","約80億人(2022年)"],["日本には約何人の人がいるか？","約1億2,500万人(2022年)"],["熱帯雨林の破壊に関する説明で、カリマンタン島では輸出用の木材伐採、焼畑や油ヤシの何が拡大などが要因となっているか","プランテーション"],["長江に建設されているサンシャダムとその影響に関する説明で、周辺地域の水没や流域の何への影響が危惧されているか","生態系"]];break;
  case "人口2" :item =[["人口密度が高い地域として、3か所特に人口密度が高い地域はどこか？","西ヨーロッパ、モンスーンアジア、アメリカ合衆国北東部"],["モンスーンアジアは、恵まれた地形、気候、土壌を利用して何が可能で生産性が高く、米は熱量も大きいから何が高い地域だったか？","稲作(連作が可能)","人口支持力"],["アメリカ合衆国北東部は何が発達している地域か？","世界的な商工業地域（アメリカンメガロポリス）"],["人口密度が最も高い主な国はどこか？","バングラデシュ"],["人口密度が最も低い主な国はどこか？","モンゴル"],["モナコは何人/km2か？","18,235人/km2"],["シンガポールは何人/km2か？","8,202人/km2"],["モンゴル、オーストラリア、リビアなどの乾燥地域を含む国やどこなどの高緯度の寒冷な国で人口密度が低いことがわかる？","カナダ"],["人口が1億人以上の国々で、1位はどこか？","インド"],["人口が1億人以上の国々で、2位はどこか？","中国"],["人口が1億人以上の国々で、日本は何位か？","12位"],["エクメーネとアネクメーネ、人間が日常的に居住・活動している地域を何というか？","エクメーネ"],["エクメーネとアネクメーネ、人間が日常的に居住・活動していない地域を何というか？","アネクメーネ"],["現在、陸地の約何%がエクメーネになっているか。","約90％"]];break;;
  case "人口3" :item =[["世界の総人口は1650年ごろには約何億人で、現在の日本の総人口の約4倍もしかなかった？","約5億人"],["1987年には何億人を超え、現在は約80億人(2022年)？","50億人"],["特に第二次世界大戦後の発展途上地域における何の影響は大きい？","人口爆発"],["世界の人口の推移で、何が始まるまでは、ほぼ横ばいになっているか？","産業革命"],["人口増加には何増加と社会増加があるか？","自然増加"],["自然増加率は何から死亡率を引いたもの？","出生率"],["社会増加率は何から転出率を引いたもの？","転入率"],["人口増加は、自然増加と何を足し合わせたもの？","社会増加"],["世界の年平均人口増加率（2010～2015年）は11.8‰。これを上回っているのはどこか？","発展途上国が多いアフリカ"],["世界の年平均人口増加率（2010～2015年）は11.8‰。これを大きく下回っているのはどこか？","先進国が多いヨーロッパ、アングロアメリカ"],["2021年の世界の人口は何人か？","7,909百万人"],["1950年は何直後で、このあたりから発展途上地域で人口が急増している？","第二次世界大戦"],["2010-2015の世界平均の自然増加率は？","11.8"],["1950-1955のアジアの出生率は？","42.0"],["2045-2050(予測)のアフリカの死亡率は？","6.5"],["先進国の日本や経済発展が進みつつある国（NIEsやASEANなど）や、何を実施してきた中国があるからだね？","一人っ子政策（1979～2015年）"]];break;
  case "人口4" :item =[["先進地域で出生率が高くなっている要因の一つは何か？","移民の流入"],["死亡率が高い地域はどこか？","アフリカとヨーロッパ"],["乳児死亡率が高いのはなぜか？","経済発展の遅れ、医療の普及の遅れ、栄養状態の悪さ"],["ヨーロッパで高齢者死亡率が高いのはなぜか？","高齢化の進行"],["自然増加率が低い地域はどこか？","先進地域"],["自然増加率が高い地域はどこか？","アフリカ、ラテンアメリカ"],["人口増加の3つのタイプとは何か？","多産多死、多産少死、少産少死"],["近代以前の人口増加タイプは何か？","多産多死"],["人口爆発とは何か？","出生率は高いまま、死亡率だけが低下する現象"],["現在の発展途上国の人口増加タイプは何か？","多産少死"],["ドイツやイタリアで人口が急激に減少した年はいつか？","2010年代"],["バルト三国などで人口が減少した要因は何か？","社会不安や経済停滞"]];break;;
  case "人口5" :item =[["人口ピラミッドとは何か？","男女別、年齢別の人口構成を表すグラフ"],["人口転換による変化で、人口ピラミッドの形はどう変化するか？","富士山型から釣鐘型、つぼ型へ"],["エチオピアの人口ピラミッドは何型か？","富士山型"],["アメリカ合衆国の人口ピラミッドは何型か？","釣鐘型"],["先進国の人口ピラミッドは何型が多いか？","釣鐘型やつぼ型"],["発展途上国の人口ピラミッドは何型が多いか？","富士山型"],["第1次産業とは何か？","農林水産業"],["第2次産業とは何か？","鉱工業・建設業"],["第3次産業とは何か？","商業・サービス業、運輸・通信業、観光、金融・教育・医療・公務など"],["先進国で就業人口の割合が高いのは第何次産業か？","第3次産業"],["アメリカ合衆国とイギリスで進んでいることは何か？","脱工業化・サービス経済化"],["韓国やブラジルは何と呼ばれているか？","NIEs"],["発展途上国で、第1次産業の割合が高い国はどこか？","中国、インド"],["経済発展が遅れている東アフリカの国はどこか？","タンザニアやサヘル"]];break;;
  case "人口6" :item =[["15世紀末の何以降、人口移動が盛んになったか？","大航海時代"],["ヨーロッパから新大陸への移動例として、何系の人々がどこへ移動したか？","ラテン系のスペイン人、ポルトガル人の中南米（ラテンアメリカ）へ移動、アングロサクソン系のイギリス人の北米（アングロアメリカ）への移動"],["アジアではどこの国の人々が世界各地に移住しているか？","中国人とインド人"],["中国で、誰が東南アジアを中心に出稼ぎに行ったか？","華南の貧しい農民"],["中国の社会主義革命後、現地の国籍を取得する人も多く、何と呼ばれているか？","華人"],["インド人がイギリス領だった時代に、他のイギリス植民地(どこ)へ、何として渡った人が多いか？","マレーシア、フィジー、ケニアなどの東アフリカ、ガイアナに契約労働者"],["アフリカ系黒人はどのようにアメリカ大陸へ移住させられたか？","自発的ではなく強制的に奴隷として"],["1960年代に、どこへ多くの労働力が流入したか？","アメリカ合衆国やヨーロッパ"],["1970年代の何によって、どこへ労働力が流入したか？","石油危機、中東の産油国"],["1990年代に、日本では何が改正され、何人(かつて何)の就労が認められるようになったか？","出入国管理法、日系人、他国へ移民した人の子孫"],["どこの国から、研修生・技能実習生として日本企業が受け入れるようになったか？","中国、ベトナム、フィリピン"],["発展途上国の人口問題は何による雇用機会の不足と食料不足が大きいか？","人口爆発"],["先進国の主な産業で、人口の約何%が職を持っているか？","60%"]];break;
  case "人口7" :item =[["人口増加に追いつかない状態になっているものは何か？","経済の発展や食料生産"],["貧困を解決するためには何が必要か？","教育水準を向上させ、貧困をなくすこと"],["人口抑制策は何のために必要か？","女性の地位や権利の向上のため"],["日本をはじめとする先進国は何という問題に直面しているか？","高齢化と少子化"],["高齢者の割合が急増すると何が不足するか？","労働力"],["高齢化に対応するために必要なことは何か？","出産奨励や十分な育児休暇や育児施設の完備、退職後の再雇用"],["社会保障制度の充実した国はどこか？","北欧諸国(スウェーデンやデンマークなど)"],["第二次世界大戦後、急速に高齢化が進んだ国はどこか？","日本"],["合計特殊出生率とは何か？","1人の女性が平均して何人の子どもを産むかを示す数値"],["人口を維持するために必要な合計特殊出生率はいくつか？","2.1以上"],["M字曲線とは何か？","女性が出産・育児によって一旦離職し、子育てが落ち着くと再び社会復帰している様子"],["合計特殊出生率が特に低い国はどこか？","日本"],["合計特殊出生率が比較的高い先進国はどこか?","アメリカ合衆国, フランス, 北欧諸国"]];break;
  case "人口8" :item =[["2023年の日本の合計特殊出生率はいくらか？","1.20"],["高齢化社会とは、総人口に占める何歳以上の割合が何%を超える社会か？","65歳以上、7%"],["高齢化率が何%を超えると高齢社会(Aged Society)というか？","14%"],["近年、高齢化率は何%を超える「何社会」と呼ばれるようになっているか？","21%, 超高齢社会(Super-aged society)"],["人口ピラミッドは何を表すことができるか？","その国の経済発展のレベルや人口増減の状況"],["産業別人口構成は、先進国では第何次産業人口割合が小さいか？","第1次産業"],["産業別人口構成は、経済の発展とともに第何次産業に移行していくか？","第2次、第3次産業"],["発展途上国では何による人口増加に何が追いつかないため、生活水準が低下するなどの問題が生じているか？","「人口爆発」、経済発展"],["先進国では、何が進展し、労働力不足や福祉負担が増大するなどの問題が生じているか？","高齢化、少子化"]];break;;
  case "村落と都市" :item =[["人間が共同の社会生活を営んでいる場所のことを何というか？","集落"],["集落は、何によって分類されるか？","経済"],["第1次産業が経済を支えている集落を何というか？","村落"],["第2次・第3次産業が経済を支えている集落を何というか？","都市"],["村落で農業を行うために必要なものは何か？","水"],["日本やヨーロッパの村落で、古くから何が行われていたか？","農業"],["村落で、住民相互の結びつきが強い集落形態は何か？","集村"],["集村で家屋が密集した村落形態は何か？","塊村"],["道路に沿って家屋が並んだ集落を何というか？","路村"],["道路以外の要因で列状に並んだ集落を何というか？","列村"],["主要街道沿いに発達した集落を何というか？","街村"],["集会や市場に利用される広場を中心に家屋が環状に並んだ集落を何というか？","円村"],["散村とは何か？","一戸または数戸の農家が散在している集落"],["アメリカ合衆国のタウンシップ制にもとづく村落は何というか？","散村"],["日本の村落で条里制に基づく集落と何か？","新田集落"]];break;;
  case "村落と都市2" :item =[["世界の伝統的な家屋は何に適応するように作られているか？","気候などの自然条件"],["高温多湿な地域では、家屋はどのような造りになっていることが多いか？","通気性をよくするために開放的な造り"],["熱帯雨林などでは、何から身を守ったり、水害から逃れるために家屋をどうしているか？","害獣、高床式"],["熱帯で、家屋の建築材料は何を多く利用しているか？","木や葉、草"],["シベリアなど寒冷な地域では、何を防ぐために何を利用して何造の家屋が作られているか？","外気を遮断し保温する、木造住宅、"],["シベリアなどの寒冷な地域では、出入り口のドアや窓はどんな大きさか？","小さい"],["西アジアや北アフリカの乾燥地域では、何のために出入り口を小さくしているか？","日中の気温が高くなるため、強い日射や外気を遮断するため"],["西アジアや北アフリカの乾燥地域で、窓はどのようなものが多いか？","小さいか、まったくない"],["西アジアや北アフリカの乾燥地域では、何などを建築材料として利用してきたか？","石、日干しレンガ、泥"],["伝統的家屋で急傾斜の屋根の場合、何が多い地域と考えられるか？","降水量や降雪量"],["伝統的家屋で平屋根の場合、何が少ない地域と考えられるか？","降水量"],["タウンシップ制と屯田兵村はいつどこで行われた公有地分割制度か？","18世紀後半から19世紀にかけてアメリカ合衆国やカナダ"],["タウンシップ制で、1区画約何haの土地に何が入植し、農業開拓を行ったか？","約64ha、一家族"],["屯田兵村は何を規範とし、何時代に何を目的に建設されたか？","タウンシップを模範、明治時代、北海道の開拓、防備、士族授産"],["古代の都市は主に何などを担っていたか？","政治、宗教、軍事的な役割"],["中世になると何が発達し、何革命後に本格的な都市化が進んでいったか？","商業都市、産業革命"],["日本では古代、何が政治の中心として発達したか？","平城京、平安京"],["中世には何などの城下町が現在の都市の起源となっていることが多いか？","鎌倉、室町、江戸"],["メトロポリスでは何が集積し、何が大きくなっているか？","生産、流通、消費に関する施設や情報、中心地機能"],["大都市圏を形成するようになっている日本の都市は？","東京大都市圏、大阪大都市圏、名古屋大都市圏"],["政治都市の例は？","キャンベラ(オーストラリア)、ブラジリア(ブラジル)、アブジャ(ナイジェリア)、オタワ(カナダ)、デリー(インド)"],["宗教都市の例は？","メッカ(サウジアラビア)、エルサレム(イスラエル)、ヴァラナシ(インド)"],["学術都市の例は？","オックスフォード(イギリス)、ハイデルベルク(ドイツ)、つくば(茨城)"],["観光・保養都市の例は？","ニース、カンヌ(フランス)、マイアミ、ラスベガス(アメリカ合衆国)"]];break;;
  case "村落と都市3" :item =[["コナベーションとは何か？","複数の都市が、都市の規模に関係なく、市街地が連続して一体の都市地域となること"],["メトロポリスとは何か？","大都市圏のこと"],["メガロポリスとは何か？","複数のメトロポリスや周辺都市が帯状に連なり、交通・通信網で結ばれた都市化地域"],["中心業務地区(CBD)とは何か？","行政機関や企業の本社などが立地する地区"],["東海道メガロポリスに含まれる都市は？","東京、川崎、横浜、静岡、浜松、名古屋、京都、大阪、神戸など"],["スプロール現象とは何か？","郊外への無秩序な開発"],["都市の形態で、放射環状型の例は？","パリ、モスクワ"],["都市の形態で、迷路型の例は？","テヘラン、ダマスカス"],["日本の城下町に多い都市の形態は？","迷路型"],["門前町の例は？","長野（善光寺）、成田（新勝寺）"],["城郭都市の例は？","ドイツのネルトリンゲン"],["市街化区域とは何か？","都市計画法による都市計画地域のうち、現在すでに市街化されている地域、または今後優先的に市街化を図ることを認められている地域"],["市街化調整区域とは何か？","都市計画法による都市計画地域のうち、郊外への無秩序な開発（スプロール現象）を防ぐために、開発が抑制されている地域"],["ロンドンのグリーンベルトは何に当たるか？","市街化調整区域"]];break;;
  case "村落と都市4" :item =[["先進国で都市化が始まったのはいつか？","産業革命以降"],["都市化(Urbanization)とは何か？","人口が都市に集中し、都市的地域が拡大していく現象"],["先進国でインナーシティ問題が発生した原因は？","富裕層が郊外へ移動し、都心部にスラムが形成されたため"],["郊外化(Suburbanization)とは何か？", "人口が都市の中心部から周辺部へと移動する現象"],["大ロンドン計画とは何か？","イギリスが世界に先駆けて実施した過密化対策"],["ニュータウンとは何か？","大都市の過密化問題を解消するために、大都市周辺に新たに建設された都市"],["大ロンドン計画でニュータウンはどこに建設されたか？","ロンドンの周りを囲むグリーンベルトの外側"],["ドックランズとは何か？","ロンドンの港湾施設として栄えたが、産業構造の転換により衰退した地区"],["ウォーターフロントの再開発とは何か？","港湾や倉庫の跡地に、オフィスビル、マンション、ホテル、レジャー施設などを建設し、活性化を図る開発"],["イギリスのニュータウンやウォーターフロントの再開発は何のモデルとなったか？","日本など他の先進国の再開発"],["都市再開発の二つの手法とは？","クリアランス型と修復保全型"],["クリアランス型とは何か？","スラムなどの不良住宅地区をすべて撤去し、その跡地に高層ビルなどを建設する手法"],["修復保全型とは何か？","歴史的な建造物や街並みを残しつつ、できる限り古い住宅や建物を修復し、保全していく手法"],["ヨーロッパの都市に多い再開発の手法は？","修復保全型（歴史的景観を重視するため、都心部などにおける高層ビルの建設を制限）"],["アメリカ合衆国や日本の大都市に比べて、高層ビルが少ないヨーロッパの都市が多い理由は？","歴史的景観を重視し、修復保全型の再開発を重視しているため"]];break;;
  case "村落と都市5" :item =[["パリのラ・デファンス地区は何の中心に建設されたか？","ビジネスセンター"],["パリ都市圏にはフランスの総人口の約何%が居住しているか？","約20%"],["パリ都市圏にはフランスの企業本社の約何%が集中しているか？","約50%"],["パリの市内には高層ビルが少ない理由は？","都市計画によって建築物の高さや美観上の規制があるため"],["パリのラ・デファンス地区では何が行われたか？","超高層のオフィスビル、大規模なショッピングセンター、近代的⾼層住宅などを備える副都⼼建設"],["日本のニュータウン建設で、職住近接型でないニュータウンの例は？","多摩ニュータウンや大阪府の千里ニュータウン"],["日本で多くのニュータウンが大都市の郊外を中心に建設されたのはいつ？","1950年代の後半"],["オールドタウンとは何か？","同じような世代の人々がいっせいに入居してすでに50年以上が経過し、建物も街もみんなそろって歳をとったニュータウン"],["横浜のみなとみらい21(MM21)は何の代表的な例か？","ウォーターフロントの再開発"],["北海道の小樽や函館は何の代表的な例か？","クリアランス型の再開発"],["環境共生都市(エコシティ)とは何か？","環境に配慮した都市整備や都市再開発"],["環境共生都市(エコシティ)の取り組みが行われている都市の例は？","船橋市、横浜市、大阪市、北九州市など"],["発展途上国で農村で起こっていることは？","人口爆発"],["push型の都市化要因とは何か？","農村での余剰労働力により、人々が都市へ押し出されること"],["プライメートシティとは何か？","特定の都市に人口や都市機能が集中し、他都市を圧倒している都市"],["プライメートシティの例は？","バンコク(タイ)、ジャカルタ(インドネシア)、リマ(ペルー)、サンティアゴ(チリ)、ブエノスアイレス(アルゼンチン)"],["バラックとは何か？","プライメートシティでさえ雇用能力はあまり大きくないため、収入を得られない人々が都市郊外の未利用地(山麓や河川の後背湿地など)に形成する不良住宅地区"]];break;
  case "村落と都市6" :item =[["スラム(squatter)とは何か？","都市郊外の未利用地を不法占拠して形成された不良住宅地区"],["先進国のスラムはどこに形成されることが多いか？","インナーシティ"],["発展途上国のスラムはどこに拡大していく傾向が強いか？","都市郊外"],["日本のニュータウンは、職住○○型の住宅衛星都市が多い。○○は？","分離"],["都市人口率とは何か？","総人口に占める都市居住者の割合"],["発展途上国でプライメートシティへの集中度が高い理由は？","その都市でなければ十分な雇用機会が得られないため"],["日本の都市人口率は？","92.0%"],["タイの都市人口率は？","52.9%"],["ラ・デファンス地区はパリの中心から西へ約何kmの位置にあるか？","約4km"],["ラ・デファンス地区の再開発の目的は？","パリの都心機能を分担し、過密化が進むパリの都心機能を分散させること"],["マレ地区ではどのような再開発が行われたか？","老朽化した建造物や街並みの修復・保全事業"],["ジェントリフィケーション(gentrification)とは何か？","インナーシティ地区やスラム化した街区を再開発により高級化した場合、低所得層が流出し、富裕層が流入する現象"],["ジェントリフィケーションの代表的な例は？","アメリカ合衆国のハーレム(ニューヨーク)などのスラム再開発"],["pull型の都市化とは何か？","雇用能力の大きい都市が周辺の農村から人口を吸引する都市化"],["push型の都市化とは何か？","農村で人口が急増し、押し出された人々が都市へ流入する都市化"]];break;;
  case "交通と通信" :item =[["交通・通信の発達によって何が短縮されたか？","時間距離"],["産業革命後、何が発明されたか？","蒸気機関車や蒸気船"],["20世紀に入って何が進展したか？","モータリゼーション"],["1970年代から何が発達したか？","高速ジェット機時代"],["私たちが日常的に利用している陸上交通は？","鉄道と自動車"],["鉄道交通の特色は？","高速・大量輸送に向いていることと、定時性にすぐれること"],["19世紀に実用化が始まった鉄道はどこで著しく発展したか？","ヨーロッパ、アメリカ合衆国、日本など"],["鉄道の敷設に大きな資本が必要な地域は？","先進国"],["鉄道が発達しにくい発展途上国は？","アフリカやラテンアメリカ"],["自動車交通の発達に有利な地形は？","平坦地"],["戸口輸送とは何か？","自動車が出発地から目的地まで直接輸送できること"],["自動車の普及があまり進んでいない発展途上国では何が大きいか？","鉄道の役割"],["発展途上国のインドでは、何を鉄道輸送量が多い？","旅客も貨物も"],["日本では何が鉄道輸送の中心？","旅客"],["アメリカ合衆国では何が鉄道輸送の中心？","貨物"],["自動車はいつ発明された？","19世紀"],["自動車はどこで最も早くモータリゼーションが進展したか？","アメリカ合衆国"]];break;;
  case "交通と通信2" :item =[["2018年の鉄道輸送量で、旅客輸送量が最も多い国は？","中国"],["2018年の鉄道輸送量で、貨物輸送量が最も多い国は？","アメリカ合衆国"],["ロードプライシングとは何か？","入域課金制など、自動車の乗り入れ規制"],["大都市間を結ぶ新幹線や高速鉄道の例は？","TGV(フランス)、ICE(ドイツ)"],["都市近郊から都心などへの移動手段として重要性が高まっているものは？","電車、地下鉄、LRT"],["パークアンドライドとは何か？","郊外の駅付近で自動車を駐車(park)し、都市へは鉄道を利用(ride)する方法"],["モーダルシフトとは何か？","貨物輸送では自動車から鉄道や船舶への輸送手段の転換"],["日本における旅客輸送で最も割合が高い輸送機関は？(2020年)","乗用車等(90.1%)"],["日本における貨物輸送で最も割合が高い輸送機関は？(2020年)","自動車(91.8%)"],["大気汚染の原因となる自動車の排気ガスに含まれる物質は？","窒素酸化物や二酸化炭素"],["ヨーロッパやアメリカ合衆国の都市で復活や普及が進められている公共交通機関は？","LRT(路面電車など)"],["自動車の大型化・高速化が進み、高速道路が多数建設されるようになったのはいつ？","第二次世界大戦後"],["1人当たりGNIと自動車保有数の関係は？","1人当たりGNIが高いほど、自動車保有数も多い傾向にある"],["2020年の日本における国内旅客輸送で、鉄道の占める割合は？","24.7%"],["2020年の日本における国内貨物輸送で、内航海運の占める割合は？","4.7%"]];break;;
  case "交通と通信3" :item =[["2020年頃に自動車保有台数が急増している国は？","中国"],["2020年頃に自動車保有台数が最も多い国は？","アメリカ合衆国"],["高速道路は主にどこを中心に整備されているか？","先進国"],["ドイツの高速道路は？","アウトバーン"],["高速鉄道で、日本の新幹線がその先駆けしているものは？","TGV(フランス)、ICE(ドイツ)、AVE(スペイン)"],["近年、高速鉄道の敷設が進んでいる国は？","韓国(KTX)、台湾"],["LRTとは何か？","次世代型路面電車のことで、環境負荷が少なく低コストでの建設が可能なシステム"],["LRTはどこを中心に導入されているか？","ヨーロッパ"],["LRTの導入で、都心部では何と共存することが可能か？","歩行者や自動車"],["LRTの有名な例は？","ドイツのフライブルク、フランスのストラスブール、富山市"],["交通機関の発達によって何が著しく短縮されたか？","時間距離"],["鉄道交通の地位は何に対して低下しているか？","相対的に"],["大都市圏の長距離輸送の手段で再評価されているものは？","鉄道交通"],["陸上交通の中心となったが、大気汚染などが深刻化したものは？","自動車交通"],["モータリゼーションとは何か？","自動車が大衆化し、人々の生活が自動車に大きく依存するような社会になること"],["モータリゼーションは日本ではいつから進行したか？","1960年代"],["開拓鉄道で、国土が広く、開発が比較的新しい国で、国土の統一と開発に鉄道が大きく貢献した例は？","北アメリカ(カナダやアメリカ合衆国)の大陸横断鉄道)やロシア(シベリア鉄道)"]];break;;
  case "交通と通信4" :item =[["水上交通とは何か？","船舶を利用した、最も大量に安く輸送できる交通手段"],["水上交通で輸送するのに適しているものは？","資源や木材など、重いわりに安いもの"],["船舶の大型化や高速化が進み、導入されている専用船の例は？","コンテナ船、オイルタンカー、LNG専用船、自動車専用船、鉱石ばら積み船"],["商船の船腹量が最も多い国は？","パナマ"],["船種別の船腹量が最も多いのは？","ばら積み乾貨物船(42.8%)"],["海上交通で運ぶ穀物や資源を運ぶ船は？","ばら積み貨物船（バルクキャリア）"],["世界の主要航路で、タンカー、コンテナ船の占める割合が大きいのはどこを結ぶ航路？","西アジアからヨーロッパや日本、中国に向かっている帯"],["世界の主要航路で、海上貨物輸送量の約3分の1を占めるものは？","原油"],["内陸水路交通とは何か？","河川、湖沼、運河を利用した船舶交通"],["日本の河川が内陸水路交通に適していない理由は？","季節による流量変化が大きく、急流が多い"],["内陸水路交通が発達している地域の例は？","ヨーロッパやロシア、アメリカ合衆国のように平坦な地形で、流量が安定しているところ"],["ヨーロッパで、内陸水路が発達している河川は？","ライン川やドナウ川"],["アメリカ合衆国で、内陸水路が発達しているのは？","五大湖"],["アフリカで内陸水路交通があまり発達していない理由は？","高原状の大陸で、下流部には多くの滝があるため"],["アフリカで内陸水路交通がある河川は？","コンゴ川とナイル川"]];break;;
  case "交通と通信5" :item =[["航空交通はいつから発達したか？","1970年代に大型ジェット機が開発されてから"],["航空交通は何輸送で圧倒的に速いか？","長距離"],["以前は旅客輸送が中心だった航空輸送で、最近増えているものは？","軽量・小型で高付加価値(価格が高い)な電子部品や精密機械などの貨物輸送、生鮮食料品など"],["技術革新などによって、航空機の何が伸びているか？","航続距離"],["輸送機関の発達は、どこの国でもだいたい同じような状況か？","そうではなく、経済発展のレベルだけでなく、地形、気候、資源の有無など各国の事情によってかなり違いがみられる"],["日本の国内輸送における旅客輸送で、最も割合が高い輸送機関は？(2009年)","自動車(65.6%)"],["日本の国内輸送における貨物輸送で、最も割合が高い輸送機関は？(2009年)","自動車(63.9%)"],["アメリカ合衆国の国内輸送における旅客輸送で、最も割合が高い輸送機関は？(2009年)","自動車(88.4%)"],["アメリカ合衆国の国内輸送における貨物輸送で、最も割合が高い輸送機関は？(2009年)","鉄道(38.5%)"],["イギリスの国内輸送における旅客輸送で、最も割合が高い輸送機関は？(2009年)","自動車(91.0%)"],["ドイツの国内輸送における旅客輸送で、最も割合が高い輸送機関は？(2009年)","自動車(90.0%)"],["日本は国土が狭く、海に囲まれているので、国内輸送の何%以上が船舶による輸送か？","90%"],["アメリカ合衆国は、旅客輸送のほとんどが何で、残りは航空機か？","自動車"],["国土が広い国で、鉄道が貨物輸送の主役となっている国は？","アメリカ合衆国、カナダ、ロシア、中国など"],["日本の主な国内路線の旅客輸送量で、最も輸送量が多い都市は？","東京(羽田)"],["水上交通の長所は？","安価に長距離大量輸送が可能。エネルギー効率が非常に高い。"],["水上交通の短所は？","速度が遅い。荷役作業には多くの時間・労働力、港湾設備が必要。"],["航空交通の長所は？","高速でほぼ大圏コースを飛行。"],["航空交通の短所は？","重量当たりの輸送費が高い。空港施設には広大な敷地、騒音問題。"]];break;;
  case "交通と通信6" :item =[["コンテナ船とは何か？","荷役作業の軽減や荷役時間の短縮などを目的とするコンテナの普及が進んでいる船"],["コンテナとは何か？","ISO(国際標準化機構)の基準に基づいた鋼鉄製の箱"],["コンテナ船で、専用のクレーンによって積み降ろしを行う港湾で、取り扱い量が多い港湾は？","シャンハイ、シンガポール、シェンチェン、ホンコン、プサンなどアジア"],["国際海峡で、条約により外国船の航行が認められている海峡は？","マラッカ海峡、ペルシャ湾の出入口のホルムズ海峡、地中海の出入口のジブラルタル海峡、黒海の出入口のボスポラス海峡"],["国際運河で、条約により外国船の航行が認められている運河は？","スエズ運河やアメリカ大陸東岸と西岸を短縮したパナマ運河"],["国際河川で、複数の国を流れ、外国船の航行が条約で認められている河川は？","ライン川(スイス⇒ドイツ⇒オランダ⇒北海)、ドナウ川(ドイツ⇒オーストリア⇒東欧諸国⇒黒海)"],["ハブ空港とは何か？","空港の効率的な活用を図るため建設された大規模拠点空港"],["ハブ空港で、地方空港から旅客を集め、目的地まで放射状に運行することからこう呼ばれているものは？","スポーク方式"],["近年、発展途上国にも建設されている国際ハブ空港の例は？","インチョン(韓国)、チャンギ(シンガポール)、ドバイ(UAE)"],["パイプラインで輸送するものは？","石油や天然ガス"],["20世紀末のICT(情報通信技術)革命によって、何が世界的な規模の情報ネットワークに発展したか？","コンピュータ、インターネット"],["インターネットや携帯電話の普及率は何によって大きく違うか？","国"],["固定電話、携帯電話、インターネットの普及率が高いのは？","先進国"],["携帯電話も固定電話と同じように、何で普及率が高いか？","先進国"],["携帯電話が普及し、固定電話の普及率を大きく上回っている国は？","発展途上国"],["インターネットは何が進んだため、最近は、大量のデータのやりとりが可能か？","情報インフラの整備や情報リテラシーの向上、ブロードバンド化"],["中国のインターネット普及率は低いが、最近は何が進み、徐々にインターネットを利用できる環境が整い始めているか？","情報インフラの整備"]];break;;
  case "交通と通信7" :item =[["情報を獲得し、利用できる国とできない国との間で、何が生じているか？","情報格差(デジタルデバイド)"],["情報格差(デジタルデバイド)が生じていると、何がより発展するか？","情報を得られる地域の経済"],["インターネットは、最初はどこで何目的として開発されたか？","アメリカ合衆国で学術研究・軍事目的"],["インターネットはいつ、世界規模の情報ネットワークに発展したか？","1990年代の自由化以降急速に普及"],["情報リテラシーとは何か？","情報を獲得できる技能があるかどうかということ"],["情報リテラシーがあると、何ができるようになるか？","パソコンの操作ができて、インターネットなどにより情報を獲得できる"],["情報リテラシーがないと、何が生じるか？","デジタルデバイド"],["20世紀末の何によって、コンピュータが飛躍的に進歩するとともに、インターネットも社会に広く浸透しつつあるか？","ICT(情報通信技術)革命"],["情報を利用できる者とできない者との間で、何が生じているか？","情報格差(デジタルデバイド)"]];break;;
  case "貿易と資本の移動" :item =[["世界の貿易総額のうち、先進国は何%を占めているか？","約60%"],["先進国は何を輸入しているか？","原材料や農産物"],["発展途上国は何を輸出しているか？","工業製品"],["国際分業とは何か？","それぞれの国が、国産品と外国製品を比較して、得意なものを生産し、不得意なものを輸入すること"],["近年、先進国で何が進んでいるか？","産業の空洞化"],["ASEANとは何か？","東南アジア諸国連合"]];break;;
  case "貿易と資本の移動2" :item =[["一般に先進国は何を輸出しているか？","工業製品"],["一般に発展途上国は何を輸出しているか？","農林水産物やエネルギー・鉱産資源"],["水平的分業とは何か？","先進国どうしの貿易"],["垂直的分業とは何か？","先進国と発展途上国の貿易"],["モノカルチャー経済とは何か？","特定の一次産品の輸出に依存する経済"],["2022年、輸出上位1位の国はどこか？","中国"],["2022年、輸出総額が1位の国はどこか？","中国"], ["ブラジルの主要輸出品目は何か？","大豆"],["インドネシアの主要輸出品目は何か？","石炭"],["タイの主要輸出品目は何か？","機械類"],["マレーシアの主要輸出品目は何か？","機械類"],["ケニアの主要輸出品目は何か？","茶"],["ナイジェリアの主要輸出品目は何か？","原油"],["コロンビアの主要輸出品目は何か？","原油"],["チリの主要輸出品目は何か？","銅鉱"] ,["ベネズエラの主要輸出品目は何か？","原油"]];break;;
  case "貿易と資本の移動3" :item =[["2019年まで、輸出入ともに首位だった国はどこか？","アメリカ合衆国"],["2020年には、輸出入相手国ともに何という国が首位になっているか？","中国"],["1980年代以降、大幅な何によって、アメリカ合衆国と貿易摩擦が生じてきたか？","輸出超過（黒字）"],["近年、中国とどこの国との貿易摩擦が深刻になっているか？","アメリカ合衆国"],["2008年の世界同時不況の影響で、日本の輸出入はどうなったか？","ともに激減"], ["2011年の何によって、日本の輸入が増加したか？","東日本大震災"],["東日本大震災の際、何の輸入が増加したか？","化石燃料"], ["2016年には、日本は何によって黒字になったか？","原油価格の上昇"],["第二次世界大戦後、輸出額の首位を争ってきたのはどことどこの国か？","アメリカ合衆国とドイツ"],["2009年以降、世界最大の輸出国はどこか？","中国"],["2022年時点で輸出貿易に占める主要国の割合が一番大きい国は？","アメリカ合衆国"],["2022年の輸出のランキングで1位は？","中国"],["2022年の輸入のランキングで1位は？","アメリカ合衆国"]];break;;
  case "貿易と資本の移動4" :item =[["日本が輸入超過になっている主な相手国はどこか？","オーストラリア、サウジアラビア、アラブ首長国連邦"],["日本の主要輸入品目で、図9中の赤字で示されている品目は何か？","電気機器、一般機械"],["オーストラリアから日本への主要輸入品目は何か？","石炭、LNG、鉄鉱石"],["インドネシアから日本への主要輸入品目は何か？","石炭、LNG、電気機器"],["ロシアから日本への主要輸入品目は何か？","LNG、石炭、原油"],["サウジアラビアから日本への主要輸入品目は何か？","原油"],["アラブ首長国連邦から日本への主要輸入品目は何か？","原油"],["カナダから日本への主要輸入品目は何か？","石炭、肉類、木材"],["ブラジルから日本への主要輸入品目は何か？","鉄鉱石、トウモロコシ、鶏肉"],["チリから日本への主要輸入品目は何か？","銅鉱、魚介類"],["図10で、1935年（第二次世界大戦前）の日本の主要輸入品目は何か？","繊維原料"],["現在、日本の輸出割合が高くなっている品目は何か？","自動車、電子部品、精密機械"],["日本のFTAカバー率が最も高い相手国はどこか？","シンガポール"],["自由貿易と保護貿易、国内産業を保護するための政策はどちらか？","保護貿易"],["WTOとFTAは何を推進しているか？","自由貿易"]];break;;
  case "貿易と資本の移動5" :item =[["GATTは何年にWTO（世界貿易機関）に改組されたか？","1995年"],["日本は何とFTA（自由貿易協定）を締結する傾向にあるか？","シンガポール、メキシコ、タイ、インドネシア、ブルネイ、ASEAN、フィリピン、スイス、ベトナム、インド"],["NAFTA（北米自由貿易協定）は何年に発効したか？","1994年"],["NAFTAは何を目標としているか？","加盟国間の関税撤廃、金融や投資の自由化、知的所有権の保護"],["USMCA（アメリカ合衆国・メキシコ・カナダ協定）は何年に発効されたか？","2020年"],["FTA（自由貿易協定）とは何か？","関税やサービス貿易（運輸、情報通信、金融、旅行、建設など）の制限撤廃を目的とする協定"],["EPA（経済連携協定）とは何か？","FTAに加え労働市場の開放、投資円滑化、経済協力推進などを含む協定"],["TPP（環太平洋経済連携協定）とは何か？","環太平洋諸国の経済自由化を目指すEPA"],["海外直接投資とは何か？","海外に工場やオフィス、販売店を設立すること"],["対内直接投資とは何か？","外国企業が国内に進出してくること"],["なぜ日本企業は国内より活動の制限がいろいろある外国へ進出するのか？","外国に進出するメリットがあるため"],["日本企業は、どのような理由でNIEsやASEAN諸国に進出したか？","円高や国内賃金水準の上昇に対応し、コストダウンを図るため"],["多国籍企業とは何か？","複数の国にまたがって活動する企業"],["ODAとは何か？","政府開発援助"],["OECD（経済協力開発機構）の下部機関で、ODAの調整を担当しているのはどこか？","DAC（開発援助委員会）"]];break;;
  case "貿易と資本の移動6" :item =[["2022年に最もODAの拠出額が多い国はどこか？","アメリカ合衆国"],["日本は何年から何年まで世界最大のODA拠出国だったか？","1991年から2001年"],["2001年にアメリカ合衆国に首位の座を明け渡した要因は何か？","バブル崩壊後の長引く不況の影響"],["日本が批判されることがある理由として、GNI（国民総所得）比が他の先進国より低いこと以外に何があるか？","無償援助ではなく有償（低金利で融資すること）が多いこと"],["援助の相手国は地理的にどこに近いか？","アジア諸国"],["日本はどこの地域への援助が多いことに注意すべきか？","アフリカ諸国"],["海外直接投資とは何か？","企業の海外進出をさし、生産費のコストダウンや貿易摩擦を解消するため"],["ODA（政府開発援助）とは何か？","政府による発展途上国への援助"]];break;;
  case "国家と民族" :item =[["第二次世界大戦後、どこの国々が独立？","アジア諸国"],["1960年は何と呼ばれた？","アフリカの年"],["「領域」って何？","領土、領海、領空"],["国家の三要素とは？","領域、国民、主権"],["排他的経済水域（EEZ）とは？","沿岸から200海里内の水産資源、エネルギー鉱産資源などに関して沿岸国に排他的管理権を認めた水域"],["領海は何海里まで？","12海里"],["国家間には何が必要？","国境"],["日本のように海洋を国境にしている国もあるが、どんな国境の場合もある？","アメリカ合衆国のアラスカとカナダのように経緯線を国境にしている場合"],["自然国境とは？","海洋、河川、湖沼、山脈など自然物を国境に利用している場合"]];break;;
  case "国家と民族2" :item =[["人為的国境(数理的国境)を利用している場合が多いのはどこ？","北アメリカやアフリカ諸国"],["アフリカでヨーロッパ諸国は何を引いた？","植民地支配によって民族の居住地域を無視した勝手な線引き"],["国内に民族問題を抱え、政治的に不安定な国が多いのはどこ？","分断された主な国境"],["自然国境の「海洋」の例は？","日本、ニュージーランド、スリランカなど島国"],["自然国境の「河川」の例は？","オーデル川(ドイツ、ポーランド)、リオグランデ川(アメリカ、メキシコ)"],["自然国境の「湖沼」の例は？","五大湖(カナダ、アメリカ)、チチカカ湖(ボリビア、ペルー)"],["自然国境の「山脈」の例は？","ピレネー山脈(スペイン、フランス)、アンデス山脈(チリ、アルゼンチン)"],["数理的国境の「経度」の例は？","141°W(アメリカのアラスカ州、カナダ)、141°E(インドネシア、パプアニューギニア)"],["数理的国境の「緯度」の例は？","49°N(カナダ、アメリカ)、22°N(エジプト、スーダン)"],["国連の主要機関の「総会」の加盟国数は？","193か国"],["国連の主要機関の「安全保障理事会」の常任理事国は？","アメリカ合衆国、イギリス、フランス、ロシア、中国"],["国際司法裁判所の本部はどこ？","オランダのハーグ"],["国連の主な内部機関の「UNICEF」とは？","国連児童基金"],["国連の主な内部機関の「UNHCR」とは？","国連難民高等弁務官事務所"],["国連の主な関連専門機関で、本部はワシントンにあるのは？","国際通貨基金(IMF)"],["国連の主な関連専門機関で、本部はパリにあるのは？","国連教育科学文化機関(UNESCO)"],["国連の主な関連専門機関で、本部はジュネーブにあるのは？","世界保健機関(WHO)"],["その他の主な関連機関で、本部はウィーンにあるのは？","国際原子力機関(IAEA)"],["その他の主な関連機関で、本部はジュネーブにあるのは？","世界貿易機関(WTO)"],["国際連合(UN)が組織されたのはいつ？","1945年"],["国際連合(UN)は何のために組織された？","国際平和と安全の維持を目的"],["日本はいつ国連に加盟した？","1956年"],["ASEANとは？","東南アジア諸国連合"],["USMCAとは？","アメリカ・メキシコ・カナダ協定"],["EUとは？","ヨーロッパ連合"]];break;;
  case "国家と民族3" :item =[["UNESCOの略称は？","国連教育科学文化機関"],["UNESCOの活動内容として正しいものは？","教育・科学・文化の研究とその普及。世界遺産の登録・保護"],["FAOの略称は？","国連食糧農業機関"],["FAOの活動内容は？","農業生産の改善による生活水準の向上"],["WTOの略称は？","世界貿易機関"],["WTOの活動内容として正しいものは？","貿易障壁と輸入制限の撤廃。世界貿易の自由化およびサービス貿易や知的所有権などを加えた新しい貿易ルールを確立"],["UNCTADの略称は？","国連貿易開発会議"],["UNCTADの活動内容は？","貿易促進による発展途上国の経済開発促進"],["UNEPの略称は？","国連環境計画"],["UNEPの活動内容は？","環境保護のための国際協力"],["OECDの略称は？","経済協力開発機構"],["OECDの活動内容は？","先進国を中心に38か国から構成(「先進国クラブ」)。世界経済の発展と途上国への援助(ODA)"],["NATOの略称は？","北大西洋条約機構"],["NATOはどんな組織？","欧米西側諸国で結成された集団安全保障機構"],["ASEANの略称は？","東南アジア諸国連合"],["ASEANの活動内容は？","東南アジア10か国。経済発展と域内貿易の拡大"],["AUの略称は？","アフリカ連合"],["AUの活動内容は？","OAU(アフリカ統一機構)が発展的に解消。EU型の政治・経済統合。"],["EUの略称は？","ヨーロッパ連合"],["EUの活動内容は？","政治・経済・通貨統合を目指す"],["EFTAの略称は？","ヨーロッパ自由貿易連合"],["EFTAはどんな組織？","EUとの拡大統一市場を目指すEEA(ヨーロッパ経済領域)を発足"],["USMCAの略称は？","アメリカ・メキシコ・カナダ協定"],["USMCAはどんな組織？","旧NAFTA。アメリカ合衆国、カナダ、メキシコ3か国の自由貿易圏の形成を目指す"],["MERCOSURの略称は？","南米南部共同市場"],["MERCOSURはどんな組織？","域内関税撤廃と域外共通関税を設定"],["APECの略称は？","アジア太平洋経済協力会議"],["APECはどんな組織？","環太平洋地域の貿易・投資の拡大・自由化による経済発展を目指す"],["OPECの略称は？","石油輸出国機構"],["OPECはどんな組織？","メジャーに対抗して設立。産油国石油産業の発展を目指す"],["OAPECの略称は？","アラブ石油輸出国機構"],["単一民族国家とは？","単一の民族で国家を形成するという理念(民族国家、国民国家)"],["中央集権国家と連邦国家、中央政府が直接的に国民・領土を支配する国家は？","中央集権国家"],["中央集権国家の例は？","日本、フランス、韓国"],["連邦国家とは？","中央政府が外交・軍事などを担当し、地方(州)政府が内政に関する権限を委任されている国家"],["連邦国家の例は？","アメリカ合衆国、ドイツ、スイス"],["君主国と共和国、君主国とは？","世襲的な元首によって統治される国家"],["君主国の例は？","イギリス、オランダ、日本"],["共和国とは？","国民から選出された元首によって統治される国家"],["共和国の例は？","アメリカ合衆国、フランス、ロシア"],["国家は〇〇・〇〇・〇〇からなる","領域、国民、主権"]];break;;
  case "国家と民族4" :item =[["人種とは？","人類を肌の色や体の形態などの身体的な特徴で分類したグループ"],["モンゴロイド(黄色人種)の特徴は？","黄・銅色の皮膚、黒髪・直毛"],["モンゴロイド(黄色人種)の主な分布地域は？","東アジア・東南アジア・南北アメリカ(先住民)"],["コーカソイド(白色人種)の特徴は？","白色の皮膚、金髪・褐色髪の波状毛"],["コーカソイド(白色人種)の主な分布地域は？","ヨーロッパ・西アジア・南アジア、北アフリカ・南北アメリカ"],["ネグロイド(黒色人種)の特徴は？","黒色の皮膚、黒色の巻き毛・縮状毛"],["ネグロイド(黒色人種)の主な分布地域は？","中部アフリカ"],["オーストラロイド(濃色人種)の特徴は？","濃色の皮膚、黒色の巻き毛・波状毛"],["オーストラロイド(濃色人種)の主な分布地域は？","ニューギニアやオーストラリア先住民など(アボリジニー)"],["コーカソイドはどこを中心に分布？","ヨーロッパ"],["西アジアと北アフリカの分布地域で間違っているのは？","ネグロイドの分布地域と思っている人がいる"],["ネグロイドはアフリカ系人種と呼ばれる、どこに分布？","サハラ砂漠以南の中南アフリカ"],["南米に多い人種は？","メスチソ(白人とインディオ)、ムラート(白人と黒人)などの混血人種"],["民族とは？","言語や宗教の関わりが大きく、同じ言語を話し、同じ宗教を信じているなど、人生観や価値観をもっている"],["民族を考える場合最も重要な指標は？","言語"]];break;;
  case "国家と民族5" :item =[["世界で最も話者人口が多い言語は？", "中国語"], ["世界で2番目に話者人口が多い言語は？", "スペイン語"], ["世界で3番目に話者人口が多い言語は？", "英語"], ["ゲルマン語派に属する言語は？", "英語・ドイツ語・オランダ語・ノルウェー語・スウェーデン語"], ["ゲルマン語派の主な分布地域は？", "北西ヨーロッパ、アングロアメリカ、オーストラリア"], ["ラテン語派に属する言語は？", "イタリア語・スペイン語・ポルトガル語・フランス語"], ["ラテン語派の主な分布地域は？", "南ヨーロッパ、ラテンアメリカ"], ["スラブ語派に属する言語は？", "ロシア語・ポーランド語・チェコ語・セルビア語"], ["スラブ語派の主な分布地域は？", "東ヨーロッパ～ロシア"], ["インド=ヨーロッパ語族のその他の言語は？", "ケルト語、ギリシャ語、ペルシャ語(イラン)、ヒンディー語(インド)"], ["アフリカ=アジア語族(アフロ=アジア)に属する言語は？", "アラビア語・ヘブライ語(イスラエル)"], ["アフリカ=アジア語族(アフロ=アジア)の主な分布地域は？", "北アフリカ～西アジア"], ["ウラル語族に属する言語は？", "フィンランド語・エストニア語・マジャール語(ハンガリー)"], ["ウラル語族の主な分布地域は？", "フィンランド、エストニア、ハンガリー"], ["アルタイ語族に属する言語は？", "トルコ語・モンゴル語"], ["アルタイ語族の主な分布地域は？", "トルコ～中央アジア、シベリア～モンゴル"], ["シナ=チベット語族に属する言語は？", "中国語・チベット語・ミャンマー語"], ["シナ=チベット語族の主な分布地域は？", "中国～インドシナ半島"], ["オーストロネシア語族(マレー=ポリネシア)に属する言語は？", "マレー語・インドネシア語・フィリピノ語"], ["オーストロネシア語族(マレー=ポリネシア)の主な分布地域は？", "東南アジア島嶼部、マダガスカル"], ["ニジェール=コルドファン語族に属する言語は？", "スーダン語系・ギニア湾沿岸、バンツー語系"], ["ニジェール=コルドファン語族の主な分布地域は？", "サハラ以南の中南アフリカ"], ["三大宗教は？", "キリスト教、イスラーム教、仏教"], ["キリスト教、イスラーム教、仏教の三大宗教を何と呼んでいる？", "世界宗教"], ["キリスト教はどこで生まれた？", "西アジア(パレスチナ)"], ["キリスト教がヨーロッパに広まっていったのはなぜ？", "ローマ帝国の発展とともに"], ["ローマ帝国の東西分裂で、西に何、東に何ができた？","西にカトリック、東にオーソドックス"], ["カトリックから宗教改革を経て何が普及した？","プロテスタント"], ["世界で最も信者人口が多い宗教は？", "キリスト教"], ["キリスト教の信者数は？", "2,586百万人"], ["イスラーム教の信者数は？", "1,999百万人"]];break;;
  case "国家と民族6" :item =[["キリスト教は、カトリック(旧教)、〇〇、〇〇という3つのグループに発展していった", "オーソドックス(正教会、東方正教会), プロテスタント(新教)"], ["イスラームもどこで生まれた？", "西アジア(アラビア半島)"], ["仏教はどこで生まれた？", "インドのガンジス川流域"], ["宗教人口でキリスト教、イスラームの次にくるのは？", "ヒンドゥー教"], ["ヒンドゥー教はどこから生まれた？", "インド古来のバラモン教"], ["ヒンドゥー教は〇〇〇〇などの影響を受けて成立した", "仏教、各地の民間信仰"], ["ユダヤ教も同様にどこに住むユダヤ人に信仰されている？", "イスラエルや世界各地"], ["中南アフリカやアメリカ大陸では何が信仰されている？", "自然崇拝の伝統宗教"], ["語族と類語、同一起源から派生したと証明されている言語グループを何というか？", "語族"], ["語族とはっきりとは同系統と認められない言語グループのことを何と指す？", "類語"], ["ケルト系民族、古代ヨーロッパの先住民で、どこなどに居住している？", "アイルランド、イギリスのスコットランド、ウェールズ、フランスのブルターニュ半島"], ["北アイルランド(イギリス)では何と何の間で対立がみられる。", "プロテスタントとカトリック"], ["バスク人、どこからどこにかけてのバスク地方に居住する少数民族？", "スペインからフランス"], ["スペインでは何が認められているが、分離独立運動も盛んである。", "自治"], ["チベット仏教(ラマ教)、何がチベットの民間宗教の影響を受けたもので、どこで信仰されている？", "チベットやモンゴル"], ["チベット自治区の中心地は？", "ラサ"], ["キリスト教はどこで始まった？", "西アジア(パレスチナ)"], ["キリスト教の聖典は？", "聖書"], ["キリスト教における精神的な支柱となるものは？", "日曜日とし、礼拝を行う"], ["イスラーム(イスラム教)はどこで始まった？", "西アジア(アラビア半島)"], ["イスラーム(イスラム教)の聖典は？", "コーラン(クルアーン)"], ["イスラーム(イスラム教)での義務は？", "礼拝、断食、巡礼"], ["イスラーム(イスラム教)で金曜日にはどこで礼拝を行う？", "モスク"], ["イスラーム(イスラム教)の最高の聖地はどこ？", "メッカ(サウジアラビア)"], ["仏教はどこで始まった？", "インド北部地方"], ["仏教はどこでは定着せず、どこへ発展した？", "スリランカ、東南アジア(インドシナ半島)、中国、朝鮮半島、日本"], ["ヒンドゥー教の特徴は？", "自然崇拝の多神教で特定の教祖・経典を持たない。輪廻思想、カースト制度とのかかわりが深い。牛を神聖化し、菜食主義者が多い。"], ["ユダヤ教はどこで始まった？","西アジア(パレスチナ)"], ["ユダヤ教で何が敵われるという「選民思想」？","ユダヤ人だけ"], ["ユダヤ教、キリスト教、イスラームの聖地は？","エルサレム(イスラエル)"]];break;;
  case "国家と民族7" :item =[["ユーゴスラビア紛争はいつからいつまでか？","1991~2002年"],["北アイルランド紛争で対立しているのは？","カトリックとプロテスタント"],["スペインで分離を求めている民族は？","バスク民族"],["メキシコで反政府運動を起こしている先住民は何年？","1994年〜"],["パレスチナ問題で対立しているのは？","アラブ人とユダヤ人"],["シリア内戦はいつから？","2011年〜"],["ソマリア内戦はいつから？","1991年〜"],["ルワンダ、ブルンジで対立しているのは？","ツチ人とフツ人"],["南スーダン内戦はいつから？","2013年〜"],["クリミア半島をめぐる対立はどことどこの対立？","ウクライナとロシア"],["チェチェン共和国の独立を求める運動はいつから？","1994年〜"],["カシミールをめぐる対立はどことどこの対立？","インドとパキスタン"],["南沙群島の領有をめぐる問題はいつから？","1974年〜"]];break;;
  case "東アジア" :item =[["アジアの大部分は何と何が広がっているか？","安定陸塊と古期造山帯"],["新期造山帯に属する山脈は？","ヒマラヤ山脈"],["新期造山帯に属する高原は？","チベット高原"],["新期造山帯に属する島は？(2つ以上)","日本列島、フィリピン諸島、スンダ列島"],["最も北に位置する海は？","北極海"],["最も東に位置する海は？","ベーリング海"],["最も南に位置する海は？","インド洋"],["最も西に位置する海は？","地中海"],["安定陸塊の高原の例は？","デカン高原"],["古期造山帯の山地の例は？","ウラル山脈"],["日本列島は何という造山帯に属しているか。","環太平洋造山帯"],["インドシナ半島の西に位置する湾は？","ベンガル湾"], ["チベット高原の北に位置する盆地","タリム盆地"]];break;;
  case "東アジア2" :item =[["黄河はどこからどこへ流れるか？","チベット→華北"],["長江はどこからどこへ流れるか？","チベット→華中"],["メコン川はどこからどこへ流れるか？","チベット→タイ・ラオス→カンボジア→ベトナム"],["チャオプラヤ川はどこからどこへ流れるか？","インドシナ北部→タイ"],["ガンジス川はどこからどこへ流れるか？","チベット→インド→バングラデシュ"],["インダス川はどこからどこへ流れるか？","チベット→パキスタン"],["Awは何気候か？","熱帯雨林気候"],["図2で、BSは何気候か？","ステップ気候"],["BWは何気候か？","砂漠気候"],["Cfaは何気候か？","温暖湿潤気候"],["Cwは何気候か？","温暖冬季少雨気候"],["Dfは何気候か？","冷帯湿潤気候"],["Dwは何気候か？","冷帯冬季少雨気候"],["ETは何気候か？","ツンドラ気候"],["アジアは大きく分けると、モンスーンの影響が(1)アジアと、乾燥気候が卓越する(2)アジアに分類される。","(1)強い、(2)乾燥"]];break;;
  case "東アジア3" :item =[["朝鮮半島は、日本とほぼ同緯度にあるが、気候の違いは？","大陸性の気候(Dw・Cw)が広がり、気温の年較差も日本より大きい"],["北京の気候区分は？","BS"],["札幌の気候区分は？","Df"],["ソウルの気候区分は？","Cw"],["図4で、東京の気候区分は？","Cfa"],["朝鮮半島には、南に何という国があるか？","大韓民国(韓国)"],["朝鮮半島には、北に何という国があるか？","朝鮮民主主義人民共和国(北朝鮮)"],["韓国と北朝鮮は、いつ国連に同時加盟したか","1991年"],["ハングル文字で、「こんにちは」は何と読むか？","アンニョンハセヨ"],["韓国の宗教別人口(2022年)で、最も多いのは？","無宗教"],["韓国の宗教別人口(2022年)で、キリスト教の割合は？","27.7%"],["韓国の宗教別人口(2022年)で、仏教の割合は？","15.5%"],["韓国の伝統的な家屋に見られる床暖房設備は？","オンドル"],["韓国の民族衣装で女性のものは？","チマ・チョゴリ"],["セマウル運動とは何か？","農村の近代化運動"],["韓国がアジアNIEsの一つとして、経済発展したのはいつからか?","1980年代"]];break;;
  case "東アジア4" :item =[["キョンイン工業地域にある主な工業は？(2つ以上)","工業地域、鉄鋼、一般機械工業、自動車工業、造船、電子工業、化学工業"],["南東沿岸工業地域にある主な工業は？(2つ以上)","鉄鋼、一般機械工業、自動車工業、造船、電子工業、化学工業、製油所"],["ホナム工業地域にある主な工業は？","化学工業"],["テグにある主な工業は？","繊維工業"],["クミにある主な工業は？","電子工業"],["ウルサンにある主な工業は？","自動車工業"],["日本海沿岸に成立している工業地域は？","ポハン、ウルサン"],["韓国はいつOECDに加盟したか？","1996年"],["韓国の首都ソウルへの人口一極集中で、ソウルに住んでいる人口は、総人口の約何分の1？","約5分の1"],["韓国と北朝鮮の政治体制の違いは？","韓国は資本主義国、北朝鮮は社会主義国"],["北朝鮮で、経済・外交・国防の自立を目指した考え方は？","チュチェ(主体)思想"],["北朝鮮で経済が不振に陥っている原因は？(2つ以上)","資本や技術の不足、軍事費の増大、自然災害"],["朝鮮半島の土地利用で最も多いのは？","森林"]];break;;
  case "東アジア5" :item =[["韓国の気候は主に何が分布しているか？","北からDw・Cw・Cfa"],["韓国の首都は？","ソウル"],["韓国の人口は約何万人？","約5,200万人"],["ソウルの人口は都市人口の約何%以上？","80%以上"],["韓国の主要産業は？(2つ以上)","自動車、石油化学、造船"],["北朝鮮の気候はほぼ全域で何？","Dw"],["北朝鮮の首都は？","ピョンヤン"],["北朝鮮の人口は約何万人？","約2,600万人"],["北朝鮮で自力更生を掲げた思想は？","チュチェ思想"],["北朝鮮の主要産業は？","工業"],["中国の国土面積はどこの国に次いで大きい？","ロシア、カナダ、アメリカ合衆国"],["中国の地形の特徴は？","西高東低"],["中国で、東部の沿岸地域と西部の内陸部、どちらの気候が湿潤？","東部の沿岸地域"],["中国の総人口約14億人のうち、何%以上が東部の平野に住んでいるか？","90%以上"],["中国の東部を流れる大河は？(2つ)","黄河、長江"]];break;;
  case "東アジア6" :item =[["中国は、大きく分けると5つの地域に分けられる。何か？","東北、華北、華中、華南、内陸地域"],["東北地方の地形と主な河川は？","東北平原。リヤオ川、ソンホワ川。"],["東北地方の気候は？","冬季寒冷なDw"],["華北地方の地形は？","黄河流域に華北平原、黄土高原"],["華北地方の気候は？","降水量が少なくBS、一部Dw、Cwも"],["華中地方の地形は？","長江流域に長江中下流平原、スーチョワン盆地。"],["華中地方の気候は？","温暖多雨なCfa"],["華南地方の地形は？","山がちで沿岸部に狭い平野。チュー川のデルタ。"],["華南地方の気候は？","亜熱帯性のCw"],["内陸地方の地形は？","ゴビ砂漠、タクラマカン砂漠、テンシャン山脈、クンルン山脈、チベット高原"],["内陸地方の気候は？","BS〜BWが大部分だが、チベット高原はET"],["中国の行政区分で、人口の90%以上は何語を話す何族？","中国語、漢族"],["中国には、55の何があるか？","少数民族"],["チベット自治区の主な民族は？","チベット族"],["シンチヤンウイグル自治区の主な民族は？","ウイグル族"],["内モンゴル自治区の主な民族は？","モンゴル族"],["中華人民共和国が成立したのはいつ？","1949年"],["1970年代末から、中国で実施された政策は？","改革・開放"],["改革・開放政策で、農業に取り入れられた制度は？","生産責任制"]];break;;
  case "東アジア7" :item =[["中国で、1979年から採用された政策は？","一人っ子政策"],["一人っ子政策によって、何が低下したか？","出生率、人口増加率"],["2022年の中国の合計特殊出生率は？","1.09"],["一人っ子政策が廃止されたのはいつ？","2015年"],["一人っ子政策廃止後、何人まで出産を認められているか？","三人"],["1950年の中国の人口ピラミッドで、最も割合が高い年齢層は？","0-4歳"],["2021年の中国の人口ピラミッドで、最も割合が高い年齢層は？","50-54歳"],["2050年(推定)の中国の人口ピラミッドで、最も割合が高い年齢層は？","75-79歳"],["東北地方で栽培されている作物は？(2つ以上)", "とうもろこし、大豆、水稲"],["華北地方で栽培されている作物は？(2つ以上)", "小麦、とうもろこし、綿花"],["華中地方で栽培されている作物は？","水稲"],["華南地方で栽培されている作物は？(2つ以上)","水稲、サトウキビ"],["図12で、内陸地方で栽培されている作物は？(2つ以上)","綿花、ブドウ"],["チンリン・ホワイ川線より北で栽培が盛んな作物は？","畑作"],["チンリン・ホワイ川線より南で栽培が盛んな作物は？","稲作"],["中国が輸入を増やしている主要な農産物は？","大豆"],["大豆の主な輸入元は？","ブラジル"]];break;;
  case "東アジア8" :item =[["中国で石炭の依存度が最も高い地域はどこか？","山西省周辺"],["粗鋼の生産量が世界で占める割合は？","54.0%"],["化学繊維の生産量が世界で占める割合は？","68.9%"],["携帯電話の生産量が世界で占める割合は？","78.6%"],["パソコンの生産量が世界で占める割合は？","98.2%"],["1980年代に中国南部で設立された、外国資本を受け入れた地域を何というか？","経済特区"],["外国企業の進出が活発なのは、中国の沿岸部と内陸部のどちらか？","沿岸部"],["近年、中国が積極的に投資を行っている地域はどこか？","アフリカ"],["中国が国内陸部からユーラシア、東南・南アジア、アフリカ東岸を結ぼうとしている政策を何というか？","一帯一路"],["郷鎮企業とは何か？","村・町などが経営する企業"],["台湾の一人当たりGNIはいくらか？","33,756ドル"], ["中国の経済政策、「改革・開放」政策は何を目的として行われたか？","外国企業の誘致と市場経済の導入"],["中国で近年進められている、地域格差解消のための大規模プロジェクトとは？","西部大開発など"]];break;;
  case "東アジア9" :item =[["東北地方の主要工業都市はどこか？","シェンヤン"],["華北地方で、先端産業や家電で発展している都市はどこか？","ペキン"],["長江河口付近に位置し、中国経済の中心地となっている都市はどこか？","シャンハイ"],["華南地方で、経済特区に指定されている都市はどこか？","コワンチョウ、シェンチェン、アモイ、スワトウ"],["内陸部で、資源開発が行われている地域はどこか？","パオトウ、ウルムチ"],["台湾の主要工業都市で、IT関連産業が盛んな都市はどこか？","タイペイ"],["中国の国土の特徴として、地形の高低差はどうか？","西高東低"],["中国の年間降水量は、どの山脈を結ぶ線によって分けられるか？","チンリン山脈とホワイ川"],["中国で、砂漠化防止のために進められている政策は何か？","退耕還林"],["2000年頃から中国で実施されている、内陸部の経済格差を解消するためのプロジェクトは何か？","西部大開発"],["中国で、電力を東部に輸送するプロジェクトを何というか？","西電東送"],["中国で、水を南から北へ送るプロジェクトを何というか？","南水北調"],["香港やマカオで採用されている、中国本土とは異なる政治・経済体制を何というか？","一国二制度"]];break;;
  case "東南アジアと南アジア" :item =[["東南アジアに含まれる主な半島や島を3つ以上挙げよ。", "インドシナ半島、マレー半島、スマトラ島、ジャワ島、バリ島、フィリピン諸島"],["フィリピン諸島やスンダ列島付近の地質学的特徴は何か？","火山が多い、地震活動が活発"],["東南アジアの気候帯は主に何と何に分けられるか？","熱帯雨林気候(Af)、熱帯モンスーン気候(Am)"],["モンスーンとは何か？","季節風"], ["インドシナ半島で、6世紀から13世紀ごろインドから伝わった宗教は何か？","上座仏教"],["島嶼部で13世紀以降アラビア商人により伝えられた宗教は何か？","イスラーム教(イスラム教)"],["フィリピンと東ティモールで多く信仰されている宗教は何か？","キリスト教(カトリック)"],["インドネシアのバリ島で多く信仰されている宗教は何か？","ヒンドゥー教"],["マレー半島から島嶼部にかけて広く分布している民族は何か？","マレー系民族"],["インドシナ半島で主に用いられている言語は何か？","シナ・チベット語族"],["1月のモンスーンの風向きは？","大陸から海洋へ"],["7月のモンスーンの風向きは？","海洋から大陸へ"]];break;;
  case "東南アジアと南アジア2" :item =[["ASEANの正式名称は何か？","東南アジア諸国連合(Association of South-East Asian Nations)"],["ASEANが結成されたのは何年か？","1967年"],["ASEAN結成当初の主な目的は何か？","反共産主義の防衛網"],["1995年にASEANに加盟した国はどこか？","ベトナム"],["1997年にASEANに加盟した国はどこか？","ミャンマーとラオス"],["1999年にASEANに加盟した国はどこか？","カンボジア"],["AFTAとは何か？","ASEAN自由貿易地域"], ["2015年にASEANで発足したものは何か？", "AEC(ASEAN経済共同体)と、それを深化させたASC(ASEAN安全保障共同体)、ASCC（ASEAN社会・文化共同体）を包括したASEAN共同体(AC)"],["プランテーション作物とは何か？","商品価値の高い農産物を大規模に栽培するもの"],["輸出指向型工業とは何か？","輸出向けの製品を製造する工業"],["表１で、ベトナムの主な宗教は何か？","大乗仏教"],["マレーシアの主な宗教は何か？","イスラーム教（国教）"],["フィリピンの主な宗教は何か？","カトリック"], ["2022年のシンガポールの主要輸出品は何か?", "機械類、石油製品、精密機器"], ["2022年のタイの主要輸出品は何か?", "機械類、自動車、プラスチック"]];break;;
  case "東南アジアと南アジア3" :item =[["タイは東南アジアで唯一、戦前から何であった国か？","独立国"],["タイで1960年代半ばから進められた農業政策を何というか？","緑の革命"],["タイの土地生産性が低い理由として、何が普及していないことが挙げられるか？","灌漑システム、機械化"],["タイの主要な輸出品を3つ挙げよ。", "天然ゴム、砂糖、エビなどの水産物"],["近年、タイで自動車産業を筆頭に進出している企業はどこの国が多いか？","日本"],["マレーシアで、民族間の所得格差を向上させるために実施された政策は何か？","マレー人優先政策（ブミプトラ政策）"],["マレー語を何と定めたか？","国語"],["天然ゴムのプランテーションがどこから移植された？","アマゾン地方"],["マレーシアで近年、食用油として需要が伸びているものは何か？","パーム油"],["ルックイースト政策とは何か？","日本や韓国をモデルとした経済政策"],["マレーシアで近年建設された、IT工業団地の名称は？","サイバージャヤ"],["シンガポールが、マレーシアから分離独立したのはいつか？","文章中に記載なし（画像から読み取れない）"],["シンガポールの公用語は何語あるか？","4言語（マレー語、中国語、タミル語、英語）"],["シンガポールは、何と呼ばれるほどに成長したか？","NIEs"],["マレーシアの人口の約60%を占めている民族は？","マレー系民族"]];break;;
  case "東南アジアと南アジア4" :item =[["インドネシアの人口は、約何人か？", "約2.8億人"], ["インドネシアで、イスラーム教徒の人口が世界で一番多い島はどこか？", "ジャワ島"], ["インドネシアの公用語は何か？", "インドネシア語"], ["ジャワ島に人口が集中していることによる問題点を解消するために、インドネシア政府が実施している政策は何か？", "トランスミグラシ政策"], ["フィリピンが、アメリカ合衆国領になる前に支配していた国はどこか？", "スペイン"], ["フィリピンの公用語は何か？", "フィリピノ語と英語"], ["日本のバナナの最大の輸入相手国はどこか？", "フィリピン"], ["シンガポールの特徴は何か？", "マラッカ海峡に面する島国。アジアNIEs。1人当たりGNIは先進国並みの58,770ドル。"], ["ブルネイの特徴は何か？", "石油・天然ガスに経済を依存。人口が少なく(約45万人)、1人当たりGNIは31,650ドル。"], ["マレーシアの特徴は何か？", "マレー系・先住民族(62.0%)、中国系(22.7%)、インド系(6.9%)からなる多民族国家。ブミプトラ政策。シンガポールに次いで工業化が進展。"], ["表3で、タイの特徴は何か？", "古くから農産物の輸出が盛ん(米の輸出は世界のトップクラス)。近年は、タイ、マレーシアとともに輸出指向型工業が発展。日本などの自動車メーカーが進出。"], ["フィリピンの特徴は何か？", "多島国で火山が多い(ピナトゥボ山)。バナナやココヤシ(コプラ)などフィリピンの農産物が経済を支えてきたが、近年は工業化も進展。"], ["インドネシアの主要輸出品で、日本へも輸出されているものは何か？", "石炭、LNG、原油"], ["多島国で、農村部では大土地所有制が残っている国はどこか？", "フィリピン"]];break;;
  case "東南アジアと南アジア5" :item =[["インドシナ半島は、第二次世界大戦後どうなったか？", "インドシナ戦争、ベトナム戦争、カンボジア内戦など紛争が続いたため、経済は長く停滞していた"], ["ベトナムで、1986年から打ち出された経済政策は何か？", "ドイモイ（刷新）"], ["ベトナムの主要な輸出品は何か？", "米やコーヒー、原油"], ["マレー語は、東南アジアの島嶼部で何として広く用いられているか？", "商用語"], ["1997年に、タイの通貨バーツの暴落から始まった経済の混乱を何というか？", "アジア経済（金融）危機"], ["東南アジアは、主に何と何からなる地域か？", "インドシナ半島、マレー半島と島嶼部"], ["タイ以外の東南アジア諸国は、第二次世界大戦後までどこの植民地支配を受けていたか？", "欧米"], ["南アジアの地形図で、北部に位置する山脈は何か？", "ヒマラヤ山脈"], ["インド半島の大部分を占める地形は何か？", "デカン高原"], ["インド半島の付け根付近を流れ、ヒンドスタン平原やガンジスデルタを形成している河川は何か？", "ガンジス川とブラマプトラ川"], ["スリランカにあるセイロン島も何として知られる？", "安定陸塊"], ["南アジアの気候図で、大部分を占める気候帯は？","Aw(サバナ気候)とAm(熱帯モンスーン気候)"]];break;;
  case "東南アジアと南アジア6" :item =[["インド半島で、夏の南西モンスーンの影響が強く、雨も多い地域はどこか？", "インド半島西岸やヒンドスタン平原からアッサム丘陵"], ["デカン高原の西部からパキスタンにかけては、何の影響が少なく、乾燥帯になっているか？", "モンスーン(季節風)と、亜熱帯高圧帯"], ["インド・パキスタン国境付近に広がる砂漠は何か？", "インダス砂漠(タール砂漠)"], ["インドの宗教で、最も信者が多いのは何か？", "ヒンドゥー教"], ["パキスタンとバングラデシュで、最も信者が多いのは何か？", "イスラーム教"], ["スリランカで最も信者が多いのは何か？", "仏教"], ["インドの国土面積は、南アジアで何番目に大きいか？", "一番大きい"], ["インドの人口は、何人を超えているか？", "14億人"], ["インドの公用語は何か？", "ヒンディー語"], ["インドで、準公用語とされている言語は何か？", "英語"], ["インド半島にもともといたとされる、ドラヴィダ系とはどのような人々か？", "黒色の肌をもつマレー系人種とかオーストラロイドとかいわれている"], ["西アジアからインドに侵入してきたとされるのは、何系の何人か？", "インド＝ヨーロッパ系のコーカソイド"], ["南アジアの言語分布図で、インド北部に分布している語族は何か？", "インド＝ヨーロッパ語族"], ["南アジアの言語分布図で、インド南部に分布している語族は何か？", "ドラヴィダ語族"], ["南アジアの米の生産地域で、多く栽培されているのはどこか？", "ガンジス川下流から中流域および海岸部"]];break;;
  case "東南アジアと南アジア7" :item =[["ヒンドスタン平原からガンジスデルタで栽培されている、黄麻とも呼ばれる繊維作物は何か？", "ジュート"], ["年降水量1,000mm未満の地域や、デカン高原西部のレグールでの分布地域が広い作物は何か？", "綿花"], ["米と小麦の生産は、中国に次いで世界第何位か？", "第2位"], ["1960年代後半から、インドで何によって小麦、米などの高収量品種が導入されたか？", "緑の革命"], ["インドは、何の生産量が世界最大か？", "牛乳"], ["牛乳や乳製品の生産増大、酪農協同組合の設立などにより、生乳（牛と水牛）の生産量が急増したことを何というか？", "白い革命"], ["第二次世界大戦前は、デカン高原の何を利用した伝統的な綿製品の生産と、どこで何くらいしか発達していなかったか？", "綿花、ジャムシェドプルの鉄鋼業"], ["戦後、政府主導の工業化政策のもと、何と何総合開発が実施されたか？", "ダモダル川"], ["近年、デカン高原南部（バンガロール）で、何産業の集積地が形成されているか？", "コンピュータソフトの開発などハイテク産業"], ["インドが1991年から外資の積極的な導入、関税引き下げを行う何を実施しているか？", "経済開放政策"], ["パキスタンは、何人などからなる何国家で、何語（何文字を使用する）が使用されているか？","パンジャブ人、パシュトゥーン人、多民族国家、ウルドゥー語（アラビア文字）"], ["パキスタンで、国語と公用語に指定されているのは何か？", "ウルドゥー語が国語、英語が公用"], ["パキスタンの国土の大部分が、何気候か？", "乾燥気候"], ["パキスタンで、イギリス植民地時代から何が整備されていたため、何地方を中心に何や何の栽培が盛んか？", "灌漑設備、パンジャブ地方、小麦や綿花"], ["南アジアの鉱工業と主な都市で、インドの鉄鉱石の産地は？","デリーの南東、ジャムシェドプル周辺"],["南アジアの鉱工業と主な都市で、インドの石炭の産地は？","デリーの南東、ジャムシェドプルからコルカタにかけて"]];break;;
  case "東南アジアと南アジア8" :item =[["バングラデシュは、どこから分離独立した国か？", "パキスタン"], ["バングラデシュで、公用語となっているのは何か？", "ベンガル語"], ["バングラデシュの国土の大部分がどこに位置するため、何と何の栽培の中心になっているか？", "ガンジスデルタ、米とジュート"], ["バングラデシュの輸出品の70%以上を占めているものは何か？", "衣類や繊維品"], ["バングラデシュの人口密度はどれくらいか？", "1,000人/km²以上"], ["バングラデシュで、しばしば起こる自然災害は何か？", "サイクロンによる洪水や高潮"], ["スリランカは、インド洋に浮かぶ何島で、何のモンスーンの影響を強く受け、国土の何部はかなり降水量が多いか？", "島国、夏の南西モンスーン、南西部"], ["スリランカで栽培に適しているものは何か？", "茶"], ["スリランカの主要な輸出品は何か？", "茶"], ["インド半島から移住してきた何系の人々と、どこ系何人からなるが、多数を占めるのは何教徒が多い何人か？", "インド=ヨーロッパ(アーリア)系、ドラヴィダ系タミル人、仏教徒が多いシンハラ人"], ["ヒンドゥー教の、身分制度を何というか？", "カースト制度"], ["カーストは、バラモン、クシャトリヤ、ヴァイシャ、シュードラからなる何と呼ばれる社会集団からなるか？", "ジャーティ"], ["インドの人口、主な言語、主な宗教は何か？", "約14億1,717万人、ヒンディー語、英語、その他の22の憲法公認語、ヒンドゥー教"], ["バングラデシュの人口、主な言語、主な宗教は何か？", "17,119万人、ベンガル語、英語、イスラーム教"], ["スリランカの人口、主な言語、主な宗教は何か？", "2,183万人、シンハラ語、タミル語、英語、仏教"]];break;;
  case "西アジアとアフリカ" :item =[["西アジア・アフリカ地域の学習のテーマは何か？","西アジア、アフリカ、北アフリカと中南アフリカの自然環境・文化の違いに注目"],["西アジアはどこからどこまでを指す地域か？","東はアフガニスタン、西はアラビア半島、北はトルコ"],["アラビア半島の地形的な特徴は？","安定陸塊(旧ゴンドワナランド)"],["アラビア半島にある山脈は？","ヒマラヤ造山帯"],["ティグリス・ユーフラテス川が形成した平野は？","メソポタミア平野"],["アラビア半島の気候は？","大部分が乾燥気候（BS～BW）"],["トルコの沿岸部やイスラエルなどの気候は？","地中海性気候（Cs）"],["BRICSの一員であり、近年急速に経済発展を遂げている国は？","インド"],["インドの1人当たりGNIは中国の約何倍か？","5倍"],["インドで盛んな産業は？","ICT関連産業"],["インドのシリコンヴァレーと呼ばれる都市は？","バンガロール"],["南アジア各国の主要な宗教で、インドの宗教は？","ヒンドゥー教"],["南アジア各国の主要な宗教で、パキスタンの宗教は？","イスラム教"]];break;
  case "西アジアとアフリカ2" :item =[["厳しい乾燥気候が分布している地域で、人々はどのように生活を営んでいるか？","遊牧とオアシス農業"],["アラビア半島で遊牧生活を送ってきた民族は？","ベドウィン"],["ティグリス・ユーフラテス川などの外来河川の沿岸で行われている農業は？","オアシス農業"],["灌漑によって、オアシスでは何が栽培されている？","小麦、ナツメヤシ、野菜、果実"],["1970年代の石油危機以降、産油国では何が整備された？","工業化やインフラ（道路、上下水道など）"],["サウジアラビアでは都市人口率が何％以上か？","80%以上"],["西アジアといえば、何という民族がイスラームにもとづいた生活を送っているイメージが強い？","アラブ民族"],["アラビア半島は何教の発祥地？","イスラーム教"],["アフリカ＝アジア語族の言語を話す人々は何人？","アラブ人"], ["イラン以東のイスラーム教徒は何人以外？","インド＝ヨーロッパ語族"],["トルコで多いイスラム教徒は何語族？","アルタイ語族"],["イスラエルに多い宗教と、その言語は","ユダヤ教徒、アフリカ＝アジア語族"],["西アジアの石油の埋蔵量がとても多い地域で、経済の中心は？","石油産業"],["1970年代の石油危機以降、西アジアの産油国は何が進んだ？","石油産業の国有化"],["西アジアの産油国で、特に石油収入をもとに何が進んでいる？","工業化"],["世界最大級の石油大国は？","サウジアラビア"],["サウジアラビアの原油埋蔵量、生産量、輸出量は世界でどの程度？","世界最大級"],["アラブの石油大国のサウジアラビアで、国土の大部分は何？","砂漠"],["西アジア・中央アジアの言語分布図で、トルコで話されている言語は？", "トルコ語"],["西アジア・中央アジアの言語分布図で、イランで話されている言語は？", "ペルシア語"]];break;;
  case "西アジアとアフリカ3" :item =[["石油関連産業をはじめとする工業化を進めている、もともとアラビア半島に居住していた民族は？","ベドウィン"],["イスラーム教徒の巡礼の町は？","メッカ"],["イラクもサウジアラビアと同様に何人国家？","アラブ人国家"],["フセイン政権で実権を握っていたのはイスラームの何派？","スンニ派"],["イラクの国土の大半は、何川が流れる何文明の発祥地？","ティグリス・ユーフラテス川、メソポタミア文明"],["石油資源も豊富だが、何という戦争が続いたため石油生産は低下した？(３つ)", "イラン・イラク戦争、湾岸戦争、イラク戦争"],["イラクの東に位置するイランは、何語族？","インド＝ヨーロッパ系（ペルシャ語）"], ["イランの国土の大部分が何高原、何山脈、何山脈などに位置している？","イラン高原、ザグロス山脈、エルブールズ山脈"],["イランの油田は南部のどこに多く分布している？","ペルシャ湾岸付近"],["トルコはイスラーム国家だが何を進めてきた？","ヨーロッパ型の近代化"],["トルコは何に加盟、さらに現在、何への加盟申請もしている？","NATO、OECD、EU"],["トルコで使われている文字は？","ラテン文字"],["イスラエルは第二次世界大戦後に建国した何人国家だった？","ユダヤ人国家"],["ユダヤ人による民族国家をどこに建設した？","パレスチナ"],["19世紀後半から何運動と呼ばれる祖国再建運動が活発化した？","シオニズム運動"],["第二次世界大戦後、どこにイスラエルが建国された？","パレスチナ"],["イスラエル国内には何語を話すユダヤ人と何語を話すパレスチナ人が居住している？","ヘブライ語、アラビア語"],["イスラエルで比較的進んでいて、何工業や何産業が発達している？","工業化、ダイヤモンド研磨工業、ハイテク産業"],["イスラエルは何の加盟国でもある？","OECD"],["イスラエルの1人当たりGNIは？","53,302ドル"],["トルコはかつて何、何、何にまたがる大帝国を築いていた？","アジア、ヨーロッパ、アフリカ"],["トルコの現在の国土は、何半島と何半島の一部？","アナトリア半島、バルカン半島"],["アジアとヨーロッパの境界となる海峡は？", "ボスポラス海峡"]];break;;
  case "西アジアとアフリカ4" :item =[["イスラーム教徒（ムスリム）の生活のきまりが詳細に記されている、唯一神アッラーを信じるよりどころは？", "聖典の「コーラン（クルアーン）」"], ["イスラム教徒に義務とされる、神に対する信仰告白の他に４つは？", "礼拝、喜捨、断食、巡礼"], ["イスラム教で禁じられていることは？", "飲酒、ギャンブル、豚肉を食すること、女性が人前で肌を露出させること"], ["トルコ、イラク、イランなどにまたがるクルディスタン地方に居住する民族で、多くが何語を使用？", "インド＝ヨーロッパ系のクルド語"], ["クルド人は何教徒？", "イスラーム教徒"], ["クルド人の人口は？", "3,000万人以上"], ["周辺諸国から国家を形成することを許されず、独立の気運も高いが、イラクでは政府の何により、多くの難民が発生した？", "弾圧"], ["西アジアの地形は、北部が何で、南部のアラビア半島は何？", "新期造山帯の山脈や高原、安定陸塊"], ["西アジアの気候は？", "亜熱帯高圧帯の影響を強く受け、BS～BW気候が分布し、古くから遊牧やオアシス農業が営まれてきた"], ["第二次世界大戦後、大規模な油田開発が進み、何によって人々の生活水準は向上した？", "石油収入"], ["中東戦争をはじめ何が続き、現在でも何問題、何問題などをかかえている？", "紛争、パレスチナ問題、クルド人問題"]];break;;
  case "西アジアとアフリカ5" :item =[["アフリカ大陸の大部分は何？", "安定陸塊（旧ゴンドワナランド）"], ["アフリカ大陸で、やや高めの高原状の大陸は何？", "高原"], ["アフリカで高度200～1,000mの割合が大きいが、低地の割合がヨーロッパと比較にならないほど小さい河川は？(2つ)", "ナイル川、コンゴ川"], ["北部には何という新期造山帯？", "アトラス山脈"], ["南部には何という古期造山帯の山脈が分布している？", "ドラケンスバーグ山脈"], ["アフリカで忘れてはいけないのが、何という「広がる境界」？", "リフトヴァレー（アフリカ大地溝帯）"], ["リフトヴァレー沿いにある、標高が高い山は？", "キリマンジャロ山"], ["キリマンジャロ山の標高は何m？", "5,895m"], ["リフトヴァレー沿いでは、何が分布し、付近には何湖や何湖などが形成されている？", "火山、氷河、断層湖（タンガニーカ湖、マラウイ湖など）"], ["最初にアフリカの位置関係をしっかり把握して、赤道をマーカーで引っぱった時に、北緯何度と南緯何度の線をなぞってごらん！", "北緯35度と南緯35度"], ["赤道周辺は何の影響を年中受けるから何になる？", "赤道低圧帯、Af"], ["赤道からちょっと高緯度側に離れたら何になる？", "Aw"], ["緯度20～30度のあたりは、何の影響を受けるから何になる？", "亜熱帯高圧帯、BW～BS"], ["北端と南端は何だったよね？", "緯度35度"], ["北端と南端はほぼ何と同じ緯度なんだ。", "東京"], ["アフリカは北端と南端の緯度がほぼ同じだということから、何と何で南北ほぼ対称的に気候が分布している？", "赤道を挟んで"], ["アフリカには、何帯、何帯、何帯の順になっている？", "温帯、乾燥帯、熱帯"], ["北回帰線付近に広がる砂漠は？", "サハラ砂漠"], ["南回帰線付近に広がる砂漠は？", "カラハリ砂漠"], ["南西岸には寒流の何の影響で何砂漠が分布している？", "ベンゲラ海流、ナミブ砂漠"], ["リフトヴァレー沿いは隆起量が大きいので、何などの東部地域は海抜高度が高く、何が分布している？", "エチオピア～ケニア、Cw"]];break;;
  case "西アジアとアフリカ6" :item =[["北端と南端には何が分布している？", "Cs"], ["赤道に近い東アフリカのソマリア付近は何じゃなくて何が広がっている？", "AじゃなくてBW～BSの乾燥気候"], ["アフリカの人々の生活は、何アフリカと何アフリカでかなり異なっている？", "北アフリカと中南アフリカ"], ["サハラ以北の北アフリカは大部分が何気候で、古くから何や何農業が行われてきたんだ。", "乾燥気候で、遊牧やオアシス農業"], ["北アフリカは、何アフリカと呼ばれていて、住民はコーカソイドの何系で何人が使用され、何教徒が多いんだ。", "「ホワイトアフリカ」、アフリカ＝アジア系、アラブ人、アラビア語、イスラーム教徒"], ["サハラ以南の中南アフリカは、何が広がり、農業も何では焼畑など、何ではプランテーションが行われているのが特徴的だね。", "熱帯、コンゴ盆地、ギニア湾岸"],["コンゴ盆地では何など、ギニア湾岸などでは何などが特徴的？", "焼畑（キャッサバ・ヤムイモなどイモ類）、プランテーション（カカオ・油ヤシなど）"],["住民は何が多く、「何アフリカ」と呼ばれる？", "ネグロイド、「ブラックアフリカ」"], ["宗教は？", "祖先や自然を崇拝する伝統宗教やキリスト教、イスラームなど多様"], ["アフリカの国々は、ヨーロッパ諸国によって、長く何支配を受けてきたので、独立が遅かったんだよね？", "植民地支配"], ["第二次世界大戦前に独立をしていたのは、わずかに何カ国しかなく、どこ？", "４か国、エジプト、エチオピア、リベリア、南アフリカ共和国"], ["アフリカ北部・西部が中心の国は？", "フランス"], ["アフリカ東部が中心の国は？", "イギリス"], ["アフリカで、ベルギーの植民地だった国は？", "コンゴ民主共和国、ルワンダ、ブルンジ"], ["アフリカで、イタリアの植民地だった国は？", "リビア、ソマリア"], ["アフリカで、ポルトガルの植民地だった国は？", "アンゴラ、モザンビーク"], ["第二次世界大戦後に独立が相次ぎ、特に何年は「何」と呼ばれるほど多くの国が独立し、現在は何カ国？", "1960年は「アフリカの年」、54か国（西サハラのみ未独立）"], ["アフリカの国々は、何（何連合）を組織し、地域の経済発展を目指しているんだよ。", "AU（アフリカ連合）"],["アフリカは他の地域に比べ、何が遅れているよね。", "経済発展"], ["アフリカの気候で、熱帯雨林気候は何の記号？", "Af"],["アフリカの言語分布で、コンゴ盆地周辺は何語族？", "ニジェール＝コルドファン語族"]];break;;
  case "西アジアとアフリカ7" :item =[["北アフリカのエジプト、リビア、アルジェリアやギニア湾岸のナイジェリアにかけての地域は？", "カッパーベルト（Copper Belt：銅地帯）"], ["北アフリカと南部アフリカは比較的豊かだけど、何アフリカは発展が遅れている？", "中南アフリカ"], ["北アフリカは、何が多く、ヨーロッパへの出稼ぎやヨーロッパからの観光客も多いため、アフリカの中では比較的豊かな国が多い？", "産油国"], ["サハラ砂漠を中心に自然環境が厳しいけど、何は、外来河川の何を利用して古くから農業が発達していた？", "エジプト、ナイル川"], ["エジプトの人口、経済を支えているものは？", "約１億人、石油製品・天然ガス・原油など"], ["リビア、アルジェリアは何加盟国で、アフリカの中では1人当たりGNIも高いほうだよ", "OPEC加盟国"], ["西アフリカだが、何湾岸国では、夏の何の影響で雨も多く、何農業が発達しているよ。", "ギニア湾岸国、南西モンスーン、プランテーション農業"], ["コートジボワールは旧何領で、何（世界最大の生産国）と何の栽培が盛んだよ。", "フランス、カカオ、コーヒー"], ["ガーナは旧何領で何が重要？", "イギリス、カカオ"], ["ナイジェリアは何で、何加盟国でもあるんだ。", "アフリカ最大の人口大国（約２億1億人）、OPEC加盟国"], ["東部には何教徒、北部から西部には何教徒が多いんだ。", "キリスト教徒、イスラーム教徒"], ["東アフリカは高原状で、何がある", "リフトヴァレー"], ["東アフリカのエチオピアは、アフリカ最古の何（紀元前5世紀ごろ）で、ほとんど何支配を受けていない珍しい国だ。", "独立国、植民地支配"], ["エチオピアを建国したのは何に移住してきたコーカソイドだったんだよ。", "アラビア半島"], ["エチオピアは何教徒が多いところもアフリカでは異色だね。", "キリスト教"], ["エチオピアの国土の大部分は何高原で、何〜何が広がっているんだ。", "エチオピア高原, Aw〜Cw"], ["エチオピアは何の原産地でもあったよね。", "コーヒー"], ["エチオピアの1人当たりGNIは？", "821ドル"]];break;;
  case "西アジアとアフリカ8" :item =[["エチオピアの南にあるケニアも高原状の国で、何の下に位置しているため過ごしやすい？","赤道直下"],["ケニアの首都ナイロビ周辺の白人入植者の居住地域は何と呼ばれている？","ホワイトハイランド"],["インド洋に浮かぶ島国はどこ？","マダガスカル"],["マダガスカルの地形的に安定した陸塊は何？","安定陸塊"],["マダガスカルの国土の東岸の気候は何？(アルファベット2文字)","Af"],["マダガスカルで、東南アジアから移り住んできた人々は何系？","マレー系(オーストロネシア)"],["アフリカ最古の独立国とされている国はどこ？","エチオピア"],["ケニアの公用語は何と何？","英語とスワヒリ語"],["旧フランス領とされている国はどこ？","マダガスカル"],["アフリカ最大流域面積を有する河川は何？","コンゴ川"],["ザンビアにかけての地域で産出される鉱産資源は何？","銅"],["南アフリカ共和国の気候は主に何？(アルファベット2文字)","Bs"],["1991年に何という悪名高い法律が南アフリカ共和国で廃止された？","アパルトヘイト(人種隔離政策)"],["南アフリカ共和国内で、不毛の地は何と呼ばれている？","ホームランド"],["南アフリカ共和国内で、資源が豊富だとされているものは？(4文字)","石炭(古期造山帯)"]];break;;
  case "ヨーロッパ" :item =[["新期造山帯に属する山脈を3つ答えよ。", "ピレネー山脈、アルプス山脈、カルパティア山脈"],  ["バルト海沿岸からスウェーデン、フィンランド付近には何が広がっている？", "安定陸塊（バルト楯状地）"], ["フランス〜ドイツ〜ポーランドに広がる、かなり海抜高度が低くて、構造平野は何？", "パリ盆地"], ["構造平野（パリ盆地）には何が広範囲に分布？", "ケスタ"],["アイスランドは何帯、何帯に属す？(コンマ区切り)","新期造山帯, 安定陸塊"],["フィヨルドはどこの国にある？","ノルウェー"],["東ヨーロッパ平原はどこにある？","ロシア"],["イベリア半島にある主な山脈は何？","ピレネー山脈"]];break;;
  case "ヨーロッパ2" :item =[["安定陸塊、古期造山帯、新期造山帯のうち、ヨーロッパで最も面積が小さいのはどれか？", "古期造山帯"], ["ヨーロッパの大部分が属する気候帯は何か？", "冷帯(亜寒帯)"], ["北緯50度付近に広がる地形は何か？", "大陸氷河"], ["大陸氷河によって形成された地形を3つ答えよ。", "U字谷、フィヨルド、モレーン"], ["フランスの農業が盛んな理由として、適切でないものはどれか？\n1. 氷食を受けていない\n2. 土壌が肥沃である\n3. 温暖な気候である", "1. 氷食を受けていない"], ["スペイン北西部に発達する地形は何か？", "リアス海岸"], ["北海やバルト海に注ぐ河川の河口に発達しやすい地形は何か？", "エスチュアリー"], ["ライン川がエスチュアリーを形成しやすい理由を2つ答えよ。", "①流域面積が広い ②険しいアルプス山脈から流れるため"], ["地中海沿岸にみられる地形は何か？", "カルスト地形"], ["ヨーロッパで偏西風の影響を強く受ける地域はどこか？", "大陸西岸の緯度50～70度付近"], ["偏西風とともに、ヨーロッパの気候に影響を与える海流は何か？", "北大西洋海流"], ["ヨーロッパとユーラシア東部で、同じ緯度でも気候が異なる理由を説明せよ。", "ヨーロッパは偏西風と暖流の影響で温暖だが、ユーラシア東部は寒冷な気候になるため。"], ["ヨーロッパで、Cfb（西岸海洋性気候）が広い範囲に分布している理由を説明せよ。", "偏西風が内陸部まで入り込みやすく、高峻な山脈がほとんどないため。"], ["地中海沿岸地域に分布する気候は何か？", "Cs（地中海性気候）"], ["ノルウェーの西岸に分布する気候は何か？", "西岸海洋性気候"]];break;;
  case "ヨーロッパ3" :item =[["北極圏で夏季にみられる現象は何か？", "白夜"], ["スウェーデンやフィンランドなどの北部に広がる植生は何か？", "針葉樹林（タイガ）"], ["ノルウェーの伝統的な住居の特徴は何か？", "急勾配の屋根をもつ木造家屋"], ["イギリスやフランスなどの中部で、木造の住宅や木材の不足を補うために用いられる建築様式は何か？", "木骨づくりの家屋"], ["木骨づくりの家屋で、木材の間に用いられる材料は何か？", "石や土など"], ["スペインやギリシャなど地中海沿岸で多くみられる家屋の特徴は何か？", "豊富な石灰岩を利用した石づくりの家屋"], ["石づくりの家屋が多い理由を説明せよ。", "植生に乏しいことから、豊富な石灰岩を利用し、強い陽射しと暑さを避けるため。"], ["ヨーロッパに主に居住している語族は何か？", "インド=ヨーロッパ語族"], ["北西ヨーロッパに多い民族系統は何か？", "ゲルマン系"], ["南ヨーロッパに多い民族系統は何か？", "ラテン系"], ["東ヨーロッパからロシアにかけて多い民族系統は何か？", "スラブ系"], ["ルーマニア(Romania)が、「ローマ人の土地」という意味を持つ理由を説明せよ。", "ラテン系民族が居住しているため。"], ["フィンランドのフィン人や、スカンディナビア半島北部のサーミ人、ハンガリーのマジャール人が話す言語は、何語族に属するか？", "ウラル語族"]];break;;
  case "ヨーロッパ4" :item =[["ゲルマン系で主流の宗派は何か。", "キリスト教のプロテスタント(新教)"], ["ラテン系で主流の宗派は何か。", "キリスト教のカトリック(旧教)"], ["スラブ系で主流の宗派は何か。", "キリスト教のオーソドックス(東方正教)"], ["スラブ系のポーランドで信仰されている主な宗派は何か。", "カトリック"], ["クロアチア、スロベニア、ウラル系のハンガリーで信仰されている主な宗派は何か", "カトリック"], ["ケルト系のアイルランドで信仰されている主な宗派は何か。", "カトリック"], ["かつてバルカン半島に支配が及んでいた国はどこか。", "トルコ"], ["トルコの影響を受け、改宗した人々がいた宗教は何か。", "イスラム教"], ["アルバニアで信仰されている主な宗教は何か。", "イスラム教"], ["ボスニア・ヘルツェゴビナで信仰されている主な宗教は何か。", "イスラム教"], ["北西ヨーロッパに居住している主な民族系統とその宗派を答えよ。", "ゲルマン語派のプロテスタント"], ["南ヨーロッパに居住している主な民族系統とその宗派を答えよ。", "ラテン語派のカトリック"], ["東ヨーロッパに居住している主な民族系統とその宗派を答えよ。", "スラブ語派の正教徒"], ["東ヨーロッパで、一部イスラム教徒が多数を占める国もあるが、その理由を説明せよ。", "かつて、トルコ（オスマン帝国）の支配下にあったため。"]];break;;
  case "ヨーロッパ5" :item =[["第二次世界大戦後、ヨーロッパ諸国の国際的な地位はどうなったか？", "著しく低下した"], ["1952年、フランスの提唱により設立された組織は何か。", "ECSC(European Coal and Steel Community：ヨーロッパ石炭鉄鋼共同体)"], ["ECSC設立の目的は何か。", "加盟国間での石炭と鉄鋼の流通の自由化"], ["1958年に設立された、共同市場と経済統合を目標に掲げた組織は何か。", "EEC(European Economic Community：ヨーロッパ経済共同体)"], ["1958年に設立された、原子力産業の共同開発を推進する組織は何か。", "EURATOM(European Atomic Energy Community：ヨーロッパ原子力共同体)"], ["1967年、ECSC、EEC、EURATOMが統合して結成された組織は何か。", "EC(European Community：ヨーロッパ共同体)"], ["1993年、ECが発展して発足した組織は何か。", "EU(European Union：ヨーロッパ連合)"], ["EUの本部はどこに置かれているか。", "ブリュッセル"], ["2002年に導入が始まった、EUの共通通貨は何か。", "EURO(ユーロ)"], ["2004年以降の新しい加盟国でもEURO流通国は増えているか？", "増えている"], ["EC(現EU)は、経済統合に向かって具体的にどんなことをやってきたか、2つ答えよ。", "①域内関税の撤廃と対外共通関税の設定、②貿易の際の関税を廃止すること"], ["1993年にはEU域内での、人、物、資本、サービスの移動をどうすることを実現させたか？", "自由化"], ["人の移動の自由化について、EU加盟国のうちアイルランドを除く27か国では何が廃止されているか？", "国境管理（国境でのチェック）"], ["国境管理が廃止された協定を何というか。", "シェンゲン協定"]];break;;
  case "ヨーロッパ6" :item =[["EUの共通農業政策(CAP)の目的は？", "域内農産物に対して関税をかけないため、生産性の低い国の農業が成り立たなくなるのを防ぎ、主要な農産物に統一価格を定めて、国際価格より高い価格で農家から買い上げること。"], ["EU域内での人の移動を自由にする協定は？", "シェンゲン協定"], ["シェンゲン協定は何年に結ばれた？", "1985年"], ["シェンゲン協定が締結された場所は？", "ルクセンブルクのシェンゲン村"], ["EFTAとは何か？", "ヨーロッパ自由貿易連合"], ["EFTAは何年に設立された？", "1960年"], ["ECSC、EEC、EURATOMは何年に統合されてECになった？", "1967年"], ["ECがEUになったのは何年？", "1993年"], ["EUの共通通貨は？", "ユーロ(EURO)"], ["ユーロは何年に流通が開始された？", "2002年"], ["イギリスがEUを離脱したのは何年？", "2020年"], ["EUの立法機関は？", "ヨーロッパ議会"], ["EUの司法機関は？", "EU司法裁判所"], ["EUの金融政策を行う機関は？", "ヨーロッパ中央銀行"], ["EUの本部はどこにある？", "ブリュッセル"]];break;;
  case "ヨーロッパ7" :item =[["オランダで盛んな農業は？", "園芸農業"], ["オランダの園芸農業で主に栽培されているものは？", "チューリップなどの花卉や野菜"], ["デンマークで発達している農業は？", "酪農"], ["デンマークがかつて依存していた輸出物は？", "穀物"], ["デンマークで酪農と並んで発展している産業は？", "養豚業"], ["イギリスで行われている農業は？", "酪農と混合農業"], ["イギリスの主要な農産物は？", "小麦"], ["ドイツ北部で行われている農業は？", "混合農業"], ["ドイツ北部で混合農業とともに栽培されている作物は？", "ジャガイモ"], ["スペインで盛んな作物は？", "ジャガイモ"], ["フランスで「EUの穀倉」と呼ばれるほど生産量が多い作物は？", "小麦、トウモロコシ"], ["フランスの小麦の生産量は？", "世界最大級"], ["アルプス山中のスイスやオーストリアで行われている農業は？", "移牧"], ["イタリア、スペインなど地中海沿岸諸国で行われている農業は？", "地中海式農業"], ["地中海式農業で主に栽培される作物は？", "ブドウ、オリーブ、オレンジ類"]];break;;
  case "ヨーロッパ8" :item =[["ヨーロッパで最も農業人口率が低い国は？", "イギリス"], ["ヨーロッパで最も耕地率が高い国は？", "デンマーク"], ["ヨーロッパで最も牧場・牧草地率が高い国は？", "デンマーク"], ["ヨーロッパで最も森林率が高い国は？", "スウェーデン"], ["フランスの国土面積に対する耕地率は？", "34.6%"], ["フランスの国土面積に対する牧場・牧草地率は？", "17.5%"], ["フランスの国土面積に対する森林率は？", "31.5%"], ["農業従事者一人当たりの農地面積が最も大きい国は？", "フランス"], ["フランスで盛んな農業は？", "穀物(小麦, トウモロコシなど)輸出, ブドウ栽培"], ["ドイツで盛んな農業は？", "小麦,ライ麦,ジャガイモを組み合わせた混合農業, 豚の飼育"], ["イギリスで特徴的な農業は？", "小麦栽培,羊の飼育頭数はヨーロッパ最大"], ["デンマークで盛んな農業は？", "乳牛飼育と飼料栽培を組み合わせた酪農"], ["オランダで盛んな農業は？", "酪農と園芸農業"], ["イタリア北部(Cfa)で盛んな農業, 南部(Cs)で盛んな農業", "北部：混合農業, 南部:地中海式農業"], ["スペインで盛んな農業は？", "地中海式農業,オリーブの生産は世界最大"]];break;;
  case "ヨーロッパ9" :item =[["ヨーロッパの工業化を推進した国は？", "イギリス、ドイツ、フランスなど北西ヨーロッパ"], ["第二次世界大戦後、ヨーロッパの工業を支えた地域は？", "「重工業三角地帯」(北フランス、ルール、ロレーヌ)"], ["1960年代のエネルギー革命以降、中心的な工業は？", "従来の鉄鋼業から自動車、エレクトロニクスなどの機械工業や先端産業"], ["ヨーロッパ経済の中軸を占める、ロンドンからベネルクス三国、ライン川沿岸、北イタリアにかけての地域は？", "「ブルーバナナ」とか「ヨーロッパのメガロポリス」"], ["ドイツ、フランス、イギリスがヨーロッパでトップクラスの工業国である一方、あまり工業が発達していない地域は？", "地中海沿岸諸国"], ["イタリアやスペインで発展している産業は？", "自動車生産や高級服飾品など特色ある産業、特に服飾や家具など高いデザイン性と中小企業のネットワークをいかして伝統産業が発達する「サードイタリー」(第三のイタリア)"], ["北イタリアから南フランス、スペイン北東部のカタルーニャ地方にかけての地域で、先端産業や観光産業の発展が著しい地域は？", "「ヨーロッパのサンベルト」"], ["石油の産出が多いのは？", "北海油田があるノルウェー、イギリス"], ["天然ガスはどこの国での生産が多い？", "ノルウェー、オランダ、イギリス"], ["鉄鉱石を産出する国", "スウェーデン"], ["ノルウェーで盛んな工業", "アルミニウム（水力発電が盛ん）"], ["スウェーデンで盛んな工業", "自動車、鉄鋼（鉄鉱石が産出）"], ["フィンランドで盛んな工業", "製紙・パルプ（森林資源が豊富）"]];break;;
  case "ヨーロッパ10" :item =[["ヨーロッパで最も人口が多い国は？", "ドイツ"], ["ヨーロッパで最も面積が大きい国は？", "フランス"], ["ヨーロッパで一人当たりGNIが最も高い国は？", "ノルウェー"], ["ドイツの主要産業は？", "ライン川やルール川の水運とルール・ザールなどの石炭を利用した鉄鋼業、ルール地方(エッセン、ドルトムント)が最大の重工業地域、ミュンヘンを中心にエレクトロニクス"], ["フランスの主要産業は？", "北海沿岸(ダンケルク)、地中海沿岸(フォス)に鉄鋼業、パリ大都市圏では衣類や化粧品、トゥールーズ(航空機)"], ["イギリスの主要産業は？", "18世紀後半、世界で最初に産業革命(マンチェスター)、各地の炭田を背景にミッドランド地方(バーミンガムの鉄鋼、コヴェントリの自動車)やヨークシャー地方(リーズの毛織物),北海には油田,ガス田。ロンドン周辺は,先端産業"], ["イタリアの主要産業は？", "資源には乏しいが、北部の平野(ミラノ、トリノ、ジェノヴァ)を中心に工業,南北の経済格差が大。フィレンツェ、ボローニャ、ヴェネツィアなどの伝統的皮革・服飾産業が注目され、「第三のイタリア(サードイタリー)」"], ["スペインの主要産業は？", "工業化はやや遅れていたが、近年は、EU諸国企業の進出により自動車工業(カタルーニャ地方のバルセロナ)などが急速に発達。"], ["1990年前後の民主化革命以降、工業化を進めている東欧で、新しくEUに加盟した国々で成長を始めている国は", "ポーランド、チェコ、スロバキア、ハンガリー"], ["東欧の国々で発展の見られる産業", "自動車産業"]];break;;
  case "ロシアと周辺地域" :item =[["ロシアの国土面積は約何km²か？", "約1,700万km²"], ["ロシアの国土は、カナダ、アメリカ合衆国、中国の約何倍か？", "約2倍"], ["ロシアとヨーロッパ、シベリアを分ける境界線は何か？", "ウラル山脈"], ["ウラル山脈の西側は何と呼ばれる平原が広がっているか？", "東ヨーロッパ平原"], ["ヴォルガ川は何海に流れ込んでいるか？", "カスピ海"], ["ドニエプル川は何海に流れ込んでいるか？", "黒海"], ["ウラル山脈東側のシベリアで、北極海に流れ込んでいる大河を３つ答えよ", "オビ川、エニセイ川、レナ川"], ["東シベリアは安定陸塊に属する何と呼ばれる高原(卓状地)があるか？", "中央シベリア高原"], ["東シベリアの安定陸塊に属する山脈を2つ答えよ", "ヴェルホヤンスク山脈、カムチャツカ山脈"],["カムチャッカ半島には何が多いか？","火山"], ["西シベリアは何と呼ばれる低地(構造平野)が分布しているか", "西シベリア低地"],["ロシアと日本との関係で、近年何が望まれているか？", "経済交流の活性化"], ["ロシアのウクライナ侵攻により、何の問題が続いているか？", "北方領土問題"]];break;;
  case "ロシアと周辺地域2" :item =[["シベリアの河川は、下流部で約何年間凍結しているか？", "約半年間"], ["シベリアの河川では、いつ頃に融雪洪水が起こるか？", "初夏(6月ごろ)"], ["夏季、シベリアの河川は何として利用されるか？", "内陸水路"], ["河口付近では何日くらい、冬季の船舶航行は無理か？", "100日くらい"], ["冬季の船舶航行の代わりに何が利用されるか？", "自動車道路、臨時の滑走路"], ["地球温暖化による北極の氷の融解によって、何が利用しやすくなるという期待があるか？", "北極航路"], ["シベリアには何が分布しているか？", "永久凍土"], ["永久凍土とは何か？", "土壌の凍結層"], ["ロシアの半分近くが永久凍土の分布地域になるが、夏には比較的高温となるD（亜寒帯）気候地域では、年間を通して表層だけは凍結していない何という土壌が分布しているか", "ポドゾル"], ["北極海沿岸などのET（ツンドラ気候）地域では、夏季だけ表層がわずかに融解し、何などの湿性植物が繁茂しているか？", "コケ（蘚苔類）"], ["旧ソ連地域は東西に長いので、気候帯も東西に帯状に分布するが、北から順に見ると、北極海沿岸が何気候か？", "ET"], ["その南側に何気候が広く分布し、ウラル山脈以南の中央アジアは大部分が乾燥気候で、何気候が分布しているか？", "Df, BS・BW"], ["特に、レナ川の東にある北東シベリアは、冬季に何が発達するため、極寒の何気候が分布しているか。", "シベリア高気圧, Dw"],["北東シベリアは何と呼ばれるか", "「北半球の寒極」"]];break;;
  case "ロシアと周辺地域3" :item =[["エニセイ川以東の東シベリアではかなり南まで何が分布しているか？", "永久凍土"], ["永久凍土は何の大きな障害になっているか？", "シベリアの開発"], ["建物やパイプラインを新たに建設したりすると、何が溶けて建物が沈下してしまうか？", "永久凍土"],  ["工場や高層建築物などは何にするなどの工夫が行われているか？", "高床式"], ["近年は針葉樹の大量伐採により、地表に何が到達し、下層の永久凍土が融解することにより湿地ができ、そこから発生する何が地球温暖化を促進しているという問題点も指摘されているか？", "直射日光, メタンガス"],["古期造山帯で丘陵性の何はヨーロッパ＝ロシアとシベリアやアジアの境界線をなすか", "ウラル山脈"],["国土は全体的に低平で、ヨーロッパ＝ロシアや西シベリアには何が広く分布するが、東シベリアの太平洋岸には環太平洋造山帯に属する山脈群が南北に走る。", "構造平野"], ["気候は、北から何が帯状に分布するか。", "ET, Df, Dw, BS, BW"], ["偏西風の影響が少ないウラル以東のシベリアは何が優勢な東シベリアはDw（「北半球の寒極」）が分布している。", "シベリア高気圧"],["ロシア革命によって何年、世界で最初の社会主義国であるソ連（ソヴィエト社会主義共和国連邦）が成立したか", "1922年"],["ソ連解体後、何という12の共和国は、ロシアを中心としてCIS（独立国家共同体）を組織したか。（）は何を除くか", "バルト三国（エストニア、ラトビア、リトアニア）"],];
  case "ロシアと周辺地域4" :item =[["ロシアやその他の旧ソ連諸国は、現在何経済の国か？", "市場経済"], ["計画経済から市場経済へ十分な準備もないまま急激に変化したので、何が深刻になったか？", "社会の混乱、失業、インフレ、物資不足"], ["貧富の差を築く者もいる反面、以前より厳しい生活を強いられる者も出てきて何が拡大したか", "経済格差"], ["現在は、何や天然ガスの資源価格が高騰し、収入が増えたため、いつ頃から、高度成長が始まったか。", "1999年頃"], ["2008年に起こった何では大きな打撃を受けたか？", "世界同時不況"], ["何年の何侵攻で欧米などとの対立が激化し、経済は停滞しているか", "2022年のウクライナ侵攻"], ["ロシアの1人当たりGNIは何ドル（2021年）？", "11,960ドル"], ["ロシアの人口は約何億人（2022年）で、約何%がスラブ系ロシア人か？", "約1.45億人, 約80%"], ["ロシア語を話し、ラテン文字（アルファベット）とは異なる何文字を使用するか？", "キリル文字"], ["ロシア人は何を信仰している人が多いか？", "正教会（ロシア正教）"], ["シベリアの先住民は何系か？", "モンゴロイド"], ["ロシア,ウクライナ,ベラルーシ,バルト三国などでは何が生じたか", "自然減"],["中央アジアには、何系、何（）系、何教徒が多いか", "アルタイ（トルコ）系,イスラーム教徒"]];break;;
  case "ロシアと周辺地域5" :item =[["ソ連時代には、集団農場の何や国営農場の何が農業生産の中心だったか", "コルホーズ, ソフホーズ"], ["市場経済移行後は何経営（農業法人）や個人経営に変化しているか", "企業"], ["ソ連時代からある菜園つきの別荘地を何というか", "ダーチャ"], ["北極海沿岸には何が分布し、アジア系の先住民（モンゴロイド）などが何、何や何・狩猟生活を送っているか。", "ET, トナカイの遊牧, 漁労"], ["ヨーロッパ・ロシアでは、何や何、何などを栽培する何農業が行われているか。", "酪農, ライ麦, ジャガイモ, 混合"], ["ウクライナ〜カザフスタン〜ロシアの西シベリア南部にかけて、肥沃な何が分布していて、大規模な何栽培が行われているか。", "チェルノーゼム, 小麦"], ["中央アジアでは、大部分が何気候（何）だから、何などの何や何農業が行われているか。", "乾燥気候（BW〜BS）, 羊, 放牧, オアシス"], ["近年は灌漑によって何栽培が盛んになっているか", "綿花"], ["アラル海に注ぐ何川や何川から過剰に取水したため、何が縮小を招き、消失の危機にあるか。", "シルダリヤ川, アムダリヤ川, アラル海"], ["黒海とカスピ海の間は何地方と呼ばれるか", "カフカス地方"], ["カフカス地方は気候的に恵まれていて旧ソ連地域、ロシアと周辺諸国の中で何気候が分布しているか", "B〜Cなど温暖な気候"], ["ロシアは総何生産量が多くて、世界最大の輸出国に成長しているか", "穀物"], ["ロシアは何などの飼料作物はかなり多く輸入をしているか", "トウモロコシ"],["ロシアはエネルギー・鉱産資源が豊富で、何、何、何などの化石燃料の産出量が多く、自給率も高いか。", "石油, 天然ガス, 石炭"],["シベリアの何油田やヨーロッパ＝ロシアの何油田の産出が多いか", "チュメニ油田, ヴォルガ＝ウラル油田"],["その他の旧ソ連諸国でも、何沿岸（何油田）などは古くから油田開発が行われているか", "カスピ海沿岸（アゼルバイジャンのバクー油田）"]];break;;
  case "ロシアと周辺地域6" :item =[["世界最初の社会主義国家であるソ連は何年に解体し（何終結）、ロシア連邦など15の共和国となる。", "1991年, 東西冷戦終結"], ["計画経済から市場経済への急速な転換は、何、経済を混乱させ、生産力は落ち込むが、近年は徐々に回復する傾向にある。", "社会"], ["ロシア、ウクライナなどには何系で何教の正教を信仰する人が多いが、中央アジアを中心に何系何教徒も多数居住している。", "スラブ系, キリスト教, トルコ系イスラーム教徒"], ["農業地域は、気候帯に沿ってほぼ何状に分布し、北極海沿岸では何、ヨーロッパ＝ロシアでは何、混合農業が発達し、ウクライナから西シベリアにかけての何地帯には何農業地域が分布している。", "帯状, トナカイの遊牧, 酪農, チェルノーゼム, 小麦"], ["ソ連時代には何工業が中心で、コンビナート方式の工業地域が資源産地に多数立地していたが、資本や技術の不足により何（先端技術）などでは先進諸国に後れをとっている。", "重化学工業, ハイテク産業"],["ロシアと周辺諸国の大半は、何と何からなる", "安定陸塊と古期造山帯"],["太平洋沿岸やカフカス地域では、何や火山の活動もみられる", "地震"],["黒海北岸から東にのびる穀倉地帯の土壌は肥沃な何か", "チェルノーゼム"],["ロシアに接する海域は、何を除いて、冬の期間, 流氷や結氷によって閉ざされる", "黒海沿岸"],["永久凍土は、何地帯のみでなく何地帯にも分布している。", "ツンドラ地帯, タイガ地帯"]];break;;
  case "アングロアメリカ" :item =[["アングロアメリカとは、主にどこの国の人々が開拓した地域を指すか？","イギリス人"],["アングロアメリカの地形の話で、カナダ楯状地はどこからどこにかけて広がっているか？","五大湖からラブラドル半島"],["カナダ楯状地に多く分布している資源は何か？","鉄鉱石"],["東部のアパラチア山脈は何造山帯に属しているか？","古期造山帯"],["西部のロッキー山脈やシエラネバダ山脈は何造山帯に属しているか？","新期造山帯"],["アメリカ合衆国の太平洋側にあるカリフォルニア州付近は何という境界にあたるか？","ずれる境界"],["その境界にある、よく地震が発生する断層の名前は？","サンアンドレアス断層"],["ハワイ諸島は何によって生じた火山か？","ホットスポット"],["氷河によって削られた、深く入り組んだ湾を何というか？", "フィヨルド"],["アラスカやカナダの太平洋岸で、氷河が発達していた理由として、何の影響を挙げているか？","偏西風"],["五大湖は、何によって形成されたか？","大陸氷河"],["北アメリカ大陸東部、大西洋に面する山脈は？", "アパラチア山脈"],["北アメリカ大陸西部、太平洋に面する山脈は？", "ロッキー山脈"]];break;;
  case "アングロアメリカ2" :item =[["アメリカ合衆国の大西洋岸からメキシコ湾岸にかけて広がっている地形は？","海岸平野"],["安定陸塊に分類されるカナダ楯状地の特徴は？","鉄鉱石の埋蔵に恵まれる"],["古期造山帯に分類されるアパラチア山脈の特徴は？","石炭の埋蔵に恵まれる、丘陵性山地"],["新期造山帯に分類されるロッキー山脈、シエラネバダ山脈などの特徴は？","高峻な山脈が南北に連なる"],["アメリカ合衆国のほぼ中央部を通る、湿潤気候と乾燥気候の境界線は？","西経100度"],["西経100度線より東側の、プレーリーと呼ばれる地域に広がる気候は？","湿潤気候 (Df, Cfa など)"],["西経100度線より西側の、グレートプレーンズと呼ばれる地域に広がる気候は？","乾燥気候 (BS, BW)"],["グレートプレーンズで、年降水量500mmを境に東側と西側で行われている農業は？","東は企業的牧畜、西は企業的穀物農業"],["アメリカ合衆国本土で最も低緯度に位置する、熱帯に属する地域は？","フロリダ半島"],["フロリダ半島やメキシコ湾岸で発生する熱帯低気圧は？","ハリケーン"],["カナダから五大湖周辺で発生する、吹雪を伴う冷たい風は？","ブリザード"],["カナダから五大湖にかけての気候区分は？","Df（冷帯湿潤気候）"],["アメリカ合衆国の東半分の気候区分は？","Cfa（温暖湿潤気候）"],["アメリカ合衆国の西半分のうち、グレートベースンなどの気候区分は？","BW（砂漠気候）"],["アメリカ合衆国の西海岸側の、サンフランシスコなどの気候区分は？","Cs（地中海性気候）"],["アラスカがCfb（西岸海洋性気候）になっている要因は？","偏西風"],["アメリカ合衆国とカナダとの国境は、おおよそ何度か？","北緯49度"]];break;;
  case "アングロアメリカ3" :item =[["アメリカ合衆国の建国と発展の原動力となったのは、主にどこの地域からの移民か？","ヨーロッパ"],["15世紀のコロンプスのアメリカ大陸到達に始まり、主にどの国々がアメリカに入植したか？","イギリス、フランス、スペイン"],["イギリス領だった東部13州が、独立を果たすのは西暦何年か？","1783年"],["初期の開拓の中心となった、イギリス系白人を何と呼ぶか？","WASP (White Anglo-Saxon Protestant)"],["17世紀以降、プランテーション労働力として、主にどこから人々が移住させられたか？","アフリカ"],["近年、アメリカ合衆国への移民が増加しているのは、主にどの地域の人々か？","ヒスパニック、アジア系"],["ヨーロッパ系移住者は、主にアメリカのどこに植民地を建設したか？","大西洋岸"],["フランスは主にアメリカのどこを植民地化したか？","ミシシッピ川流域"],["スペインは主にアメリカのどこを植民地化したか？","フロリダ半島と西部"],["ルイジアナは何語起源の地名か？","フランス語"],["サンフランシスコは何語起源の地名か？","スペイン語"],["現在のアメリカ合衆国の人口は約何人か？","約3.4億人"],["アメリカ合衆国の人口のうち、多数派を占めるのは何系の人々か？","ヨーロッパ系白人"],["少数派民族集団（マイノリティ）には、どのような人々がいるか？","アフリカ系黒人、ヒスパニック、アジア系、先住民"],["2021年における、アメリカ合衆国への移民の出身国第1位は？","メキシコ"]];break;;
  case "アングロアメリカ4" :item =[["今でも1年間に何人近い移民を受け入れているか？","100万人"],["ヨーロッパ系白人は、アメリカ合衆国のどの地域で割合が高いか？","全域、特に北部や中西部"],["ハワイ州では、何系の人々の割合が高いか？","アジア系"],["アメリカ合衆国の広大な土地を所有する自作農が中心だった農業は、何によって無償で農地を得られたか？","ホームステッド法"],["アフリカ系黒人は、奴隷解放後もどこで暮らしていたか？","南東部のコットンベルト"],["中南米からの移住者であるヒスパニックは、主にどこの国境に近い地域に多く居住しているか？","メキシコ"],["フロリダ半島に多い、出身国の系統は？","キューバ系"],["ニューヨークに多い、出身国の系統は？","プエルトリコ系"],["太平洋側には、主にどこの国からの移民が多いか？","中国系、韓国系、東南アジア系、日系"],["1960年代に何という法律が成立し、移民法が改正されたか？","公民権法"],["アメリカ合衆国の大都市では、人種・民族・所得などによって何が進んでいるか？","住み分け（セグリゲーション）"],["一般に、インナーシティにはどのような人々が集中し、何を形成しているか？","黒人、ヒスパニック、スラム"],["新しく流入してきた移民は、何を形成することが多いか？","民族ごとの集団"],["異なる文化が共存しているアメリカ合衆国の社会を、何と呼ぶか？", "サラダボウル論"],["公民権法が施行されたのは西暦何年？","1960年代"]];break;;
  case "アングロアメリカ5" :item =[["アメリカ合衆国の大都市で、低所得層、郊外に中高所得層という構図を打破するために、何が起きているか？","ジェントリフィケーション"],["ジェントリフィケーションの有名な例は？","ニューヨークのハーレム"],["アメリカ合衆国は何と呼ばれているほど、農業が発達しているか？","世界の食料倉庫"],["アメリカ合衆国の農業地域区分で、年降水量500mmのラインが重要な意味を持つ理由は？","湿潤な東側では畑作、酪農、混合農業、園芸農業、乾燥した西側では牧畜"],["年降水量500mmの等雨量線付近のプレーリーからグレートプレーンズにかけては、何が分布しているか？","肥沃な黒色土（プレーリー土）"],["降水量が少ないグレートプレーンズでは、地下水を汲み上げ散水用のパイプを使って自動的に灌漑を行う方式は？","センターピボット方式"],["穀物の集荷・運搬・販売は何と呼ばれているか？","穀物メジャー"],["酪農地帯（デーリーベルト）は、主にどこの周辺に分布しているか？","五大湖沿岸"],["五大湖沿岸が酪農に適している理由は？","やや冷涼 (Df) で、氷食により土壌がやせている"],["コーンベルトでは、何が栽培され、何と何の飼育に利用されているか？", "トウモロコシ、大豆、肉牛"],["主な農産物の総生産量に占めるアメリカ合衆国の割合で、最も高いものは？","トウモロコシ"],["小麦の生産で、アメリカ合衆国は何位？","3位"],["アメリカ合衆国で、綿花の生産が盛んな地域は？","南部"],["アメリカ合衆国の農業の特徴は？","企業的な大規模経営、機械化、高い労働生産性"],["アメリカ合衆国の農業地域区分で、企業的穀物農業が行われている地域は？","春小麦地帯、冬小麦地帯"]];break;;
  case "アングロアメリカ6" :item =[["酪農地帯（デーリーベルト）で生産されるものは？","牛乳、チーズ、バターなどの乳製品"],["コーンベルトの中心となる作物は？","トウモロコシ、大豆"],["コーンベルトの農業の特徴は？","肉牛飼育（フィードロット）、養豚、商業的混合農業地域"],["春小麦地帯の主な立地条件は？","カナダにまたがるやや冷涼な地域"],["春小麦地帯の集散地は？","ミネアポリス"],["冬小麦地帯の主な立地条件は？","カンザス州を中心とする温暖なプレーリー"],["冬小麦地帯の集散地は？","カンザスシティ"],["コットンベルトの主な立地条件は？","温暖な南東部に立地"],["コットンベルトで、かつて行われていた農業は？","黒人奴隷を使用したプランテーション"],["コットンベルトで、現在問題となっていることは？","連作障害や土壌侵食"],["園芸農業が盛んな地域は？","大西洋岸のメガロポリス近郊"],["企業的牧畜が盛んな地域は？","年降水量500mm未満のグレートプレーンズ"],["地中海式農業が盛んな地域は？","太平洋岸の地中海性気候地域"],["地中海式農業で、灌漑設備が整えられている地域は？","シエラネバダ山系の融雪水を利用"],["地中海式農業で、大規模な機械化農業が行われている地域は？","カリフォルニア州"],["地中海式農業で、収穫は主に誰に依存しているか？","メキシコ（ヒスパニック）系の労働者"],["アメリカ合衆国の主な農産物の上位５州（2022年）で小麦の生産量が一位の州は？","カンザス"],["アメリカ合衆国の主な農産物の上位５州（2022年）でトウモロコシの生産量が一位の州は？","アイオワ"]];break;;
  case "アングロアメリカ7" :item =[["アメリカ合衆国の1次エネルギーの自給率は？","105.9% (2020年)"],["技術革新によって採掘が可能になった資源は？","シェールガス、シェールオイル"],["シェールガスやシェールオイルとは？","地中の頁岩に閉じ込められている天然ガスや原油"],["エネルギー自給率も以前よりだいぶ上昇している、アメリカ合衆国の経済を潤しつつあるものはなに？", "エネルギー、鉱産資源"],["石油の生産量はどの国が多い？","ロシア、サウジアラビア"],["石油はどこで産出される？","メキシコ湾岸、テキサス、アラスカ、カリフォルニア"],["石炭の生産量が多いのはどこの国？","中国"],["石炭はどこで産出される？","アパラチア炭田、西部のロッキー炭田"],["天然ガスの生産量が多いのは？","ロシア"],["天然ガスはどこで産出される？","メキシコ湾岸（メサビ）"],["鉄鉱石はどこで産出される？", "安定陸塊の五大湖沿岸"],["銅はどこで産出される？","西部の新期造山帯地域"],["20世紀にアメリカ合衆国は何として発展してきた？","世界最大の工業国"],["アメリカ合衆国で工業化が進展し、世界の経済をリードする存在となった地域は？","北東部のメガロポリスや五大湖沿岸"],["1950年代～1960年代にかけて、何が飛躍的な発展を遂げた？","鉄鋼、石油化学、自動車など重工業"],["1970年代はどこの国の工業化が進んだ？","日本"],["アメリカ合衆国の産業構造の転換を図る必要があった要因は？","技術革新が遅れ、賃金水準も高かったので、安くて優秀な日本やヨーロッパの製品に押され始めた"],["停滞する北東部や五大湖沿岸の古くからの工業地域（スノーベルト）ではなく、どこが発展した？","南部や西部のサンベルト"],["サンベルトで発展した産業は？","エレクトロニクスや航空宇宙産業"],["アメリカ合衆国の地域別工業生産額の変化で、1965年から2020年にかけて最も生産額の割合が増加した地域は？","南部"]];break;;
  case "アングロアメリカ8" :item =[["日本やヨーロッパの発展により、五大湖沿岸や東部の工業地域が停滞したのはわかるんだけど、どうして先端技術産業はどこに進出する必要があったの？", "サンベルト"],["先端技術産業にとって、サンベルトに進出するメリットは？","鉄鋼業などと異なり、資源立地の必要性はあまりない。南部には石油や天然ガスが豊富。広く安い用地、豊富で安い労働力（アフリカ系黒人やヒスパニックなど）、温暖で快適な気候が存在する。州政府などの行政による優遇措置もあった。"],["カリフォルニア州の何と呼ばれる地域が、アメリカ合衆国の経済の活力源となっている？","シリコンヴァレー"],["シリコンヴァレーの発展に寄与したものは？","コンピュータ、インターネットの開発"],["ニューイングランド地方の特徴は？","産業革命の発祥地で、最も古くからの工業地域。近年はボストンを中心にエレクトロニクスなど先端産業が発達（エレクトロニクスハイウェイ）。"],["アメリカ合衆国最大の都市ニューヨークの特徴は？","シリコンアレーやフィラデルフィア、ボルティモアなど大消費地をひかえ、各種工業が発達。臨海部には輸入鉄鉱を利用した製鉄所（スパローポイント）も立地。"],["中部大西洋岸の特徴は？","臨海部に輸入鉄鉱を利用した製鉄所（スパローポイント）も立地。"],["五大湖沿岸の特徴は？","五大湖周辺で産出する鉄鉱石（メサビ鉄山）とアパラチアの石炭を五大湖の水運で結びつけ、鉄鋼（ピッツバーグ）・自動車（デトロイト）などの重工業が発達。"],["南部地域では、何が発達している？","当初は、綿繰都市での綿工業やTVAによる原子力・アルミニウム工業程度しか発達していなかったが、現在は石油化学・航空宇宙産業（ヒューストン）、エレクトロニクス（ダラス～フォートワースにかけてのシリコンプレーン）などが発達。"],["太平洋岸の特徴は？","コロンビア川、コロラド川流域の開発による電力を利用して、シアトルやロサンゼルスには航空機工業が発達。サンフランシスコ郊外には、シリコンヴァレーと呼ばれる先端産業の集積地。"]];break;;
  case "アングロアメリカ9" :item =[["1990年代の情報通信技術革命を何というか？","ICT"],["ICTの中心となったものは何か？","コンピューター"],["コンピューターのCPUなどで世界基準となっている国はどこか？","アメリカ合衆国"],["アメリカ合衆国で、IT関連産業が世界市場に占めるシェアはどうなっているか？","大きい"],["アメリカ合衆国が再びパワーを取り戻した理由の一つとして、何が挙げられるか？","ICT"],["アメリカ合衆国で問題となっている、安価な製品を供給している地域はどこか？(3つ)","NIES、ASEAN、中国"],["アメリカ合衆国で、多くの企業が生産拠点を海外に移すことで何が起きているか？","産業の空洞化"],["2008年末の世界同時不況は何によって引き起こされたか？","世界金融危機"],["アメリカ合衆国が目指している「メイドイン〇〇の復活」とは？","メイドインアメリカ"],["ホームステッド法は何年に制定されたか？","19世紀"],["ホームステッド法で、開拓に従事した者に供与すると決められた土地の広さは？","約64ha"],["アグリビジネスとは何か？","農産物の集荷、貯蔵、運搬、販売などを独占的に行っている"],["穀物メジャーとは何か？","小麦などの穀物の流通を担っている多国籍企業"],["多文化主義とは何か？","それぞれの民族の文化を尊重しながら、調和していこうという考え方"],["アメリカ合衆国の総人口約3.4億人のうち、約60%を占めるのは何系か？","ヨーロッパ系白人"],["アフリカ系黒人は主にアメリカ合衆国のどの地域に居住しているか？","南東部"],["ヒスパニックは主にアメリカ合衆国のどの地域に居住しているか？","南西部"],["アメリカ合衆国は、世界の何ランキングで1位か？(3つ)","農業国、工業国、エネルギー資源の産出国"],["アメリカ合衆国で問題となっている産業は何か？","空洞化"]];break;;
  case "アングロアメリカ10" :item =[["カナダは、世界で何番目に広い国土を持つ国か？", "2番目"], ["カナダの大部分は何帯に属しているか？", "Df（冷帯）"], ["カナダの人口は約何万人か？", "約3,800万人"], ["カナダの先住民といえば何か？", "イヌイット"], ["カナダで最初に入植したのはどこの国の人々か？", "フランス人"], ["17世紀にフランスが植民地を建設したのはどこか？", "ケベック"], ["18世紀にカナダはどこの国の領土になったか？", "イギリス"], ["カナダの公用語は何か？(2つ)", "英語とフランス語"], ["カナダで、近年設立された準州の名前は？", "ヌナブト準州"], ["ヌナブト準州は何を意味するか？", "私たちの土地"], ["ケベック州で多数を占めるのは何系住民か？", "フランス系住民"], ["ケベック州で高まっている動きは何か？", "分離独立"], ["カナダの二大都市はどこか？(2つ)", "トロントとモントリオール"], ["モントリオールは何州にあるか？", "ケベック州"], ["カナダの首都はどこか？", "オタワ"], ["オタワは何年に首都になったか？", "2021年"], ["カナダが輸出できる資源は何か？","石油、天然ガス、ウラン"], ["カナダは何の自給率が高いか？","農産物や資源などの一次産品"],["1994年にアメリカ合衆国、メキシコと結成したのは何？","NAFTA（北米自由貿易協定）"], ["現在のNAFTAは何という名称か？","USMCA"]];break;;
  case "アングロアメリカ11" :item =[["アメリカ合衆国の主な貿易相手国で、輸出1位はどこか？(2022年)", "カナダ"], ["アメリカ合衆国の主な貿易相手国で、輸入1位はどこか？(2022年)", "中国"], ["カナダの主な貿易相手国で、輸出1位はどこか？(2022年)", "アメリカ"], ["カナダの主な貿易相手国で、輸入1位はどこか？(2022年)", "アメリカ"], ["メキシコの主な貿易相手国で、輸出1位はどこか？(2022年)", "アメリカ"], ["メキシコの主な貿易相手国で、輸入1位はどこか？(2022年)", "アメリカ"], ["アメリカ合衆国の主要輸出品目1位は何か？(2021年)", "機械類"], ["アメリカ合衆国の主要輸入品目1位は何か？(2021年)", "機械類"], ["カナダの主要輸出品目1位は何か？(2021年)", "原油"], ["カナダの主要輸入品目1位は何か？(2021年)", "機械類"], ["メキシコの主要輸出品目1位は何か？(2021年)", "機械類"], ["メキシコの主要輸入品目1位は何か？(2021年)", "機械類"], ["カナダの総人口は約何万人？", "約3,800万人"],["カナダで分離独立の動きがある州はどこか？", "ケベック州"], ["カナダ、アメリカ合衆国、メキシコの間で結成している協定は何か？", "USMCA（旧NAFTA）"]];break;;
  case "ラテンアメリカ" :item =[ ["西部内陸に多いのは何系白人か？", "ヨーロッパ系白人"], ["西部内陸に追いやられたのは誰か？", "アメリカインディアン"], ["南東部に多いのは誰か？", "黒人"], ["黒人はかつて何のために連れてこられたか？", "奴隷労働力"], ["南東部の何で、黒人の割合が高いか？", "コットンベルト"], ["メキシコと国境を接する南西部の州に多いのは誰か？", "ヒスパニック"], ["フロリダ州に多いのは何系か？", "キューバ系"], ["フロリダ半島は何に近いか？", "キューバ"], ["何年にアメリカ合衆国とキューバの国交回復という歴史的事件が起こったか？", "2015年"], ["ミシガン州を含む五大湖地方は、何が広がることで、冷涼な気候でも何が発達しているか？", "やせ地、酪農"],["アメリカ合衆国とカナダでよく出題される事柄は何に関する問題が多いか？","USMCA"]];break;;
  case "ラテンアメリカ2" :item =[["ラテンアメリカとは、メキシコ以南の何大陸を指すか？", "アメリカ大陸"], ["メキシコから南の地域を何と呼ぶか？", "南アメリカ"], ["西インド諸島は、何と何の間にあるか？", "北アメリカと南アメリカ"], ["中央アメリカと西インド諸島をまとめて何と呼ぶか？", "カリブ諸国"], ["中央アメリカは何の一部であるか？", "新期造山帯"], ["南米はかつて何大陸と一緒に一つの巨大な大陸を形成していたか？", "アフリカ、インド、オーストラリアなど"], ["その巨大な大陸の名前は何か？", "ゴンドワナランド"], ["南米の大部分は何であるか？", "安定陸塊"], ["ブラジル高原や北部の何などが安定陸塊か？", "ギアナ高地"], ["ブラジル高原の標高は高いところで何m、大半は何mか？", "1,000m, 300~500m"], ["ギアナ高地は何に囲まれたテーブルマウンテンがたくさんあるか？", "断崖絶壁"], ["太平洋側から何が沈み込んでいるので、大陸の西側は何になっているか？", "海洋プレート、新期造山帯"], ["新期造山帯に属する何山脈が南北に連なっているか。", "アンデス山脈"], ["南米は全体として何が低いので、多くの河川は大西洋側に流れているか？", "西高東低"], ["アマゾン川の河口は何川と合流しているか、地図で確認すべきことは何か？","オリノコ川、ラプラタ川、位置関係"], ["ラプラタ川の河口は何で、チリ南部には何があるか？", "エスチュアリー、フィヨルド"],["南米の太平洋岸沿いの海洋部分は何によって色が濃いか？", "海溝"], ["海溝は何の下に沈み込んでいて、何がアンデス山脈に沿って分布しているか？", "大陸プレート, 海溝"], ["南米の太平洋岸には何、何などが大陸に沿って分布しているか？", "ペルー海溝、チリ海溝"], ["チリ沖の地震で発生した津波はどこに大きな被害を与えたことがあるか？", "日本, 三陸海岸"],["エクアドルは何語で「赤道」のこと？", "スペイン語"],];
  case "ラテンアメリカ3" :item =[["ラテンアメリカで面積割合がとても大きい気候は何か？", "A気候"], ["赤道付近のアマゾン川流域は何が分布し、何が広がっているか？", "Af, 熱帯雨林のセルバ"], ["熱帯雨林では、多種類の何が何を形成しているか？", "常緑広葉樹、密林"], ["アマゾン川流域で育生している木の例を2つ答えよ", "ヤシ類、ゴム、マングローブ"], ["北半球側に分布している熱帯草原を何というか？", "リャノ"], ["南半球側に分布している熱帯草原を何というか？", "カンポ"], ["ブラジルの熱帯雨林地域では何を栽培しているか？", "キャッサバ"], ["ブラジルでは、輸出用の商品作物を栽培する何を何というか？", "大農園、プランテーション農業"], ["サバナ地域では、何の飼育頭数は世界一か？", "牛"], ["ブラジルは何を除いて大部分が何になるけど、その南側の何は何であるか？", "南部、熱帯、アルゼンチンの首都ブエノスアイレス"], ["アルゼンチンのブエノスアイレスは、東京とほぼ同緯度だが、大陸の何にあるから、東京と同じ何になるか？", "東岸、Cfa(温暖湿潤気候)"], ["ラプラタ川流域のCfa~BSの地域には、何と呼ばれる草原が広がっていて、肥沃な何土(何土と呼ばれるプレーリー土の一種)が分布しているんだ。", "パンパ、黒色、パンパ"], ["パンパでは、何や何などが大規模に行われている。", "混合農業, 企業的牧畜"], ["アルゼンチンは何で数少ない小麦の輸出地域", "南米"], ["チリ中部はなんという気候か？", "Cs(地中海性気候)"], ["チリ南部は何の影響を年中受ける何か？", "偏西風、Cfb(西岸海洋性気候)"], ["BW(砂漠気候)が分布する緯度20~30度付近の東西幅が狭く、海洋の影響を受けるから砂漠があまり発達していない大陸はどこか？", "ラテンアメリカ"], ["海岸部からチリ北部にかけての砂漠は何か？", "海岸砂漠(アタカマ砂漠)"], ["アルゼンチン南部のパタゴニアにも何があるか？", "砂漠(地形性砂漠)"], ["ペルー、ボリビアにいたる地域を何と呼ぶか？", "中央アンデス"], ["中央アンデスで栄えた文明は何か？", "インディオの文明(インカ文明)"], ["ペルー、チリ北部の海岸沿いには何が広がっているか？", "砂漠"], ["ペルー海流の影響で、何だけでなく、何も少ない気候だ。", "降水量, 気温"], ["アンデスの山岳地帯はいつの入植者も少なかったため、何が伝統的な生活を送っているか？", "ヨーロッパから, インディオ"]];break;;
  case "ラテンアメリカ4" :item =[["ラテンアメリカで大土地所有制による経営を何といいますか？", "プランテーション"],["特定農産物に依存する経済を何といいますか？", "モノカルチャー経済"],["モノカルチャー経済は、主に誰が持ち込んだ大土地所有制によって生まれましたか？", "スペイン人やポルトガル人"],["独立後、メキシコで何が解体されましたか？", "アシエンダ"],["ブラジルでは、何が解体され、農業の多角化が行われましたか？", "大農園"],["1970年代以降、日本のODAによる協力で、ブラジルで大規模な何に変化しましたか？", "大豆畑"],["1990年代以降、アメリカ合衆国の穀物メジャーは何を輸出していますか？", "大豆"],["サトウキビは世界の何%を生産していますか？", "約40％"],["牛の飼育頭数で、アメリカ合衆国に次いで世界第2位の国はどこですか？", "ブラジル"],["メキシコ湾岸で何が開発されていますか？", "石油"],["メキシコは何に加盟していませんか？", "OPEC"],["メキシコは何と何を結成しましたか？", "カナダとUSMCA"],["ブラジルとメキシコは何が豊富ですか？", "鉄鉱石"],["1990年代からは何政策を採ったため、輸出指向型工業への転換に成功しましたか？", "経済開放政策"],["サンパウロ、リオデジャネイロ、ベロオリゾンテなどの大都市はどこに集中していますか？", "南東部"],["近年、ラテンアメリカ有数の原油生産国になっているのはどこですか？", "リオデジャネイロ沖など"],["1995年に設立された何に注目すべきですか？", "MERCOSUR(南米南部共同市場)"],["MERCOSURに加盟している国はどこですか？", "ブラジル、アルゼンチン、ウルグアイ、パラグアイ"],["メキシコの主要輸出品は何ですか？", "機械類・自動車・自動車部品・原油・野菜・果物"],["ブラジルの主要輸出品は何ですか？", "鉄鉱石・大豆・原油・肉類・機械類"]];break;;
  case "ラテンアメリカ5" :item =[["アマゾン地方の開発が本格的に始まったのはいつですか？", "1960年代以降"],["ブラジルの首都をリオデジャネイロからどこに移転する計画がありましたか？", "ブラジリア"],["アマゾン川流域に指定された自由貿易地域は何ですか？", "マナオス"],["アマゾン横断道路は何と呼ばれていますか？", "トランスアマゾニアンハイウェイ"],["ラテンアメリカで、スペイン、ポルトガルの植民地支配を受けたため、共通して強い影響を受けている事柄は何ですか？", "言語(スペイン語, ポルトガル語), 宗教(カトリック)など"],["大土地所有制が残存し、特定の農産物などに依存する経済を何といいますか?", "モノカルチャー経済"],["メキシコ、ブラジルなどは、工業化の進展により何と呼ばれるようになりましたか？", "NIES"],["ブラジルでは大土地所有制の農牧場を何と呼びますか？", "ファゼンダ"],["アンデス諸国では大土地所有制の農牧場を何と呼びますか？", "アシエンダ"],["メキシコシティの大気汚染の原因は何ですか？", "プライメートシティ, 工場の排煙, 自動車の排ガスなど"],["メキシコシティの標高は何mですか？", "2,309m"],["メキシコの主な公用語は何ですか？", "スペイン語"],["キューバの主要輸出品は何ですか？", "サトウキビのプランテーション"],["ジャマイカの主要輸出品は何ですか？", "コーヒー栽培(ブルーマウンテン)"],["パナマの特色は何ですか？", "便宜置籍船国。パナマ運河。"],["ベネズエラの特色は何ですか？", "OPEC加盟の産油国。"],["ペルーの特色は何ですか？", "世界的な漁獲高。フィッシュミール、銅を輸出。"],["ボリビアの首都ラパスの標高は何m以上ですか？", "3,600m以上"],["チリの特色は何ですか？", "銅の産出は世界最大。OECD加盟国。"],["面積・人口(約2.2億人)がラテンアメリカの中で最大で、かつてはコーヒーのモノカルチャーであったが、近年、大規模な海底油田が開発され産油国になったのはどこですか？", "ブラジル"],["住民の大部分がヨーロッパ系白人で、ブエノスアイレスなどヨーロッパ風の都市を建設。パンパでは肥沃な黒色土に恵まれるため企業的穀物農業(小麦)や企業的牧畜(牛・羊)を行ったのはどこですか？", "アルゼンチン"]];break;;
  case "オセアニア" :item =[["オセアニアは何と何を含めた地域を指すか","オーストラリア大陸とニュージーランド、その他の太平洋の島々"],["Oceaniaとは何か","オセアニアを英語で表現したもの"],["オーストラリア大陸の東岸に南北に走る山脈は何か","グレートディバイディング山脈"],["オーストラリアの北東部の海岸に広がる世界最大のサンゴ礁群は何か","グレートバリアリーフ"],["ニュージーランドは何に属するか","大部分が新期造山帯"],["フィヨルドランドがあるのはどこか","ニュージーランドの南島南西岸"],["ミクロネシアとはどういう意味か","小さい島々"],["メラネシアとはどういう意味か","黒い島々"],["ポリネシアとはどういう意味か","多い島々"],["ミクロネシアの島国のうち、りん鉱石を産出する国はどこか","ナウル"],["パプアニューギニアは何を産出するか","銅"],["フランス領で、ニッケルを産出するところはどこか","ニューカレドニア"],["フランス領ポリネシアに含まれる島はどこか","タヒチなど"]];break;;
  case "オセアニア2" :item =[["オセアニアには独立国がいくつあるか", "16"], ["オセアニアの地域人口は約何人か", "約4,400万人"], ["オセアニアの人口の約70%を占める2か国はどこか", "オーストラリアとニュージーランド"], ["オーストラリアのクリスマスは何月か", "12~1月"], ["オーストラリア大陸のほぼ中央部を通る線を何というか", "南回帰線"], ["オーストラリアで、乾燥気候(B)の割合が高いことから何大陸と呼ばれているか", "乾燥大陸"], ["オーストラリアの内陸になるほど降水量はどうなるか", "少なくなる"], ["オーストラリア大陸の北部は、最も低緯度にあることから何気候か", "熱帯気候"], ["オーストラリアの東岸に分布する気候は", "Cfa(温暖湿潤気候)"], ["オーストラリアの南西岸に分布する気候は", "Cs(地中海性気候)"], ["オーストラリアの南東部に位置し、二大都市が立地しているのは何と何か", "シドニーとメルボルン"], ["ニュージーランドの大部分は何気候に属しているか", "西岸海洋性気候(Cfb)"], ["オセアニアの島嶼部は主に何気候に属しているか", "熱帯気候"]];break;;
  case "オセアニア3" :item =[["オーストラリアの先住民を何と呼ぶか", "アボリジニー"], ["18世紀末からオーストラリアに入植してきたのは誰か", "イギリス人をはじめとするヨーロッパ系の人々"], ["ゴールドラッシュに代表されるものは何か", "鉱産資源の発見"], ["有色人種の移民を制限する政策を何というか", "白豪主義"], ["1970年代にオーストラリアは何に加盟したか", "EC(現EU)"], ["白豪主義が撤廃されたのは何年代か", "1970年代"], ["移民の出身地の文化を尊重していこうという政策を何というか", "多文化主義"], ["2000年のシドニーオリンピックの最終聖火ランナーは誰か", "アボリジニーの選手"], ["ニュージーランドの先住民を何と呼ぶか", "マオリ"], ["ニュージーランドの人口は約何万人か", "約510万人"],["ニュージーランドの総人口の1割以上は何系住民か", "マオリ系"],["ニュージーランドの公用語は何か", "英語とマオリ語"],["オーストラリアもニュージーランドも主な産業は何か", "農業"],["オーストラリアの主な上位輸出品は何か", "石炭、鉄鉱石、液化天然ガス"],["ニュージーランドの輸出品は何か", "酪農品、肉類、木材、野菜・果実など"]];break;;
  case "オセアニア4" :item =[["1人当たりGNIが高いのはどこか", "オーストラリア"], ["オーストラリアとニュージーランドは何に加盟しているか", "OECD"], ["オーストラリアで、牧羊はどこを中心に行われているか", "グレートアーテジアン盆地やマリー・ダーリング盆地"], ["グレートアーテジアン盆地は何に恵まれているか", "被圧地下水"], ["被圧地下水を利用して何が行われているか", "掘り抜き井戸を利用した地下水汲み上げ"], ["羊や牛の飲み水に、地下水が適していない理由は何か", "地下水の塩分濃度が高いため"], ["良質な羊毛がとれる羊の品種は何か", "メリノ種"], ["マリー・ダーリング盆地を流れる川は何か", "マリー川やダーリング川"], ["マリー川やダーリング川の水は何に利用されているか", "灌漑"], ["オーストラリアは何の生産・輸出国として重要か", "小麦"], ["乳牛飼育を中心とする酪農はどこで発達しているか", "南東部の大都市（シドニー、メルボルン）周辺"], ["フィードロットが行われているのはどこか", "北東部"], ["北東部(Am、Cw)には何があるか", "プランテーション農業として発達したサトウキビ栽培地域"], ["ニュージーランドの農業はどのような気候環境か", "全土が温暖湿潤なCfb(西岸海洋性気候)"], ["ニュージーランドで盛んな家畜は何か", "牧羊"], ["ニュージーランドで、より湿潤な北島に多い家畜は何か", "乳牛"]];break;;
  case "オセアニア5" :item =[["オーストラリアで、石炭や鉄鉱石の産出が盛んな地域はどこか", "東部の古期造山帯地域"], ["オーストラリアで、ボーキサイトの産出が盛んな地域はどこか", "北部の熱帯地域"], ["鉄鉱石の採掘が盛んな、オーストラリアの代表的な鉱山はどこか", "マウントホエールバック(マウントニューマン)"], ["オーストラリアで、世界最大級の輸出量を誇る鉱産資源は何か", "石炭と鉄鉱石"], ["ニュージーランドは、日本と何が似ているか", "新期造山帯に属する"], ["ニュージーランドで盛んな工業は何か", "アルミニウム工業"], ["ニュージーランドでアルミニウム工業が発達している理由は何か", "水力発電が盛ん"], ["ニュージーランドの水力発電の割合は", "54.3%"], ["ニュージーランドの地熱発電の割合は", "18.9％"], ["ニュージーランドの火力発電の割合は", "18.5%"], ["ナウルで産出されていたものは何か", "りん鉱石"], ["パプアニューギニアの特産品は", "銅、原油などの鉱産資源や林産資源が豊富。"], ["フィジーの特産品は", "先住のメラネシア系住民とインド系との対立。サトウキビ。"], ["ニューカレドニア(フランス領)の特産品は", "ニッケルなど鉱産資源が豊富。"], ["フランス領ポリネシアの特産品は", "タヒチ島は観光業が発展。"]];break;;
  case "日本" :item =[["日本列島は何の「せばまる境界」付近に形成された弧状列島か", "プレート"], ["日本列島は何によって生じた火山や褶曲山脈などの集まりか", "環太平洋造山帯"], ["日本は、世界の4枚のプレートがひしめきあう場所にあるため、どのような地域か", "地震や火山活動も非常に活発で自然災害も多い"], ["日本は、温泉による観光・保養地も多く発達しているが、何にも利用されているか", "地熱発電"], ["日本の国土の大部分は何プレートの上にあるか", "北アメリカプレートとユーラシアプレート"], ["フォッサマグナとは何か", "二つのプレートの境界"], ["フォッサマグナより東の地域と西の地域を分けるものは何か", "東北日本と西南日本"], ["西南日本を外帯と内帯に分けているものは何か", "諏訪湖付近で糸魚川・静岡構造線と交わる中央構造線(メディアンライン)"], ["外帯の山地は、内帯に比べてどうなっているか", "丘陵や高原状の緩やかな山地が多い"]];break;;
  case "日本2" :item =[["日本の国土は、山地の占める割合がどうなっているか", "高い(約60%)"], ["日本の国土で、山地に丘陵を加えると何%になるか", "70%"], ["系統地理分野で勉強した、扇状地、三角州や(洪積)台地のことを何と呼ぶか", "地形"], ["ケッペンの気候区分では、日本の大部分は何になるか", "温暖湿潤気候(Cfa)"], ["ケッペンの気候区分で、北海道は何になるか", "亜寒帯湿潤気候(Df)"], ["ユーラシア大陸の東岸に位置していて、北端が北緯45度、南端が北緯20度である日本は何の影響を受けるか", "夏は南東季節風、冬は北西季節風"], ["熱帯地域とは違って、日本では何が明瞭か", "四季の変化"], ["東日本では、秋に何による雨が多いか", "秋雨(秋霖)"], ["太平洋側と日本海側では、冬の天候に大きな違いがみられるが、何と何の影響が大きいか", "東北、北陸、山陰の日本海側では、シベリア高気圧(シベリア気団)からの季節風"], ["日本海側で、冬に多量の降水や降雪をもたらすのはなぜか", "日本海上で水蒸気を供給され(暖流の対馬海流の影響)"], ["太平洋側が山越えした乾燥風が吹き込むので、晴天が多くなるのはいつか", "冬"], ["フォッサマグナの付近は、大陸プレートどうしの境界で、特に何が大きいか", "糸魚川=静岡構造線付近は隆起量が大きく、西側には「日本アルプス」(飛騨山脈、木曽山脈、赤石山脈)と呼ばれる3,000m級の山々が南北に連なっている"], ["日本は、何に属しているから、とても山がちか", "新期造山帯"], ["壮年期の険しい山が多いのはなぜか", "降水量が多いから、河川の侵食、運搬、堆積作用も活発"]];break;;
  case "日本3" :item =[["日本の代表的な気圧配置図で、冬に特徴的な気圧配置は何か？","西高東低"],["主に吹く風の方向で冬は何色で示されているか？","青"],["梅雨前線が停滞するのは、主に何気団と何気団の間か？","オホーツク海気団と小笠原気団"],["夏に、北太平洋（小笠原）高気圧の北上により、何をもたらすか？","高温となり晴天"],["秋に、秋雨（秋霖）前線の停滞や何が近づき、長雨や大雨をもたらすか？","台風"],["シベリア高気圧（シベリア気団）が発達し、低温で乾燥した何が日本列島に吹き込むか？","北西季節風"],["都市型災害とは何か？","都市化の進展によって従来あまり利用されていなかった後背湿地や河口付近の低湿地などの開発も進んだことによって起こる災害"],["舗装化によって地面を人工物で覆うと、何が起こりやすくなるか？","集中豪雨"],["日本は、何と呼ばれる環太平洋造山帯に属する弧状列島か？","火山や地震が多い"],["日本は、何という4つのプレートの境界付近に位置しているか？","ユーラシアプレート、北アメリカプレート、太平洋プレート、フィリピン海プレート"],["日本の大部分は何気候に属し、北海道は何気候に属しているか？","Cfa、Df"],["夏のオホーツク海高気圧が強いと、北海道から東北地方の太平洋側では冷涼・湿潤な何が吹くか？","やませ"]];break;;
  case "日本4" :item =[["日本の人口ピラミッドは、明治の初めには何型だったか？", "富士山型"], ["第1次ベビーブームは何年か？", "1947年～1949年"], ["第2次ベビーブームは何年か？", "1971年～1974年"], ["2023年の合計特殊出生率はいくつか？", "1.20"], ["2005年には何がマイナスになったか？", "自然増減率"], ["2040年には、日本の人口の約何分の1が高齢者になると予測されているか？", "3分の1"], ["1950年代後半から1960年代の高度経済成長期に、人口が流入したのは主にどこの三大都市圏か？", "東京、大阪、名古屋"], ["1970年代の石油危機以降、都市から地方への人口移動は何現象と呼ばれるか？", "Uターン現象"], ["2015年～2020年には、人口が増加したのは8都県だが、それはどこか？", "沖縄・東京・埼玉・愛知・神奈川・福岡・滋賀・千葉"], ["2022年～2023年に人口増加率が上位の都道府県はどこか？", "東京"], ["都心部の昼間人口比率（昼間人口/夜間人口×100）は、何に注意して見るべきか？", "とても高い"]];break;;
  case "日本5" :item =[ ["住民基本台帳人口による上位20市と東京23区で最も人口が多いのはどこか？", "東京23区"], ["図9で、過疎地域の全国に占める割合で最も大きいのは何か？", "市町村数"], ["都道府県別の人口増加率で、0.0～1.0の範囲を示している色は何色か？", "水色"], ["ベビーブームとは何か？", "一時的な出生数の急増現象"], ["Uターン現象とは何か？", "大都市から地方への人口移動現象"], ["日本の総人口は約何億人か？", "約1.2億人"], ["2023年の合計特殊出生率はいくらか？", "1.20"], ["2021年の老年人口率は何％か？", "28.9%"], ["1950年代後半～1960年代の高度経済成長期に、人口集中が進んだのは主にどこか？", "三大都市圏"], ["近年、何によって都心回帰が生じているか？", "不況による地価の下落"]];break;;
  case "日本6" :item =[["日本の農地の内、農業に適した平野の割合は約何%か？","12%"],["家族労働中心で、零細経営の農家が多い。農業従事者一人当たりの農地面積は欧米と比べてどうか？","狭い"],["日本の農業従事者一人当たりの農地面積は約何haか？","2.0ha"],["日本の農業は、他の産業より労働生産性が高いか低いか？","低い"],["1962年と2020年の米の1人当たり年間消費量を比べると、どう変化しているか？","減少"],["1970年頃から、米に関してどのような政策が行われたか？","生産調整"],["1995年、米の輸入に関して何が始まったか？","部分自由化（ミニマムアクセス）"],["1999年、米の輸入に関して何が行われたか？","関税化"],["1995年に施行された、食料の流通に関する新しい法律は何か？","新食糧法"],["輸入が自由化されると、何が下がっていくと予想されるか？","食料自給率"],["表日本の2021年の穀類の自給率はおよそ何%か？","29％"],["2021年の日本の野菜の自給率はおよそ何%か？","80％"],["日本より、肉類の自給率が低い国はどこ？","オランダ"]];break;;
  case "日本7" :item =[["1991年に輸入自由化が行われたものは何か？","牛肉とオレンジ類"],["日本の食料自給率の特徴は？","先進国の中で最も低い水準"],["日本は何を大量に輸入しているため、食料の輸入大国と言われているか？","飼料"],["TPPとは何か、正式名称で答えよ","環太平洋経済連携協定"],["農業産出額の割合が最も高い地域はどこか？","北海道"],["東北地方の米の産出額割合はいくらか？","26.7%"],["関東・東山地方の野菜の産出額割合はいくらか？","29.7%"],["沖縄地方の畜産の産出額割合はいくらか？","45.6％"],["日本の森林の約何％が人工林か？","約40％"],["日本は木材の約何％を輸入に頼っているか？","約60％"],["2021年のエビの主な輸入先はどこか？（上位3つ）","インド、ベトナム、インドネシア"], ["2021年のマグロの主な輸入元はどこか？（上位3つ）","台湾、中国、韓国"],["日本はエネルギー資源について、自給率は高いか？","低い"],["1970年代の石油危機以後、日本は何の利用に積極的に取り組んでいるか？","原子力発電"],["コージェネレーションシステムとは何か？","電力を供給するとともに、発生する排熱も有効に利用するシステム"],["重油やLNGを燃料として発電する方法は？","火力発電"]];break;;
  case "日本8" :item =[["第二次世界大戦前、日本は発展途上国レベルの工業化だったが、主な工業製品は何だったか？","繊維品"],["第二次世界大戦後、急速に工業化が進み、1950年代後半から1960年代にかけての高度経済成長期には、何などの重化学工業が基幹産業になっていったか？（３つ以上）","鉄鋼、石油化学、造船"],["1970年代の石油危機以降、資源を大量に消費するタイプの産業は何業種となったか？","不況業種"],["1980年代後半から、何の影響（輸出が不利になる）により生産費が上昇したか？","円高"],["コストダウンを図る目的で、どこへ生産拠点が移動していったか？（３つ以上）","アジアNIES、ASEAN、中国"],["アメリカ合衆国など先進国との間で何が生じたため、日本企業は何をするようになったか？","貿易摩擦、現地に日本企業を設立"],["製造業における大規模事業所と中小規模事業所の割合は？","大規模1.6%、中小98.4%"],["製造業における大企業の割合は？","51.1％"],["1930年の日本の工業製品の出荷額で最も割合が大きいものは何か？","繊維"],["2020年の日本の工業製品の出荷額で最も割合が大きいものは何か？","輸送機械"],["1970年から2022年にかけて、日本の自動車の輸出と現地生産はどのように変化したか？","輸出はほぼ横ばい、現地生産は増加"],["1980年の3大工業地帯の工業出荷額の全国比（%）は合計でいくらか？","43.3"],["2020年の京浜工業地帯の工業出荷額は全国の何%か？","7.6"],["2020年の主要工業地域で、工業出荷額が一番多い地域は？","京葉"]];break;;

    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    // case "" :item =
    //




  }print(item);if(widget.name == "英単語" || widget.name == "英熟語"){aa();}
   }
   
   void aa (){
     switch (widget.name2) {
     case "中学英語1":
     item = [
     {"word": "time", "meaning": "時間", "example": "ドラえもんはいつも未来に行くための時間旅行をしている。", "translation": "Doraemon always travels through time to go to the future."},
     {"word": "journalist", "meaning": "ジャーナリスト", "example": "ドラえもんがジャーナリストだったら、未来の出来事を記事にするだろう。", "translation": "If Doraemon were a journalist, he would write articles about future events."},
     {"word": "reach", "meaning": "届く", "example": "ドラえもんはどこでもドアでどこにでも簡単に届く。", "translation": "Doraemon can easily reach anywhere with the Anywhere Door."},
     {"word": "lunch", "meaning": "昼食", "example": "ドラえもんとのび太はいつも一緒に昼食を食べる。", "translation": "Doraemon and Nobita always have lunch together."},
     {"word": "orange", "meaning": "オレンジ", "example": "ドラえもんの好きな食べ物はどら焼きとオレンジだ。", "translation": "Doraemon's favorite foods are dorayaki and oranges."},
     {"word": "camera", "meaning": "カメラ", "example": "ドラえもんは未来のカメラで色々な写真を撮る。", "translation": "Doraemon takes various pictures with a camera from the future."},
     {"word": "earth", "meaning": "地球", "example": "ドラえもんは地球の平和を守るために戦う。", "translation": "Doraemon fights to protect the peace of the Earth."},
     {"word": "trick", "meaning": "いたずら", "example": "ドラえもんの道具は時々いたずらに使われる。", "translation": "Doraemon's gadgets are sometimes used for tricks."},
     {"word": "knee", "meaning": "ひざ", "example": "ドラえもんは転んでひざを擦りむいた。", "translation": "Doraemon fell down and scraped his knee."},
     {"word": "did", "meaning": "した", "example": "ドラえもんは宿題を手伝ってくれた。", "translation": "Doraemon did help me with my homework."}
     ];
     break;
     case "中学英語2":
     item = [
     {"word": "crayon", "meaning": "クレヨン", "example": "ドラえもんは秘密道具でクレヨンを作ることができる。", "translation": "Doraemon can make crayons with his secret gadgets."},
     {"word": "pool", "meaning": "プール", "example": "ドラえもんと友達はよく家のプールで遊ぶ。", "translation": "Doraemon and his friends often play in the pool at home."},
     {"word": "musician", "meaning": "音楽家", "example": "もしドラえもんが音楽家なら、未来の音楽を演奏するだろう。", "translation": "If Doraemon were a musician, he would play future music."},
     {"word": "hour", "meaning": "時間", "example": "ドラえもんの道具は時間を自由に変えられる。", "translation": "Doraemon's gadgets can change time freely."},
     {"word": "member", "meaning": "メンバー", "example": "ドラえもんはいつも友達のメンバーと一緒に冒険をする。", "translation": "Doraemon always goes on adventures with his group of friends."},
     {"word": "understand", "meaning": "理解する", "example": "ドラえもんはのび太の気持ちをよく理解している。", "translation": "Doraemon understands Nobita's feelings very well."},
     {"word": "reduce", "meaning": "減らす", "example": "ドラえもんは道具でゴミを減らすことができる。", "translation": "Doraemon can reduce garbage with his gadgets."},
     {"word": "president", "meaning": "大統領", "example": "もしドラえもんが大統領なら、世界は平和になるだろう。", "translation": "If Doraemon were the president, the world would be at peace."},
     {"word": "ship", "meaning": "船", "example": "ドラえもんはタイムマシンで船に乗って過去へ行く。", "translation": "Doraemon travels to the past by ship using his time machine."},
     {"word": "carpenter", "meaning": "大工", "example": "ドラえもんが大工なら、色々なものを自分で作るだろう。", "translation": "If Doraemon were a carpenter, he would make various things by himself."}
     ];
     break;
     case "中学英語3":
     item = [
     {"word": "care", "meaning": "世話", "example": "ドラえもんはのび太の世話をよくしている。", "translation": "Doraemon takes good care of Nobita."},
     {"word": "worry", "meaning": "心配", "example": "ドラえもんはいつも友達の心配をしている。", "translation": "Doraemon is always worried about his friends."},
     {"word": "mouth", "meaning": "口", "example": "ドラえもんの口から色々な道具が出てくる。", "translation": "Various gadgets come out of Doraemon's mouth."},
     {"word": "study", "meaning": "勉強", "example": "ドラえもんはのび太に勉強を教える。", "translation": "Doraemon teaches Nobita how to study."},
     {"word": "mistake", "meaning": "間違い", "example": "ドラえもんも時々間違いをすることがある。", "translation": "Doraemon sometimes makes mistakes too."},
     {"word": "condition", "meaning": "状態", "example": "ドラえもんは友達の体の状態をチェックする。", "translation": "Doraemon checks the physical condition of his friends."},
     {"word": "fly", "meaning": "飛ぶ", "example": "ドラえもんはタケコプターで空を飛ぶ。", "translation": "Doraemon flies in the sky with the Takecopter."},
     {"word": "favorite", "meaning": "お気に入り", "example": "ドラえもんのお気に入りはどら焼きだ。", "translation": "Doraemon's favorite is dorayaki."},
     {"word": "stay", "meaning": "滞在する", "example": "ドラえもんはのび太の家に長く滞在している。", "translation": "Doraemon has been staying at Nobita's house for a long time."},
     {"word": "carry", "meaning": "運ぶ", "example": "ドラえもんは重いものを道具で運ぶ。", "translation": "Doraemon carries heavy things with his gadgets."}
     ];
     break;
     case "中学英語4":
     item = [
     {"word": "similar", "meaning": "似ている", "example": "ドラえもんとロボットの友達は性格が似ている。", "translation": "Doraemon and his robot friends have similar personalities."},
     {"word": "without", "meaning": "～なしで", "example": "ドラえもんは道具なしでも、のび太を助けようとする。", "translation": "Even without his gadgets, Doraemon tries to help Nobita."},
     {"word": "until", "meaning": "～まで", "example": "ドラえもんは、みんなが笑顔になるまで頑張る。", "translation": "Doraemon keeps trying until everyone smiles."},
     {"word": "mind", "meaning": "気にする", "example": "ドラえもんは小さなことを気にしない。", "translation": "Doraemon doesn't mind small things."},
     {"word": "also", "meaning": "～もまた", "example": "ドラえもんもまた、みんなと同じように遊ぶのが好き。", "translation": "Doraemon also likes to play just like everyone else."},
     {"word": "event", "meaning": "イベント", "example": "ドラえもんは色々なイベントで活躍する。", "translation": "Doraemon plays an active role in various events."},
     {"word": "though", "meaning": "～だけれど", "example": "ドラえもんはロボットだけれど、心を持っている。", "translation": "Though Doraemon is a robot, he has a heart."},
     {"word": "adventure", "meaning": "冒険", "example": "ドラえもんはいつも楽しい冒険にでかける。", "translation": "Doraemon always goes on fun adventures."},
     {"word": "lead", "meaning": "導く", "example": "ドラえもんはいつも友達を良い方向へ導く。", "translation": "Doraemon always leads his friends in a good direction."},
     {"word": "grandma", "meaning": "おばあさん", "example": "ドラえもんはのび太のおばあさんのことも大切に思っている。", "translation": "Doraemon also cares for Nobita's grandma."}
     ];
     break;
     case "中学英語5":
     item = [
     {"word": "beautiful", "meaning": "美しい", "example": "ドラえもんは、美しい景色を見るのが好き。", "translation": "Doraemon likes to see beautiful scenery."},
     {"word": "nervous", "meaning": "緊張している", "example": "ドラえもんも時々、緊張することがある。", "translation": "Doraemon also gets nervous sometimes."},
     {"word": "wide", "meaning": "広い", "example": "ドラえもんのポケットはとても広い。", "translation": "Doraemon's pocket is very wide."},
     {"word": "decoration", "meaning": "飾り", "example": "ドラえもんは誕生日には部屋を飾り付けする。", "translation": "Doraemon decorates the room for birthdays."},
     {"word": "fry", "meaning": "揚げる", "example": "ドラえもんは時々、料理を揚げてくれる。", "translation": "Doraemon sometimes fries food for us."},
     {"word": "social", "meaning": "社交的な", "example": "ドラえもんはとても社交的なロボットだ。", "translation": "Doraemon is a very social robot."},
     {"word": "cat", "meaning": "猫", "example": "ドラえもんは猫型のロボットだ。", "translation": "Doraemon is a cat-shaped robot."},
     {"word": "hello", "meaning": "こんにちは", "example": "ドラえもんはいつも「こんにちは」と挨拶する。", "translation": "Doraemon always greets with 'Hello'."},
     {"word": "map", "meaning": "地図", "example": "ドラえもんは未来の地図を持っている。", "translation": "Doraemon has a map from the future."},
     {"word": "insect", "meaning": "昆虫", "example": "ドラえもんは昆虫のこともよく知っている。", "translation": "Doraemon knows a lot about insects as well."}
     ];
     break;
     case "中学英語6":
     item = [
     {"word": "even", "meaning": "～でさえ", "example": "ドラえもんは、難しい問題でさえ解決できる。", "translation": "Doraemon can solve even difficult problems."},
     {"word": "teamwork", "meaning": "チームワーク", "example": "ドラえもんは友達とのチームワークを大切にしている。", "translation": "Doraemon values teamwork with his friends."},
     {"word": "choice", "meaning": "選択", "example": "ドラえもんはいつも良い選択をする。", "translation": "Doraemon always makes good choices."},
     {"word": "bench", "meaning": "ベンチ", "example": "ドラえもんは公園のベンチでよく休む。", "translation": "Doraemon often rests on a park bench."},
     {"word": "relax", "meaning": "リラックスする", "example": "ドラえもんは、昼寝をすることでリラックスする。", "translation": "Doraemon relaxes by taking a nap."},
     {"word": "slow", "meaning": "ゆっくり", "example": "ドラえもんはのび太に合わせてゆっくり歩く。", "translation": "Doraemon walks slowly to match Nobita's pace."},
     {"word": "heat", "meaning": "暑さ", "example": "ドラえもんは夏の暑さにも強い。", "translation": "Doraemon is also strong against the summer heat."},
     {"word": "schoolyard", "meaning": "校庭", "example": "ドラえもんはよく校庭でみんなと遊ぶ。", "translation": "Doraemon often plays with everyone in the schoolyard."},
     {"word": "teeth", "meaning": "歯", "example": "ドラえもんは歯を大切にしている。", "translation": "Doraemon takes care of his teeth."},
     {"word": "enough", "meaning": "十分な", "example": "ドラえもんはいつもみんなに十分な道具をくれる。", "translation": "Doraemon always gives everyone enough gadgets."}
     ];
     break;
     case "中学英語7":
     item = [
     {"word": "skill", "meaning": "スキル", "example": "ドラえもんは色々なスキルを持っている。", "translation": "Doraemon has various skills."},
     {"word": "everything", "meaning": "全て", "example": "ドラえもんは何でも知っているように見える。", "translation": "Doraemon seems to know everything."},
     {"word": "full", "meaning": "満腹", "example": "ドラえもんはどら焼きでお腹がいっぱいになった。", "translation": "Doraemon got full from dorayaki."},
     {"word": "park", "meaning": "公園", "example": "ドラえもんは友達とよく公園で遊ぶ。", "translation": "Doraemon often plays with his friends in the park."},
     {"word": "candle", "meaning": "ろうそく", "example": "ドラえもんは誕生日にろうそくを灯す。", "translation": "Doraemon lights candles on birthdays."},
     {"word": "library", "meaning": "図書館", "example": "ドラえもんは図書館でよく本を読む。", "translation": "Doraemon often reads books in the library."},
     {"word": "desk", "meaning": "机", "example": "ドラえもんはのび太の机で勉強を見ている。", "translation": "Doraemon watches over Nobita's studies at his desk."},
     {"word": "share", "meaning": "共有する", "example": "ドラえもんは友達と道具を共有する。", "translation": "Doraemon shares his gadgets with his friends."},
     {"word": "suddenly", "meaning": "突然", "example": "ドラえもんは突然、過去にタイムスリップした。", "translation": "Doraemon suddenly time-slipped to the past."},
     {"word": "alone", "meaning": "一人で", "example": "ドラえもんは時々一人で未来へ行くことがある。", "translation": "Doraemon sometimes goes to the future alone."},
     ];
     break;
     case "中学英語8":
     item = [
     {"word": "subject", "meaning": "科目", "example": "ドラえもんはすべての科目をよく知っている。", "translation": "Doraemon knows all subjects well."},
     {"word": "fish", "meaning": "魚", "example": "ドラえもんは海で魚を釣る。", "translation": "Doraemon catches fish in the sea."},
     {"word": "familiar", "meaning": "馴染みのある", "example": "ドラえもんは未来の道具にも馴染みがある。", "translation": "Doraemon is familiar with gadgets from the future."},
     {"word": "doghouse", "meaning": "犬小屋", "example": "ドラえもんは時々犬小屋で休むことがある。", "translation": "Doraemon sometimes rests in the doghouse."},
     {"word": "high", "meaning": "高い", "example": "ドラえもんは高い場所も平気だ。", "translation": "Doraemon is not afraid of high places."},
     {"word": "ride", "meaning": "乗る", "example": "ドラえもんはタケコプターに乗って空を飛ぶ。", "translation": "Doraemon flies in the sky riding the Takecopter."},
     {"word": "sea", "meaning": "海", "example": "ドラえもんは海の中で冒険をする。", "translation": "Doraemon goes on adventures in the sea."},
     {"word": "leader", "meaning": "リーダー", "example": "ドラえもんはみんなのリーダーだ。", "translation": "Doraemon is the leader of everyone."},
     {"word": "dead", "meaning": "死んだ", "example": "ドラえもんは、壊れても死んだりはしない。", "translation": "Even if Doraemon breaks, he doesn't die."},
     {"word": "toss", "meaning": "投げる", "example": "ドラえもんは時々ボールを投げて遊ぶ。", "translation": "Doraemon sometimes plays by throwing a ball."}
     ];
     break;
     case "中学英語9":
     item = [
     {"word": "remind", "meaning": "思い出させる", "example": "ドラえもんはのび太に大切なことを思い出させる。", "translation": "Doraemon reminds Nobita of important things."},
     {"word": "disease", "meaning": "病気", "example": "ドラえもんは未来の医学で病気を治すことができる。", "translation": "Doraemon can cure diseases with future medicine."},
     {"word": "boring", "meaning": "退屈な", "example": "ドラえもんは退屈な時間も楽しくしてくれる。", "translation": "Doraemon makes even boring times fun."},
     {"word": "telephone", "meaning": "電話", "example": "ドラえもんは未来の電話で話をする。", "translation": "Doraemon talks on a phone from the future."},
     {"word": "best", "meaning": "最高の", "example": "ドラえもんはのび太にとって最高の友達だ。", "translation": "Doraemon is the best friend for Nobita."},
     {"word": "born", "meaning": "生まれた", "example": "ドラえもんは未来の世界で生まれた。", "translation": "Doraemon was born in the future world."},
     {"word": "clearly", "meaning": "はっきりと", "example": "ドラえもんは問題をはっきりと説明する。", "translation": "Doraemon explains problems clearly."},
     {"word": "tall", "meaning": "背が高い", "example": "ドラえもんは猫型ロボットとしては背が高い。", "translation": "Doraemon is tall for a cat-type robot."},
     {"word": "children", "meaning": "子供たち", "example": "ドラえもんは子供たちに夢を与える。", "translation": "Doraemon gives dreams to children."},
     {"word": "girl", "meaning": "女の子", "example": "ドラえもんはしずかちゃんという女の子の友達がいる。", "translation": "Doraemon has a friend named Shizuka, who is a girl."}
     ];
     break;
     case "中学英語10":
     item = [
     {"word": "elephant", "meaning": "象", "example": "ドラえもんは象とも友達になる。", "translation": "Doraemon makes friends with elephants too."},
     {"word": "cold", "meaning": "寒い", "example": "ドラえもんは寒い場所でも大丈夫だ。", "translation": "Doraemon is okay even in cold places."},
     {"word": "chair", "meaning": "椅子", "example": "ドラえもんは椅子に座って休む。", "translation": "Doraemon sits on a chair to rest."},
     {"word": "band", "meaning": "バンド", "example": "ドラえもんは友達とバンドを組む。", "translation": "Doraemon forms a band with his friends."},
     {"word": "fell", "meaning": "転んだ", "example": "ドラえもんは時々転んでしまう。", "translation": "Doraemon sometimes falls down."},
     {"word": "ran", "meaning": "走った", "example": "ドラえもんは急いで走った。", "translation": "Doraemon ran in a hurry."},
     {"word": "designer", "meaning": "デザイナー", "example": "ドラえもんは未来のデザイナーかもしれない。", "translation": "Doraemon might be a future designer."},
     {"word": "memory", "meaning": "記憶", "example": "ドラえもんはたくさんの記憶を持っている。", "translation": "Doraemon has many memories."},
     {"word": "print", "meaning": "印刷する", "example": "ドラえもんは道具で何でも印刷できる。", "translation": "Doraemon can print anything with his gadgets."},
     {"word": "week", "meaning": "週", "example": "ドラえもんは一週間、のび太の家にいる。", "translation": "Doraemon stays at Nobita's house for a week."}
     ];
     break;
     case "中学英語11":
     item = [
     {"word": "red", "meaning": "赤", "example": "ドラえもんの鼻は赤色だ。", "translation": "Doraemon's nose is red."},
     {"word": "glass", "meaning": "グラス", "example": "ドラえもんはグラスでジュースを飲む。", "translation": "Doraemon drinks juice with a glass."},
     {"word": "receive", "meaning": "受け取る", "example": "ドラえもんは友達からプレゼントを受け取る。", "translation": "Doraemon receives gifts from his friends."},
     {"word": "tradition", "meaning": "伝統", "example": "ドラえもんは日本の伝統を大切にする。", "translation": "Doraemon values Japanese traditions."},
     {"word": "suffer", "meaning": "苦しむ", "example": "ドラえもんは、みんなが苦しむのを見るのが嫌だ。", "translation": "Doraemon hates to see everyone suffer."},
     {"word": "crowd", "meaning": "群衆", "example": "ドラえもんは、時々群衆の中で迷子になる。", "translation": "Doraemon sometimes gets lost in a crowd."},
     {"word": "bend", "meaning": "曲げる", "example": "ドラえもんはスプーンを曲げることができる。", "translation": "Doraemon can bend a spoon."},
     {"word": "long", "meaning": "長い", "example": "ドラえもんは長い時間、のび太のそばにいる。", "translation": "Doraemon is with Nobita for a long time."},
     {"word": "woman", "meaning": "女性", "example": "ドラえもんは女性にも優しい。", "translation": "Doraemon is also kind to women."},
     {"word": "bag", "meaning": "バッグ", "example": "ドラえもんはどこでもドアをバッグに入れる。", "translation": "Doraemon puts the Anywhere Door in his bag."}
     ];
     break;
     case "中学英語12":
     item = [
     {"word": "shopper", "meaning": "買い物客", "example": "ドラえもんは未来の買い物客を見かける。", "translation": "Doraemon sees shoppers from the future."},
     {"word": "fill", "meaning": "満たす", "example": "ドラえもんはポケットを道具で満たす。", "translation": "Doraemon fills his pocket with gadgets."},
     {"word": "club", "meaning": "クラブ", "example": "ドラえもんはクラブ活動に参加する。", "translation": "Doraemon participates in club activities."},
     {"word": "shyly", "meaning": "恥ずかしそうに", "example": "ドラえもんは時々恥ずかしそうにする。", "translation": "Doraemon sometimes acts shyly."},
     {"word": "year", "meaning": "年", "example": "ドラえもんは未来の年号を教えてくれる。", "translation": "Doraemon tells us the year in the future."},
     {"word": "dance", "meaning": "踊る", "example": "ドラえもんは時々踊ることがある。", "translation": "Doraemon sometimes dances."},
     {"word": "kid", "meaning": "子供", "example": "ドラえもんは子供たちと遊ぶのが好きだ。", "translation": "Doraemon likes to play with kids."},
     {"word": "pick", "meaning": "選ぶ", "example": "ドラえもんはいつも良い道具を選ぶ。", "translation": "Doraemon always picks good gadgets."},
     {"word": "field", "meaning": "畑", "example": "ドラえもんは畑で野菜を作るのを手伝う。", "translation": "Doraemon helps grow vegetables in the field."},
     {"word": "strong", "meaning": "強い", "example": "ドラえもんはとても強いロボットだ。", "translation": "Doraemon is a very strong robot."}
     ];
     break;
     case "中学英語13":
     item = [
     {"word": "camp", "meaning": "キャンプ", "example": "ドラえもんは友達とキャンプに行く。", "translation": "Doraemon goes camping with his friends."},
     {"word": "action", "meaning": "行動", "example": "ドラえもんはいつも迅速な行動をする。", "translation": "Doraemon always takes swift action."},
     {"word": "wash", "meaning": "洗う", "example": "ドラえもんは食器を洗うのを手伝う。", "translation": "Doraemon helps wash the dishes."},
     {"word": "jacket", "meaning": "ジャケット", "example": "ドラえもんはジャケットを着て出かける。", "translation": "Doraemon goes out wearing a jacket."},
     {"word": "ear", "meaning": "耳", "example": "ドラえもんには耳がない。", "translation": "Doraemon does not have ears."},
     {"word": "bread", "meaning": "パン", "example": "ドラえもんは朝ごはんにパンを食べる。", "translation": "Doraemon eats bread for breakfast."},
     {"word": "surprise", "meaning": "驚き", "example": "ドラえもんは時々、みんなを驚かせる。", "translation": "Doraemon sometimes surprises everyone."},
     {"word": "bathroom", "meaning": "浴室", "example": "ドラえもんは浴室で体を洗う。", "translation": "Doraemon washes his body in the bathroom."},
     {"word": "graduate", "meaning": "卒業する", "example": "ドラえもんは未来の学校を卒業した。", "translation": "Doraemon graduated from a school in the future."},
     {"word": "dolphin", "meaning": "イルカ", "example": "ドラえもんはイルカと友達になる。", "translation": "Doraemon makes friends with dolphins."}
     ];
     break;
     case "中学英語14":
     item = [
     {"word": "unfair", "meaning": "不公平な", "example": "ドラえもんは不公平なことを許さない。", "translation": "Doraemon does not allow unfair things."},
     {"word": "evening", "meaning": "夕方", "example": "ドラえもんは夕方に宿題をする。", "translation": "Doraemon does his homework in the evening."},
     {"word": "sorry", "meaning": "ごめんなさい", "example": "ドラえもんは間違いをしたら「ごめんなさい」と言う。", "translation": "Doraemon says 'sorry' if he makes a mistake."},
     {"word": "ceremony", "meaning": "式典", "example": "ドラえもんは卒業式典に参加する。", "translation": "Doraemon attends the graduation ceremony."},
     {"word": "price", "meaning": "価格", "example": "ドラえもんは未来の価格を知っている。", "translation": "Doraemon knows the prices of the future."},
     {"word": "sister", "meaning": "妹", "example": "ドラえもんは妹のようにみんなを大切にする。", "translation": "Doraemon cherishes everyone like a sister."},
     {"word": "listen", "meaning": "聞く", "example": "ドラえもんは人の話をよく聞く。", "translation": "Doraemon listens to people well."},
     {"word": "guest", "meaning": "客", "example": "ドラえもんはいつもお客様を歓迎する。", "translation": "Doraemon always welcomes guests."},
     {"word": "dream", "meaning": "夢", "example": "ドラえもんはみんなの夢を叶える手伝いをする。", "translation": "Doraemon helps to make everyone's dreams come true."},
     {"word": "stapler", "meaning": "ホチキス", "example": "ドラえもんはホチキスを使って書類をまとめる。", "translation": "Doraemon uses a stapler to organize documents."}
     ];
     break;
     case "中学英語15":
     item = [
     {"word": "teammate", "meaning": "チームメイト", "example": "ドラえもんはみんなのチームメイトだ。", "translation": "Doraemon is everyone's teammate."},
     {"word": "alone", "meaning": "一人で", "example": "ドラえもんは時々一人で考える時間を持つ。", "translation": "Doraemon sometimes has time to think alone."},
     {"word": "another", "meaning": "もう一つの", "example": "ドラえもんはもう一つの道具を出す。", "translation": "Doraemon takes out another gadget."},
     {"word": "point", "meaning": "ポイント", "example": "ドラえもんは問題を解決するポイントを知っている。", "translation": "Doraemon knows the points to solve problems."},
     {"word": "example", "meaning": "例", "example": "ドラえもんは良い例を示す。", "translation": "Doraemon shows good examples."},
     {"word": "fast", "meaning": "速い", "example": "ドラえもんは速く走ることができる。", "translation": "Doraemon can run fast."},
     {"word": "hurt", "meaning": "傷つける", "example": "ドラえもんは誰も傷つけたくない。", "translation": "Doraemon doesn't want to hurt anyone."},
     {"word": "pot", "meaning": "鍋", "example": "ドラえもんは鍋を使って料理をする。", "translation": "Doraemon cooks using a pot."},
     {"word": "curry", "meaning": "カレー", "example": "ドラえもんはカレーが好きだ。", "translation": "Doraemon likes curry."},
     {"word": "pardon", "meaning": "許す", "example": "ドラえもんは間違いを許す。", "translation": "Doraemon forgives mistakes."}
     ];
     break;
     case "中学英語16":
     item = [
     {"word": "produce", "meaning": "生産する", "example": "ドラえもんは未来の道具を生産する。", "translation": "Doraemon produces gadgets from the future."},
     {"word": "area", "meaning": "地域", "example": "ドラえもんは様々な地域へ冒険に行く。", "translation": "Doraemon goes on adventures to various areas."},
     {"word": "same", "meaning": "同じ", "example": "ドラえもんはいつもと同じように優しい。", "translation": "Doraemon is always kind as usual."},
     {"word": "problem", "meaning": "問題", "example": "ドラえもんは問題を解決するのが得意だ。", "translation": "Doraemon is good at solving problems."},
     {"word": "student", "meaning": "生徒", "example": "ドラえもんはのび太の生徒でもある。", "translation": "Doraemon is also a student of Nobita."},
     {"word": "right", "meaning": "正しい", "example": "ドラえもんは正しいことをする。", "translation": "Doraemon does the right thing."},
     {"word": "spoil", "meaning": "甘やかす", "example": "ドラえもんは時々、のび太を甘やかす。", "translation": "Doraemon sometimes spoils Nobita."},
     {"word": "when", "meaning": "いつ", "example": "ドラえもんは、必要な時にいつも現れる。", "translation": "Doraemon always appears when he is needed."},
     {"word": "Wednesday", "meaning": "水曜日", "example": "ドラえもんは水曜日にどら焼きを食べる。", "translation": "Doraemon eats dorayaki on Wednesdays."},
     {"word": "shirt", "meaning": "シャツ", "example": "ドラえもんはいつも同じシャツを着ている。", "translation": "Doraemon always wears the same shirt."}
     ];
     break;
     case "中学英語17":
     item = [
     {"word": "pair", "meaning": "ペア", "example": "ドラえもんはのび太とペアで行動する。", "translation": "Doraemon acts in a pair with Nobita."},
     {"word": "meet", "meaning": "会う", "example": "ドラえもんは未来の人々に会う。", "translation": "Doraemon meets people from the future."},
     {"word": "classmate", "meaning": "クラスメイト", "example": "ドラえもんはのび太のクラスメイトとも仲が良い。", "translation": "Doraemon is also good friends with Nobita's classmates."},
     {"word": "Sunday", "meaning": "日曜日", "example": "ドラえもんは日曜日にゆっくり休む。", "translation": "Doraemon rests on Sundays."},
     {"word": "answer", "meaning": "答え", "example": "ドラえもんはいつも正しい答えを知っている。", "translation": "Doraemon always knows the correct answer."},
     {"word": "stage", "meaning": "舞台", "example": "ドラえもんは舞台で活躍する。", "translation": "Doraemon plays an active role on stage."},
     {"word": "forest", "meaning": "森", "example": "ドラえもんは森の中で冒険をする。", "translation": "Doraemon goes on adventures in the forest."},
     {"word": "knife", "meaning": "ナイフ", "example": "ドラえもんはナイフを使いこなす。", "translation": "Doraemon is good at using a knife."},
     {"word": "rest", "meaning": "休憩", "example": "ドラえもんは疲れたら休憩する。", "translation": "Doraemon takes a rest when he is tired."},
     {"word": "train", "meaning": "電車", "example": "ドラえもんは未来の電車に乗る。", "translation": "Doraemon rides on a train from the future."}
     ];
     break;
     case "中学英語18":
     item = [
     {"word": "talk", "meaning": "話す", "example": "ドラえもんは友達とよく話をする。", "translation": "Doraemon often talks with his friends."},
     {"word": "gate", "meaning": "門", "example": "ドラえもんは学校の門から出入りする。", "translation": "Doraemon enters and exits through the school gate."},
     {"word": "rabbit", "meaning": "ウサギ", "example": "ドラえもんはウサギと遊ぶのが好きだ。", "translation": "Doraemon likes to play with rabbits."},
     {"word": "discover", "meaning": "発見する", "example": "ドラえもんは新しい世界を発見する。", "translation": "Doraemon discovers new worlds."},
     {"word": "delicious", "meaning": "おいしい", "example": "ドラえもんのどら焼きはおいしい。", "translation": "Doraemon's dorayaki is delicious."},
     {"word": "lose", "meaning": "失う", "example": "ドラえもんは道具を失うことがある。", "translation": "Doraemon sometimes loses his gadgets."},
     {"word": "body", "meaning": "体", "example": "ドラえもんは自分の体を大切にしている。", "translation": "Doraemon takes care of his own body."},
     {"word": "learn", "meaning": "学ぶ", "example": "ドラえもんはいつも新しいことを学ぶ。", "translation": "Doraemon is always learning new things."},
     {"word": "soon", "meaning": "すぐに", "example": "ドラえもんはすぐに問題を解決する。", "translation": "Doraemon solves problems quickly."},
     {"word": "weather", "meaning": "天気", "example": "ドラえもんは未来の天気を教えてくれる。", "translation": "Doraemon tells us the weather of the future."}
     ];
     break;
     case "中学英語19":
     item = [
     {"word": "left", "meaning": "左", "example": "ドラえもんは左のポケットから道具を出す。", "translation": "Doraemon takes out a gadget from his left pocket."},
     {"word": "spice", "meaning": "スパイス", "example": "ドラえもんは料理にスパイスを使う。", "translation": "Doraemon uses spices in cooking."},
     {"word": "virtual", "meaning": "仮想の", "example": "ドラえもんは仮想世界を体験する。", "translation": "Doraemon experiences a virtual world."},
     {"word": "themselves", "meaning": "彼ら自身", "example": "ドラえもんたちは自分たち自身で問題を解決する。", "translation": "Doraemon and his friends solve problems by themselves."},
     {"word": "museum", "meaning": "博物館", "example": "ドラえもんは博物館で歴史を学ぶ。", "translation": "Doraemon learns history at the museum."},
     {"word": "wait", "meaning": "待つ", "example": "ドラえもんはみんなを待つ。", "translation": "Doraemon waits for everyone."},
     {"word": "sound", "meaning": "音", "example": "ドラえもんは色々な音を聞き分ける。", "translation": "Doraemon can distinguish various sounds."},
     {"word": "ago", "meaning": "～前に", "example": "ドラえもんは過去にタイムスリップする。", "translation": "Doraemon time-slips to the past."},
     {"word": "dictionary", "meaning": "辞書", "example": "ドラえもんは辞書で言葉を調べる。", "translation": "Doraemon looks up words in the dictionary."},
     {"word": "weak", "meaning": "弱い", "example": "ドラえもんは、時々弱気になる。", "translation": "Doraemon sometimes becomes weak."}
     ];
     break;
     case "中学英語20":
     item = [
     {"word": "scooter", "meaning": "スクーター", "example": "ドラえもんはスクーターで移動する。", "translation": "Doraemon travels by scooter."},
     {"word": "whose", "meaning": "誰の", "example": "ドラえもんは誰の道具かを知っている。", "translation": "Doraemon knows whose gadget it is."},
     {"word": "community", "meaning": "地域社会", "example": "ドラえもんは地域社会に貢献する。", "translation": "Doraemon contributes to the community."},
     {"word": "animation", "meaning": "アニメ", "example": "ドラえもんはアニメが好きだ。", "translation": "Doraemon likes animation."},
     {"word": "grand", "meaning": "壮大な", "example": "ドラえもんは壮大な冒険をする。", "translation": "Doraemon goes on grand adventures."},
     {"word": "thirsty", "meaning": "のどが渇いた", "example": "ドラえもんはのどが渇くとジュースを飲む。", "translation": "Doraemon drinks juice when he is thirsty."},
     {"word": "celebrate", "meaning": "祝う", "example": "ドラえもんは誕生日を祝う。", "translation": "Doraemon celebrates birthdays."},
     {"word": "shoot", "meaning": "撃つ", "example": "ドラえもんは敵を撃つことはしない。", "translation": "Doraemon doesn't shoot enemies."},
     {"word": "wood", "meaning": "木", "example": "ドラえもんは木を使って工作をする。", "translation": "Doraemon uses wood to make crafts."}
     ];
     break;
     case "中学英語21":
     item = [
     {"word": "dinner", "meaning": "夕食", "example": "ドラえもんは友達と一緒に夕食を食べる。", "translation": "Doraemon has dinner with his friends."},
     {"word": "mine", "meaning": "私のもの", "example": "ドラえもんは私の友達だ。", "translation": "Doraemon is a friend of mine."},
     {"word": "statue", "meaning": "像", "example": "ドラえもんは街の像を見るのが好きだ。", "translation": "Doraemon likes to see statues in the city."},
     {"word": "promise", "meaning": "約束", "example": "ドラえもんはみんなと約束をする。", "translation": "Doraemon makes promises with everyone."},
     {"word": "need", "meaning": "必要とする", "example": "ドラえもんは困った時に道具を必要とする。", "translation": "Doraemon needs his gadgets when he's in trouble."},
     {"word": "through", "meaning": "～を通して", "example": "ドラえもんはどこでもドアを通して色々な場所へ行く。", "translation": "Doraemon goes to various places through the Anywhere Door."},
     {"word": "proud", "meaning": "誇りに思う", "example": "ドラえもんは友達を誇りに思う。", "translation": "Doraemon is proud of his friends."},
     {"word": "arrive", "meaning": "到着する", "example": "ドラえもんは時間旅行で色々な時代に到着する。", "translation": "Doraemon arrives in various eras through time travel."},
     {"word": "culture", "meaning": "文化", "example": "ドラえもんは様々な文化を学ぶ。", "translation": "Doraemon learns about various cultures."},
     {"word": "use", "meaning": "使う", "example": "ドラえもんは道具を使う。", "translation": "Doraemon uses his gadgets."}
     ];
     break;
     case "中学英語22":
     item = [
     {"word": "habit", "meaning": "習慣", "example": "ドラえもんは良い習慣を持っている。", "translation": "Doraemon has good habits."},
     {"word": "class", "meaning": "クラス", "example": "ドラえもんはのび太のクラスにいる。", "translation": "Doraemon is in Nobita's class."},
     {"word": "crowded", "meaning": "混雑した", "example": "ドラえもんは混雑した場所が苦手だ。", "translation": "Doraemon doesn't like crowded places."},
     {"word": "please", "meaning": "お願いします", "example": "ドラえもんは何かを頼む時に「お願いします」と言う。", "translation": "Doraemon says 'please' when asking for something."},
     {"word": "enjoy", "meaning": "楽しむ", "example": "ドラえもんは友達と遊ぶのを楽しむ。", "translation": "Doraemon enjoys playing with his friends."},
     {"word": "ballet", "meaning": "バレエ", "example": "ドラえもんはバレエを見に行く。", "translation": "Doraemon goes to see ballet."},
     {"word": "prepare", "meaning": "準備する", "example": "ドラえもんは冒険の準備をする。", "translation": "Doraemon prepares for adventures."},
     {"word": "radio", "meaning": "ラジオ", "example": "ドラえもんはラジオで音楽を聴く。", "translation": "Doraemon listens to music on the radio."},
     {"word": "music", "meaning": "音楽", "example": "ドラえもんは色々な音楽を聴くのが好きだ。", "translation": "Doraemon likes to listen to various types of music."},
     {"word": "clean", "meaning": "きれいにする", "example": "ドラえもんは部屋をきれいに保つ。", "translation": "Doraemon keeps the room clean."}
     ];
     break;
     case "中学英語23":
     item = [
     {"word": "weigh", "meaning": "重さを量る", "example": "ドラえもんは自分の体重を量る。", "translation": "Doraemon weighs himself."},
     {"word": "bottle", "meaning": "ボトル", "example": "ドラえもんはボトルに入ったジュースを飲む。", "translation": "Doraemon drinks juice from a bottle."},
     {"word": "but", "meaning": "しかし", "example": "ドラえもんは失敗することもある、しかし、諦めない。", "translation": "Doraemon sometimes fails, but he doesn't give up."},
     {"word": "page", "meaning": "ページ", "example": "ドラえもんは本のページをめくる。", "translation": "Doraemon turns the pages of a book."},
     {"word": "skirt", "meaning": "スカート", "example": "ドラえもんはスカートを履いて踊る。", "translation": "Doraemon dances wearing a skirt."},
     {"word": "hospital", "meaning": "病院", "example": "ドラえもんは病院で体の調子を見てもらう。", "translation": "Doraemon goes to the hospital for check-ups."},
     {"word": "pretty", "meaning": "かわいい", "example": "ドラえもんは可愛いロボットだ。", "translation": "Doraemon is a pretty robot."},
     {"word": "grandfather", "meaning": "祖父", "example": "ドラえもんはのび太の祖父を尊敬している。", "translation": "Doraemon respects Nobita's grandfather."},
     {"word": "bath", "meaning": "お風呂", "example": "ドラえもんは毎日お風呂に入る。", "translation": "Doraemon takes a bath every day."}
     ];
     break;
     case "中学英語24":
     item = [
     {"word": "go", "meaning": "行く", "example": "ドラえもんはどこでもドアでどこへでも行く。", "translation": "Doraemon goes anywhere with the Anywhere Door."},
     {"word": "so", "meaning": "とても", "example": "ドラえもんはとても優しい。", "translation": "Doraemon is so kind."},
     {"word": "perfect", "meaning": "完璧な", "example": "ドラえもんは完璧なロボットではない。", "translation": "Doraemon is not a perfect robot."},
     {"word": "wave", "meaning": "波", "example": "ドラえもんは海で波に乗る。", "translation": "Doraemon rides the waves in the sea."},
     {"word": "prize", "meaning": "賞", "example": "ドラえもんは色々な賞をもらう。", "translation": "Doraemon receives various prizes."},
     {"word": "speed", "meaning": "速度", "example": "ドラえもんは未来の乗り物をすごい速度で動かす。", "translation": "Doraemon moves future vehicles at great speed."},
     {"word": "bedroom", "meaning": "寝室", "example": "ドラえもんはのび太の寝室で寝る。", "translation": "Doraemon sleeps in Nobita's bedroom."},
     {"word": "central", "meaning": "中央の", "example": "ドラえもんは街の中央にいる。", "translation": "Doraemon is in the central area of the city."},
     {"word": "shark", "meaning": "サメ", "example": "ドラえもんはサメを怖がる。", "translation": "Doraemon is afraid of sharks."},
     {"word": "traditional", "meaning": "伝統的な", "example": "ドラえもんは日本の伝統的なお菓子を食べる。", "translation": "Doraemon eats traditional Japanese sweets."}
     ];
     break;
     case "中学英語25":
     item = [
     {"word": "recite", "meaning": "暗唱する", "example": "ドラえもんは物語を暗唱する。", "translation": "Doraemon recites a story."},
     {"word": "say", "meaning": "言う", "example": "ドラえもんはいつも「こんにちは」と言う。", "translation": "Doraemon always says 'hello'."},
     {"word": "look", "meaning": "見る", "example": "ドラえもんは空を見るのが好きだ。", "translation": "Doraemon likes to look at the sky."},
     {"word": "trophy", "meaning": "トロフィー", "example": "ドラえもんはみんなでトロフィーを分ける。", "translation": "Doraemon shares a trophy with everyone."},
     {"word": "birthday", "meaning": "誕生日", "example": "ドラえもんは誕生日にみんなを祝う。", "translation": "Doraemon celebrates everyone on their birthdays."},
     {"word": "moon", "meaning": "月", "example": "ドラえもんは月を見ながら歌を歌う。", "translation": "Doraemon sings a song while looking at the moon."},
     {"word": "heart", "meaning": "心", "example": "ドラえもんは温かい心を持っている。", "translation": "Doraemon has a warm heart."},
     {"word": "than", "meaning": "～より", "example": "ドラえもんは、誰よりも友達を大切にする。", "translation": "Doraemon values his friends more than anyone else."},
     {"word": "should", "meaning": "～すべき", "example": "ドラえもんは、いつも正しいことをすべきだと教えてくれる。", "translation": "Doraemon always teaches us that we should do the right thing."},
     {"word": "easy", "meaning": "簡単な", "example": "ドラえもんは、難しいことも簡単にしてくれる。", "translation": "Doraemon makes even difficult things easy."}
     ];
     break;
     case "中学英語26":
     item = [
     {"word": "check", "meaning": "確認する", "example": "ドラえもんは道具の状態をチェックする。", "translation": "Doraemon checks the condition of his gadgets."},
     {"word": "crane", "meaning": "クレーン", "example": "ドラえもんはクレーンで物を運ぶ。", "translation": "Doraemon uses a crane to carry things."},
     {"word": "solar", "meaning": "太陽の", "example": "ドラえもんは太陽エネルギーを利用する。", "translation": "Doraemon uses solar energy."},
     {"word": "first", "meaning": "最初の", "example": "ドラえもんはいつも最初に助けに来てくれる。", "translation": "Doraemon is always the first to come to help."},
     {"word": "star", "meaning": "星", "example": "ドラえもんは星を見るのが好きだ。", "translation": "Doraemon likes to look at the stars."},
     {"word": "cent", "meaning": "セント", "example": "ドラえもんは未来のお金を使う。", "translation": "Doraemon uses money from the future."},
     {"word": "button", "meaning": "ボタン", "example": "ドラえもんはボタンを押して道具を出す。", "translation": "Doraemon presses a button to take out his gadgets."},
     {"word": "flight", "meaning": "飛行", "example": "ドラえもんはタケコプターで飛行する。", "translation": "Doraemon flies with his Takecopter."},
     {"word": "good", "meaning": "良い", "example": "ドラえもんは良い友達だ。", "translation": "Doraemon is a good friend."},
     {"word": "angry", "meaning": "怒った", "example": "ドラえもんも時々怒ることがある。", "translation": "Doraemon also gets angry sometimes."}
     ];
     break;
     case "中学英語27":
     item = [
     {"word": "communication", "meaning": "コミュニケーション", "example": "ドラえもんはみんなとのコミュニケーションを大切にする。", "translation": "Doraemon values communication with everyone."},
     {"word": "active", "meaning": "活発な", "example": "ドラえもんはとても活発なロボットだ。", "translation": "Doraemon is a very active robot."},
     {"word": "rat", "meaning": "ネズミ", "example": "ドラえもんはネズミが嫌いだ。", "translation": "Doraemon hates rats."},
     {"word": "hers", "meaning": "彼女の", "example": "ドラえもんは彼女の道具を大切にする。", "translation": "Doraemon takes care of her gadgets."},
     {"word": "side", "meaning": "側", "example": "ドラえもんはいつも友達の側にいる。", "translation": "Doraemon is always on his friend's side."},
     {"word": "label", "meaning": "ラベル", "example": "ドラえもんは道具にラベルを貼る。", "translation": "Doraemon puts labels on his gadgets."},
     {"word": "seat", "meaning": "席", "example": "ドラえもんはみんなと一緒に席に座る。", "translation": "Doraemon sits in a seat with everyone."},
     {"word": "worse", "meaning": "より悪い", "example": "ドラえもんは悪いことがより悪くなるのを防ぐ。", "translation": "Doraemon prevents bad things from getting worse."},
     {"word": "lost", "meaning": "失った", "example": "ドラえもんは時々道を失う。", "translation": "Doraemon sometimes gets lost."},
     {"word": "mask", "meaning": "マスク", "example": "ドラえもんはマスクを着けてウイルスから守る。", "translation": "Doraemon wears a mask to protect himself from viruses."}
     ];
     break;
     case "中学英語28":
     item = [
     {"word": "Japanese", "meaning": "日本語の", "example": "ドラえもんは日本語を話す。", "translation": "Doraemon speaks Japanese."},
     {"word": "candy", "meaning": "キャンディ", "example": "ドラえもんはキャンディが好きだ。", "translation": "Doraemon likes candy."},
     {"word": "sofa", "meaning": "ソファ", "example": "ドラえもんはソファでくつろぐ。", "translation": "Doraemon relaxes on the sofa."},
     {"word": "about", "meaning": "～について", "example": "ドラえもんは未来について話す。", "translation": "Doraemon talks about the future."},
     {"word": "captain", "meaning": "キャプテン", "example": "ドラえもんはチームのキャプテンを務める。", "translation": "Doraemon serves as the captain of the team."},
     {"word": "foreign", "meaning": "外国の", "example": "ドラえもんは外国の文化にも興味がある。", "translation": "Doraemon is also interested in foreign cultures."},
     {"word": "cute", "meaning": "かわいい", "example": "ドラえもんはとてもかわいい。", "translation": "Doraemon is very cute."},
     {"word": "happen", "meaning": "起こる", "example": "ドラえもんは色々なことが起こる冒険に行く。", "translation": "Doraemon goes on adventures where various things happen."},
     {"word": "honey", "meaning": "ハチミツ", "example": "ドラえもんはハチミツを時々食べる。", "translation": "Doraemon sometimes eats honey."},
     {"word": "roof", "meaning": "屋根", "example": "ドラえもんは屋根の上から町を見る。", "translation": "Doraemon looks at the town from the roof."}
     ];
     break;
     case "中学英語29":
     item = [
     {"word": "no", "meaning": "いいえ", "example": "ドラえもんは嫌な時は「いいえ」と言う。", "translation": "Doraemon says 'no' when he doesn't like something."},
     {"word": "my", "meaning": "私の", "example": "ドラえもんは私の友達だ。", "translation": "Doraemon is my friend."},
     {"word": "duck", "meaning": "アヒル", "example": "ドラえもんはアヒルと遊ぶ。", "translation": "Doraemon plays with ducks."},
     {"word": "those", "meaning": "あれらの", "example": "ドラえもんはあれらの道具を使う。", "translation": "Doraemon uses those gadgets."},
     {"word": "can", "meaning": "～できる", "example": "ドラえもんは何でもできる。", "translation": "Doraemon can do anything."},
     {"word": "easily", "meaning": "簡単に", "example": "ドラえもんは問題を簡単に解決できる。", "translation": "Doraemon can solve problems easily."},
     {"word": "new", "meaning": "新しい", "example": "ドラえもんは新しい道具を出す。", "translation": "Doraemon takes out new gadgets."},
     {"word": "down", "meaning": "下に", "example": "ドラえもんは階段を下りる。", "translation": "Doraemon goes down the stairs."},
     {"word": "spread", "meaning": "広げる", "example": "ドラえもんは地図を広げる。", "translation": "Doraemon spreads out a map."},
     {"word": "company", "meaning": "会社", "example": "ドラえもんは未来の会社で働いている。", "translation": "Doraemon works at a company in the future."}
     ];
     break;
     case "中学英語30":
     item = [
     {"word": "write", "meaning": "書く", "example": "ドラえもんは日記を書く。", "translation": "Doraemon writes a diary."},
     {"word": "absent", "meaning": "欠席", "example": "ドラえもんは時々学校を欠席する。", "translation": "Doraemon is sometimes absent from school."},
     {"word": "snack", "meaning": "おやつ", "example": "ドラえもんはよくおやつを食べる。", "translation": "Doraemon often eats snacks."},
     {"word": "comic", "meaning": "漫画", "example": "ドラえもんは漫画を読む。", "translation": "Doraemon reads manga."},
     {"word": "excited", "meaning": "興奮した", "example": "ドラえもんは新しい冒険に興奮している。", "translation": "Doraemon is excited about new adventures."},
     {"word": "we", "meaning": "私たちは", "example": "ドラえもんと私たちは友達だ。", "translation": "Doraemon and we are friends."},
     {"word": "respect", "meaning": "尊敬する", "example": "ドラえもんはみんなを尊敬している。", "translation": "Doraemon respects everyone."},
     {"word": "abroad", "meaning": "海外へ", "example": "ドラえもんは海外に旅行に行く。", "translation": "Doraemon travels abroad."},
     {"word": "his", "meaning": "彼の", "example": "ドラえもんは彼の道具を大切にする。", "translation": "Doraemon takes care of his gadgets."},
     {"word": "textbook", "meaning": "教科書", "example": "ドラえもんは教科書で勉強する。", "translation": "Doraemon studies with a textbook."}
     ];
     break;
     case "中学英語31":
     item = [
     {"word": "yard", "meaning": "庭", "example": "ドラえもんは庭で遊ぶ。", "translation": "Doraemon plays in the yard."},
     {"word": "spell", "meaning": "綴る", "example": "ドラえもんは単語を綴る。", "translation": "Doraemon spells words."},
     {"word": "amazing", "meaning": "驚くべき", "example": "ドラえもんは驚くべき道具を持っている。", "translation": "Doraemon has amazing gadgets."},
     {"word": "monument", "meaning": "記念碑", "example": "ドラえもんは街の記念碑を見に行く。", "translation": "Doraemon goes to see the city's monuments."},
     {"word": "die", "meaning": "死ぬ", "example": "ドラえもんは壊れても死なない。", "translation": "Doraemon doesn't die even if he breaks."},
     {"word": "grow", "meaning": "成長する", "example": "ドラえもんは色々なことを学んで成長する。", "translation": "Doraemon grows by learning various things."},
     {"word": "five", "meaning": "5つ", "example": "ドラえもんは五つの道具を出した。", "translation": "Doraemon took out five gadgets."},
     {"word": "run", "meaning": "走る", "example": "ドラえもんは急いで走る。", "translation": "Doraemon runs in a hurry."},
     {"word": "waiter", "meaning": "ウェイター", "example": "ドラえもんはレストランでウェイターをする。", "translation": "Doraemon works as a waiter in a restaurant."},
     {"word": "favor", "meaning": "頼み", "example": "ドラえもんは友達の頼みを聞く。", "translation": "Doraemon listens to his friends' favors."}
     ];
     break;
     case "中学英語32":
     item = [
     {"word": "ourselves", "meaning": "私たち自身", "example": "ドラえもんたちは私たち自身で解決する。", "translation": "Doraemon and his friends solve problems by ourselves."},
     {"word": "plane", "meaning": "飛行機", "example": "ドラえもんは飛行機に乗って旅行に行く。", "translation": "Doraemon travels by plane."},
     {"word": "fruit", "meaning": "果物", "example": "ドラえもんは色々な果物を食べる。", "translation": "Doraemon eats various fruits."},
     {"word": "love", "meaning": "愛", "example": "ドラえもんはみんなに愛されている。", "translation": "Doraemon is loved by everyone."},
     {"word": "car", "meaning": "車", "example": "ドラえもんは車を運転する。", "translation": "Doraemon drives a car."},
     {"word": "by", "meaning": "～によって", "example": "ドラえもんは時間旅行によって過去に行く。", "translation": "Doraemon goes to the past by time travel."},
     {"word": "she", "meaning": "彼女", "example": "ドラえもんは彼女を大切にする。", "translation": "Doraemon cherishes her."},
     {"word": "actually", "meaning": "実際に", "example": "ドラえもんは実際に空を飛ぶ。", "translation": "Doraemon actually flies in the sky."},
     {"word": "wrong", "meaning": "間違った", "example": "ドラえもんは間違ったことはしない。", "translation": "Doraemon does not do wrong things."},
     {"word": "while", "meaning": "～の間", "example": "ドラえもんは、のび太が寝ている間、本を読んでいる。", "translation": "Doraemon reads a book while Nobita is sleeping."}
     ];
     break;
     case "中学英語33":
     item = [
     {"word": "airport", "meaning": "空港", "example": "ドラえもんは空港から飛行機に乗る。", "translation": "Doraemon takes a plane from the airport."},
     {"word": "finish", "meaning": "終わらせる", "example": "ドラえもんは宿題を終わらせる。", "translation": "Doraemon finishes his homework."},
     {"word": "secret", "meaning": "秘密", "example": "ドラえもんは秘密の道具を持っている。", "translation": "Doraemon has secret gadgets."},
     {"word": "ceiling", "meaning": "天井", "example": "ドラえもんは天井を見上げる。", "translation": "Doraemon looks up at the ceiling."},
     {"word": "wallet", "meaning": "財布", "example": "ドラえもんは財布にお金を入れる。", "translation": "Doraemon puts money in his wallet."},
     {"word": "wonderful", "meaning": "素晴らしい", "example": "ドラえもんは素晴らしい友達だ。", "translation": "Doraemon is a wonderful friend."},
     {"word": "contest", "meaning": "コンテスト", "example": "ドラえもんはコンテストに参加する。", "translation": "Doraemon participates in a contest."},
     {"word": "climb", "meaning": "登る", "example": "ドラえもんは山を登る。", "translation": "Doraemon climbs a mountain."},
     {"word": "pan", "meaning": "フライパン", "example": "ドラえもんはフライパンで料理を作る。", "translation": "Doraemon cooks with a pan."},
     {"word": "pen", "meaning": "ペン", "example": "ドラえもんはペンで文字を書く。", "translation": "Doraemon writes with a pen."}
     ];
     break;
     case "中学英語34":
     item = [
     {"word": "play", "meaning": "遊ぶ", "example": "ドラえもんは友達と遊ぶのが好きだ。", "translation": "Doraemon likes to play with his friends."},
     {"word": "white", "meaning": "白い", "example": "ドラえもんは白い服を着ている。", "translation": "Doraemon wears white clothes."},
     {"word": "bank", "meaning": "銀行", "example": "ドラえもんは銀行でお金をおろす。", "translation": "Doraemon withdraws money from the bank."},
     {"word": "lend", "meaning": "貸す", "example": "ドラえもんは道具を友達に貸す。", "translation": "Doraemon lends his gadgets to his friends."},
     {"word": "butterfly", "meaning": "蝶", "example": "ドラえもんは蝶を追いかける。", "translation": "Doraemon chases butterflies."},
     {"word": "homestay", "meaning": "ホームステイ", "example": "ドラえもんはホームステイをする。", "translation": "Doraemon does a homestay."},
     {"word": "daily", "meaning": "毎日の", "example": "ドラえもんは毎日、冒険をする。", "translation": "Doraemon has daily adventures."},
     {"word": "basketball", "meaning": "バスケットボール", "example": "ドラえもんはバスケットボールをする。", "translation": "Doraemon plays basketball."},
     {"word": "shell", "meaning": "貝殻", "example": "ドラえもんは海で貝殻を拾う。", "translation": "Doraemon picks up seashells at the sea."},
     {"word": "hunting", "meaning": "狩り", "example": "ドラえもんは宝物を探しに行く。", "translation": "Doraemon goes treasure hunting."}
     ];
     break;
     case "中学英語35":
     item = [
     {"word": "grown", "meaning": "成長した", "example": "ドラえもんはみんなの成長を見守っている。", "translation": "Doraemon watches over everyone's growth."},
     {"word": "American", "meaning": "アメリカ人の", "example": "ドラえもんはアメリカ人の友達もいる。", "translation": "Doraemon also has American friends."},
     {"word": "Korean", "meaning": "韓国人の", "example": "ドラえもんは韓国人の友達もいる。", "translation": "Doraemon also has Korean friends."},
     {"word": "past", "meaning": "過去", "example": "ドラえもんは過去にタイムスリップする。", "translation": "Doraemon time slips into the past."},
     {"word": "close", "meaning": "近い", "example": "ドラえもんは友達と近い場所にいる。", "translation": "Doraemon is close to his friends."},
     {"word": "party", "meaning": "パーティー", "example": "ドラえもんはパーティーを開く。", "translation": "Doraemon throws a party."},
     {"word": "king", "meaning": "王様", "example": "ドラえもんは王様と友達になる。", "translation": "Doraemon makes friends with a king."},
     {"word": "teach", "meaning": "教える", "example": "ドラえもんはのび太に色々教える。", "translation": "Doraemon teaches Nobita various things."},
     {"word": "rider", "meaning": "乗り手", "example": "ドラえもんはタイムマシンの乗り手だ。", "translation": "Doraemon is a rider of the time machine."},
     {"word": "ice", "meaning": "氷", "example": "ドラえもんは氷を食べる。", "translation": "Doraemon eats ice."}
     ];
     break;
     case "中学英語36":
     item = [
     {"word": "driver", "meaning": "運転手", "example": "ドラえもんは車の運転手をする。", "translation": "Doraemon works as a driver."},
     {"word": "trainer", "meaning": "トレーナー", "example": "ドラえもんは動物のトレーナーをする。", "translation": "Doraemon works as an animal trainer."},
     {"word": "son", "meaning": "息子", "example": "ドラえもんは、のび太の息子の子孫。", "translation": "Doraemon is the descendent of Nobita's son."},
     {"word": "thousand", "meaning": "千", "example": "ドラえもんは千個の道具を持っている。", "translation": "Doraemon has a thousand gadgets."},
     {"word": "raise", "meaning": "上げる", "example": "ドラえもんは手を挙げて挨拶をする。", "translation": "Doraemon raises his hand to greet."},
     {"word": "month", "meaning": "月", "example": "ドラえもんは一ヶ月、旅行に行った。", "translation": "Doraemon went on a trip for a month."},
     {"word": "room", "meaning": "部屋", "example": "ドラえもんは自分の部屋でくつろぐ。", "translation": "Doraemon relaxes in his room."},
     {"word": "well", "meaning": "よく", "example": "ドラえもんはよく友達を助ける。", "translation": "Doraemon often helps his friends."},
     {"word": "boy", "meaning": "少年", "example": "ドラえもんは少年の友達。", "translation": "Doraemon is a friend of a boy."},
     {"word": "office", "meaning": "事務所", "example": "ドラえもんは未来の事務所で働く。", "translation": "Doraemon works at an office in the future."}
     ];
     break;
     case "中学英語37":
     item = [
     {"word": "aircraft", "meaning": "航空機", "example": "ドラえもんはひみつ道具で航空機を出す。", "translation": "Doraemon takes out an aircraft with his secret gadget."},
     {"word": "surprised", "meaning": "驚いた", "example": "ドラえもんはのび太のいたずらに驚いた。", "translation": "Doraemon was surprised by Nobita's prank."},
     {"word": "photographer", "meaning": "写真家", "example": "ドラえもんは未来の写真家が撮った写真を見た。", "translation": "Doraemon saw a photo taken by a future photographer."},
     {"word": "rope", "meaning": "ロープ", "example": "ドラえもんはどこでもドアをロープで縛った。", "translation": "Doraemon tied the Anywhere Door with a rope."},
     {"word": "however", "meaning": "しかしながら", "example": "ドラえもんは便利だが、しかしながら欠点もある。", "translation": "Doraemon is convenient, however, he also has shortcomings."},
     {"word": "plan", "meaning": "計画", "example": "ドラえもんはのび太の夏休みの計画を立てた。", "translation": "Doraemon made a plan for Nobita's summer vacation."},
     {"word": "differently", "meaning": "異なって", "example": "ドラえもんの考え方はのび太と異なってしまう。", "translation": "Doraemon's way of thinking differs from Nobita's."},
     {"word": "oil", "meaning": "油", "example": "ドラえもんはひみつ道具のメンテナンスに油を使った。", "translation": "Doraemon used oil for the maintenance of his secret gadgets."},
     {"word": "elementary", "meaning": "初歩の", "example": "ドラえもんは初歩の算数をのび太に教えた。", "translation": "Doraemon taught Nobita elementary arithmetic."},
     {"word": "photo", "meaning": "写真", "example": "ドラえもんはのび太との思い出の写真を大切にしている。", "translation": "Doraemon cherishes the photos of his memories with Nobita."},
     ];
     break;
     case "中学英語38":
     item = [
     {"word": "shy", "meaning": "恥ずかしがり屋の", "example": "ドラえもんは時々、恥ずかしがり屋になる。", "translation": "Doraemon is sometimes shy."},
     {"word": "corner", "meaning": "角", "example": "ドラえもんは部屋の角でひみつ道具を使った。", "translation": "Doraemon used his secret gadget in the corner of the room."},
     {"word": "door", "meaning": "ドア", "example": "ドラえもんはどこでもドアでどこへでも行く。", "translation": "Doraemon goes anywhere with the Anywhere Door."},
     {"word": "hole", "meaning": "穴", "example": "ドラえもんは地面に穴を掘ってひみつ基地を作った。", "translation": "Doraemon dug a hole in the ground and made a secret base."},
     {"word": "or", "meaning": "または", "example": "ドラえもんはラーメンまたはカレーが好きだ。", "translation": "Doraemon likes ramen or curry."},
     {"word": "school", "meaning": "学校", "example": "ドラえもんはのび太と一緒に学校へ行く。", "translation": "Doraemon goes to school with Nobita."},
     {"word": "flower", "meaning": "花", "example": "ドラえもんはしずかちゃんに花をプレゼントした。", "translation": "Doraemon gave flowers to Shizuka."},
     {"word": "afternoon", "meaning": "午後", "example": "ドラえもんは午後に昼寝をした。", "translation": "Doraemon took a nap in the afternoon."},
     {"word": "question", "meaning": "質問", "example": "ドラえもんはのび太の質問に答えた。", "translation": "Doraemon answered Nobita's question."},
     {"word": "fire", "meaning": "火", "example": "ドラえもんは火災報知機を作動させた。", "translation": "Doraemon activated the fire alarm."},
     ];
     break;
     case "中学英語39":
     item = [
     {"word": "injury", "meaning": "怪我", "example": "ドラえもんはのび太の怪我をひみつ道具で治した。", "translation": "Doraemon healed Nobita's injury with his secret gadget."},
     {"word": "wish", "meaning": "願い", "example": "ドラえもんはのび太の願いを叶えようとする。", "translation": "Doraemon tries to fulfill Nobita's wish."},
     {"word": "job", "meaning": "仕事", "example": "ドラえもんは未来の世界でロボットの仕事をしている。", "translation": "Doraemon works as a robot in the future world."},
     {"word": "her", "meaning": "彼女の", "example": "ドラえもんは彼女（しずか）をいつも助けている。", "translation": "Doraemon always helps her (Shizuka)."},
     {"word": "explain", "meaning": "説明する", "example": "ドラえもんはひみつ道具をのび太に説明する。", "translation": "Doraemon explains his secret gadgets to Nobita."},
     {"word": "tennis", "meaning": "テニス", "example": "ドラえもんはのび太とテニスをして遊んだ。", "translation": "Doraemon played tennis with Nobita."},
     {"word": "become", "meaning": "～になる", "example": "ドラえもんはのび太の友達になった。", "translation": "Doraemon became Nobita's friend."},
     {"word": "toothpaste", "meaning": "歯磨き粉", "example": "ドラえもんは未来の歯磨き粉を使った。", "translation": "Doraemon used future toothpaste."},
     {"word": "host", "meaning": "主催者", "example": "ドラえもんは誕生日パーティーの主催者となった。", "translation": "Doraemon became the host of the birthday party."},
     {"word": "worst", "meaning": "最悪の", "example": "ドラえもんは最悪の結果にならないように努力する。", "translation": "Doraemon tries his best to avoid the worst outcome."},
     ];
     break;
     case "中学英語40":
     item = [
     {"word": "bay", "meaning": "湾", "example": "ドラえもんは湾の近くで秘密の遊びをした。", "translation": "Doraemon had a secret play near the bay."},
     {"word": "quiet", "meaning": "静かな", "example": "ドラえもんは静かな場所で読書をした。", "translation": "Doraemon read a book in a quiet place."},
     {"word": "sometimes", "meaning": "時々", "example": "ドラえもんは時々、どら焼きを食べすぎる。", "translation": "Doraemon sometimes eats too many dorayaki."},
     {"word": "apartment", "meaning": "アパート", "example": "ドラえもんはのび太のアパートに住んでいる。", "translation": "Doraemon lives in Nobita's apartment."},
     {"word": "joke", "meaning": "冗談", "example": "ドラえもんはのび太に冗談を言った。", "translation": "Doraemon told Nobita a joke."},
     {"word": "save", "meaning": "救う", "example": "ドラえもんはのび太をピンチから救った。", "translation": "Doraemon saved Nobita from a pinch."},
     {"word": "word", "meaning": "言葉", "example": "ドラえもんはのび太に優しい言葉をかけた。", "translation": "Doraemon spoke kind words to Nobita."},
     {"word": "deep", "meaning": "深い", "example": "ドラえもんは深い海で冒険をした。", "translation": "Doraemon went on an adventure in the deep sea."},
     {"word": "low", "meaning": "低い", "example": "ドラえもんは低い声で話した。", "translation": "Doraemon spoke in a low voice."},
     {"word": "French", "meaning": "フランスの", "example": "ドラえもんはフランスのパンを焼いた。", "translation": "Doraemon baked French bread."},
     ];
     break;
     case "中学英語41":
     item = [
     {"word": "store", "meaning": "店", "example": "ドラえもんはひみつ道具を売っている店に行った。", "translation": "Doraemon went to the store selling secret gadgets."},
     {"word": "late", "meaning": "遅れて", "example": "ドラえもんは学校に遅れてしまった。", "translation": "Doraemon was late for school."},
     {"word": "someone", "meaning": "誰か", "example": "ドラえもんは誰かの助けを必要とした。", "translation": "Doraemon needed someone's help."},
     {"word": "bird", "meaning": "鳥", "example": "ドラえもんは空を飛ぶ鳥を見ていた。", "translation": "Doraemon watched the birds flying in the sky."},
     {"word": "hey", "meaning": "ねえ", "example": "ドラえもんは「ねえ、のび太」と呼びかけた。", "translation": "Doraemon called out, 'Hey, Nobita'."},
     {"word": "protect", "meaning": "守る", "example": "ドラえもんはのび太をいつも守っている。", "translation": "Doraemon is always protecting Nobita."},
     {"word": "hand", "meaning": "手", "example": "ドラえもんは手を振って別れを告げた。", "translation": "Doraemon waved his hand goodbye."},
     {"word": "have", "meaning": "持つ", "example": "ドラえもんはたくさんのひみつ道具を持っている。", "translation": "Doraemon has many secret gadgets."},
     {"word": "champion", "meaning": "優勝者", "example": "ドラえもんはゲームの優勝者になった。", "translation": "Doraemon became the champion of the game."},
     {"word": "calendar", "meaning": "カレンダー", "example": "ドラえもんはカレンダーで日付を確認した。", "translation": "Doraemon checked the date on the calendar."},
     {"word": "able", "meaning": "～できる", "example": "ドラえもんはひみつ道具で何でもできる。", "translation": "Doraemon is able to do anything with his secret gadgets."},
     ];
     break;
     case "中学英語42":
     item = [
     {"word": "website", "meaning": "ウェブサイト", "example": "ドラえもんは未来のウェブサイトを見た。", "translation": "Doraemon viewed a website from the future."},
     {"word": "horse", "meaning": "馬", "example": "ドラえもんは馬に乗って冒険をした。", "translation": "Doraemon went on an adventure riding a horse."},
     {"word": "message", "meaning": "メッセージ", "example": "ドラえもんは未来からメッセージを受け取った。", "translation": "Doraemon received a message from the future."},
     {"word": "customer", "meaning": "客", "example": "ドラえもんは未来のレストランで客になった。", "translation": "Doraemon became a customer at a future restaurant."},
     {"word": "greeting", "meaning": "挨拶", "example": "ドラえもんは笑顔で挨拶をした。", "translation": "Doraemon greeted with a smile."},
     {"word": "business", "meaning": "ビジネス", "example": "ドラえもんは未来のビジネスについて学んだ。", "translation": "Doraemon learned about future business."},
     {"word": "cover", "meaning": "覆う", "example": "ドラえもんはひみつ道具で空を覆った。", "translation": "Doraemon covered the sky with his secret gadget."},
     {"word": "will", "meaning": "～だろう", "example": "ドラえもんは明日、きっと良いことがあるだろう。", "translation": "Doraemon will probably have a good day tomorrow."},
     {"word": "most", "meaning": "最も", "example": "ドラえもんは最も信頼できるロボットだ。", "translation": "Doraemon is the most reliable robot."},
     {"word": "island", "meaning": "島", "example": "ドラえもんは無人島で生活した。", "translation": "Doraemon lived on a deserted island."},
     ];
     break;
     case "中学英語43":
     item = [
     {"word": "our", "meaning": "私たちの", "example": "ドラえもんは私たちの友達だ。", "translation": "Doraemon is our friend."},
     {"word": "sharp", "meaning": "鋭い", "example": "ドラえもんは鋭い爪を出した。", "translation": "Doraemon took out his sharp claws."},
     {"word": "hop", "meaning": "跳ぶ", "example": "ドラえもんは嬉しくて跳び跳ねた。", "translation": "Doraemon was so happy that he hopped."},
     {"word": "your", "meaning": "あなたの", "example": "ドラえもんはあなたの夢を応援する。", "translation": "Doraemon supports your dreams."},
     {"word": "take", "meaning": "取る", "example": "ドラえもんはひみつ道具を取り出した。", "translation": "Doraemon took out a secret gadget."},
     {"word": "player", "meaning": "選手", "example": "ドラえもんは野球の選手になった。", "translation": "Doraemon became a baseball player."},
     {"word": "get", "meaning": "手に入れる", "example": "ドラえもんは新しいひみつ道具を手に入れた。", "translation": "Doraemon got a new secret gadget."},
     {"word": "clock", "meaning": "時計", "example": "ドラえもんは時計を見て時間を確かめた。", "translation": "Doraemon checked the time on his clock."},
     {"word": "actor", "meaning": "俳優", "example": "ドラえもんは映画で俳優役を演じた。", "translation": "Doraemon played an actor role in the movie."},
     {"word": "solve", "meaning": "解決する", "example": "ドラえもんはのび太のトラブルを解決した。", "translation": "Doraemon solved Nobita's problem."},
     ];
     break;
     case "中学英語44":
     item = [
     {"word": "nail", "meaning": "爪", "example": "ドラえもんはロボットなので爪がない。", "translation": "Doraemon is a robot so he doesn't have nails."},
     {"word": "change", "meaning": "変える", "example": "ドラえもんはひみつ道具で見た目を変えた。", "translation": "Doraemon changed his appearance with his secret gadget."},
     {"word": "potato", "meaning": "じゃがいも", "example": "ドラえもんは畑でじゃがいもを育てた。", "translation": "Doraemon grew potatoes in the field."},
     {"word": "ring", "meaning": "指輪", "example": "ドラえもんは指輪をひみつ道具にした。", "translation": "Doraemon made a ring into a secret gadget."},
     {"word": "fishing", "meaning": "釣り", "example": "ドラえもんはのび太と釣りに行った。", "translation": "Doraemon went fishing with Nobita."},
     {"word": "journey", "meaning": "旅", "example": "ドラえもんは過去への旅を楽しんだ。", "translation": "Doraemon enjoyed his journey into the past."},
     {"word": "bring", "meaning": "持ってくる", "example": "ドラえもんはひみつ道具を持ってきてくれた。", "translation": "Doraemon brought his secret gadget for us."},
     {"word": "toast", "meaning": "トースト", "example": "ドラえもんは朝食にトーストを食べた。", "translation": "Doraemon ate toast for breakfast."},
     {"word": "salt", "meaning": "塩", "example": "ドラえもんは料理に少し塩を振った。", "translation": "Doraemon sprinkled a little salt on his food."},
     {"word": "fat", "meaning": "脂肪", "example": "ドラえもんは太らないように気をつけている。", "translation": "Doraemon is careful not to get fat."},
     ];
     break;
     case "中学英語45":
     item = [
     {"word": "all", "meaning": "すべて", "example": "ドラえもんはすべてを解決する。", "translation": "Doraemon solves everything."},
     {"word": "had", "meaning": "持っていた", "example": "ドラえもんはひみつ道具を持っていた。", "translation": "Doraemon had secret gadgets."},
     {"word": "lion", "meaning": "ライオン", "example": "ドラえもんはライオンの着ぐるみを着た。", "translation": "Doraemon wore a lion costume."},
     {"word": "animal", "meaning": "動物", "example": "ドラえもんは動物たちと友達になった。", "translation": "Doraemon became friends with animals."},
     {"word": "zero", "meaning": "ゼロ", "example": "ドラえもんはテストでゼロ点を取らない。", "translation": "Doraemon never gets zero on a test."},
     {"word": "bake", "meaning": "焼く", "example": "ドラえもんはどら焼きを焼いた。", "translation": "Doraemon baked dorayaki."},
     {"word": "cycle", "meaning": "自転車", "example": "ドラえもんは自転車に乗るのが苦手。", "translation": "Doraemon is not good at riding a bicycle."},
     {"word": "daughter", "meaning": "娘", "example": "ドラえもんには娘はいない。", "translation": "Doraemon doesn't have a daughter."},
     {"word": "parent", "meaning": "親", "example": "ドラえもんはのび太の親のような存在だ。", "translation": "Doraemon is like a parent to Nobita."},
     {"word": "classroom", "meaning": "教室", "example": "ドラえもんはのび太と教室で勉強した。", "translation": "Doraemon studied with Nobita in the classroom."},
     ];
     break;
     case "中学英語46":
     item = [
     {"word": "along", "meaning": "～に沿って", "example": "ドラえもんは川に沿って歩いた。", "translation": "Doraemon walked along the river."},
     {"word": "tell", "meaning": "話す", "example": "ドラえもんはのび太にひみつ道具のことを話した。", "translation": "Doraemon told Nobita about his secret gadgets."},
     {"word": "cheese", "meaning": "チーズ", "example": "ドラえもんはチーズ味のどら焼きが好きだ。", "translation": "Doraemon likes cheese-flavored dorayaki."},
     {"word": "notice", "meaning": "気づく", "example": "ドラえもんはのび太の異変に気づいた。", "translation": "Doraemon noticed something strange about Nobita."},
     {"word": "blossom", "meaning": "開花", "example": "ドラえもんは桜の開花を楽しみにしている。", "translation": "Doraemon is looking forward to the cherry blossoms."},
     {"word": "fit", "meaning": "合う", "example": "ドラえもんの道具はのび太にぴったり合う。", "translation": "Doraemon's gadgets fit Nobita perfectly."},
     {"word": "menu", "meaning": "メニュー", "example": "ドラえもんはレストランでメニューを見た。", "translation": "Doraemon looked at the menu in the restaurant."},
     {"word": "for", "meaning": "～のために", "example": "ドラえもんはのび太のためにひみつ道具を使う。", "translation": "Doraemon uses his secret gadgets for Nobita."},
     {"word": "they", "meaning": "彼らは", "example": "ドラえもんと仲間たちはいつも一緒だ。", "translation": "Doraemon and his friends are always together."},
     {"word": "yourselves", "meaning": "あなたたち自身", "example": "ドラえもんは「あなたたち自身でやってみて」と言った。", "translation": "Doraemon said, 'Try it yourselves'."},
     ];
     break;
     case "中学英語47":
     item = [
     {"word": "state", "meaning": "状態", "example": "ドラえもんは故障した状態だった。", "translation": "Doraemon was in a broken state."},
     {"word": "convenience", "meaning": "便利", "example": "ドラえもんは便利なひみつ道具をたくさん持っている。", "translation": "Doraemon has many convenient secret gadgets."},
     {"word": "watch", "meaning": "見る", "example": "ドラえもんはテレビで野球を観戦した。", "translation": "Doraemon watched baseball on TV."},
     {"word": "tree", "meaning": "木", "example": "ドラえもんは木の下で昼寝をした。", "translation": "Doraemon took a nap under the tree."},
     {"word": "anyone", "meaning": "誰か", "example": "ドラえもんは誰か友達を探した。", "translation": "Doraemon looked for a friend."},
     {"word": "shoulder", "meaning": "肩", "example": "ドラえもんはのび太の肩をたたいた。", "translation": "Doraemon tapped Nobita on the shoulder."},
     {"word": "clerk", "meaning": "店員", "example": "ドラえもんはコンビニの店員に話しかけた。", "translation": "Doraemon spoke to the clerk at the convenience store."},
     {"word": "then", "meaning": "それから", "example": "ドラえもんは宿題をして、それから遊んだ。", "translation": "Doraemon did his homework and then played."},
     {"word": "morning", "meaning": "朝", "example": "ドラえもんは朝早く起きた。", "translation": "Doraemon woke up early in the morning."},
     {"word": "top", "meaning": "一番上", "example": "ドラえもんは山の頂上に登った。", "translation": "Doraemon climbed to the top of the mountain."},
     ];
     break;
    
     
     case "中学英語48":
     item = [
     {"word": "medicine", "meaning": "薬", "example": "ドラえもんは、のび太が風邪を引いたときのために、未来の薬を取り出した。", "translation": "Doraemon took out a future medicine for Nobita when he caught a cold."},
     {"word": "him", "meaning": "彼を", "example": "のび太はいつもドラえもんに頼ってばかりいるので、ドラえもんは彼を心配している。", "translation": "Nobita always relies on Doraemon, so Doraemon is worried about him."},
     {"word": "me", "meaning": "私を", "example": "ドラえもんは「僕を頼って！」と、のび太に言った。", "translation": "Doraemon said to Nobita, 'Rely on me!'"},
     {"word": "thank", "meaning": "感謝する", "example": "のび太はいつもドラえもんに「ありがとう」と感謝する。", "translation": "Nobita always thanks Doraemon."},
     {"word": "person", "meaning": "人", "example": "ドラえもんは人間ではないけれど、のび太にとっては大切な人だ。", "translation": "Doraemon is not human, but he is an important person for Nobita."},
     {"word": "them", "meaning": "彼らを", "example": "ドラえもんはのび太たちをどこでもドアで色々な場所に連れて行った。", "translation": "Doraemon took them to various places with the Anywhere Door."},
     {"word": "god", "meaning": "神", "example": "のび太はドラえもんに「あなたは僕にとって神様だよ」と言った。", "translation": "Nobita said to Doraemon, 'You are a god to me.'"},
     {"word": "damage", "meaning": "損害", "example": "ドラえもんの道具の使い過ぎで、時々ひどい損害が出ることがある。", "translation": "Sometimes, using Doraemon's gadgets too much causes serious damage."},
     {"word": "hot", "meaning": "暑い", "example": "真夏の暑い日に、ドラえもんはどこでもドアで涼しい場所へ連れて行ってくれた。", "translation": "On a hot summer day, Doraemon took us to a cool place with the Anywhere Door."},
     {"word": "test", "meaning": "テスト", "example": "のび太はいつもテストの点が悪く、ドラえもんに助けを求める。", "translation": "Nobita always gets bad scores on tests and asks Doraemon for help."}
     ];
     break;
     case "中学英語49":
     item = [
     {"word": "lily", "meaning": "ユリ", "example": "しずかちゃんは、ドラえもんが庭に植えたユリの花を気に入っている。", "translation": "Shizuka likes the lily flowers that Doraemon planted in the garden."},
     {"word": "pass", "meaning": "合格する", "example": "のび太はドラえもんに頼ってばかりで、テストに合格することはない。", "translation": "Nobita always relies on Doraemon and never passes his tests."},
     {"word": "rule", "meaning": "規則", "example": "ドラえもんは、どんな時でも時間を守るという規則をのび太に教えた。", "translation": "Doraemon taught Nobita the rule of being on time."},
     {"word": "mother", "meaning": "お母さん", "example": "のび太のお母さんはいつもドラえもんの事を心配している。", "translation": "Nobita's mother is always worried about Doraemon."},
     {"word": "dish", "meaning": "料理", "example": "ドラえもんは、未来の技術を使っておいしい料理を作った。", "translation": "Doraemon used future technology to make delicious dishes."},
     {"word": "bowl", "meaning": "お椀", "example": "ドラえもんは、のび太がお茶碗を割ってしまったので、新しいお椀を出した。", "translation": "Doraemon took out a new bowl because Nobita broke the one he was using."},
     {"word": "yet", "meaning": "まだ", "example": "のび太は、ドラえもんの道具の使い方をまだ理解していない。", "translation": "Nobita has not yet understood how to use Doraemon's gadgets."},
     {"word": "agree", "meaning": "同意する", "example": "ドラえもんは、のび太の提案にいつも同意するとは限らない。", "translation": "Doraemon doesn't always agree with Nobita's suggestions."},
     {"word": "act", "meaning": "行動する", "example": "ドラえもんは、のび太が困っている時にはすぐに行動する。", "translation": "Doraemon acts immediately when Nobita is in trouble."},
     {"word": "tour", "meaning": "旅行", "example": "ドラえもんはのび太をタイムマシンで恐竜時代のツアーに連れて行った。", "translation": "Doraemon took Nobita on a tour of the dinosaur era using his time machine."}
     ];
     break;
     case "中学英語50":
     item = [
     {"word": "usual", "meaning": "いつもの", "example": "のび太はいつものようにドラえもんに宿題を頼った。", "translation": "Nobita, as usual, asked Doraemon for help with his homework."},
     {"word": "why", "meaning": "なぜ", "example": "のび太はドラえもんに「なぜいつも僕を助けてくれるの？」と聞いた。", "translation": "Nobita asked Doraemon, 'Why do you always help me?'"},
     {"word": "picnic", "meaning": "ピクニック", "example": "ドラえもんはのび太たちと秘密道具を使って楽しいピクニックに出かけた。", "translation": "Doraemon went on a fun picnic with Nobita and others using his secret gadgets."},
     {"word": "although", "meaning": "～だけれども", "example": "ドラえもんは、のび太はいつも失敗するけれども、見捨てることはしない。", "translation": "Although Nobita always fails, Doraemon never abandons him."},
     {"word": "report", "meaning": "レポート", "example": "のび太はドラえもんの助けを借りて、夏休みのレポートを終わらせた。", "translation": "Nobita finished his summer vacation report with the help of Doraemon."},
     {"word": "singer", "meaning": "歌手", "example": "ドラえもんとのび太は、未来の歌手のコンサートをタイムマシンで見に行った。", "translation": "Doraemon and Nobita went to see a future singer's concert using the time machine."},
     {"word": "career", "meaning": "職業", "example": "ドラえもんは、のび太の将来の職業について色々と考えている。", "translation": "Doraemon is thinking about Nobita's future career."},
     {"word": "hope", "meaning": "希望", "example": "のび太はドラえもんのおかげで、いつも希望を失わずにいられる。", "translation": "Nobita can always keep hope thanks to Doraemon."},
     {"word": "experience", "meaning": "経験", "example": "ドラえもんは、のび太に色々な経験をさせようとしている。", "translation": "Doraemon is trying to give Nobita various experiences."},
     ];
     break;
     case "中学英語51":
     item = [
     {"word": "rise", "meaning": "上がる", "example": "ドラえもんが太陽の光に照らされて、空中にフワッと上がった。", "translation": "Doraemon, illuminated by the sunlight, rose gently into the air."},
     {"word": "narrow", "meaning": "狭い", "example": "どこでもドアの中は意外と狭くて、ドラえもんはいつも少し窮屈そうにしている。", "translation": "The inside of the Anywhere Door is surprisingly narrow, and Doraemon always seems a bit cramped."},
     {"word": "impress", "meaning": "感動させる", "example": "ドラえもんの秘密道具は、いつもみんなを感動させる。", "translation": "Doraemon's secret gadgets always impress everyone."},
     {"word": "guess", "meaning": "推測する", "example": "のび太はドラえもんが次に何を出すのかを、いつも推測しようとする。", "translation": "Nobita always tries to guess what Doraemon will bring out next."},
     {"word": "bye", "meaning": "さようなら", "example": "ドラえもんは、いつも最後に「じゃあ、またね！」と手を振ってさようならをする。", "translation": "Doraemon always waves and says 'See you again!' at the end."},
     {"word": "paint", "meaning": "塗る", "example": "ドラえもんは、のび太と一緒に秘密道具を使って壁をカラフルに塗った。", "translation": "Doraemon and Nobita used a secret gadget to paint the wall colorfully."},
     {"word": "forget", "meaning": "忘れる", "example": "のび太は、ドラえもんの誕生日を時々忘れてしまう。", "translation": "Nobita sometimes forgets Doraemon's birthday."},
     {"word": "giant", "meaning": "巨人", "example": "ジャイアンはいつもみんなをいじめるが、ドラえもんはジャイアンを怖がらない。", "translation": "Gian always bullies everyone, but Doraemon is not afraid of Gian."},
     {"word": "spirit", "meaning": "精神", "example": "ドラえもんは、のび太の優しい精神をいつも応援している。", "translation": "Doraemon always supports Nobita's gentle spirit."},
     {"word": "butter", "meaning": "バター", "example": "ドラえもんは、のび太のためにホットケーキにたっぷりバターを塗ってくれた。", "translation": "Doraemon generously spread butter on Nobita's pancake."}
     ];
     break;
     case "中学英語52":
     item = [
     {"word": "importance", "meaning": "重要性", "example": "ドラえもんは、のび太に時間の大切さや勉強の重要性を教えようとする。", "translation": "Doraemon tries to teach Nobita the importance of time and the importance of studying."},
     {"word": "postcard", "meaning": "絵はがき", "example": "ドラえもんは、未来から来た友人たちに絵はがきを送ることがある。", "translation": "Doraemon sometimes sends postcards to his friends who came from the future."},
     {"word": "separate", "meaning": "分ける", "example": "ドラえもんは、いつもお菓子をみんなに分けてくれる。", "translation": "Doraemon always shares his snacks with everyone."},
     {"word": "German", "meaning": "ドイツの", "example": "ドラえもんは、タイムマシンを使ってドイツの昔の街並みをのび太に見せた。", "translation": "Doraemon showed Nobita an old German cityscape using the time machine."},
     {"word": "clear", "meaning": "明確な", "example": "ドラえもんは、のび太に「諦めないこと」を明確に伝えた。", "translation": "Doraemon clearly conveyed to Nobita that he should not give up."},
     {"word": "necessary", "meaning": "必要な", "example": "のび太は、いつもドラえもんの助けがどうしても必要だと思っている。", "translation": "Nobita always thinks he absolutely needs Doraemon's help."},
     {"word": "he", "meaning": "彼は", "example": "のび太は彼（ドラえもん）がいないと何もできない。", "translation": "Nobita can't do anything without him (Doraemon)."},
     {"word": "between", "meaning": "～の間に", "example": "ドラえもんはいつも、のび太とジャイアンの間に立って喧嘩を止めようとする。", "translation": "Doraemon always stands between Nobita and Gian to try and stop their fights."},
     {"word": "behind", "meaning": "～の後ろに", "example": "ドラえもんは、のび太の背後からいつも優しく見守っている。", "translation": "Doraemon is always watching over Nobita gently from behind him."},
     {"word": "bridge", "meaning": "橋", "example": "ドラえもんはどこでもドアを使って川に橋をかけて、みんなを向こう岸へ連れて行った。", "translation": "Doraemon used the Anywhere Door to create a bridge over the river and take everyone to the other side."}
     ];
     break;
     case "中学英語53":
     item = [
     {"word": "herself", "meaning": "彼女自身を", "example": "しずかちゃんはいつも自分自身を大切にしている。", "translation": "Shizuka always takes care of herself."},
     {"word": "overseas", "meaning": "海外へ", "example": "ドラえもんは、どこでもドアで気軽に海外へ旅行することがある。", "translation": "Doraemon sometimes travels overseas easily with the Anywhere Door."},
     {"word": "shampoo", "meaning": "シャンプー", "example": "ドラえもんは、お風呂に入る時も便利な秘密道具のシャンプーを使う。", "translation": "Doraemon uses a convenient secret gadget shampoo when taking a bath."},
     {"word": "invite", "meaning": "招待する", "example": "ドラえもんは、時々友達を未来の世界に招待することがある。", "translation": "Doraemon sometimes invites his friends to the future world."},
     {"word": "lady", "meaning": "女性", "example": "ドラえもんは、しずかちゃんをいつも大切にする紳士的なレディーだ。", "translation": "Doraemon is a gentleman who always cherishes Shizuka as a lady."},
     {"word": "laugh", "meaning": "笑う", "example": "のび太はドラえもんのおもしろい行動を見ていつも笑っている。", "translation": "Nobita is always laughing at Doraemon's funny behavior."},
     {"word": "farmer", "meaning": "農家", "example": "ドラえもんとのび太は、タイムマシンで過去の農家を訪れた。", "translation": "Doraemon and Nobita visited a farmer in the past using the time machine."},
     {"word": "healthy", "meaning": "健康な", "example": "ドラえもんはいつも健康で元気だ。", "translation": "Doraemon is always healthy and energetic."},
     {"word": "floor", "meaning": "床", "example": "のび太はいつも部屋の床にマンガを散らかしている。", "translation": "Nobita always scatters manga on the floor of his room."},
     {"word": "bakery", "meaning": "パン屋", "example": "ドラえもんは、町のパン屋さんの焼きたてのパンが大好きだ。", "translation": "Doraemon loves the freshly baked bread from the town bakery."}
     ];
     break;
     case "中学英語54":
     item = [
     {"word": "leave", "meaning": "出発する", "example": "ドラえもんは、のび太が遅刻しそうになると、時間どおりに家を出発させる。", "translation": "Doraemon makes Nobita leave the house on time when he's about to be late."},
     {"word": "volleyball", "meaning": "バレーボール", "example": "ドラえもんは、のび太たちと一緒にバレーボールをすることがある。", "translation": "Doraemon sometimes plays volleyball with Nobita and the others."},
     {"word": "out", "meaning": "外へ", "example": "ドラえもんは、のび太を外に連れ出して遊ぶ。", "translation": "Doraemon takes Nobita out to play."},
     {"word": "track", "meaning": "線路", "example": "ドラえもんとのび太は、線路の上を歩くことは危険だと知っている。", "translation": "Doraemon and Nobita know that it is dangerous to walk on the tracks."},
     {"word": "both", "meaning": "両方", "example": "ドラえもんは、のび太の両方の宿題を手伝うことがある。", "translation": "Doraemon sometimes helps Nobita with both of his homework assignments."},
     {"word": "again", "meaning": "再び", "example": "のび太は、何度も失敗するが、ドラえもんの助けで再び挑戦する。", "translation": "Nobita fails many times, but with Doraemon's help, he tries again."},
     {"word": "bamboo", "meaning": "竹", "example": "ドラえもんは、竹を使った秘密道具で、のび太を助けた。", "translation": "Doraemon helped Nobita with a secret gadget made of bamboo."},
     {"word": "free", "meaning": "自由な", "example": "ドラえもんは、いつも自由に空を飛びたいと思っている。", "translation": "Doraemon always wants to fly freely in the sky."},
     {"word": "phone", "meaning": "電話", "example": "ドラえもんは、未来の電話を使って、友達と話すことがある。", "translation": "Doraemon sometimes uses a future phone to talk with his friends."},
     {"word": "salad", "meaning": "サラダ", "example": "ドラえもんは、のび太のために栄養満点なサラダを作ることがある。", "translation": "Doraemon sometimes makes a nutritious salad for Nobita."}
     ];
     break;
     case "中学英語55":
     item = [
     {"word": "programmer", "meaning": "プログラマー", "example": "ドラえもんは、未来のプログラマーが作った。", "translation": "Doraemon was created by a future programmer."},
     {"word": "purpose", "meaning": "目的", "example": "ドラえもんの目的は、のび太を幸せにすることだ。", "translation": "Doraemon's purpose is to make Nobita happy."},
     {"word": "football", "meaning": "サッカー", "example": "ドラえもんは、のび太たちとサッカーをして遊ぶことがある。", "translation": "Doraemon sometimes plays soccer with Nobita and his friends."},
     {"word": "design", "meaning": "デザイン", "example": "ドラえもんの体は、未来の技術を使ってデザインされた。", "translation": "Doraemon's body was designed using future technology."},
     {"word": "news", "meaning": "ニュース", "example": "ドラえもんは、未来のニュースを見て、現代の世界の出来事を教えてくれる。", "translation": "Doraemon watches future news and tells us about the events in the modern world."},
     {"word": "hate", "meaning": "嫌う", "example": "のび太は勉強が大嫌いだ。", "translation": "Nobita hates studying."},
     {"word": "north", "meaning": "北", "example": "ドラえもんとのび太は、どこでもドアで北極へ旅行した。", "translation": "Doraemon and Nobita traveled to the North Pole with the Anywhere Door."},
     {"word": "excuse", "meaning": "言い訳", "example": "のび太はいつも宿題を忘れた言い訳をドラえもんにする。", "translation": "Nobita always makes excuses to Doraemon for forgetting his homework."},
     {"word": "quickly", "meaning": "早く", "example": "ドラえもんは、のび太を助けるためにいつも早く駆けつける。", "translation": "Doraemon always rushes to help Nobita quickly."},
     {"word": "sport", "meaning": "スポーツ", "example": "ドラえもんは、のび太と一緒に色々なスポーツを楽しむ。", "translation": "Doraemon enjoys various sports with Nobita."}
     ];
     break;
     case "中学英語56":
     item = [
     {"word": "hamburger", "meaning": "ハンバーガー", "example": "ドラえもんは、のび太と一緒に未来のハンバーガーを食べた。", "translation": "Doraemon ate a future hamburger with Nobita."},
     {"word": "attention", "meaning": "注意", "example": "ドラえもんは、のび太に危ないから注意するように言う。", "translation": "Doraemon tells Nobita to pay attention because it's dangerous."},
     {"word": "resource", "meaning": "資源", "example": "ドラえもんは、未来の資源の使い方をのび太に教えてくれる。", "translation": "Doraemon teaches Nobita how to use resources from the future."},
     {"word": "trouble", "meaning": "トラブル", "example": "ドラえもんは、いつもトラブルに巻き込まれるのび太を助ける。", "translation": "Doraemon always helps Nobita who gets caught up in trouble."},
     {"word": "coach", "meaning": "コーチ", "example": "ドラえもんは、のび太の運動のコーチになることがある。", "translation": "Doraemon sometimes becomes Nobita's sports coach."},
     {"word": "meter", "meaning": "メーター", "example": "ドラえもんの身長は129.3センチメーターだ。", "translation": "Doraemon's height is 129.3 centimeters."},
     {"word": "sightseeing", "meaning": "観光", "example": "ドラえもんは、どこでもドアで色々な場所に観光に行く。", "translation": "Doraemon goes sightseeing in various places with the Anywhere Door."},
     {"word": "upset", "meaning": "動揺した", "example": "のび太は、ジャイアンに宿題を破られて動揺した。", "translation": "Nobita was upset when Gian tore up his homework."},
     {"word": "road", "meaning": "道", "example": "ドラえもんとのび太は、いつも一緒に学校への道を通る。", "translation": "Doraemon and Nobita always walk to school together on the same road."},
     {"word": "million", "meaning": "百万", "example": "ドラえもんは、百万個の秘密道具を持っている。", "translation": "Doraemon has millions of secret gadgets."}
     ];
     break;
     case "中学英語57":
     item = [
     {"word": "father", "meaning": "お父さん", "example": "のび太のお父さんはいつも優しくのび太を見守っている。", "translation": "Nobita's father always watches over Nobita kindly."},
     {"word": "power", "meaning": "力", "example": "ドラえもんは、未来の科学の力を使える。", "translation": "Doraemon can use the power of future science."},
     {"word": "child", "meaning": "子供", "example": "ドラえもんは、のび太にとって最高の子供時代の友達だ。", "translation": "Doraemon is Nobita's best childhood friend."},
     {"word": "rainy", "meaning": "雨の", "example": "雨の日にドラえもんは、のび太に傘を出してくれる。", "translation": "On rainy days, Doraemon gives Nobita an umbrella."},
     {"word": "ruler", "meaning": "定規", "example": "ドラえもんは、未来の便利な定規を持っている。", "translation": "Doraemon has a convenient ruler from the future."},
     {"word": "gentlemen", "meaning": "紳士たち", "example": "ドラえもんはいつも紳士たちのように礼儀正しい。", "translation": "Doraemon is always polite like a gentleman."},
     {"word": "every", "meaning": "毎～", "example": "ドラえもんは、毎日のび太と遊ぶ。", "translation": "Doraemon plays with Nobita every day."},
     {"word": "Indian", "meaning": "インドの", "example": "ドラえもんとのび太は、タイムマシンでインドの昔の街へ旅行した。", "translation": "Doraemon and Nobita traveled to an old Indian town with the time machine."},
     {"word": "line", "meaning": "線", "example": "ドラえもんは、どこでもドアで部屋に線を引き、そこから先へは行かないように言った。", "translation": "Doraemon drew a line in the room with the Anywhere Door and told everyone not to go beyond it."}
     ];
     break;
     case "中学英語58":
     item = [
     {"word": "smart", "meaning": "賢い", "example": "ドラえもんは、とても賢いロボットだ。", "translation": "Doraemon is a very smart robot."},
     {"word": "eat", "meaning": "食べる", "example": "ドラえもんは、どら焼きを食べるのが大好きだ。", "translation": "Doraemon loves to eat dorayaki."},
     {"word": "catch", "meaning": "捕まえる", "example": "ドラえもんは、のび太が逃げ出した猫を捕まえた。", "translation": "Doraemon caught the cat that Nobita let escape."},
     {"word": "uniform", "meaning": "制服", "example": "のび太はいつも学校の制服を着ている。", "translation": "Nobita always wears his school uniform."},
     {"word": "rich", "meaning": "裕福な", "example": "スネ夫は裕福な家庭に育った。", "translation": "Suneo grew up in a rich family."},
     {"word": "machine", "meaning": "機械", "example": "ドラえもんは未来の機械だ。", "translation": "Doraemon is a machine from the future."},
     {"word": "sky", "meaning": "空", "example": "ドラえもんとのび太は、タケコプターで空を飛んだ。", "translation": "Doraemon and Nobita flew in the sky with the Bamboo Copter."},
     {"word": "life", "meaning": "人生", "example": "ドラえもんはのび太の人生をより良くしようとしている。", "translation": "Doraemon is trying to make Nobita's life better."},
     {"word": "positive", "meaning": "前向きな", "example": "ドラえもんは、いつも前向きな考え方を持っている。", "translation": "Doraemon always has a positive attitude."},
     {"word": "friendship", "meaning": "友情", "example": "ドラえもんとのび太の友情はとても強い。", "translation": "The friendship between Doraemon and Nobita is very strong."}
     ];
     break;
    
     
     case "中学英語59":
     item = [
     {"word": "break", "meaning": "壊す", "example": "のび太はいつもドラえもんの道具を壊してしまう。", "translation": "Nobita always breaks Doraemon's gadgets."},
     {"word": "lesson", "meaning": "授業", "example": "のび太は授業中にいつも寝ている。", "translation": "Nobita always sleeps during lessons."},
     {"word": "toy", "meaning": "おもちゃ", "example": "ドラえもんは、未来のおもちゃをたくさん持っている。", "translation": "Doraemon has many toys from the future."},
     {"word": "computer", "meaning": "コンピューター", "example": "ドラえもんは、コンピューターを使って情報収集をする。", "translation": "Doraemon uses a computer to gather information."},
     {"word": "noon", "meaning": "正午", "example": "正午になると、のび太はいつもお腹が空く。", "translation": "Nobita always gets hungry at noon."},
     {"word": "theirs", "meaning": "彼らのもの", "example": "このお菓子は、ジャイアンとスネ夫のものだ。", "translation": "These snacks are theirs, Gian and Suneo's."},
     {"word": "usually", "meaning": "普段は", "example": "ドラえもんは普段は優しいが、怒ると怖い。", "translation": "Doraemon is usually kind, but he's scary when angry."},
     {"word": "chew", "meaning": "噛む", "example": "のび太は、ガムをクチャクチャ噛む。", "translation": "Nobita chews gum loudly."},
     {"word": "rice", "meaning": "米", "example": "ドラえもんは、炊きたての米が好きだ。", "translation": "Doraemon likes freshly cooked rice."},
     {"word": "pumpkin", "meaning": "かぼちゃ", "example": "ドラえもんは、ハロウィンの時にかぼちゃを飾った。", "translation": "Doraemon decorated with pumpkins for Halloween."}
     ];
     break;
     case "中学英語60":
     item = [
     {"word": "us", "meaning": "私たちを", "example": "ドラえもんはいつも私たち（のび太たち）を助けてくれる。", "translation": "Doraemon always helps us (Nobita and the others)."},
     {"word": "decide", "meaning": "決める", "example": "ドラえもんは、どこに行くかをのび太たちと一緒に決める。", "translation": "Doraemon decides where to go with Nobita and the others."},
     {"word": "inside", "meaning": "中に", "example": "どこでもドアの中は、外から見るよりも広い。", "translation": "The inside of the Anywhere Door is wider than it looks from the outside."},
     {"word": "sightsee", "meaning": "観光する", "example": "ドラえもんは、のび太と色々な場所に観光に行く。", "translation": "Doraemon goes sightseeing in various places with Nobita."},
     {"word": "tournament", "meaning": "大会", "example": "ドラえもんは、野球の大会でジャイアンを応援する。", "translation": "Doraemon cheers for Gian at the baseball tournament."},
     {"word": "activity", "meaning": "活動", "example": "ドラえもんは、色々な活動をのび太と一緒に楽しむ。", "translation": "Doraemon enjoys various activities with Nobita."},
     {"word": "sunshine", "meaning": "日光", "example": "ドラえもんは、日光浴をするとエネルギーが回復する。", "translation": "Doraemon's energy recovers when he basks in the sunshine."},
     {"word": "present", "meaning": "プレゼント", "example": "ドラえもんは、のび太の誕生日に特別なプレゼントを贈った。", "translation": "Doraemon gave Nobita a special present for his birthday."},
     {"word": "table", "meaning": "テーブル", "example": "ドラえもんは、テーブルの上にどら焼きを並べた。", "translation": "Doraemon placed dorayaki on the table."}
     ];
     break;
     case "中学英語61":
     item = [
     {"word": "Monday", "meaning": "月曜日", "example": "のび太はいつも月曜日の朝に学校に行くのが嫌だ。", "translation": "Nobita always hates going to school on Monday mornings."},
     {"word": "hit", "meaning": "打つ", "example": "ジャイアンはよくのび太を叩く。", "translation": "Gian often hits Nobita."},
     {"word": "storm", "meaning": "嵐", "example": "嵐の日に、ドラえもんはのび太を安全な場所に避難させた。", "translation": "On a stormy day, Doraemon evacuated Nobita to a safe place."},
     {"word": "factory", "meaning": "工場", "example": "ドラえもんとのび太は、タイムマシンで未来の工場を見学した。", "translation": "Doraemon and Nobita visited a future factory with the time machine."},
     {"word": "booth", "meaning": "ブース", "example": "ドラえもんは、未来のゲームブースで遊んだ。", "translation": "Doraemon played at a future game booth."},
     {"word": "last", "meaning": "最後の", "example": "ドラえもんは、最後のどら焼きをのび太にあげた。", "translation": "Doraemon gave the last dorayaki to Nobita."},
     {"word": "accident", "meaning": "事故", "example": "ドラえもんとのび太は、タイムマシンの事故に巻き込まれそうになった。", "translation": "Doraemon and Nobita were about to get into a time machine accident."},
     {"word": "broke", "meaning": "壊れた", "example": "のび太は、またドラえもんの道具を壊してしまった。", "translation": "Nobita broke Doraemon's gadget again."},
     {"word": "forward", "meaning": "前へ", "example": "ドラえもんは、のび太を未来へ前進させようと頑張っている。", "translation": "Doraemon is trying hard to move Nobita forward into the future."},
     {"word": "wind", "meaning": "風", "example": "ドラえもんは、風を使って空を飛ぶ秘密道具を使うことがある。", "translation": "Doraemon sometimes uses a secret gadget that uses wind to fly."}
     ];
     break;
     case "中学英語62":
     item = [
     {"word": "trip", "meaning": "旅行", "example": "ドラえもんは、のび太を色々な場所に旅行に連れて行く。", "translation": "Doraemon takes Nobita on trips to various places."},
     {"word": "spot", "meaning": "場所", "example": "ドラえもんは、秘密道具を使っていつも最高の場所を見つける。", "translation": "Doraemon always finds the best spots using his secret gadgets."},
     {"word": "pilot", "meaning": "パイロット", "example": "ドラえもんは、どこでもドアでパイロットの気分を味わえる。", "translation": "Doraemon can experience being a pilot with the Anywhere Door."},
     {"word": "railway", "meaning": "鉄道", "example": "ドラえもんは、のび太を未来の鉄道に乗せてあげた。", "translation": "Doraemon took Nobita on a ride on a future railway."},
     {"word": "attend", "meaning": "出席する", "example": "のび太は、ドラえもんの友達のパーティーに出席した。", "translation": "Nobita attended Doraemon's friend's party."},
     {"word": "badly", "meaning": "ひどく", "example": "のび太は、テストの結果がひどく悪かった。", "translation": "Nobita did badly on his test."},
     {"word": "scene", "meaning": "場面", "example": "ドラえもんの映画には、感動的な場面がたくさんある。", "translation": "There are many touching scenes in Doraemon movies."},
     {"word": "swim", "meaning": "泳ぐ", "example": "ドラえもんは、のび太と海で泳いだ。", "translation": "Doraemon swam in the sea with Nobita."},
     {"word": "date", "meaning": "日付", "example": "ドラえもんは、タイムマシンを使って歴史的な日付を調べることがある。", "translation": "Doraemon sometimes uses the time machine to check historical dates."},
     {"word": "science", "meaning": "科学", "example": "ドラえもんは、未来の科学の力を持っている。", "translation": "Doraemon has the power of future science."},
     {"word": "little", "meaning": "少し", "example": "のび太は、いつも少しだけドラえもんに助けてもらう。", "translation": "Nobita always asks Doraemon for a little help."}
     ];
     break;
     case "中学英語63":
     item = [
     {"word": "bury", "meaning": "埋める", "example": "ドラえもんは、タイムカプセルを庭に埋めた。", "translation": "Doraemon buried a time capsule in the garden."},
     {"word": "count", "meaning": "数える", "example": "ドラえもんは、いつもお菓子を数えてから食べる。", "translation": "Doraemon always counts his snacks before eating them."},
     {"word": "continue", "meaning": "続ける", "example": "ドラえもんは、のび太を助けることを続ける。", "translation": "Doraemon continues to help Nobita."},
     {"word": "stair", "meaning": "階段", "example": "のび太は、いつも階段で転んでしまう。", "translation": "Nobita always falls down the stairs."},
     {"word": "Saturday", "meaning": "土曜日", "example": "ドラえもんは、土曜日にのび太と一緒に遊ぶことが多い。", "translation": "Doraemon often plays with Nobita on Saturdays."},
     {"word": "notebook", "meaning": "ノート", "example": "のび太は、いつもノートに宿題を忘れる。", "translation": "Nobita always forgets his homework in his notebook."},
     {"word": "government", "meaning": "政府", "example": "ドラえもんは、未来の政府の情報を知っている。", "translation": "Doraemon knows information from the future government."},
     {"word": "friendly", "meaning": "友好的な", "example": "ドラえもんは、とても友好的なロボットだ。", "translation": "Doraemon is a very friendly robot."},
     {"word": "success", "meaning": "成功", "example": "ドラえもんは、のび太の成功をいつも願っている。", "translation": "Doraemon always hopes for Nobita's success."},
     {"word": "before", "meaning": "前に", "example": "ドラえもんは、いつも朝ごはんの前に、のび太を起こす。", "translation": "Doraemon always wakes Nobita up before breakfast."}
     ];
     break;
     case "中学英語64":
     item = [
     {"word": "beside", "meaning": "～のそばに", "example": "ドラえもんはいつも、のび太のそばにいる。", "translation": "Doraemon is always beside Nobita."},
     {"word": "wing", "meaning": "翼", "example": "ドラえもんは、タケコプターという翼を使って空を飛ぶ。", "translation": "Doraemon flies in the sky using a wing called the Bamboo Copter."},
     {"word": "actress", "meaning": "女優", "example": "ドラえもんは、テレビで未来の女優を見て感動した。", "translation": "Doraemon was impressed by seeing a future actress on TV."},
     {"word": "luckily", "meaning": "幸運にも", "example": "ドラえもんは、幸運にも問題を解決できた。", "translation": "Luckily, Doraemon was able to solve the problem."},
     {"word": "silent", "meaning": "静かな", "example": "ドラえもんは、時々静かな場所で休憩する。", "translation": "Doraemon sometimes rests in a silent place."},
     {"word": "view", "meaning": "眺め", "example": "ドラえもんは、どこでもドアで色々な眺めを楽しむ。", "translation": "Doraemon enjoys various views with the Anywhere Door."},
     {"word": "kitchen", "meaning": "台所", "example": "ドラえもんは、台所で料理をすることが好きだ。", "translation": "Doraemon likes to cook in the kitchen."},
     {"word": "add", "meaning": "加える", "example": "ドラえもんは、料理に秘密のスパイスを加える。", "translation": "Doraemon adds a secret spice to the dish."},
     {"word": "diary", "meaning": "日記", "example": "のび太は、毎日日記をつけている。", "translation": "Nobita writes in his diary every day."},
     {"word": "Thursday", "meaning": "木曜日", "example": "ドラえもんは、木曜日に特別な道具を使うことが多い。", "translation": "Doraemon often uses special gadgets on Thursdays."}
     ];
     break;
     case "中学英語65":
     item = [
     {"word": "finally", "meaning": "ついに", "example": "のび太は、ドラえもんの助けでついに宿題を終えた。", "translation": "Nobita finally finished his homework with Doraemon's help."},
     {"word": "key", "meaning": "鍵", "example": "ドラえもんは、どこでもドアの鍵を持っている。", "translation": "Doraemon has the key to the Anywhere Door."},
     {"word": "who", "meaning": "誰", "example": "ドラえもんは、誰が困っているのかを知ろうとする。", "translation": "Doraemon tries to find out who is in trouble."},
     {"word": "because", "meaning": "なぜなら", "example": "ドラえもんは、のび太を助ける、なぜなら友達だから。", "translation": "Doraemon helps Nobita because he is his friend."},
     {"word": "matter", "meaning": "問題", "example": "ドラえもんは、どんな問題でも解決してくれる。", "translation": "Doraemon can solve any problem."},
     {"word": "milk", "meaning": "牛乳", "example": "ドラえもんは、のび太に毎朝牛乳を飲ませる。", "translation": "Doraemon makes Nobita drink milk every morning."},
     {"word": "newspaper", "meaning": "新聞", "example": "ドラえもんは、未来の新聞でニュースを確認する。", "translation": "Doraemon checks the news in the future newspaper."},
     {"word": "cry", "meaning": "泣く", "example": "のび太は、いつも失敗して泣いてしまう。", "translation": "Nobita always fails and cries."},
     {"word": "today", "meaning": "今日", "example": "ドラえもんは、今日も一日頑張る。", "translation": "Doraemon will do his best today as well."},
     {"word": "effort", "meaning": "努力", "example": "ドラえもんは、のび太の努力をいつも応援する。", "translation": "Doraemon always supports Nobita's efforts."}
     ];
     break;
     case "中学英語66":
     item = [
     {"word": "back", "meaning": "後ろに", "example": "ドラえもんはいつも、のび太の後ろから見守っている。", "translation": "Doraemon is always watching over Nobita from behind."},
     {"word": "sheep", "meaning": "羊", "example": "ドラえもんとのび太は、牧場で羊を見た。", "translation": "Doraemon and Nobita saw sheep at a pasture."},
     {"word": "piano", "meaning": "ピアノ", "example": "しずかちゃんは、ピアノを弾くのが得意だ。", "translation": "Shizuka is good at playing the piano."},
     {"word": "believe", "meaning": "信じる", "example": "ドラえもんは、のび太を信じている。", "translation": "Doraemon believes in Nobita."},
     {"word": "meal", "meaning": "食事", "example": "ドラえもんは、のび太と毎日の食事を一緒にする。", "translation": "Doraemon has meals with Nobita every day."},
     {"word": "brush", "meaning": "ブラシ", "example": "ドラえもんは、秘密道具のブラシで部屋を掃除する。", "translation": "Doraemon cleans the room with a secret gadget brush."},
     {"word": "sad", "meaning": "悲しい", "example": "のび太は、テストが悪くて悲しい。", "translation": "Nobita is sad because he did badly on the test."},
     {"word": "ocean", "meaning": "海", "example": "ドラえもんとのび太は、海に遊びに行った。", "translation": "Doraemon and Nobita went to play at the ocean."},
     {"word": "bell", "meaning": "ベル", "example": "ドラえもんの首には、ベルがついている。", "translation": "Doraemon has a bell around his neck."},
     {"word": "other", "meaning": "他の", "example": "ドラえもんは、他のロボットたちと友達だ。", "translation": "Doraemon is friends with other robots."}
     ];
     break;
     case "中学英語67":
     item = [
     {"word": "keep", "meaning": "保つ", "example": "ドラえもんは、部屋をいつもきれいに保つ。", "translation": "Doraemon always keeps the room clean."},
     {"word": "teacher", "meaning": "先生", "example": "のび太は、いつも先生に怒られる。", "translation": "Nobita always gets scolded by his teacher."},
     {"word": "food", "meaning": "食べ物", "example": "ドラえもんは、未来の食べ物をたくさん持っている。", "translation": "Doraemon has a lot of food from the future."},
     {"word": "worker", "meaning": "働く人", "example": "ドラえもんは、未来の工場の働く人たちを見学した。", "translation": "Doraemon visited the workers in a future factory."},
     {"word": "must", "meaning": "～しなければならない", "example": "のび太は、宿題をしなければならない。", "translation": "Nobita must do his homework."},
     {"word": "important", "meaning": "重要な", "example": "ドラえもんは、友達との友情を重要だと思っている。", "translation": "Doraemon thinks friendship with friends is important."},
     {"word": "distance", "meaning": "距離", "example": "ドラえもんは、どこでもドアを使って距離を無視できる。", "translation": "Doraemon can ignore distance with the Anywhere Door."},
     {"word": "bug", "meaning": "虫", "example": "のび太は虫が嫌いだ。", "translation": "Nobita hates bugs."},
     {"word": "support", "meaning": "支える", "example": "ドラえもんは、いつも心の底から、のび太を支えている。", "translation": "Doraemon is always supporting Nobita from the bottom of his heart."},
     {"word": "wonder", "meaning": "不思議に思う", "example": "のび太は、いつもドラえもんの秘密道具を不思議に思っている。", "translation": "Nobita always wonders about Doraemon's secret gadgets."}
     ];
     break;
     case "中学英語68":
     item = [
     {"word": "young", "meaning": "若い", "example": "ドラえもんは、未来の若いロボットだ。", "translation": "Doraemon is a young robot from the future."},
     {"word": "safely", "meaning": "安全に", "example": "ドラえもんは、のび太をいつも安全に守ってくれる。", "translation": "Doraemon always keeps Nobita safe."},
     {"word": "put", "meaning": "置く", "example": "ドラえもんは、どら焼きをテーブルの上に置いた。", "translation": "Doraemon put dorayaki on the table."},
     {"word": "treasure", "meaning": "宝物", "example": "ドラえもんは、のび太を大切な宝物だと思っている。", "translation": "Doraemon thinks of Nobita as a precious treasure."},
     {"word": "improve", "meaning": "改善する", "example": "ドラえもんは、のび太の生活を改善しようとしている。", "translation": "Doraemon is trying to improve Nobita's life."},
     {"word": "soup", "meaning": "スープ", "example": "ドラえもんは、のび太に温かいスープを作ってあげた。", "translation": "Doraemon made warm soup for Nobita."},
     {"word": "buy", "meaning": "買う", "example": "のび太は、いつもお菓子を買ってもらう。", "translation": "Nobita always gets snacks bought for him."},
     {"word": "sure", "meaning": "確かな", "example": "ドラえもんは、いつも確かな情報を持っている。", "translation": "Doraemon always has reliable information."},
     {"word": "color", "meaning": "色", "example": "ドラえもんは、青い色が大好きだ。", "translation": "Doraemon loves the color blue."},
     {"word": "air", "meaning": "空気", "example": "ドラえもんは、空気のきれいな場所が好きだ。", "translation": "Doraemon likes places with clean air."}
     ];
     break;
     case "中学英語69":
     item = [
     {"word": "especially", "meaning": "特に", "example": "ドラえもんは特にどら焼きが好きだ。", "translation": "Doraemon especially likes dorayaki."},
     {"word": "safe", "meaning": "安全な", "example": "ドラえもんは、のび太が安全な場所にいることを確認する。", "translation": "Doraemon makes sure Nobita is in a safe place."},
     {"word": "sing", "meaning": "歌う", "example": "ジャイアンはよくみんなの前で歌を歌う。", "translation": "Gian often sings in front of everyone."},
     {"word": "loud", "meaning": "大声で", "example": "ジャイアンはいつも大声で歌う。", "translation": "Gian always sings loudly."},
     {"word": "brother", "meaning": "兄弟", "example": "ドラえもんは、のび太にとって兄弟のような存在だ。", "translation": "Doraemon is like a brother to Nobita."},
     {"word": "pink", "meaning": "ピンク色の", "example": "しずかちゃんは、ピンク色の服が好きだ。", "translation": "Shizuka likes pink clothes."},
     {"word": "bike", "meaning": "自転車", "example": "のび太は自転車に乗るのが苦手だ。", "translation": "Nobita is not good at riding a bike."},
     {"word": "create", "meaning": "作り出す", "example": "ドラえもんは、様々な秘密道具を作り出す。", "translation": "Doraemon creates various secret gadgets."},
     {"word": "original", "meaning": "オリジナルの", "example": "ドラえもんは、オリジナルの道具をたくさん持っている。", "translation": "Doraemon has many original gadgets."},
     {"word": "south", "meaning": "南", "example": "ドラえもんは、のび太と南の島へ旅行に行った。", "translation": "Doraemon went on a trip to a southern island with Nobita."}
     ];
     break;
    
     
     case "中学英語70":
     item = [
     {"word": "flavor", "meaning": "風味", "example": "ドラえもんは、どら焼きの様々な風味を楽しんでいる。", "translation": "Doraemon enjoys the various flavors of dorayaki."},
     {"word": "walk", "meaning": "歩く", "example": "ドラえもんは、のび太と一緒に学校まで歩く。", "translation": "Doraemon walks to school with Nobita."},
     {"word": "city", "meaning": "都市", "example": "ドラえもんとのび太は、未来の都市を観光した。", "translation": "Doraemon and Nobita went sightseeing in a future city."},
     {"word": "together", "meaning": "一緒に", "example": "ドラえもんはいつも、のび太と一緒に遊ぶ。", "translation": "Doraemon always plays with Nobita together."},
     {"word": "hundred", "meaning": "百", "example": "ドラえもんは、百個以上の秘密道具を持っている。", "translation": "Doraemon has more than a hundred secret gadgets."},
     {"word": "comfortable", "meaning": "快適な", "example": "ドラえもんは、どこでもドアの中で快適な時間を過ごしている。", "translation": "Doraemon spends comfortable time inside the Anywhere Door."},
     {"word": "sweater", "meaning": "セーター", "example": "のび太は、寒い日にセーターを着て暖かくしている。", "translation": "Nobita wears a sweater to keep warm on cold days."},
     {"word": "recycling", "meaning": "リサイクル", "example": "ドラえもんは、未来のリサイクルの仕組みをのび太に教えた。", "translation": "Doraemon taught Nobita about the future recycling system."},
     {"word": "find", "meaning": "見つける", "example": "ドラえもんは、いつも困っているのび太を見つける。", "translation": "Doraemon always finds Nobita when he's in trouble."},
     {"word": "lay", "meaning": "横たえる", "example": "のび太は、いつも畳の上に横たわってマンガを読んでいる。", "translation": "Nobita always lays on the tatami and reads manga."}
     ];
     break;
     case "中学英語71":
     item = [
     {"word": "marry", "meaning": "結婚する", "example": "ドラえもんは、のび太がしずかちゃんと結婚することを願っている。", "translation": "Doraemon hopes that Nobita will marry Shizuka."},
     {"word": "balcony", "meaning": "バルコニー", "example": "のび太は、バルコニーから外の景色を眺めるのが好きだ。", "translation": "Nobita likes to look at the view from the balcony."},
     {"word": "day", "meaning": "日", "example": "ドラえもんは、毎日必ずのび太と一緒にいる。", "translation": "Doraemon is always with Nobita every day."},
     {"word": "any", "meaning": "どれでも", "example": "ドラえもんは、どんな時でものび太を助ける。", "translation": "Doraemon helps Nobita at any time."},
     {"word": "case", "meaning": "場合", "example": "ドラえもんは、どんな場合でも冷静に対処する。", "translation": "Doraemon deals with any case calmly."},
     {"word": "shall", "meaning": "～しましょうか", "example": "ドラえもんは「一緒に行きましょうか？」と、のび太を誘った。", "translation": "Doraemon invited Nobita, saying, 'Shall we go together?'"},
     {"word": "from", "meaning": "～から", "example": "ドラえもんは未来から来た。", "translation": "Doraemon came from the future."},
     {"word": "speak", "meaning": "話す", "example": "ドラえもんは、のび太に優しく話しかける。", "translation": "Doraemon speaks to Nobita kindly."},
     {"word": "total", "meaning": "合計", "example": "ドラえもんの道具の合計数は、数えきれないほど多い。", "translation": "The total number of Doraemon's gadgets is countless."},
     {"word": "grandparent", "meaning": "祖父母", "example": "のび太は、時々おじいちゃんおばあちゃんの家へ遊びに行く。", "translation": "Nobita sometimes goes to his grandparents' house to play."}
     ];
     break;
     case "中学英語72":
     item = [
     {"word": "panic", "meaning": "パニック", "example": "のび太は、テストの結果を見てパニックになった。", "translation": "Nobita panicked when he saw his test results."},
     {"word": "draw", "meaning": "描く", "example": "のび太は、ドラえもんをよく描いている。", "translation": "Nobita often draws Doraemon."},
     {"word": "known", "meaning": "知られている", "example": "ドラえもんは、未来では有名なロボットだ。", "translation": "Doraemon is a well-known robot in the future."},
     {"word": "movement", "meaning": "動き", "example": "ドラえもんは、滑らかな動きで歩く。", "translation": "Doraemon walks with smooth movements."},
     {"word": "there", "meaning": "そこに", "example": "ドラえもんは、いつもそこにいてくれる。", "translation": "Doraemon is always there for me."},
     {"word": "expensive", "meaning": "高価な", "example": "ドラえもんの道具は、とても高価だ。", "translation": "Doraemon's gadgets are very expensive."},
     {"word": "hair", "meaning": "髪", "example": "しずかちゃんの髪は、いつもサラサラしている。", "translation": "Shizuka's hair is always smooth."},
     {"word": "uncle", "meaning": "おじ", "example": "のび太のおじさんが、遊びに来た。", "translation": "Nobita's uncle came to visit."},
     {"word": "junior", "meaning": "年下の", "example": "スネ夫は、のび太たちより少し年下だ。", "translation": "Suneo is a little junior to Nobita and his friends."},
     {"word": "stone", "meaning": "石", "example": "ドラえもんは、川原の石を拾い集めた。", "translation": "Doraemon collected stones from the riverbed."}
     ];
     break;
     case "中学英語73":
     item = [
     {"word": "church", "meaning": "教会", "example": "ドラえもんとのび太は、教会の前を通った。", "translation": "Doraemon and Nobita passed by a church."},
     {"word": "holiday", "meaning": "休日", "example": "ドラえもんは、休日にのび太と一緒に遊ぶ。", "translation": "Doraemon plays with Nobita on holidays."},
     {"word": "kangaroo", "meaning": "カンガルー", "example": "ドラえもんとのび太は、動物園でカンガルーを見た。", "translation": "Doraemon and Nobita saw kangaroos at the zoo."},
     {"word": "chance", "meaning": "機会", "example": "ドラえもんは、のび太にチャンスを与えようとする。", "translation": "Doraemon tries to give Nobita a chance."},
     {"word": "magazine", "meaning": "雑誌", "example": "のび太は、マンガ雑誌を読んでいる。", "translation": "Nobita is reading a manga magazine."},
     {"word": "surround", "meaning": "囲む", "example": "ドラえもんは、みんなを笑顔で囲む。", "translation": "Doraemon surrounds everyone with a smile."},
     {"word": "toward", "meaning": "～の方へ", "example": "ドラえもんは、いつも前の方へ進んでいる。", "translation": "Doraemon is always moving toward the front."},
     {"word": "trick", "meaning": "いたずら", "example": "ジャイアンは、よくのび太にいたずらをする。", "translation": "Gian often plays tricks on Nobita."},
     {"word": "greet", "meaning": "あいさつする", "example": "ドラえもんは、いつもみんなにあいさつをする。", "translation": "Doraemon always greets everyone."},
     {"word": "smile", "meaning": "笑顔", "example": "ドラえもんは、いつも笑顔でいる。", "translation": "Doraemon always has a smile on his face."}
     ];
     break;
     case "中学英語74":
     item = [
     {"word": "sale", "meaning": "セール", "example": "ドラえもんは、タイムセールでたくさんどら焼きを買った。", "translation": "Doraemon bought a lot of dorayaki at a time sale."},
     {"word": "stomach", "meaning": "お腹", "example": "のび太は、いつもお腹が空いている。", "translation": "Nobita is always hungry."},
     {"word": "cloudy", "meaning": "曇りの", "example": "今日は曇りの日だ。", "translation": "Today is a cloudy day."},
     {"word": "many", "meaning": "たくさんの", "example": "ドラえもんは、たくさんの秘密道具を持っている。", "translation": "Doraemon has many secret gadgets."},
     {"word": "suit", "meaning": "似合う", "example": "しずかちゃんは、どんな服でも似合う。", "translation": "Shizuka looks good in any clothes."},
     {"word": "Paralympics", "meaning": "パラリンピック", "example": "ドラえもんは、パラリンピックを見て感動した。", "translation": "Doraemon was moved by watching the Paralympics."},
     {"word": "almost", "meaning": "ほとんど", "example": "のび太は、いつも宿題をほとんどやっていない。", "translation": "Nobita almost never does his homework."},
     {"word": "each", "meaning": "それぞれの", "example": "ドラえもんは、それぞれに合った道具を使う。", "translation": "Doraemon uses gadgets that are suitable for each situation."},
     {"word": "end", "meaning": "終わり", "example": "ドラえもんとのび太の冒険には終わりがない。", "translation": "There is no end to Doraemon and Nobita's adventures."},
     {"word": "stand", "meaning": "立つ", "example": "ドラえもんは、のび太をいつも後ろから支える。", "translation": "Doraemon always stands behind and supports Nobita."}
     ];
     break;
     case "中学英語75":
     item = [
     {"word": "harvest", "meaning": "収穫", "example": "ドラえもんとのび太は、畑で野菜を収穫した。", "translation": "Doraemon and Nobita harvested vegetables in the field."},
     {"word": "big", "meaning": "大きい", "example": "ドラえもんは、大きな秘密道具を持っている。", "translation": "Doraemon has a big secret gadget."},
     {"word": "someday", "meaning": "いつか", "example": "のび太は、いつかドラえもんのように賢くなりたいと思っている。", "translation": "Nobita hopes to become smart someday like Doraemon."},
     {"word": "tool", "meaning": "道具", "example": "ドラえもんは、便利な道具をたくさん持っている。", "translation": "Doraemon has many useful tools."},
     {"word": "lake", "meaning": "湖", "example": "ドラえもんは、湖で釣りを楽しんだ。", "translation": "Doraemon enjoyed fishing at the lake."},
     {"word": "else", "meaning": "ほかに", "example": "ドラえもんは「ほかに何か困っていることはない？」と聞いた。", "translation": "Doraemon asked, 'Is there anything else you are having trouble with?'"},
     {"word": "racket", "meaning": "ラケット", "example": "ドラえもんは、のび太とラケットを使ってテニスをした。", "translation": "Doraemon played tennis with Nobita using a racket."},
     {"word": "performance", "meaning": "公演", "example": "ドラえもんは、未来の音楽の公演を見た。", "translation": "Doraemon watched a future music performance."},
     {"word": "remember", "meaning": "覚えている", "example": "ドラえもんは、のび太の誕生日をいつも覚えている。", "translation": "Doraemon always remembers Nobita's birthday."},
     {"word": "gym", "meaning": "体育館", "example": "ドラえもんとのび太は、体育館で一緒に運動した。", "translation": "Doraemon and Nobita exercised together in the gym."}
     ];
     break;
     case "中学英語76":
     item = [
     {"word": "upset", "meaning": "動揺した", "example": "のび太は、テストの結果が悪くて動揺した。", "translation": "Nobita was upset because his test results were bad."},
     {"word": "fall", "meaning": "落ちる", "example": "のび太は、よく転んで落ちる。", "translation": "Nobita often falls down."},
     {"word": "turtle", "meaning": "カメ", "example": "ドラえもんは、池でカメを見た。", "translation": "Doraemon saw a turtle in the pond."},
     {"word": "compare", "meaning": "比べる", "example": "ドラえもんは、過去と未来を比べるのが好きだ。", "translation": "Doraemon likes to compare the past and the future."},
     {"word": "dessert", "meaning": "デザート", "example": "ドラえもんは、どら焼きをデザートに食べた。", "translation": "Doraemon ate dorayaki for dessert."},
     {"word": "youth", "meaning": "青春", "example": "ドラえもんは、のび太の青春を応援している。", "translation": "Doraemon is supporting Nobita's youth."},
     {"word": "festival", "meaning": "祭り", "example": "ドラえもんは、夏祭りで花火を見た。", "translation": "Doraemon saw fireworks at a summer festival."},
     {"word": "aunt", "meaning": "おば", "example": "のび太のおばさんが遊びに来た。", "translation": "Nobita's aunt came to visit."},
     {"word": "cooking", "meaning": "料理", "example": "ドラえもんは、料理をするのが好きだ。", "translation": "Doraemon likes cooking."},
     {"word": "great", "meaning": "素晴らしい", "example": "ドラえもんは、素晴らしい友達だ。", "translation": "Doraemon is a great friend."}
     ];
     break;
     case "中学英語77":
     item = [
     {"word": "police", "meaning": "警察", "example": "ドラえもんは、困った時は警察に助けてもらうように言う。", "translation": "Doraemon tells Nobita to seek help from the police when in trouble."},
     {"word": "size", "meaning": "大きさ", "example": "ドラえもんの大きさは、129.3センチだ。", "translation": "Doraemon's size is 129.3 centimeters."},
     {"word": "toothbrush", "meaning": "歯ブラシ", "example": "ドラえもんは、いつも歯を磨く。", "translation": "Doraemon always brushes his teeth."},
     {"word": "such", "meaning": "そのような", "example": "ドラえもんは、そのような時にはいつも助けてくれる。", "translation": "Doraemon always helps in such situations."},
     {"word": "part", "meaning": "部分", "example": "ドラえもんは、いつも一部分だけ壊れる。", "translation": "A part of Doraemon always breaks."},
     {"word": "really", "meaning": "本当に", "example": "ドラえもんは、のび太のことが本当に好きだ。", "translation": "Doraemon really likes Nobita."},
     {"word": "home", "meaning": "家", "example": "ドラえもんは、のび太の家で暮らしている。", "translation": "Doraemon lives in Nobita's home."},
     {"word": "orchestra", "meaning": "オーケストラ", "example": "ドラえもんは、オーケストラの演奏を聴くのが好きだ。", "translation": "Doraemon likes listening to orchestra performances."},
     {"word": "highland", "meaning": "高地", "example": "ドラえもんは、高地でのび太と遊んだ。", "translation": "Doraemon played with Nobita in the highlands."},
     {"word": "nursery", "meaning": "保育園", "example": "のび太は、小さい時に保育園に通っていた。", "translation": "Nobita went to nursery school when he was little."}
     ];
     break;
     case "中学英語78":
     item = [
     {"word": "language", "meaning": "言語", "example": "ドラえもんは、色々な言語を話すことができる。", "translation": "Doraemon can speak various languages."},
     {"word": "sleep", "meaning": "眠る", "example": "のび太は、いつもすぐに眠ってしまう。", "translation": "Nobita always falls asleep immediately."},
     {"word": "public", "meaning": "公共の", "example": "ドラえもんは、公共の場所で騒がない。", "translation": "Doraemon doesn't make noise in public places."},
     {"word": "everybody", "meaning": "みんな", "example": "ドラえもんは、みんなを笑顔にする。", "translation": "Doraemon makes everybody smile."},
     {"word": "originally", "meaning": "もともと", "example": "ドラえもんはもともと、子守用のロボットだった。", "translation": "Doraemon was originally a robot for babysitting."},
     {"word": "depend", "meaning": "頼る", "example": "のび太は、いつもドラえもんに頼ってしまう。", "translation": "Nobita always depends on Doraemon."},
     {"word": "lemon", "meaning": "レモン", "example": "ドラえもんは、レモンが好きだ。", "translation": "Doraemon likes lemons."},
     {"word": "interview", "meaning": "インタビュー", "example": "ドラえもんは、未来のテレビのインタビューを受けた。", "translation": "Doraemon had an interview on a future TV show."},
     {"word": "age", "meaning": "年齢", "example": "ドラえもんは、年齢を重ねても見た目が変わらない。", "translation": "Doraemon doesn't change his appearance even as he ages."},
     {"word": "neighbor", "meaning": "隣人", "example": "ドラえもんは、近所の隣人たちと仲が良い。", "translation": "Doraemon is good friends with his neighbors."}
     ];
     break;
     case "中学英語79":
     item = [
     {"word": "fold", "meaning": "折りたたむ", "example": "ドラえもんは、どこでもドアを折りたたんでしまった。", "translation": "Doraemon folded the Anywhere Door."},
     {"word": "pull", "meaning": "引く", "example": "ドラえもんは、重い荷物を引いて運んだ。", "translation": "Doraemon pulled and carried the heavy luggage."},
     {"word": "mousetrap", "meaning": "ねずみ取り", "example": "ドラえもんは、ねずみ取りが怖い。", "translation": "Doraemon is afraid of mousetraps."},
     {"word": "astronaut", "meaning": "宇宙飛行士", "example": "ドラえもんは、宇宙飛行士に憧れている。", "translation": "Doraemon admires astronauts."},
     {"word": "early", "meaning": "早く", "example": "のび太は、いつも学校に遅刻するが、今日は早く起きた。", "translation": "Nobita is always late for school, but he woke up early today."},
     {"word": "kind", "meaning": "親切な", "example": "ドラえもんは、いつもみんなに親切だ。", "translation": "Doraemon is always kind to everyone."},
     {"word": "near", "meaning": "近くに", "example": "ドラえもんは、いつものび太の近くにいる。", "translation": "Doraemon is always near Nobita."},
     {"word": "hear", "meaning": "聞く", "example": "ドラえもんは、のび太の声を聞くとすぐに駆けつける。", "translation": "Doraemon rushes to Nobita as soon as he hears his voice."},
     {"word": "shock", "meaning": "衝撃", "example": "ドラえもんは、電気ショックを受けると故障してしまう。", "translation": "Doraemon breaks down if he receives an electric shock."},
     {"word": "beef", "meaning": "牛肉", "example": "ドラえもんは、牛肉が好きだ。", "translation": "Doraemon likes beef."}
     ];
     break;
     case "中学英語80":
     item = [
     {"word": "used", "meaning": "使われた", "example": "ドラえもんは、未来で使われた道具を持ってきている。", "translation": "Doraemon has brought gadgets that were used in the future."},
     {"word": "famous", "meaning": "有名な", "example": "ドラえもんは、未来では有名なロボットだ。", "translation": "Doraemon is a famous robot in the future."},
     {"word": "around", "meaning": "～の周りに", "example": "ドラえもんは、いつもみんなの周りにいる。", "translation": "Doraemon is always around everyone."},
     {"word": "brave", "meaning": "勇敢な", "example": "ドラえもんは、勇敢に困難に立ち向かう。", "translation": "Doraemon bravely faces difficulties."},
     {"word": "platform", "meaning": "プラットフォーム", "example": "ドラえもんは、駅のプラットフォームで電車を待った。", "translation": "Doraemon waited for the train on the platform at the station."},
     {"word": "luck", "meaning": "運", "example": "ドラえもんは、のび太に運が良くなるように願っている。", "translation": "Doraemon hopes that Nobita will have good luck."},
     {"word": "decision", "meaning": "決断", "example": "ドラえもんは、いつも正しい決断をする。", "translation": "Doraemon always makes the right decisions."},
     {"word": "dear", "meaning": "親愛なる", "example": "ドラえもんは、のび太を親愛なる友達だと思っている。", "translation": "Doraemon thinks of Nobita as a dear friend."},
     {"word": "egg", "meaning": "卵", "example": "ドラえもんは、卵を使った料理を作ることが好きだ。", "translation": "Doraemon likes to cook dishes using eggs."},
     {"word": "face", "meaning": "顔", "example": "ドラえもんは、いつも笑顔の顔をしている。", "translation": "Doraemon always has a smiling face."}
     ];
     break;
     case "中学英語81":
     item = [
     {"word": "few", "meaning": "少数の", "example": "ドラえもんは、少数の秘密道具を持って、のび太の家に来た。", "translation": "Doraemon came to Nobita's house with a few secret gadgets."},
     {"word": "training", "meaning": "訓練", "example": "ドラえもんは、のび太を助けるための訓練をしている。", "translation": "Doraemon is training to help Nobita."},
     {"word": "upon", "meaning": "～の上に", "example": "ドラえもんは、屋根の上に座って空を見ている。", "translation": "Doraemon is sitting upon the roof, looking at the sky."},
     {"word": "feeling", "meaning": "感情", "example": "ドラえもんは、のび太の気持ちを理解しようとする。", "translation": "Doraemon tries to understand Nobita's feelings."},
     {"word": "water", "meaning": "水", "example": "ドラえもんは、水を飲むのが好きだ。", "translation": "Doraemon likes to drink water."},
     {"word": "pollution", "meaning": "汚染", "example": "ドラえもんは、未来の汚染問題について心配している。", "translation": "Doraemon is worried about the pollution problems in the future."},
     {"word": "cook", "meaning": "料理する", "example": "ドラえもんは、のび太のために料理をする。", "translation": "Doraemon cooks for Nobita."},
     {"word": "window", "meaning": "窓", "example": "のび太は、窓から外を眺めている。", "translation": "Nobita is looking outside the window."},
     {"word": "gram", "meaning": "グラム", "example": "ドラえもんは、料理に必要なグラム数を正確に量る。", "translation": "Doraemon accurately measures the grams needed for cooking."},
     {"word": "program", "meaning": "番組", "example": "ドラえもんは、未来のテレビ番組を見るのが好きだ。", "translation": "Doraemon likes watching future TV programs."}
     ];
     break;
     case "中学英語82":
     item = [
     {"word": "quiz", "meaning": "クイズ", "example": "ドラえもんは、クイズを出して、のび太をテストした。", "translation": "Doraemon gave Nobita a quiz to test him."},
     {"word": "spaghetti", "meaning": "スパゲッティ", "example": "ドラえもんは、スパゲッティを美味しそうに食べた。", "translation": "Doraemon ate spaghetti with relish."},
     {"word": "banana", "meaning": "バナナ", "example": "ドラえもんは、バナナをよく食べている。", "translation": "Doraemon often eats bananas."},
     {"word": "coat", "meaning": "コート", "example": "ドラえもんは、寒い日にコートを着て暖かくした。", "translation": "Doraemon wore a coat to keep warm on cold days."},
     {"word": "light", "meaning": "光", "example": "ドラえもんは、未来の光を使って部屋を照らした。", "translation": "Doraemon used the light from the future to illuminate the room."},
     {"word": "drugstore", "meaning": "薬局", "example": "ドラえもんは、薬局で薬を買った。", "translation": "Doraemon bought medicine at the drugstore."},
     {"word": "sense", "meaning": "感覚", "example": "ドラえもんは、優れた感覚を持っている。", "translation": "Doraemon has excellent senses."},
     {"word": "gather", "meaning": "集める", "example": "ドラえもんは、みんなを庭に集めた。", "translation": "Doraemon gathered everyone in the garden."},
     {"word": "once", "meaning": "一度", "example": "ドラえもんは、一度だけ過去に行ったことがある。", "translation": "Doraemon has been to the past only once."}
     ];
     break;
     case "中学英語83":
     item = [
     {"word": "homework", "meaning": "宿題", "example": "のび太はいつも宿題を忘れる。", "translation": "Nobita always forgets his homework."},
     {"word": "math", "meaning": "算数", "example": "のび太は算数が苦手だ。", "translation": "Nobita is not good at math."},
     {"word": "dress", "meaning": "ドレス", "example": "しずかちゃんは、素敵なドレスを着ていた。", "translation": "Shizuka was wearing a lovely dress."},
     {"word": "chicken", "meaning": "鶏肉", "example": "ドラえもんは、鶏肉料理を美味しく作った。", "translation": "Doraemon made a delicious chicken dish."},
     {"word": "like", "meaning": "～が好き", "example": "ドラえもんは、どら焼きが好きだ。", "translation": "Doraemon likes dorayaki."},
     {"word": "brown", "meaning": "茶色の", "example": "ドラえもんは、茶色い帽子をかぶっている。", "translation": "Doraemon is wearing a brown hat."},
     {"word": "quite", "meaning": "かなり", "example": "ドラえもんは、かなり疲れていた。", "translation": "Doraemon was quite tired."},
     {"word": "order", "meaning": "注文", "example": "ドラえもんは、レストランで料理を注文した。", "translation": "Doraemon ordered a meal at the restaurant."},
     {"word": "interesting", "meaning": "面白い", "example": "ドラえもんの話は、いつも面白い。", "translation": "Doraemon's stories are always interesting."},
     {"word": "Friday", "meaning": "金曜日", "example": "ドラえもんは、金曜日にみんなと遊ぶのが好きだ。", "translation": "Doraemon likes to play with everyone on Fridays."}
     ];
     break;
     case "中学英語84":
     item = [
     {"word": "smell", "meaning": "におい", "example": "ドラえもんは、パンの焼けるにおいが好きだ。", "translation": "Doraemon likes the smell of baking bread."},
     {"word": "personal", "meaning": "個人的な", "example": "ドラえもんは、のび太の個人的な悩みをよく聞く。", "translation": "Doraemon often listens to Nobita's personal problems."},
     {"word": "apple", "meaning": "りんご", "example": "ドラえもんは、りんごを丸かじりするのが好きだ。", "translation": "Doraemon likes to eat apples whole."},
     {"word": "elbow", "meaning": "肘", "example": "のび太は、よく肘をぶつける。", "translation": "Nobita often bumps his elbow."},
     {"word": "bear", "meaning": "クマ", "example": "ドラえもんとのび太は、山でクマを見た。", "translation": "Doraemon and Nobita saw a bear in the mountains."},
     {"word": "borrow", "meaning": "借りる", "example": "ドラえもんは、のび太に秘密道具を借りることがある。", "translation": "Doraemon sometimes borrows secret gadgets from Nobita."},
     {"word": "bed", "meaning": "ベッド", "example": "のび太は、いつもベッドでマンガを読んでいる。", "translation": "Nobita is always reading manga in bed."},
     {"word": "weekend", "meaning": "週末", "example": "ドラえもんは、週末にみんなと遊ぶ。", "translation": "Doraemon plays with everyone on weekends."},
     {"word": "Europe", "meaning": "ヨーロッパ", "example": "ドラえもんは、どこでもドアでヨーロッパを旅行した。", "translation": "Doraemon traveled to Europe with the Anywhere Door."}
     ];
     break;
     case "中学英語85":
     item = [
     {"word": "salesclerk", "meaning": "店員", "example": "ドラえもんは、デパートの店員さんに商品の場所を聞いた。", "translation": "Doraemon asked the salesclerk in the department store where the product was."},
     {"word": "touch", "meaning": "触る", "example": "ドラえもんは、未来の機械に触ってみた。", "translation": "Doraemon tried touching a future machine."},
     {"word": "supermarket", "meaning": "スーパーマーケット", "example": "ドラえもんは、スーパーマーケットでどら焼きを買った。", "translation": "Doraemon bought dorayaki at the supermarket."},
     {"word": "black", "meaning": "黒色の", "example": "ドラえもんは、黒い服を着ている。", "translation": "Doraemon is wearing black clothes."},
     {"word": "game", "meaning": "ゲーム", "example": "ドラえもんは、未来のゲームを楽しむのが好きだ。", "translation": "Doraemon likes playing future games."},
     {"word": "dangerous", "meaning": "危険な", "example": "ドラえもんは、危険な場所にのび太を近づけないようにする。", "translation": "Doraemon prevents Nobita from going near dangerous places."},
     {"word": "move", "meaning": "動く", "example": "ドラえもんは、自由に動き回ることができる。", "translation": "Doraemon can move around freely."},
     {"word": "anything", "meaning": "何でも", "example": "ドラえもんは、何でも知っている。", "translation": "Doraemon knows anything."},
     {"word": "situation", "meaning": "状況", "example": "ドラえもんは、どんな状況でも冷静に対応する。", "translation": "Doraemon responds calmly to any situation."}
     ];
     break;
     case "中学英語86":
     item = [
     {"word": "worried", "meaning": "心配した", "example": "ドラえもんは、のび太のことを心配した。", "translation": "Doraemon was worried about Nobita."},
     {"word": "fashion", "meaning": "ファッション", "example": "ドラえもんは、未来のファッションに興味がある。", "translation": "Doraemon is interested in future fashion."},
     {"word": "burn", "meaning": "燃やす", "example": "ドラえもんは、ゴミを燃やして処分した。", "translation": "Doraemon burned the trash for disposal."},
     {"word": "dollar", "meaning": "ドル", "example": "ドラえもんは、ドルでお買い物をする。", "translation": "Doraemon does his shopping in dollars."},
     {"word": "clothes", "meaning": "服", "example": "ドラえもんは、色々な服を持っている。", "translation": "Doraemon has various clothes."},
     {"word": "live", "meaning": "住む", "example": "ドラえもんは、のび太の家に住んでいる。", "translation": "Doraemon lives in Nobita's house."},
     {"word": "summer", "meaning": "夏", "example": "ドラえもんは、夏が好きだ。", "translation": "Doraemon likes summer."},
     {"word": "bookstore", "meaning": "本屋", "example": "ドラえもんは、本屋で漫画を買った。", "translation": "Doraemon bought manga at the bookstore."},
     {"word": "college", "meaning": "大学", "example": "ドラえもんは、未来の大学について知っている。", "translation": "Doraemon knows about universities in the future."},
     {"word": "land", "meaning": "陸", "example": "ドラえもんは、陸の上を歩くことができる。", "translation": "Doraemon can walk on land."}
     ];
     break;
     case "中学英語87":
     item = [
     {"word": "cut", "meaning": "切る", "example": "ドラえもんは、ハサミで紙を切った。", "translation": "Doraemon cut the paper with scissors."},
     {"word": "unlock", "meaning": "鍵を開ける", "example": "ドラえもんは、どこでもドアの鍵を開けた。", "translation": "Doraemon unlocked the Anywhere Door."},
     {"word": "main", "meaning": "主な", "example": "ドラえもんは、主な目的はのび太を助けることだ。", "translation": "Doraemon's main purpose is to help Nobita."},
     {"word": "half", "meaning": "半分", "example": "ドラえもんは、どら焼きを半分に割って食べた。", "translation": "Doraemon split the dorayaki in half and ate it."},
     {"word": "lot", "meaning": "たくさん", "example": "ドラえもんは、たくさんの秘密道具を持っている。", "translation": "Doraemon has a lot of secret gadgets."},
     {"word": "wear", "meaning": "着る", "example": "ドラえもんは、いつも赤い首輪を着けている。", "translation": "Doraemon always wears a red collar."},
     {"word": "village", "meaning": "村", "example": "ドラえもんは、のび太と昔の村へ行った。", "translation": "Doraemon went to an old village with Nobita."},
     {"word": "anymore", "meaning": "もはや～ない", "example": "のび太は、もはや宿題を忘れることはない。", "translation": "Nobita no longer forgets his homework anymore."},
     {"word": "anytime", "meaning": "いつでも", "example": "ドラえもんは、いつでものび太を助ける。", "translation": "Doraemon helps Nobita anytime."},
     {"word": "native", "meaning": "母国の", "example": "ドラえもんは、母国語で話す。", "translation": "Doraemon speaks in his native language."}
     ];
     break;
     case "中学英語88":
     item = [
     {"word": "shake", "meaning": "振る", "example": "ドラえもんは、手を振ってのび太にあいさつした。", "translation": "Doraemon shook his hand and greeted Nobita."},
     {"word": "addition", "meaning": "足し算", "example": "のび太は、足し算が苦手だ。", "translation": "Nobita is not good at addition."},
     {"word": "mirror", "meaning": "鏡", "example": "ドラえもんは、鏡に映った自分を見ている。", "translation": "Doraemon is looking at himself in the mirror."},
     {"word": "energy", "meaning": "エネルギー", "example": "ドラえもんは、どら焼きを食べるとエネルギーが湧いてくる。", "translation": "Doraemon gets energy when he eats dorayaki."},
     {"word": "bright", "meaning": "明るい", "example": "ドラえもんは、いつも明るい。", "translation": "Doraemon is always bright."},
     {"word": "patient", "meaning": "患者", "example": "ドラえもんは、医者ではないが患者の気持ちを理解しようとする。", "translation": "Doraemon is not a doctor but tries to understand the feelings of patients."},
     {"word": "some", "meaning": "いくつかの", "example": "ドラえもんは、いくつかの秘密道具を試した。", "translation": "Doraemon tried some secret gadgets."},
     {"word": "now", "meaning": "今", "example": "ドラえもんは今、のび太と一緒に遊んでいる。", "translation": "Doraemon is playing with Nobita now."},
     {"word": "six", "meaning": "６", "example": "ドラえもんとのび太は６人で遊んでいる。", "translation": "Doraemon and Nobita are playing together with six people."},
     {"word": "happy", "meaning": "幸せな", "example": "ドラえもんは、のび太が幸せだと自分も幸せだ。", "translation": "Doraemon is happy when Nobita is happy."}
     ];
     break;
     case "中学英語89":
     item = [
     {"word": "blind", "meaning": "盲目の", "example": "ドラえもんは、盲目の子供に優しく接した。", "translation": "Doraemon treated the blind child kindly."},
     {"word": "feel", "meaning": "感じる", "example": "ドラえもんは、のび太の気持ちを感じ取ることができる。", "translation": "Doraemon can feel Nobita's feelings."},
     {"word": "research", "meaning": "研究", "example": "ドラえもんは、未来の科学の研究結果を知っている。", "translation": "Doraemon knows the results of future scientific research."},
     {"word": "letter", "meaning": "手紙", "example": "ドラえもんは、友達から手紙をもらった。", "translation": "Doraemon received a letter from a friend."},
     {"word": "fine", "meaning": "元気な", "example": "ドラえもんは、今日も一日元気だ。", "translation": "Doraemon is fine today as well."},
     {"word": "cloud", "meaning": "雲", "example": "ドラえもんは、空に浮かぶ雲を見ている。", "translation": "Doraemon is watching the clouds floating in the sky."},
     {"word": "jump", "meaning": "跳ぶ", "example": "ドラえもんは、ジャンプして障害物を飛び越えた。", "translation": "Doraemon jumped and cleared the obstacles."},
     {"word": "entrance", "meaning": "入り口", "example": "ドラえもんは、家の入り口で待っている。", "translation": "Doraemon is waiting at the entrance of the house."},
     {"word": "collect", "meaning": "集める", "example": "ドラえもんは、切手を集めるのが趣味だ。", "translation": "Doraemon's hobby is collecting stamps."},
     {"word": "gesture", "meaning": "身振り", "example": "ドラえもんは、身振り手振りで説明する。", "translation": "Doraemon explains with gestures."}
     ];
     break;
    
     
     case "中学英語90":
     item = [
     {"word": "chocolate", "meaning": "チョコレート", "example": "ドラえもんは、チョコレートが好きだ。", "translation": "Doraemon likes chocolate."},
     {"word": "aquarium", "meaning": "水族館", "example": "ドラえもんは、のび太と水族館に行った。", "translation": "Doraemon went to the aquarium with Nobita."},
     {"word": "lunchtime", "meaning": "昼食時間", "example": "のび太はいつも、昼食時間が待ち遠しい。", "translation": "Nobita always looks forward to lunchtime."},
     {"word": "above", "meaning": "～の上に", "example": "ドラえもんは、屋根の上に立っている。", "translation": "Doraemon is standing above the roof."},
     {"word": "character", "meaning": "性格", "example": "ドラえもんは、優しい性格だ。", "translation": "Doraemon has a kind character."},
     {"word": "address", "meaning": "住所", "example": "ドラえもんは、住所を知っている。", "translation": "Doraemon knows his address."},
     {"word": "meeting", "meaning": "会議", "example": "ドラえもんは、未来の会議に出席した。", "translation": "Doraemon attended a future meeting."},
     {"word": "away", "meaning": "離れて", "example": "ドラえもんは、のび太から離れないようにしている。", "translation": "Doraemon tries not to leave Nobita's side."},
     {"word": "begin", "meaning": "始める", "example": "ドラえもんは、新しい冒険を始めようとした。", "translation": "Doraemon tried to begin a new adventure."},
     {"word": "plant", "meaning": "植物", "example": "ドラえもんは、庭に植物を植えた。", "translation": "Doraemon planted a plant in the garden."}
     ];
     break;
     case "中学英語91":
     item = [
     {"word": "let", "meaning": "～させてあげる", "example": "ドラえもんは、のび太に好きなようにさせてあげる。", "translation": "Doraemon lets Nobita do what he likes."},
     {"word": "choose", "meaning": "選ぶ", "example": "ドラえもんは、いつも道具を選ぶのを手伝ってくれる。", "translation": "Doraemon always helps me choose gadgets."},
     {"word": "product", "meaning": "製品", "example": "ドラえもんは、未来の製品をたくさん持っている。", "translation": "Doraemon has many products from the future."},
     {"word": "adult", "meaning": "大人", "example": "ドラえもんは、大人になったのび太と会った。", "translation": "Doraemon met Nobita when he became an adult."},
     {"word": "perform", "meaning": "行う", "example": "ドラえもんは、色々なパフォーマンスを披露した。", "translation": "Doraemon performed various performances."},
     {"word": "express", "meaning": "表現する", "example": "ドラえもんは、言葉で感情を表現するのが苦手だ。", "translation": "Doraemon is not good at expressing his feelings with words."},
     {"word": "injure", "meaning": "傷つける", "example": "ドラえもんは、のび太が怪我をしないように気を配っている。", "translation": "Doraemon makes sure that Nobita doesn't get injured."},
     {"word": "certainly", "meaning": "確かに", "example": "ドラえもんは「確かに、そうだよ」と言った。", "translation": "Doraemon said, 'Certainly, that's right'."},
     {"word": "canyon", "meaning": "峡谷", "example": "ドラえもんは、峡谷を探検した。", "translation": "Doraemon explored a canyon."},
     {"word": "alarm", "meaning": "警報", "example": "ドラえもんは、緊急事態の時に警報を鳴らす。", "translation": "Doraemon sounds an alarm in case of emergency."}
     ];
     break;
     case "中学英語92":
     item = [
     {"word": "octopus", "meaning": "タコ", "example": "ドラえもんは、水族館でタコを見た。", "translation": "Doraemon saw an octopus at the aquarium."},
     {"word": "thing", "meaning": "物", "example": "ドラえもんは、色々な物を持っている。", "translation": "Doraemon has various things."},
     {"word": "hall", "meaning": "ホール", "example": "ドラえもんは、コンサートホールで音楽を聴いた。", "translation": "Doraemon listened to music in a concert hall."},
     {"word": "earthquake", "meaning": "地震", "example": "ドラえもんは、地震に備えるための道具を持っている。", "translation": "Doraemon has tools to prepare for earthquakes."},
     {"word": "short", "meaning": "短い", "example": "のび太の夏休みは、とても短かった。", "translation": "Nobita's summer vacation was very short."},
     {"word": "see", "meaning": "見る", "example": "ドラえもんは、いつもみんなを見守っている。", "translation": "Doraemon is always watching over everyone."},
     {"word": "ticket", "meaning": "チケット", "example": "ドラえもんは、映画のチケットを買った。", "translation": "Doraemon bought a movie ticket."},
     {"word": "sunny", "meaning": "晴れの", "example": "今日は晴れの日だ。", "translation": "Today is a sunny day."},
     {"word": "difficulty", "meaning": "困難", "example": "ドラえもんは、どんな困難にも立ち向かう。", "translation": "Doraemon faces any difficulty."},
     {"word": "stadium", "meaning": "スタジアム", "example": "ドラえもんは、スタジアムで野球の試合を見た。", "translation": "Doraemon watched a baseball game at the stadium."}
     ];
     break;
     case "中学英語93":
     item = [
     {"word": "vegetable", "meaning": "野菜", "example": "ドラえもんは、野菜を育てるのが得意だ。", "translation": "Doraemon is good at growing vegetables."},
     {"word": "recycle", "meaning": "リサイクルする", "example": "ドラえもんは、ゴミをリサイクルすることの大切さを教えてくれた。", "translation": "Doraemon taught me the importance of recycling waste."},
     {"word": "scare", "meaning": "怖がらせる", "example": "ジャイアンは、いつもみんなを怖がらせる。", "translation": "Gian always scares everyone."},
     {"word": "heavy", "meaning": "重い", "example": "ドラえもんは、重い荷物を軽々と持ち上げた。", "translation": "Doraemon easily lifted the heavy baggage."},
     {"word": "headache", "meaning": "頭痛", "example": "のび太は、宿題をしすぎて頭痛がする。", "translation": "Nobita has a headache from doing too much homework."},
     {"word": "tomorrow", "meaning": "明日", "example": "ドラえもんは、明日も遊ぼうと約束した。", "translation": "Doraemon promised to play tomorrow as well."},
     {"word": "hotel", "meaning": "ホテル", "example": "ドラえもんは、未来のホテルに泊まった。", "translation": "Doraemon stayed in a future hotel."},
     {"word": "artist", "meaning": "芸術家", "example": "ドラえもんは、有名な芸術家の作品を見た。", "translation": "Doraemon saw the work of a famous artist."},
     {"word": "you", "meaning": "あなた", "example": "ドラえもんは「あなたならできる」と、のび太を励ました。", "translation": "Doraemon encouraged Nobita, saying, 'You can do it'."},
     {"word": "this", "meaning": "この", "example": "ドラえもんは、この道具を使ってみてと勧めた。", "translation": "Doraemon recommended trying this gadget."}
     ];
     break;
     case "中学英語94":
     item = [
     {"word": "place", "meaning": "場所", "example": "ドラえもんは、どこでも好きな場所に連れて行ってくれる。", "translation": "Doraemon takes me to any place I want to go."},
     {"word": "grandmother", "meaning": "祖母", "example": "のび太は、おばあちゃんが好きだ。", "translation": "Nobita likes his grandmother."},
     {"word": "sandwich", "meaning": "サンドイッチ", "example": "ドラえもんは、ピクニックにサンドイッチを持ってきた。", "translation": "Doraemon brought sandwiches for the picnic."},
     {"word": "zookeeper", "meaning": "飼育員", "example": "ドラえもんは、動物園の飼育員に話を聞いた。", "translation": "Doraemon listened to the zookeeper at the zoo."},
     {"word": "level", "meaning": "レベル", "example": "ドラえもんの知能レベルは高い。", "translation": "Doraemon has a high level of intelligence."},
     {"word": "throw", "meaning": "投げる", "example": "のび太は、ボールを投げるのが苦手だ。", "translation": "Nobita is not good at throwing a ball."},
     {"word": "taste", "meaning": "味", "example": "ドラえもんは、色々な味のどら焼きを試している。", "translation": "Doraemon tries dorayaki of various tastes."},
     {"word": "speech", "meaning": "スピーチ", "example": "ドラえもんは、みんなの前でスピーチをした。", "translation": "Doraemon gave a speech in front of everyone."},
     {"word": "husband", "meaning": "夫", "example": "のび太は、将来しずかちゃんの夫になる。", "translation": "Nobita will become Shizuka's husband in the future."},
     {"word": "middle", "meaning": "真ん中", "example": "ドラえもんは、いつもみんなの真ん中にいる。", "translation": "Doraemon is always in the middle of everyone."}
     ];
     break;
     case "中学英語95":
     item = [
     {"word": "international", "meaning": "国際的な", "example": "ドラえもんは、国際的な交流に興味がある。", "translation": "Doraemon is interested in international exchange."},
     {"word": "tourist", "meaning": "旅行者", "example": "ドラえもんは、観光客に未来の道具を紹介した。", "translation": "Doraemon introduced future gadgets to tourists."},
     {"word": "hard", "meaning": "難しい", "example": "ドラえもんは、難しい問題にも挑戦する。", "translation": "Doraemon takes on difficult problems."},
     {"word": "idea", "meaning": "考え", "example": "ドラえもんは、いつも良い考えを持っている。", "translation": "Doraemon always has good ideas."},
     {"word": "baby", "meaning": "赤ちゃん", "example": "ドラえもんは、赤ちゃんにも優しい。", "translation": "Doraemon is kind to babies."},
     {"word": "nature", "meaning": "自然", "example": "ドラえもんは、自然を大切にしている。", "translation": "Doraemon values nature."},
     {"word": "sugar", "meaning": "砂糖", "example": "ドラえもんは、どら焼きに砂糖をたくさん使う。", "translation": "Doraemon uses a lot of sugar in dorayaki."},
     {"word": "team", "meaning": "チーム", "example": "ドラえもんは、チームで野球をするのが好きだ。", "translation": "Doraemon likes playing baseball as a team."},
     {"word": "eraser", "meaning": "消しゴム", "example": "のび太は、消しゴムをよくなくす。", "translation": "Nobita often loses his eraser."},
     {"word": "start", "meaning": "始める", "example": "ドラえもんは、新しい生活を始める。", "translation": "Doraemon will start a new life."}
     ];
     break;
     case "中学英語96":
     item = [
     {"word": "grass", "meaning": "草", "example": "ドラえもんは、草の上で昼寝をするのが好きだ。", "translation": "Doraemon likes to take naps on the grass."},
     {"word": "disappear", "meaning": "消える", "example": "ドラえもんは、どこでもドアで消えた。", "translation": "Doraemon disappeared with the Anywhere Door."},
     {"word": "exchange", "meaning": "交換", "example": "ドラえもんは、道具を交換することがある。", "translation": "Doraemon sometimes exchanges gadgets."},
     {"word": "terrible", "meaning": "ひどい", "example": "のび太は、ひどい風邪をひいた。", "translation": "Nobita caught a terrible cold."},
     {"word": "cheap", "meaning": "安い", "example": "ドラえもんは、安いお菓子を買った。", "translation": "Doraemon bought cheap snacks."},
     {"word": "show", "meaning": "見せる", "example": "ドラえもんは、のび太に秘密道具を見せた。", "translation": "Doraemon showed Nobita his secret gadgets."},
     {"word": "call", "meaning": "呼ぶ", "example": "ドラえもんは、のび太を呼んだ。", "translation": "Doraemon called Nobita."},
     {"word": "cup", "meaning": "コップ", "example": "ドラえもんは、コップでお茶を飲んだ。", "translation": "Doraemon drank tea with a cup."},
     {"word": "country", "meaning": "国", "example": "ドラえもんは、色々な国を旅行してみたいと思っている。", "translation": "Doraemon wants to travel to various countries."},
     {"word": "yesterday", "meaning": "昨日", "example": "ドラえもんは、昨日どこかへ出かけた。", "translation": "Doraemon went somewhere yesterday."}
     ];
     break;
     case "中学英語97":
     item = [
     {"word": "pig", "meaning": "豚", "example": "ドラえもんとのび太は、牧場で豚を見た。", "translation": "Doraemon and Nobita saw pigs at the farm."},
     {"word": "common", "meaning": "共通の", "example": "ドラえもんとのび太には、共通の趣味がある。", "translation": "Doraemon and Nobita have a common hobby."},
     {"word": "dad", "meaning": "お父さん", "example": "のび太は、お父さんのことが好きだ。", "translation": "Nobita likes his dad."},
     {"word": "welcome", "meaning": "歓迎する", "example": "ドラえもんは、新しい友達を歓迎する。", "translation": "Doraemon welcomes new friends."},
     {"word": "athlete", "meaning": "運動選手", "example": "ドラえもんは、有名な運動選手に会った。", "translation": "Doraemon met a famous athlete."},
     {"word": "spend", "meaning": "過ごす", "example": "ドラえもんは、のび太と楽しい時間を過ごす。", "translation": "Doraemon spends fun time with Nobita."},
     {"word": "follow", "meaning": "ついて行く", "example": "ドラえもんは、のび太の後ろについて行った。", "translation": "Doraemon followed behind Nobita."},
     {"word": "doctor", "meaning": "医者", "example": "ドラえもんは、医者のような知恵を持っている。", "translation": "Doraemon has wisdom like a doctor."},
     {"word": "thought", "meaning": "考え", "example": "ドラえもんは、色々と考えを巡らせた。", "translation": "Doraemon pondered many thoughts."},
     {"word": "beach", "meaning": "ビーチ", "example": "ドラえもんは、ビーチで遊んだ。", "translation": "Doraemon played at the beach."}
     ];
     break;
     case "中学英語98":
     item = [
     {"word": "course", "meaning": "進路", "example": "ドラえもんは、のび太を正しい進路へと導く。", "translation": "Doraemon guides Nobita to the correct course."},
     {"word": "gas", "meaning": "ガス", "example": "ドラえもんは、ガスを使って秘密道具を動かす。", "translation": "Doraemon uses gas to power his secret gadgets."},
     {"word": "are", "meaning": "～である", "example": "ドラえもんとのび太は友達である。", "translation": "Doraemon and Nobita are friends."},
     {"word": "flag", "meaning": "旗", "example": "ドラえもんは、運動会で旗を振った。", "translation": "Doraemon waved a flag at the sports day."},
     {"word": "piece", "meaning": "一片", "example": "ドラえもんは、ケーキを一切れ食べた。", "translation": "Doraemon ate a piece of cake."},
     {"word": "space", "meaning": "宇宙", "example": "ドラえもんは、宇宙に行ってみたい。", "translation": "Doraemon wants to go to space."},
     {"word": "later", "meaning": "後で", "example": "ドラえもんは、「後でまた遊ぼう」と言った。", "translation": "Doraemon said, 'Let's play again later'."},
     {"word": "doll", "meaning": "人形", "example": "しずかちゃんは、人形が好きだ。", "translation": "Shizuka likes dolls."},
     {"word": "whale", "meaning": "クジラ", "example": "ドラえもんとのび太は、海でクジラを見た。", "translation": "Doraemon and Nobita saw a whale in the sea."},
     {"word": "east", "meaning": "東", "example": "ドラえもんは、東の方角へ旅に出た。", "translation": "Doraemon set out on a journey to the east."}
     ];
     break;
     case "中学英語99":
     item = [
     {"word": "head", "meaning": "頭", "example": "ドラえもんは、頭を使って問題を解決する。", "translation": "Doraemon uses his head to solve problems."},
     {"word": "natural", "meaning": "自然な", "example": "ドラえもんは、自然な笑顔をする。", "translation": "Doraemon has a natural smile."},
     {"word": "century", "meaning": "世紀", "example": "ドラえもんは、未来の世紀から来た。", "translation": "Doraemon came from a future century."},
     {"word": "movie", "meaning": "映画", "example": "ドラえもんは、映画を観るのが好きだ。", "translation": "Doraemon likes watching movies."},
     {"word": "popular", "meaning": "人気のある", "example": "ドラえもんは、みんなに人気のあるキャラクターだ。", "translation": "Doraemon is a popular character among everyone."},
     {"word": "army", "meaning": "軍隊", "example": "ドラえもんは、未来の軍隊について知っている。", "translation": "Doraemon knows about the future army."},
     {"word": "tight", "meaning": "きつい", "example": "ドラえもんは、ベルトがきつくて苦しそうだった。", "translation": "Doraemon looked uncomfortable with the tight belt."},
     {"word": "soft", "meaning": "柔らかい", "example": "ドラえもんは、柔らかいクッションが好きだ。", "translation": "Doraemon likes soft cushions."},
     {"word": "round", "meaning": "丸い", "example": "ドラえもんは、丸い形をしている。", "translation": "Doraemon has a round shape."},
     {"word": "tea", "meaning": "お茶", "example": "ドラえもんは、お茶を飲んで一息ついた。", "translation": "Doraemon took a break and drank tea."}
     ];
     break;
     case "中学英語100":
     item = [
     {"word": "if", "meaning": "もし～ならば", "example": "ドラえもんは、「もし困ったら、僕を呼んで」と言った。", "translation": "Doraemon said, 'If you are in trouble, call me'."},
     {"word": "book", "meaning": "本", "example": "ドラえもんは、本を読むのが好きだ。", "translation": "Doraemon likes to read books."},
     {"word": "skate", "meaning": "スケート", "example": "ドラえもんは、スケートをするのが得意だ。", "translation": "Doraemon is good at skating."},
     {"word": "leg", "meaning": "足", "example": "ドラえもんは、足を使って歩くことができる。", "translation": "Doraemon can walk using his legs."},
     {"word": "arm", "meaning": "腕", "example": "ドラえもんは、腕を使って道具を使う。", "translation": "Doraemon uses his arms to use his gadgets."},
     {"word": "sign", "meaning": "サイン", "example": "ドラえもんは、有名な人にサインをもらった。", "translation": "Doraemon got a signature from a famous person."},
     {"word": "special", "meaning": "特別な", "example": "ドラえもんは、特別な秘密道具を使った。", "translation": "Doraemon used a special secret gadget."},
     {"word": "finger", "meaning": "指", "example": "ドラえもんは、指でボタンを押した。", "translation": "Doraemon pressed the button with his finger."},
     {"word": "fun", "meaning": "楽しい", "example": "ドラえもんと遊ぶのは、いつも楽しい。", "translation": "It's always fun to play with Doraemon."},
     {"word": "discount", "meaning": "割引", "example": "ドラえもんは、割引セールでお買い物をした。", "translation": "Doraemon went shopping at a discount sale."}
     ];
     break;
    
     
     case "中学英語101":
     item = [
     {"word": "wedding", "meaning": "結婚式", "example": "ドラえもんは、のび太の結婚式に出席した。", "translation": "Doraemon attended Nobita's wedding."},
     {"word": "sometime", "meaning": "いつか", "example": "ドラえもんは、いつか未来に帰る。", "translation": "Doraemon will return to the future sometime."},
     {"word": "project", "meaning": "計画", "example": "ドラえもんは、のび太を助ける計画を立てた。", "translation": "Doraemon made a project to help Nobita."},
     {"word": "professional", "meaning": "プロの", "example": "ドラえもんは、プロの料理人顔負けの料理を作った。", "translation": "Doraemon cooked dishes like a professional chef."},
     {"word": "noise", "meaning": "騒音", "example": "ドラえもんは、騒音の多い場所が苦手だ。", "translation": "Doraemon dislikes noisy places."},
     {"word": "hero", "meaning": "ヒーロー", "example": "ドラえもんは、のび太にとってヒーローだ。", "translation": "Doraemon is a hero to Nobita."},
     {"word": "award", "meaning": "賞", "example": "ドラえもんは、未来の賞を受賞した。", "translation": "Doraemon received a future award."},
     {"word": "funny", "meaning": "面白い", "example": "ドラえもんは、面白いことをするのが好きだ。", "translation": "Doraemon likes to do funny things."},
     {"word": "serve", "meaning": "出す", "example": "ドラえもんは、みんなにお菓子を出した。", "translation": "Doraemon served everyone snacks."},
     {"word": "very", "meaning": "とても", "example": "ドラえもんは、とても優しい。", "translation": "Doraemon is very kind."}
     ];
     break;
     case "中学英語102":
     item = [
     {"word": "how", "meaning": "どのように", "example": "ドラえもんは、どのように未来に行ったのか教えてくれた。", "translation": "Doraemon taught us how to go to the future."},
     {"word": "garden", "meaning": "庭", "example": "ドラえもんは、庭で植物を育てている。", "translation": "Doraemon grows plants in the garden."},
     {"word": "electricity", "meaning": "電気", "example": "ドラえもんは、電気で動く。", "translation": "Doraemon moves with electricity."},
     {"word": "join", "meaning": "参加する", "example": "ドラえもんは、のび太の遊びに参加する。", "translation": "Doraemon joins Nobita's play."},
     {"word": "difficult", "meaning": "難しい", "example": "ドラえもんは、難しい問題も解決する。", "translation": "Doraemon solves difficult problems."},
     {"word": "fan", "meaning": "扇風機", "example": "ドラえもんは、暑い時に扇風機を使う。", "translation": "Doraemon uses a fan when it's hot."},
     {"word": "breakfast", "meaning": "朝食", "example": "ドラえもんは、いつも朝食をきちんと食べる。", "translation": "Doraemon always eats his breakfast properly."},
     {"word": "sun", "meaning": "太陽", "example": "ドラえもんは、太陽の光を浴びてエネルギーを充電する。", "translation": "Doraemon charges his energy in the sunlight."},
     {"word": "sleepy", "meaning": "眠い", "example": "のび太は、いつも眠い。", "translation": "Nobita is always sleepy."},
     {"word": "simple", "meaning": "簡単な", "example": "ドラえもんは、簡単な料理も作る。", "translation": "Doraemon cooks simple dishes too."}
     ];
     break;
     case "中学英語103":
     item = [
     {"word": "hungry", "meaning": "お腹が空いた", "example": "のび太は、いつもお腹が空いている。", "translation": "Nobita is always hungry."},
     {"word": "different", "meaning": "違う", "example": "ドラえもんは、のび太と違うところがある。", "translation": "Doraemon and Nobita are different."},
     {"word": "twice", "meaning": "２回", "example": "ドラえもんは、同じ場所に２回行ったことがある。", "translation": "Doraemon has been to the same place twice."},
     {"word": "story", "meaning": "物語", "example": "ドラえもんは、面白い物語をたくさん知っている。", "translation": "Doraemon knows many interesting stories."},
     {"word": "dog", "meaning": "犬", "example": "ドラえもんは、犬が好きだ。", "translation": "Doraemon likes dogs."},
     {"word": "think", "meaning": "思う", "example": "ドラえもんは、のび太の将来を思っている。", "translation": "Doraemon is thinking about Nobita's future."},
     {"word": "possible", "meaning": "可能", "example": "ドラえもんなら、どんなことでも可能だ。", "translation": "Anything is possible with Doraemon."},
     {"word": "second", "meaning": "秒", "example": "ドラえもんは、一秒でも早く駆けつける。", "translation": "Doraemon rushes to help in even a second."},
     {"word": "pay", "meaning": "支払う", "example": "ドラえもんは、未来の通貨で支払う。", "translation": "Doraemon pays in future currency."},
     {"word": "empty", "meaning": "空の", "example": "のび太のお腹は、いつも空だ。", "translation": "Nobita's stomach is always empty."}
     ];
     break;
     case "中学英語104":
     item = [
     {"word": "scientist", "meaning": "科学者", "example": "ドラえもんは、未来の科学者を知っている。", "translation": "Doraemon knows future scientists."},
     {"word": "passport", "meaning": "パスポート", "example": "ドラえもんは、どこでもドアでパスポートなしでどこへでも行ける。", "translation": "Doraemon can go anywhere without a passport with the Anywhere Door."},
     {"word": "yourself", "meaning": "あなた自身を", "example": "ドラえもんは、のび太に「あなた自身を信じて」と言った。", "translation": "Doraemon said to Nobita, 'Believe in yourself'."},
     {"word": "shoe", "meaning": "靴", "example": "のび太は、新しい靴を履いてみた。", "translation": "Nobita tried on new shoes."},
     {"word": "enemy", "meaning": "敵", "example": "ドラえもんは、敵と戦う。", "translation": "Doraemon fights with enemies."},
     {"word": "already", "meaning": "すでに", "example": "ドラえもんは、すでに解決策を知っていた。", "translation": "Doraemon already knew the solution."},
     {"word": "send", "meaning": "送る", "example": "ドラえもんは、未来に手紙を送った。", "translation": "Doraemon sent a letter to the future."},
     {"word": "successful", "meaning": "成功した", "example": "ドラえもんは、作戦が成功して喜んだ。", "translation": "Doraemon was happy that the plan was successful."},
     {"word": "powerful", "meaning": "強力な", "example": "ドラえもんは、強力な道具を使える。", "translation": "Doraemon can use powerful gadgets."},
     {"word": "increase", "meaning": "増やす", "example": "ドラえもんは、どら焼きの数を増やした。", "translation": "Doraemon increased the number of dorayaki."}
     ];
     break;
     case "中学英語105":
     item = [
     {"word": "never", "meaning": "決して～ない", "example": "ドラえもんは、決してのび太を見捨てない。", "translation": "Doraemon never abandons Nobita."},
     {"word": "make", "meaning": "作る", "example": "ドラえもんは、美味しい料理を作る。", "translation": "Doraemon makes delicious dishes."},
     {"word": "bored", "meaning": "退屈な", "example": "のび太は、退屈な時はドラえもんと遊ぶ。", "translation": "Nobita plays with Doraemon when he is bored."},
     {"word": "imagine", "meaning": "想像する", "example": "ドラえもんは、未来の世界を想像する。", "translation": "Doraemon imagines the future world."},
     {"word": "control", "meaning": "制御する", "example": "ドラえもんは、秘密道具を制御できる。", "translation": "Doraemon can control his secret gadgets."},
     {"word": "human", "meaning": "人間", "example": "ドラえもんは人間ではない。", "translation": "Doraemon is not a human."},
     {"word": "dark", "meaning": "暗い", "example": "ドラえもんは、暗い場所が少し苦手だ。", "translation": "Doraemon is a little afraid of dark places."},
     {"word": "everywhere", "meaning": "どこでも", "example": "ドラえもんは、どこへでも連れて行ってくれる。", "translation": "Doraemon takes me everywhere."},
     {"word": "shopping", "meaning": "買い物", "example": "ドラえもんは、買い物に行くのが好きだ。", "translation": "Doraemon likes to go shopping."},
     {"word": "real", "meaning": "本当の", "example": "ドラえもんは、本当の友達だ。", "translation": "Doraemon is a real friend."}
     ];
     break;
     case "中学英語106":
     item = [
     {"word": "engineer", "meaning": "エンジニア", "example": "ドラえもんは、未来のエンジニアが作った。", "translation": "Doraemon was created by a future engineer."},
     {"word": "helpful", "meaning": "役に立つ", "example": "ドラえもんは、とても役に立つ存在だ。", "translation": "Doraemon is a very helpful presence."},
     {"word": "several", "meaning": "いくつかの", "example": "ドラえもんは、いくつかの秘密道具を試した。", "translation": "Doraemon tried several secret gadgets."},
     {"word": "paper", "meaning": "紙", "example": "ドラえもんは、紙を使って色々なものを作った。", "translation": "Doraemon made various things using paper."},
     {"word": "ring", "meaning": "指輪", "example": "ドラえもんは、指輪を拾った。", "translation": "Doraemon picked up a ring."},
     {"word": "ski", "meaning": "スキー", "example": "ドラえもんは、雪山でスキーをした。", "translation": "Doraemon went skiing on the snowy mountain."},
     {"word": "post", "meaning": "郵便", "example": "ドラえもんは、手紙を郵便ポストに投函した。", "translation": "Doraemon posted the letter in the mailbox."},
     {"word": "want", "meaning": "～が欲しい", "example": "ドラえもんは、どら焼きが欲しい。", "translation": "Doraemon wants dorayaki."},
     {"word": "does", "meaning": "する", "example": "ドラえもんは、いつも頑張って宿題をする。", "translation": "Doraemon always works hard to do his homework."},
     {"word": "shoes", "meaning": "靴", "example": "ドラえもんは、靴を履いて歩いた。", "translation": "Doraemon walked while wearing shoes."}
     ];
     break;
     case "中学英語107":
     item = [
     {"word": "sink", "meaning": "シンク", "example": "ドラえもんは、シンクで食器を洗った。", "translation": "Doraemon washed the dishes in the sink."},
     {"word": "mouse", "meaning": "ねずみ", "example": "ドラえもんは、ねずみが苦手だ。", "translation": "Doraemon is not good with mice."},
     {"word": "juice", "meaning": "ジュース", "example": "ドラえもんは、ジュースを飲んで休憩した。", "translation": "Doraemon took a break and drank juice."},
     {"word": "own", "meaning": "自分自身の", "example": "ドラえもんは、自分自身の力で困難を乗り越える。", "translation": "Doraemon overcomes difficulties with his own power."},
     {"word": "world", "meaning": "世界", "example": "ドラえもんは、色々な世界を見てみたい。", "translation": "Doraemon wants to see various worlds."},
     {"word": "vacation", "meaning": "休暇", "example": "ドラえもんは、のび太と休暇を楽しんだ。", "translation": "Doraemon enjoyed a vacation with Nobita."},
     {"word": "refrigerator", "meaning": "冷蔵庫", "example": "ドラえもんは、冷蔵庫にどら焼きを保管している。", "translation": "Doraemon keeps dorayaki in the refrigerator."},
     {"word": "longdistance", "meaning": "長距離の", "example": "ドラえもんは、長距離の旅行が好きだ。", "translation": "Doraemon likes long-distance trips."},
     {"word": "number", "meaning": "数字", "example": "ドラえもんは、数字を数えるのが得意だ。", "translation": "Doraemon is good at counting numbers."},
     {"word": "under", "meaning": "～の下に", "example": "ドラえもんは、机の下に隠れた。", "translation": "Doraemon hid under the desk."}
     ];
     break;
     case "中学英語108":
     item = [
     {"word": "site", "meaning": "場所", "example": "ドラえもんは、新しい場所を見つけた。", "translation": "Doraemon found a new site."},
     {"word": "exciting", "meaning": "わくわくする", "example": "ドラえもんとの冒険は、いつもわくわくする。", "translation": "Adventures with Doraemon are always exciting."},
     {"word": "slope", "meaning": "坂", "example": "ドラえもんは、坂道を駆け上がった。", "translation": "Doraemon ran up the slope."},
     {"word": "reason", "meaning": "理由", "example": "ドラえもんは、理由を説明した。", "translation": "Doraemon explained the reason."},
     {"word": "box", "meaning": "箱", "example": "ドラえもんは、箱の中に秘密道具をしまっている。", "translation": "Doraemon keeps secret gadgets in a box."},
     {"word": "violin", "meaning": "バイオリン", "example": "しずかちゃんは、バイオリンを弾くのが好きだ。", "translation": "Shizuka likes to play the violin."},
     {"word": "built", "meaning": "建てられた", "example": "ドラえもんの家は、未来の技術で建てられた。", "translation": "Doraemon's house was built with future technology."},
     {"word": "cookie", "meaning": "クッキー", "example": "ドラえもんは、クッキーを食べるのが好きだ。", "translation": "Doraemon likes eating cookies."},
     {"word": "wrap", "meaning": "包む", "example": "ドラえもんは、お弁当を包んで持ってきた。", "translation": "Doraemon wrapped his lunch and brought it."},
     {"word": "effect", "meaning": "効果", "example": "ドラえもんは、秘密道具の効果を試した。", "translation": "Doraemon tried the effect of his secret gadget."}
     ];
     break;
     case "中学英語109":
     item = [
     {"word": "detective", "meaning": "探偵", "example": "ドラえもんは、探偵になって事件を解決した。", "translation": "Doraemon became a detective and solved the case."},
     {"word": "nurse", "meaning": "看護師", "example": "ドラえもんは、看護師のようにみんなを優しく看病する。", "translation": "Doraemon kindly nurses everyone like a nurse."},
     {"word": "dentist", "meaning": "歯医者", "example": "ドラえもんは、歯医者が苦手だ。", "translation": "Doraemon is not good with dentists."},
     {"word": "anywhere", "meaning": "どこでも", "example": "ドラえもんは、どこへでも行ける。", "translation": "Doraemon can go anywhere."},
     {"word": "yen", "meaning": "円", "example": "ドラえもんは、円でお買い物をする。", "translation": "Doraemon does his shopping in yen."},
     {"word": "as", "meaning": "～として", "example": "ドラえもんは、のび太の友達としていつもそばにいる。", "translation": "Doraemon is always by Nobita's side as a friend."},
     {"word": "overcome", "meaning": "克服する", "example": "ドラえもんは、困難を克服した。", "translation": "Doraemon overcame his difficulties."},
     {"word": "sailor", "meaning": "船乗り", "example": "ドラえもんは、船乗りになって海を旅した。", "translation": "Doraemon became a sailor and traveled the sea."},
     {"word": "tail", "meaning": "尻尾", "example": "ドラえもんには、尻尾がある。", "translation": "Doraemon has a tail."},
     {"word": "lovely", "meaning": "愛らしい", "example": "ドラえもんは、愛らしいロボットだ。", "translation": "Doraemon is a lovely robot."}
     ];
     break;
     case "中学英語110":
     item = [
     {"word": "money", "meaning": "お金", "example": "ドラえもんは、お金を大切に使う。", "translation": "Doraemon uses money carefully."},
     {"word": "plate", "meaning": "お皿", "example": "ドラえもんは、お皿に料理を盛り付けた。", "translation": "Doraemon put food on a plate."},
     {"word": "noisy", "meaning": "騒がしい", "example": "ドラえもんは、騒がしい場所が苦手だ。", "translation": "Doraemon doesn't like noisy places."},
     {"word": "enter", "meaning": "入る", "example": "ドラえもんは、どこでもドアから入った。", "translation": "Doraemon entered through the Anywhere Door."},
     {"word": "influence", "meaning": "影響", "example": "ドラえもんは、のび太に良い影響を与えている。", "translation": "Doraemon has a good influence on Nobita."},
     {"word": "drum", "meaning": "ドラム", "example": "ジャイアンは、ドラムを叩くのが好きだ。", "translation": "Gian likes to play the drums."},
     {"word": "ahead", "meaning": "先に", "example": "ドラえもんは、先に進んだ。", "translation": "Doraemon went ahead."},
     {"word": "joy", "meaning": "喜び", "example": "ドラえもんは、みんなの喜びを自分の喜びとする。", "translation": "Doraemon makes everyone's joy his own."},
     {"word": "koala", "meaning": "コアラ", "example": "ドラえもんは、動物園でコアラを見た。", "translation": "Doraemon saw a koala at the zoo."},
     {"word": "panda", "meaning": "パンダ", "example": "ドラえもんは、パンダが大好きだ。", "translation": "Doraemon loves pandas."}
     ];
     break;
    
     
     case "中学英語111":
     item = [
     {"word": "next", "meaning": "次の", "example": "ドラえもんは、次の秘密道具を出した。", "translation": "Doraemon took out the next secret gadget."},
     {"word": "night", "meaning": "夜", "example": "ドラえもんは、夜空を見るのが好きだ。", "translation": "Doraemon likes to look at the night sky."},
     {"word": "meat", "meaning": "肉", "example": "ドラえもんは、肉料理を美味しく作った。", "translation": "Doraemon made a delicious meat dish."},
     {"word": "introduce", "meaning": "紹介する", "example": "ドラえもんは、友達を紹介してくれた。", "translation": "Doraemon introduced his friends."},
     {"word": "small", "meaning": "小さい", "example": "ドラえもんは、小さい道具もたくさん持っている。", "translation": "Doraemon has many small gadgets too."},
     {"word": "work", "meaning": "働く", "example": "ドラえもんは、いつも一生懸命働く。", "translation": "Doraemon always works very hard."},
     {"word": "large", "meaning": "大きい", "example": "ドラえもんは、大きな秘密道具も持っている。", "translation": "Doraemon has large secret gadgets too."},
     {"word": "during", "meaning": "～の間", "example": "ドラえもんは、授業の間、のび太を見守っていた。", "translation": "Doraemon watched over Nobita during class."},
     {"word": "cherry", "meaning": "さくらんぼ", "example": "ドラえもんは、さくらんぼが好きだ。", "translation": "Doraemon likes cherries."},
     {"word": "fox", "meaning": "キツネ", "example": "ドラえもんは、森でキツネを見た。", "translation": "Doraemon saw a fox in the forest."}
     ];
     break;
     case "中学英語112":
     item = [
     {"word": "mountain", "meaning": "山", "example": "ドラえもんは、のび太と山に登った。", "translation": "Doraemon climbed a mountain with Nobita."},
     {"word": "cool", "meaning": "涼しい", "example": "ドラえもんは、涼しい場所が好きだ。", "translation": "Doraemon likes cool places."},
     {"word": "pencil", "meaning": "鉛筆", "example": "のび太は、鉛筆で宿題をしていた。", "translation": "Nobita was doing his homework with a pencil."},
     {"word": "saw", "meaning": "見た", "example": "ドラえもんは、昨日不思議な夢を見た。", "translation": "Doraemon saw a strange dream yesterday."},
     {"word": "snow", "meaning": "雪", "example": "ドラえもんは、雪で遊ぶのが好きだ。", "translation": "Doraemon likes to play in the snow."},
     {"word": "more", "meaning": "もっと", "example": "ドラえもんは、もっとどら焼きが食べたい。", "translation": "Doraemon wants to eat more dorayaki."},
     {"word": "pray", "meaning": "祈る", "example": "ドラえもんは、みんなの幸せを祈っている。", "translation": "Doraemon prays for everyone's happiness."},
     {"word": "wet", "meaning": "濡れた", "example": "のび太は、雨に濡れてしまった。", "translation": "Nobita got wet in the rain."},
     {"word": "system", "meaning": "システム", "example": "ドラえもんは、未来のシステムを説明した。", "translation": "Doraemon explained a system from the future."},
     {"word": "below", "meaning": "～の下に", "example": "ドラえもんは、机の下を掃除した。", "translation": "Doraemon cleaned below the desk."}
     ];
     break;
     case "中学英語113":
     item = [
     {"word": "northern", "meaning": "北の", "example": "ドラえもんは、北の国へ旅に行った。", "translation": "Doraemon traveled to a northern country."},
     {"word": "stormy", "meaning": "嵐の", "example": "嵐の夜に、ドラえもんはのび太を慰めた。", "translation": "Doraemon comforted Nobita on a stormy night."},
     {"word": "temple", "meaning": "寺", "example": "ドラえもんは、お寺でお参りした。", "translation": "Doraemon visited a temple."},
     {"word": "kilometer", "meaning": "キロメートル", "example": "ドラえもんは、１０キロメートル離れた場所まで歩いた。", "translation": "Doraemon walked to a place 10 kilometers away."},
     {"word": "here", "meaning": "ここに", "example": "ドラえもんは、「ここに来て！」と言った。", "translation": "Doraemon said, 'Come here!'"},
     {"word": "much", "meaning": "たくさんの", "example": "ドラえもんは、たくさんの秘密道具を持っている。", "translation": "Doraemon has much secret gadgets."},
     {"word": "belong", "meaning": "所属する", "example": "ドラえもんは、未来の世界に所属している。", "translation": "Doraemon belongs to the future world."},
     {"word": "shape", "meaning": "形", "example": "ドラえもんは、丸い形をしている。", "translation": "Doraemon has a round shape."},
     {"word": "too", "meaning": "～もまた", "example": "ドラえもんも、のび太と一緒に遊ぶのが好きだ。", "translation": "Doraemon likes to play with Nobita too."},
     {"word": "yes", "meaning": "はい", "example": "ドラえもんは「はい」と答えた。", "translation": "Doraemon answered, 'Yes'."}
     ];
     break;
     case "中学英語114":
     item = [
     {"word": "board", "meaning": "板", "example": "ドラえもんは、板を使って何かを作った。", "translation": "Doraemon made something using a board."},
     {"word": "global", "meaning": "地球規模の", "example": "ドラえもんは、地球規模の問題について考えている。", "translation": "Doraemon is thinking about global issues."},
     {"word": "try", "meaning": "試す", "example": "ドラえもんは、新しい秘密道具を試してみた。", "translation": "Doraemon tried a new secret gadget."},
     {"word": "communicate", "meaning": "コミュニケーションをとる", "example": "ドラえもんは、色々な人とコミュニケーションをとることができる。", "translation": "Doraemon can communicate with various people."},
     {"word": "give", "meaning": "与える", "example": "ドラえもんは、のび太に勇気を与えた。", "translation": "Doraemon gave Nobita courage."},
     {"word": "airplane", "meaning": "飛行機", "example": "ドラえもんは、飛行機に乗って旅行に出かけた。", "translation": "Doraemon went on a trip by airplane."},
     {"word": "since", "meaning": "～以来", "example": "ドラえもんは、生まれて以来ずっと優しい。", "translation": "Doraemon has been kind since he was born."},
     {"word": "surprising", "meaning": "驚くべき", "example": "ドラえもんの秘密道具はいつも驚くべきものばかりだ。", "translation": "Doraemon's secret gadgets are always surprising."},
     {"word": "fever", "meaning": "熱", "example": "のび太は熱を出して寝込んでしまった。", "translation": "Nobita had a fever and was sick in bed."},
     {"word": "travel", "meaning": "旅行する", "example": "ドラえもんは、色々な場所へ旅行をする。", "translation": "Doraemon travels to many places."}
     ];
     break;
     case "中学英語115":
     item = [
     {"word": "pizza", "meaning": "ピザ", "example": "ドラえもんは、ピザを美味しく食べた。", "translation": "Doraemon ate pizza deliciously."},
     {"word": "among", "meaning": "～の中に", "example": "ドラえもんは、みんなの中にいつもいる。", "translation": "Doraemon is always among everyone."},
     {"word": "marker", "meaning": "マーカー", "example": "のび太は、マーカーで線を引いた。", "translation": "Nobita drew a line with a marker."},
     {"word": "charity", "meaning": "慈善", "example": "ドラえもんは、慈善活動に参加した。", "translation": "Doraemon participated in charity work."},
     {"word": "poor", "meaning": "貧しい", "example": "ドラえもんは、貧しい人々を助けた。", "translation": "Doraemon helped poor people."},
     {"word": "careful", "meaning": "注意深い", "example": "ドラえもんは、いつも注意深く行動する。", "translation": "Doraemon always acts carefully."},
     {"word": "painting", "meaning": "絵", "example": "ドラえもんは、絵を描くのが好きだ。", "translation": "Doraemon likes to draw paintings."},
     {"word": "pocket", "meaning": "ポケット", "example": "ドラえもんは、ポケットから道具を取り出す。", "translation": "Doraemon takes out gadgets from his pocket."},
     {"word": "limit", "meaning": "制限", "example": "ドラえもんは、道具を使う時間制限がある。", "translation": "Doraemon has a time limit for using his gadgets."},
     {"word": "ball", "meaning": "ボール", "example": "ドラえもんは、ボールで遊ぶのが好きだ。", "translation": "Doraemon likes to play with a ball."}
     ];
     break;
     case "中学英語116":
     item = [
     {"word": "lie", "meaning": "嘘をつく", "example": "のび太は、嘘をついてしまった。", "translation": "Nobita told a lie."},
     {"word": "difference", "meaning": "違い", "example": "ドラえもんは、違いを説明した。", "translation": "Doraemon explained the difference."},
     {"word": "which", "meaning": "どちら", "example": "ドラえもんは、「どちらの道具を使う？」と聞いた。", "translation": "Doraemon asked, 'Which gadget will you use?'"},
     {"word": "tube", "meaning": "チューブ", "example": "ドラえもんは、チューブを使って空を飛んだ。", "translation": "Doraemon used a tube to fly in the sky."},
     {"word": "spring", "meaning": "春", "example": "ドラえもんは、春が好きだ。", "translation": "Doraemon likes spring."},
     {"word": "advice", "meaning": "忠告", "example": "ドラえもんは、いつも良い忠告をくれる。", "translation": "Doraemon always gives good advice."},
     {"word": "fix", "meaning": "修理する", "example": "ドラえもんは、壊れた道具を修理した。", "translation": "Doraemon fixed the broken gadget."},
     {"word": "soldier", "meaning": "兵士", "example": "ドラえもんは、兵士の歴史について調べている。", "translation": "Doraemon is studying the history of soldiers."},
     {"word": "plastic", "meaning": "プラスチック", "example": "ドラえもんは、プラスチックのリサイクルを推進している。", "translation": "Doraemon promotes the recycling of plastic."},
     {"word": "push", "meaning": "押す", "example": "ドラえもんは、ボタンを押した。", "translation": "Doraemon pushed the button."}
     ];
     break;
     case "中学英語117":
     item = [
     {"word": "bicycle", "meaning": "自転車", "example": "のび太は、自転車に乗るのが苦手だ。", "translation": "Nobita is not good at riding a bicycle."},
     {"word": "period", "meaning": "期間", "example": "ドラえもんは、短い期間で成長した。", "translation": "Doraemon grew in a short period."},
     {"word": "Chinese", "meaning": "中国の", "example": "ドラえもんは、中国の文化に興味がある。", "translation": "Doraemon is interested in Chinese culture."},
     {"word": "street", "meaning": "通り", "example": "ドラえもんは、街の通りを歩いた。", "translation": "Doraemon walked along the street."},
     {"word": "health", "meaning": "健康", "example": "ドラえもんは、みんなの健康を気遣っている。", "translation": "Doraemon cares about everyone's health."},
     {"word": "university", "meaning": "大学", "example": "ドラえもんは、未来の大学を訪問した。", "translation": "Doraemon visited a future university."},
     {"word": "step", "meaning": "ステップ", "example": "ドラえもんは、一歩ずつ階段を上がった。", "translation": "Doraemon went up the steps one by one."},
     {"word": "information", "meaning": "情報", "example": "ドラえもんは、たくさんの情報を持っている。", "translation": "Doraemon has a lot of information."},
     {"word": "ours", "meaning": "私たちのもの", "example": "この秘密基地は、私たちのものだ。", "translation": "This secret base is ours."},
     {"word": "soccer", "meaning": "サッカー", "example": "ドラえもんは、サッカーをするのが好きだ。", "translation": "Doraemon likes to play soccer."}
     ];
     break;
     case "中学英語118":
     item = [
     {"word": "instead", "meaning": "代わりに", "example": "ドラえもんは、代わりに掃除をした。", "translation": "Doraemon cleaned instead."},
     {"word": "come", "meaning": "来る", "example": "ドラえもんは、いつも私のところに来てくれる。", "translation": "Doraemon always comes to me."},
     {"word": "yours", "meaning": "あなたのもの", "example": "この道具は、あなたのものだよ。", "translation": "This gadget is yours."},
     {"word": "won", "meaning": "勝った", "example": "ドラえもんは、ゲームに勝った。", "translation": "Doraemon won the game."},
     {"word": "match", "meaning": "試合", "example": "ドラえもんは、サッカーの試合を見た。", "translation": "Doraemon watched a soccer match."},
     {"word": "cafeteria", "meaning": "カフェテリア", "example": "ドラえもんは、学校のカフェテリアで食事をした。", "translation": "Doraemon had a meal in the school cafeteria."},
     {"word": "guide", "meaning": "案内する", "example": "ドラえもんは、街を案内してくれた。", "translation": "Doraemon guided me through the city."},
     {"word": "far", "meaning": "遠い", "example": "ドラえもんは、遠い場所へ旅行に行った。", "translation": "Doraemon went on a trip to a far place."},
     {"word": "practice", "meaning": "練習", "example": "のび太は、毎日練習を頑張った。", "translation": "Nobita worked hard to practice every day."},
     {"word": "bomb", "meaning": "爆弾", "example": "ドラえもんは、爆弾の夢を見て怖がった。", "translation": "Doraemon was scared after dreaming of a bomb."}
     ];
     break;
     case "中学英語119":
     item = [
     {"word": "war", "meaning": "戦争", "example": "ドラえもんは、戦争のない世界を願っている。", "translation": "Doraemon wishes for a world without war."},
     {"word": "mom", "meaning": "お母さん", "example": "のび太は、お母さんのことが好きだ。", "translation": "Nobita likes his mom."},
     {"word": "cap", "meaning": "帽子", "example": "ドラえもんは、帽子をかぶっている。", "translation": "Doraemon is wearing a cap."},
     {"word": "invent", "meaning": "発明する", "example": "ドラえもんは、新しい道具を発明するのが好きだ。", "translation": "Doraemon likes to invent new gadgets."},
     {"word": "basket", "meaning": "かご", "example": "ドラえもんは、かごにどら焼きを入れた。", "translation": "Doraemon put dorayaki in a basket."},
     {"word": "hurry", "meaning": "急ぐ", "example": "ドラえもんは、急いで学校へ向かった。", "translation": "Doraemon hurried to school."},
     {"word": "belt", "meaning": "ベルト", "example": "のび太は、ベルトを締めた。", "translation": "Nobita tightened his belt."},
     {"word": "guy", "meaning": "男", "example": "ドラえもんは、面白い男の子と出会った。", "translation": "Doraemon met an interesting guy."},
     {"word": "western", "meaning": "西洋の", "example": "ドラえもんは、西洋の音楽が好きだ。", "translation": "Doraemon likes Western music."},
     {"word": "robot", "meaning": "ロボット", "example": "ドラえもんは、未来のロボットだ。", "translation": "Doraemon is a robot from the future."}
     ];
     break;
     case "中学英語120":
     item = [
     {"word": "interested", "meaning": "興味がある", "example": "ドラえもんは、科学に興味がある。", "translation": "Doraemon is interested in science."},
     {"word": "wild", "meaning": "野生の", "example": "ドラえもんは、野生動物が好きだ。", "translation": "Doraemon likes wild animals."},
     {"word": "castle", "meaning": "城", "example": "ドラえもんは、お城を見に行った。", "translation": "Doraemon went to see a castle."},
     {"word": "interest", "meaning": "興味", "example": "ドラえもんは、色々なことに興味を持っている。", "translation": "Doraemon is interested in many things."},
     {"word": "picture", "meaning": "絵", "example": "ドラえもんは、絵を描くのが好きだ。", "translation": "Doraemon likes to draw pictures."},
     {"word": "cousin", "meaning": "いとこ", "example": "のび太は、いとこと遊んだ。", "translation": "Nobita played with his cousin."},
     {"word": "pet", "meaning": "ペット", "example": "ドラえもんは、ペットを飼っている。", "translation": "Doraemon has a pet."},
     {"word": "tear", "meaning": "涙", "example": "のび太は、悲しくて涙を流した。", "translation": "Nobita shed tears because he was sad."},
     {"word": "volunteer", "meaning": "ボランティア", "example": "ドラえもんは、ボランティア活動をしている。", "translation": "Doraemon is doing volunteer work."},
     {"word": "writer", "meaning": "作家", "example": "ドラえもんは、小説家の友達がいる。", "translation": "Doraemon has a writer friend."}
     ];
     break;
    
     
     case "中学英語121":
     item = [
     {"word": "circle", "meaning": "円", "example": "ドラえもんは、円を描いてみた。", "translation": "Doraemon tried drawing a circle."},
     {"word": "sit", "meaning": "座る", "example": "ドラえもんは、いつも畳の上に座っている。", "translation": "Doraemon always sits on the tatami mat."},
     {"word": "name", "meaning": "名前", "example": "ドラえもんの名前は、みんな知っている。", "translation": "Everyone knows Doraemon's name."},
     {"word": "snowy", "meaning": "雪の降る", "example": "雪の降る日に、ドラえもんは雪だるまを作った。", "translation": "Doraemon made a snowman on a snowy day."},
     {"word": "hunter", "meaning": "狩人", "example": "ドラえもんは、狩人のように動物を探した。", "translation": "Doraemon searched for animals like a hunter."},
     {"word": "refuse", "meaning": "拒否する", "example": "ドラえもんは、悪い誘いを拒否した。", "translation": "Doraemon refused the bad temptation."},
     {"word": "connect", "meaning": "繋ぐ", "example": "ドラえもんは、未来と現在を繋げている。", "translation": "Doraemon connects the future and the present."},
     {"word": "treat", "meaning": "ご馳走", "example": "ドラえもんは、みんなにご馳走を振る舞った。", "translation": "Doraemon treated everyone to a feast."},
     {"word": "single", "meaning": "一つの", "example": "ドラえもんは、一つの秘密道具を使った。", "translation": "Doraemon used a single secret gadget."},
     {"word": "parade", "meaning": "パレード", "example": "ドラえもんは、パレードを見て楽しんだ。", "translation": "Doraemon enjoyed watching the parade."}
     ];
     break;
     case "中学英語122":
     item = [
     {"word": "tower", "meaning": "塔", "example": "ドラえもんは、高い塔に登った。", "translation": "Doraemon climbed a tall tower."},
     {"word": "moment", "meaning": "瞬間", "example": "ドラえもんは、魔法のような瞬間を見た。", "translation": "Doraemon saw a magical moment."},
     {"word": "theater", "meaning": "劇場", "example": "ドラえもんは、劇場で映画を見た。", "translation": "Doraemon watched a movie at the theater."},
     {"word": "meaning", "meaning": "意味", "example": "ドラえもんは、言葉の意味を教えてくれた。", "translation": "Doraemon taught me the meaning of the words."},
     {"word": "serious", "meaning": "深刻な", "example": "ドラえもんは、深刻な顔で問題について考えた。", "translation": "Doraemon thought about the problem with a serious face."},
     {"word": "fin", "meaning": "ひれ", "example": "ドラえもんは、魚のひれを触ってみた。", "translation": "Doraemon tried touching the fin of the fish."},
     {"word": "sleigh", "meaning": "そり", "example": "ドラえもんは、雪の上をそりで滑った。", "translation": "Doraemon slid on the snow with a sleigh."},
     {"word": "stamp", "meaning": "切手", "example": "ドラえもんは、切手を集めるのが趣味だ。", "translation": "Doraemon's hobby is collecting stamps."},
     {"word": "kill", "meaning": "殺す", "example": "ドラえもんは、生き物を殺すことは絶対にしない。", "translation": "Doraemon never kills living things."},
     {"word": "third", "meaning": "３番目の", "example": "ドラえもんは、３番目の秘密道具を取り出した。", "translation": "Doraemon took out his third secret gadget."}
     ];
     break;
     case "中学英語123":
     item = [
     {"word": "just", "meaning": "ちょうど", "example": "ドラえもんは、ちょうどその時現れた。", "translation": "Doraemon appeared just at that moment."},
     {"word": "hat", "meaning": "帽子", "example": "ドラえもんは、新しい帽子を買った。", "translation": "Doraemon bought a new hat."},
     {"word": "blow", "meaning": "吹く", "example": "ドラえもんは、風を吹かせて物を動かした。", "translation": "Doraemon blew wind and moved things."},
     {"word": "publish", "meaning": "出版する", "example": "ドラえもんは、自分の漫画を出版した。", "translation": "Doraemon published his own manga."},
     {"word": "rescue", "meaning": "救助する", "example": "ドラえもんは、のび太を救助した。", "translation": "Doraemon rescued Nobita."},
     {"word": "win", "meaning": "勝つ", "example": "ドラえもんは、いつもゲームに勝つ。", "translation": "Doraemon always wins at games."},
     {"word": "minute", "meaning": "分", "example": "ドラえもんは、一分でも早く駆けつける。", "translation": "Doraemon rushes to help in even a minute."},
     {"word": "surf", "meaning": "サーフィン", "example": "ドラえもんは、海でサーフィンをした。", "translation": "Doraemon went surfing in the sea."},
     {"word": "front", "meaning": "正面", "example": "ドラえもんは、みんなの正面に立った。", "translation": "Doraemon stood in front of everyone."},
     {"word": "weekday", "meaning": "平日", "example": "ドラえもんは、平日は学校へ行く。", "translation": "Doraemon goes to school on weekdays."}
     ];
     break;
     case "中学英語124":
     item = [
     {"word": "neck", "meaning": "首", "example": "ドラえもんは、首に鈴をつけている。", "translation": "Doraemon wears a bell around his neck."},
     {"word": "open", "meaning": "開ける", "example": "ドラえもんは、ドアを開けて中に入った。", "translation": "Doraemon opened the door and went inside."},
     {"word": "often", "meaning": "しばしば", "example": "ドラえもんは、しばしばのび太を助ける。", "translation": "Doraemon often helps Nobita."},
     {"word": "glove", "meaning": "手袋", "example": "ドラえもんは、寒い日に手袋をした。", "translation": "Doraemon wore gloves on a cold day."},
     {"word": "sheet", "meaning": "シーツ", "example": "のび太は、シーツを被って寝ている。", "translation": "Nobita sleeps with the sheet over him."},
     {"word": "yellow", "meaning": "黄色", "example": "ドラえもんは、黄色の服を着ている。", "translation": "Doraemon is wearing a yellow shirt."},
     {"word": "spider", "meaning": "クモ", "example": "ドラえもんは、クモが少し苦手だ。", "translation": "Doraemon is a little afraid of spiders."},
     {"word": "camping", "meaning": "キャンプ", "example": "ドラえもんは、山でキャンプをした。", "translation": "Doraemon went camping in the mountains."},
     {"word": "Tuesday", "meaning": "火曜日", "example": "ドラえもんは、火曜日に特別なイベントがある。", "translation": "Doraemon has a special event on Tuesdays."},
     {"word": "capital", "meaning": "首都", "example": "ドラえもんは、日本の首都に行ったことがある。", "translation": "Doraemon has been to the capital of Japan."}
     ];
     break;
     case "中学英語125":
     item = [
     {"word": "encourage", "meaning": "励ます", "example": "ドラえもんは、いつもみんなを励ます。", "translation": "Doraemon always encourages everyone."},
     {"word": "knock", "meaning": "ノックする", "example": "ドラえもんは、ドアをノックした。", "translation": "Doraemon knocked on the door."},
     {"word": "schedule", "meaning": "予定", "example": "ドラえもんは、忙しいスケジュールをこなす。", "translation": "Doraemon handles a busy schedule."},
     {"word": "boat", "meaning": "ボート", "example": "ドラえもんは、ボートで海へ出かけた。", "translation": "Doraemon went out to sea on a boat."},
     {"word": "old", "meaning": "古い", "example": "ドラえもんは、古い道具も大切にする。", "translation": "Doraemon cherishes old gadgets too."},
     {"word": "anyway", "meaning": "とにかく", "example": "ドラえもんは、「とにかくやってみよう」と言った。", "translation": "Doraemon said, 'Let's try it anyway'."},
     {"word": "against", "meaning": "～に対して", "example": "ドラえもんは、悪いことに反対する。", "translation": "Doraemon is against bad things."},
     {"word": "waterfall", "meaning": "滝", "example": "ドラえもんは、滝を見に行った。", "translation": "Doraemon went to see a waterfall."},
     {"word": "slowly", "meaning": "ゆっくりと", "example": "ドラえもんは、ゆっくりと歩いた。", "translation": "Doraemon walked slowly."}
     ];
     break;
     case "中学英語126":
     item = [
     {"word": "ask", "meaning": "尋ねる", "example": "ドラえもんは、道を尋ねた。", "translation": "Doraemon asked for directions."},
     {"word": "across", "meaning": "横切って", "example": "ドラえもんは、川を横切って歩いた。", "translation": "Doraemon walked across the river."},
     {"word": "visitor", "meaning": "訪問者", "example": "ドラえもんは、訪問者を歓迎した。", "translation": "Doraemon welcomed the visitor."},
     {"word": "something", "meaning": "何か", "example": "ドラえもんは、何かを探していた。", "translation": "Doraemon was looking for something."},
     {"word": "sick", "meaning": "病気の", "example": "のび太は、病気で寝込んでしまった。", "translation": "Nobita was sick and was in bed."},
     {"word": "return", "meaning": "帰る", "example": "ドラえもんは、家に帰ってきた。", "translation": "Doraemon returned home."},
     {"word": "visit", "meaning": "訪ねる", "example": "ドラえもんは、未来を訪ねた。", "translation": "Doraemon visited the future."},
     {"word": "baseball", "meaning": "野球", "example": "ドラえもんは、野球を見るのが好きだ。", "translation": "Doraemon likes to watch baseball."},
     {"word": "chorus", "meaning": "合唱", "example": "ドラえもんは、合唱に参加した。", "translation": "Doraemon participated in the chorus."},
     {"word": "biscuit", "meaning": "ビスケット", "example": "ドラえもんは、ビスケットを食べるのが好きだ。", "translation": "Doraemon likes to eat biscuits."}
     ];
     break;
     case "中学英語127":
     item = [
     {"word": "role", "meaning": "役割", "example": "ドラえもんは、良い友達の役割を果たす。", "translation": "Doraemon plays the role of a good friend."},
     {"word": "less", "meaning": "より少ない", "example": "ドラえもんは、昔より少しだけ怒る回数が減った。", "translation": "Doraemon gets angry a little less than before."},
     {"word": "voice", "meaning": "声", "example": "ドラえもんは、優しい声をしている。", "translation": "Doraemon has a gentle voice."},
     {"word": "fight", "meaning": "戦う", "example": "ドラえもんは、悪い奴らと戦う。", "translation": "Doraemon fights against bad guys."},
     {"word": "cancer", "meaning": "癌", "example": "ドラえもんは、癌の研究を支援する。", "translation": "Doraemon supports cancer research."},
     {"word": "card", "meaning": "カード", "example": "ドラえもんは、カードを使ってゲームをした。", "translation": "Doraemon played a game using cards."},
     {"word": "tent", "meaning": "テント", "example": "ドラえもんは、テントの中で休んだ。", "translation": "Doraemon rested inside the tent."},
     {"word": "loser", "meaning": "敗者", "example": "ドラえもんは、負けた人の気持ちを理解する。", "translation": "Doraemon understands the feelings of the loser."},
     {"word": "rose", "meaning": "バラ", "example": "ドラえもんは、バラの花を贈った。", "translation": "Doraemon gifted a rose flower."},
     {"word": "gift", "meaning": "贈り物", "example": "ドラえもんは、プレゼントを贈るのが好きだ。", "translation": "Doraemon likes to give gifts."},
     {"word": "season", "meaning": "季節", "example": "ドラえもんは、四季が好きだ。", "translation": "Doraemon likes all four seasons."}
     ];
     break;
     case "中学英語128":
     item = [
     {"word": "over", "meaning": "～の上に", "example": "ドラえもんは、空を飛んで雲の上に行った。", "translation": "Doraemon flew in the sky and went over the clouds."},
     {"word": "exam", "meaning": "試験", "example": "のび太は、いつも試験の点が悪い。", "translation": "Nobita always gets bad scores on exams."},
     {"word": "cake", "meaning": "ケーキ", "example": "ドラえもんは、ケーキを食べるのが好きだ。", "translation": "Doraemon likes to eat cake."},
     {"word": "hold", "meaning": "持つ", "example": "ドラえもんは、道具を持って現れた。", "translation": "Doraemon appeared with a gadget in his hand."},
     {"word": "eye", "meaning": "目", "example": "ドラえもんは、目を大きく見開いた。", "translation": "Doraemon opened his eyes wide."},
     {"word": "mall", "meaning": "モール", "example": "ドラえもんは、ショッピングモールに買い物に行った。", "translation": "Doraemon went shopping at the shopping mall."},
     {"word": "set", "meaning": "セット", "example": "ドラえもんは、道具をセットした。", "translation": "Doraemon set up his gadgets."},
     {"word": "pain", "meaning": "痛み", "example": "のび太は、転んで痛みを感じた。", "translation": "Nobita fell and felt pain."},
     {"word": "tiger", "meaning": "トラ", "example": "ドラえもんは、動物園でトラを見た。", "translation": "Doraemon saw a tiger at the zoo."},
     {"word": "people", "meaning": "人々", "example": "ドラえもんは、全ての人々を助けたいと思っている。", "translation": "Doraemon wants to help all people."}
     ];
     break;
     case "中学英語129":
     item = [
     {"word": "turn", "meaning": "回す", "example": "ドラえもんは、鍵を回してドアを開けた。", "translation": "Doraemon turned the key and opened the door."},
     {"word": "perhaps", "meaning": "多分", "example": "ドラえもんは、「多分そうだと思う」と言った。", "translation": "Doraemon said, 'I think perhaps that's the case'."},
     {"word": "family", "meaning": "家族", "example": "ドラえもんは、のび太を家族のように思っている。", "translation": "Doraemon thinks of Nobita as family."},
     {"word": "bus", "meaning": "バス", "example": "ドラえもんは、バスに乗って遠くまで行った。", "translation": "Doraemon rode the bus and went far away."},
     {"word": "restaurant", "meaning": "レストラン", "example": "ドラえもんは、レストランで食事をした。", "translation": "Doraemon had a meal at the restaurant."},
     {"word": "kilogram", "meaning": "キログラム", "example": "ドラえもんは、１キログラムのどら焼きを全部食べた。", "translation": "Doraemon ate all of the 1 kilogram of dorayaki."},
     {"word": "style", "meaning": "スタイル", "example": "ドラえもんは、自分のスタイルを持っている。", "translation": "Doraemon has his own style."},
     {"word": "local", "meaning": "地元の", "example": "ドラえもんは、地元のお祭りに参加した。", "translation": "Doraemon participated in the local festival."},
     {"word": "ever", "meaning": "かつて", "example": "ドラえもんは、かつてタイムスリップしたことがある。", "translation": "Doraemon has time-slipped before."},
     {"word": "tonight", "meaning": "今夜", "example": "ドラえもんは、今夜花火を見る予定だ。", "translation": "Doraemon is planning to watch fireworks tonight."}
     ];
     break;
     case "中学英語130":
     item = [
     {"word": "himself", "meaning": "彼自身", "example": "ドラえもんは、彼自身で問題を解決できる。", "translation": "Doraemon can solve problems by himself."},
     {"word": "after", "meaning": "～の後に", "example": "ドラえもんは、ご飯を食べた後に、運動をする。", "translation": "Doraemon exercises after eating his meal."},
     {"word": "bad", "meaning": "悪い", "example": "ジャイアンは、悪いことをする。", "translation": "Gian does bad things."},
     {"word": "log", "meaning": "丸太", "example": "ドラえもんは、丸太を運んで家を建てた。", "translation": "Doraemon carried logs and built a house."},
     {"word": "realize", "meaning": "気づく", "example": "のび太は、やっと自分の間違いに気づいた。", "translation": "Nobita finally realized his mistake."},
     {"word": "discussion", "meaning": "議論", "example": "ドラえもんは、みんなで議論をした。", "translation": "Doraemon had a discussion with everyone."},
     {"word": "grandpa", "meaning": "おじいちゃん", "example": "のび太は、おじいちゃんのことが大好きだ。", "translation": "Nobita loves his grandpa."},
     {"word": "these", "meaning": "これらの", "example": "ドラえもんは、これらの道具をのび太に与えた。", "translation": "Doraemon gave these gadgets to Nobita."},
     {"word": "guitar", "meaning": "ギター", "example": "ドラえもんは、ギターを弾く。", "translation": "Doraemon plays the guitar."},
     {"word": "officer", "meaning": "警官", "example": "ドラえもんは、警察官に助けてもらった。", "translation": "Doraemon got help from a police officer."}
     ];
     break;
    
     
     case "中学英語131":
     item = [
     {"word": "group", "meaning": "グループ", "example": "ドラえもんは、友達グループと遊んでいる。", "translation": "Doraemon is playing with his group of friends."},
     {"word": "center", "meaning": "中心", "example": "ドラえもんは、いつもみんなの中心にいる。", "translation": "Doraemon is always at the center of everyone."},
     {"word": "goodbye", "meaning": "さようなら", "example": "ドラえもんは、「さようなら」と言って未来に帰った。", "translation": "Doraemon said, 'Goodbye,' and went back to the future."},
     {"word": "into", "meaning": "～の中に", "example": "ドラえもんは、どこでもドアの中に入った。", "translation": "Doraemon went into the Anywhere Door."},
     {"word": "farm", "meaning": "農場", "example": "ドラえもんは、農場で野菜を収穫した。", "translation": "Doraemon harvested vegetables at the farm."},
     {"word": "generation", "meaning": "世代", "example": "ドラえもんは、未来の世代について知っている。", "translation": "Doraemon knows about future generations."},
     {"word": "tooth", "meaning": "歯", "example": "のび太は、歯を磨くのが嫌いだ。", "translation": "Nobita hates to brush his teeth."},
     {"word": "house", "meaning": "家", "example": "ドラえもんは、のび太の家に住んでいる。", "translation": "Doraemon lives in Nobita's house."},
     {"word": "tie", "meaning": "ネクタイ", "example": "ドラえもんは、ネクタイを締めてみた。", "translation": "Doraemon tried wearing a tie."},
     {"word": "drive", "meaning": "運転する", "example": "ドラえもんは、車の運転もできる。", "translation": "Doraemon can drive a car too."}
     ];
     break;
     case "中学英語132":
     item = [
     {"word": "up", "meaning": "上へ", "example": "ドラえもんは、空の上へ飛んで行った。", "translation": "Doraemon flew up into the sky."},
     {"word": "off", "meaning": "離れて", "example": "ドラえもんは、家から離れた。", "translation": "Doraemon went off from home."},
     {"word": "strange", "meaning": "奇妙な", "example": "ドラえもんは、奇妙な夢を見た。", "translation": "Doraemon had a strange dream."},
     {"word": "fresh", "meaning": "新鮮な", "example": "ドラえもんは、新鮮な野菜が好きだ。", "translation": "Doraemon likes fresh vegetables."},
     {"word": "waste", "meaning": "無駄", "example": "ドラえもんは、無駄をなくそうとする。", "translation": "Doraemon tries to eliminate waste."},
     {"word": "national", "meaning": "国家的な", "example": "ドラえもんは、国家的なイベントに参加した。", "translation": "Doraemon participated in a national event."},
     {"word": "read", "meaning": "読む", "example": "ドラえもんは、漫画を読むのが好きだ。", "translation": "Doraemon likes to read manga."},
     {"word": "cheer", "meaning": "応援する", "example": "ドラえもんは、みんなを応援する。", "translation": "Doraemon cheers for everyone."},
     {"word": "foot", "meaning": "足", "example": "ドラえもんは、足を使って歩く。", "translation": "Doraemon walks using his feet."},
     {"word": "sweet", "meaning": "甘い", "example": "ドラえもんは、甘いものが好きだ。", "translation": "Doraemon likes sweet things."}
     ];
     break;
     case "中学英語133":
     item = [
     {"word": "rain", "meaning": "雨", "example": "ドラえもんは、雨の日に傘をさした。", "translation": "Doraemon used an umbrella on a rainy day."},
     {"word": "useful", "meaning": "役に立つ", "example": "ドラえもんの道具は、とても役に立つ。", "translation": "Doraemon's gadgets are very useful."},
     {"word": "hill", "meaning": "丘", "example": "ドラえもんは、丘の上に立って景色を眺めた。", "translation": "Doraemon stood on top of a hill and looked at the view."},
     {"word": "help", "meaning": "助ける", "example": "ドラえもんは、困っている人を助ける。", "translation": "Doraemon helps people in trouble."},
     {"word": "drink", "meaning": "飲む", "example": "ドラえもんは、ジュースを飲んだ。", "translation": "Doraemon drank juice."},
     {"word": "blue", "meaning": "青い", "example": "ドラえもんは、青い色のロボットだ。", "translation": "Doraemon is a blue robot."},
     {"word": "with", "meaning": "～と一緒に", "example": "ドラえもんは、いつもみんなと一緒に遊ぶ。", "translation": "Doraemon always plays with everyone."},
     {"word": "dry", "meaning": "乾いた", "example": "ドラえもんは、濡れた服を乾かした。", "translation": "Doraemon dried his wet clothes."},
     {"word": "history", "meaning": "歴史", "example": "ドラえもんは、日本の歴史に詳しい。", "translation": "Doraemon is familiar with Japanese history."},
     {"word": "score", "meaning": "得点", "example": "ドラえもんは、ゲームで良い得点をとった。", "translation": "Doraemon got a good score in the game."}
     ];
     break;
     case "中学英語134":
     item = [
     {"word": "hobby", "meaning": "趣味", "example": "ドラえもんの趣味は、どら焼きを食べることだ。", "translation": "Doraemon's hobby is eating dorayaki."},
     {"word": "better", "meaning": "より良い", "example": "ドラえもんは、のび太がより良くなるように願っている。", "translation": "Doraemon hopes that Nobita will become better."},
     {"word": "build", "meaning": "建てる", "example": "ドラえもんは、自分で秘密基地を建てた。", "translation": "Doraemon built his own secret base."},
     {"word": "where", "meaning": "どこ", "example": "ドラえもんは、どこへ行くか迷っている。", "translation": "Doraemon is wondering where to go."},
     {"word": "ready", "meaning": "準備ができた", "example": "ドラえもんは、冒険の準備ができた。", "translation": "Doraemon is ready for the adventure."},
     {"word": "either", "meaning": "どちらも", "example": "ドラえもんは、どちらの選択も好きだ。", "translation": "Doraemon likes either choice."},
     {"word": "sell", "meaning": "売る", "example": "ドラえもんは、秘密道具を売ってみた。", "translation": "Doraemon tried selling his secret gadgets."},
     {"word": "what", "meaning": "何", "example": "ドラえもんは、「何がしたい？」と聞いた。", "translation": "Doraemon asked, 'What do you want to do?'"},
     {"word": "station", "meaning": "駅", "example": "ドラえもんは、駅で電車を待った。", "translation": "Doraemon waited for the train at the station."},
     {"word": "video", "meaning": "ビデオ", "example": "ドラえもんは、ビデオを撮るのが好きだ。", "translation": "Doraemon likes to take videos."}
     ];
     break;
     case "中学英語135":
     item = [
     {"word": "do", "meaning": "する", "example": "ドラえもんは、宿題を手伝ってくれる。", "translation": "Doraemon helps me do my homework."},
     {"word": "gray", "meaning": "灰色の", "example": "ドラえもんは、灰色の服を着ている。", "translation": "Doraemon is wearing gray clothes."},
     {"word": "umbrella", "meaning": "傘", "example": "ドラえもんは、傘をさして出かけた。", "translation": "Doraemon went out with an umbrella."},
     {"word": "kite", "meaning": "凧", "example": "ドラえもんは、凧を飛ばした。", "translation": "Doraemon flew a kite."},
     {"word": "friend", "meaning": "友達", "example": "ドラえもんは、のび太にとって最高の友達だ。", "translation": "Doraemon is the best friend for Nobita."},
     {"word": "windy", "meaning": "風の強い", "example": "風の強い日に、ドラえもんは凧揚げをした。", "translation": "Doraemon flew a kite on a windy day."},
     {"word": "winter", "meaning": "冬", "example": "ドラえもんは、冬が好きだ。", "translation": "Doraemon likes winter."},
     {"word": "still", "meaning": "まだ", "example": "ドラえもんは、まだ秘密道具を隠している。", "translation": "Doraemon is still hiding a secret gadget."},
     {"word": "mean", "meaning": "意味する", "example": "ドラえもんは、言葉の意味を説明した。", "translation": "Doraemon explained what it means."},
     {"word": "myself", "meaning": "私自身", "example": "ドラえもんは、私自身で解決したいと願った。", "translation": "Doraemon wished to solve the problem by myself."}
     ];
     break;
     case "中学英語136":
     item = [
     {"word": "wife", "meaning": "妻", "example": "のび太は、将来しずかちゃんの夫になる。", "translation": "Nobita will become Shizuka's wife in the future."},
     {"word": "always", "meaning": "いつも", "example": "ドラえもんは、いつもみんなを助ける。", "translation": "Doraemon always helps everyone."},
     {"word": "warm", "meaning": "暖かい", "example": "ドラえもんは、暖かい場所が好きだ。", "translation": "Doraemon likes warm places."},
     {"word": "green", "meaning": "緑色の", "example": "ドラえもんは、緑色の服を着ている。", "translation": "Doraemon is wearing green clothes."},
     {"word": "wake", "meaning": "起こす", "example": "ドラえもんは、のび太を起こすのが得意だ。", "translation": "Doraemon is good at waking up Nobita."},
     {"word": "coffee", "meaning": "コーヒー", "example": "ドラえもんは、コーヒーを飲んで一息ついた。", "translation": "Doraemon took a break and drank coffee."},
     {"word": "shop", "meaning": "店", "example": "ドラえもんは、おもちゃ屋に行った。", "translation": "Doraemon went to a toy shop."},
     {"word": "costume", "meaning": "衣装", "example": "ドラえもんは、特別な衣装を着た。", "translation": "Doraemon wore a special costume."},
     {"word": "stove", "meaning": "ストーブ", "example": "ドラえもんは、ストーブで暖まった。", "translation": "Doraemon warmed himself with a stove."},
     {"word": "everyone", "meaning": "みんな", "example": "ドラえもんは、みんなと友達になりたいと思っている。", "translation": "Doraemon wants to be friends with everyone."}
     ];
     break;
     case "中学英語137":
     item = [
     {"word": "song", "meaning": "歌", "example": "ドラえもんは、歌を歌うのが好きだ。", "translation": "Doraemon likes to sing songs."},
     {"word": "way", "meaning": "道", "example": "ドラえもんは、正しい道を示してくれる。", "translation": "Doraemon shows the right way."},
     {"word": "man", "meaning": "男", "example": "ドラえもんは、男の人にも人気がある。", "translation": "Doraemon is popular among men too."},
     {"word": "lucky", "meaning": "幸運な", "example": "ドラえもんは、幸運にも問題を解決できた。", "translation": "Doraemon was lucky to solve the problem."},
     {"word": "pharmacist", "meaning": "薬剤師", "example": "ドラえもんは、未来の薬剤師について知っている。", "translation": "Doraemon knows about future pharmacists."},
     {"word": "rock", "meaning": "岩", "example": "ドラえもんは、大きな岩を持ち上げた。", "translation": "Doraemon lifted a big rock."},
     {"word": "river", "meaning": "川", "example": "ドラえもんは、川で魚を釣った。", "translation": "Doraemon fished in the river."},
     {"word": "town", "meaning": "町", "example": "ドラえもんは、町を散歩した。", "translation": "Doraemon took a walk around the town."},
     {"word": "nice", "meaning": "良い", "example": "ドラえもんは、とても良い友達だ。", "translation": "Doraemon is a very nice friend."},
     {"word": "nothing", "meaning": "何も～ない", "example": "ドラえもんは、何も隠していない。", "translation": "Doraemon is hiding nothing."}
     ];
     break;
     case "中学英語138":
     item = [
     {"word": "silver", "meaning": "銀色の", "example": "ドラえもんは、銀色の道具を持っている。", "translation": "Doraemon has a silver gadget."},
     {"word": "art", "meaning": "芸術", "example": "ドラえもんは、芸術作品を見るのが好きだ。", "translation": "Doraemon likes to see works of art."},
     {"word": "technology", "meaning": "技術", "example": "ドラえもんは、未来の技術を持っている。", "translation": "Doraemon has technology from the future."},
     {"word": "billion", "meaning": "１０億", "example": "ドラえもんは、１０億個の秘密道具を持っているという噂がある。", "translation": "There is a rumor that Doraemon has a billion secret gadgets."},
     {"word": "outside", "meaning": "外に", "example": "ドラえもんは、外で遊ぶのが好きだ。", "translation": "Doraemon likes to play outside."},
     {"word": "future", "meaning": "未来", "example": "ドラえもんは、未来から来た。", "translation": "Doraemon came from the future."},
     {"word": "branch", "meaning": "枝", "example": "ドラえもんは、木の枝を拾って何かを作ろうとした。", "translation": "Doraemon picked up a tree branch and tried to make something."},
     {"word": "clock", "meaning": "時計", "example": "ドラえもんは、時間を確認するために時計を見た。", "translation": "Doraemon looked at the clock to check the time."},
     {"word": "recipe", "meaning": "レシピ", "example": "ドラえもんは、レシピを見て料理を作った。", "translation": "Doraemon made a dish by looking at the recipe."},
     {"word": "shout", "meaning": "叫ぶ", "example": "ドラえもんは、嬉しくて叫んだ。", "translation": "Doraemon shouted for joy."}
     ];
     break;
     case "中学英語139":
     item = [
     {"word": "stomachache", "meaning": "腹痛", "example": "のび太は、食べ過ぎて腹痛になってしまった。", "translation": "Nobita ate too much and got a stomachache."},
     {"word": "their", "meaning": "彼らの", "example": "これらの道具は、彼らのものだ。", "translation": "These gadgets are theirs."},
     {"word": "drop", "meaning": "落とす", "example": "のび太は、ボールを落としてしまった。", "translation": "Nobita dropped the ball."},
     {"word": "gentleman", "meaning": "紳士", "example": "ドラえもんは、紳士のように礼儀正しい。", "translation": "Doraemon is polite like a gentleman."},
     {"word": "final", "meaning": "最終の", "example": "ドラえもんは、最終決戦に挑んだ。", "translation": "Doraemon challenged the final battle."},
     {"word": "peace", "meaning": "平和", "example": "ドラえもんは、平和な世界を願っている。", "translation": "Doraemon wishes for a peaceful world."},
     {"word": "stop", "meaning": "止める", "example": "ドラえもんは、戦争を止めたいと思っている。", "translation": "Doraemon wants to stop war."},
     {"word": "concert", "meaning": "コンサート", "example": "ドラえもんは、音楽のコンサートに行った。", "translation": "Doraemon went to a music concert."},
     {"word": "wall", "meaning": "壁", "example": "ドラえもんは、壁に何かを貼った。", "translation": "Doraemon put something up on the wall."},
     {"word": "straight", "meaning": "まっすぐな", "example": "ドラえもんは、まっすぐな道を進んだ。", "translation": "Doraemon went straight ahead."}
     ];
     break;
     case "中学英語140":
     item = [
     {"word": "fact", "meaning": "事実", "example": "ドラえもんは、事実を伝えるのが大切だと考えた。", "translation": "Doraemon thought it was important to tell the facts."},
     {"word": "zoo", "meaning": "動物園", "example": "ドラえもんは、動物園へ行った。", "translation": "Doraemon went to the zoo."},
     {"word": "building", "meaning": "建物", "example": "ドラえもんは、高い建物を見上げた。", "translation": "Doraemon looked up at a tall building."},
     {"word": "maybe", "meaning": "多分", "example": "ドラえもんは、「多分、大丈夫だよ」と言った。", "translation": "Doraemon said, 'Maybe it's okay'."},
     {"word": "quick", "meaning": "早い", "example": "ドラえもんは、素早く動く。", "translation": "Doraemon moves quickly."},
     {"word": "know", "meaning": "知っている", "example": "ドラえもんは、何でも知っている。", "translation": "Doraemon knows everything."},
     {"word": "afraid", "meaning": "恐れる", "example": "ドラえもんは、ねずみを恐れている。", "translation": "Doraemon is afraid of mice."},
     {"word": "glad", "meaning": "嬉しい", "example": "ドラえもんは、みんなが喜んでくれると嬉しい。", "translation": "Doraemon is glad when everyone is happy."},
     {"word": "only", "meaning": "たった～だけ", "example": "ドラえもんは、たった一つの秘密道具を使った。", "translation": "Doraemon used only one secret gadget."},
     {"word": "environment", "meaning": "環境", "example": "ドラえもんは、環境を守るのが大切だと言った。", "translation": "Doraemon said it's important to protect the environment."}
     ];
     break;
     case "中学英語141":
     item = [
     {"word": "fridge", "meaning": "冷蔵庫", "example": "ドラえもんは、冷蔵庫にどら焼きを保管している。", "translation": "Doraemon keeps dorayaki in the fridge."},
     {"word": "opinion", "meaning": "意見", "example": "ドラえもんは、みんなの意見を聞いた。", "translation": "Doraemon listened to everyone's opinions."},
     {"word": "reuse", "meaning": "再利用する", "example": "ドラえもんは、道具を再利用することにした。", "translation": "Doraemon decided to reuse the gadget."},
     {"word": "busy", "meaning": "忙しい", "example": "ドラえもんは、毎日忙しい。", "translation": "Doraemon is busy every day."},
     {"word": "tired", "meaning": "疲れた", "example": "ドラえもんは、少し疲れている。", "translation": "Doraemon is a little tired."},
     {"word": "toe", "meaning": "つま先", "example": "のび太は、つま先をぶつけた。", "translation": "Nobita bumped his toe."},
     {"word": "nose", "meaning": "鼻", "example": "ドラえもんは、鼻を使って匂いを嗅いでいる。", "translation": "Doraemon uses his nose to smell."},
     {"word": "whole", "meaning": "全体の", "example": "ドラえもんは、全体を見た。", "translation": "Doraemon saw the whole picture."},
     {"word": "traffic", "meaning": "交通", "example": "ドラえもんは、交通ルールを守る。", "translation": "Doraemon obeys traffic rules."},
     {"word": "cause", "meaning": "原因", "example": "ドラえもんは、問題の原因を突き止めた。", "translation": "Doraemon identified the cause of the problem."}
     ];
     break;
    
     
     case "高校英語1":
     item = [
     {"word": "primarily", "meaning": "主として", "example": "ドラえもんは、主にのび太の世話をしている。", "translation": "Doraemon is primarily taking care of Nobita."},
     {"word": "powerhouse", "meaning": "強豪", "example": "ジャイアンは、町のガキ大将という強豪だ。", "translation": "Gian is a powerhouse among the town bullies."},
     {"word": "jumper", "meaning": "ジャンパー", "example": "ドラえもんは、新しいジャンパーを着てみた。", "translation": "Doraemon tried on a new jumper."},
     {"word": "attorney", "meaning": "弁護士", "example": "ドラえもんは、困ったときは未来の弁護士に相談する。", "translation": "Doraemon consults with a future attorney when he's in trouble."},
     {"word": "construction", "meaning": "建設", "example": "ドラえもんは、未来の建設技術を教えた。", "translation": "Doraemon taught about future construction technology."},
     {"word": "prestige", "meaning": "名声", "example": "ドラえもんは、未来で高い名声を得ている。", "translation": "Doraemon has high prestige in the future."},
     {"word": "competition", "meaning": "競争", "example": "ドラえもんは、競争を避ける。", "translation": "Doraemon avoids competition."},
     {"word": "discourage", "meaning": "落胆させる", "example": "ドラえもんは、のび太を落胆させないように励ます。", "translation": "Doraemon encourages Nobita so he won't be discouraged."},
     {"word": "guy", "meaning": "男", "example": "ドラえもんは、面白い男の子と友達になった。", "translation": "Doraemon became friends with an interesting guy."},
     {"word": "summit", "meaning": "頂上", "example": "ドラえもんは、山頂に登り、景色を楽しんだ。", "translation": "Doraemon climbed to the summit of the mountain and enjoyed the view."}
     ];
     break;
     case "高校英語2":
     item = [
     {"word": "industrialize", "meaning": "工業化する", "example": "ドラえもんは、未来の工業化された都市を見学した。", "translation": "Doraemon visited a future industrialized city."},
     {"word": "filter", "meaning": "ろ過する", "example": "ドラえもんは、水をろ過して飲んだ。", "translation": "Doraemon filtered water and drank it."},
     {"word": "infrastructure", "meaning": "インフラ", "example": "ドラえもんは、未来のインフラに驚いた。", "translation": "Doraemon was amazed by the future infrastructure."},
     {"word": "pence", "meaning": "ペンス", "example": "ドラえもんは、未来のお金でペンスを使った。", "translation": "Doraemon used pence in the future currency."},
     {"word": "grim", "meaning": "厳しい", "example": "ドラえもんは、厳しい現実を目の当たりにした。", "translation": "Doraemon faced a grim reality."},
     {"word": "airmail", "meaning": "航空便", "example": "ドラえもんは、未来から航空便で手紙を送った。", "translation": "Doraemon sent a letter by airmail from the future."},
     {"word": "transplant", "meaning": "移植する", "example": "ドラえもんは、未来の技術で植物を移植した。", "translation": "Doraemon transplanted a plant using future technology."},
     {"word": "gangster", "meaning": "ギャング", "example": "ドラえもんは、ギャングに遭遇してしまった。", "translation": "Doraemon encountered a gangster."},
     {"word": "erupt", "meaning": "噴火する", "example": "ドラえもんは、火山が噴火するところを見た。", "translation": "Doraemon saw a volcano erupt."},
     {"word": "tribe", "meaning": "部族", "example": "ドラえもんは、過去の部族と交流した。", "translation": "Doraemon interacted with a tribe in the past."}
     ];
     break;
     case "高校英語3":
     item = [
     {"word": "indeed", "meaning": "実に", "example": "ドラえもんの道具は、実に便利だ。", "translation": "Doraemon's gadgets are indeed useful."},
     {"word": "opportunity", "meaning": "機会", "example": "ドラえもんは、のび太にチャンスを与えようとする。", "translation": "Doraemon tries to give Nobita an opportunity."},
     {"word": "gloomy", "meaning": "陰気な", "example": "雨の日、ドラえもんは少し陰気な気分になった。", "translation": "Doraemon felt a little gloomy on a rainy day."},
     {"word": "seek", "meaning": "探し求める", "example": "ドラえもんは、新しい冒険を求めて旅に出る。", "translation": "Doraemon goes on a journey seeking a new adventure."},
     {"word": "erect", "meaning": "建設する", "example": "ドラえもんは、秘密基地を建設しようとしている。", "translation": "Doraemon is trying to erect a secret base."},
     {"word": "adolescent", "meaning": "青年", "example": "ドラえもんは、のび太の青年時代を見守っている。", "translation": "Doraemon is watching over Nobita's adolescent years."},
     {"word": "clause", "meaning": "条項", "example": "ドラえもんは、契約書に書かれた条項を読んだ。", "translation": "Doraemon read the clause written in the contract."},
     {"word": "contradict", "meaning": "矛盾する", "example": "ドラえもんの行動は、時々矛盾している。", "translation": "Doraemon's actions sometimes contradict each other."},
     {"word": "columnist", "meaning": "コラムニスト", "example": "ドラえもんは、新聞のコラムニストにインタビューを受けた。", "translation": "Doraemon was interviewed by a newspaper columnist."},
     {"word": "sustain", "meaning": "持続させる", "example": "ドラえもんは、持続可能な社会の実現を願っている。", "translation": "Doraemon hopes to sustain a sustainable society."}
     ];
     break;
     case "高校英語4":
     item = [
     {"word": "criticize", "meaning": "批判する", "example": "ドラえもんは、ジャイアンの行動を批判した。", "translation": "Doraemon criticized Gian's actions."},
     {"word": "impact", "meaning": "影響", "example": "ドラえもんの道具は、世界に大きな影響を与える。", "translation": "Doraemon's gadgets have a big impact on the world."},
     {"word": "radioactive", "meaning": "放射性の", "example": "ドラえもんは、放射性物質を避ける。", "translation": "Doraemon avoids radioactive substances."},
     {"word": "vow", "meaning": "誓う", "example": "ドラえもんは、永遠にのび太の友達でいると誓った。", "translation": "Doraemon vowed to be Nobita's friend forever."},
     {"word": "straightforward", "meaning": "率直な", "example": "ドラえもんは、いつも率直な意見を言う。", "translation": "Doraemon always gives straightforward opinions."},
     {"word": "outgoing", "meaning": "社交的な", "example": "ドラえもんは、社交的な性格だ。", "translation": "Doraemon has an outgoing personality."},
     {"word": "foundation", "meaning": "基礎", "example": "ドラえもんは、しっかりとした基礎を築くことを大切にしている。", "translation": "Doraemon values building a solid foundation."},
     {"word": "clinical", "meaning": "臨床の", "example": "ドラえもんは、臨床実験の結果を知っている。", "translation": "Doraemon knows the results of a clinical trial."},
     {"word": "environmentalist", "meaning": "環境保護活動家", "example": "ドラえもんは、環境保護活動家と一緒に地球を守る。", "translation": "Doraemon protects the Earth with an environmentalist."},
     {"word": "reaction", "meaning": "反応", "example": "ドラえもんは、のび太の反応にいつも驚いている。", "translation": "Doraemon is always surprised by Nobita's reactions."}
     ];
     break;
     case "高校英語5":
     item = [
     {"word": "attitude", "meaning": "態度", "example": "ドラえもんは、前向きな態度を保っている。", "translation": "Doraemon maintains a positive attitude."},
     {"word": "instruction", "meaning": "指示", "example": "ドラえもんは、のび太に道具の使い方を指示した。", "translation": "Doraemon instructed Nobita on how to use the gadget."},
     {"word": "feature", "meaning": "特徴", "example": "ドラえもんの特徴は、青い体だ。", "translation": "A feature of Doraemon is his blue body."},
     {"word": "appropriate", "meaning": "適切な", "example": "ドラえもんは、状況に合った適切な道具を使う。", "translation": "Doraemon uses appropriate gadgets for each situation."},
     {"word": "harmful", "meaning": "有害な", "example": "ドラえもんは、有害な物質を避ける。", "translation": "Doraemon avoids harmful substances."},
     {"word": "whisper", "meaning": "ささやく", "example": "ドラえもんは、のび太に小さな声でささやいた。", "translation": "Doraemon whispered to Nobita in a small voice."},
     {"word": "southern", "meaning": "南の", "example": "ドラえもんは、南の島へ旅行に行った。", "translation": "Doraemon went on a trip to a southern island."},
     {"word": "access", "meaning": "アクセス", "example": "ドラえもんは、未来のデータベースにアクセスした。", "translation": "Doraemon accessed a future database."},
     {"word": "function", "meaning": "機能", "example": "ドラえもんの道具には、色々な機能がある。", "translation": "Doraemon's gadgets have various functions."},
     {"word": "gallery", "meaning": "ギャラリー", "example": "ドラえもんは、美術館のギャラリーで絵を見た。", "translation": "Doraemon saw paintings in the gallery of an art museum."}
     ];
     break;
     case "高校英語6":
     item = [
     {"word": "hardship", "meaning": "苦難", "example": "ドラえもんは、のび太の苦難を分かち合う。", "translation": "Doraemon shares Nobita's hardships."},
     {"word": "endangered", "meaning": "絶滅危惧の", "example": "ドラえもんは、絶滅危惧種の動物を保護している。", "translation": "Doraemon is protecting endangered animals."},
     {"word": "dimension", "meaning": "次元", "example": "ドラえもんは、異なる次元を旅することができる。", "translation": "Doraemon can travel through different dimensions."},
     {"word": "barely", "meaning": "かろうじて", "example": "ドラえもんは、かろうじて危機を脱出した。", "translation": "Doraemon barely escaped the crisis."},
     {"word": "faithful", "meaning": "忠実な", "example": "ドラえもんは、のび太に忠実な友達だ。", "translation": "Doraemon is a faithful friend to Nobita."},
     {"word": "recession", "meaning": "不況", "example": "ドラえもんは、未来の不況について知っている。", "translation": "Doraemon knows about the future recession."},
     {"word": "neutral", "meaning": "中立の", "example": "ドラえもんは、争いに対して中立の立場を取る。", "translation": "Doraemon takes a neutral stance in conflicts."},
     {"word": "basis", "meaning": "根拠", "example": "ドラえもんは、根拠に基づいて行動する。", "translation": "Doraemon acts based on evidence."},
     {"word": "classification", "meaning": "分類", "example": "ドラえもんは、道具を分類してみた。", "translation": "Doraemon tried classifying his gadgets."},
     {"word": "spectacular", "meaning": "壮観な", "example": "ドラえもんは、壮観な景色を見て感動した。", "translation": "Doraemon was moved by the spectacular view."}
     ];
     break;
     case "高校英語7":
     item = [
     {"word": "infect", "meaning": "感染させる", "example": "ドラえもんは、病気を感染させないように気をつけている。", "translation": "Doraemon is careful not to infect others with diseases."},
     {"word": "superpower", "meaning": "超大国", "example": "ドラえもんは、未来の超大国について知っている。", "translation": "Doraemon knows about future superpowers."},
     {"word": "linguistic", "meaning": "言語の", "example": "ドラえもんは、言語の壁を乗り越える。", "translation": "Doraemon overcomes linguistic barriers."},
     {"word": "aid", "meaning": "援助", "example": "ドラえもんは、困っている人に援助する。", "translation": "Doraemon provides aid to people in need."},
     {"word": "timid", "meaning": "臆病な", "example": "ドラえもんは、臆病な部分がある。", "translation": "Doraemon has some timid aspects."},
     {"word": "stubborn", "meaning": "頑固な", "example": "ドラえもんは、時には頑固になることがある。", "translation": "Doraemon can sometimes be stubborn."},
     {"word": "accordingly", "meaning": "それに応じて", "example": "ドラえもんは、状況に応じて適切な行動をとる。", "translation": "Doraemon acts accordingly to the situation."},
     {"word": "limitation", "meaning": "制限", "example": "ドラえもんの道具には、時間制限がある。", "translation": "Doraemon's gadgets have time limitations."},
     {"word": "astronomer", "meaning": "天文学者", "example": "ドラえもんは、未来の天文学者と会った。", "translation": "Doraemon met a future astronomer."},
     {"word": "enable", "meaning": "可能にする", "example": "ドラえもんは、のび太の夢を可能にする。", "translation": "Doraemon enables Nobita's dreams."}
     ];
     break;
     case "高校英語8":
     item = [
     {"word": "integrate", "meaning": "統合する", "example": "ドラえもんは、色々なものを統合して新たな道具を作る。", "translation": "Doraemon integrates various things to create new gadgets."},
     {"word": "partial", "meaning": "部分的な", "example": "ドラえもんは、部分的に壊れてしまった。", "translation": "Doraemon was partially broken."},
     {"word": "operation", "meaning": "手術", "example": "ドラえもんは、未来の技術で手術を受けた。", "translation": "Doraemon had an operation using future technology."},
     {"word": "regarding", "meaning": "～に関して", "example": "ドラえもんは、将来に関して話をした。", "translation": "Doraemon talked regarding the future."},
     {"word": "horizontal", "meaning": "水平な", "example": "ドラえもんは、水平な地面を歩いた。", "translation": "Doraemon walked on a horizontal surface."},
     {"word": "migrate", "meaning": "移動する", "example": "ドラえもんは、色々な場所へ移動する。", "translation": "Doraemon migrates to various places."},
     {"word": "leftover", "meaning": "残り物", "example": "ドラえもんは、残り物で美味しい料理を作った。", "translation": "Doraemon made delicious food with leftovers."},
     {"word": "shallow", "meaning": "浅い", "example": "ドラえもんは、浅い川を渡った。", "translation": "Doraemon crossed the shallow river."},
     {"word": "absurd", "meaning": "不条理な", "example": "ドラえもんは、不条理な出来事に遭遇した。", "translation": "Doraemon encountered an absurd event."},
     {"word": "admit", "meaning": "認める", "example": "ドラえもんは、自分の間違いを認めた。", "translation": "Doraemon admitted his mistake."}
     ];
     break;
     case "高校英語9":
     item = [
     {"word": "unfortunately", "meaning": "残念なことに", "example": "残念なことに、ドラえもんの道具は壊れてしまった。", "translation": "Unfortunately, Doraemon's gadget broke."},
     {"word": "admission", "meaning": "入場", "example": "ドラえもんは、博物館への入場チケットを買った。", "translation": "Doraemon bought an admission ticket to the museum."},
     {"word": "shocked", "meaning": "衝撃を受けた", "example": "ドラえもんは、真実に衝撃を受けた。", "translation": "Doraemon was shocked by the truth."},
     {"word": "determine", "meaning": "決定する", "example": "ドラえもんは、問題を解決することを決定した。", "translation": "Doraemon determined to solve the problem."},
     {"word": "equipment", "meaning": "機器", "example": "ドラえもんは、未来の機器を使った。", "translation": "Doraemon used future equipment."},
     {"word": "bang", "meaning": "ドスン", "example": "ドラえもんは、大きな音を立てて落ちてきた。", "translation": "Doraemon fell down with a bang."},
     {"word": "spin", "meaning": "回転する", "example": "ドラえもんは、コマを回転させて遊んだ。", "translation": "Doraemon played with a spinning top."},
     {"word": "ballot", "meaning": "投票", "example": "ドラえもんは、未来の選挙で投票した。", "translation": "Doraemon voted in a future election."},
     {"word": "seaside", "meaning": "海辺", "example": "ドラえもんは、海辺を散歩した。", "translation": "Doraemon took a walk by the seaside."},
     {"word": "completion", "meaning": "完了", "example": "ドラえもんは、計画の完了を喜んだ。", "translation": "Doraemon was happy with the completion of the plan."}
     ];
     break;
     case "高校英語10":
     item = [
     {"word": "rehearsal", "meaning": "リハーサル", "example": "ドラえもんは、コンサートのリハーサルに参加した。", "translation": "Doraemon participated in the rehearsal for the concert."},
     {"word": "shuttle", "meaning": "シャトル", "example": "ドラえもんは、宇宙シャトルに乗って旅行に行った。", "translation": "Doraemon went on a trip on a space shuttle."},
     {"word": "basically", "meaning": "基本的に", "example": "ドラえもんは、基本的に優しい。", "translation": "Doraemon is basically kind."},
     {"word": "anticipate", "meaning": "予想する", "example": "ドラえもんは、未来の出来事を予想した。", "translation": "Doraemon anticipated future events."},
     {"word": "escalator", "meaning": "エスカレーター", "example": "ドラえもんは、エスカレーターに乗ってみた。", "translation": "Doraemon tried riding an escalator."},
     {"word": "inhabitant", "meaning": "住民", "example": "ドラえもんは、未来の住民と交流した。", "translation": "Doraemon interacted with future inhabitants."},
     {"word": "peacefully", "meaning": "平和に", "example": "ドラえもんは、平和に暮らすことを願っている。", "translation": "Doraemon hopes to live peacefully."},
     {"word": "province", "meaning": "地方", "example": "ドラえもんは、日本の地方へ旅行に出かけた。", "translation": "Doraemon went on a trip to a province in Japan."},
     {"word": "affiliate", "meaning": "提携する", "example": "ドラえもんは、未来の企業と提携した。", "translation": "Doraemon affiliated with a future company."},
     {"word": "graze", "meaning": "放牧する", "example": "ドラえもんは、牧場で動物を放牧した。", "translation": "Doraemon grazed animals in a pasture."}
     ];
     break;

    
     
     case "高校英語11":
     item = [
     {"word": "characteristic", "meaning": "特徴", "example": "ドラえもんの最も大きな特徴は、青い体と丸い頭だ。", "translation": "Doraemon's most notable characteristics are his blue body and round head."},
     {"word": "creature", "meaning": "生き物", "example": "ドラえもんは、色々な種類の生き物と出会う。", "translation": "Doraemon encounters various kinds of creatures."},
     {"word": "entry", "meaning": "入り口", "example": "ドラえもんは、どこでもドアの入り口から入った。", "translation": "Doraemon entered through the entry of the Anywhere Door."},
     {"word": "imitate", "meaning": "真似る", "example": "のび太は、ドラえもんの仕草を真似しようとする。", "translation": "Nobita tries to imitate Doraemon's gestures."},
     {"word": "register", "meaning": "登録する", "example": "ドラえもんは、未来の道具を登録した。", "translation": "Doraemon registered his future gadgets."},
     {"word": "perceive", "meaning": "知覚する", "example": "ドラえもんは、危険をすぐに知覚する。", "translation": "Doraemon quickly perceives danger."},
     {"word": "clothing", "meaning": "衣服", "example": "ドラえもんは、色々な種類の衣服を持っている。", "translation": "Doraemon has various types of clothing."},
     {"word": "indoor", "meaning": "屋内の", "example": "ドラえもんは、屋内で遊ぶのが好きだ。", "translation": "Doraemon likes to play indoors."},
     {"word": "loose", "meaning": "緩い", "example": "ドラえもんの首輪は少し緩かった。", "translation": "Doraemon's collar was a little loose."},
     {"word": "pale", "meaning": "青白い", "example": "のび太は、病気で少し青白い顔をしている。", "translation": "Nobita has a slightly pale face because he is sick."}
     ];
     break;
     case "高校英語12":
     item = [
     {"word": "production", "meaning": "生産", "example": "ドラえもんは、未来の生産技術を見学した。", "translation": "Doraemon visited the future's production technology."},
     {"word": "major", "meaning": "主要な", "example": "ドラえもんの主要な目的は、のび太を助けることだ。", "translation": "Doraemon's major purpose is to help Nobita."},
     {"word": "independent", "meaning": "独立した", "example": "ドラえもんは、独立して行動することができる。", "translation": "Doraemon can act independently."},
     {"word": "avoid", "meaning": "避ける", "example": "ドラえもんは、危険な場所を避ける。", "translation": "Doraemon avoids dangerous places."},
     {"word": "ceremony", "meaning": "式典", "example": "ドラえもんは、卒業式典に参加した。", "translation": "Doraemon participated in the graduation ceremony."},
     {"word": "ideal", "meaning": "理想的な", "example": "ドラえもんは、理想的な世界を夢見ている。", "translation": "Doraemon dreams of an ideal world."},
     {"word": "rare", "meaning": "珍しい", "example": "ドラえもんは、珍しい生き物を見た。", "translation": "Doraemon saw a rare creature."},
     {"word": "eventually", "meaning": "結局は", "example": "ドラえもんは、結局のび太を助けることになる。", "translation": "Doraemon eventually ends up helping Nobita."},
     {"word": "lunchtime", "meaning": "昼食時間", "example": "のび太は、いつも昼食時間が待ち遠しい。", "translation": "Nobita always looks forward to lunchtime."},
     {"word": "garbage", "meaning": "ゴミ", "example": "ドラえもんは、ゴミを分別して捨てた。", "translation": "Doraemon sorted and threw away the garbage."}
     ];
     break;
     case "高校英語13":
     item = [
     {"word": "sector", "meaning": "部門", "example": "ドラえもんは、未来の様々な部門について知っている。", "translation": "Doraemon knows about various sectors of the future."},
     {"word": "concrete", "meaning": "具体的な", "example": "ドラえもんは、具体的な計画を立てた。", "translation": "Doraemon made a concrete plan."},
     {"word": "revenue", "meaning": "収入", "example": "ドラえもんは、未来の経済における収入について考えた。", "translation": "Doraemon thought about revenue in the future economy."},
     {"word": "malnutrition", "meaning": "栄養失調", "example": "ドラえもんは、栄養失調で苦しむ人を助ける。", "translation": "Doraemon helps people suffering from malnutrition."},
     {"word": "ultimately", "meaning": "最終的に", "example": "ドラえもんは、最終的に問題を解決する。", "translation": "Doraemon ultimately solves the problem."},
     {"word": "prominent", "meaning": "著名な", "example": "ドラえもんは、著名な科学者と会った。", "translation": "Doraemon met a prominent scientist."},
     {"word": "suspend", "meaning": "中断する", "example": "ドラえもんは、計画を一時中断した。", "translation": "Doraemon suspended the plan temporarily."},
     {"word": "hazard", "meaning": "危険", "example": "ドラえもんは、危険な場所を避ける。", "translation": "Doraemon avoids hazardous places."},
     {"word": "assessment", "meaning": "評価", "example": "ドラえもんは、現状の評価を行った。", "translation": "Doraemon performed an assessment of the situation."},
     {"word": "spark", "meaning": "火花", "example": "ドラえもんの秘密道具は、時々火花を散らす。", "translation": "Doraemon's secret gadgets sometimes spark."}
     ];
     break;
     case "高校英語14":
     item = [
     {"word": "spite", "meaning": "悪意", "example": "ドラえもんは、悪意のある行動を許さない。", "translation": "Doraemon does not tolerate actions with spite."},
     {"word": "unauthorized", "meaning": "許可されていない", "example": "ドラえもんは、許可されていない場所には入らない。", "translation": "Doraemon does not enter unauthorized areas."},
     {"word": "eternity", "meaning": "永遠", "example": "ドラえもんは、のび太との友情が永遠であることを願っている。", "translation": "Doraemon hopes their friendship with Nobita will last for eternity."},
     {"word": "absolutely", "meaning": "絶対に", "example": "ドラえもんは、絶対に嘘をつかない。", "translation": "Doraemon absolutely never tells a lie."},
     {"word": "assorted", "meaning": "詰め合わせの", "example": "ドラえもんは、色々なお菓子の詰め合わせを買った。", "translation": "Doraemon bought an assorted pack of snacks."},
     {"word": "consumer", "meaning": "消費者", "example": "ドラえもんは、消費者の立場になって考える。", "translation": "Doraemon thinks from the perspective of a consumer."},
     {"word": "pastime", "meaning": "娯楽", "example": "ドラえもんは、昼寝を娯楽として楽しむ。", "translation": "Doraemon enjoys taking naps as a pastime."},
     {"word": "gleam", "meaning": "きらめき", "example": "ドラえもんの目は、希望のきらめきを宿している。", "translation": "Doraemon's eyes hold a gleam of hope."},
     {"word": "empathy", "meaning": "共感", "example": "ドラえもんは、のび太に共感する。", "translation": "Doraemon has empathy for Nobita."},
     {"word": "dependency", "meaning": "依存", "example": "のび太は、ドラえもんに依存しすぎている。", "translation": "Nobita has too much dependency on Doraemon."}
     ];
     break;
     case "高校英語15":
     item = [
     {"word": "discomfort", "meaning": "不快感", "example": "ドラえもんは、少しだけ不快感を感じている。", "translation": "Doraemon is feeling a little discomfort."},
     {"word": "overlap", "meaning": "重なる", "example": "ドラえもんは、違う時間の流れが重なっていることに気づいた。", "translation": "Doraemon noticed the overlap of different timelines."},
     {"word": "venture", "meaning": "冒険", "example": "ドラえもんは、新しい冒険に出かける。", "translation": "Doraemon goes on a new venture."},
     {"word": "claw", "meaning": "爪", "example": "ドラえもんは、猫の爪を触った。", "translation": "Doraemon touched the cat's claw."},
     {"word": "feast", "meaning": "ご馳走", "example": "ドラえもんは、みんなにご馳走を振る舞った。", "translation": "Doraemon treated everyone to a feast."},
     {"word": "tame", "meaning": "飼い慣らす", "example": "ドラえもんは、野生動物を飼い慣らそうとした。", "translation": "Doraemon tried to tame a wild animal."},
     {"word": "scope", "meaning": "範囲", "example": "ドラえもんの道具は、活動範囲を広げる。", "translation": "Doraemon's gadgets expand the scope of his activities."},
     {"word": "turbulence", "meaning": "乱気流", "example": "ドラえもんは、タイムマシンの乱気流に巻き込まれた。", "translation": "Doraemon got caught in the turbulence of the time machine."},
     {"word": "achieve", "meaning": "達成する", "example": "ドラえもんは、目的を達成した。", "translation": "Doraemon achieved his goal."},
     {"word": "disagree", "meaning": "反対する", "example": "ドラえもんは、のび太の意見に反対した。", "translation": "Doraemon disagreed with Nobita's opinion."}
     ];
     break;
     case "高校英語16":
     item = [
     {"word": "salmon", "meaning": "鮭", "example": "ドラえもんは、川で鮭を釣った。", "translation": "Doraemon caught salmon in the river."},
     {"word": "widespread", "meaning": "広範囲にわたる", "example": "ドラえもんの活躍は、広範囲にわたっている。", "translation": "Doraemon's activities are widespread."},
     {"word": "significance", "meaning": "重要性", "example": "ドラえもんは、友情の重要性を知っている。", "translation": "Doraemon knows the significance of friendship."},
     {"word": "tackle", "meaning": "取り組む", "example": "ドラえもんは、難しい問題にも取り組む。", "translation": "Doraemon tackles difficult problems."},
     {"word": "sequence", "meaning": "順番", "example": "ドラえもんは、正しい順番で道具を使った。", "translation": "Doraemon used the gadgets in the correct sequence."},
     {"word": "moderate", "meaning": "適度な", "example": "ドラえもんは、適度な運動を勧めている。", "translation": "Doraemon recommends moderate exercise."},
     {"word": "acknowledge", "meaning": "認める", "example": "ドラえもんは、過去の過ちを認めた。", "translation": "Doraemon acknowledged his past mistakes."},
     {"word": "instruct", "meaning": "教える", "example": "ドラえもんは、のび太に勉強を教える。", "translation": "Doraemon instructs Nobita in his studies."},
     {"word": "fireworks", "meaning": "花火", "example": "ドラえもんは、花火を見て楽しんだ。", "translation": "Doraemon enjoyed watching fireworks."},
     {"word": "attentive", "meaning": "注意深い", "example": "ドラえもんは、のび太に注意深く気を配る。", "translation": "Doraemon is attentive to Nobita."}
     ];
     break;
     case "高校英語17":
     item = [
     {"word": "killer", "meaning": "殺人者", "example": "ドラえもんは、歴史上の殺人犯について学んだ。", "translation": "Doraemon learned about historical killers."},
     {"word": "continent", "meaning": "大陸", "example": "ドラえもんは、色々な大陸を旅行した。", "translation": "Doraemon traveled to different continents."},
     {"word": "stereotypical", "meaning": "典型的な", "example": "ドラえもんは、典型的なロボットのイメージを覆す。", "translation": "Doraemon breaks the stereotypical image of a robot."},
     {"word": "climate", "meaning": "気候", "example": "ドラえもんは、地球の気候変動について心配している。", "translation": "Doraemon is worried about climate change on Earth."},
     {"word": "chemical", "meaning": "化学的な", "example": "ドラえもんは、化学的な実験をした。", "translation": "Doraemon conducted a chemical experiment."},
     {"word": "ancient", "meaning": "古代の", "example": "ドラえもんは、古代文明を訪ねた。", "translation": "Doraemon visited an ancient civilization."},
     {"word": "display", "meaning": "展示", "example": "ドラえもんは、博物館で道具を展示した。", "translation": "Doraemon displayed his gadgets at a museum."},
     {"word": "resume", "meaning": "再開する", "example": "ドラえもんは、中断していた冒険を再開した。", "translation": "Doraemon resumed the adventure he had paused."},
     {"word": "sensation", "meaning": "感覚", "example": "ドラえもんは、未来の感覚を体験した。", "translation": "Doraemon experienced a sensation from the future."},
     {"word": "acting", "meaning": "演技", "example": "ドラえもんは、舞台で演技をした。", "translation": "Doraemon performed acting on the stage."}
     ];
     break;
     case "高校英語18":
     item = [
     {"word": "structure", "meaning": "構造", "example": "ドラえもんは、建物の構造について調べた。", "translation": "Doraemon researched the structure of a building."},
     {"word": "expand", "meaning": "拡大する", "example": "ドラえもんは、どこでもドアで行動範囲を拡大した。", "translation": "Doraemon expanded his range of activity with the Anywhere Door."},
     {"word": "data", "meaning": "データ", "example": "ドラえもんは、未来のデータを分析した。", "translation": "Doraemon analyzed future data."},
     {"word": "concern", "meaning": "懸念", "example": "ドラえもんは、未来の環境問題を懸念している。", "translation": "Doraemon has concerns about future environmental problems."},
     {"word": "typical", "meaning": "典型的な", "example": "のび太は、典型的な小学生だ。", "translation": "Nobita is a typical elementary school student."},
     {"word": "credit", "meaning": "信用", "example": "ドラえもんは、みんなの信用を得ている。", "translation": "Doraemon has earned everyone's credit."},
     {"word": "cancel", "meaning": "キャンセルする", "example": "ドラえもんは、予定をキャンセルした。", "translation": "Doraemon canceled his plans."},
     {"word": "honor", "meaning": "尊敬する", "example": "ドラえもんは、みんなから尊敬されている。", "translation": "Doraemon is honored by everyone."},
     {"word": "disturb", "meaning": "邪魔する", "example": "ドラえもんは、のび太の勉強を邪魔しない。", "translation": "Doraemon does not disturb Nobita's studying."},
     {"word": "spill", "meaning": "こぼす", "example": "のび太は、ジュースをこぼしてしまった。", "translation": "Nobita spilled the juice."}
     ];
     break;
     case "高校英語19":
     item = [
     {"word": "supervise", "meaning": "監督する", "example": "ドラえもんは、子供たちの遊びを監督した。", "translation": "Doraemon supervised the children's play."},
     {"word": "hip", "meaning": "腰", "example": "ドラえもんは、腰を痛めてしまった。", "translation": "Doraemon hurt his hip."},
     {"word": "fragment", "meaning": "断片", "example": "ドラえもんは、壊れた道具の断片を集めた。", "translation": "Doraemon collected the fragments of the broken gadget."},
     {"word": "elsewhere", "meaning": "他の場所で", "example": "ドラえもんは、他の場所で冒険を始めた。", "translation": "Doraemon started an adventure elsewhere."},
     {"word": "hasty", "meaning": "急な", "example": "ドラえもんは、急な出来事に戸惑った。", "translation": "Doraemon was confused by the hasty event."},
     {"word": "immerse", "meaning": "浸す", "example": "ドラえもんは、お風呂にゆっくり浸かった。", "translation": "Doraemon immersed himself in the bath."},
     {"word": "confine", "meaning": "閉じ込める", "example": "ドラえもんは、のび太を部屋に閉じ込めた。", "translation": "Doraemon confined Nobita in the room."},
     {"word": "truly", "meaning": "本当に", "example": "ドラえもんは、のび太を本当に大切に思っている。", "translation": "Doraemon truly cares about Nobita."},
     {"word": "bound", "meaning": "縛られた", "example": "ドラえもんは、時間に縛られない未来から来た。", "translation": "Doraemon came from a future not bound by time."},
     {"word": "startle", "meaning": "びっくりさせる", "example": "ドラえもんは、大きな音でのび太をびっくりさせた。", "translation": "Doraemon startled Nobita with a loud noise."}
     ];
     break;
     case "高校英語20":
     item = [
     {"word": "decline", "meaning": "低下する", "example": "ドラえもんは、地球の環境が低下していくことを心配している。", "translation": "Doraemon is worried about the Earth's environment declining."},
     {"word": "geometry", "meaning": "幾何学", "example": "ドラえもんは、幾何学の問題を解いた。", "translation": "Doraemon solved a geometry problem."},
     {"word": "nominate", "meaning": "推薦する", "example": "ドラえもんは、のび太をヒーローに推薦した。", "translation": "Doraemon nominated Nobita to be a hero."},
     {"word": "oversee", "meaning": "監督する", "example": "ドラえもんは、イベントを監督した。", "translation": "Doraemon oversaw the event."},
     {"word": "snatch", "meaning": "ひったくる", "example": "ドラえもんは、泥棒に道具をひったくられた。", "translation": "Doraemon had his gadget snatched by a thief."},
     {"word": "phase", "meaning": "段階", "example": "ドラえもんは、計画の次の段階に進んだ。", "translation": "Doraemon moved to the next phase of his plan."},
     {"word": "slant", "meaning": "傾斜", "example": "ドラえもんは、傾斜のある場所を歩いた。", "translation": "Doraemon walked on a slant."},
     {"word": "curriculum", "meaning": "カリキュラム", "example": "ドラえもんは、未来の教育カリキュラムを体験した。", "translation": "Doraemon experienced a future education curriculum."},
     {"word": "enrage", "meaning": "激怒させる", "example": "ジャイアンは、のび太を激怒させた。", "translation": "Gian enraged Nobita."},
     {"word": "buyer", "meaning": "買い手", "example": "ドラえもんは、秘密道具の買い手を見つけた。", "translation": "Doraemon found a buyer for his secret gadgets."}
     ];
     break;
    
     
     case "高校英語21":
     item = [
     {"word": "substantial", "meaning": "相当な", "example": "ドラえもんは、相当な量のどら焼きを持っていた。", "translation": "Doraemon had a substantial amount of dorayaki."},
     {"word": "scheme", "meaning": "計画", "example": "ドラえもんは、のび太を助けるための綿密な計画を立てた。", "translation": "Doraemon devised a detailed scheme to help Nobita."},
     {"word": "approximately", "meaning": "およそ", "example": "ドラえもんは、およそ100個の秘密道具を持っている。", "translation": "Doraemon has approximately 100 secret gadgets."},
     {"word": "gender", "meaning": "性別", "example": "ドラえもんは、性別に関係なく誰とでも友達になれる。", "translation": "Doraemon can be friends with anyone regardless of gender."},
     {"word": "nerve", "meaning": "神経", "example": "ドラえもんは、神経を集中させて問題を解いた。", "translation": "Doraemon concentrated his nerve and solved the problem."},
     {"word": "illustrate", "meaning": "説明する", "example": "ドラえもんは、図を使って分かりやすく説明した。", "translation": "Doraemon illustrated his point using diagrams."},
     {"word": "overdo", "meaning": "やりすぎる", "example": "ドラえもんは、いつもやりすぎてしまう。", "translation": "Doraemon always tends to overdo things."},
     {"word": "colored", "meaning": "色付きの", "example": "ドラえもんは、色付きのどら焼きを作った。", "translation": "Doraemon made colored dorayaki."},
     {"word": "extinct", "meaning": "絶滅した", "example": "ドラえもんは、絶滅した動物に会いにいった。", "translation": "Doraemon went to see an extinct animal."},
     {"word": "preference", "meaning": "好み", "example": "ドラえもんは、どら焼きに対する特別な好みがある。", "translation": "Doraemon has a special preference for dorayaki."}
     ];
     break;
     case "高校英語22":
     item = [
     {"word": "plead", "meaning": "嘆願する", "example": "のび太は、ドラえもんに助けを嘆願した。", "translation": "Nobita pleaded with Doraemon for help."},
     {"word": "acoustic", "meaning": "音響の", "example": "ドラえもんは、音響の良い場所で歌った。", "translation": "Doraemon sang in a place with good acoustics."},
     {"word": "distort", "meaning": "歪める", "example": "ドラえもんは、空間を歪める道具を使った。", "translation": "Doraemon used a gadget that distorted space."},
     {"word": "acute", "meaning": "鋭い", "example": "ドラえもんは、鋭い感覚を持っている。", "translation": "Doraemon has acute senses."},
     {"word": "transmit", "meaning": "伝達する", "example": "ドラえもんは、未来の情報を伝達した。", "translation": "Doraemon transmitted information from the future."},
     {"word": "missing", "meaning": "行方不明の", "example": "ドラえもんは、行方不明の動物を探した。", "translation": "Doraemon looked for a missing animal."},
     {"word": "trait", "meaning": "特徴", "example": "ドラえもんの優れた特徴は、優しさだ。", "translation": "Doraemon's excellent trait is kindness."},
     {"word": "presumably", "meaning": "おそらく", "example": "ドラえもんは、おそらく未来に帰るだろう。", "translation": "Doraemon is presumably going back to the future."},
     {"word": "verse", "meaning": "詩", "example": "ドラえもんは、詩を朗読した。", "translation": "Doraemon recited a verse."},
     {"word": "overly", "meaning": "過度に", "example": "のび太は、いつもドラえもんに過度に頼りすぎている。", "translation": "Nobita is always overly reliant on Doraemon."}
     ];
     break;
     case "高校英語23":
     item = [
     {"word": "vice", "meaning": "悪徳", "example": "ドラえもんは、悪徳を許さない。", "translation": "Doraemon does not condone vice."},
     {"word": "invest", "meaning": "投資する", "example": "ドラえもんは、未来の技術に投資した。", "translation": "Doraemon invested in future technology."},
     {"word": "luxury", "meaning": "贅沢", "example": "ドラえもんは、贅沢な生活には興味がない。", "translation": "Doraemon is not interested in a life of luxury."},
     {"word": "apparent", "meaning": "明白な", "example": "ドラえもんの優しさは、誰の目にも明白だ。", "translation": "Doraemon's kindness is apparent to everyone."},
     {"word": "logic", "meaning": "論理", "example": "ドラえもんは、論理的に問題を解決する。", "translation": "Doraemon solves problems logically."},
     {"word": "distribute", "meaning": "分配する", "example": "ドラえもんは、お菓子をみんなに分配した。", "translation": "Doraemon distributed snacks to everyone."},
     {"word": "thrill", "meaning": "スリル", "example": "ドラえもんは、スリル満点のアトラクションを楽しんだ。", "translation": "Doraemon enjoyed a thrilling attraction."},
     {"word": "orbit", "meaning": "軌道", "example": "ドラえもんは、宇宙で衛星の軌道を調べた。", "translation": "Doraemon studied the orbits of satellites in space."},
     {"word": "aggressive", "meaning": "攻撃的な", "example": "ドラえもんは、攻撃的な態度を避ける。", "translation": "Doraemon avoids aggressive behavior."},
     {"word": "atom", "meaning": "原子", "example": "ドラえもんは、原子レベルの技術を見た。", "translation": "Doraemon saw technology at the atomic level."}
     ];
     break;
     case "高校英語24":
     item = [
     {"word": "perception", "meaning": "知覚", "example": "ドラえもんは、優れた知覚能力を持っている。", "translation": "Doraemon has excellent perception skills."},
     {"word": "exceed", "meaning": "超える", "example": "ドラえもんの能力は、いつも予想を超える。", "translation": "Doraemon's abilities always exceed expectations."},
     {"word": "recognition", "meaning": "認識", "example": "ドラえもんは、顔認識システムを使った。", "translation": "Doraemon used a facial recognition system."},
     {"word": "indicate", "meaning": "示す", "example": "ドラえもんは、地図で場所を示した。", "translation": "Doraemon indicated the location on a map."},
     {"word": "northern", "meaning": "北の", "example": "ドラえもんは、北の寒い場所に行った。", "translation": "Doraemon went to a cold place in the north."},
     {"word": "rotate", "meaning": "回転する", "example": "ドラえもんは、地球が回転するのを観察した。", "translation": "Doraemon observed the Earth rotating."},
     {"word": "stress", "meaning": "ストレス", "example": "ドラえもんは、ストレスを溜めないようにしている。", "translation": "Doraemon tries to avoid stress."},
     {"word": "stumble", "meaning": "つまずく", "example": "のび太は、道でつまずいた。", "translation": "Nobita stumbled on the road."},
     {"word": "transport", "meaning": "輸送する", "example": "ドラえもんは、どこでもドアで色々な場所へ輸送する。", "translation": "Doraemon transports to various locations with the Anywhere Door."},
     {"word": "fellow", "meaning": "仲間", "example": "ドラえもんは、いつも仲間のことを大切にする。", "translation": "Doraemon always cares about his fellows."}
     ];
     break;
     case "高校英語25":
     item = [
     {"word": "description", "meaning": "説明", "example": "ドラえもんは、道具の説明をした。", "translation": "Doraemon gave a description of his gadget."},
     {"word": "authorize", "meaning": "許可する", "example": "ドラえもんは、のび太に道具の使用を許可した。", "translation": "Doraemon authorized Nobita to use the gadget."},
     {"word": "inner", "meaning": "内側の", "example": "ドラえもんは、内側のメカニズムを調べた。", "translation": "Doraemon examined the inner mechanisms."},
     {"word": "combination", "meaning": "組み合わせ", "example": "ドラえもんは、秘密道具を組み合わせて使った。", "translation": "Doraemon used a combination of secret gadgets."},
     {"word": "exploit", "meaning": "利用する", "example": "ドラえもんは、道具の機能を最大限に利用する。", "translation": "Doraemon exploits the functions of his gadgets to the fullest."},
     {"word": "browse", "meaning": "閲覧する", "example": "ドラえもんは、インターネットを閲覧した。", "translation": "Doraemon browsed the internet."},
     {"word": "unclear", "meaning": "不明瞭な", "example": "ドラえもんは、状況が不明瞭であることに気づいた。", "translation": "Doraemon realized that the situation was unclear."},
     {"word": "betray", "meaning": "裏切る", "example": "ドラえもんは、友達を裏切らない。", "translation": "Doraemon never betrays his friends."},
     {"word": "riddle", "meaning": "謎", "example": "ドラえもんは、謎を解き明かした。", "translation": "Doraemon solved the riddle."},
     {"word": "operational", "meaning": "作動可能な", "example": "ドラえもんは、道具を作動可能な状態にした。", "translation": "Doraemon made the gadget operational."}
     ];
     break;
     case "高校英語26":
     item = [
     {"word": "quit", "meaning": "やめる", "example": "ドラえもんは、悪事をやめるように説得した。", "translation": "Doraemon persuaded him to quit doing bad things."},
     {"word": "guideline", "meaning": "指針", "example": "ドラえもんは、未来の生活指針を参考にする。", "translation": "Doraemon refers to future lifestyle guidelines."},
     {"word": "criminal", "meaning": "犯罪者", "example": "ドラえもんは、犯罪者を捕まえた。", "translation": "Doraemon caught the criminal."},
     {"word": "explorer", "meaning": "探検家", "example": "ドラえもんは、未来の探検家と出会った。", "translation": "Doraemon met a future explorer."},
     {"word": "vitality", "meaning": "活力", "example": "ドラえもんは、いつも活力に満ち溢れている。", "translation": "Doraemon is always full of vitality."},
     {"word": "envision", "meaning": "思い描く", "example": "ドラえもんは、未来の街を思い描いた。", "translation": "Doraemon envisioned a city of the future."},
     {"word": "household", "meaning": "家庭の", "example": "ドラえもんは、家庭用品を修理するのが得意だ。", "translation": "Doraemon is good at repairing household items."},
     {"word": "dramatic", "meaning": "劇的な", "example": "ドラえもんは、劇的な変化を体験した。", "translation": "Doraemon experienced a dramatic change."},
     {"word": "evolve", "meaning": "進化する", "example": "ドラえもんは、未来の技術が進化しているのを見た。", "translation": "Doraemon saw how future technology is evolving."},
     {"word": "league", "meaning": "リーグ", "example": "ドラえもんは、未来の野球リーグを見た。", "translation": "Doraemon watched a future baseball league."}
     ];
     break;
     case "高校英語27":
     item = [
     {"word": "pesticide", "meaning": "殺虫剤", "example": "ドラえもんは、殺虫剤を使わないで虫を追い払った。", "translation": "Doraemon chased away the bugs without using pesticide."},
     {"word": "console", "meaning": "慰める", "example": "ドラえもんは、のび太を慰めた。", "translation": "Doraemon consoled Nobita."},
     {"word": "county", "meaning": "郡", "example": "ドラえもんは、未来の郡の様子を見た。", "translation": "Doraemon saw a county in the future."},
     {"word": "fierce", "meaning": "激しい", "example": "ドラえもんは、激しい嵐の中を飛び回った。", "translation": "Doraemon flew around in the middle of a fierce storm."},
     {"word": "scrap", "meaning": "スクラップ", "example": "ドラえもんは、スクラップから道具を修理した。", "translation": "Doraemon repaired his gadgets with scrap metal."},
     {"word": "grind", "meaning": "砕く", "example": "ドラえもんは、石を砕いて粉にした。", "translation": "Doraemon ground the stones into powder."},
     {"word": "distinguished", "meaning": "著名な", "example": "ドラえもんは、著名な科学者と会って話をした。", "translation": "Doraemon met and talked with a distinguished scientist."},
     {"word": "consent", "meaning": "同意", "example": "ドラえもんは、のび太の同意を得てから行動する。", "translation": "Doraemon acts after getting Nobita's consent."},
     {"word": "clip", "meaning": "クリップ", "example": "ドラえもんは、クリップを使って資料をまとめた。", "translation": "Doraemon used a clip to organize his materials."},
     {"word": "escalate", "meaning": "エスカレートする", "example": "ドラえもんは、事態がエスカレートしないように気をつけた。", "translation": "Doraemon was careful that the situation would not escalate."},
     {"word": "hospitality", "meaning": "歓待", "example": "ドラえもんは、未来の人々から歓待を受けた。", "translation": "Doraemon received hospitality from the people of the future."}
     ];
     break;
     case "高校英語28":
     item = [
     {"word": "legal", "meaning": "合法的な", "example": "ドラえもんは、合法的な方法で問題を解決する。", "translation": "Doraemon solves problems in a legal way."},
     {"word": "evidence", "meaning": "証拠", "example": "ドラえもんは、事件の証拠を集めた。", "translation": "Doraemon collected evidence of the incident."},
     {"word": "specialize", "meaning": "専門にする", "example": "ドラえもんは、道具の修理を専門にしている。", "translation": "Doraemon specializes in repairing gadgets."},
     {"word": "improper", "meaning": "不適切な", "example": "ドラえもんは、不適切な行動をしない。", "translation": "Doraemon does not do improper things."},
     {"word": "certify", "meaning": "証明する", "example": "ドラえもんは、未来の資格を証明した。", "translation": "Doraemon certified his qualifications from the future."},
     {"word": "replicate", "meaning": "複製する", "example": "ドラえもんは、道具を複製してみた。", "translation": "Doraemon tried to replicate a gadget."},
     {"word": "endorse", "meaning": "支持する", "example": "ドラえもんは、のび太の意見を支持した。", "translation": "Doraemon endorsed Nobita's opinion."},
     {"word": "fasten", "meaning": "固定する", "example": "ドラえもんは、ベルトをしっかり固定した。", "translation": "Doraemon fastened his belt securely."},
     {"word": "calculate", "meaning": "計算する", "example": "ドラえもんは、時間を計算した。", "translation": "Doraemon calculated the time."},
     {"word": "assign", "meaning": "割り当てる", "example": "ドラえもんは、それぞれに役割を割り当てた。", "translation": "Doraemon assigned roles to each person."}
     ];
     break;
     case "高校英語29":
     item = [
     {"word": "muscle", "meaning": "筋肉", "example": "ドラえもんは、筋肉を鍛えている。", "translation": "Doraemon is training his muscles."},
     {"word": "statement", "meaning": "声明", "example": "ドラえもんは、事件に関する声明を発表した。", "translation": "Doraemon released a statement regarding the incident."},
     {"word": "dinosaur", "meaning": "恐竜", "example": "ドラえもんは、タイムマシンで恐竜時代に行った。", "translation": "Doraemon went to the dinosaur era using the time machine."},
     {"word": "affair", "meaning": "出来事", "example": "ドラえもんは、奇妙な出来事に巻き込まれた。", "translation": "Doraemon got involved in a strange affair."},
     {"word": "connection", "meaning": "つながり", "example": "ドラえもんは、友達とのつながりを大切にしている。", "translation": "Doraemon values the connection with his friends."},
     {"word": "cave", "meaning": "洞窟", "example": "ドラえもんは、洞窟の中を探検した。", "translation": "Doraemon explored inside the cave."},
     {"word": "consensus", "meaning": "合意", "example": "ドラえもんは、みんなの合意を得ようとした。", "translation": "Doraemon tried to get a consensus from everyone."},
     {"word": "numerous", "meaning": "たくさんの", "example": "ドラえもんは、たくさんの秘密道具を持っている。", "translation": "Doraemon has numerous secret gadgets."},
     {"word": "sweep", "meaning": "掃く", "example": "ドラえもんは、ほうきで床を掃いた。", "translation": "Doraemon swept the floor with a broom."},
     {"word": "sue", "meaning": "訴える", "example": "ドラえもんは、悪い人を訴える。", "translation": "Doraemon sues bad people."}
     ];
     break;
     case "高校英語30":
     item = [
     {"word": "means", "meaning": "手段", "example": "ドラえもんは、色々な手段を使って問題を解決する。", "translation": "Doraemon uses various means to solve problems."},
     {"word": "overwhelm", "meaning": "圧倒する", "example": "ドラえもんは、敵を圧倒する力を持っている。", "translation": "Doraemon has the power to overwhelm his enemies."},
     {"word": "veterinarian", "meaning": "獣医", "example": "ドラえもんは、動物の医者である獣医に話を聞いた。", "translation": "Doraemon listened to a veterinarian, an animal doctor."},
     {"word": "disrupt", "meaning": "妨害する", "example": "ドラえもんは、悪い計画を妨害した。", "translation": "Doraemon disrupted the evil plan."},
     {"word": "participant", "meaning": "参加者", "example": "ドラえもんは、みんなでイベントに参加した。", "translation": "Doraemon participated in the event with everyone."},
     {"word": "pilgrim", "meaning": "巡礼者", "example": "ドラえもんは、巡礼者のように旅をした。", "translation": "Doraemon traveled like a pilgrim."},
     {"word": "terrorist", "meaning": "テロリスト", "example": "ドラえもんは、テロリストを阻止した。", "translation": "Doraemon stopped the terrorist."},
     {"word": "inferior", "meaning": "劣った", "example": "ドラえもんは、劣った道具でも使いこなす。", "translation": "Doraemon can handle even inferior gadgets."},
     {"word": "flock", "meaning": "群れ", "example": "ドラえもんは、鳥の群れを見た。", "translation": "Doraemon saw a flock of birds."},
     {"word": "noticeable", "meaning": "目立つ", "example": "ドラえもんは、青い体がとても目立つ。", "translation": "Doraemon's blue body is very noticeable."}
     ];
     break;
    
     
     case "高校英語31":
     item = [
     {"word": "cheaply", "meaning": "安く", "example": "ドラえもんは、未来の道具を安く手に入れた。", "translation": "Doraemon obtained a future gadget cheaply."},
     {"word": "psychologist", "meaning": "心理学者", "example": "ドラえもんは、心理学者にのび太の心の悩みを相談した。", "translation": "Doraemon consulted with a psychologist about Nobita's mental problems."},
     {"word": "eagerly", "meaning": "熱心に", "example": "のび太は、ドラえもんの道具を熱心に使おうとする。", "translation": "Nobita is eager to use Doraemon's gadgets."},
     {"word": "historical", "meaning": "歴史的な", "example": "ドラえもんは、歴史的な出来事を体験した。", "translation": "Doraemon experienced a historical event."},
     {"word": "sacrifice", "meaning": "犠牲", "example": "ドラえもんは、みんなのために自己犠牲を払った。", "translation": "Doraemon made a self-sacrifice for everyone."},
     {"word": "monitor", "meaning": "監視する", "example": "ドラえもんは、のび太をいつも監視している。", "translation": "Doraemon is always monitoring Nobita."},
     {"word": "tension", "meaning": "緊張", "example": "ドラえもんは、緊張した場面でも冷静さを保つ。", "translation": "Doraemon maintains his composure even in tense situations."},
     {"word": "unlucky", "meaning": "不運な", "example": "のび太は、いつも不運な目に遭う。", "translation": "Nobita is always meeting with unlucky situations."},
     {"word": "transform", "meaning": "変身させる", "example": "ドラえもんは、秘密道具で自分を変身させた。", "translation": "Doraemon transformed himself with a secret gadget."},
     {"word": "commit", "meaning": "犯す", "example": "ドラえもんは、絶対に悪いことは犯さない。", "translation": "Doraemon never commits any bad deeds."}
     ];
     break;
     case "高校英語32":
     item = [
     {"word": "tornado", "meaning": "竜巻", "example": "ドラえもんは、竜巻に巻き込まれそうになった。", "translation": "Doraemon was almost caught in a tornado."},
     {"word": "motion", "meaning": "動き", "example": "ドラえもんは、ロボットの動きを観察した。", "translation": "Doraemon observed the motion of the robot."},
     {"word": "bureau", "meaning": "局", "example": "ドラえもんは、未来の管理局で手続きをした。", "translation": "Doraemon went through procedures at a future bureau."},
     {"word": "obey", "meaning": "従う", "example": "ドラえもんは、ルールに従う。", "translation": "Doraemon obeys the rules."},
     {"word": "relief", "meaning": "安心", "example": "ドラえもんは、無事解決し安心した。", "translation": "Doraemon was relieved when everything was resolved safely."},
     {"word": "bacteria", "meaning": "細菌", "example": "ドラえもんは、細菌の勉強をした。", "translation": "Doraemon studied bacteria."},
     {"word": "heal", "meaning": "癒す", "example": "ドラえもんは、傷を癒す道具を使った。", "translation": "Doraemon used a gadget that heals wounds."},
     {"word": "ecosystem", "meaning": "生態系", "example": "ドラえもんは、自然の生態系を守る大切さを知っている。", "translation": "Doraemon knows the importance of protecting natural ecosystems."},
     {"word": "compromise", "meaning": "妥協する", "example": "ドラえもんは、お互いに妥協することにした。", "translation": "Doraemon decided to compromise with each other."},
     {"word": "refugee", "meaning": "難民", "example": "ドラえもんは、難民を助けるために行動した。", "translation": "Doraemon took action to help refugees."}
     ];
     break;
     case "高校英語33":
     item = [
     {"word": "drawing", "meaning": "絵", "example": "ドラえもんは、絵を描くのが好きだ。", "translation": "Doraemon likes drawing pictures."},
     {"word": "suspect", "meaning": "容疑者", "example": "ドラえもんは、犯人を容疑者だと疑った。", "translation": "Doraemon suspected the criminal to be the suspect."},
     {"word": "oppose", "meaning": "反対する", "example": "ドラえもんは、悪事に反対する。", "translation": "Doraemon opposes evil deeds."},
     {"word": "principle", "meaning": "原理", "example": "ドラえもんは、科学の原理を理解している。", "translation": "Doraemon understands the principles of science."},
     {"word": "importantly", "meaning": "重要なことには", "example": "重要なことには、ドラえもんはいつも真剣に取り組む。", "translation": "Importantly, Doraemon always approaches serious matters with sincerity."},
     {"word": "remote", "meaning": "遠隔の", "example": "ドラえもんは、遠隔操作で道具を使った。", "translation": "Doraemon used a gadget with remote control."},
     {"word": "trash", "meaning": "ゴミ", "example": "ドラえもんは、ゴミをきちんと分別して捨てた。", "translation": "Doraemon properly sorted and threw away the trash."},
     {"word": "predict", "meaning": "予測する", "example": "ドラえもんは、未来を予測する道具を持っている。", "translation": "Doraemon has a gadget that can predict the future."},
     {"word": "desire", "meaning": "欲望", "example": "ドラえもんは、欲望に負けないようにした。", "translation": "Doraemon tried not to give in to his desires."},
     {"word": "supply", "meaning": "供給", "example": "ドラえもんは、道具を供給した。", "translation": "Doraemon supplied the gadgets."}
     ];
     break;
     case "高校英語34":
     item = [
     {"word": "collapse", "meaning": "崩壊する", "example": "ドラえもんは、古い建物が崩壊するのを見た。", "translation": "Doraemon saw an old building collapse."},
     {"word": "embarrass", "meaning": "恥ずかしい思いをさせる", "example": "ドラえもんは、のび太を恥ずかしい思いをさせないようにした。", "translation": "Doraemon tried not to embarrass Nobita."},
     {"word": "outback", "meaning": "奥地", "example": "ドラえもんは、オーストラリアの奥地を探検した。", "translation": "Doraemon explored the outback of Australia."},
     {"word": "particle", "meaning": "粒子", "example": "ドラえもんは、小さな粒子の動きを観察した。", "translation": "Doraemon observed the movement of tiny particles."},
     {"word": "folder", "meaning": "フォルダー", "example": "ドラえもんは、ファイルをフォルダーに整理した。", "translation": "Doraemon organized the files into folders."},
     {"word": "laboratory", "meaning": "研究所", "example": "ドラえもんは、未来の研究所を訪問した。", "translation": "Doraemon visited a laboratory in the future."},
     {"word": "depart", "meaning": "出発する", "example": "ドラえもんは、未来へ出発した。", "translation": "Doraemon departed for the future."},
     {"word": "commercial", "meaning": "商業的な", "example": "ドラえもんは、商業的なイベントに参加した。", "translation": "Doraemon participated in a commercial event."},
     {"word": "agriculture", "meaning": "農業", "example": "ドラえもんは、未来の農業技術を学んだ。", "translation": "Doraemon learned about future agricultural technology."},
     {"word": "childhood", "meaning": "子供時代", "example": "ドラえもんは、のび太の子供時代を大切に思っている。", "translation": "Doraemon values Nobita's childhood."}
     ];
     break;
     case "高校英語35":
     item = [
     {"word": "efficient", "meaning": "効率的な", "example": "ドラえもんは、いつも効率的な道具を使う。", "translation": "Doraemon always uses efficient gadgets."},
     {"word": "philosophy", "meaning": "哲学", "example": "ドラえもんは、自分の哲学を持っている。", "translation": "Doraemon has his own philosophy."},
     {"word": "grant", "meaning": "許可する", "example": "ドラえもんは、のび太に特別な道具を使うことを許可した。", "translation": "Doraemon granted Nobita permission to use a special gadget."},
     {"word": "bilingual", "meaning": "二か国語を話せる", "example": "ドラえもんは、色々な言語を話せる。", "translation": "Doraemon is bilingual, able to speak many languages."},
     {"word": "expense", "meaning": "費用", "example": "ドラえもんは、道具の費用を心配した。", "translation": "Doraemon worried about the expense of the gadgets."},
     {"word": "install", "meaning": "設置する", "example": "ドラえもんは、新しい道具を設置した。", "translation": "Doraemon installed a new gadget."},
     {"word": "occasionally", "meaning": "時々", "example": "ドラえもんは、時々過去にタイムスリップする。", "translation": "Doraemon occasionally time slips to the past."},
     {"word": "advertisement", "meaning": "広告", "example": "ドラえもんは、未来の道具の広告を見た。", "translation": "Doraemon saw an advertisement for a future gadget."},
     {"word": "abandon", "meaning": "見捨てる", "example": "ドラえもんは、決して友達を見捨てない。", "translation": "Doraemon never abandons his friends."},
     {"word": "extraordinary", "meaning": "並外れた", "example": "ドラえもんは、並外れた能力を持っている。", "translation": "Doraemon has extraordinary abilities."}
     ];
     break;
     case "高校英語36":
     item = [
     {"word": "yell", "meaning": "叫ぶ", "example": "ジャイアンは、いつも大声で叫んでいる。", "translation": "Gian is always yelling loudly."},
     {"word": "cure", "meaning": "治療する", "example": "ドラえもんは、病気を治療する薬を持っていた。", "translation": "Doraemon had medicine to cure diseases."},
     {"word": "fancy", "meaning": "高級な", "example": "ドラえもんは、高級なレストランで食事をした。", "translation": "Doraemon had a meal at a fancy restaurant."},
     {"word": "property", "meaning": "財産", "example": "ドラえもんは、大切な財産を失くした。", "translation": "Doraemon lost his valuable property."},
     {"word": "grill", "meaning": "焼く", "example": "ドラえもんは、肉を焼いてみんなで食べた。", "translation": "Doraemon grilled meat and everyone ate it together."},
     {"word": "moreover", "meaning": "さらに", "example": "ドラえもんは、さらに新しい道具を使った。", "translation": "Moreover, Doraemon used a new gadget."},
     {"word": "carve", "meaning": "彫る", "example": "ドラえもんは、木に名前を彫った。", "translation": "Doraemon carved his name on the tree."},
     {"word": "flour", "meaning": "小麦粉", "example": "ドラえもんは、小麦粉を使ってお菓子を作った。", "translation": "Doraemon made snacks using flour."},
     {"word": "enormous", "meaning": "巨大な", "example": "ドラえもんは、巨大な敵と戦った。", "translation": "Doraemon fought a huge enemy."},
     {"word": "insurance", "meaning": "保険", "example": "ドラえもんは、未来の保険について説明した。", "translation": "Doraemon explained about future insurance."}
     ];
     break;
     case "高校英語37":
     item = [
     {"word": "scramble", "meaning": "我先にと進む", "example": "ドラえもんは、我先にと道具を取ろうとした。", "translation": "Doraemon scrambled to get the gadgets first."},
     {"word": "observation", "meaning": "観察", "example": "ドラえもんは、星を観察するのが好きだ。", "translation": "Doraemon likes to observe the stars."},
     {"word": "cater", "meaning": "応じる", "example": "ドラえもんは、のび太の要望に応じた。", "translation": "Doraemon catered to Nobita's requests."},
     {"word": "particularly", "meaning": "特に", "example": "ドラえもんは、特にどら焼きが好きだ。", "translation": "Doraemon particularly likes dorayaki."},
     {"word": "cease", "meaning": "やめる", "example": "ドラえもんは、戦争をやめさせようとした。", "translation": "Doraemon tried to cease the war."},
     {"word": "vanish", "meaning": "消える", "example": "ドラえもんは、どこでもドアで姿を消した。", "translation": "Doraemon vanished with the Anywhere Door."},
     {"word": "overturn", "meaning": "覆す", "example": "ドラえもんは、悪者の計画を覆した。", "translation": "Doraemon overturned the villain's plan."},
     {"word": "conquer", "meaning": "征服する", "example": "ドラえもんは、困難を征服した。", "translation": "Doraemon conquered the difficulties."},
     {"word": "negotiate", "meaning": "交渉する", "example": "ドラえもんは、敵と交渉しようとした。", "translation": "Doraemon tried to negotiate with the enemy."},
     {"word": "economical", "meaning": "経済的な", "example": "ドラえもんは、経済的な方法で問題を解決した。", "translation": "Doraemon solved the problem in an economical way."}
     ];
     break;
     case "高校英語38":
     item = [
     {"word": "split", "meaning": "分割する", "example": "ドラえもんは、どら焼きを半分に分割した。", "translation": "Doraemon split the dorayaki in half."},
     {"word": "delicate", "meaning": "繊細な", "example": "ドラえもんは、繊細な作業をするのが得意だ。", "translation": "Doraemon is good at doing delicate work."},
     {"word": "session", "meaning": "集まり", "example": "ドラえもんは、友達との勉強会に参加した。", "translation": "Doraemon participated in a study session with his friends."},
     {"word": "careless", "meaning": "不注意な", "example": "のび太は、不注意で物を壊してしまう。", "translation": "Nobita carelessly breaks things."},
     {"word": "invention", "meaning": "発明", "example": "ドラえもんは、未来の発明品を見せてくれた。", "translation": "Doraemon showed me inventions from the future."},
     {"word": "consume", "meaning": "消費する", "example": "ドラえもんは、エネルギーを消費すると充電する。", "translation": "Doraemon recharges when he consumes energy."},
     {"word": "spicy", "meaning": "辛い", "example": "ドラえもんは、辛い食べ物が少し苦手だ。", "translation": "Doraemon is not very good with spicy food."},
     {"word": "plug", "meaning": "栓", "example": "ドラえもんは、プラグをコンセントに差し込んだ。", "translation": "Doraemon plugged the plug into the outlet."},
     {"word": "regional", "meaning": "地方の", "example": "ドラえもんは、地方のお祭りに参加した。", "translation": "Doraemon participated in a regional festival."},
     {"word": "wound", "meaning": "傷", "example": "ドラえもんは、傷の手当てをしてくれた。", "translation": "Doraemon treated the wound."}
     ];
     break;
     case "高校英語39":
     item = [
     {"word": "debt", "meaning": "借金", "example": "ドラえもんは、のび太の借金を肩代わりした。", "translation": "Doraemon took on Nobita's debt."},
     {"word": "urge", "meaning": "促す", "example": "ドラえもんは、のび太に勉強するように促した。", "translation": "Doraemon urged Nobita to study."},
     {"word": "unhealthy", "meaning": "不健康な", "example": "ドラえもんは、不健康な生活を送らないように気を付けている。", "translation": "Doraemon is careful not to live an unhealthy life."},
     {"word": "advanced", "meaning": "進んだ", "example": "ドラえもんは、進んだ技術を持っている。", "translation": "Doraemon has advanced technology."},
     {"word": "absorb", "meaning": "吸収する", "example": "ドラえもんは、知識を吸収するのが好きだ。", "translation": "Doraemon likes to absorb knowledge."},
     {"word": "urban", "meaning": "都会の", "example": "ドラえもんは、都会の街並みを散歩した。", "translation": "Doraemon walked around the urban cityscape."},
     {"word": "chemistry", "meaning": "化学", "example": "ドラえもんは、化学の実験をした。", "translation": "Doraemon did a chemistry experiment."},
     {"word": "minority", "meaning": "少数派", "example": "ドラえもんは、少数派の人々の意見を尊重する。", "translation": "Doraemon respects the opinions of minority groups."},
     {"word": "blank", "meaning": "空白", "example": "ドラえもんは、空白のページに絵を描いた。", "translation": "Doraemon drew a picture on a blank page."},
     {"word": "orchestra", "meaning": "オーケストラ", "example": "ドラえもんは、オーケストラの演奏を聴きに行った。", "translation": "Doraemon went to listen to an orchestra."}
     ];
     break;
     case "高校英語40":
     item = [
     {"word": "unlike", "meaning": "～と違って", "example": "ドラえもんは、のび太と違って勉強が好きだ。", "translation": "Unlike Nobita, Doraemon likes to study."},
     {"word": "uncover", "meaning": "暴く", "example": "ドラえもんは、事件の真相を暴いた。", "translation": "Doraemon uncovered the truth of the incident."},
     {"word": "suggestion", "meaning": "提案", "example": "ドラえもんは、のび太に良い提案をした。", "translation": "Doraemon made a good suggestion to Nobita."},
     {"word": "exclusive", "meaning": "独占的な", "example": "ドラえもんは、独占的な道具は使わないようにしている。", "translation": "Doraemon is careful not to use exclusive gadgets."},
     {"word": "largely", "meaning": "大部分は", "example": "ドラえもんは、その問題の大部分を解決した。", "translation": "Doraemon solved largely most of that problem."},
     {"word": "outsider", "meaning": "部外者", "example": "ドラえもんは、部外者の意見も尊重する。", "translation": "Doraemon respects the opinions of outsiders too."},
     {"word": "alert", "meaning": "警戒する", "example": "ドラえもんは、危険に警戒するように言った。", "translation": "Doraemon said to be alert to danger."},
     {"word": "psychology", "meaning": "心理学", "example": "ドラえもんは、心理学について少し学んだ。", "translation": "Doraemon learned a little about psychology."},
     {"word": "reluctant", "meaning": "気が進まない", "example": "のび太は、勉強をするのは気が進まない。", "translation": "Nobita is reluctant to study."},
     {"word": "weapon", "meaning": "武器", "example": "ドラえもんは、武器を使いたくないと考えている。", "translation": "Doraemon doesn't want to use weapons."}
     ];
     break;
    
     
     case "高校英語41":
     item = [
     {"word": "accord", "meaning": "一致する", "example": "ドラえもんは、ルールに一致した行動をとる。", "translation": "Doraemon acts in accord with the rules."},
     {"word": "scan", "meaning": "スキャンする", "example": "ドラえもんは、未来の道具で物体をスキャンした。", "translation": "Doraemon scanned an object with a future gadget."},
     {"word": "convert", "meaning": "変換する", "example": "ドラえもんは、エネルギーを変換する道具を使った。", "translation": "Doraemon used a gadget to convert energy."},
     {"word": "smash", "meaning": "粉砕する", "example": "ジャイアンは、物を粉砕する力がある。", "translation": "Gian has the power to smash things."},
     {"word": "finance", "meaning": "財政", "example": "ドラえもんは、未来の財政状況について知っている。", "translation": "Doraemon knows about future finances."},
     {"word": "deprive", "meaning": "奪う", "example": "ドラえもんは、誰かの物を奪うことを許さない。", "translation": "Doraemon does not allow anyone to deprive others of their belongings."},
     {"word": "postpone", "meaning": "延期する", "example": "ドラえもんは、のび太との約束を延期した。", "translation": "Doraemon postponed his appointment with Nobita."},
     {"word": "entrepreneur", "meaning": "起業家", "example": "ドラえもんは、未来の起業家と出会った。", "translation": "Doraemon met a future entrepreneur."},
     {"word": "assault", "meaning": "襲撃", "example": "ドラえもんは、突然の襲撃に遭った。", "translation": "Doraemon was caught in a sudden assault."},
     {"word": "concept", "meaning": "概念", "example": "ドラえもんは、時間という概念を説明した。", "translation": "Doraemon explained the concept of time."}
     ];
     break;
     case "高校英語42":
     item = [
     {"word": "explanation", "meaning": "説明", "example": "ドラえもんは、道具の使い方を説明した。", "translation": "Doraemon gave an explanation of how to use the gadget."},
     {"word": "audio", "meaning": "音声", "example": "ドラえもんは、音声記録を聞いた。", "translation": "Doraemon listened to an audio recording."},
     {"word": "extra", "meaning": "余分な", "example": "ドラえもんは、余分な道具を持っていた。", "translation": "Doraemon had an extra gadget with him."},
     {"word": "contact", "meaning": "接触", "example": "ドラえもんは、未来人と接触した。", "translation": "Doraemon made contact with a person from the future."},
     {"word": "proportion", "meaning": "割合", "example": "ドラえもんは、割合を計算した。", "translation": "Doraemon calculated the proportion."},
     {"word": "persuade", "meaning": "説得する", "example": "ドラえもんは、のび太を説得した。", "translation": "Doraemon persuaded Nobita."},
     {"word": "eliminate", "meaning": "排除する", "example": "ドラえもんは、悪いものを排除しようとする。", "translation": "Doraemon tries to eliminate bad things."},
     {"word": "definitely", "meaning": "間違いなく", "example": "ドラえもんは、間違いなく優しい。", "translation": "Doraemon is definitely kind."},
     {"word": "surgery", "meaning": "手術", "example": "ドラえもんは、未来の技術で手術を受けた。", "translation": "Doraemon had surgery using future technology."},
     {"word": "emerge", "meaning": "現れる", "example": "ドラえもんは、突然姿を現した。", "translation": "Doraemon suddenly emerged."}
     ];
     break;
     case "高校英語43":
     item = [
     {"word": "offend", "meaning": "気分を害する", "example": "ドラえもんは、誰かの気分を害するようなことはしない。", "translation": "Doraemon does not do anything to offend anyone."},
     {"word": "mental", "meaning": "精神的な", "example": "ドラえもんは、のび太の精神的なサポートをする。", "translation": "Doraemon provides mental support to Nobita."},
     {"word": "parking", "meaning": "駐車", "example": "ドラえもんは、車の駐車スペースを探した。", "translation": "Doraemon looked for a parking space for the car."},
     {"word": "vehicle", "meaning": "乗り物", "example": "ドラえもんは、未来の乗り物に乗ってみた。", "translation": "Doraemon tried riding a vehicle from the future."},
     {"word": "mayor", "meaning": "市長", "example": "ドラえもんは、街の市長と話をした。", "translation": "Doraemon spoke with the mayor of the town."},
     {"word": "define", "meaning": "定義する", "example": "ドラえもんは、正義を定義しようとした。", "translation": "Doraemon tried to define justice."},
     {"word": "nowadays", "meaning": "最近では", "example": "最近では、ドラえもんのようなロボットは珍しい。", "translation": "Nowadays, robots like Doraemon are rare."},
     {"word": "response", "meaning": "反応", "example": "ドラえもんは、のび太の反応を見て笑った。", "translation": "Doraemon laughed at Nobita's response."},
     {"word": "mushroom", "meaning": "キノコ", "example": "ドラえもんは、森でキノコを採った。", "translation": "Doraemon gathered mushrooms in the forest."},
     {"word": "frighten", "meaning": "怖がらせる", "example": "ドラえもんは、のび太を怖がらせることはしない。", "translation": "Doraemon does not do anything to frighten Nobita."}
     ];
     break;
     case "高校英語44":
     item = [
     {"word": "corporation", "meaning": "企業", "example": "ドラえもんは、未来の大企業を訪問した。", "translation": "Doraemon visited a large corporation in the future."},
     {"word": "code", "meaning": "コード", "example": "ドラえもんは、プログラミングのコードを書いた。", "translation": "Doraemon wrote programming code."},
     {"word": "radical", "meaning": "根本的な", "example": "ドラえもんは、根本的な解決策を見つけようとする。", "translation": "Doraemon tries to find a radical solution."},
     {"word": "chairman", "meaning": "会長", "example": "ドラえもんは、会社の会長と会談した。", "translation": "Doraemon had a meeting with the chairman of the company."},
     {"word": "string", "meaning": "紐", "example": "ドラえもんは、紐を使って物を結んだ。", "translation": "Doraemon tied things with a string."},
     {"word": "troublesome", "meaning": "面倒な", "example": "ドラえもんは、面倒な問題を解決した。", "translation": "Doraemon solved a troublesome problem."},
     {"word": "retailer", "meaning": "小売業者", "example": "ドラえもんは、小売業者と取引をした。", "translation": "Doraemon did business with a retailer."},
     {"word": "unit", "meaning": "単位", "example": "ドラえもんは、単位を間違えないように気を付けた。", "translation": "Doraemon was careful not to make mistakes with units."},
     {"word": "moisture", "meaning": "湿気", "example": "ドラえもんは、湿気の多い場所を避けた。", "translation": "Doraemon avoided places with high moisture."},
     {"word": "developer", "meaning": "開発者", "example": "ドラえもんは、未来の道具の開発者と話をした。", "translation": "Doraemon spoke with the developer of a future gadget."}
     ];
     break;
     case "高校英語45":
     item = [
     {"word": "deposit", "meaning": "預ける", "example": "ドラえもんは、銀行にお金を預けた。", "translation": "Doraemon deposited money at the bank."},
     {"word": "entertainment", "meaning": "娯楽", "example": "ドラえもんは、未来の娯楽を楽しんだ。", "translation": "Doraemon enjoyed future entertainment."},
     {"word": "shorten", "meaning": "短くする", "example": "ドラえもんは、時間を短くする道具を使った。", "translation": "Doraemon used a gadget that shortened time."},
     {"word": "awareness", "meaning": "意識", "example": "ドラえもんは、環境保護の意識を高めた。", "translation": "Doraemon raised awareness for environmental protection."},
     {"word": "endure", "meaning": "耐える", "example": "ドラえもんは、どんな困難にも耐える。", "translation": "Doraemon endures any hardship."},
     {"word": "aluminum", "meaning": "アルミニウム", "example": "ドラえもんは、アルミニウム製の道具を使った。", "translation": "Doraemon used a gadget made of aluminum."},
     {"word": "stressed", "meaning": "ストレスを感じた", "example": "ドラえもんは、少しストレスを感じている。", "translation": "Doraemon is feeling a bit stressed."},
     {"word": "necessity", "meaning": "必要性", "example": "ドラえもんは、道具の必要性を説明した。", "translation": "Doraemon explained the necessity of the gadget."},
     {"word": "opponent", "meaning": "対戦相手", "example": "ドラえもんは、強い対戦相手と戦った。", "translation": "Doraemon fought a strong opponent."},
     {"word": "fiber", "meaning": "繊維", "example": "ドラえもんは、繊維でできた服を着ている。", "translation": "Doraemon is wearing clothes made of fiber."}
     ];
     break;
     case "高校英語46":
     item = [
     {"word": "secondhand", "meaning": "中古の", "example": "ドラえもんは、中古の道具を見つけた。", "translation": "Doraemon found a secondhand gadget."},
     {"word": "administration", "meaning": "行政", "example": "ドラえもんは、未来の行政システムを調べた。", "translation": "Doraemon researched the administrative systems of the future."},
     {"word": "political", "meaning": "政治的な", "example": "ドラえもんは、政治的な問題について議論した。", "translation": "Doraemon discussed political issues."},
     {"word": "retain", "meaning": "保持する", "example": "ドラえもんは、記憶を保持する。", "translation": "Doraemon retains his memories."},
     {"word": "enforce", "meaning": "執行する", "example": "ドラえもんは、法律を執行する。", "translation": "Doraemon enforces the laws."},
     {"word": "acid", "meaning": "酸", "example": "ドラえもんは、酸性の液体を避けた。", "translation": "Doraemon avoided acidic liquids."},
     {"word": "poll", "meaning": "投票", "example": "ドラえもんは、意見を問うために投票を行った。", "translation": "Doraemon conducted a poll to ask for opinions."},
     {"word": "accept", "meaning": "受け入れる", "example": "ドラえもんは、現実を受け入れた。", "translation": "Doraemon accepted reality."},
     {"word": "beg", "meaning": "懇願する", "example": "のび太は、ドラえもんに助けを懇願した。", "translation": "Nobita begged Doraemon for help."},
     {"word": "quote", "meaning": "引用する", "example": "ドラえもんは、本の一節を引用した。", "translation": "Doraemon quoted a passage from a book."}
     ];
     break;
     case "高校英語47":
     item = [
     {"word": "nearby", "meaning": "近くに", "example": "ドラえもんは、近くの公園へ遊びに行った。", "translation": "Doraemon went to play in a nearby park."},
     {"word": "employee", "meaning": "従業員", "example": "ドラえもんは、未来の企業の従業員と話した。", "translation": "Doraemon spoke with an employee from a future company."},
     {"word": "survey", "meaning": "調査", "example": "ドラえもんは、街の人々にアンケート調査をした。", "translation": "Doraemon conducted a survey among the people in town."},
     {"word": "senior", "meaning": "年上の", "example": "ドラえもんは、年上の人にも礼儀正しい。", "translation": "Doraemon is polite to older people too."},
     {"word": "whenever", "meaning": "～するときはいつでも", "example": "ドラえもんは、のび太が困ったときはいつでも助けに来る。", "translation": "Doraemon comes to help whenever Nobita is in trouble."},
     {"word": "automatically", "meaning": "自動的に", "example": "ドラえもんは、自動的にドアを開けた。", "translation": "Doraemon automatically opened the door."},
     {"word": "enthusiastic", "meaning": "熱狂的な", "example": "ドラえもんは、新しい道具に熱狂している。", "translation": "Doraemon is enthusiastic about his new gadgets."},
     {"word": "massive", "meaning": "巨大な", "example": "ドラえもんは、巨大な敵と戦った。", "translation": "Doraemon fought a massive enemy."},
     {"word": "bounce", "meaning": "跳ねる", "example": "ドラえもんは、ボールを跳ねさせて遊んだ。", "translation": "Doraemon played by bouncing the ball."},
     {"word": "cop", "meaning": "警官", "example": "ドラえもんは、警察官に道を聞いた。", "translation": "Doraemon asked a police cop for directions."}
     ];
     break;
     case "高校英語48":
     item = [
     {"word": "landmark", "meaning": "名所", "example": "ドラえもんは、町の有名な名所を訪れた。", "translation": "Doraemon visited a famous landmark in town."},
     {"word": "enhance", "meaning": "高める", "example": "ドラえもんは、道具を使って能力を高める。", "translation": "Doraemon enhances his abilities by using gadgets."},
     {"word": "pottery", "meaning": "陶器", "example": "ドラえもんは、陶器を作るのが好きだ。", "translation": "Doraemon likes making pottery."},
     {"word": "admiration", "meaning": "感嘆", "example": "ドラえもんは、のび太の勇気に感嘆した。", "translation": "Doraemon was filled with admiration for Nobita's courage."},
     {"word": "totally", "meaning": "完全に", "example": "ドラえもんは、完全に疲れ切ってしまった。", "translation": "Doraemon was totally exhausted."},
     {"word": "coincidence", "meaning": "偶然", "example": "ドラえもんは、偶然友達に会った。", "translation": "Doraemon met his friend by coincidence."},
     {"word": "sophisticated", "meaning": "洗練された", "example": "ドラえもんは、洗練された未来の技術に驚いた。", "translation": "Doraemon was surprised by the sophisticated technology of the future."},
     {"word": "endanger", "meaning": "危険にさらす", "example": "ドラえもんは、のび太を危険にさらさないように注意している。", "translation": "Doraemon is careful not to endanger Nobita."},
     {"word": "knowledgeable", "meaning": "知識のある", "example": "ドラえもんは、様々なことに知識がある。", "translation": "Doraemon is knowledgeable about various things."},
     {"word": "involve", "meaning": "巻き込む", "example": "ドラえもんは、のび太を事件に巻き込んだ。", "translation": "Doraemon involved Nobita in the incident."}
     ];
     break;
     case "高校英語49":
     item = [
     {"word": "license", "meaning": "免許", "example": "ドラえもんは、未来の免許を持っている。", "translation": "Doraemon has a license from the future."},
     {"word": "currently", "meaning": "現在", "example": "ドラえもんは、現在、のび太と一緒にいる。", "translation": "Doraemon is currently with Nobita."},
     {"word": "chase", "meaning": "追いかける", "example": "ドラえもんは、泥棒を追いかけた。", "translation": "Doraemon chased after the thief."},
     {"word": "additional", "meaning": "追加の", "example": "ドラえもんは、追加の道具を取り出した。", "translation": "Doraemon took out an additional gadget."},
     {"word": "theme", "meaning": "テーマ", "example": "ドラえもんは、映画のテーマ曲を聴いた。", "translation": "Doraemon listened to the theme song of a movie."},
     {"word": "theory", "meaning": "理論", "example": "ドラえもんは、新しい理論を学んだ。", "translation": "Doraemon learned a new theory."},
     {"word": "security", "meaning": "警備", "example": "ドラえもんは、警備システムの穴を見つけた。", "translation": "Doraemon found a flaw in the security system."},
     {"word": "somehow", "meaning": "どういうわけか", "example": "ドラえもんは、どういうわけか問題を解決できた。", "translation": "Doraemon somehow managed to solve the problem."},
     {"word": "pressure", "meaning": "圧力", "example": "ドラえもんは、プレッシャーに負けずに頑張った。", "translation": "Doraemon persevered despite the pressure."},
     {"word": "background", "meaning": "背景", "example": "ドラえもんは、事件の背景を調べた。", "translation": "Doraemon investigated the background of the incident."}
     ];
     break;
     case "高校英語50":
     item = [
     {"word": "archive", "meaning": "記録保管所", "example": "ドラえもんは、過去の記録をアーカイブで調べた。", "translation": "Doraemon researched past records in an archive."},
     {"word": "dazzle", "meaning": "目をくらませる", "example": "ドラえもんの道具の光が、敵を眩惑させた。", "translation": "The light from Doraemon's gadgets dazzled the enemy."},
     {"word": "recess", "meaning": "休憩", "example": "ドラえもんは、休憩時間にみんなと遊んだ。", "translation": "Doraemon played with everyone during recess."},
     {"word": "skyscraper", "meaning": "超高層ビル", "example": "ドラえもんは、超高層ビルを見上げた。", "translation": "Doraemon looked up at a skyscraper."},
     {"word": "botanical", "meaning": "植物の", "example": "ドラえもんは、植物園を訪れた。", "translation": "Doraemon visited a botanical garden."},
     {"word": "sincerity", "meaning": "誠実さ", "example": "ドラえもんは、常に誠実な行動を心がけている。", "translation": "Doraemon always tries to act with sincerity."},
     {"word": "typically", "meaning": "典型的に", "example": "ドラえもんは、典型的にどら焼きが好きだ。", "translation": "Doraemon typically likes dorayaki."},
     {"word": "foggy", "meaning": "霧が深い", "example": "ドラえもんは、霧が深い日に散歩した。", "translation": "Doraemon took a walk on a foggy day."},
     {"word": "restrain", "meaning": "抑制する", "example": "ドラえもんは、自分の感情を抑制した。", "translation": "Doraemon restrained his emotions."},
     {"word": "respondent", "meaning": "回答者", "example": "ドラえもんは、アンケートの回答者を集めた。", "translation": "Doraemon collected respondents for the questionnaire."}
     ];
     break;
     case "高校英語51":
     item = [
     {"word": "representative", "meaning": "代表", "example": "ドラえもんは、未来の世界の代表として来た。", "translation": "Doraemon came as a representative of the future world."},
     {"word": "threat", "meaning": "脅威", "example": "ドラえもんは、地球に対する脅威を取り除こうとした。", "translation": "Doraemon tried to remove the threat to the Earth."},
     {"word": "religious", "meaning": "宗教的な", "example": "ドラえもんは、宗教的な場所を訪れた。", "translation": "Doraemon visited a religious site."},
     {"word": "bore", "meaning": "退屈させる", "example": "のび太は、ドラえもんを退屈させる。", "translation": "Nobita bores Doraemon."},
     {"word": "accidentally", "meaning": "誤って", "example": "のび太は、誤って秘密道具を壊してしまった。", "translation": "Nobita accidentally broke the secret gadget."},
     {"word": "extreme", "meaning": "極端な", "example": "ドラえもんは、極端な行動を避けた。", "translation": "Doraemon avoided extreme actions."},
     {"word": "revolution", "meaning": "革命", "example": "ドラえもんは、未来の技術革命に驚いた。", "translation": "Doraemon was surprised by the future technological revolution."},
     {"word": "researcher", "meaning": "研究者", "example": "ドラえもんは、未来の研究者と話をした。", "translation": "Doraemon spoke with a researcher from the future."},
     {"word": "exaggerate", "meaning": "誇張する", "example": "のび太は、自分の失敗を誇張しがちだ。", "translation": "Nobita tends to exaggerate his failures."},
     {"word": "motivation", "meaning": "動機", "example": "ドラえもんの行動の動機は、のび太を助けることだ。", "translation": "Doraemon's motivation is to help Nobita."}
     ];
     break;
     case "高校英語52":
     item = [
     {"word": "require", "meaning": "必要とする", "example": "ドラえもんは、道具を使うために特別なエネルギーを必要とする。", "translation": "Doraemon requires special energy to use his gadgets."},
     {"word": "establish", "meaning": "設立する", "example": "ドラえもんは、秘密基地を設立した。", "translation": "Doraemon established a secret base."},
     {"word": "screen", "meaning": "画面", "example": "ドラえもんは、テレビの画面を見た。", "translation": "Doraemon looked at the screen of the TV."},
     {"word": "consider", "meaning": "考慮する", "example": "ドラえもんは、色々な可能性を考慮して計画を立てる。", "translation": "Doraemon makes a plan considering various possibilities."},
     {"word": "organize", "meaning": "組織する", "example": "ドラえもんは、イベントを組織した。", "translation": "Doraemon organized an event."},
     {"word": "argue", "meaning": "議論する", "example": "ドラえもんは、のび太と議論した。", "translation": "Doraemon argued with Nobita."},
     {"word": "chip", "meaning": "チップ", "example": "ドラえもんは、コンピューターチップを交換した。", "translation": "Doraemon replaced the computer chip."},
     {"word": "correctly", "meaning": "正しく", "example": "ドラえもんは、いつも正しく道具を使う。", "translation": "Doraemon always uses gadgets correctly."},
     {"word": "fiction", "meaning": "フィクション", "example": "ドラえもんは、フィクションの世界を楽しんだ。", "translation": "Doraemon enjoyed the world of fiction."},
     {"word": "confidence", "meaning": "自信", "example": "ドラえもんは、自信を持って行動する。", "translation": "Doraemon acts with confidence."}
     ];
     break;
     case "高校英語53":
     item = [
     {"word": "alliance", "meaning": "同盟", "example": "ドラえもんは、他のロボットと同盟を結んだ。", "translation": "Doraemon formed an alliance with other robots."},
     {"word": "bookcase", "meaning": "本棚", "example": "ドラえもんは、本棚の本を整理した。", "translation": "Doraemon organized the books in the bookcase."},
     {"word": "assumption", "meaning": "仮定", "example": "ドラえもんは、仮定を立てて推理した。", "translation": "Doraemon made an assumption and reasoned."},
     {"word": "grave", "meaning": "墓", "example": "ドラえもんは、お墓参りをした。", "translation": "Doraemon visited a grave."},
     {"word": "scar", "meaning": "傷跡", "example": "ドラえもんは、過去の戦いで傷跡が残っている。", "translation": "Doraemon has a scar from a battle in the past."},
     {"word": "regret", "meaning": "後悔する", "example": "のび太は、過去の行動を後悔した。", "translation": "Nobita regretted his actions in the past."},
     {"word": "submit", "meaning": "提出する", "example": "のび太は、レポートを提出した。", "translation": "Nobita submitted his report."},
     {"word": "disc", "meaning": "円盤", "example": "ドラえもんは、空を飛ぶ円盤に乗った。", "translation": "Doraemon rode a flying disc."},
     {"word": "complicate", "meaning": "複雑にする", "example": "ドラえもんは、問題を複雑にしないで解決する。", "translation": "Doraemon solves problems without making them complicated."},
     {"word": "deceptive", "meaning": "人を欺く", "example": "ドラえもんの道具には、人を欺くものもある。", "translation": "Some of Doraemon's gadgets can be deceptive."}
     ];
     break;
     case "高校英語54":
     item = [
     {"word": "restore", "meaning": "修復する", "example": "ドラえもんは、壊れた道具を修復した。", "translation": "Doraemon restored a broken gadget."},
     {"word": "rub", "meaning": "こする", "example": "ドラえもんは、目をこすった。", "translation": "Doraemon rubbed his eyes."},
     {"word": "fingerprint", "meaning": "指紋", "example": "ドラえもんは、指紋を採取した。", "translation": "Doraemon took fingerprints."},
     {"word": "nonetheless", "meaning": "それにもかかわらず", "example": "ドラえもんは、大変だったが、それにもかかわらず頑張った。", "translation": "Doraemon had a hard time, nonetheless, he did his best."},
     {"word": "aboriginal", "meaning": "先住民の", "example": "ドラえもんは、先住民の文化に触れた。", "translation": "Doraemon experienced aboriginal culture."},
     {"word": "architect", "meaning": "建築家", "example": "ドラえもんは、未来の建築家と会った。", "translation": "Doraemon met a future architect."},
     {"word": "appetite", "meaning": "食欲", "example": "ドラえもんは、どら焼きの匂いで食欲をそそられた。", "translation": "Doraemon's appetite was whetted by the smell of dorayaki."},
     {"word": "alien", "meaning": "宇宙人", "example": "ドラえもんは、宇宙人と友達になった。", "translation": "Doraemon became friends with an alien."},
     {"word": "negotiation", "meaning": "交渉", "example": "ドラえもんは、敵と交渉をした。", "translation": "Doraemon engaged in negotiation with the enemy."},
     {"word": "exhibit", "meaning": "展示する", "example": "ドラえもんは、博物館で道具を展示した。", "translation": "Doraemon exhibited his gadgets at a museum."}
     ];
     break;
     case "高校英語55":
     item = [
     {"word": "implement", "meaning": "実行する", "example": "ドラえもんは、計画を実行した。", "translation": "Doraemon implemented the plan."},
     {"word": "boom", "meaning": "ブーム", "example": "未来で、ある道具がブームになった。", "translation": "In the future, a certain gadget became a boom."},
     {"word": "homesick", "meaning": "ホームシックの", "example": "ドラえもんは、故郷を懐かしく思った。", "translation": "Doraemon felt homesick."},
     {"word": "mostly", "meaning": "ほとんど", "example": "ドラえもんは、ほとんど毎日どら焼きを食べる。", "translation": "Doraemon eats dorayaki mostly every day."},
     {"word": "recall", "meaning": "思い出す", "example": "ドラえもんは、過去の記憶を思い出した。", "translation": "Doraemon recalled memories of the past."},
     {"word": "temper", "meaning": "気性", "example": "ドラえもんは、冷静な性格なので、あまり気性を荒らげることがない。", "translation": "Doraemon is a calm character, so he does not often lose his temper."},
     {"word": "failure", "meaning": "失敗", "example": "ドラえもんは、失敗から学ぶことを知っている。", "translation": "Doraemon knows to learn from failure."},
     {"word": "precisely", "meaning": "正確に", "example": "ドラえもんは、時間を正確に測った。", "translation": "Doraemon measured the time precisely."},
     {"word": "competitive", "meaning": "競争心のある", "example": "ジャイアンは、競争心がある。", "translation": "Gian is competitive."},
     {"word": "squeeze", "meaning": "押し込む", "example": "ドラえもんは、狭い場所に無理やり押し込んだ。", "translation": "Doraemon squeezed into a narrow space."}
     ];
     break;
     case "高校英語56":
     item = [
     {"word": "column", "meaning": "円柱", "example": "ドラえもんは、円柱の形をした秘密基地を作った。", "translation": "Doraemon made a secret base in the shape of a column."},
     {"word": "toothache", "meaning": "歯痛", "example": "のび太は、甘いものを食べ過ぎて歯痛になった。", "translation": "Nobita had a toothache from eating too many sweets."},
     {"word": "hospitalization", "meaning": "入院", "example": "ドラえもんは、入院した友達を見舞った。", "translation": "Doraemon visited his friend who was hospitalized."},
     {"word": "bulldozer", "meaning": "ブルドーザー", "example": "ドラえもんは、ブルドーザーを運転した。", "translation": "Doraemon drove a bulldozer."},
     {"word": "electron", "meaning": "電子", "example": "ドラえもんは、電子の動きを研究した。", "translation": "Doraemon studied the movement of electrons."},
     {"word": "due", "meaning": "予定の", "example": "ドラえもんは、宿題を提出する期限が迫っていた。", "translation": "Doraemon's homework was due soon."},
     {"word": "behavior", "meaning": "行動", "example": "ドラえもんは、のび太の行動に注意した。", "translation": "Doraemon paid attention to Nobita's behavior."},
     {"word": "weekday", "meaning": "平日", "example": "ドラえもんは、平日はのび太と学校に行く。", "translation": "Doraemon goes to school with Nobita on weekdays."},
     {"word": "concentrate", "meaning": "集中する", "example": "ドラえもんは、問題に集中して取り組んだ。", "translation": "Doraemon concentrated on solving the problem."},
     {"word": "suppose", "meaning": "思う", "example": "ドラえもんは、「多分そうだと思う」と言った。", "translation": "Doraemon said, 'I suppose that's the case'."}
     ];
     break;
     case "高校英語57":
     item = [
     {"word": "redundant", "meaning": "余分な", "example": "ドラえもんは、余分な道具は使わない。", "translation": "Doraemon does not use redundant gadgets."},
     {"word": "coordinate", "meaning": "調整する", "example": "ドラえもんは、みんなの動きを調整した。", "translation": "Doraemon coordinated everyone's movements."},
     {"word": "impair", "meaning": "損なう", "example": "ドラえもんは、環境を損なう行動をしない。", "translation": "Doraemon does not do anything to impair the environment."},
     {"word": "cherish", "meaning": "大切にする", "example": "ドラえもんは、友達を大切にしている。", "translation": "Doraemon cherishes his friends."},
     {"word": "region", "meaning": "地域", "example": "ドラえもんは、色々な地域を旅した。", "translation": "Doraemon traveled to various regions."},
     {"word": "scale", "meaning": "規模", "example": "ドラえもんは、大きな規模のイベントに参加した。", "translation": "Doraemon participated in a large-scale event."},
     {"word": "applicant", "meaning": "応募者", "example": "ドラえもんは、未来の仕事に応募した。", "translation": "Doraemon applied for a job in the future."},
     {"word": "agreement", "meaning": "合意", "example": "ドラえもんは、みんなの合意を得た。", "translation": "Doraemon got everyone's agreement."},
     {"word": "swarm", "meaning": "群がる", "example": "ドラえもんは、虫が群がっているのを見た。", "translation": "Doraemon saw insects swarming around."},
     {"word": "disorder", "meaning": "混乱", "example": "ドラえもんは、部屋の混乱を片付けた。", "translation": "Doraemon cleaned up the disorder in the room."}
     ];
     break;
     case "高校英語58":
     item = [
     {"word": "qualify", "meaning": "資格を与える", "example": "ドラえもんは、試験に合格して資格を得た。", "translation": "Doraemon qualified for the test after passing it."},
     {"word": "activist", "meaning": "活動家", "example": "ドラえもんは、環境活動家と協力した。", "translation": "Doraemon cooperated with an environmental activist."},
     {"word": "nicely", "meaning": "うまく", "example": "ドラえもんは、料理をうまく作った。", "translation": "Doraemon made the dish nicely."},
     {"word": "category", "meaning": "カテゴリー", "example": "ドラえもんは、道具をカテゴリーに分けた。", "translation": "Doraemon divided the gadgets into categories."},
     {"word": "perfume", "meaning": "香水", "example": "ドラえもんは、香水の匂いをかいだ。", "translation": "Doraemon smelled the perfume."},
     {"word": "crisis", "meaning": "危機", "example": "ドラえもんは、危機を乗り越えた。", "translation": "Doraemon overcame the crisis."},
     {"word": "dump", "meaning": "捨てる", "example": "ドラえもんは、ゴミをきちんと捨てた。", "translation": "Doraemon dumped the trash properly."},
     {"word": "primitive", "meaning": "原始的な", "example": "ドラえもんは、原始的な生活を体験した。", "translation": "Doraemon experienced a primitive life."},
     {"word": "funeral", "meaning": "葬式", "example": "ドラえもんは、友達の葬式に出席した。", "translation": "Doraemon attended his friend's funeral."},
     {"word": "tighten", "meaning": "締める", "example": "ドラえもんは、ベルトをきつく締めた。", "translation": "Doraemon tightened his belt."}
     ];
     break;
     case "高校英語59":
     item = [
     {"word": "pretend", "meaning": "ふりをする", "example": "ドラえもんは、知らないふりをした。", "translation": "Doraemon pretended not to know."},
     {"word": "quantity", "meaning": "量", "example": "ドラえもんは、大量のどら焼きを準備した。", "translation": "Doraemon prepared a large quantity of dorayaki."},
     {"word": "summary", "meaning": "要約", "example": "ドラえもんは、事件の要約を説明した。", "translation": "Doraemon explained a summary of the incident."},
     {"word": "meanwhile", "meaning": "その間", "example": "ドラえもんが準備をしている間、のび太は遊んでいた。", "translation": "While Doraemon was preparing, Nobita was playing."},
     {"word": "separately", "meaning": "別々に", "example": "ドラえもんは、別々に道具を保管した。", "translation": "Doraemon stored the gadgets separately."},
     {"word": "physics", "meaning": "物理学", "example": "ドラえもんは、物理学の法則を理解している。", "translation": "Doraemon understands the laws of physics."},
     {"word": "substitute", "meaning": "代用する", "example": "ドラえもんは、壊れた道具の代用になるものを使った。", "translation": "Doraemon used a substitute for the broken gadget."},
     {"word": "pollute", "meaning": "汚染する", "example": "ドラえもんは、地球を汚染から守りたいと思っている。", "translation": "Doraemon wants to protect the Earth from pollution."},
     {"word": "transportation", "meaning": "交通機関", "example": "ドラえもんは、未来の交通機関を利用した。", "translation": "Doraemon used a future mode of transportation."},
     {"word": "tourism", "meaning": "観光", "example": "ドラえもんは、観光客に人気がある。", "translation": "Doraemon is popular among tourists."}
     ];
     break;
     case "高校英語60":
     item = [
     {"word": "fame", "meaning": "名声", "example": "ドラえもんは、未来で名声を得ている。", "translation": "Doraemon has achieved fame in the future."},
     {"word": "confess", "meaning": "告白する", "example": "のび太は、ドラえもんに自分の過ちを告白した。", "translation": "Nobita confessed his mistake to Doraemon."},
     {"word": "entertainer", "meaning": "芸能人", "example": "ドラえもんは、未来の芸能人に会った。", "translation": "Doraemon met a future entertainer."},
     {"word": "ambiguous", "meaning": "曖昧な", "example": "ドラえもんは、曖昧な表現を避けた。", "translation": "Doraemon avoided ambiguous expressions."},
     {"word": "election", "meaning": "選挙", "example": "ドラえもんは、未来の選挙を観察した。", "translation": "Doraemon observed a future election."},
     {"word": "negate", "meaning": "否定する", "example": "ドラえもんは、悪者の主張を否定した。", "translation": "Doraemon negated the villain's claims."},
     {"word": "checkup", "meaning": "健康診断", "example": "ドラえもんは、定期的に健康診断を受けている。", "translation": "Doraemon receives regular checkups."},
     {"word": "controversy", "meaning": "論争", "example": "ドラえもんは、論争を避ける。", "translation": "Doraemon avoids controversy."},
     {"word": "technical", "meaning": "技術的な", "example": "ドラえもんは、技術的な問題を解決した。", "translation": "Doraemon solved a technical problem."},
     {"word": "divert", "meaning": "そらす", "example": "ドラえもんは、敵の注意をそらした。", "translation": "Doraemon diverted the enemy's attention."}
     ];
     break;
    
     
     case "高校英語61":
     item = [
     {"word": "poverty", "meaning": "貧困", "example": "ドラえもんは、貧困のない世界を願っている。", "translation": "Doraemon wishes for a world without poverty."},
     {"word": "range", "meaning": "範囲", "example": "ドラえもんの行動範囲は広い。", "translation": "Doraemon has a wide range of activity."},
     {"word": "marathon", "meaning": "マラソン", "example": "ドラえもんは、マラソン大会に出場した。", "translation": "Doraemon participated in a marathon."},
     {"word": "obvious", "meaning": "明白な", "example": "ドラえもんの優しさは、明白だ。", "translation": "Doraemon's kindness is obvious."},
     {"word": "editor", "meaning": "編集者", "example": "ドラえもんは、雑誌の編集者と話した。", "translation": "Doraemon spoke with a magazine editor."},
     {"word": "revise", "meaning": "修正する", "example": "ドラえもんは、計画を修正した。", "translation": "Doraemon revised the plan."},
     {"word": "vague", "meaning": "曖昧な", "example": "ドラえもんは、曖昧な表現を避けた。", "translation": "Doraemon avoided using vague expressions."},
     {"word": "justify", "meaning": "正当化する", "example": "ドラえもんは、自分の行動を正当化しようとはしなかった。", "translation": "Doraemon did not try to justify his actions."},
     {"word": "pastry", "meaning": "焼き菓子", "example": "ドラえもんは、おいしい焼き菓子を作った。", "translation": "Doraemon made delicious pastries."},
     {"word": "shift", "meaning": "変化", "example": "ドラえもんは、時代の変化を感じた。", "translation": "Doraemon felt the shift in time."}
     ];
     break;
     case "高校英語62":
     item = [
     {"word": "thorough", "meaning": "徹底的な", "example": "ドラえもんは、徹底的な調査をした。", "translation": "Doraemon conducted a thorough investigation."},
     {"word": "adore", "meaning": "敬愛する", "example": "のび太は、ドラえもんを敬愛している。", "translation": "Nobita adores Doraemon."},
     {"word": "personality", "meaning": "性格", "example": "ドラえもんは、優しい性格のロボットだ。", "translation": "Doraemon is a robot with a kind personality."},
     {"word": "subtract", "meaning": "引く", "example": "ドラえもんは、数式で引き算をした。", "translation": "Doraemon subtracted numbers in a formula."},
     {"word": "enterprise", "meaning": "企業", "example": "ドラえもんは、未来の企業を訪問した。", "translation": "Doraemon visited a future enterprise."},
     {"word": "talent", "meaning": "才能", "example": "ドラえもんは、色々な才能を持っている。", "translation": "Doraemon has various talents."},
     {"word": "insight", "meaning": "洞察力", "example": "ドラえもんは、優れた洞察力を持っている。", "translation": "Doraemon has excellent insight."},
     {"word": "intelligence", "meaning": "知能", "example": "ドラえもんの知能は高い。", "translation": "Doraemon's intelligence is high."},
     {"word": "promotion", "meaning": "昇進", "example": "ドラえもんは、仕事で昇進した。", "translation": "Doraemon got a promotion at work."},
     {"word": "concerned", "meaning": "心配している", "example": "ドラえもんは、のび太のことをいつも心配している。", "translation": "Doraemon is always concerned about Nobita."}
     ];
     break;
     case "高校英語63":
     item = [
     {"word": "initiate", "meaning": "始める", "example": "ドラえもんは、新しい計画を始めた。", "translation": "Doraemon initiated a new plan."},
     {"word": "inscription", "meaning": "碑文", "example": "ドラえもんは、古代の碑文を解読した。", "translation": "Doraemon deciphered an ancient inscription."},
     {"word": "highway", "meaning": "高速道路", "example": "ドラえもんは、高速道路を運転した。", "translation": "Doraemon drove on the highway."},
     {"word": "guilty", "meaning": "有罪の", "example": "ドラえもんは、無実を証明した。", "translation": "Doraemon proved his innocence."},
     {"word": "relate", "meaning": "関連付ける", "example": "ドラえもんは、二つの出来事を関連付けた。", "translation": "Doraemon related the two events."},
     {"word": "battery", "meaning": "電池", "example": "ドラえもんは、電池を交換した。", "translation": "Doraemon replaced the battery."},
     {"word": "horizon", "meaning": "地平線", "example": "ドラえもんは、地平線を見ていた。", "translation": "Doraemon was looking at the horizon."},
     {"word": "huge", "meaning": "巨大な", "example": "ドラえもんは、巨大なロボットと戦った。", "translation": "Doraemon fought a huge robot."},
     {"word": "properly", "meaning": "適切に", "example": "ドラえもんは、道具を適切に使った。", "translation": "Doraemon used the gadgets properly."},
     {"word": "quality", "meaning": "質", "example": "ドラえもんは、道具の質を重視する。", "translation": "Doraemon values the quality of his gadgets."}
     ];
     break;
     case "高校英語64":
     item = [
     {"word": "silently", "meaning": "静かに", "example": "ドラえもんは、静かに本を読んだ。", "translation": "Doraemon read a book silently."},
     {"word": "acquire", "meaning": "獲得する", "example": "ドラえもんは、新しい道具を獲得した。", "translation": "Doraemon acquired a new gadget."},
     {"word": "bloom", "meaning": "咲く", "example": "ドラえもんは、花が咲くのを見て喜んだ。", "translation": "Doraemon was happy to see the flowers bloom."},
     {"word": "device", "meaning": "装置", "example": "ドラえもんは、便利な装置を開発した。", "translation": "Doraemon developed a convenient device."},
     {"word": "overall", "meaning": "全体的な", "example": "ドラえもんは、全体の状況を把握した。", "translation": "Doraemon grasped the overall situation."},
     {"word": "radish", "meaning": "大根", "example": "ドラえもんは、畑で大根を収穫した。", "translation": "Doraemon harvested radishes in the field."},
     {"word": "purchase", "meaning": "購入する", "example": "ドラえもんは、未来の道具を購入した。", "translation": "Doraemon purchased a gadget from the future."},
     {"word": "membership", "meaning": "会員資格", "example": "ドラえもんは、未来のクラブの会員になった。", "translation": "Doraemon became a member of a future club."},
     {"word": "cruise", "meaning": "クルーズ旅行", "example": "ドラえもんは、豪華客船でクルーズ旅行に出かけた。", "translation": "Doraemon went on a cruise trip on a luxury ship."},
     {"word": "accomplish", "meaning": "成し遂げる", "example": "ドラえもんは、目標を成し遂げた。", "translation": "Doraemon accomplished his goal."}
     ];
     break;
     case "高校英語65":
     item = [
     {"word": "disappoint", "meaning": "失望させる", "example": "ドラえもんは、友達を失望させたくないと思っている。", "translation": "Doraemon does not want to disappoint his friends."},
     {"word": "relative", "meaning": "親戚", "example": "ドラえもんは、のび太の親戚に会った。", "translation": "Doraemon met Nobita's relatives."},
     {"word": "fragile", "meaning": "壊れやすい", "example": "ドラえもんは、壊れやすいものを丁寧に扱った。", "translation": "Doraemon handled the fragile object carefully."},
     {"word": "motivate", "meaning": "動機づける", "example": "ドラえもんは、のび太を勉強するように動機づけた。", "translation": "Doraemon motivated Nobita to study."},
     {"word": "dignity", "meaning": "尊厳", "example": "ドラえもんは、他者の尊厳を重んじている。", "translation": "Doraemon values the dignity of others."},
     {"word": "intake", "meaning": "摂取量", "example": "ドラえもんは、栄養の摂取量を管理している。", "translation": "Doraemon manages his nutritional intake."},
     {"word": "visa", "meaning": "ビザ", "example": "ドラえもんは、ビザを取得して外国へ行った。", "translation": "Doraemon obtained a visa and went abroad."},
     {"word": "bid", "meaning": "入札", "example": "ドラえもんは、オークションに入札した。", "translation": "Doraemon made a bid at an auction."},
     {"word": "tap", "meaning": "軽く叩く", "example": "ドラえもんは、のび太の肩を軽く叩いた。", "translation": "Doraemon tapped Nobita lightly on the shoulder."},
     {"word": "producer", "meaning": "プロデューサー", "example": "ドラえもんは、未来のテレビ番組のプロデューサーに会った。", "translation": "Doraemon met a producer of a future TV program."}
     ];
     break;
     case "高校英語66":
     item = [
     {"word": "classify", "meaning": "分類する", "example": "ドラえもんは、道具をカテゴリーに分類した。", "translation": "Doraemon classified his gadgets into categories."},
     {"word": "intensive", "meaning": "集中的な", "example": "ドラえもんは、集中的な訓練を受けた。", "translation": "Doraemon underwent intensive training."},
     {"word": "accommodation", "meaning": "宿泊施設", "example": "ドラえもんは、未来の宿泊施設に泊まった。", "translation": "Doraemon stayed in a future accommodation facility."},
     {"word": "development", "meaning": "開発", "example": "ドラえもんは、新しい道具の開発に携わった。", "translation": "Doraemon was involved in the development of a new gadget."},
     {"word": "concerning", "meaning": "～に関する", "example": "ドラえもんは、未来に関する情報を集めた。", "translation": "Doraemon gathered information concerning the future."},
     {"word": "paralyze", "meaning": "麻痺させる", "example": "ドラえもんは、敵を麻痺させる道具を使った。", "translation": "Doraemon used a gadget that paralyzed the enemy."},
     {"word": "seldom", "meaning": "めったに～ない", "example": "ドラえもんは、めったに怒ることはない。", "translation": "Doraemon seldom gets angry."},
     {"word": "closet", "meaning": "クローゼット", "example": "のび太は、クローゼットに服を隠した。", "translation": "Nobita hid the clothes in the closet."},
     {"word": "salon", "meaning": "サロン", "example": "ドラえもんは、美容室のサロンに行った。", "translation": "Doraemon went to a beauty salon."},
     {"word": "edition", "meaning": "版", "example": "ドラえもんは、漫画の限定版を買った。", "translation": "Doraemon bought a limited edition of the manga."}
     ];
     break;
     case "高校英語67":
     item = [
     {"word": "occur", "meaning": "起こる", "example": "ドラえもんは、不思議な出来事が起こったのを見た。", "translation": "Doraemon saw a strange event occur."},
     {"word": "prevail", "meaning": "普及する", "example": "ドラえもんは、未来の技術が普及しているのを見た。", "translation": "Doraemon saw that future technology was prevailing."},
     {"word": "discriminate", "meaning": "差別する", "example": "ドラえもんは、差別をしない。", "translation": "Doraemon does not discriminate."},
     {"word": "forthcoming", "meaning": "近づいている", "example": "ドラえもんは、新しいイベントが近づいていることに気付いた。", "translation": "Doraemon noticed that a new event was forthcoming."},
     {"word": "atomic", "meaning": "原子力の", "example": "ドラえもんは、原子力の技術について学んだ。", "translation": "Doraemon learned about atomic technology."},
     {"word": "lane", "meaning": "車線", "example": "ドラえもんは、道路の車線を確認した。", "translation": "Doraemon checked the lanes of the road."},
     {"word": "leisure", "meaning": "余暇", "example": "ドラえもんは、余暇に本を読むのが好きだ。", "translation": "Doraemon likes to read books during his leisure time."},
     {"word": "investment", "meaning": "投資", "example": "ドラえもんは、未来の投資方法を知っている。", "translation": "Doraemon knows about future investment methods."},
     {"word": "advertise", "meaning": "宣伝する", "example": "ドラえもんは、道具を宣伝するために広告を作った。", "translation": "Doraemon created an advertisement to promote his gadgets."},
     {"word": "media", "meaning": "メディア", "example": "ドラえもんは、メディアを通して情報を収集する。", "translation": "Doraemon gathers information through the media."}
     ];
     break;
     case "高校英語68":
     item = [
     {"word": "instructor", "meaning": "指導者", "example": "ドラえもんは、未来のインストラクターに教えてもらった。", "translation": "Doraemon was taught by a future instructor."},
     {"word": "deer", "meaning": "鹿", "example": "ドラえもんは、森で鹿を見た。", "translation": "Doraemon saw a deer in the forest."},
     {"word": "burden", "meaning": "負担", "example": "ドラえもんは、誰かの負担を軽くしたいと思っている。", "translation": "Doraemon wants to ease the burden of others."},
     {"word": "delight", "meaning": "喜び", "example": "ドラえもんは、のび太の笑顔を見て喜びを感じた。", "translation": "Doraemon felt delight when he saw Nobita smile."},
     {"word": "greenhouse", "meaning": "温室", "example": "ドラえもんは、温室で植物を育てた。", "translation": "Doraemon grew plants in a greenhouse."},
     {"word": "bleed", "meaning": "出血する", "example": "ドラえもんは、少しだけ出血してしまった。", "translation": "Doraemon bled a little bit."},
     {"word": "vast", "meaning": "広大な", "example": "ドラえもんは、広大な宇宙を旅した。", "translation": "Doraemon traveled through the vast universe."},
     {"word": "novel", "meaning": "小説", "example": "ドラえもんは、面白い小説を読んだ。", "translation": "Doraemon read an interesting novel."},
     {"word": "recognize", "meaning": "認識する", "example": "ドラえもんは、過去の友達を認識した。", "translation": "Doraemon recognized his friend from the past."},
     {"word": "sample", "meaning": "見本", "example": "ドラえもんは、道具の見本を見せてくれた。", "translation": "Doraemon showed me a sample of his gadget."}
     ];
     break;
     case "高校英語69":
     item = [
     {"word": "precise", "meaning": "正確な", "example": "ドラえもんは、時間を正確に測ることができる。", "translation": "Doraemon can measure time precisely."},
     {"word": "network", "meaning": "ネットワーク", "example": "ドラえもんは、情報ネットワークにアクセスした。", "translation": "Doraemon accessed the information network."},
     {"word": "associate", "meaning": "関連付ける", "example": "ドラえもんは、出来事を関連付けて考えた。", "translation": "Doraemon associated the events together."},
     {"word": "surface", "meaning": "表面", "example": "ドラえもんは、氷の表面を調べた。", "translation": "Doraemon examined the surface of the ice."},
     {"word": "alternative", "meaning": "代わりの", "example": "ドラえもんは、代わりの道具を使った。", "translation": "Doraemon used an alternative gadget."},
     {"word": "conduct", "meaning": "行う", "example": "ドラえもんは、実験を行った。", "translation": "Doraemon conducted an experiment."},
     {"word": "accuse", "meaning": "非難する", "example": "ジャイアンは、いつも自分以外を非難する。", "translation": "Gian always accuses others."},
     {"word": "angle", "meaning": "角度", "example": "ドラえもんは、角度を調整した。", "translation": "Doraemon adjusted the angle."},
     {"word": "conflict", "meaning": "対立", "example": "ドラえもんは、対立を避けるようにしている。", "translation": "Doraemon tries to avoid conflict."},
     {"word": "bother", "meaning": "悩ませる", "example": "ドラえもんは、のび太を悩ませたくないと思っている。", "translation": "Doraemon doesn't want to bother Nobita."}
     ];
     break;
     case "高校英語70":
     item = [
     {"word": "author", "meaning": "著者", "example": "ドラえもんは、未来の有名な著者に会った。", "translation": "Doraemon met a famous author from the future."},
     {"word": "bet", "meaning": "賭ける", "example": "ドラえもんは、ゲームに賭けをした。", "translation": "Doraemon made a bet on the game."},
     {"word": "reproduce", "meaning": "複製する", "example": "ドラえもんは、壊れた道具を複製した。", "translation": "Doraemon reproduced a broken gadget."},
     {"word": "amaze", "meaning": "驚嘆させる", "example": "ドラえもんは、みんなを驚かせた。", "translation": "Doraemon amazed everyone."},
     {"word": "scratch", "meaning": "引っ掻く", "example": "ドラえもんは、体を掻いた。", "translation": "Doraemon scratched his body."},
     {"word": "intense", "meaning": "激しい", "example": "ドラえもんは、激しい運動をして汗をかいた。", "translation": "Doraemon did intense exercise and sweated."},
     {"word": "relatively", "meaning": "比較的", "example": "ドラえもんは、比較的冷静だった。", "translation": "Doraemon was relatively calm."},
     {"word": "territory", "meaning": "縄張り", "example": "ドラえもんは、動物の縄張りを観察した。", "translation": "Doraemon observed the territory of animals."},
     {"word": "jar", "meaning": "瓶", "example": "ドラえもんは、瓶の中に何かを入れた。", "translation": "Doraemon put something in the jar."},
     {"word": "jealous", "meaning": "嫉妬深い", "example": "ジャイアンは、いつも嫉妬深い。", "translation": "Gian is always jealous."}
     ];
     break;
    
     
     case "高校英語71":
     item = [
     {"word": "countryside", "meaning": "田舎", "example": "ドラえもんは、田舎でのんびり過ごした。", "translation": "Doraemon relaxed in the countryside."},
     {"word": "mall", "meaning": "モール", "example": "ドラえもんは、ショッピングモールへ買い物に行った。", "translation": "Doraemon went shopping at the mall."},
     {"word": "scary", "meaning": "怖い", "example": "ドラえもんは、怖い夢を見てしまった。", "translation": "Doraemon had a scary dream."},
     {"word": "electronic", "meaning": "電子的な", "example": "ドラえもんは、電子的な道具を操作した。", "translation": "Doraemon operated an electronic gadget."},
     {"word": "trend", "meaning": "流行", "example": "ドラえもんは、未来の流行について学んだ。", "translation": "Doraemon learned about future trends."},
     {"word": "unlikely", "meaning": "ありそうもない", "example": "のび太がテストで100点を取るのはありそうもない。", "translation": "It is unlikely that Nobita will get 100 on a test."},
     {"word": "wisdom", "meaning": "知恵", "example": "ドラえもんは、未来の知恵を持っている。", "translation": "Doraemon has wisdom from the future."},
     {"word": "dehydration", "meaning": "脱水症状", "example": "ドラえもんは、脱水症状にならないように水分補給を促した。", "translation": "Doraemon urged everyone to hydrate to prevent dehydration."},
     {"word": "upbringing", "meaning": "育ち", "example": "ドラえもんの育ちは未来だが、優しい心を持っている。", "translation": "Doraemon's upbringing is in the future, but he has a kind heart."},
     {"word": "debit", "meaning": "借方", "example": "ドラえもんは、銀行口座の借方を見た。", "translation": "Doraemon looked at the debit side of his bank account."}
     ];
     break;
     case "高校英語72":
     item = [
     {"word": "singular", "meaning": "単一の", "example": "ドラえもんは、単一の目標に向かって努力した。", "translation": "Doraemon worked towards a singular goal."},
     {"word": "widely", "meaning": "広く", "example": "ドラえもんの漫画は、広く読まれている。", "translation": "Doraemon's manga is widely read."},
     {"word": "protective", "meaning": "保護的な", "example": "ドラえもんは、のび太に対して保護的な態度をとる。", "translation": "Doraemon takes a protective attitude towards Nobita."},
     {"word": "mutual", "meaning": "相互の", "example": "ドラえもんとのび太は、相互に助け合う友達だ。", "translation": "Doraemon and Nobita are friends who help each other mutually."},
     {"word": "surrender", "meaning": "降伏する", "example": "ドラえもんは、悪者に降伏するように言われたが、拒否した。", "translation": "Doraemon was told to surrender to the villains, but he refused."},
     {"word": "exhibition", "meaning": "展示会", "example": "ドラえもんは、未来の道具の展示会へ行った。", "translation": "Doraemon went to an exhibition of future gadgets."},
     {"word": "worsen", "meaning": "悪化させる", "example": "ドラえもんは、状況を悪化させないように気を付けた。", "translation": "Doraemon was careful not to worsen the situation."},
     {"word": "suspicious", "meaning": "疑わしい", "example": "ドラえもんは、怪しい行動をしている人を見て疑わしく思った。", "translation": "Doraemon looked suspiciously at a person acting strangely."},
     {"word": "association", "meaning": "協会", "example": "ドラえもんは、未来のロボット協会に所属している。", "translation": "Doraemon belongs to a future robot association."},
     {"word": "extensive", "meaning": "広範囲な", "example": "ドラえもんは、広範囲な知識を持っている。", "translation": "Doraemon has extensive knowledge."}
     ];
     break;
     case "高校英語73":
     item = [
     {"word": "embrace", "meaning": "受け入れる", "example": "ドラえもんは、新しい文化を受け入れる。", "translation": "Doraemon embraces new cultures."},
     {"word": "relegate", "meaning": "格下げする", "example": "ジャイアンは、いつもスネ夫を格下扱いにする。", "translation": "Gian always relegates Suneo to an inferior position."},
     {"word": "forum", "meaning": "討論会", "example": "ドラえもんは、未来のフォーラムに参加した。", "translation": "Doraemon participated in a future forum."},
     {"word": "introduction", "meaning": "紹介", "example": "ドラえもんは、新しい道具を紹介した。", "translation": "Doraemon gave an introduction to a new gadget."},
     {"word": "demolish", "meaning": "取り壊す", "example": "ドラえもんは、古い建物を壊す計画を阻止した。", "translation": "Doraemon prevented the plan to demolish the old building."},
     {"word": "screw", "meaning": "ねじ", "example": "ドラえもんは、ねじを使って道具を修理した。", "translation": "Doraemon repaired the gadget using screws."},
     {"word": "comparable", "meaning": "同等の", "example": "ドラえもんは、他のロボットと同等の能力を持っている。", "translation": "Doraemon has comparable abilities to other robots."},
     {"word": "comprise", "meaning": "構成する", "example": "ドラえもんの体は、様々な部品で構成されている。", "translation": "Doraemon's body is comprised of various parts."},
     {"word": "dread", "meaning": "恐れる", "example": "のび太は、テストを恐れている。", "translation": "Nobita dreads tests."},
     {"word": "convey", "meaning": "伝える", "example": "ドラえもんは、のび太に大切なメッセージを伝えた。", "translation": "Doraemon conveyed an important message to Nobita."}
     ];
     break;
     case "高校英語74":
     item = [
     {"word": "military", "meaning": "軍事的な", "example": "ドラえもんは、軍事的な技術を嫌う。", "translation": "Doraemon dislikes military technology."},
     {"word": "release", "meaning": "解放する", "example": "ドラえもんは、捕らえられた動物を解放した。", "translation": "Doraemon released the captured animals."},
     {"word": "flavor", "meaning": "風味", "example": "ドラえもんは、どら焼きの様々な風味を楽しんだ。", "translation": "Doraemon enjoyed the different flavors of dorayaki."},
     {"word": "digital", "meaning": "デジタルの", "example": "ドラえもんは、デジタルの世界を体験した。", "translation": "Doraemon experienced the digital world."},
     {"word": "tempt", "meaning": "誘惑する", "example": "ドラえもんは、美味しいものに誘惑される。", "translation": "Doraemon is tempted by delicious food."},
     {"word": "driving", "meaning": "運転", "example": "ドラえもんは、車の運転の練習をした。", "translation": "Doraemon practiced driving a car."},
     {"word": "script", "meaning": "脚本", "example": "ドラえもんは、映画の脚本を読んだ。", "translation": "Doraemon read the script of a movie."},
     {"word": "remarkable", "meaning": "注目すべき", "example": "ドラえもんは、注目すべき活躍をした。", "translation": "Doraemon made a remarkable achievement."},
     {"word": "seasonal", "meaning": "季節の", "example": "ドラえもんは、季節のイベントを楽しんだ。", "translation": "Doraemon enjoyed seasonal events."},
     {"word": "assess", "meaning": "評価する", "example": "ドラえもんは、状況を評価した。", "translation": "Doraemon assessed the situation."}
     ];
     break;
     case "高校英語75":
     item = [
     {"word": "innovation", "meaning": "革新", "example": "ドラえもんは、未来の技術革新に驚いた。", "translation": "Doraemon was amazed by the technological innovation of the future."},
     {"word": "roam", "meaning": "歩き回る", "example": "ドラえもんは、街を自由に歩き回った。", "translation": "Doraemon roamed freely around the town."},
     {"word": "boundary", "meaning": "境界線", "example": "ドラえもんは、時空の境界線を越えた。", "translation": "Doraemon crossed the boundary of time and space."},
     {"word": "narrative", "meaning": "物語", "example": "ドラえもんは、面白い物語を語ってくれた。", "translation": "Doraemon told us an interesting narrative."},
     {"word": "accuracy", "meaning": "正確さ", "example": "ドラえもんは、道具の正確さを重視している。", "translation": "Doraemon emphasizes the accuracy of his gadgets."},
     {"word": "inhabit", "meaning": "住む", "example": "ドラえもんは、未来の都市に住んでみたい。", "translation": "Doraemon wants to inhabit a city in the future."},
     {"word": "evergreen", "meaning": "常緑の", "example": "ドラえもんは、常緑樹の森を訪れた。", "translation": "Doraemon visited a forest of evergreen trees."},
     {"word": "mixture", "meaning": "混合物", "example": "ドラえもんは、色々な材料を混ぜて混合物を作った。", "translation": "Doraemon mixed various ingredients to create a mixture."},
     {"word": "applause", "meaning": "拍手", "example": "ドラえもんは、みんなから拍手喝采を浴びた。", "translation": "Doraemon received applause from everyone."},
     {"word": "starve", "meaning": "飢えさせる", "example": "ドラえもんは、みんなを飢えさせたくないと思っている。", "translation": "Doraemon does not want to starve anyone."}
     ];
     break;
     case "高校英語76":
     item = [
     {"word": "alter", "meaning": "変える", "example": "ドラえもんは、道具を使って自分を変えた。", "translation": "Doraemon used a gadget to alter himself."},
     {"word": "extinction", "meaning": "絶滅", "example": "ドラえもんは、動物の絶滅を阻止したいと願っている。", "translation": "Doraemon wants to prevent the extinction of animals."},
     {"word": "reference", "meaning": "参照", "example": "ドラえもんは、本を参考にした。", "translation": "Doraemon used the book as a reference."},
     {"word": "economic", "meaning": "経済的な", "example": "ドラえもんは、経済的な問題も解決できる。", "translation": "Doraemon can also solve economic problems."},
     {"word": "biological", "meaning": "生物学的な", "example": "ドラえもんは、生物学的な研究もできる。", "translation": "Doraemon can also do biological research."},
     {"word": "discipline", "meaning": "規律", "example": "ドラえもんは、規律を守ることを大切にしている。", "translation": "Doraemon values keeping discipline."},
     {"word": "boost", "meaning": "高める", "example": "ドラえもんは、元気が出るようにみんなを励ました。", "translation": "Doraemon boosted everyone's spirits with encouragement."},
     {"word": "scent", "meaning": "香り", "example": "ドラえもんは、お花のいい香りをかいだ。", "translation": "Doraemon smelled the nice scent of the flowers."},
     {"word": "conference", "meaning": "会議", "example": "ドラえもんは、未来の技術会議に出席した。", "translation": "Doraemon attended a future technology conference."},
     {"word": "sore", "meaning": "痛い", "example": "のび太は、転んで膝が痛い。", "translation": "Nobita's knee is sore from falling down."}
     ];
     break;
     case "高校英語77":
     item = [
     {"word": "impressive", "meaning": "印象的な", "example": "ドラえもんの秘密道具は、いつも印象的だ。", "translation": "Doraemon's secret gadgets are always impressive."},
     {"word": "humid", "meaning": "湿った", "example": "ドラえもんは、湿った場所が苦手だ。", "translation": "Doraemon dislikes humid places."},
     {"word": "bewilder", "meaning": "当惑させる", "example": "ドラえもんは、不思議な出来事に当惑した。", "translation": "Doraemon was bewildered by the strange event."},
     {"word": "heavily", "meaning": "ひどく", "example": "ドラえもんは、ひどく疲れていた。", "translation": "Doraemon was heavily tired."},
     {"word": "celebrity", "meaning": "有名人", "example": "ドラえもんは、未来の有名人に会った。", "translation": "Doraemon met a celebrity from the future."},
     {"word": "displace", "meaning": "移動させる", "example": "ドラえもんは、物を瞬間移動させた。", "translation": "Doraemon displaced an object instantaneously."},
     {"word": "stack", "meaning": "積み重ねる", "example": "ドラえもんは、本を積み重ねた。", "translation": "Doraemon stacked the books."},
     {"word": "cultural", "meaning": "文化的な", "example": "ドラえもんは、文化的な遺産を見に行った。", "translation": "Doraemon went to see a cultural heritage site."},
     {"word": "mainstream", "meaning": "主流", "example": "ドラえもんは、主流の考え方ではない。", "translation": "Doraemon's thinking is not mainstream."},
     {"word": "thriller", "meaning": "スリラー", "example": "ドラえもんは、スリラー映画を見てドキドキした。", "translation": "Doraemon was thrilled watching a thriller movie."}
     ];
     break;
     case "高校英語78":
     item = [
     {"word": "sunglasses", "meaning": "サングラス", "example": "ドラえもんは、サングラスをかけて出かけた。", "translation": "Doraemon went out wearing sunglasses."},
     {"word": "insert", "meaning": "挿入する", "example": "ドラえもんは、カードを挿入して機械を動かした。", "translation": "Doraemon inserted a card and operated the machine."},
     {"word": "draft", "meaning": "下書き", "example": "ドラえもんは、手紙の下書きを書いた。", "translation": "Doraemon wrote a draft of a letter."},
     {"word": "file", "meaning": "ファイル", "example": "ドラえもんは、資料をファイルに整理した。", "translation": "Doraemon organized the documents into files."},
     {"word": "dioxide", "meaning": "二酸化物", "example": "ドラえもんは、二酸化炭素について学んだ。", "translation": "Doraemon learned about dioxide."},
     {"word": "peculiar", "meaning": "奇妙な", "example": "ドラえもんは、奇妙な行動をしていた。", "translation": "Doraemon was acting in a peculiar way."},
     {"word": "formulate", "meaning": "作り出す", "example": "ドラえもんは、新しい計画を作り出した。", "translation": "Doraemon formulated a new plan."},
     {"word": "merit", "meaning": "長所", "example": "ドラえもんは、道具の長所と短所を説明した。", "translation": "Doraemon explained the merits and demerits of the gadgets."},
     {"word": "mode", "meaning": "モード", "example": "ドラえもんは、道具のモードを変えて使った。", "translation": "Doraemon changed the mode of the gadget and used it."},
     {"word": "applaud", "meaning": "拍手喝采する", "example": "ドラえもんは、みんなの活躍に拍手喝采を送った。", "translation": "Doraemon applauded everyone's achievement."}
     ];
     break;
     case "高校英語79":
     item = [
     {"word": "operate", "meaning": "操作する", "example": "ドラえもんは、機械を操作するのが得意だ。", "translation": "Doraemon is good at operating machines."},
     {"word": "grab", "meaning": "つかむ", "example": "ドラえもんは、物をしっかり掴んだ。", "translation": "Doraemon grabbed the object firmly."},
     {"word": "debate", "meaning": "討論する", "example": "ドラえもんは、みんなと討論した。", "translation": "Doraemon had a debate with everyone."},
     {"word": "economy", "meaning": "経済", "example": "ドラえもんは、未来の経済システムについて学んだ。", "translation": "Doraemon learned about the future economy."},
     {"word": "emergency", "meaning": "緊急事態", "example": "ドラえもんは、緊急事態にすぐに対応できる。", "translation": "Doraemon can quickly respond to emergencies."},
     {"word": "classical", "meaning": "クラシックの", "example": "ドラえもんは、クラシック音楽が好きだ。", "translation": "Doraemon likes classical music."},
     {"word": "jewelry", "meaning": "宝石", "example": "ドラえもんは、宝石を見て驚いた。", "translation": "Doraemon was surprised by seeing the jewelry."},
     {"word": "factor", "meaning": "要因", "example": "ドラえもんは、事件の要因を分析した。", "translation": "Doraemon analyzed the factors of the incident."},
     {"word": "adapt", "meaning": "適応する", "example": "ドラえもんは、どんな状況にも適応できる。", "translation": "Doraemon can adapt to any situation."},
     {"word": "shortage", "meaning": "不足", "example": "ドラえもんは、資源不足を心配している。", "translation": "Doraemon is worried about the shortage of resources."}
     ];
     break;
     case "高校英語80":
     item = [
     {"word": "technician", "meaning": "技術者", "example": "ドラえもんは、未来の技術者と話した。", "translation": "Doraemon talked to a technician from the future."},
     {"word": "informal", "meaning": "非公式の", "example": "ドラえもんは、非公式な会合に出席した。", "translation": "Doraemon attended an informal meeting."},
     {"word": "instantly", "meaning": "即座に", "example": "ドラえもんは、即座に行動した。", "translation": "Doraemon acted instantly."},
     {"word": "dismiss", "meaning": "解雇する", "example": "ドラえもんは、友達を解雇することは絶対にない。", "translation": "Doraemon would never dismiss his friends."},
     {"word": "dedicate", "meaning": "捧げる", "example": "ドラえもんは、のび太のために自分の時間を捧げている。", "translation": "Doraemon dedicates his time for Nobita."},
     {"word": "misunderstanding", "meaning": "誤解", "example": "ドラえもんは、誤解を解こうとした。", "translation": "Doraemon tried to clear up the misunderstanding."},
     {"word": "cruel", "meaning": "残酷な", "example": "ドラえもんは、残酷な行為を嫌う。", "translation": "Doraemon dislikes cruel acts."},
     {"word": "criticism", "meaning": "批判", "example": "ドラえもんは、批判を受け止める。", "translation": "Doraemon accepts criticism."},
     {"word": "backer", "meaning": "支援者", "example": "ドラえもんは、のび太の夢の支援者だ。", "translation": "Doraemon is a backer of Nobita's dreams."},
     {"word": "discrimination", "meaning": "差別", "example": "ドラえもんは、差別をしない。", "translation": "Doraemon does not discriminate against anyone."}
     ];
     break;
    
     
     case "高校英語81":
     item = [
     {"word": "distinction", "meaning": "区別", "example": "ドラえもんは、善悪の区別をきちんとつける。", "translation": "Doraemon makes a clear distinction between good and evil."},
     {"word": "chat", "meaning": "おしゃべりする", "example": "ドラえもんは、友達と楽しくおしゃべりをした。", "translation": "Doraemon had a fun chat with his friends."},
     {"word": "reverse", "meaning": "逆にする", "example": "ドラえもんは、時間を逆にする道具を使った。", "translation": "Doraemon used a gadget that reversed time."},
     {"word": "colleague", "meaning": "同僚", "example": "ドラえもんは、未来の同僚と仕事をした。", "translation": "Doraemon worked with his colleagues from the future."},
     {"word": "capable", "meaning": "有能な", "example": "ドラえもんは、とても有能なロボットだ。", "translation": "Doraemon is a very capable robot."},
     {"word": "volume", "meaning": "音量", "example": "ドラえもんは、テレビの音量を調節した。", "translation": "Doraemon adjusted the volume of the TV."},
     {"word": "entertain", "meaning": "楽しませる", "example": "ドラえもんは、みんなを楽しませるのが好きだ。", "translation": "Doraemon likes to entertain everyone."},
     {"word": "contract", "meaning": "契約", "example": "ドラえもんは、契約書をよく読んだ。", "translation": "Doraemon carefully read the contract."},
     {"word": "justice", "meaning": "正義", "example": "ドラえもんは、正義を重んじる。", "translation": "Doraemon values justice."},
     {"word": "interrupt", "meaning": "邪魔する", "example": "ドラえもんは、のび太の勉強を邪魔しないようにした。", "translation": "Doraemon tried not to interrupt Nobita's studying."}
     ];
     break;
     case "高校英語82":
     item = [
     {"word": "showdown", "meaning": "対決", "example": "ドラえもんは、宿敵との対決に挑んだ。", "translation": "Doraemon challenged his nemesis to a showdown."},
     {"word": "takeoff", "meaning": "離陸", "example": "ドラえもんは、飛行機の離陸を見た。", "translation": "Doraemon watched the airplane take off."},
     {"word": "clone", "meaning": "クローン", "example": "ドラえもんは、クローン技術に興味を持っている。", "translation": "Doraemon is interested in cloning technology."},
     {"word": "concede", "meaning": "認める", "example": "ドラえもんは、自分の間違いを認めた。", "translation": "Doraemon conceded his mistake."},
     {"word": "comprehensive", "meaning": "包括的な", "example": "ドラえもんは、包括的な計画を立てた。", "translation": "Doraemon made a comprehensive plan."},
     {"word": "beneficial", "meaning": "有益な", "example": "ドラえもんの道具は、みんなに有益だ。", "translation": "Doraemon's gadgets are beneficial to everyone."},
     {"word": "prescribe", "meaning": "処方する", "example": "ドラえもんは、未来の薬を処方した。", "translation": "Doraemon prescribed a future medicine."},
     {"word": "humble", "meaning": "謙虚な", "example": "ドラえもんは、いつも謙虚な態度でいる。", "translation": "Doraemon is always humble."},
     {"word": "coalition", "meaning": "連合", "example": "ドラえもんは、他のヒーローと同盟を結んだ。", "translation": "Doraemon formed a coalition with other heroes."},
     {"word": "colonize", "meaning": "植民地化する", "example": "ドラえもんは、未来で月が植民地化されているのを見た。", "translation": "Doraemon saw that the moon was colonized in the future."}
     ];
     break;
     case "高校英語83":
     item = [
     {"word": "assume", "meaning": "仮定する", "example": "ドラえもんは、いくつかの仮定に基づいて推理した。", "translation": "Doraemon made inferences based on several assumptions."},
     {"word": "employ", "meaning": "雇う", "example": "ドラえもんは、未来のロボットを雇った。", "translation": "Doraemon employed a robot from the future."},
     {"word": "satisfy", "meaning": "満足させる", "example": "ドラえもんは、みんなを満足させるために努力した。", "translation": "Doraemon made an effort to satisfy everyone."},
     {"word": "excerpt", "meaning": "抜粋", "example": "ドラえもんは、資料から一部を抜粋した。", "translation": "Doraemon took an excerpt from the document."},
     {"word": "rarely", "meaning": "めったに～ない", "example": "ドラえもんは、めったに怒ることはない。", "translation": "Doraemon rarely gets angry."},
     {"word": "fund", "meaning": "資金", "example": "ドラえもんは、研究資金を集めた。", "translation": "Doraemon collected funds for his research."},
     {"word": "document", "meaning": "書類", "example": "ドラえもんは、書類を確認した。", "translation": "Doraemon checked the document."},
     {"word": "increasingly", "meaning": "ますます", "example": "ドラえもんは、ますます人気が出てきた。", "translation": "Doraemon has become increasingly popular."},
     {"word": "planner", "meaning": "計画立案者", "example": "ドラえもんは、計画立案者のように計画を立てた。", "translation": "Doraemon made plans like a planner."},
     {"word": "source", "meaning": "源", "example": "ドラえもんは、エネルギーの源を探した。", "translation": "Doraemon looked for the source of the energy."}
     ];
     break;
     case "高校英語84":
     item = [
     {"word": "awkward", "meaning": "ぎこちない", "example": "のび太は、ぎこちない動きしかできない。", "translation": "Nobita can only make awkward movements."},
     {"word": "shatter", "meaning": "粉々にする", "example": "ドラえもんは、物を粉々に砕く道具を使った。", "translation": "Doraemon used a gadget that shattered objects."},
     {"word": "vaccine", "meaning": "ワクチン", "example": "ドラえもんは、未来のワクチンを接種した。", "translation": "Doraemon got a future vaccine."},
     {"word": "cautious", "meaning": "用心深い", "example": "ドラえもんは、用心深く行動する。", "translation": "Doraemon acts cautiously."},
     {"word": "adviser", "meaning": "アドバイザー", "example": "ドラえもんは、のび太のアドバイザーになった。", "translation": "Doraemon became Nobita's adviser."},
     {"word": "expertise", "meaning": "専門知識", "example": "ドラえもんは、様々な分野の専門知識を持っている。", "translation": "Doraemon has expertise in various fields."},
     {"word": "obligation", "meaning": "義務", "example": "ドラえもんは、友達を助ける義務があると思っている。", "translation": "Doraemon believes it's his obligation to help his friends."},
     {"word": "illusion", "meaning": "幻想", "example": "ドラえもんは、幻を作り出す道具を使った。", "translation": "Doraemon used a gadget to create an illusion."},
     {"word": "crawl", "meaning": "這う", "example": "ドラえもんは、狭い場所を這って進んだ。", "translation": "Doraemon crawled through a narrow space."},
     {"word": "profile", "meaning": "プロフィール", "example": "ドラえもんは、自分のプロフィールを公開した。", "translation": "Doraemon revealed his profile."}
     ];
     break;
     case "高校英語85":
     item = [
     {"word": "divorce", "meaning": "離婚", "example": "ドラえもんは、離婚問題を解決する。", "translation": "Doraemon solves divorce problems."},
     {"word": "resign", "meaning": "辞任する", "example": "ドラえもんは、責任をとって辞任した。", "translation": "Doraemon resigned to take responsibility."},
     {"word": "certificate", "meaning": "証明書", "example": "ドラえもんは、資格の証明書を見せた。", "translation": "Doraemon showed his certificate of qualification."},
     {"word": "growth", "meaning": "成長", "example": "ドラえもんは、のび太の成長を喜んでいる。", "translation": "Doraemon is happy about Nobita's growth."},
     {"word": "crucial", "meaning": "決定的な", "example": "ドラえもんは、決定的な場面で活躍した。", "translation": "Doraemon played a crucial role at a decisive moment."},
     {"word": "partner", "meaning": "相棒", "example": "ドラえもんは、のび太の相棒だ。", "translation": "Doraemon is Nobita's partner."},
     {"word": "spacecraft", "meaning": "宇宙船", "example": "ドラえもんは、宇宙船に乗って宇宙へ行った。", "translation": "Doraemon went to space in a spacecraft."},
     {"word": "legend", "meaning": "伝説", "example": "ドラえもんは、伝説のヒーローと出会った。", "translation": "Doraemon met a legendary hero."},
     {"word": "controversial", "meaning": "物議を醸す", "example": "ドラえもんは、物議を醸す行動はしない。", "translation": "Doraemon does not take controversial actions."},
     {"word": "temporary", "meaning": "一時的な", "example": "ドラえもんは、一時的な道具を借りた。", "translation": "Doraemon borrowed a temporary gadget."}
     ];
     break;
     case "高校英語86":
     item = [
     {"word": "modernization", "meaning": "近代化", "example": "ドラえもんは、未来の都市の近代化を見た。", "translation": "Doraemon saw the modernization of the future city."},
     {"word": "dilemma", "meaning": "ジレンマ", "example": "ドラえもんは、ジレンマに陥った。", "translation": "Doraemon got into a dilemma."},
     {"word": "grip", "meaning": "つかむ", "example": "ドラえもんは、しっかりと物を掴んだ。", "translation": "Doraemon gripped the object tightly."},
     {"word": "stern", "meaning": "厳格な", "example": "ドラえもんは、時には厳格な態度で接する。", "translation": "Doraemon sometimes takes a stern attitude."},
     {"word": "duplicate", "meaning": "複製する", "example": "ドラえもんは、道具を複製した。", "translation": "Doraemon duplicated the gadget."},
     {"word": "prosecute", "meaning": "起訴する", "example": "ドラえもんは、悪者を起訴する。", "translation": "Doraemon prosecutes bad guys."},
     {"word": "perfectly", "meaning": "完璧に", "example": "ドラえもんは、完璧に仕事をこなした。", "translation": "Doraemon completed the work perfectly."},
     {"word": "creep", "meaning": "忍び寄る", "example": "ドラえもんは、忍び寄る敵を警戒した。", "translation": "Doraemon was wary of the enemy creeping up."},
     {"word": "fraud", "meaning": "詐欺", "example": "ドラえもんは、詐欺を見破った。", "translation": "Doraemon exposed the fraud."},
     {"word": "generosity", "meaning": "寛大さ", "example": "ドラえもんは、いつも寛大だ。", "translation": "Doraemon is always generous."}
     ];
     break;
     case "高校英語87":
     item = [
     {"word": "anytime", "meaning": "いつでも", "example": "ドラえもんは、いつでものび太を助ける。", "translation": "Doraemon helps Nobita anytime."},
     {"word": "complaint", "meaning": "苦情", "example": "ドラえもんは、苦情を受け止める。", "translation": "Doraemon accepts complaints."},
     {"word": "derive", "meaning": "由来する", "example": "ドラえもんの力は、未来の技術に由来する。", "translation": "Doraemon's power is derived from future technology."},
     {"word": "spoil", "meaning": "甘やかす", "example": "ドラえもんは、のび太を甘やかしすぎないように気を付けている。", "translation": "Doraemon is careful not to spoil Nobita too much."},
     {"word": "compose", "meaning": "構成する", "example": "ドラえもんの体は、多くの部品で構成されている。", "translation": "Doraemon's body is composed of many parts."},
     {"word": "thankful", "meaning": "感謝している", "example": "ドラえもんは、いつもみんなに感謝している。", "translation": "Doraemon is always thankful to everyone."},
     {"word": "corridor", "meaning": "廊下", "example": "ドラえもんは、長い廊下を歩いた。", "translation": "Doraemon walked down the long corridor."},
     {"word": "conservation", "meaning": "保護", "example": "ドラえもんは、環境の保護を訴えた。", "translation": "Doraemon appealed for environmental conservation."},
     {"word": "satellite", "meaning": "衛星", "example": "ドラえもんは、人工衛星を調べた。", "translation": "Doraemon investigated a satellite."},
     {"word": "scholar", "meaning": "学者", "example": "ドラえもんは、未来の学者と話をした。", "translation": "Doraemon spoke with a scholar from the future."}
     ];
     break;
     case "高校英語88":
     item = [
     {"word": "underwater", "meaning": "水中の", "example": "ドラえもんは、水中の世界を探検した。", "translation": "Doraemon explored the underwater world."},
     {"word": "arctic", "meaning": "北極の", "example": "ドラえもんは、北極に行ったことがある。", "translation": "Doraemon has been to the Arctic."},
     {"word": "fluid", "meaning": "液体", "example": "ドラえもんは、不思議な液体を飲んだ。", "translation": "Doraemon drank a mysterious fluid."},
     {"word": "commemorate", "meaning": "記念する", "example": "ドラえもんは、友達の誕生日を記念した。", "translation": "Doraemon commemorated his friend's birthday."},
     {"word": "transparent", "meaning": "透明な", "example": "ドラえもんは、透明な素材でできた道具を使った。", "translation": "Doraemon used a gadget made of transparent material."},
     {"word": "eruption", "meaning": "噴火", "example": "ドラえもんは、火山の噴火を間近で見た。", "translation": "Doraemon saw a volcanic eruption up close."},
     {"word": "ugly", "meaning": "醜い", "example": "ドラえもんは、醜い争いを嫌う。", "translation": "Doraemon dislikes ugly conflicts."},
     {"word": "repay", "meaning": "返済する", "example": "のび太は、ドラえもんに借りを返そうとした。", "translation": "Nobita tried to repay his debt to Doraemon."},
     {"word": "united", "meaning": "団結した", "example": "ドラえもんは、みんなと団結して敵に立ち向かった。", "translation": "Doraemon united with everyone and confronted the enemy."},
     {"word": "budget", "meaning": "予算", "example": "ドラえもんは、予算内でやりくりした。", "translation": "Doraemon managed the budget effectively."}
     ];
     break;
     case "高校英語89":
     item = [
     {"word": "throughout", "meaning": "～の間中", "example": "ドラえもんは、一年中を通してのび太のそばにいる。", "translation": "Doraemon is with Nobita throughout the year."},
     {"word": "ignorance", "meaning": "無知", "example": "ドラえもんは、無知を恥じるべきだと考えている。", "translation": "Doraemon believes we should be ashamed of ignorance."},
     {"word": "diminish", "meaning": "減少する", "example": "ドラえもんは、資源が減少していることに気づいた。", "translation": "Doraemon noticed the diminishing resources."},
     {"word": "hypertension", "meaning": "高血圧", "example": "ドラえもんは、高血圧にならないように気を付けている。", "translation": "Doraemon is careful not to develop hypertension."},
     {"word": "concession", "meaning": "譲歩", "example": "ドラえもんは、相手に譲歩を求めた。", "translation": "Doraemon asked the other party for a concession."},
     {"word": "penetrate", "meaning": "浸透する", "example": "ドラえもんは、敵の防御を浸透する道具を使った。", "translation": "Doraemon used a gadget that penetrated the enemy's defenses."},
     {"word": "hail", "meaning": "雹", "example": "ドラえもんは、雹が降るのを見た。", "translation": "Doraemon saw hail falling."},
     {"word": "collecting", "meaning": "収集", "example": "ドラえもんは、切手を収集するのが好きだ。", "translation": "Doraemon likes collecting stamps."},
     {"word": "lethal", "meaning": "致命的な", "example": "ドラえもんは、致命的な攻撃を避けた。", "translation": "Doraemon avoided the lethal attack."},
     {"word": "illegal", "meaning": "違法な", "example": "ドラえもんは、違法な行為はしない。", "translation": "Doraemon does not do anything illegal."}
     ];
     break;
     case "高校英語90":
     item = [
     {"word": "canoe", "meaning": "カヌー", "example": "ドラえもんは、カヌーに乗って川を下った。", "translation": "Doraemon went down the river in a canoe."},
     {"word": "grocery", "meaning": "食料品", "example": "ドラえもんは、食料品店で買い物をした。", "translation": "Doraemon did his shopping at a grocery store."},
     {"word": "acquaintance", "meaning": "知り合い", "example": "ドラえもんは、知り合いのロボットに会った。", "translation": "Doraemon met an acquaintance robot."},
     {"word": "selfish", "meaning": "利己的な", "example": "ドラえもんは、利己的な行動を嫌う。", "translation": "Doraemon dislikes selfish behavior."},
     {"word": "interact", "meaning": "交流する", "example": "ドラえもんは、他の人と積極的に交流する。", "translation": "Doraemon actively interacts with other people."},
     {"word": "settlement", "meaning": "解決", "example": "ドラえもんは、問題を平和的に解決した。", "translation": "Doraemon solved the problem peacefully."},
     {"word": "unexpected", "meaning": "予期しない", "example": "ドラえもんは、予期しない出来事に驚いた。", "translation": "Doraemon was surprised by the unexpected event."},
     {"word": "chore", "meaning": "雑用", "example": "のび太は、いつも雑用を押し付けられる。", "translation": "Nobita is always forced to do chores."},
     {"word": "physician", "meaning": "医師", "example": "ドラえもんは、未来の医師に相談した。", "translation": "Doraemon consulted with a physician from the future."},
     {"word": "forth", "meaning": "前へ", "example": "ドラえもんは、勇気をもって前へ進んだ。", "translation": "Doraemon stepped forth with courage."}
     ];
     break;
    
     
     case "高校英語91":
     item = [
     {"word": "generate", "meaning": "生み出す", "example": "ドラえもんは、エネルギーを生み出す道具を使った。", "translation": "Doraemon used a gadget that generated energy."},
     {"word": "severe", "meaning": "厳しい", "example": "ドラえもんは、厳しい訓練に耐えた。", "translation": "Doraemon endured severe training."},
     {"word": "guarantee", "meaning": "保証する", "example": "ドラえもんは、道具の品質を保証した。", "translation": "Doraemon guaranteed the quality of his gadgets."},
     {"word": "proficient", "meaning": "熟達した", "example": "ドラえもんは、道具の操作に熟達している。", "translation": "Doraemon is proficient in operating his gadgets."},
     {"word": "innermost", "meaning": "最も奥の", "example": "ドラえもんは、心の最も奥底にある優しさを持っている。", "translation": "Doraemon has kindness in the innermost part of his heart."},
     {"word": "invisible", "meaning": "見えない", "example": "ドラえもんは、見えない道具を使った。", "translation": "Doraemon used an invisible gadget."},
     {"word": "vivid", "meaning": "鮮やかな", "example": "ドラえもんは、鮮やかな夢を見た。", "translation": "Doraemon had a vivid dream."},
     {"word": "intersection", "meaning": "交差点", "example": "ドラえもんは、交差点で事故に遭いそうになった。", "translation": "Doraemon almost got into an accident at the intersection."},
     {"word": "productivity", "meaning": "生産性", "example": "ドラえもんは、生産性を高めるために道具を使った。", "translation": "Doraemon used gadgets to increase productivity."},
     {"word": "obstacle", "meaning": "障害", "example": "ドラえもんは、障害を乗り越えた。", "translation": "Doraemon overcame the obstacle."}
     ];
     break;
     case "高校英語92":
     item = [
     {"word": "bookshelf", "meaning": "本棚", "example": "ドラえもんは、本棚の本を整理した。", "translation": "Doraemon organized the books on the bookshelf."},
     {"word": "tuition", "meaning": "授業料", "example": "ドラえもんは、未来の学校の授業料を支払った。", "translation": "Doraemon paid the tuition for a future school."},
     {"word": "flu", "meaning": "インフルエンザ", "example": "のび太は、インフルエンザで寝込んだ。", "translation": "Nobita was in bed with the flu."},
     {"word": "anthropologist", "meaning": "人類学者", "example": "ドラえもんは、人類学者と話をした。", "translation": "Doraemon talked with an anthropologist."},
     {"word": "tablespoon", "meaning": "大さじ", "example": "ドラえもんは、大さじ一杯の砂糖を入れた。", "translation": "Doraemon put one tablespoon of sugar in."},
     {"word": "groundwater", "meaning": "地下水", "example": "ドラえもんは、地下水について調査した。", "translation": "Doraemon investigated groundwater."},
     {"word": "trivial", "meaning": "些細な", "example": "ドラえもんは、些細なことでも見逃さない。", "translation": "Doraemon does not overlook even trivial things."},
     {"word": "arrogant", "meaning": "傲慢な", "example": "ジャイアンは、時々傲慢な態度をとる。", "translation": "Gian sometimes acts in an arrogant manner."},
     {"word": "relax", "meaning": "くつろぐ", "example": "ドラえもんは、ゆっくりとくつろいでいた。", "translation": "Doraemon was relaxing peacefully."},
     {"word": "review", "meaning": "見直す", "example": "ドラえもんは、計画を見直した。", "translation": "Doraemon reviewed his plan."}
     ];
     break;
     case "高校英語93":
     item = [
     {"word": "retail", "meaning": "小売りの", "example": "ドラえもんは、小売店で買い物をした。", "translation": "Doraemon did his shopping at a retail store."},
     {"word": "seize", "meaning": "つかむ", "example": "ドラえもんは、チャンスを掴んだ。", "translation": "Doraemon seized the opportunity."},
     {"word": "vacant", "meaning": "空いている", "example": "ドラえもんは、空いている場所を探した。", "translation": "Doraemon looked for a vacant spot."},
     {"word": "spectator", "meaning": "観客", "example": "ドラえもんは、試合を観戦していた観客の一人だ。", "translation": "Doraemon was one of the spectators at the game."},
     {"word": "overlook", "meaning": "見落とす", "example": "ドラえもんは、小さなことを見落とさない。", "translation": "Doraemon does not overlook small details."},
     {"word": "initiative", "meaning": "主導権", "example": "ドラえもんは、主導権を握って行動した。", "translation": "Doraemon took the initiative and acted."},
     {"word": "union", "meaning": "組合", "example": "ドラえもんは、労働組合に所属している。", "translation": "Doraemon belongs to a labor union."},
     {"word": "organism", "meaning": "有機体", "example": "ドラえもんは、地球上の様々な有機体について学んだ。", "translation": "Doraemon learned about various organisms on Earth."},
     {"word": "welfare", "meaning": "福祉", "example": "ドラえもんは、人々の福祉に関心を持っている。", "translation": "Doraemon is interested in people's welfare."},
     {"word": "fulfill", "meaning": "果たす", "example": "ドラえもんは、自分の役割を果たす。", "translation": "Doraemon fulfills his role."}
     ];
     break;
     case "高校英語94":
     item = [
     {"word": "studio", "meaning": "スタジオ", "example": "ドラえもんは、テレビスタジオを訪れた。", "translation": "Doraemon visited a TV studio."},
     {"word": "literature", "meaning": "文学", "example": "ドラえもんは、文学作品を読むのが好きだ。", "translation": "Doraemon likes to read works of literature."},
     {"word": "negative", "meaning": "否定的な", "example": "ドラえもんは、否定的なことは言わない。", "translation": "Doraemon does not say negative things."},
     {"word": "cell", "meaning": "細胞", "example": "ドラえもんは、細胞について学んだ。", "translation": "Doraemon learned about cells."},
     {"word": "questionnaire", "meaning": "アンケート", "example": "ドラえもんは、アンケート調査を実施した。", "translation": "Doraemon conducted a questionnaire."},
     {"word": "contemporary", "meaning": "現代の", "example": "ドラえもんは、現代の文化について学んでいる。", "translation": "Doraemon is learning about contemporary culture."},
     {"word": "institution", "meaning": "機関", "example": "ドラえもんは、教育機関で講義を受けた。", "translation": "Doraemon attended a lecture at an educational institution."},
     {"word": "tend", "meaning": "～しがちである", "example": "のび太は、いつも失敗しがちだ。", "translation": "Nobita tends to fail all the time."},
     {"word": "millionaire", "meaning": "大富豪", "example": "ドラえもんは、未来の大富豪に会った。", "translation": "Doraemon met a future millionaire."},
     {"word": "surrounding", "meaning": "周囲の", "example": "ドラえもんは、周囲の状況を観察した。", "translation": "Doraemon observed the surrounding situation."}
     ];
     break;
     case "高校英語95":
     item = [
     {"word": "famine", "meaning": "飢饉", "example": "ドラえもんは、飢饉で苦しむ人々を助けた。", "translation": "Doraemon helped people suffering from famine."},
     {"word": "meditate", "meaning": "瞑想する", "example": "ドラえもんは、静かに瞑想をした。", "translation": "Doraemon meditated quietly."},
     {"word": "extent", "meaning": "程度", "example": "ドラえもんは、状況の深刻さを測った。", "translation": "Doraemon measured the extent of the situation's seriousness."},
     {"word": "babysit", "meaning": "子守をする", "example": "ドラえもんは、赤ちゃんの子守をした。", "translation": "Doraemon babysat the baby."},
     {"word": "asset", "meaning": "資産", "example": "ドラえもんは、未来の資産を管理した。", "translation": "Doraemon managed future assets."},
     {"word": "statistics", "meaning": "統計", "example": "ドラえもんは、統計データを分析した。", "translation": "Doraemon analyzed statistical data."},
     {"word": "diplomat", "meaning": "外交官", "example": "ドラえもんは、未来の外交官と話をした。", "translation": "Doraemon spoke with a diplomat from the future."},
     {"word": "shelter", "meaning": "避難所", "example": "ドラえもんは、人々を避難所に誘導した。", "translation": "Doraemon guided people to the shelter."},
     {"word": "trigger", "meaning": "引き金となる", "example": "ドラえもんは、事件の引き金となった。", "translation": "Doraemon triggered the incident."},
     {"word": "addiction", "meaning": "中毒", "example": "ドラえもんは、中毒にならないように注意している。", "translation": "Doraemon is careful not to become addicted."}
     ];
     break;
     case "高校英語96":
     item = [
     {"word": "exotic", "meaning": "異国風の", "example": "ドラえもんは、異国風の場所を旅した。", "translation": "Doraemon traveled to an exotic place."},
     {"word": "intrude", "meaning": "侵入する", "example": "ドラえもんは、許可なく他人の家に入らない。", "translation": "Doraemon does not intrude into other people's houses without permission."},
     {"word": "reputation", "meaning": "評判", "example": "ドラえもんは、良い評判を得ている。", "translation": "Doraemon has a good reputation."},
     {"word": "investigate", "meaning": "調査する", "example": "ドラえもんは、事件を調査した。", "translation": "Doraemon investigated the incident."},
     {"word": "creativity", "meaning": "創造性", "example": "ドラえもんは、創造性に溢れている。", "translation": "Doraemon is full of creativity."},
     {"word": "rural", "meaning": "田舎の", "example": "ドラえもんは、田舎でゆっくり過ごした。", "translation": "Doraemon had a relaxing time in the rural countryside."},
     {"word": "announcement", "meaning": "発表", "example": "ドラえもんは、重要な発表をした。", "translation": "Doraemon made an important announcement."},
     {"word": "rely", "meaning": "頼る", "example": "ドラえもんは、いつも友達を頼りにしている。", "translation": "Doraemon always relies on his friends."},
     {"word": "atmosphere", "meaning": "雰囲気", "example": "ドラえもんは、楽しい雰囲気を作ろうとした。", "translation": "Doraemon tried to create a fun atmosphere."},
     {"word": "extend", "meaning": "広げる", "example": "ドラえもんは、活動範囲を広げようとしている。", "translation": "Doraemon is trying to extend his range of activity."}
     ];
     break;
     case "高校英語97":
     item = [
     {"word": "internal", "meaning": "内部の", "example": "ドラえもんは、機械の内部構造を見た。", "translation": "Doraemon looked at the internal structure of the machine."},
     {"word": "magnify", "meaning": "拡大する", "example": "ドラえもんは、顕微鏡で細胞を拡大した。", "translation": "Doraemon magnified cells with a microscope."},
     {"word": "slavery", "meaning": "奴隷制度", "example": "ドラえもんは、奴隷制度のない世界を望んでいる。", "translation": "Doraemon wishes for a world without slavery."},
     {"word": "additive", "meaning": "添加物", "example": "ドラえもんは、添加物の少ない食べ物を選んだ。", "translation": "Doraemon chose foods with fewer additives."},
     {"word": "cooker", "meaning": "調理器", "example": "ドラえもんは、便利な調理器を使った。", "translation": "Doraemon used a convenient cooker."},
     {"word": "segment", "meaning": "区分", "example": "ドラえもんは、計画を区分ごとに分けた。", "translation": "Doraemon divided the plan into segments."},
     {"word": "revive", "meaning": "復活させる", "example": "ドラえもんは、絶滅した動物を復活させようとした。", "translation": "Doraemon tried to revive an extinct animal."},
     {"word": "ecology", "meaning": "生態学", "example": "ドラえもんは、生態学について学んだ。", "translation": "Doraemon studied ecology."},
     {"word": "modest", "meaning": "控えめな", "example": "ドラえもんは、謙虚で控えめな性格だ。", "translation": "Doraemon is humble and modest."},
     {"word": "buildup", "meaning": "蓄積", "example": "ドラえもんは、知識の蓄積を大切にしている。", "translation": "Doraemon values the buildup of knowledge."}
     ];
     break;
     case "高校英語98":
     item = [
     {"word": "romantic", "meaning": "ロマンチックな", "example": "ドラえもんは、ロマンチックな物語を読んだ。", "translation": "Doraemon read a romantic story."},
     {"word": "authority", "meaning": "権威", "example": "ドラえもんは、権威に屈しない。", "translation": "Doraemon does not yield to authority."},
     {"word": "lower", "meaning": "下げる", "example": "ドラえもんは、音量を下げた。", "translation": "Doraemon lowered the volume."},
     {"word": "initially", "meaning": "最初は", "example": "ドラえもんは、最初は失敗したが、最後は成功した。", "translation": "Initially, Doraemon failed, but in the end he succeeded."},
     {"word": "rebuild", "meaning": "再建する", "example": "ドラえもんは、壊れた家を再建した。", "translation": "Doraemon rebuilt the broken house."},
     {"word": "resemble", "meaning": "似ている", "example": "ドラえもんは、過去の自分に似ている。", "translation": "Doraemon resembles his past self."},
     {"word": "bald", "meaning": "禿げた", "example": "ドラえもんは、おじいさんが禿げているのに驚いた。", "translation": "Doraemon was surprised that the old man was bald."},
     {"word": "catastrophe", "meaning": "大災害", "example": "ドラえもんは、大災害を阻止した。", "translation": "Doraemon prevented a catastrophe."},
     {"word": "smuggle", "meaning": "密輸する", "example": "ドラえもんは、密輸を阻止しようとした。", "translation": "Doraemon tried to stop smuggling."},
     {"word": "decent", "meaning": "きちんとした", "example": "ドラえもんは、いつもきちんと服を着ている。", "translation": "Doraemon always wears decent clothes."}
     ];
     break;
     case "高校英語99":
     item = [
     {"word": "coupon", "meaning": "クーポン", "example": "ドラえもんは、クーポンでお得に買い物をした。", "translation": "Doraemon got a good deal using a coupon."},
     {"word": "restrict", "meaning": "制限する", "example": "ドラえもんは、道具の使用を制限した。", "translation": "Doraemon restricted the use of the gadgets."},
     {"word": "solo", "meaning": "単独で", "example": "ドラえもんは、単独で冒険に出かけた。", "translation": "Doraemon went on a solo adventure."},
     {"word": "soil", "meaning": "土", "example": "ドラえもんは、土に触れるのが好きだ。", "translation": "Doraemon likes to touch soil."},
     {"word": "contrast", "meaning": "対照", "example": "ドラえもんは、過去と未来を対照して見た。", "translation": "Doraemon compared and contrasted the past and future."},
     {"word": "consequence", "meaning": "結果", "example": "ドラえもんは、行動の結果を考えた。", "translation": "Doraemon thought about the consequences of his actions."},
     {"word": "facility", "meaning": "施設", "example": "ドラえもんは、未来の施設を見学した。", "translation": "Doraemon visited a facility in the future."},
     {"word": "anxiety", "meaning": "不安", "example": "ドラえもんは、少し不安を感じている。", "translation": "Doraemon is feeling a little anxiety."},
     {"word": "commonly", "meaning": "一般的に", "example": "ドラえもんは、一般的に知られていることを知っている。", "translation": "Doraemon knows what is commonly known."},
     {"word": "hesitate", "meaning": "ためらう", "example": "のび太は、いつも行動をためらう。", "translation": "Nobita always hesitates to act."}
     ];
     break;
     case "高校英語100":
     item = [
     {"word": "literally", "meaning": "文字通りに", "example": "ドラえもんは、文字通りの意味で捉えた。", "translation": "Doraemon took the meaning literally."},
     {"word": "contaminate", "meaning": "汚染する", "example": "ドラえもんは、環境を汚染しないように注意している。", "translation": "Doraemon is careful not to contaminate the environment."},
     {"word": "vision", "meaning": "視力", "example": "ドラえもんの視力はとても良い。", "translation": "Doraemon has excellent vision."},
     {"word": "motive", "meaning": "動機", "example": "ドラえもんは、犯人の動機を調べた。", "translation": "Doraemon investigated the motive of the criminal."},
     {"word": "stance", "meaning": "立場", "example": "ドラえもんは、中立な立場をとる。", "translation": "Doraemon takes a neutral stance."},
     {"word": "complex", "meaning": "複雑な", "example": "ドラえもんは、複雑な問題を解決した。", "translation": "Doraemon solved a complex problem."},
     {"word": "argument", "meaning": "議論", "example": "ドラえもんは、議論することを避けた。", "translation": "Doraemon avoided the argument."},
     {"word": "hint", "meaning": "ヒント", "example": "ドラえもんは、のび太にヒントを与えた。", "translation": "Doraemon gave Nobita a hint."},
     {"word": "shelf", "meaning": "棚", "example": "ドラえもんは、棚に本を並べた。", "translation": "Doraemon placed the books on the shelf."},
     {"word": "confuse", "meaning": "混乱させる", "example": "ドラえもんは、のび太を混乱させるようなことは言わない。", "translation": "Doraemon does not say anything to confuse Nobita."}
     ];
     break;
    
     
     case "高校英語101":
     item = [
     {"word": "affectionate", "meaning": "愛情深い", "example": "ドラえもんは、のび太に愛情深い。", "translation": "Doraemon is affectionate towards Nobita."},
     {"word": "modify", "meaning": "修正する", "example": "ドラえもんは、道具を少し修正した。", "translation": "Doraemon slightly modified his gadget."},
     {"word": "personnel", "meaning": "職員", "example": "ドラえもんは、未来の会社の職員に話を聞いた。", "translation": "Doraemon spoke with personnel of a future company."},
     {"word": "implant", "meaning": "移植する", "example": "ドラえもんは、未来の技術を使って記憶を移植した。", "translation": "Doraemon implanted his memory using future technology."},
     {"word": "inquiry", "meaning": "問い合わせ", "example": "ドラえもんは、図書館で資料について問い合わせた。", "translation": "Doraemon made an inquiry about the materials at the library."},
     {"word": "infant", "meaning": "幼児", "example": "ドラえもんは、幼児に優しく接した。", "translation": "Doraemon treated the infant gently."},
     {"word": "rating", "meaning": "評価", "example": "ドラえもんは、テレビ番組の評価を気にした。", "translation": "Doraemon cared about the rating of the TV program."},
     {"word": "haunt", "meaning": "つきまとう", "example": "ドラえもんは、過去の出来事に悩まされていた。", "translation": "Doraemon was haunted by past events."},
     {"word": "behavioral", "meaning": "行動の", "example": "ドラえもんは、のび太の行動を分析した。", "translation": "Doraemon analyzed Nobita's behavioral patterns."},
     {"word": "recruit", "meaning": "採用する", "example": "ドラえもんは、新しい仲間を募集した。", "translation": "Doraemon recruited new members."}
     ];
     break;
     case "高校英語102":
     item = [
     {"word": "ban", "meaning": "禁止する", "example": "ドラえもんは、危険な道具の使用を禁止した。", "translation": "Doraemon banned the use of dangerous gadgets."},
     {"word": "clue", "meaning": "手がかり", "example": "ドラえもんは、事件解決の手がかりを探した。", "translation": "Doraemon looked for a clue to solve the case."},
     {"word": "jumbo", "meaning": "巨大な", "example": "ドラえもんは、巨大な象を見て驚いた。", "translation": "Doraemon was surprised to see a jumbo elephant."},
     {"word": "wealthy", "meaning": "裕福な", "example": "スネ夫は、とても裕福な家庭で育った。", "translation": "Suneo grew up in a wealthy family."},
     {"word": "intention", "meaning": "意図", "example": "ドラえもんは、友達を助けるという意図をもって行動した。", "translation": "Doraemon acted with the intention of helping his friends."},
     {"word": "mission", "meaning": "任務", "example": "ドラえもんは、のび太を助けるという任務を遂行した。", "translation": "Doraemon accomplished his mission to help Nobita."},
     {"word": "layer", "meaning": "層", "example": "ドラえもんは、地層を調べた。", "translation": "Doraemon investigated the layers of the earth."},
     {"word": "fur", "meaning": "毛皮", "example": "ドラえもんは、毛皮のコートを着て暖かくした。", "translation": "Doraemon wore a fur coat to keep warm."},
     {"word": "considerable", "meaning": "かなりの", "example": "ドラえもんは、かなりの量のどら焼きを消費した。", "translation": "Doraemon consumed a considerable amount of dorayaki."},
     {"word": "eagle", "meaning": "ワシ", "example": "ドラえもんは、空を飛ぶワシを見た。", "translation": "Doraemon saw an eagle flying in the sky."}
     ];
     break;
     case "高校英語103":
     item = [
     {"word": "extract", "meaning": "抽出する", "example": "ドラえもんは、植物からエキスを抽出した。", "translation": "Doraemon extracted essence from the plant."},
     {"word": "agonize", "meaning": "苦悩する", "example": "ドラえもんは、問題解決に苦悩した。", "translation": "Doraemon agonized over how to solve the problem."},
     {"word": "bind", "meaning": "縛る", "example": "ドラえもんは、ひもで物を縛った。", "translation": "Doraemon bound the object with string."},
     {"word": "principal", "meaning": "校長", "example": "ドラえもんは、学校の校長に会った。", "translation": "Doraemon met with the school principal."},
     {"word": "vomit", "meaning": "吐く", "example": "のび太は、乗り物酔いで吐いてしまった。", "translation": "Nobita vomited due to motion sickness."},
     {"word": "refer", "meaning": "参照する", "example": "ドラえもんは、資料を参照した。", "translation": "Doraemon referred to the materials."},
     {"word": "insist", "meaning": "主張する", "example": "ドラえもんは、自分の意見を主張した。", "translation": "Doraemon insisted on his opinion."},
     {"word": "manual", "meaning": "説明書", "example": "ドラえもんは、道具の説明書を読んだ。", "translation": "Doraemon read the manual for the gadget."},
     {"word": "withdraw", "meaning": "撤退する", "example": "ドラえもんは、敵から撤退した。", "translation": "Doraemon withdrew from the enemy."},
     {"word": "cassette", "meaning": "カセット", "example": "ドラえもんは、古いカセットテープを聞いた。", "translation": "Doraemon listened to an old cassette tape."}
     ];
     break;
     case "高校英語104":
     item = [
     {"word": "version", "meaning": "版", "example": "ドラえもんは、道具の新しいバージョンを使った。", "translation": "Doraemon used a new version of his gadget."},
     {"word": "threaten", "meaning": "脅す", "example": "ジャイアンは、いつも友達を脅している。", "translation": "Gian is always threatening his friends."},
     {"word": "pal", "meaning": "友達", "example": "ドラえもんは、のび太を親友と呼ぶ。", "translation": "Doraemon calls Nobita his pal."},
     {"word": "campaign", "meaning": "運動", "example": "ドラえもんは、環境保護運動に参加した。", "translation": "Doraemon participated in an environmental protection campaign."},
     {"word": "attractive", "meaning": "魅力的な", "example": "ドラえもんは、魅力的な笑顔をしている。", "translation": "Doraemon has an attractive smile."},
     {"word": "enjoyable", "meaning": "楽しい", "example": "ドラえもんとの時間は、いつも楽しい。", "translation": "Time with Doraemon is always enjoyable."},
     {"word": "stare", "meaning": "見つめる", "example": "ドラえもんは、空をじっと見つめていた。", "translation": "Doraemon was staring at the sky."},
     {"word": "horror", "meaning": "恐怖", "example": "ドラえもんは、恐怖映画を見て怖くなった。", "translation": "Doraemon was scared after watching a horror movie."},
     {"word": "command", "meaning": "命令する", "example": "ドラえもんは、ロボットに命令を下した。", "translation": "Doraemon gave a command to the robot."},
     {"word": "receipt", "meaning": "レシート", "example": "ドラえもんは、買い物のレシートを受け取った。", "translation": "Doraemon received a receipt for his purchase."}
     ];
     break;
     case "高校英語105":
     item = [
     {"word": "fitness", "meaning": "健康", "example": "ドラえもんは、健康のために運動をする。", "translation": "Doraemon exercises for fitness."},
     {"word": "domestic", "meaning": "国内の", "example": "ドラえもんは、国内の旅行を楽しんだ。", "translation": "Doraemon enjoyed domestic travel."},
     {"word": "cough", "meaning": "咳", "example": "のび太は、風邪で咳をしている。", "translation": "Nobita is coughing because of a cold."},
     {"word": "recording", "meaning": "録音", "example": "ドラえもんは、音声を録音した。", "translation": "Doraemon made an audio recording."},
     {"word": "resolve", "meaning": "解決する", "example": "ドラえもんは、問題を解決しようとした。", "translation": "Doraemon tried to resolve the problem."},
     {"word": "strategy", "meaning": "戦略", "example": "ドラえもんは、戦略を立てて戦った。", "translation": "Doraemon fought with a strategy."},
     {"word": "possess", "meaning": "所有する", "example": "ドラえもんは、たくさんの秘密道具を所有している。", "translation": "Doraemon possesses many secret gadgets."},
     {"word": "client", "meaning": "依頼人", "example": "ドラえもんは、依頼人の問題を解決した。", "translation": "Doraemon solved a problem for his client."},
     {"word": "minimum", "meaning": "最小限", "example": "ドラえもんは、最小限のエネルギーで動いた。", "translation": "Doraemon moved using minimum energy."},
     {"word": "immigrant", "meaning": "移民", "example": "ドラえもんは、移民の人々と交流した。", "translation": "Doraemon interacted with immigrants."}
     ];
     break;
     case "高校英語106":
     item = [
     {"word": "mainly", "meaning": "主として", "example": "ドラえもんは、主としてみんなを助けている。", "translation": "Doraemon is mainly helping everyone."},
     {"word": "current", "meaning": "現在の", "example": "ドラえもんは、現在の出来事を知っている。", "translation": "Doraemon knows about current events."},
     {"word": "librarian", "meaning": "図書館司書", "example": "ドラえもんは、図書館司書に質問した。", "translation": "Doraemon asked a librarian a question."},
     {"word": "ensure", "meaning": "保証する", "example": "ドラえもんは、安全を保証した。", "translation": "Doraemon ensured safety."},
     {"word": "entire", "meaning": "全体の", "example": "ドラえもんは、全体の状況を見た。", "translation": "Doraemon saw the entire situation."},
     {"word": "newscaster", "meaning": "ニュースキャスター", "example": "ドラえもんは、ニュースキャスターの仕事をした。", "translation": "Doraemon worked as a newscaster."},
     {"word": "distract", "meaning": "気をそらす", "example": "ドラえもんは、敵の気をそらした。", "translation": "Doraemon distracted the enemy."},
     {"word": "utility", "meaning": "実用性", "example": "ドラえもんの道具は、実用性がある。", "translation": "Doraemon's gadgets have practicality and utility."},
     {"word": "rewrite", "meaning": "書き直す", "example": "ドラえもんは、物語を書き直した。", "translation": "Doraemon rewrote the story."},
     {"word": "coherent", "meaning": "筋の通った", "example": "ドラえもんは、筋の通った説明をした。", "translation": "Doraemon gave a coherent explanation."}
     ];
     break;
     case "高校英語107":
     item = [
     {"word": "deliberate", "meaning": "意図的な", "example": "ドラえもんは、意図的にその場所へ行った。", "translation": "Doraemon went to that place deliberately."},
     {"word": "ignition", "meaning": "点火", "example": "ドラえもんは、ロケットの点火ボタンを押した。", "translation": "Doraemon pressed the ignition button on the rocket."},
     {"word": "distinct", "meaning": "明確な", "example": "ドラえもんは、明確な区別をつけている。", "translation": "Doraemon makes a distinct differentiation."},
     {"word": "tender", "meaning": "優しい", "example": "ドラえもんは、いつも優しい心を持っている。", "translation": "Doraemon always has a tender heart."},
     {"word": "fry", "meaning": "揚げる", "example": "ドラえもんは、料理を揚げて作った。", "translation": "Doraemon made a dish by frying it."},
     {"word": "retrieve", "meaning": "取り戻す", "example": "ドラえもんは、失われた道具を取り戻した。", "translation": "Doraemon retrieved the lost gadget."},
     {"word": "instance", "meaning": "例", "example": "例えば、ドラえもんはいつも手伝ってくれる。", "translation": "For instance, Doraemon always helps me."},
     {"word": "minister", "meaning": "大臣", "example": "ドラえもんは、未来の大臣に会った。", "translation": "Doraemon met a minister from the future."},
     {"word": "conclude", "meaning": "結論づける", "example": "ドラえもんは、推理して結論づけた。", "translation": "Doraemon concluded by reasoning."},
     {"word": "populate", "meaning": "住まわせる", "example": "ドラえもんは、月を人に住まわせる計画について知っている。", "translation": "Doraemon knows the plan to populate the moon with people."}
     ];
     break;
     case "高校英語108":
     item = [
     {"word": "workplace", "meaning": "職場", "example": "ドラえもんは、未来の職場を見学した。", "translation": "Doraemon visited a workplace of the future."},
     {"word": "currency", "meaning": "通貨", "example": "ドラえもんは、未来の通貨を使った。", "translation": "Doraemon used future currency."},
     {"word": "toxic", "meaning": "有毒な", "example": "ドラえもんは、有毒なガスを避けた。", "translation": "Doraemon avoided the toxic gas."},
     {"word": "technically", "meaning": "技術的に", "example": "ドラえもんは、技術的に難しい問題を解決した。", "translation": "Doraemon solved the problem technically."},
     {"word": "ignorant", "meaning": "無知な", "example": "のび太は、無知なためにいつも失敗する。", "translation": "Nobita always fails due to his ignorance."},
     {"word": "undergo", "meaning": "経験する", "example": "ドラえもんは、厳しい訓練を受けた。", "translation": "Doraemon underwent rigorous training."},
     {"word": "soak", "meaning": "浸す", "example": "ドラえもんは、熱いお湯にゆっくり浸かった。", "translation": "Doraemon soaked himself in hot water."},
     {"word": "disabled", "meaning": "障害のある", "example": "ドラえもんは、障害のある人を助けた。", "translation": "Doraemon helped people with disabilities."},
     {"word": "submarine", "meaning": "潜水艦", "example": "ドラえもんは、潜水艦で海の中を探検した。", "translation": "Doraemon explored the sea in a submarine."},
     {"word": "fade", "meaning": "薄れる", "example": "ドラえもんは、記憶が薄れていくのを心配した。", "translation": "Doraemon was worried that his memories were fading."}
     ];
     break;
     case "高校英語109":
     item = [
     {"word": "oppress", "meaning": "抑圧する", "example": "ドラえもんは、人々を抑圧する行為を嫌う。", "translation": "Doraemon dislikes actions that oppress people."},
     {"word": "liberate", "meaning": "解放する", "example": "ドラえもんは、捕らえられていた動物を解放した。", "translation": "Doraemon liberated the captured animals."},
     {"word": "desperate", "meaning": "必死の", "example": "のび太は、必死になってドラえもんに助けを求めた。", "translation": "Nobita desperately asked Doraemon for help."},
     {"word": "salesperson", "meaning": "販売員", "example": "ドラえもんは、未来の販売員と話をした。", "translation": "Doraemon spoke with a salesperson from the future."},
     {"word": "herd", "meaning": "群れ", "example": "ドラえもんは、たくさんの羊の群れを見た。", "translation": "Doraemon saw a herd of sheep."},
     {"word": "moist", "meaning": "湿った", "example": "ドラえもんは、湿った場所が苦手だ。", "translation": "Doraemon dislikes moist places."},
     {"word": "chilly", "meaning": "肌寒い", "example": "ドラえもんは、肌寒い夜に暖かい服を着た。", "translation": "Doraemon wore warm clothes on a chilly night."},
     {"word": "abundant", "meaning": "豊富な", "example": "ドラえもんは、豊富な道具を持っている。", "translation": "Doraemon has abundant gadgets."},
     {"word": "mount", "meaning": "乗る", "example": "ドラえもんは、ロケットに乗って宇宙へ行った。", "translation": "Doraemon mounted a rocket and went to space."},
     {"word": "democracy", "meaning": "民主主義", "example": "ドラえもんは、民主主義の大切さを学んだ。", "translation": "Doraemon learned the importance of democracy."}
     ];
     break;
     case "高校英語110":
     item = [
     {"word": "pursue", "meaning": "追求する", "example": "ドラえもんは、夢を追求する大切さを知っている。", "translation": "Doraemon knows the importance of pursuing one's dreams."},
     {"word": "acceptable", "meaning": "受け入れられる", "example": "ドラえもんは、みんなが受け入れられる解決策を見つけた。", "translation": "Doraemon found a solution that was acceptable to everyone."},
     {"word": "transfer", "meaning": "移す", "example": "ドラえもんは、エネルギーを移す道具を使った。", "translation": "Doraemon used a gadget to transfer energy."},
     {"word": "farming", "meaning": "農業", "example": "ドラえもんは、未来の農業技術を学んだ。", "translation": "Doraemon learned about future farming technology."},
     {"word": "raincoat", "meaning": "レインコート", "example": "ドラえもんは、雨の日にレインコートを着た。", "translation": "Doraemon wore a raincoat on a rainy day."},
     {"word": "clown", "meaning": "道化師", "example": "ドラえもんは、ピエロを見て笑った。", "translation": "Doraemon laughed watching the clown."},
     {"word": "fossil", "meaning": "化石", "example": "ドラえもんは、古代の化石を発掘した。", "translation": "Doraemon excavated an ancient fossil."},
     {"word": "caption", "meaning": "説明文", "example": "ドラえもんは、写真に説明文を付けた。", "translation": "Doraemon added a caption to the photo."},
     {"word": "sphere", "meaning": "球体", "example": "ドラえもんは、球体の道具を使って遊んだ。", "translation": "Doraemon played with a spherical gadget."},
     {"word": "boast", "meaning": "自慢する", "example": "ジャイアンは、いつも自分の力を自慢する。", "translation": "Gian always boasts about his power."}
     ];
     break;
    
     
     case "高校英語111":
     item = [
     {"word": "trial", "meaning": "裁判", "example": "ドラえもんは、未来の裁判を見学した。", "translation": "Doraemon visited a trial in the future."},
     {"word": "nevertheless", "meaning": "それにもかかわらず", "example": "ドラえもんは、困難にもかかわらず諦めなかった。", "translation": "Doraemon did not give up, nevertheless, he faced difficulties."},
     {"word": "complicated", "meaning": "複雑な", "example": "ドラえもんは、複雑な問題を解いた。", "translation": "Doraemon solved a complicated problem."},
     {"word": "witness", "meaning": "目撃者", "example": "ドラえもんは、事件の目撃者になった。", "translation": "Doraemon became a witness to the incident."},
     {"word": "preserve", "meaning": "保護する", "example": "ドラえもんは、自然を保護することを大切にしている。", "translation": "Doraemon values preserving nature."},
     {"word": "council", "meaning": "評議会", "example": "ドラえもんは、未来の評議会に参加した。", "translation": "Doraemon participated in a future council."},
     {"word": "otherwise", "meaning": "さもなければ", "example": "ドラえもんは、「さもなければ、大変なことになるよ」と言った。", "translation": "Doraemon said, 'Otherwise, it will be a disaster'."},
     {"word": "requirement", "meaning": "要件", "example": "ドラえもんは、必要な要件を全て満たした。", "translation": "Doraemon fulfilled all the requirements."},
     {"word": "thus", "meaning": "したがって", "example": "ドラえもんは、したがってそう結論付けた。", "translation": "Thus, Doraemon came to that conclusion."},
     {"word": "underground", "meaning": "地下の", "example": "ドラえもんは、地下の秘密基地を作った。", "translation": "Doraemon built an underground secret base."}
     ];
     break;
     case "高校英語112":
     item = [
     {"word": "independence", "meaning": "独立", "example": "ドラえもんは、独立して行動できる。", "translation": "Doraemon can act independently."},
     {"word": "palm", "meaning": "手のひら", "example": "ドラえもんは、手のひらに道具を乗せた。", "translation": "Doraemon placed the gadget on his palm."},
     {"word": "analysis", "meaning": "分析", "example": "ドラえもんは、状況を分析した。", "translation": "Doraemon conducted an analysis of the situation."},
     {"word": "violence", "meaning": "暴力", "example": "ドラえもんは、暴力を嫌う。", "translation": "Doraemon dislikes violence."},
     {"word": "slash", "meaning": "切りつける", "example": "ドラえもんは、敵を切りつける。", "translation": "Doraemon slashed at the enemy."},
     {"word": "prosper", "meaning": "繁栄する", "example": "ドラえもんは、人々が繁栄することを願っている。", "translation": "Doraemon hopes that people will prosper."},
     {"word": "diploma", "meaning": "卒業証書", "example": "ドラえもんは、未来の学校で卒業証書を受け取った。", "translation": "Doraemon received his diploma at a future school."},
     {"word": "classic", "meaning": "古典的な", "example": "ドラえもんは、古典的な音楽を聴く。", "translation": "Doraemon listens to classical music."},
     {"word": "scribble", "meaning": "走り書きする", "example": "ドラえもんは、メモを走り書きした。", "translation": "Doraemon scribbled a note."},
     {"word": "conceal", "meaning": "隠す", "example": "ドラえもんは、秘密道具を隠した。", "translation": "Doraemon concealed his secret gadgets."}
     ];
     break;
     case "高校英語113":
     item = [
     {"word": "blaze", "meaning": "炎", "example": "ドラえもんは、燃え盛る炎を消そうとした。", "translation": "Doraemon tried to put out the blaze."},
     {"word": "petrol", "meaning": "ガソリン", "example": "ドラえもんは、ガソリンを入れて車を動かした。", "translation": "Doraemon put petrol in the car and drove it."},
     {"word": "viable", "meaning": "実行可能な", "example": "ドラえもんは、実行可能な計画を立てた。", "translation": "Doraemon made a viable plan."},
     {"word": "planning", "meaning": "計画", "example": "ドラえもんは、イベントの計画を立てた。", "translation": "Doraemon made a plan for the event."},
     {"word": "lifelong", "meaning": "生涯にわたる", "example": "ドラえもんは、生涯にわたって友達を大切にする。", "translation": "Doraemon values his friends for a lifelong relationship."},
     {"word": "govern", "meaning": "統治する", "example": "ドラえもんは、未来の都市を統治するシステムを視察した。", "translation": "Doraemon inspected the system of governing future cities."},
     {"word": "contribute", "meaning": "貢献する", "example": "ドラえもんは、社会に貢献したいと考えている。", "translation": "Doraemon wants to contribute to society."},
     {"word": "appreciate", "meaning": "感謝する", "example": "ドラえもんは、友達にいつも感謝している。", "translation": "Doraemon is always grateful to his friends."},
     {"word": "tasty", "meaning": "美味しい", "example": "ドラえもんは、美味しいどら焼きを食べて満足した。", "translation": "Doraemon was satisfied after eating a tasty dorayaki."},
     {"word": "compete", "meaning": "競う", "example": "ドラえもんは、ゲームで友達と競った。", "translation": "Doraemon competed with his friends in a game."}
     ];
     break;
     case "高校英語114":
     item = [
     {"word": "assert", "meaning": "主張する", "example": "ドラえもんは、自分の意見を主張した。", "translation": "Doraemon asserted his opinion."},
     {"word": "thread", "meaning": "糸", "example": "ドラえもんは、糸を使って縫い物をした。", "translation": "Doraemon used a thread to sew."},
     {"word": "pose", "meaning": "姿勢", "example": "ドラえもんは、写真を撮るためにポーズをとった。", "translation": "Doraemon posed for a photo."},
     {"word": "glance", "meaning": "ちらっと見る", "example": "ドラえもんは、時間をちらっと見た。", "translation": "Doraemon glanced at the time."},
     {"word": "management", "meaning": "経営", "example": "ドラえもんは、未来の会社の経営方法を学んだ。", "translation": "Doraemon learned about the management methods of a future company."},
     {"word": "trek", "meaning": "長旅", "example": "ドラえもんは、長い山道の旅をした。", "translation": "Doraemon went on a long mountain trek."},
     {"word": "disguise", "meaning": "変装", "example": "ドラえもんは、変装して街を歩いた。", "translation": "Doraemon walked through the town in disguise."},
     {"word": "trousers", "meaning": "ズボン", "example": "ドラえもんは、新しいズボンを履いてみた。", "translation": "Doraemon tried on new trousers."},
     {"word": "garlic", "meaning": "ニンニク", "example": "ドラえもんは、料理にニンニクを使った。", "translation": "Doraemon used garlic in his cooking."},
     {"word": "conditional", "meaning": "条件付きの", "example": "ドラえもんは、条件付きで道具を貸した。", "translation": "Doraemon lent the gadget with a conditional agreement."}
     ];
     break;
     case "高校英語115":
     item = [
     {"word": "wage", "meaning": "賃金", "example": "ドラえもんは、未来の仕事で賃金をもらった。", "translation": "Doraemon received wages for his work in the future."},
     {"word": "leadership", "meaning": "指導力", "example": "ドラえもんは、みんなをまとめる指導力がある。", "translation": "Doraemon has the leadership to unite everyone."},
     {"word": "circumstance", "meaning": "状況", "example": "ドラえもんは、状況を判断して行動した。", "translation": "Doraemon assessed the circumstance and acted."},
     {"word": "mineral", "meaning": "鉱物", "example": "ドラえもんは、鉱物を採取した。", "translation": "Doraemon collected minerals."},
     {"word": "liquid", "meaning": "液体", "example": "ドラえもんは、不思議な液体を飲んだ。", "translation": "Doraemon drank a mysterious liquid."},
     {"word": "amuse", "meaning": "楽しませる", "example": "ドラえもんは、のび太を楽しませようと努力した。", "translation": "Doraemon tried to amuse Nobita."},
     {"word": "lately", "meaning": "最近", "example": "ドラえもんは、最近少し疲れている。", "translation": "Lately, Doraemon has been feeling a little tired."},
     {"word": "accurate", "meaning": "正確な", "example": "ドラえもんは、正確に時間を測った。", "translation": "Doraemon measured the time accurately."},
     {"word": "agenda", "meaning": "議題", "example": "ドラえもんは、会議の議題を確認した。", "translation": "Doraemon checked the agenda for the meeting."},
     {"word": "proponent", "meaning": "支持者", "example": "ドラえもんは、新しい技術の支持者になった。", "translation": "Doraemon became a proponent of new technology."}
     ];
     break;
     case "高校英語116":
     item = [
     {"word": "enroll", "meaning": "登録する", "example": "ドラえもんは、未来の学校に登録した。", "translation": "Doraemon enrolled in a future school."},
     {"word": "investigation", "meaning": "調査", "example": "ドラえもんは、事件の調査をした。", "translation": "Doraemon conducted an investigation of the incident."},
     {"word": "firefighter", "meaning": "消防士", "example": "ドラえもんは、消防士の仕事を見学した。", "translation": "Doraemon observed the work of a firefighter."},
     {"word": "sorrow", "meaning": "悲しみ", "example": "ドラえもんは、悲しんでいる人に寄り添った。", "translation": "Doraemon was there for the people who were in sorrow."},
     {"word": "cuisine", "meaning": "料理", "example": "ドラえもんは、色々な国の料理に挑戦した。", "translation": "Doraemon tried cooking dishes from various countries."},
     {"word": "congratulate", "meaning": "祝福する", "example": "ドラえもんは、みんなの成功を祝福した。", "translation": "Doraemon congratulated everyone on their success."},
     {"word": "engage", "meaning": "従事する", "example": "ドラえもんは、環境保護活動に従事した。", "translation": "Doraemon engaged in environmental protection activities."},
     {"word": "organic", "meaning": "有機的な", "example": "ドラえもんは、有機野菜を栽培した。", "translation": "Doraemon cultivated organic vegetables."},
     {"word": "ease", "meaning": "和らげる", "example": "ドラえもんは、のび太の痛みを和らげた。", "translation": "Doraemon eased Nobita's pain."},
     {"word": "patch", "meaning": "つぎ", "example": "ドラえもんは、ズボンの穴をパッチで塞いだ。", "translation": "Doraemon covered the hole in his trousers with a patch."}
     ];
     break;
     case "高校英語117":
     item = [
     {"word": "tank", "meaning": "タンク", "example": "ドラえもんは、ガソリンタンクを満タンにした。", "translation": "Doraemon filled the gasoline tank."},
     {"word": "entirely", "meaning": "完全に", "example": "ドラえもんは、完全に問題を解決した。", "translation": "Doraemon completely solved the problem."},
     {"word": "condemn", "meaning": "非難する", "example": "ドラえもんは、暴力行為を非難した。", "translation": "Doraemon condemned the violent act."},
     {"word": "overtake", "meaning": "追い越す", "example": "ドラえもんは、前の車を追い越した。", "translation": "Doraemon overtook the car in front of him."},
     {"word": "fright", "meaning": "恐怖", "example": "ドラえもんは、恐怖を感じた。", "translation": "Doraemon felt a fright."},
     {"word": "humiliate", "meaning": "屈辱を与える", "example": "ドラえもんは、誰かを屈辱的に扱うことを嫌う。", "translation": "Doraemon dislikes treating anyone in a humiliating way."},
     {"word": "variable", "meaning": "変わりやすい", "example": "ドラえもんは、変わりやすい天気に対応した。", "translation": "Doraemon responded to the variable weather."},
     {"word": "conclusion", "meaning": "結論", "example": "ドラえもんは、推理して結論を導き出した。", "translation": "Doraemon came to a conclusion through reasoning."},
     {"word": "scatter", "meaning": "まき散らす", "example": "ドラえもんは、種をまき散らした。", "translation": "Doraemon scattered seeds."},
     {"word": "genuine", "meaning": "本物の", "example": "ドラえもんは、本物の友情を大切にしている。", "translation": "Doraemon values genuine friendship."}
     ];
     break;
     case "高校英語118":
     item = [
     {"word": "punctual", "meaning": "時間厳守の", "example": "ドラえもんは、いつも時間厳守だ。", "translation": "Doraemon is always punctual."},
     {"word": "initial", "meaning": "最初の", "example": "ドラえもんは、最初の計画を実行した。", "translation": "Doraemon executed his initial plan."},
     {"word": "snowboard", "meaning": "スノーボード", "example": "ドラえもんは、雪山でスノーボードをした。", "translation": "Doraemon went snowboarding on the snowy mountain."},
     {"word": "dominate", "meaning": "支配する", "example": "ドラえもんは、悪いやつが世界を支配するのを阻止した。", "translation": "Doraemon prevented evil beings from dominating the world."},
     {"word": "neglect", "meaning": "無視する", "example": "ドラえもんは、問題を無視しなかった。", "translation": "Doraemon did not neglect the problem."},
     {"word": "era", "meaning": "時代", "example": "ドラえもんは、恐竜時代へ行った。", "translation": "Doraemon went to the dinosaur era."},
     {"word": "motorbike", "meaning": "バイク", "example": "ドラえもんは、バイクで走り出した。", "translation": "Doraemon set off on a motorbike."},
     {"word": "priority", "meaning": "優先順位", "example": "ドラえもんは、友達を助けることを優先した。", "translation": "Doraemon prioritized helping his friends."},
     {"word": "habitat", "meaning": "生息地", "example": "ドラえもんは、動物の生息地を守った。", "translation": "Doraemon protected the habitat of animals."},
     {"word": "biography", "meaning": "伝記", "example": "ドラえもんは、有名な科学者の伝記を読んだ。", "translation": "Doraemon read the biography of a famous scientist."}
     ];
     break;
     case "高校英語119":
     item = [
     {"word": "chimpanzee", "meaning": "チンパンジー", "example": "ドラえもんは、動物園でチンパンジーを見た。", "translation": "Doraemon saw a chimpanzee at the zoo."},
     {"word": "obviously", "meaning": "明らかに", "example": "ドラえもんは、明らかに困っていた。", "translation": "Doraemon was obviously in trouble."},
     {"word": "available", "meaning": "利用可能な", "example": "ドラえもんは、利用可能な道具をすべて使った。", "translation": "Doraemon used all the available gadgets."},
     {"word": "tumble", "meaning": "転ぶ", "example": "のび太は、いつも転んでしまう。", "translation": "Nobita always tumbles."},
     {"word": "allocate", "meaning": "割り当てる", "example": "ドラえもんは、役割を割り当てた。", "translation": "Doraemon allocated the roles."},
     {"word": "specialist", "meaning": "専門家", "example": "ドラえもんは、専門家と意見交換をした。", "translation": "Doraemon exchanged views with a specialist."},
     {"word": "keen", "meaning": "熱心な", "example": "ドラえもんは、勉強に熱心だ。", "translation": "Doraemon is keen on studying."},
     {"word": "invasion", "meaning": "侵略", "example": "ドラえもんは、宇宙からの侵略を阻止した。", "translation": "Doraemon prevented an invasion from space."},
     {"word": "triumph", "meaning": "勝利", "example": "ドラえもんは、勝利を喜んだ。", "translation": "Doraemon celebrated his triumph."},
     {"word": "renew", "meaning": "更新する", "example": "ドラえもんは、契約を更新した。", "translation": "Doraemon renewed his contract."}
     ];
     break;
     case "高校英語120":
     item = [
     {"word": "interaction", "meaning": "交流", "example": "ドラえもんは、友達と交流するのが好きだ。", "translation": "Doraemon likes interaction with his friends."},
     {"word": "participate", "meaning": "参加する", "example": "ドラえもんは、みんなの活動に参加する。", "translation": "Doraemon participates in everyone's activities."},
     {"word": "crime", "meaning": "犯罪", "example": "ドラえもんは、犯罪を許さない。", "translation": "Doraemon does not tolerate crimes."},
     {"word": "represent", "meaning": "代表する", "example": "ドラえもんは、未来を代表して来た。", "translation": "Doraemon came representing the future."},
     {"word": "gradually", "meaning": "徐々に", "example": "のび太は、徐々に成長している。", "translation": "Nobita is gradually growing up."},
     {"word": "fried", "meaning": "揚げた", "example": "ドラえもんは、揚げたてのドーナツを食べて満足した。", "translation": "Doraemon was satisfied eating freshly fried donuts."},
     {"word": "demonstrate", "meaning": "示す", "example": "ドラえもんは、道具の機能を示した。", "translation": "Doraemon demonstrated the function of his gadget."},
     {"word": "landscape", "meaning": "風景", "example": "ドラえもんは、美しい風景を眺めた。", "translation": "Doraemon looked at the beautiful landscape."},
     {"word": "pleasantly", "meaning": "愉快に", "example": "ドラえもんは、愉快な旅に出かけた。", "translation": "Doraemon went on a pleasant trip."},
     {"word": "furthermore", "meaning": "さらに", "example": "ドラえもんは、さらに詳しく説明した。", "translation": "Furthermore, Doraemon explained in more detail."}
     ];
     break;
    
     
     case "高校英語121":
     item = [
     {"word": "roundabout", "meaning": "遠回しの", "example": "ドラえもんは、遠回しな言い方で注意した。", "translation": "Doraemon cautioned in a roundabout way."},
     {"word": "confession", "meaning": "告白", "example": "のび太は、ドラえもんに自分の秘密を告白した。", "translation": "Nobita made a confession to Doraemon about his secret."},
     {"word": "obedient", "meaning": "従順な", "example": "ドラえもんは、のび太にいつも従順だ。", "translation": "Doraemon is always obedient to Nobita."},
     {"word": "abolish", "meaning": "廃止する", "example": "ドラえもんは、悪い制度を廃止しようとした。", "translation": "Doraemon tried to abolish a bad system."},
     {"word": "mumble", "meaning": "つぶやく", "example": "ドラえもんは、小さな声でつぶやいた。", "translation": "Doraemon mumbled in a low voice."},
     {"word": "depot", "meaning": "貯蔵庫", "example": "ドラえもんは、秘密道具を貯蔵庫に保管した。", "translation": "Doraemon stored his secret gadgets in the depot."},
     {"word": "treaty", "meaning": "条約", "example": "ドラえもんは、未来の条約について学んだ。", "translation": "Doraemon learned about a future treaty."},
     {"word": "democratic", "meaning": "民主的な", "example": "ドラえもんは、民主的な方法で物事を決める。", "translation": "Doraemon makes decisions in a democratic way."},
     {"word": "multinational", "meaning": "多国籍の", "example": "ドラえもんは、多国籍企業で働いた。", "translation": "Doraemon worked at a multinational corporation."},
     {"word": "preschool", "meaning": "幼稚園", "example": "のび太は、昔幼稚園に通っていた。", "translation": "Nobita used to go to preschool."}
     ];
     break;
     case "高校英語122":
     item = [
     {"word": "profession", "meaning": "職業", "example": "ドラえもんは、未来の職業について説明した。", "translation": "Doraemon explained about future professions."},
     {"word": "swell", "meaning": "膨らむ", "example": "ドラえもんは、風船を膨らませた。", "translation": "Doraemon swelled the balloon."},
     {"word": "cultivate", "meaning": "耕す", "example": "ドラえもんは、畑を耕して野菜を育てた。", "translation": "Doraemon cultivated the field and grew vegetables."},
     {"word": "headline", "meaning": "見出し", "example": "ドラえもんは、新聞の見出しを読んだ。", "translation": "Doraemon read the headline of the newspaper."},
     {"word": "stem", "meaning": "茎", "example": "ドラえもんは、花の茎を触ってみた。", "translation": "Doraemon touched the stem of the flower."},
     {"word": "altitude", "meaning": "高度", "example": "ドラえもんは、高い山の上で高度を測った。", "translation": "Doraemon measured the altitude on top of a high mountain."},
     {"word": "vital", "meaning": "不可欠な", "example": "ドラえもんは、水が生命維持に不可欠だと語った。", "translation": "Doraemon said water is vital for life."},
     {"word": "coverage", "meaning": "報道", "example": "ドラえもんは、ニュースの報道を見た。", "translation": "Doraemon watched the news coverage."},
     {"word": "formerly", "meaning": "以前は", "example": "ドラえもんは、以前は違う場所に住んでいた。", "translation": "Doraemon formerly lived in a different place."},
     {"word": "sailboat", "meaning": "ヨット", "example": "ドラえもんは、ヨットに乗って海に出た。", "translation": "Doraemon went out to sea on a sailboat."}
     ];
     break;
     case "高校英語123":
     item = [
     {"word": "outstanding", "meaning": "傑出した", "example": "ドラえもんは、傑出した能力を持っている。", "translation": "Doraemon has outstanding abilities."},
     {"word": "devastate", "meaning": "破壊する", "example": "ドラえもんは、街を破壊する敵を止めた。", "translation": "Doraemon stopped the enemy from devastating the town."},
     {"word": "repeatedly", "meaning": "繰り返し", "example": "のび太は、何度も何度も同じ失敗を繰り返す。", "translation": "Nobita repeatedly makes the same mistake."},
     {"word": "suburb", "meaning": "郊外", "example": "ドラえもんは、郊外の住宅街へ行った。", "translation": "Doraemon went to a suburban residential area."},
     {"word": "drag", "meaning": "引きずる", "example": "ドラえもんは、重い荷物を引きずって運んだ。", "translation": "Doraemon dragged a heavy load."},
     {"word": "symptom", "meaning": "症状", "example": "のび太は、風邪の症状で苦しんだ。", "translation": "Nobita suffered from the symptoms of a cold."},
     {"word": "risk", "meaning": "危険", "example": "ドラえもんは、危険を冒して人々を助けた。", "translation": "Doraemon took a risk to save people."},
     {"word": "prediction", "meaning": "予測", "example": "ドラえもんは、未来の予測を立てた。", "translation": "Doraemon made a prediction about the future."},
     {"word": "utilize", "meaning": "利用する", "example": "ドラえもんは、道具を最大限に利用した。", "translation": "Doraemon utilized his gadgets to the fullest."},
     {"word": "instinct", "meaning": "本能", "example": "ドラえもんは、危険を察知する本能を持っている。", "translation": "Doraemon has an instinct for sensing danger."}
     ];
     break;
     case "高校英語124":
     item = [
     {"word": "breeze", "meaning": "そよ風", "example": "ドラえもんは、そよ風を感じて気持ちよくなった。", "translation": "Doraemon felt comfortable enjoying the breeze."},
     {"word": "basement", "meaning": "地下室", "example": "ドラえもんは、地下室を探検した。", "translation": "Doraemon explored the basement."},
     {"word": "stable", "meaning": "安定した", "example": "ドラえもんは、安定した場所に立っている。", "translation": "Doraemon is standing on a stable surface."},
     {"word": "sensitive", "meaning": "敏感な", "example": "ドラえもんは、痛みに敏感だ。", "translation": "Doraemon is sensitive to pain."},
     {"word": "resist", "meaning": "抵抗する", "example": "ドラえもんは、悪い力に抵抗した。", "translation": "Doraemon resisted the evil forces."},
     {"word": "overthrow", "meaning": "転覆させる", "example": "ドラえもんは、独裁政権を転覆させた。", "translation": "Doraemon overthrew the dictatorship."},
     {"word": "napkin", "meaning": "ナプキン", "example": "ドラえもんは、ナプキンで口を拭いた。", "translation": "Doraemon wiped his mouth with a napkin."},
     {"word": "bargain", "meaning": "掘り出し物", "example": "ドラえもんは、掘り出し物を見つけた。", "translation": "Doraemon found a bargain."},
     {"word": "blueberry", "meaning": "ブルーベリー", "example": "ドラえもんは、ブルーベリーを食べた。", "translation": "Doraemon ate a blueberry."},
     {"word": "stock", "meaning": "株", "example": "ドラえもんは、株の取引を体験した。", "translation": "Doraemon experienced trading stocks."}
     ];
     break;
     case "高校英語125":
     item = [
     {"word": "sufficient", "meaning": "十分な", "example": "ドラえもんは、十分なエネルギーを充電した。", "translation": "Doraemon charged up sufficient energy."},
     {"word": "latest", "meaning": "最新の", "example": "ドラえもんは、最新の道具を使った。", "translation": "Doraemon used the latest gadget."},
     {"word": "bizarre", "meaning": "奇妙な", "example": "ドラえもんは、奇妙な生き物に会った。", "translation": "Doraemon met a bizarre creature."},
     {"word": "sandal", "meaning": "サンダル", "example": "ドラえもんは、サンダルを履いてビーチに行った。", "translation": "Doraemon wore sandals and went to the beach."},
     {"word": "mercy", "meaning": "慈悲", "example": "ドラえもんは、敵に慈悲を与えた。", "translation": "Doraemon showed mercy to the enemy."},
     {"word": "irrational", "meaning": "不合理な", "example": "ドラえもんは、不合理な行動をしない。", "translation": "Doraemon does not act irrationally."},
     {"word": "mediocre", "meaning": "平凡な", "example": "ドラえもんは、平凡な生活を嫌う。", "translation": "Doraemon dislikes a mediocre life."},
     {"word": "disgrace", "meaning": "不名誉", "example": "ドラえもんは、不名誉なことをしない。", "translation": "Doraemon does not do anything that would bring disgrace."},
     {"word": "experimental", "meaning": "実験的な", "example": "ドラえもんは、実験的な道具を使った。", "translation": "Doraemon used an experimental gadget."},
     {"word": "heater", "meaning": "ヒーター", "example": "ドラえもんは、寒いのでヒーターをつけた。", "translation": "Doraemon turned on the heater because it was cold."}
     ];
     break;
     case "高校英語126":
     item = [
     {"word": "evaluate", "meaning": "評価する", "example": "ドラえもんは、自分の能力を評価した。", "translation": "Doraemon evaluated his abilities."},
     {"word": "genetic", "meaning": "遺伝子の", "example": "ドラえもんは、遺伝子工学に興味がある。", "translation": "Doraemon is interested in genetic engineering."},
     {"word": "talkative", "meaning": "おしゃべりな", "example": "ドラえもんは、時々おしゃべりになる。", "translation": "Doraemon sometimes becomes talkative."},
     {"word": "component", "meaning": "構成要素", "example": "ドラえもんは、機械の構成要素を調べた。", "translation": "Doraemon examined the components of the machine."},
     {"word": "breed", "meaning": "品種", "example": "ドラえもんは、色々な種類の動物の品種を見た。", "translation": "Doraemon saw various breeds of animals."},
     {"word": "innocent", "meaning": "無罪の", "example": "ドラえもんは、無実の罪を着せられた。", "translation": "Doraemon was accused of a crime he did not commit, so he was innocent."},
     {"word": "output", "meaning": "出力", "example": "ドラえもんは、機械の出力を調整した。", "translation": "Doraemon adjusted the output of the machine."},
     {"word": "molecule", "meaning": "分子", "example": "ドラえもんは、分子の構造を調べた。", "translation": "Doraemon examined the structure of a molecule."},
     {"word": "heritage", "meaning": "遺産", "example": "ドラえもんは、文化的な遺産を大切にしている。", "translation": "Doraemon values cultural heritage."},
     {"word": "constantly", "meaning": "絶えず", "example": "ドラえもんは、絶えずのび太を見守っている。", "translation": "Doraemon is constantly watching over Nobita."}
     ];
     break;
     case "高校英語127":
     item = [
     {"word": "protest", "meaning": "抗議する", "example": "ドラえもんは、不当な行為に抗議した。", "translation": "Doraemon protested against the unfair act."},
     {"word": "bark", "meaning": "吠える", "example": "犬が急に吠え出した。", "translation": "A dog suddenly started to bark."},
     {"word": "scold", "meaning": "叱る", "example": "ドラえもんは、のび太を叱ることもあった。", "translation": "Doraemon sometimes scolded Nobita."},
     {"word": "regulation", "meaning": "規則", "example": "ドラえもんは、規則を守ることを大切にしている。", "translation": "Doraemon values following the regulations."},
     {"word": "fantastic", "meaning": "素晴らしい", "example": "ドラえもんは、素晴らしい景色に感動した。", "translation": "Doraemon was impressed by the fantastic view."},
     {"word": "disaster", "meaning": "災害", "example": "ドラえもんは、災害から人々を救った。", "translation": "Doraemon rescued people from the disaster."},
     {"word": "identify", "meaning": "特定する", "example": "ドラえもんは、犯人を特定した。", "translation": "Doraemon identified the criminal."},
     {"word": "laundry", "meaning": "洗濯物", "example": "ドラえもんは、洗濯物を干した。", "translation": "Doraemon hung up the laundry."},
     {"word": "expose", "meaning": "暴露する", "example": "ドラえもんは、悪事を暴露した。", "translation": "Doraemon exposed the evil deeds."},
     {"word": "outweigh", "meaning": "上回る", "example": "ドラえもんは、友情が他の何よりも重要だと考えている。", "translation": "Doraemon believes friendship outweighs everything else."}
     ];
     break;
     case "高校英語128":
     item = [
     {"word": "strengthen", "meaning": "強化する", "example": "ドラえもんは、道具を強化した。", "translation": "Doraemon strengthened his gadgets."},
     {"word": "borrower", "meaning": "借り手", "example": "ドラえもんは、お金の借り手を探した。", "translation": "Doraemon looked for a borrower of money."},
     {"word": "odd", "meaning": "奇妙な", "example": "ドラえもんは、奇妙な出来事に遭遇した。", "translation": "Doraemon encountered an odd incident."},
     {"word": "imply", "meaning": "ほのめかす", "example": "ドラえもんは、暗に危険をほのめかした。", "translation": "Doraemon implied the danger indirectly."},
     {"word": "distinguish", "meaning": "区別する", "example": "ドラえもんは、本物と偽物を区別した。", "translation": "Doraemon distinguished between the genuine and the fake."},
     {"word": "latter", "meaning": "後者の", "example": "ドラえもんは、前者よりも後者の案を選んだ。", "translation": "Doraemon chose the latter plan rather than the former."},
     {"word": "substance", "meaning": "物質", "example": "ドラえもんは、未知の物質を調べた。", "translation": "Doraemon examined an unknown substance."},
     {"word": "dull", "meaning": "退屈な", "example": "ドラえもんは、退屈な時間が嫌いだ。", "translation": "Doraemon dislikes dull times."},
     {"word": "dormitory", "meaning": "寮", "example": "ドラえもんは、未来の学生寮に泊まった。", "translation": "Doraemon stayed in a future dormitory."},
     {"word": "explosion", "meaning": "爆発", "example": "ドラえもんは、爆発が起きるのを見た。", "translation": "Doraemon saw an explosion."}
     ];
     break;
     case "高校英語129":
     item = [
     {"word": "underestimate", "meaning": "過小評価する", "example": "ドラえもんは、敵を過小評価しないように注意した。", "translation": "Doraemon was careful not to underestimate his opponent."},
     {"word": "incredible", "meaning": "信じられない", "example": "ドラえもんは、信じられないような出来事を体験した。", "translation": "Doraemon experienced an incredible event."},
     {"word": "effective", "meaning": "効果的な", "example": "ドラえもんの道具は、効果的に機能する。", "translation": "Doraemon's gadgets function effectively."},
     {"word": "ritual", "meaning": "儀式", "example": "ドラえもんは、古い儀式を観察した。", "translation": "Doraemon observed an old ritual."},
     {"word": "privilege", "meaning": "特権", "example": "ドラえもんは、特別な特権を持っている。", "translation": "Doraemon has special privileges."},
     {"word": "setback", "meaning": "挫折", "example": "ドラえもんは、挫折を経験しても諦めない。", "translation": "Doraemon does not give up even if he experiences a setback."},
     {"word": "mum", "meaning": "お母さん", "example": "のび太は、お母さんのことが好きだ。", "translation": "Nobita likes his mum."},
     {"word": "circuit", "meaning": "回路", "example": "ドラえもんは、電子回路を修理した。", "translation": "Doraemon repaired an electronic circuit."},
     {"word": "diverse", "meaning": "多様な", "example": "ドラえもんは、多様な文化に触れた。", "translation": "Doraemon experienced diverse cultures."},
     {"word": "offensive", "meaning": "不快な", "example": "ドラえもんは、不快なことはしない。", "translation": "Doraemon does not do anything offensive."}
     ];
     break;
     case "高校英語130":
     item = [
     {"word": "advertising", "meaning": "広告", "example": "ドラえもんは、未来の広告について学んだ。", "translation": "Doraemon learned about future advertising techniques."},
     {"word": "proposal", "meaning": "提案", "example": "ドラえもんは、新しい提案をした。", "translation": "Doraemon made a new proposal."},
     {"word": "cram", "meaning": "詰め込む", "example": "のび太は、試験前に知識を詰め込む。", "translation": "Nobita crams knowledge before exams."},
     {"word": "parallel", "meaning": "並行の", "example": "ドラえもんは、並行の世界へ行った。", "translation": "Doraemon went to a parallel world."},
     {"word": "deforestation", "meaning": "森林破壊", "example": "ドラえもんは、森林破壊を止めた。", "translation": "Doraemon stopped deforestation."},
     {"word": "equivalent", "meaning": "同等の", "example": "ドラえもんは、同等の能力を持つロボットに会った。", "translation": "Doraemon met a robot with equivalent abilities."},
     {"word": "traveler", "meaning": "旅行者", "example": "ドラえもんは、未来の旅行者に道を聞かれた。", "translation": "Doraemon was asked for directions by a traveler from the future."},
     {"word": "allege", "meaning": "主張する", "example": "ドラえもんは、真実を主張した。", "translation": "Doraemon alleged the truth."},
     {"word": "inconvenient", "meaning": "不便な", "example": "ドラえもんは、不便な道具の改善を試みた。", "translation": "Doraemon tried to improve the inconvenient gadget."},
     {"word": "superior", "meaning": "優れた", "example": "ドラえもんは、優れた道具を作ることができる。", "translation": "Doraemon can make superior gadgets."}
     ];
     break;
     case "高校英語131":
     item = [
     {"word": "fairly", "meaning": "かなり", "example": "ドラえもんは、かなり上手に料理を作ることが出来る。", "translation": "Doraemon can cook fairly well."},
     {"word": "average", "meaning": "平均", "example": "のび太のテストの点はいつも平均点以下だ。", "translation": "Nobita's test scores are always below average."},
     {"word": "staff", "meaning": "職員", "example": "ドラえもんは、未来の博物館の職員に質問をした。", "translation": "Doraemon asked a question to the staff at the museum from the future."},
     {"word": "permission", "meaning": "許可", "example": "ドラえもんは、のび太に道具を使う許可を与えた。", "translation": "Doraemon gave Nobita permission to use the gadget."},
     {"word": "scholarship", "meaning": "奨学金", "example": "ドラえもんは、奨学金を得て留学した。", "translation": "Doraemon received a scholarship to study abroad."},
     {"word": "rob", "meaning": "奪う", "example": "ジャイアンは、よく友達のおもちゃを奪う。", "translation": "Gian often robs his friends' toys."},
     {"word": "frankly", "meaning": "率直に", "example": "ドラえもんは、自分の気持ちを率直に伝えた。", "translation": "Doraemon frankly expressed his feelings."},
     {"word": "manufacture", "meaning": "製造する", "example": "ドラえもんは、未来の工場で道具が製造されるのを見た。", "translation": "Doraemon saw the gadgets being manufactured in a future factory."},
     {"word": "percentage", "meaning": "割合", "example": "ドラえもんは、正解率を計算した。", "translation": "Doraemon calculated the percentage of correct answers."},
     {"word": "exception", "meaning": "例外", "example": "ドラえもんは、例外を認めなかった。", "translation": "Doraemon did not allow exceptions."}
     ];
     break;
     case "高校英語132":
     item = [
     {"word": "reservation", "meaning": "予約", "example": "ドラえもんは、レストランを予約した。", "translation": "Doraemon made a reservation at a restaurant."},
     {"word": "institute", "meaning": "研究所", "example": "ドラえもんは、未来の科学研究所を見学した。", "translation": "Doraemon visited a scientific research institute of the future."},
     {"word": "gene", "meaning": "遺伝子", "example": "ドラえもんは、遺伝子について研究した。", "translation": "Doraemon researched about genes."},
     {"word": "assistance", "meaning": "援助", "example": "ドラえもんは、困っている人々に援助をした。", "translation": "Doraemon provided assistance to people in need."},
     {"word": "objective", "meaning": "目標", "example": "ドラえもんは、明確な目標を持って行動した。", "translation": "Doraemon acted with a clear objective."},
     {"word": "microwave", "meaning": "電子レンジ", "example": "ドラえもんは、電子レンジで料理を温めた。", "translation": "Doraemon warmed the food in the microwave."},
     {"word": "rude", "meaning": "失礼な", "example": "ドラえもんは、失礼な態度をとることを嫌う。", "translation": "Doraemon dislikes rude behavior."},
     {"word": "ethnicity", "meaning": "民族性", "example": "ドラえもんは、多様な民族の文化に興味を持っている。", "translation": "Doraemon is interested in the cultures of various ethnicities."},
     {"word": "virtue", "meaning": "美徳", "example": "ドラえもんは、友情を美徳としている。", "translation": "Doraemon considers friendship a virtue."},
     {"word": "treatment", "meaning": "治療", "example": "ドラえもんは、未来の治療法を体験した。", "translation": "Doraemon experienced future medical treatment."}
     ];
     break;
     case "高校英語133":
     item = [
     {"word": "recent", "meaning": "最近の", "example": "ドラえもんは、最近あった出来事を話した。", "translation": "Doraemon talked about a recent event."},
     {"word": "simply", "meaning": "単に", "example": "ドラえもんは、単に友達を助けたいだけだ。", "translation": "Doraemon simply wants to help his friends."},
     {"word": "artificial", "meaning": "人工的な", "example": "ドラえもんは、人工的に作られた道具を使った。", "translation": "Doraemon used an artificially created gadget."},
     {"word": "differ", "meaning": "異なる", "example": "ドラえもんと、のび太は考え方が異なることがある。", "translation": "Doraemon and Nobita sometimes differ in their thinking."},
     {"word": "exact", "meaning": "正確な", "example": "ドラえもんは、正確な時間を測った。", "translation": "Doraemon measured the exact time."},
     {"word": "sled", "meaning": "そり", "example": "ドラえもんは、そりで雪の上を滑った。", "translation": "Doraemon slid on the snow with a sled."},
     {"word": "educational", "meaning": "教育的な", "example": "ドラえもんは、教育的な番組が好きだ。", "translation": "Doraemon likes educational programs."},
     {"word": "undertake", "meaning": "引き受ける", "example": "ドラえもんは、新しい任務を引き受けた。", "translation": "Doraemon undertook a new mission."},
     {"word": "acceptance", "meaning": "受容", "example": "ドラえもんは、ありのままの自分を受け入れた。", "translation": "Doraemon accepted himself as he is."},
     {"word": "resort", "meaning": "リゾート", "example": "ドラえもんは、リゾート地へ行った。", "translation": "Doraemon went to a resort."}
     ];
     break;
     case "高校英語134":
     item = [
     {"word": "cartoon", "meaning": "漫画", "example": "ドラえもんは、漫画を読むのが好きだ。", "translation": "Doraemon likes to read cartoons."},
     {"word": "tone", "meaning": "口調", "example": "ドラえもんは、優しい口調で話す。", "translation": "Doraemon speaks in a gentle tone."},
     {"word": "compliment", "meaning": "褒め言葉", "example": "ドラえもんは、みんなを褒めた。", "translation": "Doraemon gave everyone a compliment."},
     {"word": "remedy", "meaning": "治療法", "example": "ドラえもんは、病気の治療法を探した。", "translation": "Doraemon looked for a remedy for the disease."},
     {"word": "ongoing", "meaning": "進行中の", "example": "ドラえもんは、現在進行中の問題に対処した。", "translation": "Doraemon addressed the ongoing problem."},
     {"word": "donate", "meaning": "寄付する", "example": "ドラえもんは、困っている人に寄付をした。", "translation": "Doraemon donated to people in need."},
     {"word": "bankrupt", "meaning": "破産する", "example": "ドラえもんは、破産した会社を救った。", "translation": "Doraemon saved the bankrupt company."},
     {"word": "walking", "meaning": "歩くこと", "example": "ドラえもんは、歩くのが好きだ。", "translation": "Doraemon likes walking."},
     {"word": "adorable", "meaning": "愛らしい", "example": "ドラえもんは、愛らしいロボットだ。", "translation": "Doraemon is an adorable robot."},
     {"word": "wither", "meaning": "しおれる", "example": "ドラえもんは、花がしおれるのを見て悲しんだ。", "translation": "Doraemon was sad to see the flower wither."}
     ];
     break;
     case "高校英語135":
     item = [
     {"word": "theft", "meaning": "窃盗", "example": "ドラえもんは、窃盗事件を解決した。", "translation": "Doraemon solved the theft."},
     {"word": "rainforest", "meaning": "熱帯雨林", "example": "ドラえもんは、熱帯雨林を探検した。", "translation": "Doraemon explored the rainforest."},
     {"word": "yield", "meaning": "産出する", "example": "ドラえもんは、畑で野菜をたくさん産出させた。", "translation": "Doraemon made the field yield a lot of vegetables."},
     {"word": "vessel", "meaning": "船", "example": "ドラえもんは、未来の船に乗った。", "translation": "Doraemon rode a ship from the future."},
     {"word": "furious", "meaning": "激怒した", "example": "ジャイアンは、ドラえもんに激怒した。", "translation": "Gian was furious with Doraemon."},
     {"word": "spaceship", "meaning": "宇宙船", "example": "ドラえもんは、宇宙船で宇宙を旅した。", "translation": "Doraemon traveled through space in a spaceship."},
     {"word": "politics", "meaning": "政治", "example": "ドラえもんは、未来の政治について学んだ。", "translation": "Doraemon learned about future politics."},
     {"word": "psychological", "meaning": "心理的な", "example": "ドラえもんは、心理的な問題を解決した。", "translation": "Doraemon resolved a psychological issue."},
     {"word": "peel", "meaning": "皮をむく", "example": "ドラえもんは、りんごの皮をむいた。", "translation": "Doraemon peeled an apple."},
     {"word": "capability", "meaning": "能力", "example": "ドラえもんは、驚くべき能力を持っている。", "translation": "Doraemon has amazing capabilities."}
     ];
     break;
     case "高校英語136":
     item = [
     {"word": "makeup", "meaning": "化粧", "example": "しずかちゃんは、化粧をするのが好きだ。", "translation": "Shizuka likes to put on makeup."},
     {"word": "overcome", "meaning": "克服する", "example": "ドラえもんは、困難を乗り越えた。", "translation": "Doraemon overcame his difficulties."},
     {"word": "context", "meaning": "文脈", "example": "ドラえもんは、文脈を理解して話した。", "translation": "Doraemon spoke with a clear understanding of the context."},
     {"word": "trace", "meaning": "痕跡", "example": "ドラえもんは、犯人の痕跡をたどった。", "translation": "Doraemon followed the trace of the criminal."},
     {"word": "honestly", "meaning": "正直に", "example": "ドラえもんは、いつも正直に話す。", "translation": "Doraemon always speaks honestly."},
     {"word": "phenomenon", "meaning": "現象", "example": "ドラえもんは、不思議な現象を観察した。", "translation": "Doraemon observed a mysterious phenomenon."},
     {"word": "pump", "meaning": "ポンプ", "example": "ドラえもんは、ポンプを使って水をくみ上げた。", "translation": "Doraemon used a pump to draw water."},
     {"word": "allergy", "meaning": "アレルギー", "example": "のび太は、アレルギーでくしゃみをした。", "translation": "Nobita sneezed due to an allergy."},
     {"word": "fascinate", "meaning": "魅了する", "example": "ドラえもんは、未来の道具に魅了された。", "translation": "Doraemon was fascinated by the gadgets of the future."},
     {"word": "hurricane", "meaning": "ハリケーン", "example": "ドラえもんは、ハリケーンの中で冒険をした。", "translation": "Doraemon had an adventure during a hurricane."}
     ];
     break;
     case "高校英語137":
     item = [
     {"word": "maintain", "meaning": "維持する", "example": "ドラえもんは、健康を維持するために運動をする。", "translation": "Doraemon exercises to maintain his health."},
     {"word": "nuclear", "meaning": "核の", "example": "ドラえもんは、核エネルギーについて学んだ。", "translation": "Doraemon learned about nuclear energy."},
     {"word": "activate", "meaning": "作動させる", "example": "ドラえもんは、道具を作動させる。", "translation": "Doraemon activated his gadget."},
     {"word": "grasp", "meaning": "掴む", "example": "ドラえもんは、ロープをしっかりと掴んだ。", "translation": "Doraemon grasped the rope tightly."},
     {"word": "scarce", "meaning": "乏しい", "example": "ドラえもんは、資源が乏しい未来を心配した。", "translation": "Doraemon was worried about the scarce resources in the future."},
     {"word": "twist", "meaning": "ねじる", "example": "ドラえもんは、針金をねじって固定した。", "translation": "Doraemon twisted the wire and fixed it."},
     {"word": "forestry", "meaning": "林業", "example": "ドラえもんは、未来の林業について学んだ。", "translation": "Doraemon learned about forestry in the future."},
     {"word": "refund", "meaning": "払い戻し", "example": "ドラえもんは、店で払い戻しを求めた。", "translation": "Doraemon asked for a refund at the store."},
     {"word": "archaeologist", "meaning": "考古学者", "example": "ドラえもんは、考古学者と古代の遺跡を訪ねた。", "translation": "Doraemon visited ancient ruins with an archaeologist."},
     {"word": "compensation", "meaning": "補償", "example": "ドラえもんは、損害賠償を求めた。", "translation": "Doraemon asked for compensation for the damage."}
     ];
     break;
     case "高校英語138":
     item = [
     {"word": "benefit", "meaning": "利益", "example": "ドラえもんは、みんなの利益を考えた。", "translation": "Doraemon thought about the benefits for everyone."},
     {"word": "decrease", "meaning": "減少する", "example": "ドラえもんは、資源が減少していることを心配した。", "translation": "Doraemon worried about decreasing resources."},
     {"word": "avenue", "meaning": "大通り", "example": "ドラえもんは、大通りを歩いた。", "translation": "Doraemon walked along the avenue."},
     {"word": "appointment", "meaning": "約束", "example": "ドラえもんは、のび太と約束をした。", "translation": "Doraemon made an appointment with Nobita."},
     {"word": "attempt", "meaning": "試みる", "example": "ドラえもんは、新しい方法を試みた。", "translation": "Doraemon attempted a new method."},
     {"word": "financial", "meaning": "財政的な", "example": "ドラえもんは、財政的な問題を解決した。", "translation": "Doraemon solved financial problems."},
     {"word": "reinforce", "meaning": "強化する", "example": "ドラえもんは、壁を強化した。", "translation": "Doraemon reinforced the wall."},
     {"word": "physical", "meaning": "物理的な", "example": "ドラえもんは、物理的な法則を理解している。", "translation": "Doraemon understands physical laws."},
     {"word": "pasta", "meaning": "パスタ", "example": "ドラえもんは、パスタを美味しそうに食べた。", "translation": "Doraemon ate the pasta with relish."},
     {"word": "investor", "meaning": "投資家", "example": "ドラえもんは、未来の投資家と話をした。", "translation": "Doraemon spoke with an investor from the future."}
     ];
     break;
     case "高校英語139":
     item = [
     {"word": "segregate", "meaning": "分離する", "example": "ドラえもんは、ゴミを分別する。", "translation": "Doraemon segregates trash."},
     {"word": "influential", "meaning": "影響力のある", "example": "ドラえもんは、影響力のある人物と会った。", "translation": "Doraemon met an influential person."},
     {"word": "portray", "meaning": "描く", "example": "ドラえもんは、友達の姿を絵に描いた。", "translation": "Doraemon portrayed his friends in a painting."},
     {"word": "admittedly", "meaning": "確かに", "example": "ドラえもんは、「確かにそれは難しい」と言った。", "translation": "Doraemon said, 'Admittedly, that is difficult'."},
     {"word": "skid", "meaning": "滑る", "example": "ドラえもんは、氷の上で滑って転んだ。", "translation": "Doraemon skidded on the ice and fell."},
     {"word": "religion", "meaning": "宗教", "example": "ドラえもんは、色々な宗教について学んだ。", "translation": "Doraemon learned about various religions."},
     {"word": "verbal", "meaning": "言葉の", "example": "ドラえもんは、言葉で説明するのが苦手だ。", "translation": "Doraemon is not good at verbal explanations."},
     {"word": "cite", "meaning": "引用する", "example": "ドラえもんは、本の一文を引用した。", "translation": "Doraemon cited a sentence from a book."},
     {"word": "electronics", "meaning": "電子工学", "example": "ドラえもんは、電子工学を学んだ。", "translation": "Doraemon studied electronics."},
     {"word": "abundant", "meaning": "豊富な", "example": "ドラえもんは、豊富な資源を持っている。", "translation": "Doraemon has abundant resources."}
     ];
     break;
     case "高校英語140":
     item = [
     {"word": "screen", "meaning": "画面", "example": "ドラえもんは、テレビの画面を見た。", "translation": "Doraemon looked at the TV screen."},
     {"word": "item", "meaning": "品物", "example": "ドラえもんは、お店で色々な品物を買った。", "translation": "Doraemon bought various items at the store."},
     {"word": "specific", "meaning": "特定の", "example": "ドラえもんは、特定の道具を使った。", "translation": "Doraemon used a specific gadget."},
     {"word": "cleaner", "meaning": "洗剤", "example": "ドラえもんは、洗剤を使って掃除をした。", "translation": "Doraemon used cleaner to tidy up."},
     {"word": "neighborhood", "meaning": "近所", "example": "ドラえもんは、近所を散歩した。", "translation": "Doraemon took a walk around his neighborhood."},
     {"word": "promote", "meaning": "促進する", "example": "ドラえもんは、環境保護を促進する活動をしている。", "translation": "Doraemon is promoting environmental protection."},
     {"word": "search", "meaning": "探す", "example": "ドラえもんは、道具を捜索した。", "translation": "Doraemon searched for his gadget."},
     {"word": "alarm", "meaning": "警報", "example": "ドラえもんは、警報が鳴ったので急いで現場へ向かった。", "translation": "Doraemon rushed to the scene when the alarm went off."},
     {"word": "majority", "meaning": "大多数", "example": "ドラえもんは、大多数の人の意見を尊重する。", "translation": "Doraemon respects the opinions of the majority."},
     {"word": "normally", "meaning": "通常は", "example": "ドラえもんは、通常は優しい。", "translation": "Doraemon is normally kind."}
     ];
     break;
    
     
     case "高校英語141":
     item = [
     {"word": "feedback", "meaning": "フィードバック", "example": "ドラえもんは、道具の改善のためにフィードバックを集めた。", "translation": "Doraemon collected feedback to improve his gadgets."},
     {"word": "semester", "meaning": "学期", "example": "ドラえもんは、未来の学校で学期末のテストを受けた。", "translation": "Doraemon took a semester-end test at a future school."},
     {"word": "deserve", "meaning": "値する", "example": "のび太は、もっと良い点を取るに値する。", "translation": "Nobita deserves to get better scores."},
     {"word": "routine", "meaning": "日課", "example": "ドラえもんは、毎日同じ日課をこなしている。", "translation": "Doraemon carries out the same routine every day."},
     {"word": "fake", "meaning": "偽の", "example": "ドラえもんは、偽の道具を見破った。", "translation": "Doraemon saw through the fake gadget."},
     {"word": "candidate", "meaning": "候補者", "example": "ドラえもんは、次期リーダーの候補者になった。", "translation": "Doraemon became a candidate for the next leader."},
     {"word": "application", "meaning": "応募", "example": "ドラえもんは、アルバイトの応募をした。", "translation": "Doraemon applied for a part-time job."},
     {"word": "critic", "meaning": "批評家", "example": "ドラえもんは、未来の道具の批評を聞いた。", "translation": "Doraemon listened to a critic's review of a future gadget."},
     {"word": "equally", "meaning": "平等に", "example": "ドラえもんは、みんなを平等に扱う。", "translation": "Doraemon treats everyone equally."},
     {"word": "evolution", "meaning": "進化", "example": "ドラえもんは、道具の進化を観察した。", "translation": "Doraemon observed the evolution of his gadgets."}
     ];
     break;
     case "高校英語142":
     item = [
     {"word": "brief", "meaning": "短い", "example": "ドラえもんは、短い時間で問題を解決した。", "translation": "Doraemon solved the problem in a brief time."},
     {"word": "tune", "meaning": "調律する", "example": "ドラえもんは、ギターを調律した。", "translation": "Doraemon tuned the guitar."},
     {"word": "occupation", "meaning": "職業", "example": "ドラえもんは、のび太に将来の職業について話した。", "translation": "Doraemon talked to Nobita about future occupations."},
     {"word": "commitment", "meaning": "献身", "example": "ドラえもんは、のび太のために献身的に尽くす。", "translation": "Doraemon is committed to helping Nobita."},
     {"word": "violate", "meaning": "侵害する", "example": "ドラえもんは、ルールを侵害するようなことはしない。", "translation": "Doraemon does not do anything to violate the rules."},
     {"word": "suspicion", "meaning": "疑い", "example": "ドラえもんは、怪しい行動に疑いを持った。", "translation": "Doraemon had a suspicion about the suspicious behavior."},
     {"word": "confrontation", "meaning": "対立", "example": "ドラえもんは、対立を避けるようにした。", "translation": "Doraemon tried to avoid a confrontation."},
     {"word": "abortion", "meaning": "中絶", "example": "ドラえもんは、生命の尊重について考えた。", "translation": "Doraemon thought about the value of life."},
     {"word": "download", "meaning": "ダウンロードする", "example": "ドラえもんは、新しいソフトをダウンロードした。", "translation": "Doraemon downloaded new software."},
     {"word": "furnish", "meaning": "備え付ける", "example": "ドラえもんは、部屋に家具を備え付けた。", "translation": "Doraemon furnished the room with furniture."}
     ];
     break;
     case "高校英語143":
     item = [
     {"word": "subtle", "meaning": "微妙な", "example": "ドラえもんは、微妙な変化に気づいた。", "translation": "Doraemon noticed a subtle change."},
     {"word": "delete", "meaning": "削除する", "example": "ドラえもんは、不要なデータを削除した。", "translation": "Doraemon deleted unnecessary data."},
     {"word": "edit", "meaning": "編集する", "example": "ドラえもんは、ビデオを編集した。", "translation": "Doraemon edited the video."},
     {"word": "peer", "meaning": "仲間", "example": "ドラえもんは、仲間のロボットたちと情報交換をした。", "translation": "Doraemon exchanged information with his peer robots."},
     {"word": "agricultural", "meaning": "農業の", "example": "ドラえもんは、農業技術を学んだ。", "translation": "Doraemon learned agricultural techniques."},
     {"word": "dissolve", "meaning": "溶解する", "example": "ドラえもんは、物質を溶かす道具を使った。", "translation": "Doraemon used a gadget that dissolved matter."},
     {"word": "lodge", "meaning": "泊まる", "example": "ドラえもんは、旅館に泊まった。", "translation": "Doraemon lodged at a traditional Japanese inn."},
     {"word": "temporarily", "meaning": "一時的に", "example": "ドラえもんは、道具を一時的に使った。", "translation": "Doraemon used the gadget temporarily."},
     {"word": "pullover", "meaning": "プルオーバー", "example": "ドラえもんは、プルオーバーを着てみた。", "translation": "Doraemon tried on a pullover."},
     {"word": "clarify", "meaning": "明確にする", "example": "ドラえもんは、問題を明確にしようとした。", "translation": "Doraemon tried to clarify the problem."}
     ];
     break;
     case "高校英語144":
     item = [
     {"word": "crop", "meaning": "作物", "example": "ドラえもんは、畑でたくさんの作物を育てた。", "translation": "Doraemon grew many crops in the field."},
     {"word": "essential", "meaning": "不可欠な", "example": "ドラえもんは、水が生きるために不可欠だと言った。", "translation": "Doraemon said water is essential for life."},
     {"word": "luckily", "meaning": "幸運にも", "example": "ドラえもんは、幸運にも危機を脱出できた。", "translation": "Luckily, Doraemon was able to escape the crisis."},
     {"word": "apologize", "meaning": "謝罪する", "example": "ドラえもんは、過ちを謝罪した。", "translation": "Doraemon apologized for his mistake."},
     {"word": "target", "meaning": "標的", "example": "ドラえもんは、標的に向かって道具を使った。", "translation": "Doraemon used the gadget targeting the target."},
     {"word": "diet", "meaning": "食事", "example": "ドラえもんは、バランスの取れた食事を心がけている。", "translation": "Doraemon tries to have a balanced diet."},
     {"word": "inexpensive", "meaning": "安い", "example": "ドラえもんは、安いお菓子を買って喜んだ。", "translation": "Doraemon was happy to buy inexpensive snacks."},
     {"word": "closely", "meaning": "密接に", "example": "ドラえもんは、のび太を密接に見守った。", "translation": "Doraemon watched Nobita closely."},
     {"word": "regularly", "meaning": "定期的に", "example": "ドラえもんは、定期的にメンテナンスをする。", "translation": "Doraemon does regular maintenance."},
     {"word": "stressful", "meaning": "ストレスの多い", "example": "ドラえもんは、ストレスの多い場所を避けた。", "translation": "Doraemon avoided stressful places."}
     ];
     break;
     case "高校英語145":
     item = [
     {"word": "relationship", "meaning": "関係", "example": "ドラえもんは、のび太との関係を大切にしている。", "translation": "Doraemon values his relationship with Nobita."},
     {"word": "therefore", "meaning": "したがって", "example": "ドラえもんは、したがって、この結論に至った。", "translation": "Therefore, Doraemon came to this conclusion."},
     {"word": "decay", "meaning": "腐敗", "example": "ドラえもんは、食べ物が腐敗するのを防ぐ道具を使った。", "translation": "Doraemon used a gadget that prevented food from decaying."},
     {"word": "standby", "meaning": "待機状態", "example": "ドラえもんは、いつでも待機状態だ。", "translation": "Doraemon is always on standby."},
     {"word": "committee", "meaning": "委員会", "example": "ドラえもんは、未来の委員会のメンバーになった。", "translation": "Doraemon became a member of a future committee."},
     {"word": "convince", "meaning": "納得させる", "example": "ドラえもんは、みんなを納得させた。", "translation": "Doraemon convinced everyone."},
     {"word": "rapidly", "meaning": "急速に", "example": "ドラえもんは、急速に成長している。", "translation": "Doraemon is growing rapidly."},
     {"word": "tidy", "meaning": "片付ける", "example": "ドラえもんは、部屋を綺麗に片付けた。", "translation": "Doraemon tidied up the room neatly."},
     {"word": "discovery", "meaning": "発見", "example": "ドラえもんは、新しい発見をした。", "translation": "Doraemon made a new discovery."},
     {"word": "income", "meaning": "収入", "example": "ドラえもんは、アルバイトで収入を得た。", "translation": "Doraemon earned an income from his part-time job."}
     ];
     break;
     case "高校英語146":
     item = [
     {"word": "documentary", "meaning": "ドキュメンタリー", "example": "ドラえもんは、ドキュメンタリー映画を見た。", "translation": "Doraemon watched a documentary film."},
     {"word": "emotion", "meaning": "感情", "example": "ドラえもんは、感情を表現することが苦手だ。", "translation": "Doraemon is not good at expressing his emotions."},
     {"word": "focus", "meaning": "集中する", "example": "ドラえもんは、一つのことに集中した。", "translation": "Doraemon focused on one thing."},
     {"word": "resident", "meaning": "住民", "example": "ドラえもんは、未来の都市の住民と交流した。", "translation": "Doraemon interacted with residents of a future city."},
     {"word": "dedication", "meaning": "献身", "example": "ドラえもんは、のび太に献身的に尽くす。", "translation": "Doraemon is dedicated to Nobita."},
     {"word": "trail", "meaning": "跡", "example": "ドラえもんは、足跡をたどって犯人を捜した。", "translation": "Doraemon followed the footprints to find the culprit."},
     {"word": "cue", "meaning": "合図", "example": "ドラえもんは、合図を送った。", "translation": "Doraemon gave a cue."},
     {"word": "drastic", "meaning": "思い切った", "example": "ドラえもんは、思い切った行動に出た。", "translation": "Doraemon took a drastic action."},
     {"word": "zipper", "meaning": "ジッパー", "example": "ドラえもんは、ジッパーを閉めた。", "translation": "Doraemon closed the zipper."},
     {"word": "preliminary", "meaning": "予備的な", "example": "ドラえもんは、予備的な調査を行った。", "translation": "Doraemon conducted a preliminary investigation."}
     ];
     break;
     case "高校英語147":
     item = [
     {"word": "backbone", "meaning": "背骨", "example": "ドラえもんは、背骨を痛めてしまった。", "translation": "Doraemon hurt his backbone."},
     {"word": "troop", "meaning": "部隊", "example": "ドラえもんは、未来の軍隊の部隊に参加した。", "translation": "Doraemon participated in a troop of the future army."},
     {"word": "exhaust", "meaning": "疲れ果てさせる", "example": "ドラえもんは、長時間の労働に疲れ果てた。", "translation": "Doraemon was exhausted by the long hours of work."},
     {"word": "interpret", "meaning": "解釈する", "example": "ドラえもんは、夢を解釈しようとした。", "translation": "Doraemon tried to interpret his dream."},
     {"word": "breakthrough", "meaning": "画期的な進歩", "example": "ドラえもんは、科学技術の画期的な進歩を目の当たりにした。", "translation": "Doraemon witnessed a breakthrough in science and technology."},
     {"word": "destination", "meaning": "目的地", "example": "ドラえもんは、目的地を目指した。", "translation": "Doraemon aimed for his destination."},
     {"word": "casually", "meaning": "さりげなく", "example": "ドラえもんは、さりげなく助けてくれた。", "translation": "Doraemon casually helped me."},
     {"word": "storage", "meaning": "保管", "example": "ドラえもんは、道具を保管するための場所を確保した。", "translation": "Doraemon secured a place for the storage of his gadgets."},
     {"word": "mature", "meaning": "成熟した", "example": "ドラえもんは、成熟した知能を持つ。", "translation": "Doraemon has a mature intelligence."},
     {"word": "shellfish", "meaning": "貝", "example": "ドラえもんは、海辺で貝を拾った。", "translation": "Doraemon picked up shellfish at the beach."}
     ];
     break;
     case "高校英語148":
     item = [
     {"word": "minor", "meaning": "小さな", "example": "ドラえもんは、小さな変化も見逃さない。", "translation": "Doraemon does not overlook even minor changes."},
     {"word": "roughly", "meaning": "おおよそ", "example": "ドラえもんは、おおよその時間を計算した。", "translation": "Doraemon calculated the time roughly."},
     {"word": "tide", "meaning": "潮流", "example": "ドラえもんは、海の潮流を調べた。", "translation": "Doraemon investigated the tide of the sea."},
     {"word": "souvenir", "meaning": "お土産", "example": "ドラえもんは、旅行のお土産を買った。", "translation": "Doraemon bought souvenirs from his trip."},
     {"word": "reliable", "meaning": "信頼できる", "example": "ドラえもんは、信頼できる友達だ。", "translation": "Doraemon is a reliable friend."},
     {"word": "barbecue", "meaning": "バーベキュー", "example": "ドラえもんは、みんなでバーベキューを楽しんだ。", "translation": "Doraemon enjoyed a barbecue with everyone."},
     {"word": "manipulate", "meaning": "操る", "example": "ドラえもんは、機械を巧みに操った。", "translation": "Doraemon skillfully manipulated the machine."},
     {"word": "cardigan", "meaning": "カーディガン", "example": "ドラえもんは、カーディガンを着て暖かくした。", "translation": "Doraemon wore a cardigan to keep warm."},
     {"word": "excel", "meaning": "優れている", "example": "ドラえもんは、機械の操作に優れている。", "translation": "Doraemon excels at operating machines."},
     {"word": "supporter", "meaning": "支持者", "example": "ドラえもんは、いつも友達の支持者だ。", "translation": "Doraemon is always a supporter of his friends."}
     ];
     break;
     case "高校英語149":
     item = [
     {"word": "analyze", "meaning": "分析する", "example": "ドラえもんは、データを分析した。", "translation": "Doraemon analyzed the data."},
     {"word": "disadvantage", "meaning": "不利な点", "example": "ドラえもんは、不利な状況でも諦めない。", "translation": "Doraemon does not give up even in a disadvantageous situation."},
     {"word": "beginner", "meaning": "初心者", "example": "のび太は、いつも初心者のように失敗する。", "translation": "Nobita always fails like a beginner."},
     {"word": "export", "meaning": "輸出する", "example": "ドラえもんは、未来の道具を輸出することにした。", "translation": "Doraemon decided to export future gadgets."},
     {"word": "obtain", "meaning": "手に入れる", "example": "ドラえもんは、新しい道具を手に入れた。", "translation": "Doraemon obtained a new gadget."},
     {"word": "terribly", "meaning": "ひどく", "example": "ドラえもんは、ひどく疲れてしまった。", "translation": "Doraemon was terribly tired."},
     {"word": "advance", "meaning": "前進する", "example": "ドラえもんは、一歩ずつ前進した。", "translation": "Doraemon advanced step by step."},
     {"word": "cooperate", "meaning": "協力する", "example": "ドラえもんは、みんなと協力して問題を解決した。", "translation": "Doraemon cooperated with everyone to solve the problem."},
     {"word": "devise", "meaning": "考案する", "example": "ドラえもんは、新しい計画を考案した。", "translation": "Doraemon devised a new plan."},
     {"word": "minimal", "meaning": "最小限の", "example": "ドラえもんは、最小限の力で動いた。", "translation": "Doraemon moved with minimal power."}
     ];
     break;
     case "高校英語150":
     item = [
     {"word": "affluent", "meaning": "裕福な", "example": "ドラえもんは、未来の裕福な家庭を訪問した。", "translation": "Doraemon visited a wealthy family in the future."},
     {"word": "rebel", "meaning": "反逆者", "example": "ドラえもんは、反逆者と戦った。", "translation": "Doraemon fought against the rebels."},
     {"word": "incentive", "meaning": "動機", "example": "ドラえもんは、新しいことを始める動機を探している。", "translation": "Doraemon is looking for an incentive to start something new."},
     {"word": "glimpse", "meaning": "ちらっと見る", "example": "ドラえもんは、未来をちらっと見た。", "translation": "Doraemon had a glimpse of the future."},
     {"word": "universe", "meaning": "宇宙", "example": "ドラえもんは、宇宙を自由に飛び回る。", "translation": "Doraemon flies freely through the universe."},
     {"word": "climatic", "meaning": "気候の", "example": "ドラえもんは、気候変動について心配している。", "translation": "Doraemon is worried about climatic changes."},
     {"word": "assistant", "meaning": "助手", "example": "ドラえもんは、のび太のアシスタントをすることもある。", "translation": "Doraemon sometimes acts as Nobita's assistant."},
     {"word": "learner", "meaning": "学習者", "example": "ドラえもんは、常に新しいことを学ぶ学習者だ。", "translation": "Doraemon is a learner who is always learning new things."},
     {"word": "annoyance", "meaning": "いらだち", "example": "ドラえもんは、のび太のわがままにいら立ちを感じる。", "translation": "Doraemon feels annoyance towards Nobita's selfishness."},
     {"word": "victory", "meaning": "勝利", "example": "ドラえもんは、困難を乗り越えて勝利を手に入れた。", "translation": "Doraemon overcame the difficulties and gained victory."}
     ];
     break;
    
     
     case "高校英語151":
     item = [
     {"word": "compulsory", "meaning": "義務的な", "example": "ドラえもんは、義務的な仕事はきちんとこなす。", "translation": "Doraemon performs his compulsory tasks properly."},
     {"word": "valid", "meaning": "有効な", "example": "ドラえもんは、未来の免許証が有効であることを確認した。", "translation": "Doraemon confirmed that his license from the future was valid."},
     {"word": "faith", "meaning": "信頼", "example": "のび太は、ドラえもんに信頼を置いている。", "translation": "Nobita has faith in Doraemon."},
     {"word": "necktie", "meaning": "ネクタイ", "example": "ドラえもんは、ネクタイを締めて正装した。", "translation": "Doraemon wore a necktie to dress formally."},
     {"word": "celebration", "meaning": "祝賀", "example": "ドラえもんは、誕生日を祝った。", "translation": "Doraemon had a celebration for his birthday."},
     {"word": "whereas", "meaning": "～である一方", "example": "のび太が怠け者である一方、ドラえもんはいつも頑張っている。", "translation": "Whereas Nobita is lazy, Doraemon is always working hard."},
     {"word": "ambitious", "meaning": "野心的な", "example": "ドラえもんは、未来の世界を変えようとする野心的な人物と出会った。", "translation": "Doraemon met an ambitious person who wanted to change the future."},
     {"word": "gap", "meaning": "隔たり", "example": "ドラえもんは、のび太との能力の隔たりを埋めようとした。", "translation": "Doraemon tried to bridge the gap in abilities between himself and Nobita."},
     {"word": "proudly", "meaning": "誇らしげに", "example": "ドラえもんは、誇らしげに自分の発明品を見せた。", "translation": "Doraemon proudly showed off his invention."},
     {"word": "wheat", "meaning": "小麦", "example": "ドラえもんは、小麦畑で収穫をした。", "translation": "Doraemon harvested wheat in the field."}
     ];
     break;
     case "高校英語152":
     item = [
     {"word": "bite", "meaning": "噛む", "example": "ドラえもんは、美味しいおやつを噛みしめた。", "translation": "Doraemon bit into a delicious snack."},
     {"word": "select", "meaning": "選ぶ", "example": "ドラえもんは、道具を慎重に選んだ。", "translation": "Doraemon selected his gadgets carefully."},
     {"word": "affect", "meaning": "影響を与える", "example": "ドラえもんの行動は、のび太に良い影響を与えている。", "translation": "Doraemon's actions positively affect Nobita."},
     {"word": "reflect", "meaning": "反映する", "example": "ドラえもんは、鏡に映る自分の姿を見た。", "translation": "Doraemon saw his reflection in the mirror."},
     {"word": "expert", "meaning": "専門家", "example": "ドラえもんは、未来の道具の専門家だ。", "translation": "Doraemon is an expert on future gadgets."},
     {"word": "significant", "meaning": "重要な", "example": "ドラえもんは、重要な決断を迫られた。", "translation": "Doraemon was faced with a significant decision."},
     {"word": "unknown", "meaning": "未知の", "example": "ドラえもんは、未知の星へ出発した。", "translation": "Doraemon departed for an unknown planet."},
     {"word": "locate", "meaning": "位置する", "example": "ドラえもんは、目的地がどこにあるのかを特定した。", "translation": "Doraemon located where his destination was."},
     {"word": "trap", "meaning": "罠", "example": "ドラえもんは、敵が仕掛けた罠に引っかかった。", "translation": "Doraemon got caught in a trap set by his enemy."},
     {"word": "task", "meaning": "任務", "example": "ドラえもんは、困難な任務に挑んだ。", "translation": "Doraemon took on a challenging task."}
     ];
     break;
     case "高校英語153":
     item = [
     {"word": "adopt", "meaning": "採用する", "example": "ドラえもんは、新しい計画を採用した。", "translation": "Doraemon adopted a new plan."},
     {"word": "kitten", "meaning": "子猫", "example": "ドラえもんは、子猫を拾って可愛がった。", "translation": "Doraemon picked up a kitten and cared for it."},
     {"word": "luggage", "meaning": "荷物", "example": "ドラえもんは、重い荷物を持って歩いた。", "translation": "Doraemon walked with heavy luggage."},
     {"word": "refresh", "meaning": "元気を取り戻す", "example": "ドラえもんは、お風呂に入ってリフレッシュした。", "translation": "Doraemon took a bath to refresh himself."},
     {"word": "prime", "meaning": "最盛期の", "example": "ドラえもんは、恐竜時代の最盛期に行った。", "translation": "Doraemon went to the prime of the dinosaur era."},
     {"word": "fluent", "meaning": "流暢な", "example": "ドラえもんは、様々な言語を流暢に話す。", "translation": "Doraemon speaks various languages fluently."},
     {"word": "conscious", "meaning": "意識している", "example": "ドラえもんは、常に安全を意識している。", "translation": "Doraemon is always conscious of safety."},
     {"word": "director", "meaning": "監督", "example": "ドラえもんは、映画の監督に会った。", "translation": "Doraemon met the director of a movie."},
     {"word": "combine", "meaning": "組み合わせる", "example": "ドラえもんは、道具を組み合わせて使った。", "translation": "Doraemon combined his gadgets and used them."},
     {"word": "strain", "meaning": "負担", "example": "ドラえもんは、重い荷物を持ち上げるのに負担を感じた。", "translation": "Doraemon felt the strain of lifting heavy luggage."}
     ];
     break;
     case "高校英語154":
     item = [
     {"word": "imperial", "meaning": "帝国の", "example": "ドラえもんは、帝国の都を訪れた。", "translation": "Doraemon visited the capital of an empire."},
     {"word": "panel", "meaning": "パネル", "example": "ドラえもんは、太陽光パネルを調べた。", "translation": "Doraemon examined a solar panel."},
     {"word": "element", "meaning": "要素", "example": "ドラえもんは、問題を解決するために必要な要素を調べた。", "translation": "Doraemon investigated the elements needed to solve the problem."},
     {"word": "capacity", "meaning": "容量", "example": "ドラえもんは、道具の容量を調べた。", "translation": "Doraemon examined the capacity of the gadget."},
     {"word": "technique", "meaning": "技術", "example": "ドラえもんは、新しい技術を学んだ。", "translation": "Doraemon learned a new technique."},
     {"word": "decorate", "meaning": "飾る", "example": "ドラえもんは、部屋を飾り付けた。", "translation": "Doraemon decorated the room."},
     {"word": "rent", "meaning": "借りる", "example": "ドラえもんは、部屋を借りた。", "translation": "Doraemon rented a room."},
     {"word": "observe", "meaning": "観察する", "example": "ドラえもんは、動物を観察した。", "translation": "Doraemon observed the animals."},
     {"word": "award", "meaning": "賞", "example": "ドラえもんは、未来で賞を受賞した。", "translation": "Doraemon received an award in the future."},
     {"word": "presentation", "meaning": "プレゼンテーション", "example": "ドラえもんは、プレゼンテーションを行った。", "translation": "Doraemon gave a presentation."}
     ];
     break;
     case "高校英語155":
     item = [
     {"word": "bonus", "meaning": "ボーナス", "example": "ドラえもんは、仕事を頑張ってボーナスをもらった。", "translation": "Doraemon received a bonus for working hard."},
     {"word": "pronunciation", "meaning": "発音", "example": "ドラえもんは、発音を練習した。", "translation": "Doraemon practiced his pronunciation."},
     {"word": "primary", "meaning": "主要な", "example": "ドラえもんの主要な目的は、のび太を助けることだ。", "translation": "Doraemon's primary goal is to help Nobita."},
     {"word": "tights", "meaning": "タイツ", "example": "ドラえもんは、タイツを履いて寒さをしのいだ。", "translation": "Doraemon wore tights to stay warm."},
     {"word": "underline", "meaning": "下線を引く", "example": "ドラえもんは、重要な箇所に下線を引いた。", "translation": "Doraemon underlined the important parts."},
     {"word": "bond", "meaning": "絆", "example": "ドラえもんは、友達との絆を大切にしている。", "translation": "Doraemon values the bonds he has with his friends."},
     {"word": "notion", "meaning": "概念", "example": "ドラえもんは、時間という概念を理解している。", "translation": "Doraemon understands the notion of time."},
     {"word": "outbreak", "meaning": "発生", "example": "ドラえもんは、病気の発生を防いだ。", "translation": "Doraemon prevented the outbreak of a disease."},
     {"word": "explore", "meaning": "探検する", "example": "ドラえもんは、未知の世界を探検した。", "translation": "Doraemon explored an unknown world."},
     {"word": "article", "meaning": "記事", "example": "ドラえもんは、新聞記事を読んだ。", "translation": "Doraemon read an article in the newspaper."}
     ];
     break;
     case "高校英語156":
     item = [
     {"word": "irritate", "meaning": "いらいらさせる", "example": "のび太は、いつもドラえもんをいらいらさせている。", "translation": "Nobita always irritates Doraemon."},
     {"word": "shrink", "meaning": "縮む", "example": "ドラえもんは、道具を使って体を縮ませた。", "translation": "Doraemon used a gadget to shrink his body."},
     {"word": "depression", "meaning": "不況", "example": "ドラえもんは、未来の不況を心配している。", "translation": "Doraemon is worried about the economic depression of the future."},
     {"word": "possession", "meaning": "所有", "example": "ドラえもんは、道具を所有している。", "translation": "Doraemon has possession of many gadgets."},
     {"word": "loyalty", "meaning": "忠誠心", "example": "ドラえもんは、友達に対して忠誠心を持っている。", "translation": "Doraemon has loyalty to his friends."},
     {"word": "coaster", "meaning": "コースター", "example": "ドラえもんは、遊園地でジェットコースターに乗った。", "translation": "Doraemon rode a roller coaster at the amusement park."},
     {"word": "sneak", "meaning": "こっそり行く", "example": "ドラえもんは、こっそり図書館へ行った。", "translation": "Doraemon sneaked into the library."},
     {"word": "mediate", "meaning": "仲介する", "example": "ドラえもんは、友達の喧嘩を仲介した。", "translation": "Doraemon mediated a fight between his friends."},
     {"word": "accelerate", "meaning": "加速する", "example": "ドラえもんは、乗り物を加速させた。", "translation": "Doraemon accelerated the vehicle."},
     {"word": "linger", "meaning": "長居する", "example": "ドラえもんは、思い出の場所に長居した。", "translation": "Doraemon lingered at the place with memories."}
     ];
     break;
     case "高校英語157":
     item = [
     {"word": "occupy", "meaning": "占める", "example": "ドラえもんは、いつも頭の中をどら焼きで占めている。", "translation": "Dorayaki always occupies Doraemon's thoughts."},
     {"word": "timber", "meaning": "木材", "example": "ドラえもんは、木材を使って家を作った。", "translation": "Doraemon made a house using timber."},
     {"word": "gross", "meaning": "総計の", "example": "ドラえもんは、総計の金額を計算した。", "translation": "Doraemon calculated the gross amount of money."},
     {"word": "yearn", "meaning": "憧れる", "example": "のび太は、ドラえもんの能力に憧れている。", "translation": "Nobita yearns for Doraemon's abilities."},
     {"word": "upstage", "meaning": "出し抜く", "example": "ドラえもんは、みんなを出し抜いた。", "translation": "Doraemon upstaged everyone."},
     {"word": "chancellor", "meaning": "総長", "example": "ドラえもんは、大学の総長に会った。", "translation": "Doraemon met the chancellor of the university."},
     {"word": "dropout", "meaning": "中退者", "example": "ドラえもんは、学校を中退した人に会った。", "translation": "Doraemon met a dropout from school."},
     {"word": "politely", "meaning": "丁寧に", "example": "ドラえもんは、いつも丁寧に話す。", "translation": "Doraemon always speaks politely."},
     {"word": "spiral", "meaning": "螺旋状の", "example": "ドラえもんは、螺旋階段を上った。", "translation": "Doraemon climbed a spiral staircase."},
     {"word": "persistent", "meaning": "粘り強い", "example": "ドラえもんは、粘り強く問題を解決した。", "translation": "Doraemon solved the problem persistently."}
     ];
     break;
     case "高校英語158":
     item = [
     {"word": "selective", "meaning": "選択的な", "example": "ドラえもんは、道具を慎重に選択した。", "translation": "Doraemon was selective in choosing his gadgets."},
     {"word": "precede", "meaning": "先行する", "example": "ドラえもんは、先行して目的地に向かった。", "translation": "Doraemon preceded to the destination."},
     {"word": "evacuate", "meaning": "避難させる", "example": "ドラえもんは、人々を安全な場所に避難させた。", "translation": "Doraemon evacuated people to a safe place."},
     {"word": "rid", "meaning": "取り除く", "example": "ドラえもんは、街から悪いものを全て取り除いた。", "translation": "Doraemon got rid of all the bad things in the town."},
     {"word": "uproot", "meaning": "根こそぎにする", "example": "ドラえもんは、木を根こそぎにした。", "translation": "Doraemon uprooted the tree."},
     {"word": "granddad", "meaning": "おじいちゃん", "example": "のび太は、おじいちゃんが好きだ。", "translation": "Nobita likes his granddad."},
     {"word": "brand", "meaning": "ブランド", "example": "ドラえもんは、有名なブランドの服を着た。", "translation": "Doraemon wore clothes from a famous brand."},
     {"word": "retire", "meaning": "引退する", "example": "ドラえもんは、引退したスポーツ選手に会った。", "translation": "Doraemon met a retired athlete."},
     {"word": "discharge", "meaning": "放出する", "example": "ドラえもんは、エネルギーを放出する道具を使った。", "translation": "Doraemon used a gadget that discharged energy."},
     {"word": "dispute", "meaning": "論争", "example": "ドラえもんは、論争を避けた。", "translation": "Doraemon avoided the dispute."}
     ];
     break;
     case "高校英語159":
     item = [
     {"word": "explode", "meaning": "爆発する", "example": "ドラえもんは、爆発の危険がある道具を使わなかった。", "translation": "Doraemon did not use a gadget that was in danger of exploding."},
     {"word": "embarrassment", "meaning": "当惑", "example": "ドラえもんは、のび太の失敗に当惑した。", "translation": "Doraemon was embarrassed by Nobita's failure."},
     {"word": "gratitude", "meaning": "感謝", "example": "ドラえもんは、みんなの協力に感謝した。", "translation": "Doraemon expressed his gratitude for everyone's cooperation."},
     {"word": "venue", "meaning": "会場", "example": "ドラえもんは、イベントの会場を探した。", "translation": "Doraemon looked for a venue for the event."},
     {"word": "portion", "meaning": "部分", "example": "ドラえもんは、ケーキの一部を食べた。", "translation": "Doraemon ate a portion of the cake."},
     {"word": "pedestrian", "meaning": "歩行者", "example": "ドラえもんは、歩行者に道を譲った。", "translation": "Doraemon gave way to pedestrians."},
     {"word": "suppress", "meaning": "抑制する", "example": "ドラえもんは、怒りを抑制した。", "translation": "Doraemon suppressed his anger."},
     {"word": "update", "meaning": "更新する", "example": "ドラえもんは、情報を更新した。", "translation": "Doraemon updated the information."},
     {"word": "flexible", "meaning": "柔軟な", "example": "ドラえもんは、柔軟な対応で問題を解決した。", "translation": "Doraemon solved the problem with a flexible approach."},
     {"word": "assignment", "meaning": "課題", "example": "ドラえもんは、課題を終わらせた。", "translation": "Doraemon completed the assignment."}
     ];
     break;
     case "高校英語160":
     item = [
     {"word": "legislation", "meaning": "法律", "example": "ドラえもんは、未来の法律について学んだ。", "translation": "Doraemon learned about future legislation."},
     {"word": "flip", "meaning": "ひっくり返す", "example": "ドラえもんは、フライパンをひっくり返した。", "translation": "Doraemon flipped the frying pan."},
     {"word": "commute", "meaning": "通勤する", "example": "ドラえもんは、未来の通勤方法を試した。", "translation": "Doraemon tried a future commuting method."},
     {"word": "consist", "meaning": "構成される", "example": "ドラえもんの体は、様々な部品で構成されている。", "translation": "Doraemon's body consists of various parts."},
     {"word": "jog", "meaning": "ジョギングする", "example": "ドラえもんは、ジョギングをした。", "translation": "Doraemon went jogging."},
     {"word": "apparently", "meaning": "どうやら", "example": "ドラえもんは、どうやら問題を解決したらしい。", "translation": "Apparently, Doraemon solved the problem."},
     {"word": "essay", "meaning": "エッセー", "example": "ドラえもんは、エッセーを書いてみた。", "translation": "Doraemon tried writing an essay."},
     {"word": "gravity", "meaning": "重力", "example": "ドラえもんは、重力について学んだ。", "translation": "Doraemon learned about gravity."},
     {"word": "hybrid", "meaning": "混成の", "example": "ドラえもんは、ハイブリッド車に乗った。", "translation": "Doraemon rode in a hybrid car."},
     {"word": "emphasize", "meaning": "強調する", "example": "ドラえもんは、安全の大切さを強調した。", "translation": "Doraemon emphasized the importance of safety."}
     ];
     break;
    
     
     case "高校英語161":
     item = [
     {"word": "amplify", "meaning": "増幅する", "example": "ドラえもんは、音を増幅する道具を使った。", "translation": "Doraemon used a gadget that amplified sound."},
     {"word": "emotional", "meaning": "感情的な", "example": "ドラえもんは、感情的な場面で感動した。", "translation": "Doraemon was moved during an emotional scene."},
     {"word": "medieval", "meaning": "中世の", "example": "ドラえもんは、中世の時代にタイムスリップした。", "translation": "Doraemon time-slipped to the medieval era."},
     {"word": "whatever", "meaning": "何でも", "example": "ドラえもんは、何でも好きな道具を出せる。", "translation": "Doraemon can bring out whatever gadget he wants."},
     {"word": "publication", "meaning": "出版物", "example": "ドラえもんは、未来の出版物を読んだ。", "translation": "Doraemon read a publication from the future."},
     {"word": "allowance", "meaning": "手当", "example": "ドラえもんは、未来の学校で手当をもらった。", "translation": "Doraemon received an allowance at a school from the future."},
     {"word": "flatter", "meaning": "おだてる", "example": "スネ夫は、いつもジャイアンをおだてている。", "translation": "Suneo is always flattering Gian."},
     {"word": "visual", "meaning": "視覚的な", "example": "ドラえもんは、視覚的な情報を使って分析した。", "translation": "Doraemon used visual information to analyze."},
     {"word": "presence", "meaning": "存在", "example": "ドラえもんは、のび太にとって大切な存在だ。", "translation": "Doraemon is an important presence for Nobita."},
     {"word": "countless", "meaning": "無数の", "example": "ドラえもんは、無数の道具を持っている。", "translation": "Doraemon has countless gadgets."}
     ];
     break;
     case "高校英語162":
     item = [
     {"word": "contribution", "meaning": "貢献", "example": "ドラえもんは、社会への貢献を考えた。", "translation": "Doraemon thought about his contribution to society."},
     {"word": "virus", "meaning": "ウイルス", "example": "ドラえもんは、ウイルスから身を守る道具を使った。", "translation": "Doraemon used a gadget to protect himself from viruses."},
     {"word": "highlight", "meaning": "強調する", "example": "ドラえもんは、重要なポイントを強調した。", "translation": "Doraemon highlighted the important points."},
     {"word": "teaching", "meaning": "教えること", "example": "ドラえもんは、のび太に勉強を教えることを楽しんでいる。", "translation": "Doraemon enjoys teaching Nobita."},
     {"word": "acquaint", "meaning": "知り合わせる", "example": "ドラえもんは、友達を紹介して知り合わせにした。", "translation": "Doraemon introduced his friends to each other."},
     {"word": "journal", "meaning": "専門誌", "example": "ドラえもんは、未来の科学雑誌を読んだ。", "translation": "Doraemon read a scientific journal from the future."},
     {"word": "dismantle", "meaning": "分解する", "example": "ドラえもんは、機械を分解して構造を調べた。", "translation": "Doraemon dismantled the machine to investigate its structure."},
     {"word": "unusual", "meaning": "珍しい", "example": "ドラえもんは、珍しい動物に会った。", "translation": "Doraemon met an unusual animal."},
     {"word": "despise", "meaning": "軽蔑する", "example": "ドラえもんは、不正を軽蔑する。", "translation": "Doraemon despises injustice."},
     {"word": "conscience", "meaning": "良心", "example": "ドラえもんは、良心に従って行動する。", "translation": "Doraemon acts according to his conscience."}
     ];
     break;
     case "高校英語163":
     item = [
     {"word": "encounter", "meaning": "遭遇する", "example": "ドラえもんは、予期せぬ敵に遭遇した。", "translation": "Doraemon encountered an unexpected enemy."},
     {"word": "victim", "meaning": "犠牲者", "example": "ドラえもんは、事件の犠牲者を救った。", "translation": "Doraemon rescued the victims of the incident."},
     {"word": "diver", "meaning": "潜水士", "example": "ドラえもんは、潜水士のように海に潜った。", "translation": "Doraemon dove into the sea like a diver."},
     {"word": "afford", "meaning": "余裕がある", "example": "ドラえもんは、お金に余裕がある。", "translation": "Doraemon can afford to spend money."},
     {"word": "secure", "meaning": "確保する", "example": "ドラえもんは、安全な場所を確保した。", "translation": "Doraemon secured a safe place."},
     {"word": "software", "meaning": "ソフトウェア", "example": "ドラえもんは、新しいソフトウェアをインストールした。", "translation": "Doraemon installed new software."},
     {"word": "location", "meaning": "場所", "example": "ドラえもんは、道具を隠した場所を特定した。", "translation": "Doraemon located the place where the gadgets were hidden."},
     {"word": "critical", "meaning": "重大な", "example": "ドラえもんは、危機的な状況を回避した。", "translation": "Doraemon avoided a critical situation."},
     {"word": "slightly", "meaning": "わずかに", "example": "ドラえもんは、少しだけ変化を感じた。", "translation": "Doraemon sensed a slightly change."},
     {"word": "estimate", "meaning": "見積もる", "example": "ドラえもんは、時間を正確に見積もった。", "translation": "Doraemon estimated the time accurately."}
     ];
     break;
     case "高校英語164":
     item = [
     {"word": "bravery", "meaning": "勇敢さ", "example": "ドラえもんは、のび太の勇敢さを褒めた。", "translation": "Doraemon praised Nobita's bravery."},
     {"word": "accumulate", "meaning": "蓄積する", "example": "ドラえもんは、知識を蓄積している。", "translation": "Doraemon is accumulating knowledge."},
     {"word": "pill", "meaning": "錠剤", "example": "ドラえもんは、未来の錠剤を飲んだ。", "translation": "Doraemon took a pill from the future."},
     {"word": "skim", "meaning": "すくい取る", "example": "ドラえもんは、スープの表面をすくった。", "translation": "Doraemon skimmed the surface of the soup."},
     {"word": "nationality", "meaning": "国籍", "example": "ドラえもんは、色々な国籍の人々と友達になった。", "translation": "Doraemon made friends with people of various nationalities."},
     {"word": "playground", "meaning": "遊び場", "example": "ドラえもんは、公園の遊び場で遊んだ。", "translation": "Doraemon played at the playground in the park."},
     {"word": "nuisance", "meaning": "迷惑", "example": "ドラえもんは、周りに迷惑をかけないように注意した。", "translation": "Doraemon was careful not to be a nuisance to others."},
     {"word": "electrical", "meaning": "電気の", "example": "ドラえもんは、電気的な道具を使った。", "translation": "Doraemon used an electrical gadget."},
     {"word": "lobby", "meaning": "ロビー", "example": "ドラえもんは、ホテルのロビーで待っていた。", "translation": "Doraemon waited in the lobby of the hotel."},
     {"word": "generous", "meaning": "寛大な", "example": "ドラえもんは、とても寛大な心の持ち主だ。", "translation": "Doraemon has a very generous heart."}
     ];
     break;
     case "高校英語165":
     item = [
     {"word": "react", "meaning": "反応する", "example": "ドラえもんは、のび太の言葉にすぐに反応した。", "translation": "Doraemon reacted immediately to Nobita's words."},
     {"word": "settle", "meaning": "解決する", "example": "ドラえもんは、問題を平和的に解決した。", "translation": "Doraemon settled the problem peacefully."},
     {"word": "definition", "meaning": "定義", "example": "ドラえもんは、友情の定義について話した。", "translation": "Doraemon talked about the definition of friendship."},
     {"word": "merely", "meaning": "単に", "example": "ドラえもんは、単に手伝いたいだけだと言った。", "translation": "Doraemon said he merely wanted to help."},
     {"word": "adjust", "meaning": "調整する", "example": "ドラえもんは、機械を調整した。", "translation": "Doraemon adjusted the machine."},
     {"word": "organization", "meaning": "組織", "example": "ドラえもんは、未来の組織を調べた。", "translation": "Doraemon investigated an organization from the future."},
     {"word": "decade", "meaning": "十年", "example": "ドラえもんは、十年後の未来に行った。", "translation": "Doraemon went to the future after a decade."},
     {"word": "environmental", "meaning": "環境の", "example": "ドラえもんは、環境問題について心配している。", "translation": "Doraemon is concerned about environmental problems."},
     {"word": "farewell", "meaning": "別れ", "example": "ドラえもんは、別れを惜しんだ。", "translation": "Doraemon said farewell with sadness."},
     {"word": "improvement", "meaning": "改善", "example": "ドラえもんは、道具の改善を重ねた。", "translation": "Doraemon made improvements to his gadgets."}
     ];
     break;
     case "高校英語166":
     item = [
     {"word": "provision", "meaning": "提供", "example": "ドラえもんは、みんなに食料を提供した。", "translation": "Doraemon provided everyone with food."},
     {"word": "ecological", "meaning": "生態学的な", "example": "ドラえもんは、生態学的な観点から問題を考えた。", "translation": "Doraemon thought about the problem from an ecological perspective."},
     {"word": "beneath", "meaning": "～の下に", "example": "ドラえもんは、地下に隠れていた。", "translation": "Doraemon was hiding beneath the ground."},
     {"word": "status", "meaning": "地位", "example": "ドラえもんは、未来での地位について学んだ。", "translation": "Doraemon learned about status in the future."},
     {"word": "freely", "meaning": "自由に", "example": "ドラえもんは、空を自由に飛び回りたい。", "translation": "Doraemon wants to fly freely in the sky."},
     {"word": "user", "meaning": "ユーザー", "example": "ドラえもんは、道具のユーザーの意見を聞いた。", "translation": "Doraemon listened to the user's opinions about his gadgets."},
     {"word": "tightly", "meaning": "きつく", "example": "ドラえもんは、ドアをきつく閉めた。", "translation": "Doraemon closed the door tightly."},
     {"word": "reward", "meaning": "報酬", "example": "ドラえもんは、報酬をもらって嬉しかった。", "translation": "Doraemon was happy to receive a reward."},
     {"word": "fortune", "meaning": "財産", "example": "ドラえもんは、未来の財産家に出会った。", "translation": "Doraemon met a wealthy person from the future."},
     {"word": "worldwide", "meaning": "世界的な", "example": "ドラえもんの人気は、世界的に広がっている。", "translation": "Doraemon's popularity is worldwide."}
     ];
     break;
     case "高校英語167":
     item = [
     {"word": "voucher", "meaning": "引換券", "example": "ドラえもんは、引換券を使って商品を手に入れた。", "translation": "Doraemon obtained the product using a voucher."},
     {"word": "collaborate", "meaning": "協力する", "example": "ドラえもんは、他のロボットと協力して問題を解決した。", "translation": "Doraemon collaborated with other robots to solve the problem."},
     {"word": "fatal", "meaning": "致命的な", "example": "ドラえもんは、致命的な危機を回避した。", "translation": "Doraemon avoided a fatal crisis."},
     {"word": "fee", "meaning": "料金", "example": "ドラえもんは、入場料を支払った。", "translation": "Doraemon paid the entrance fee."},
     {"word": "aspect", "meaning": "側面", "example": "ドラえもんは、物事の様々な側面を見た。", "translation": "Doraemon looked at various aspects of things."},
     {"word": "ruin", "meaning": "破滅させる", "example": "ドラえもんは、地球を破滅させる計画を阻止した。", "translation": "Doraemon stopped the plan to ruin the earth."},
     {"word": "curious", "meaning": "好奇心旺盛な", "example": "ドラえもんは、好奇心旺盛で何でも知りたがる。", "translation": "Doraemon is curious and eager to learn about anything."},
     {"word": "aisle", "meaning": "通路", "example": "ドラえもんは、スーパーマーケットの通路を歩いた。", "translation": "Doraemon walked through the aisle in the supermarket."},
     {"word": "pronounce", "meaning": "発音する", "example": "ドラえもんは、難しい言葉を発音した。", "translation": "Doraemon pronounced a difficult word."},
     {"word": "academic", "meaning": "学術的な", "example": "ドラえもんは、学術的な研究を行った。", "translation": "Doraemon conducted academic research."}
     ];
     break;
     case "高校英語168":
     item = [
     {"word": "grandchild", "meaning": "孫", "example": "ドラえもんは、孫の世話をするロボットだった。", "translation": "Doraemon was a robot meant to take care of grandchildren."},
     {"word": "debris", "meaning": "破片", "example": "ドラえもんは、爆発で飛び散った破片を片付けた。", "translation": "Doraemon cleaned up the debris from the explosion."},
     {"word": "unemployment", "meaning": "失業", "example": "ドラえもんは、失業問題に関心があった。", "translation": "Doraemon was concerned about unemployment issues."},
     {"word": "lawsuit", "meaning": "訴訟", "example": "ドラえもんは、訴訟を起こされた。", "translation": "Doraemon had a lawsuit filed against him."},
     {"word": "experiment", "meaning": "実験", "example": "ドラえもんは、新しい道具の実験をした。", "translation": "Doraemon conducted an experiment with a new gadget."},
     {"word": "issue", "meaning": "問題", "example": "ドラえもんは、様々な問題解決に取り組んでいる。", "translation": "Doraemon is dealing with various issues."},
     {"word": "slice", "meaning": "薄切り", "example": "ドラえもんは、パンを薄く切った。", "translation": "Doraemon cut the bread into a thin slice."},
     {"word": "recommend", "meaning": "勧める", "example": "ドラえもんは、のび太に本を読むことを勧めた。", "translation": "Doraemon recommended Nobita to read books."},
     {"word": "origin", "meaning": "起源", "example": "ドラえもんは、地球の起源について学んだ。", "translation": "Doraemon learned about the origin of the Earth."},
     {"word": "extremely", "meaning": "非常に", "example": "ドラえもんは、非常に驚いていた。", "translation": "Doraemon was extremely surprised."}
     ];
     break;
     case "高校英語169":
     item = [
     {"word": "approve", "meaning": "承認する", "example": "ドラえもんは、のび太の計画を承認した。", "translation": "Doraemon approved Nobita's plan."},
     {"word": "potential", "meaning": "潜在的な", "example": "ドラえもんは、のび太の潜在的な能力を引き出そうとする。", "translation": "Doraemon tries to bring out Nobita's potential abilities."},
     {"word": "laptop", "meaning": "ノートパソコン", "example": "ドラえもんは、ノートパソコンを使って作業をした。", "translation": "Doraemon worked using a laptop."},
     {"word": "achievement", "meaning": "業績", "example": "ドラえもんは、素晴らしい業績を上げた。", "translation": "Doraemon made a remarkable achievement."},
     {"word": "ginger", "meaning": "生姜", "example": "ドラえもんは、生姜を使った料理を作った。", "translation": "Doraemon made a dish using ginger."},
     {"word": "construct", "meaning": "建設する", "example": "ドラえもんは、秘密基地を建設した。", "translation": "Doraemon constructed a secret base."},
     {"word": "reject", "meaning": "拒否する", "example": "ドラえもんは、悪い誘いを拒否した。", "translation": "Doraemon rejected the bad invitation."},
     {"word": "pile", "meaning": "積み重ね", "example": "ドラえもんは、本を積み重ねた。", "translation": "Doraemon piled up the books."},
     {"word": "launch", "meaning": "打ち上げる", "example": "ドラえもんは、ロケットを打ち上げた。", "translation": "Doraemon launched a rocket."},
     {"word": "instant", "meaning": "即席の", "example": "ドラえもんは、インスタントラーメンを食べてみた。", "translation": "Doraemon tried instant ramen."}
     ];
     break;
     case "高校英語170":
     item = [
     {"word": "miniature", "meaning": "小型の", "example": "ドラえもんは、小型の秘密道具を使った。", "translation": "Doraemon used a miniature secret gadget."},
     {"word": "contrary", "meaning": "反対に", "example": "ドラえもんは、のび太の意見とは反対のことを言った。", "translation": "Doraemon said the contrary of Nobita's opinion."},
     {"word": "tense", "meaning": "緊張した", "example": "ドラえもんは、緊張した場面で冷静さを保った。", "translation": "Doraemon remained calm in a tense situation."},
     {"word": "stimulate", "meaning": "刺激する", "example": "ドラえもんは、頭を刺激する道具を使った。", "translation": "Doraemon used a gadget that stimulated his mind."},
     {"word": "federal", "meaning": "連邦の", "example": "ドラえもんは、未来の連邦政府を訪れた。", "translation": "Doraemon visited the future federal government."},
     {"word": "confirm", "meaning": "確認する", "example": "ドラえもんは、情報を確認した。", "translation": "Doraemon confirmed the information."},
     {"word": "harmony", "meaning": "調和", "example": "ドラえもんは、みんなとの調和を大切にしている。", "translation": "Doraemon values harmony with everyone."},
     {"word": "psychiatry", "meaning": "精神医学", "example": "ドラえもんは、精神医学について学んだ。", "translation": "Doraemon learned about psychiatry."},
     {"word": "fashionable", "meaning": "おしゃれな", "example": "ドラえもんは、おしゃれな服を着て出かけた。", "translation": "Doraemon went out wearing fashionable clothes."},
     {"word": "facilitate", "meaning": "促進する", "example": "ドラえもんは、学習を促進する道具を使った。", "translation": "Doraemon used gadgets to facilitate learning."}
     ];
     break;
    
     
     case "高校英語171":
     item = [
     {"word": "delay", "meaning": "遅らせる", "example": "ドラえもんは、出発時間を遅らせないようにした。", "translation": "Doraemon made sure not to delay the departure time."},
     {"word": "vary", "meaning": "変化する", "example": "ドラえもんの道具は、大きさが変化するものがある。", "translation": "Some of Doraemon's gadgets vary in size."},
     {"word": "reveal", "meaning": "明らかにする", "example": "ドラえもんは、事件の真相を明らかにした。", "translation": "Doraemon revealed the truth behind the incident."},
     {"word": "logical", "meaning": "論理的な", "example": "ドラえもんは、論理的な思考をする。", "translation": "Doraemon thinks logically."},
     {"word": "strip", "meaning": "剥ぎ取る", "example": "ドラえもんは、古い壁紙を剥ぎ取った。", "translation": "Doraemon stripped off the old wallpaper."},
     {"word": "slam", "meaning": "ピシャリと閉める", "example": "ジャイアンは、ドアをピシャリと閉めた。", "translation": "Gian slammed the door shut."},
     {"word": "equality", "meaning": "平等", "example": "ドラえもんは、平等を重んじる。", "translation": "Doraemon values equality."},
     {"word": "skeleton", "meaning": "骨格", "example": "ドラえもんは、恐竜の骨格を見た。", "translation": "Doraemon looked at the skeleton of a dinosaur."},
     {"word": "compound", "meaning": "化合物", "example": "ドラえもんは、化学の実験で化合物を作った。", "translation": "Doraemon made a compound in a chemistry experiment."},
     {"word": "formation", "meaning": "形成", "example": "ドラえもんは、岩の形成過程を見た。", "translation": "Doraemon saw the formation process of rocks."}
     ];
     break;
     case "高校英語172":
     item = [
     {"word": "capture", "meaning": "捕獲する", "example": "ドラえもんは、逃げ出した動物を捕獲した。", "translation": "Doraemon captured the escaped animal."},
     {"word": "prohibit", "meaning": "禁止する", "example": "ドラえもんは、危険な場所に行くことを禁止した。", "translation": "Doraemon prohibited going to dangerous places."},
     {"word": "widen", "meaning": "広げる", "example": "ドラえもんは、どこでもドアで部屋を広げた。", "translation": "Doraemon widened the room with the Anywhere Door."},
     {"word": "incident", "meaning": "事件", "example": "ドラえもんは、過去の事件を調査した。", "translation": "Doraemon investigated an incident from the past."},
     {"word": "frontier", "meaning": "最先端", "example": "ドラえもんは、科学技術の最先端を見てきた。", "translation": "Doraemon has seen the frontier of scientific technology."},
     {"word": "trustworthy", "meaning": "信頼できる", "example": "ドラえもんは、信頼できる友達だ。", "translation": "Doraemon is a trustworthy friend."},
     {"word": "mammal", "meaning": "哺乳類", "example": "ドラえもんは、哺乳類について研究した。", "translation": "Doraemon researched mammals."},
     {"word": "executive", "meaning": "重役", "example": "ドラえもんは、会社の重役に会った。", "translation": "Doraemon met an executive of a company."},
     {"word": "ray", "meaning": "光線", "example": "ドラえもんは、不思議な光線を浴びた。", "translation": "Doraemon was bathed in a strange ray."},
     {"word": "overplay", "meaning": "誇張する", "example": "ドラえもんは、自分の力を誇張することはしない。", "translation": "Doraemon does not overplay his abilities."}
     ];
     break;
     case "高校英語173":
     item = [
     {"word": "timetable", "meaning": "時間割", "example": "のび太は、いつも時間割を間違える。", "translation": "Nobita always gets his timetable wrong."},
     {"word": "ignore", "meaning": "無視する", "example": "ドラえもんは、悪いことは無視しない。", "translation": "Doraemon does not ignore bad things."},
     {"word": "passion", "meaning": "情熱", "example": "ドラえもんは、友達を助ける情熱がある。", "translation": "Doraemon has the passion to help his friends."},
     {"word": "possibly", "meaning": "もしかしたら", "example": "ドラえもんは、「もしかしたら、出来るかもしれない」と言った。", "translation": "Doraemon said, 'Possibly, I might be able to do it'."},
     {"word": "comedy", "meaning": "コメディー", "example": "ドラえもんは、コメディー映画を見て笑った。", "translation": "Doraemon laughed while watching a comedy movie."},
     {"word": "frequently", "meaning": "頻繁に", "example": "のび太は、頻繁に失敗する。", "translation": "Nobita fails frequently."},
     {"word": "strictly", "meaning": "厳格に", "example": "ドラえもんは、ルールを厳格に守る。", "translation": "Doraemon strictly follows the rules."},
     {"word": "flesh", "meaning": "肉", "example": "ドラえもんは、肉を食べる。", "translation": "Doraemon eats meat."},
     {"word": "unfold", "meaning": "展開する", "example": "ドラえもんは、地図を広げて見た。", "translation": "Doraemon unfolded the map and looked at it."},
     {"word": "automatic", "meaning": "自動的な", "example": "ドラえもんは、自動ドアを通り抜けた。", "translation": "Doraemon passed through an automatic door."}
     ];
     break;
     case "高校英語174":
     item = [
     {"word": "clumsy", "meaning": "不器用な", "example": "のび太は、とても不器用だ。", "translation": "Nobita is very clumsy."},
     {"word": "employment", "meaning": "雇用", "example": "ドラえもんは、未来の雇用状況について調べた。", "translation": "Doraemon researched employment conditions in the future."},
     {"word": "reduction", "meaning": "削減", "example": "ドラえもんは、エネルギー消費を削減する計画を立てた。", "translation": "Doraemon made a plan to reduce energy consumption."},
     {"word": "abuse", "meaning": "虐待", "example": "ドラえもんは、動物虐待を許さない。", "translation": "Doraemon does not allow animal abuse."},
     {"word": "mentally", "meaning": "精神的に", "example": "ドラえもんは、のび太を精神的にサポートしている。", "translation": "Doraemon provides mental support for Nobita."},
     {"word": "annual", "meaning": "年間の", "example": "ドラえもんは、年間の計画を立てた。", "translation": "Doraemon made an annual plan."},
     {"word": "graduation", "meaning": "卒業", "example": "ドラえもんは、のび太の卒業を祝った。", "translation": "Doraemon celebrated Nobita's graduation."},
     {"word": "confident", "meaning": "自信のある", "example": "ドラえもんは、いつも自信を持って行動する。", "translation": "Doraemon always acts with confidence."},
     {"word": "messy", "meaning": "散らかった", "example": "のび太の部屋は、いつも散らかっている。", "translation": "Nobita's room is always messy."},
     {"word": "steady", "meaning": "安定した", "example": "ドラえもんは、安定した歩き方をする。", "translation": "Doraemon has a steady gait."}
     ];
     break;
     case "高校英語175":
     item = [
     {"word": "accompany", "meaning": "同行する", "example": "ドラえもんは、のび太に同行して街へ行った。", "translation": "Doraemon accompanied Nobita to the town."},
     {"word": "frame", "meaning": "枠", "example": "ドラえもんは、写真を額縁に入れた。", "translation": "Doraemon put the picture in a frame."},
     {"word": "appeal", "meaning": "訴える", "example": "ドラえもんは、みんなに助けを訴えた。", "translation": "Doraemon appealed to everyone for help."},
     {"word": "virtually", "meaning": "事実上", "example": "ドラえもんは、事実上何でもできる。", "translation": "Doraemon can do virtually anything."},
     {"word": "therapy", "meaning": "療法", "example": "ドラえもんは、心の治療を受けた。", "translation": "Doraemon received therapy."},
     {"word": "blade", "meaning": "刃", "example": "ドラえもんは、鋭い刃物を使った。", "translation": "Doraemon used a sharp blade."},
     {"word": "detect", "meaning": "検出する", "example": "ドラえもんは、危険を検出するセンサーを持っている。", "translation": "Doraemon has a sensor that can detect danger."},
     {"word": "adequate", "meaning": "十分な", "example": "ドラえもんは、十分な食料を持ってきた。", "translation": "Doraemon brought adequate food."},
     {"word": "aspirin", "meaning": "アスピリン", "example": "のび太は、アスピリンを飲んで頭痛を治そうとした。", "translation": "Nobita tried to cure his headache by taking aspirin."},
     {"word": "merge", "meaning": "合併する", "example": "ドラえもんは、二つの会社を合併させた。", "translation": "Doraemon merged two companies."}
     ];
     break;
     case "高校英語176":
     item = [
     {"word": "responsibility", "meaning": "責任", "example": "ドラえもんは、責任感を持って行動する。", "translation": "Doraemon acts with a sense of responsibility."},
     {"word": "previous", "meaning": "以前の", "example": "ドラえもんは、以前の出来事を思い出した。", "translation": "Doraemon remembered a previous event."},
     {"word": "despite", "meaning": "～にもかかわらず", "example": "ドラえもんは、困難にもかかわらず諦めなかった。", "translation": "Despite the difficulties, Doraemon did not give up."},
     {"word": "defeat", "meaning": "打ち負かす", "example": "ドラえもんは、強い敵を打ち負かした。", "translation": "Doraemon defeated a strong enemy."},
     {"word": "audition", "meaning": "オーディション", "example": "ドラえもんは、オーディションに参加した。", "translation": "Doraemon participated in an audition."},
     {"word": "publicity", "meaning": "宣伝", "example": "ドラえもんは、新しい道具の宣伝をした。", "translation": "Doraemon did publicity for a new gadget."},
     {"word": "relevant", "meaning": "関連のある", "example": "ドラえもんは、問題に関連のある情報を探した。", "translation": "Doraemon looked for information relevant to the problem."},
     {"word": "perspective", "meaning": "視点", "example": "ドラえもんは、違う視点から物事を考えた。", "translation": "Doraemon considered things from a different perspective."},
     {"word": "examine", "meaning": "調査する", "example": "ドラえもんは、現場を詳しく調査した。", "translation": "Doraemon examined the scene in detail."},
     {"word": "constitution", "meaning": "憲法", "example": "ドラえもんは、未来の憲法について学んだ。", "translation": "Doraemon learned about the future constitution."}
     ];
     break;
     case "高校英語177":
     item = [
     {"word": "loan", "meaning": "貸付金", "example": "ドラえもんは、友達にお金を貸した。", "translation": "Doraemon gave a loan to a friend."},
     {"word": "sponsor", "meaning": "スポンサー", "example": "ドラえもんは、イベントのスポンサーになった。", "translation": "Doraemon became a sponsor of the event."},
     {"word": "hopeful", "meaning": "希望に満ちた", "example": "ドラえもんは、希望に満ちた未来を信じている。", "translation": "Doraemon believes in a hopeful future."},
     {"word": "ingredient", "meaning": "材料", "example": "ドラえもんは、料理の材料を買いに行った。", "translation": "Doraemon went to buy ingredients for his cooking."},
     {"word": "arise", "meaning": "生じる", "example": "ドラえもんは、問題が生じたら解決する。", "translation": "Doraemon solves problems that arise."},
     {"word": "inevitable", "meaning": "避けられない", "example": "ドラえもんは、別れは避けられないと言った。", "translation": "Doraemon said that farewells are inevitable."},
     {"word": "abstract", "meaning": "抽象的な", "example": "ドラえもんは、抽象的な概念について考えた。", "translation": "Doraemon pondered abstract concepts."},
     {"word": "existence", "meaning": "存在", "example": "ドラえもんは、自分の存在意義を考えた。", "translation": "Doraemon thought about the meaning of his existence."},
     {"word": "relation", "meaning": "関係", "example": "ドラえもんは、友達との関係を大切にする。", "translation": "Doraemon values his relationship with his friends."},
     {"word": "workout", "meaning": "運動", "example": "ドラえもんは、毎日運動を欠かさない。", "translation": "Doraemon never skips his daily workouts."}
     ];
     break;
     case "高校英語178":
     item = [
     {"word": "elderly", "meaning": "高齢の", "example": "ドラえもんは、高齢者を助けた。", "translation": "Doraemon helped an elderly person."},
     {"word": "option", "meaning": "選択肢", "example": "ドラえもんは、いくつかの選択肢の中から選んだ。", "translation": "Doraemon chose from several options."},
     {"word": "population", "meaning": "人口", "example": "ドラえもんは、未来の人口問題について学んだ。", "translation": "Doraemon learned about future population issues."},
     {"word": "online", "meaning": "オンラインの", "example": "ドラえもんは、オンラインで買い物をした。", "translation": "Doraemon went shopping online."},
     {"word": "various", "meaning": "様々な", "example": "ドラえもんは、様々な場所へ旅行に行った。", "translation": "Doraemon traveled to various places."},
     {"word": "civil", "meaning": "市民の", "example": "ドラえもんは、市民を守るために戦った。", "translation": "Doraemon fought to protect the civilians."},
     {"word": "chart", "meaning": "図", "example": "ドラえもんは、図を使って説明をした。", "translation": "Doraemon explained using a chart."},
     {"word": "validation", "meaning": "検証", "example": "ドラえもんは、データの検証を行った。", "translation": "Doraemon validated the data."},
     {"word": "deficit", "meaning": "赤字", "example": "ドラえもんは、会社の赤字を解消しようとした。", "translation": "Doraemon tried to resolve the company's deficit."},
     {"word": "lean", "meaning": "寄りかかる", "example": "ドラえもんは、壁に寄りかかって休んだ。", "translation": "Doraemon leaned against the wall to rest."}
     ];
     break;
     case "高校英語179":
     item = [
     {"word": "excessive", "meaning": "過度な", "example": "ドラえもんは、過度な運動をしないように注意している。", "translation": "Doraemon is careful not to overdo the exercise."},
     {"word": "prompt", "meaning": "迅速な", "example": "ドラえもんは、いつも迅速に対応してくれる。", "translation": "Doraemon always responds promptly."},
     {"word": "appliance", "meaning": "電気器具", "example": "ドラえもんは、電気器具を修理した。", "translation": "Doraemon repaired an electrical appliance."},
     {"word": "nutrition", "meaning": "栄養", "example": "ドラえもんは、栄養バランスの良い食事を心がけている。", "translation": "Doraemon is mindful of having a balanced diet."},
     {"word": "pregnant", "meaning": "妊娠している", "example": "ドラえもんは、妊娠している友達を労わった。", "translation": "Doraemon took care of his pregnant friend."},
     {"word": "pear", "meaning": "梨", "example": "ドラえもんは、梨を美味しそうに食べた。", "translation": "Doraemon ate the pear with relish."},
     {"word": "rattle", "meaning": "ガタガタ鳴る", "example": "ドラえもんは、おもちゃをガタガタ鳴らして遊んだ。", "translation": "Doraemon played with a rattle toy."},
     {"word": "hesitant", "meaning": "ためらう", "example": "のび太は、いつも行動をためらう。", "translation": "Nobita always hesitates to act."},
     {"word": "deem", "meaning": "見なす", "example": "ドラえもんは、それは危険だと見なした。", "translation": "Doraemon deemed it to be dangerous."},
     {"word": "discredit", "meaning": "信用を失わせる", "example": "ドラえもんは、友達の信用を失うようなことはしない。", "translation": "Doraemon does not do anything that would discredit his friends."}
     ];
     break;
     case "高校英語180":
     item = [
     {"word": "literally", "meaning": "文字通り", "example": "ドラえもんは、言葉を文字通り受け取ることがある。", "translation": "Doraemon sometimes takes words literally."},
     {"word": "contaminate", "meaning": "汚染する", "example": "ドラえもんは、環境を汚染するものを排除した。", "translation": "Doraemon eliminated things that contaminate the environment."},
     {"word": "vision", "meaning": "ビジョン", "example": "ドラえもんは、未来のビジョンを描いた。", "translation": "Doraemon envisioned the future."},
     {"word": "motive", "meaning": "動機", "example": "ドラえもんは、犯人の動機を追求した。", "translation": "Doraemon pursued the motive of the criminal."},
     {"word": "stance", "meaning": "立場", "example": "ドラえもんは、中立の立場をとる。", "translation": "Doraemon takes a neutral stance."},
     {"word": "complex", "meaning": "複雑な", "example": "ドラえもんは、複雑な問題を解いた。", "translation": "Doraemon solved a complex problem."},
     {"word": "argument", "meaning": "議論", "example": "ドラえもんは、議論を通して解決策を見つけようとした。", "translation": "Doraemon tried to find a solution through argument."},
     {"word": "hint", "meaning": "ヒント", "example": "ドラえもんは、のび太にヒントを与えた。", "translation": "Doraemon gave Nobita a hint."},
     {"word": "shelf", "meaning": "棚", "example": "ドラえもんは、棚から本を取り出した。", "translation": "Doraemon took a book from the shelf."},
     {"word": "confuse", "meaning": "混乱させる", "example": "ドラえもんは、わざと話を混乱させない。", "translation": "Doraemon doesn't intentionally confuse the conversation."}
     ];
     break;
    
     
     case "中学英熟語1":
     item = [
     {"word": "a series of ～", "meaning": "一連の～", "example": "ドラえもんは、一連の秘密道具を取り出した。", "translation": "Doraemon took out a series of secret gadgets."},
     {"word": "As well as", "meaning": "～と同様に", "example": "ドラえもんは、のび太を手伝うだけでなく、一緒に遊ぶ。", "translation": "Doraemon plays with Nobita as well as helps him."},
     {"word": "Leave a message", "meaning": "伝言を残す", "example": "ドラえもんは、未来の友達に伝言を残した。", "translation": "Doraemon left a message for his friends in the future."},
     {"word": "be busy with", "meaning": "～で忙しい", "example": "ドラえもんは、いつも色々なことで忙しい。", "translation": "Doraemon is always busy with various things."},
     {"word": "As soon as", "meaning": "～するとすぐに", "example": "ドラえもんは、のび太が困るとすぐに助けに来る。", "translation": "Doraemon comes to help as soon as Nobita is in trouble."},
     {"word": "Belong to", "meaning": "～に所属する", "example": "ドラえもんは、未来の研究所に所属している。", "translation": "Doraemon belongs to a research institute in the future."},
     {"word": "Prepare for", "meaning": "～の準備をする", "example": "ドラえもんは、遠足の準備をした。", "translation": "Doraemon prepared for the field trip."},
     {"word": "A little", "meaning": "少し", "example": "ドラえもんは、少しだけお菓子を食べた。", "translation": "Doraemon ate a little snack."},
     {"word": "Take part in", "meaning": "～に参加する", "example": "ドラえもんは、町の運動会に参加した。", "translation": "Doraemon took part in the town's sports day."},
     {"word": "At the end of", "meaning": "～の終わりに", "example": "ドラえもんは、物語の終わりにのび太と別れた。", "translation": "Doraemon parted with Nobita at the end of the story."}
     ];
     break;
     case "中学英熟語2":
     item = [
     {"word": "a great deal of ～", "meaning": "たくさんの～", "example": "ドラえもんは、たくさんのどら焼きを持ってきた。", "translation": "Doraemon brought a great deal of dorayaki."},
     {"word": "On your right", "meaning": "あなたの右側に", "example": "ドラえもんは、「あなたの右側にあります」と教えてくれた。", "translation": "Doraemon told him, 'It's on your right'."},
     {"word": "Don't have to", "meaning": "～する必要がない", "example": "のび太は、「今日は学校に行かなくてもいい」と言って喜んだ。", "translation": "Nobita was happy saying, 'I don't have to go to school today'."},
     {"word": "In the future", "meaning": "将来", "example": "ドラえもんは、将来、のび太が良い大人になることを願っている。", "translation": "Doraemon hopes that Nobita will become a good adult in the future."},
     {"word": "Next door", "meaning": "隣の", "example": "ドラえもんは、隣の家に住む人と友達になった。", "translation": "Doraemon became friends with the person living next door."},
     {"word": "Come up", "meaning": "思いつく", "example": "ドラえもんは、良いアイデアを思いついた。", "translation": "Doraemon came up with a good idea."},
     {"word": "How many", "meaning": "いくつ", "example": "ドラえもんは、のび太に「どら焼きはいくつ欲しい？」と聞いた。", "translation": "Doraemon asked Nobita, 'How many dorayaki do you want?'"},
     {"word": "Throw away", "meaning": "捨てる", "example": "ドラえもんは、ゴミをちゃんと捨てた。", "translation": "Doraemon threw away the trash properly."},
     {"word": "Decide to", "meaning": "～することに決める", "example": "ドラえもんは、のび太を助けることを決めた。", "translation": "Doraemon decided to help Nobita."},
     {"word": "Put down", "meaning": "置く", "example": "ドラえもんは、テーブルの上に道具を置いた。", "translation": "Doraemon put down the gadget on the table."}
     ];
     break;
     case "中学英熟語3":
     item = [
     {"word": "For the first time", "meaning": "初めて", "example": "のび太は、初めてテストで100点を取った。", "translation": "Nobita got a perfect score on a test for the first time."},
     {"word": "a variety of ～", "meaning": "様々な～", "example": "ドラえもんは、様々な秘密道具を持っている。", "translation": "Doraemon has a variety of secret gadgets."},
     {"word": "Have to", "meaning": "～しなければならない", "example": "のび太は、宿題をしなければならない。", "translation": "Nobita has to do his homework."},
     {"word": "What time", "meaning": "何時", "example": "ドラえもんは、のび太に「何時に起きるの？」と聞いた。", "translation": "Doraemon asked Nobita, 'What time do you wake up?'"},
     {"word": "All day", "meaning": "一日中", "example": "のび太は、一日中ゲームをしていた。", "translation": "Nobita was playing games all day."},
     {"word": "Talk about", "meaning": "～について話す", "example": "ドラえもんは、のび太と未来について話した。", "translation": "Doraemon talked about the future with Nobita."},
     {"word": "Be impressed with", "meaning": "～に感動する", "example": "ドラえもんは、のび太の成長に感動した。", "translation": "Doraemon was impressed with Nobita's growth."},
     {"word": "Since then", "meaning": "それ以来", "example": "ドラえもんは、それ以来、のび太を見守っている。", "translation": "Doraemon has been watching over Nobita since then."},
     {"word": "Any of", "meaning": "どれでも", "example": "ドラえもんは、「どれでも好きな道具を使っていいよ」と言った。", "translation": "Doraemon said, 'You can use any of my gadgets you like'."},
     {"word": "Leave for", "meaning": "～へ出発する", "example": "ドラえもんは、未来へ出発した。", "translation": "Doraemon left for the future."}
     ];
     break;
     case "中学英熟語4":
     item = [
     {"word": "Be over", "meaning": "終わる", "example": "ドラえもんは、夏休みが終わってしまうことを悲しんだ。", "translation": "Doraemon was sad that summer vacation was over."},
     {"word": "I hear that", "meaning": "～と聞いている", "example": "ドラえもんは、「みんなが僕のことを好きだと聞いている」と言った。", "translation": "Doraemon said, 'I hear that everyone likes me'."},
     {"word": "Write down", "meaning": "書き留める", "example": "ドラえもんは、メモを書き留めた。", "translation": "Doraemon wrote down a memo."},
     {"word": "At the age of", "meaning": "～歳で", "example": "のび太は、10歳でドラえもんと出会った。", "translation": "Nobita met Doraemon at the age of 10."},
     {"word": "What to do", "meaning": "何をすべきか", "example": "ドラえもんは、何をすべきか考えていた。", "translation": "Doraemon was thinking about what to do."},
     {"word": "Get on", "meaning": "～に乗る", "example": "ドラえもんは、電車に乗った。", "translation": "Doraemon got on the train."},
     {"word": "Lose my way", "meaning": "道に迷う", "example": "のび太は、いつも道に迷ってしまう。", "translation": "Nobita always loses his way."},
     {"word": "At any time", "meaning": "いつでも", "example": "ドラえもんは、いつでものび太を助ける。", "translation": "Doraemon helps Nobita at any time."},
     {"word": "Too busy to", "meaning": "～するのに忙しすぎる", "example": "ドラえもんは、忙しくて遊ぶ時間がなかった。", "translation": "Doraemon was too busy to play."},
     {"word": "Feel sorry for", "meaning": "～を気の毒に思う", "example": "ドラえもんは、のび太を気の毒に思った。", "translation": "Doraemon felt sorry for Nobita."}
     ];
     break;
     case "中学英熟語5":
     item = [
     {"word": "Stay up", "meaning": "夜更かしする", "example": "のび太は、いつも夜更かししてしまう。", "translation": "Nobita always stays up late at night."},
     {"word": "A piece of", "meaning": "一枚の～", "example": "ドラえもんは、一枚のクッキーを食べた。", "translation": "Doraemon ate a piece of cookie."},
     {"word": "Be popular among", "meaning": "～の間で人気がある", "example": "ドラえもんは、子供たちの間で人気がある。", "translation": "Doraemon is popular among children."},
     {"word": "Put it in", "meaning": "～に入れる", "example": "ドラえもんは、道具をポケットに入れた。", "translation": "Doraemon put the gadget in his pocket."},
     {"word": "above all", "meaning": "何よりもまず", "example": "ドラえもんは、何よりもまず、のび太の安全を考えた。", "translation": "Above all, Doraemon considered Nobita's safety."},
     {"word": "Once a week", "meaning": "週に一度", "example": "ドラえもんは、週に一度友達と会う。", "translation": "Doraemon meets his friends once a week."},
     {"word": "Go abroad", "meaning": "海外へ行く", "example": "ドラえもんは、どこでもドアで海外へ行った。", "translation": "Doraemon went abroad using the Anywhere Door."},
     {"word": "Sit down", "meaning": "座る", "example": "ドラえもんは、椅子に座った。", "translation": "Doraemon sat down on the chair."},
     {"word": "Between A and B", "meaning": "AとBの間に", "example": "ドラえもんは、のび太とジャイアンの間に割って入った。", "translation": "Doraemon intervened between Nobita and Gian."},
     {"word": "Hear about", "meaning": "～について聞く", "example": "ドラえもんは、のび太の噂を聞いた。", "translation": "Doraemon heard about Nobita's rumor."}
     ];
     break;
     case "中学英熟語6":
     item = [
     {"word": "Talk to", "meaning": "～と話す", "example": "ドラえもんは、のび太と話をした。", "translation": "Doraemon talked to Nobita."},
     {"word": "Deal with", "meaning": "～に対処する", "example": "ドラえもんは、難しい問題に対処する。", "translation": "Doraemon deals with difficult problems."},
     {"word": "Let me see", "meaning": "ええと", "example": "ドラえもんは、「ええと、どこへ行こうかな」と言った。", "translation": "Doraemon said, 'Let me see, where shall I go?'"},
     {"word": "For some time", "meaning": "しばらくの間", "example": "ドラえもんは、しばらくの間旅に出た。", "translation": "Doraemon went on a trip for some time."},
     {"word": "lots of", "meaning": "たくさんの", "example": "ドラえもんは、たくさんのお菓子を持ってきた。", "translation": "Doraemon brought lots of snacks."},
     {"word": "according to ～", "meaning": "～によると", "example": "ドラえもんが言うところによると、未来ではロボットが普通らしい。", "translation": "According to Doraemon, robots are common in the future."},
     {"word": "Be absent from", "meaning": "～を欠席する", "example": "のび太は、学校を欠席することが多い。", "translation": "Nobita is often absent from school."},
     {"word": "How many times", "meaning": "何回", "example": "ドラえもんは、のび太に「何回同じ失敗をするんだ？」と言った。", "translation": "Doraemon said to Nobita, 'How many times are you going to make the same mistake?'"},
     {"word": "Next time", "meaning": "今度", "example": "ドラえもんは、のび太に「今度一緒に遊ぼう」と言った。", "translation": "Doraemon said to Nobita, 'Let's play together next time'."},
     {"word": "A member of", "meaning": "～の一員", "example": "ドラえもんは、チームの一員として頑張った。", "translation": "Doraemon worked hard as a member of the team."}
     ];
     break;
     case "中学英熟語7":
     item = [
     {"word": "Hear from", "meaning": "～から便りがある", "example": "ドラえもんは、未来の友達から便りがあった。", "translation": "Doraemon heard from his friend in the future."},
     {"word": "Put on", "meaning": "～を身に着ける", "example": "ドラえもんは、新しい帽子を被った。", "translation": "Doraemon put on a new hat."},
     {"word": "At home", "meaning": "家で", "example": "ドラえもんは、家でゆっくりしている。", "translation": "Doraemon is relaxing at home."},
     {"word": "Stay with", "meaning": "～と一緒にいる", "example": "ドラえもんは、いつもみんなと一緒にいる。", "translation": "Doraemon always stays with everyone."},
     {"word": "Be supposed to", "meaning": "～することになっている", "example": "のび太は、宿題をすることになっている。", "translation": "Nobita is supposed to do his homework."},
     {"word": "In the middle of", "meaning": "～の途中で", "example": "ドラえもんは、食事の途中で呼ばれた。", "translation": "Doraemon was called in the middle of his meal."},
     {"word": "Like A better than B", "meaning": "BよりAが好き", "example": "ドラえもんは、どら焼きをあんこより好きだ。", "translation": "Doraemon likes dorayaki better than anko."},
     {"word": "Fill ～with", "meaning": "～を…で満たす", "example": "ドラえもんは、ポケットを道具で満たした。", "translation": "Doraemon filled his pocket with gadgets."},
     {"word": "What's wrong?", "meaning": "どうしたの？", "example": "ドラえもんは、のび太に「どうしたの？」と聞いた。", "translation": "Doraemon asked Nobita, 'What's wrong?'"},
     {"word": "Come back to", "meaning": "～に戻ってくる", "example": "ドラえもんは、のび太の家に帰ってきた。", "translation": "Doraemon came back to Nobita's house."}
     ];
     break;
     case "中学英熟語8":
     item = [
     {"word": "Once more", "meaning": "もう一度", "example": "ドラえもんは、もう一度チャンスを与えた。", "translation": "Doraemon gave him another chance once more."},
     {"word": "Get off", "meaning": "～から降りる", "example": "ドラえもんは、電車から降りた。", "translation": "Doraemon got off the train."},
     {"word": "Stop watching", "meaning": "見るのをやめる", "example": "ドラえもんは、テレビを見るのをやめた。", "translation": "Doraemon stopped watching TV."},
     {"word": "During my stay in", "meaning": "～に滞在中", "example": "ドラえもんは、未来に滞在中、色々な体験をした。", "translation": "Doraemon had various experiences during his stay in the future."},
     {"word": "Sit on", "meaning": "～に座る", "example": "ドラえもんは、椅子に座った。", "translation": "Doraemon sat on the chair."},
     {"word": "From A to B", "meaning": "AからBまで", "example": "ドラえもんは、A地点からB地点まで移動した。", "translation": "Doraemon moved from point A to point B."},
     {"word": "Make a mistake", "meaning": "間違いを犯す", "example": "のび太は、いつも間違いを犯してしまう。", "translation": "Nobita always makes a mistake."},
     {"word": "A lot of", "meaning": "たくさんの", "example": "ドラえもんは、たくさんのお菓子を持っている。", "translation": "Doraemon has a lot of snacks."},
     {"word": "Than before", "meaning": "以前より", "example": "のび太は、以前より少しだけ強くなった。", "translation": "Nobita is a little stronger than before."},
     {"word": "At night", "meaning": "夜に", "example": "ドラえもんは、夜に星を見るのが好きだ。", "translation": "Doraemon likes to look at the stars at night."}
     ];
     break;
     case "中学英熟語9":
     item = [
     {"word": "Try on", "meaning": "試着する", "example": "ドラえもんは、新しい服を試着した。", "translation": "Doraemon tried on a new outfit."},
     {"word": "Be in trouble", "meaning": "困っている", "example": "のび太はいつも困っている。", "translation": "Nobita is always in trouble."},
     {"word": "Put out", "meaning": "消す", "example": "ドラえもんは、火を消した。", "translation": "Doraemon put out the fire."},
     {"word": "Around the world", "meaning": "世界中で", "example": "ドラえもんは、世界中を旅した。", "translation": "Doraemon traveled around the world."},
     {"word": "In the morning", "meaning": "朝に", "example": "ドラえもんは、朝に散歩をした。", "translation": "Doraemon took a walk in the morning."},
     {"word": "Be used to", "meaning": "～に慣れている", "example": "ドラえもんは、現代の生活に慣れている。", "translation": "Doraemon is used to living in the present."},
     {"word": "Have no idea", "meaning": "全く知らない", "example": "ドラえもんは、「全く知らない」と言った。", "translation": "Doraemon said, 'I have no idea'."},
     {"word": "One after another", "meaning": "次々と", "example": "ドラえもんは、次々と秘密道具を使った。", "translation": "Doraemon used his secret gadgets one after another."},
     {"word": "Come from", "meaning": "～から来る", "example": "ドラえもんは、未来から来た。", "translation": "Doraemon comes from the future."}
     ];
     break;
     case "中学英熟語10":
     item = [
     {"word": "Which do you like better, A or B?", "meaning": "AとBのどちらが好きですか？", "example": "ドラえもんは、のび太に「どら焼きとアンコ、どちらが好き？」と聞いた。", "translation": "Doraemon asked Nobita, 'Which do you like better, dorayaki or anko?'"},
     {"word": "Go across", "meaning": "～を横切る", "example": "ドラえもんは、川を横切って行った。", "translation": "Doraemon went across the river."},
     {"word": "Listen to", "meaning": "～を聞く", "example": "ドラえもんは、音楽を聴くのが好きだ。", "translation": "Doraemon likes to listen to music."},
     {"word": "Communicate with", "meaning": "～とコミュニケーションをとる", "example": "ドラえもんは、未来の人々とコミュニケーションをとった。", "translation": "Doraemon communicated with people from the future."},
     {"word": "Smile at", "meaning": "～に微笑みかける", "example": "ドラえもんは、のび太に微笑みかけた。", "translation": "Doraemon smiled at Nobita."},
     {"word": "Get out", "meaning": "～から出る", "example": "ドラえもんは、車から出た。", "translation": "Doraemon got out of the car."},
     {"word": "Put up", "meaning": "～を掲げる", "example": "ドラえもんは、旗を掲げた。", "translation": "Doraemon put up the flag."},
     {"word": "I hope so.", "meaning": "そうだといいな", "example": "ドラえもんは、「そうだといいな」とつぶやいた。", "translation": "Doraemon murmured, 'I hope so'."},
     {"word": "All around", "meaning": "～の至る所に", "example": "ドラえもんは、世界中の至る所へ旅をした。", "translation": "Doraemon traveled all around the world."},
     {"word": "Next to", "meaning": "～の隣に", "example": "ドラえもんは、のび太の隣に座った。", "translation": "Doraemon sat next to Nobita."}
     ];
     break;
    
     
     case "中学英熟語11":
     item = [
     {"word": "Be covered with", "meaning": "～で覆われている", "example": "ドラえもんの体は、青い色で覆われている。", "translation": "Doraemon's body is covered with blue."},
     {"word": "Go back to", "meaning": "～に戻る", "example": "ドラえもんは、未来の世界に戻った。", "translation": "Doraemon went back to the future."},
     {"word": "Thanks to", "meaning": "～のおかげで", "example": "ドラえもんのおかげで、のび太は助かった。", "translation": "Thanks to Doraemon, Nobita was saved."},
     {"word": "As usual", "meaning": "いつものように", "example": "のび太は、いつものように宿題を忘れた。", "translation": "Nobita forgot his homework as usual."},
     {"word": "Help me with", "meaning": "～を手伝って", "example": "のび太は、ドラえもんに宿題を手伝ってと頼んだ。", "translation": "Nobita asked Doraemon to help him with his homework."},
     {"word": "One day", "meaning": "ある日", "example": "ある日、ドラえもんはタイムマシンを使った。", "translation": "One day, Doraemon used his time machine."},
     {"word": "At the same time", "meaning": "同時に", "example": "ドラえもんは、同時に複数の道具を使った。", "translation": "Doraemon used multiple gadgets at the same time."},
     {"word": "How long", "meaning": "どのくらい", "example": "ドラえもんは、「どのくらい時間がかかりますか？」と聞いた。", "translation": "Doraemon asked, 'How long will it take?'"},
     {"word": "Such as", "meaning": "～のような", "example": "ドラえもんは、どら焼きのような甘いものが好きだ。", "translation": "Doraemon likes sweet things such as dorayaki."},
     {"word": "A cup of", "meaning": "一杯の～", "example": "ドラえもんは、一杯のお茶を飲んだ。", "translation": "Doraemon drank a cup of tea."}
     ];
     break;
     case "中学英熟語12":
     item = [
     {"word": "Hurry up", "meaning": "急ぐ", "example": "ドラえもんは、のび太に「急いで！」と言った。", "translation": "Doraemon said to Nobita, 'Hurry up!'"},
     {"word": "Turn around", "meaning": "振り返る", "example": "ドラえもんは、後ろを振り返った。", "translation": "Doraemon turned around."},
     {"word": "Any other", "meaning": "他の", "example": "ドラえもんは、「他に何か欲しいものある？」と聞いた。", "translation": "Doraemon asked, 'Do you want any other gadgets?'"},
     {"word": "Little by little", "meaning": "少しずつ", "example": "のび太は、少しずつ成長している。", "translation": "Nobita is growing up little by little."},
     {"word": "In this way", "meaning": "このように", "example": "ドラえもんは、このようにして問題を解決した。", "translation": "In this way, Doraemon solved the problem."},
     {"word": "Be different from", "meaning": "～と異なる", "example": "ドラえもんは、他のロボットと異なる。", "translation": "Doraemon is different from other robots."},
     {"word": "Make a speech", "meaning": "演説をする", "example": "ドラえもんは、みんなの前で演説をした。", "translation": "Doraemon made a speech in front of everyone."},
     {"word": "So that you can", "meaning": "～できるように", "example": "ドラえもんは、のび太が勉強できるように手伝った。", "translation": "Doraemon helped Nobita so that he can study."},
     {"word": "After school", "meaning": "放課後", "example": "のび太は、放課後ドラえもんと遊んだ。", "translation": "Nobita played with Doraemon after school."},
     {"word": "Why don't you", "meaning": "～しませんか？", "example": "ドラえもんは、のび太に「一緒に遊びませんか？」と言った。", "translation": "Doraemon asked Nobita, 'Why don't you play together?'"}
     ];
     break;
     case "中学英熟語13":
     item = [
     {"word": "Be surprised at", "meaning": "～に驚く", "example": "ドラえもんは、のび太の成長に驚いた。", "translation": "Doraemon was surprised at Nobita's growth."},
     {"word": "Thank you for", "meaning": "～をありがとう", "example": "のび太は、ドラえもんに「助けてくれてありがとう」と言った。", "translation": "Nobita said to Doraemon, 'Thank you for helping me'."},
     {"word": "As tall as", "meaning": "～と同じくらいの高さ", "example": "ドラえもんは、のび太と同じくらいの高さだ。", "translation": "Doraemon is as tall as Nobita."},
     {"word": "Go down", "meaning": "降りる", "example": "ドラえもんは、階段を降りた。", "translation": "Doraemon went down the stairs."},
     {"word": "Right away", "meaning": "すぐに", "example": "ドラえもんは、頼まれたらすぐにやってくれる。", "translation": "Doraemon will do it right away if he is asked."},
     {"word": "Be ready to", "meaning": "～する準備ができている", "example": "ドラえもんは、いつでも冒険の準備ができている。", "translation": "Doraemon is always ready to go on an adventure."},
     {"word": "Suffer from", "meaning": "～で苦しむ", "example": "のび太は、いつも宿題に苦しんでいる。", "translation": "Nobita always suffers from homework."},
     {"word": "I mean", "meaning": "つまり", "example": "ドラえもんは、「つまり、そういうことだ」と言った。", "translation": "Doraemon said, 'I mean, that's how it is'."},
     {"word": "For example", "meaning": "例えば", "example": "ドラえもんは、例えば、秘密道具を使った。", "translation": "For example, Doraemon used a secret gadget."},
     {"word": "Live in", "meaning": "～に住む", "example": "ドラえもんは、のび太の家に住んでいる。", "translation": "Doraemon lives in Nobita's house."}
     ];
     break;
     case "中学英熟語14":
     item = [
     {"word": "By myself", "meaning": "一人で", "example": "ドラえもんは、一人で買い物に出かけた。", "translation": "Doraemon went shopping by himself."},
     {"word": "You're kidding.", "meaning": "冗談でしょ", "example": "ドラえもんは、のび太の話を聞いて「冗談でしょ？」と言った。", "translation": "Doraemon said to Nobita, 'You're kidding?' after hearing his story."},
     {"word": "Get out of", "meaning": "～から出る", "example": "ドラえもんは、車から出た。", "translation": "Doraemon got out of the car."},
     {"word": "Turn down", "meaning": "～を断る", "example": "ドラえもんは、ジャイアンのお誘いを断った。", "translation": "Doraemon turned down Gian's invitation."},
     {"word": "Depend on", "meaning": "～に頼る", "example": "のび太は、いつもドラえもんに頼ってばかりだ。", "translation": "Nobita always depends on Doraemon."},
     {"word": "Wish for", "meaning": "～を願う", "example": "ドラえもんは、平和な世界を願っている。", "translation": "Doraemon wishes for a peaceful world."},
     {"word": "Go to school", "meaning": "学校へ行く", "example": "ドラえもんは、毎日学校へ行く。", "translation": "Doraemon goes to school every day."},
     {"word": "No longer", "meaning": "もはや～ない", "example": "のび太は、もはや宿題を忘れることはない。", "translation": "Nobita no longer forgets his homework."},
     {"word": "Each of", "meaning": "～それぞれの", "example": "ドラえもんは、それぞれの能力を生かして戦った。", "translation": "Doraemon fought by utilizing each of their abilities."},
     {"word": "Here and there", "meaning": "あちこちに", "example": "ドラえもんは、あちこちに道具を隠した。", "translation": "Doraemon hid his gadgets here and there."}
     ];
     break;
     case "中学英熟語15":
     item = [
     {"word": "That's right", "meaning": "その通り", "example": "ドラえもんは「その通り」と言って頷いた。", "translation": "Doraemon nodded and said, 'That's right'."},
     {"word": "Come in", "meaning": "入る", "example": "ドラえもんは、「どうぞ入って」と言った。", "translation": "Doraemon said, 'Come in'."},
     {"word": "So wonderful that", "meaning": "～なほど素晴らしい", "example": "ドラえもんの道具は、とても素晴らしい。", "translation": "Doraemon's gadgets are so wonderful that it's hard to believe."},
     {"word": "How do you like", "meaning": "～はどうですか？", "example": "ドラえもんは、「この料理はどう？」と聞いた。", "translation": "Doraemon asked, 'How do you like this dish?'"},
     {"word": "Go away", "meaning": "行ってしまう", "example": "ドラえもんは、のび太から離れて行ってしまった。", "translation": "Doraemon went away from Nobita."},
     {"word": "Go up to", "meaning": "～まで行く", "example": "ドラえもんは、山の上まで行った。", "translation": "Doraemon went up to the top of the mountain."},
     {"word": "Right now", "meaning": "今すぐ", "example": "ドラえもんは、「今すぐに行く」と言った。", "translation": "Doraemon said, 'I'll go right now'."},
     {"word": "At a time", "meaning": "一度に", "example": "ドラえもんは、一度にたくさんの道具を出すことができる。", "translation": "Doraemon can bring out a lot of gadgets at a time."},
     {"word": "Go home", "meaning": "家に帰る", "example": "ドラえもんは、家に帰ってきた。", "translation": "Doraemon went home."},
     {"word": "Long ago", "meaning": "昔", "example": "ドラえもんは、昔の時代にタイムスリップした。", "translation": "Doraemon time-slipped to an era long ago."}
     ];
     break;
     case "中学英熟語16":
     item = [
     {"word": "After all", "meaning": "結局", "example": "ドラえもんは、結局のび太を助けることにした。", "translation": "After all, Doraemon decided to help Nobita."},
     {"word": "With a smile", "meaning": "笑顔で", "example": "ドラえもんは、いつも笑顔で話す。", "translation": "Doraemon always speaks with a smile."},
     {"word": "Be proud of", "meaning": "～を誇りに思う", "example": "ドラえもんは、のび太の勇気を誇りに思った。", "translation": "Doraemon was proud of Nobita's courage."},
     {"word": "In those days", "meaning": "当時", "example": "ドラえもんは、当時、まだ小さいロボットだった。", "translation": "In those days, Doraemon was still a small robot."},
     {"word": "At least", "meaning": "少なくとも", "example": "ドラえもんは、少なくとも3つの道具を使った。", "translation": "Doraemon used at least three gadgets."},
     {"word": "Turn off", "meaning": "～を消す", "example": "ドラえもんは、電気を消した。", "translation": "Doraemon turned off the lights."},
     {"word": "Be interested in", "meaning": "～に興味がある", "example": "ドラえもんは、未来の科学に興味がある。", "translation": "Doraemon is interested in future science."},
     {"word": "take a bath", "meaning": "お風呂に入る", "example": "ドラえもんは、お風呂に入って体を温めた。", "translation": "Doraemon took a bath to warm himself."},
     {"word": "At once", "meaning": "すぐに", "example": "ドラえもんは、「すぐに助けに行く」と言った。", "translation": "Doraemon said, 'I'll go help at once'."},
     {"word": "Make friends with", "meaning": "～と友達になる", "example": "ドラえもんは、色々な人と友達になった。", "translation": "Doraemon made friends with many people."}
     ];
     break;
     case "中学英熟語17":
     item = [
     {"word": "Be famous for", "meaning": "～で有名である", "example": "ドラえもんは、どら焼きが好きで有名だ。", "translation": "Doraemon is famous for his love of dorayaki."},
     {"word": "Not at all", "meaning": "全然～ない", "example": "ドラえもんは、「全然疲れていない」と言った。", "translation": "Doraemon said, 'I'm not tired at all'."},
     {"word": "A glass of", "meaning": "グラス一杯の～", "example": "ドラえもんは、グラス一杯の水を飲んだ。", "translation": "Doraemon drank a glass of water."},
     {"word": "Some day", "meaning": "いつか", "example": "ドラえもんは、いつか未来に帰るだろう。", "translation": "Doraemon will go back to the future some day."},
     {"word": "Good luck", "meaning": "幸運を祈る", "example": "ドラえもんは、のび太に「頑張って、幸運を祈る」と言った。", "translation": "Doraemon said to Nobita, 'Good luck, do your best'."},
     {"word": "Be happy to", "meaning": "～して嬉しい", "example": "ドラえもんは、のび太を助けることができて嬉しい。", "translation": "Doraemon is happy to help Nobita."},
     {"word": "Run around", "meaning": "走り回る", "example": "のび太は、いつも部屋の中を走り回っている。", "translation": "Nobita is always running around the room."},
     {"word": "In time", "meaning": "間に合って", "example": "ドラえもんは、時間に間に合った。", "translation": "Doraemon arrived in time."},
     {"word": "From now on", "meaning": "これから", "example": "ドラえもんは、「これからもっと頑張る」と言った。", "translation": "Doraemon said, 'I will work harder from now on'."},
     {"word": "The next day", "meaning": "次の日", "example": "ドラえもんは、次の日も冒険に行った。", "translation": "Doraemon went on an adventure the next day."}
     ];
     break;
     case "中学英熟語18":
     item = [
     {"word": "By mistake", "meaning": "間違って", "example": "のび太は、間違ってドラえもんの道具を使ってしまった。", "translation": "Nobita used Doraemon's gadget by mistake."},
     {"word": "I see", "meaning": "なるほど", "example": "ドラえもんは、「なるほど、そういうことか」と言った。", "translation": "Doraemon said, 'I see, that's how it is'."},
     {"word": "No more", "meaning": "これ以上～ない", "example": "ドラえもんは、「これ以上どら焼きは食べられない」と言った。", "translation": "Doraemon said, 'I can't eat any more dorayaki'."},
     {"word": "Far from", "meaning": "～から遠く離れて", "example": "ドラえもんは、故郷から遠く離れた場所にいる。", "translation": "Doraemon is far from his hometown."},
     {"word": "Look after", "meaning": "～の世話をする", "example": "ドラえもんは、のび太の世話をするのが好きだ。", "translation": "Doraemon likes to look after Nobita."},
     {"word": "One of", "meaning": "～のうちの一つ", "example": "ドラえもんは、一番お気に入りの道具の一つを使った。", "translation": "Doraemon used one of his favorite gadgets."},
     {"word": "For dinner", "meaning": "夕食に", "example": "ドラえもんは、夕食にどら焼きを食べた。", "translation": "Doraemon ate dorayaki for dinner."},
     {"word": "Hundreds of", "meaning": "何百もの～", "example": "ドラえもんは、何百もの秘密道具を持っている。", "translation": "Doraemon has hundreds of secret gadgets."},
     {"word": "Make fun of", "meaning": "～をからかう", "example": "ジャイアンは、いつもスネ夫をからかう。", "translation": "Gian always makes fun of Suneo."},
     {"word": "Both A and B", "meaning": "AとBの両方", "example": "ドラえもんは、AとBの両方の計画を実行することにした。", "translation": "Doraemon decided to carry out both plan A and B."}
     ];
     break;
     case "中学英熟語19":
     item = [
     {"word": "Run away", "meaning": "逃げる", "example": "のび太は、ジャイアンから逃げた。", "translation": "Nobita ran away from Gian."},
     {"word": "Find out", "meaning": "見つける", "example": "ドラえもんは、事件の犯人を見つけた。", "translation": "Doraemon found out the criminal."},
     {"word": "Look up", "meaning": "調べる", "example": "ドラえもんは、辞書で単語を調べた。", "translation": "Doraemon looked up the word in the dictionary."},
     {"word": "Take a break", "meaning": "休憩する", "example": "ドラえもんは、休憩を挟んでからまた作業を始めた。", "translation": "Doraemon took a break and then started working again."},
     {"word": "Continue to", "meaning": "～し続ける", "example": "ドラえもんは、のび太を助け続ける。", "translation": "Doraemon continues to help Nobita."},
     {"word": "Some of", "meaning": "～のうちのいくつか", "example": "ドラえもんは、いくつかの道具を貸した。", "translation": "Doraemon lent some of his gadgets."},
     {"word": "Get to", "meaning": "～に到着する", "example": "ドラえもんは、目的地に到着した。", "translation": "Doraemon got to his destination."},
     {"word": "Grow up", "meaning": "成長する", "example": "のび太は、少しずつ成長している。", "translation": "Nobita is growing up little by little."},
     {"word": "Not only A but also B", "meaning": "AだけでなくBも", "example": "ドラえもんは、のび太を助けるだけでなく、一緒に遊ぶ。", "translation": "Doraemon not only helps Nobita but also plays with him."},
     {"word": "By the way", "meaning": "ところで", "example": "ドラえもんは、「ところで、今日は何をするの？」と聞いた。", "translation": "Doraemon asked, 'By the way, what are we doing today?'"}
     ];
     break;
     case "中学英熟語20":
     item = [
     {"word": "Up to", "meaning": "～まで", "example": "ドラえもんは、夕食まで宿題をすることにした。", "translation": "Doraemon decided to do homework up to dinner time."},
     {"word": "Here you are", "meaning": "はい、どうぞ", "example": "ドラえもんは、のび太に道具を渡しながら、「はい、どうぞ」と言った。", "translation": "Doraemon said, 'Here you are' while handing a gadget to Nobita."},
     {"word": "Out of", "meaning": "～の中から", "example": "ドラえもんは、ポケットから道具を取り出した。", "translation": "Doraemon took out a gadget out of his pocket."},
     {"word": "Die of", "meaning": "～で死ぬ", "example": "ドラえもんは、病気で死ぬことはない。", "translation": "Doraemon does not die of diseases."},
     {"word": "Make up my mind", "meaning": "決心する", "example": "ドラえもんは、未来へ行くことを決心した。", "translation": "Doraemon made up his mind to go to the future."},
     {"word": "Go into", "meaning": "～に入る", "example": "ドラえもんは、洞窟の中に入った。", "translation": "Doraemon went into the cave."},
     {"word": "The number of", "meaning": "～の数", "example": "ドラえもんは、道具の数を数えてみた。", "translation": "Doraemon tried to count the number of his gadgets."},
     {"word": "A group of", "meaning": "～のグループ", "example": "ドラえもんは、友達のグループと遊んだ。", "translation": "Doraemon played with a group of his friends."},
     {"word": "Soon after", "meaning": "～の直後", "example": "ドラえもんは、用事を済ませた直後に、のび太の家に行った。", "translation": "Soon after finishing his errands, Doraemon went to Nobita's house."},
     {"word": "Be able to", "meaning": "～することができる", "example": "ドラえもんは、どこへでも行くことができる。", "translation": "Doraemon is able to go anywhere."}
     ];
     break;
    
     
     case "中学英熟語21":
     item = [
     {"word": "I think so, too", "meaning": "私もそう思う", "example": "ドラえもんは、「私もそう思う」と答えた。", "translation": "Doraemon replied, 'I think so, too'."},
     {"word": "Say hello to", "meaning": "～によろしく伝える", "example": "ドラえもんは、未来の友達に「よろしく伝えて」と言った。", "translation": "Doraemon said, 'Say hello to my friend,' to the person."},
     {"word": "Again and again", "meaning": "何度も", "example": "のび太は、何度も同じ失敗を繰り返した。", "translation": "Nobita made the same mistake again and again."},
     {"word": "Begin to", "meaning": "～し始める", "example": "ドラえもんは、新しい冒険を始めた。", "translation": "Doraemon began to start a new adventure."},
     {"word": "Take a look at", "meaning": "～を見る", "example": "ドラえもんは、道具を見てみた。", "translation": "Doraemon took a look at the gadget."},
     {"word": "Be late for", "meaning": "～に遅れる", "example": "のび太は、学校に遅刻した。", "translation": "Nobita was late for school."},
     {"word": "Without saying", "meaning": "言うまでもなく", "example": "ドラえもんは、言うまでもなく、のび太を助けた。", "translation": "Without saying, Doraemon helped Nobita."},
     {"word": "I would like to", "meaning": "～したい", "example": "ドラえもんは、「未来へ行ってみたい」と言った。", "translation": "Doraemon said, 'I would like to go to the future'."},
     {"word": "No one", "meaning": "誰も～ない", "example": "ドラえもんは、誰も傷つけたくない。", "translation": "Doraemon does not want to hurt no one."},
     {"word": "Get together", "meaning": "集まる", "example": "ドラえもんは、友達と集まって遊んだ。", "translation": "Doraemon got together with his friends and played."}
     ];
     break;
     case "中学英熟語22":
     item = [
     {"word": "Need to", "meaning": "～する必要がある", "example": "のび太は、宿題をする必要がある。", "translation": "Nobita needs to do his homework."},
     {"word": "Used to", "meaning": "以前は～だった", "example": "ドラえもんは、以前は黄色かった。", "translation": "Doraemon used to be yellow."},
     {"word": "Could you", "meaning": "～してくれませんか", "example": "ドラえもんは、「手伝ってくれませんか」と言った。", "translation": "Doraemon said, 'Could you help me?'"},
     {"word": "Instead of", "meaning": "～の代わりに", "example": "ドラえもんは、代わりに宿題を手伝った。", "translation": "Doraemon helped with homework instead of Nobita."},
     {"word": "Not yet.", "meaning": "まだ～ない", "example": "のび太は、宿題をまだ終えていない。", "translation": "Nobita has not finished his homework yet."},
     {"word": "Each other", "meaning": "お互いに", "example": "ドラえもんと、のび太はお互いに助け合う。", "translation": "Doraemon and Nobita help each other."},
     {"word": "Say to myself", "meaning": "心の中で思う", "example": "ドラえもんは、心の中で「本当にすごい」と思った。", "translation": "Doraemon said to himself, 'That's really amazing'."},
     {"word": "I think that", "meaning": "～と思う", "example": "ドラえもんは、「きっとうまくいくと思う」と言った。", "translation": "Doraemon said, 'I think that it will work out well'."},
     {"word": "Come and see", "meaning": "見に来て", "example": "ドラえもんは、「見に来て」と言った。", "translation": "Doraemon said, 'Come and see!'"},
     {"word": "Sound like", "meaning": "～のように聞こえる", "example": "ドラえもんの道具は、魔法のように聞こえる。", "translation": "Doraemon's gadgets sound like magic."}
     ];
     break;
     case "中学英熟語23":
     item = [
     {"word": "A is to B what C is to D", "meaning": "AのBに対する関係はCのDに対する関係と同じ", "example": "ドラえもんとのび太の関係は、犬と飼い主の関係に似ている。", "translation": "The relationship between Doraemon and Nobita is to a dog and its owner."},
     {"word": "Finish writing", "meaning": "書き終える", "example": "のび太は、やっと宿題を書き終えた。", "translation": "Nobita finally finished writing his homework."},
     {"word": "On TV", "meaning": "テレビで", "example": "ドラえもんは、テレビで面白い番組を見た。", "translation": "Doraemon watched an interesting show on TV."},
     {"word": "Introduce A to B", "meaning": "AをBに紹介する", "example": "ドラえもんは、のび太を未来の友達に紹介した。", "translation": "Doraemon introduced Nobita to his future friend."},
     {"word": "Day and night", "meaning": "昼も夜も", "example": "ドラえもんは、昼も夜も頑張っている。", "translation": "Doraemon works hard day and night."},
     {"word": "Look around", "meaning": "見回す", "example": "ドラえもんは、あたりを見回した。", "translation": "Doraemon looked around."},
     {"word": "The other day", "meaning": "先日", "example": "ドラえもんは、先日、未来に行った。", "translation": "The other day, Doraemon went to the future."},
     {"word": "Go on", "meaning": "続ける", "example": "ドラえもんは、冒険を続けることを決めた。", "translation": "Doraemon decided to go on with the adventure."},
     {"word": "Graduate from", "meaning": "～を卒業する", "example": "のび太は、小学校を卒業した。", "translation": "Nobita graduated from elementary school."},
     {"word": "Of all", "meaning": "すべての～の中で", "example": "ドラえもんは、すべてのおやつの中で、どら焼きが一番好きだ。", "translation": "Of all snacks, Doraemon likes dorayaki the best."}
     ];
     break;
     case "中学英熟語24":
     item = [
     {"word": "Both of", "meaning": "両方の", "example": "ドラえもんは、両方の道具を使った。", "translation": "Doraemon used both of his gadgets."},
     {"word": "Many kinds of", "meaning": "たくさんの種類の～", "example": "ドラえもんは、たくさんの種類のお菓子を持ってきた。", "translation": "Doraemon brought many kinds of snacks."},
     {"word": "Go ahead", "meaning": "どうぞ", "example": "ドラえもんは、「どうぞ、お先に」と言った。", "translation": "Doraemon said, 'Go ahead'."},
     {"word": "Take a message", "meaning": "伝言を預かる", "example": "ドラえもんは、のび太の伝言を預かった。", "translation": "Doraemon took a message for Nobita."},
     {"word": "Come true", "meaning": "実現する", "example": "のび太の夢が、いつか実現するといいね。", "translation": "I hope that Nobita's dream will come true someday."},
     {"word": "I'm afraid that", "meaning": "～ではないかと心配している", "example": "ドラえもんは、「ちょっと不安です」と言った。", "translation": "Doraemon said, 'I'm afraid that something might go wrong'."},
     {"word": "Over there", "meaning": "あそこに", "example": "ドラえもんは、「あそこを見て」と言った。", "translation": "Doraemon said, 'Look over there'."},
     {"word": "Get up", "meaning": "起きる", "example": "のび太は、なかなか起きられない。", "translation": "Nobita cannot get up easily."},
     {"word": "Look at", "meaning": "～を見る", "example": "ドラえもんは、写真を見た。", "translation": "Doraemon looked at the picture."},
     {"word": "Go around", "meaning": "～を回る", "example": "ドラえもんは、世界中を回った。", "translation": "Doraemon went around the world."}
     ];
     break;
     case "中学英熟語25":
     item = [
     {"word": "Half of", "meaning": "～の半分", "example": "ドラえもんは、どら焼きの半分を食べた。", "translation": "Doraemon ate half of the dorayaki."},
     {"word": "Sounds good.", "meaning": "いいですね", "example": "ドラえもんは、「いいですね」と答えた。", "translation": "Doraemon replied, 'Sounds good'."},
     {"word": "Cut down", "meaning": "切り倒す", "example": "ドラえもんは、木を切って道を切り開いた。", "translation": "Doraemon cut down a tree to make a path."},
     {"word": "See her off", "meaning": "～を見送る", "example": "ドラえもんは、友達を見送った。", "translation": "Doraemon saw his friend off."},
     {"word": "Just then", "meaning": "ちょうどその時", "example": "ドラえもんは、ちょうどその時に現れた。", "translation": "Doraemon appeared just then."},
     {"word": "Far away", "meaning": "遠く離れて", "example": "ドラえもんは、遠く離れた場所へ旅に出た。", "translation": "Doraemon went on a journey far away."},
     {"word": "How much", "meaning": "いくら", "example": "ドラえもんは、値段を尋ねた。", "translation": "Doraemon asked, 'How much does it cost?'"},
     {"word": "Not ～any more", "meaning": "もはや～ない", "example": "のび太は、もはや学校に遅刻しないだろう。", "translation": "Nobita will no longer be late for school."},
     {"word": "Be surprised to", "meaning": "～して驚く", "example": "ドラえもんは、驚いて飛び上がった。", "translation": "Doraemon was surprised to jump up."},
     {"word": "Many times", "meaning": "何度も", "example": "ドラえもんは、何度も同じ失敗を繰り返した。", "translation": "Doraemon made the same mistake many times."}
     ];
     break;
     case "中学英熟語26":
     item = [
     {"word": "A kind of", "meaning": "一種の～", "example": "ドラえもんは、一種のロボットだ。", "translation": "Doraemon is a kind of robot."},
     {"word": "The same as", "meaning": "～と同じ", "example": "ドラえもんは、昔と今では同じように見える。", "translation": "Doraemon looks the same as he was before."},
     {"word": "Be careful about", "meaning": "～に気をつける", "example": "ドラえもんは、健康に気を付けている。", "translation": "Doraemon is careful about his health."},
     {"word": "Take a picture", "meaning": "写真を撮る", "example": "ドラえもんは、記念写真を撮った。", "translation": "Doraemon took a picture as a souvenir."},
     {"word": "All right.", "meaning": "大丈夫だよ", "example": "ドラえもんは、「大丈夫だよ」と言った。", "translation": "Doraemon said, 'All right'."},
     {"word": "Part of", "meaning": "～の一部", "example": "ドラえもんは、この街の一部になっている。", "translation": "Doraemon has become a part of this town."},
     {"word": "Go and see", "meaning": "見に行く", "example": "ドラえもんは、のび太と博物館を見に行った。", "translation": "Doraemon went to see a museum with Nobita."},
     {"word": "See a doctor", "meaning": "医者に診てもらう", "example": "ドラえもんは、「具合が悪いなら医者に診てもらった方が良い」と言った。", "translation": "Doraemon said, 'You should see a doctor if you feel sick'."},
     {"word": "By hand", "meaning": "手で", "example": "ドラえもんは、手で絵を描いた。", "translation": "Doraemon drew a picture by hand."},
     {"word": "Look down", "meaning": "見下ろす", "example": "ドラえもんは、街を見下ろした。", "translation": "Doraemon looked down on the town."}
     ];
     break;
     case "中学英熟語27":
     item = [
     {"word": "Go to bed", "meaning": "寝る", "example": "のび太は、いつもすぐに寝てしまう。", "translation": "Nobita always goes to bed immediately."},
     {"word": "Of course", "meaning": "もちろん", "example": "ドラえもんは、「もちろん」と答えた。", "translation": "Doraemon answered, 'Of course'."},
     {"word": "Either A or B", "meaning": "AかBのどちらか", "example": "ドラえもんは、AかBのどちらかの道具を使うことにした。", "translation": "Doraemon decided to use either gadget A or B."},
     {"word": "Speak to", "meaning": "～に話しかける", "example": "ドラえもんは、困っている人に話しかけた。", "translation": "Doraemon spoke to someone who was in trouble."},
     {"word": "Exchange A for B", "meaning": "AをBと交換する", "example": "ドラえもんは、道具をどら焼きと交換した。", "translation": "Doraemon exchanged a gadget for a dorayaki."},
     {"word": "Would you like?", "meaning": "～はいかがですか？", "example": "ドラえもんは、「お茶はいかがですか？」と聞いた。", "translation": "Doraemon asked, 'Would you like some tea?'"},
     {"word": "Happen to", "meaning": "たまたま～する", "example": "ドラえもんは、たまたま良い道具を見つけた。", "translation": "Doraemon happened to find a good gadget."},
     {"word": "Bring back", "meaning": "～を持ち帰る", "example": "ドラえもんは、お土産を持ち帰った。", "translation": "Doraemon brought back souvenirs."},
     {"word": "Wait for", "meaning": "～を待つ", "example": "ドラえもんは、のび太を待っていた。", "translation": "Doraemon was waiting for Nobita."},
     {"word": "Go on a trip to", "meaning": "～へ旅行に行く", "example": "ドラえもんは、過去へ旅行に行った。", "translation": "Doraemon went on a trip to the past."}
     ];
     break;
     case "中学英熟語28":
     item = [
     {"word": "Keep in touch", "meaning": "連絡を取り合う", "example": "ドラえもんは、友達と連絡を取り合っている。", "translation": "Doraemon keeps in touch with his friends."},
     {"word": "Do my homework", "meaning": "宿題をする", "example": "のび太は、いつも宿題をするのが嫌だ。", "translation": "Nobita always hates to do his homework."},
     {"word": "You're welcome.", "meaning": "どういたしまして", "example": "ドラえもんは、「どういたしまして」と言った。", "translation": "Doraemon said, 'You're welcome'."},
     {"word": "For a long time", "meaning": "長い間", "example": "ドラえもんは、長い間未来にいた。", "translation": "Doraemon was in the future for a long time."},
     {"word": "Pay for", "meaning": "～の代金を払う", "example": "ドラえもんは、食事の代金を払った。", "translation": "Doraemon paid for the meal."},
     {"word": "Because of", "meaning": "～のせいで", "example": "のび太は、雨のせいで遅刻した。", "translation": "Nobita was late because of the rain."},
     {"word": "A lot", "meaning": "たくさんの", "example": "ドラえもんは、たくさんのお菓子を持っている。", "translation": "Doraemon has a lot of snacks."},
     {"word": "Wake up", "meaning": "目を覚ます", "example": "ドラえもんは、のび太を起こすのが得意だ。", "translation": "Doraemon is good at waking up Nobita."},
     {"word": "Be friendly to", "meaning": "～に親切にする", "example": "ドラえもんは、誰にでも親切にする。", "translation": "Doraemon is friendly to everyone."},
     {"word": "Work at", "meaning": "～で働く", "example": "ドラえもんは、未来の工場で働いた。", "translation": "Doraemon worked at a factory in the future."}
     ];
     break;
     case "中学英熟語29":
     item = [
     {"word": "As long as", "meaning": "～である限り", "example": "ドラえもんは、のび太が困っている限り助けるだろう。", "translation": "Doraemon will help Nobita as long as he is in trouble."},
     {"word": "Take a walk", "meaning": "散歩する", "example": "ドラえもんは、のび太と散歩に出かけた。", "translation": "Doraemon took a walk with Nobita."},
     {"word": "Be afraid of", "meaning": "～を恐れる", "example": "ドラえもんは、ねずみを恐れている。", "translation": "Doraemon is afraid of mice."},
     {"word": "Hold on", "meaning": "つかまる", "example": "ドラえもんは、手すりにつかまった。", "translation": "Doraemon held on to the railing."},
     {"word": "The way to", "meaning": "～への道", "example": "ドラえもんは、学校への道を知っている。", "translation": "Doraemon knows the way to school."},
     {"word": "Look for", "meaning": "～を探す", "example": "ドラえもんは、なくした道具を探した。", "translation": "Doraemon looked for the lost gadget."},
     {"word": "Get along with", "meaning": "～と仲良くする", "example": "ドラえもんは、いつもみんなと仲良くしている。", "translation": "Doraemon always gets along with everyone."},
     {"word": "Come on.", "meaning": "さあ", "example": "ドラえもんは、のび太に「さあ、行こう！」と言った。", "translation": "Doraemon said to Nobita, 'Come on, let's go!'"},
     {"word": "On the way", "meaning": "途中で", "example": "ドラえもんは、学校の途中で買い物をした。", "translation": "Doraemon went shopping on the way to school."},
     {"word": "Get well", "meaning": "良くなる", "example": "ドラえもんは、「早く良くなってね」と言った。", "translation": "Doraemon said, 'Get well soon'."},
     {"word": "May I help you?", "meaning": "お手伝いしましょうか？", "example": "ドラえもんは、「お手伝いしましょうか？」と聞いた。", "translation": "Doraemon asked, 'May I help you?'"}
     ];
     break;
     case "中学英熟語30":
     item = [
     {"word": "Do my best", "meaning": "最善を尽くす", "example": "ドラえもんは、いつも最善を尽くしている。", "translation": "Doraemon always does his best."},
     {"word": "Take away", "meaning": "～を取り去る", "example": "ドラえもんは、悪いものをすべて取り去った。", "translation": "Doraemon took away all the bad things."},
     {"word": "Go out", "meaning": "外出する", "example": "ドラえもんは、友達と外出するのが好きだ。", "translation": "Doraemon likes to go out with his friends."},
     {"word": "A pair of", "meaning": "一組の～", "example": "ドラえもんは、一組の手袋を使った。", "translation": "Doraemon used a pair of gloves."},
     {"word": "I'm sure that", "meaning": "～だと確信している", "example": "ドラえもんは、「きっとうまくいくと確信している」と言った。", "translation": "Doraemon said, 'I'm sure that it will go well'."},
     {"word": "Pick up", "meaning": "拾う", "example": "ドラえもんは、落ちていたものを拾い上げた。", "translation": "Doraemon picked up the thing that had fallen."},
     {"word": "At that time", "meaning": "その時", "example": "ドラえもんは、その時、未来にいた。", "translation": "At that time, Doraemon was in the future."},
     {"word": "How often", "meaning": "どのくらい", "example": "ドラえもんは、のび太に「どのくらいの頻度で勉強するの？」と聞いた。", "translation": "Doraemon asked Nobita, 'How often do you study?'"},
     {"word": "Keep talking", "meaning": "話し続ける", "example": "ドラえもんは、面白い話をし続けた。", "translation": "Doraemon kept talking about interesting stories."},
     {"word": "All alone", "meaning": "一人ぼっちで", "example": "のび太は、一人ぼっちで寂しかった。", "translation": "Nobita was lonely all alone."}
     ];
     break;
    
     
     case "中学英熟語31":
     item = [
     {"word": "These days", "meaning": "最近", "example": "ドラえもんは、最近の出来事を話してくれた。", "translation": "Doraemon told me about things that have happened these days."},
     {"word": "Be full of", "meaning": "～でいっぱいである", "example": "ドラえもんのポケットは、いつも秘密道具でいっぱいだ。", "translation": "Doraemon's pocket is always full of secret gadgets."},
     {"word": "Stand for", "meaning": "～を象徴する", "example": "ドラえもんは、友達の象徴だ。", "translation": "Doraemon stands for friendship."},
     {"word": "Be kind to", "meaning": "～に親切にする", "example": "ドラえもんは、みんなに親切にする。", "translation": "Doraemon is kind to everyone."},
     {"word": "Walk around", "meaning": "歩き回る", "example": "ドラえもんは、街を歩き回った。", "translation": "Doraemon walked around the town."},
     {"word": "A few", "meaning": "少数の", "example": "ドラえもんは、少しだけお菓子を食べた。", "translation": "Doraemon ate a few snacks."},
     {"word": "Play catch", "meaning": "キャッチボールをする", "example": "ドラえもんは、のび太とキャッチボールをして遊んだ。", "translation": "Doraemon played catch with Nobita."},
     {"word": "At last", "meaning": "ついに", "example": "ドラえもんは、ついに秘密道具を完成させた。", "translation": "Doraemon finally completed the secret gadget."},
     {"word": "Take care of", "meaning": "～の世話をする", "example": "ドラえもんは、いつも のび太の世話をする。", "translation": "Doraemon always takes care of Nobita."},
     {"word": "Last year", "meaning": "去年", "example": "ドラえもんは、去年、未来へ旅行に行った。", "translation": "Doraemon traveled to the future last year."}
     ];
     break;
     case "中学英熟語32":
     item = [
     {"word": "All over", "meaning": "～の至る所に", "example": "ドラえもんは、街の至る所を歩き回った。", "translation": "Doraemon walked all over the town."},
     {"word": "Work on", "meaning": "～に取り組む", "example": "ドラえもんは、新しい発明に取り組んだ。", "translation": "Doraemon worked on a new invention."},
     {"word": "How to", "meaning": "～する方法", "example": "ドラえもんは、道具の使い方を説明した。", "translation": "Doraemon explained how to use the gadget."},
     {"word": "Give ～a call", "meaning": "～に電話する", "example": "ドラえもんは、友達に電話をした。", "translation": "Doraemon gave his friend a call."},
     {"word": "Walk to", "meaning": "～まで歩く", "example": "ドラえもんは、学校まで歩いた。", "translation": "Doraemon walked to school."},
     {"word": "Do well", "meaning": "うまくやる", "example": "ドラえもんは、「テスト頑張って」と言った。", "translation": "Doraemon said, 'Do well on the test'."},
     {"word": "How about", "meaning": "～はいかがですか？", "example": "ドラえもんは、のび太に「お茶はいかがですか？」と聞いた。", "translation": "Doraemon asked Nobita, 'How about some tea?'"},
     {"word": "More and more", "meaning": "ますます", "example": "ドラえもんは、ますます強くなっている。", "translation": "Doraemon is becoming more and more powerful."},
     {"word": "Call back", "meaning": "電話をかけ直す", "example": "ドラえもんは、「後でかけ直すね」と言った。", "translation": "Doraemon said, 'I'll call back later'."},
     {"word": "In fact", "meaning": "実際は", "example": "ドラえもんは、実際は優しいロボットだ。", "translation": "In fact, Doraemon is a kind robot."}
     ];
     break;
     case "中学英熟語33":
     item = [
     {"word": "Come out of", "meaning": "～から出てくる", "example": "ドラえもんは、どこでもドアから出てきた。", "translation": "Doraemon came out of the Anywhere Door."},
     {"word": "On foot", "meaning": "徒歩で", "example": "ドラえもんは、徒歩で街を散歩した。", "translation": "Doraemon took a walk around the town on foot."},
     {"word": "Have a chance to", "meaning": "～する機会がある", "example": "ドラえもんは、またの機会に未来へ行くことにした。", "translation": "Doraemon had a chance to go to the future again."},
     {"word": "Enough to", "meaning": "～するのに十分な", "example": "ドラえもんは、十分な食料を持ってきた。", "translation": "Doraemon brought enough food to last."},
     {"word": "Think about", "meaning": "～について考える", "example": "ドラえもんは、自分の未来について考えた。", "translation": "Doraemon thought about his future."},
     {"word": "Bring up", "meaning": "～を育てる", "example": "ドラえもんは、のび太を立派な大人に育てたいと思っている。", "translation": "Doraemon wants to bring up Nobita into a fine adult."},
     {"word": "Look forward to", "meaning": "～を楽しみにする", "example": "ドラえもんは、明日の冒険を楽しみにしている。", "translation": "Doraemon is looking forward to tomorrow's adventure."},
     {"word": "Get angry", "meaning": "怒る", "example": "ジャイアンは、いつも怒っている。", "translation": "Gian always gets angry."},
     {"word": "Please help yourself.", "meaning": "ご自由にどうぞ", "example": "ドラえもんは、「ご自由にどうぞ」と言った。", "translation": "Doraemon said, 'Please help yourself'."},
     {"word": "Day after day", "meaning": "毎日毎日", "example": "のび太は、毎日毎日宿題を忘れる。", "translation": "Nobita forgets his homework day after day."}
     ];
     break;
     case "中学英熟語34":
     item = [
     {"word": "Stand up", "meaning": "立ち上がる", "example": "ドラえもんは、椅子から立ち上がった。", "translation": "Doraemon stood up from the chair."},
     {"word": "Go shopping", "meaning": "買い物に行く", "example": "ドラえもんは、買い物に行った。", "translation": "Doraemon went shopping."},
     {"word": "Seem to", "meaning": "～のようだ", "example": "ドラえもんは、少し疲れているようだ。", "translation": "Doraemon seems to be a little tired."},
     {"word": "Arrive at", "meaning": "～に到着する", "example": "ドラえもんは、目的地に到着した。", "translation": "Doraemon arrived at his destination."},
     {"word": "Want to", "meaning": "～したい", "example": "ドラえもんは、未来に行ってみたい。", "translation": "Doraemon wants to go to the future."},
     {"word": "Away from", "meaning": "～から離れて", "example": "ドラえもんは、危険な場所から離れた。", "translation": "Doraemon went away from the dangerous place."},
     {"word": "Have fun", "meaning": "楽しむ", "example": "ドラえもんは、友達と遊んで楽しんだ。", "translation": "Doraemon had fun playing with his friends."},
     {"word": "Take it easy.", "meaning": "ゆっくりしてね", "example": "ドラえもんは、「ゆっくりしてね」と言った。", "translation": "Doraemon said, 'Take it easy'."},
     {"word": "A sheet of", "meaning": "一枚の～", "example": "ドラえもんは、一枚の紙を取り出した。", "translation": "Doraemon took out a sheet of paper."},
     {"word": "On the other hand", "meaning": "その一方で", "example": "のび太が勉強嫌いな一方で、しずかちゃんは勉強が好きだ。", "translation": "On the other hand, Shizuka likes studying while Nobita dislikes it."}
     ];
     break;
     case "中学英熟語35":
     item = [
     {"word": "Be responsible for", "meaning": "～に責任がある", "example": "ドラえもんは、みんなを守る責任があると思っている。", "translation": "Doraemon thinks he is responsible for protecting everyone."},
     {"word": "This morning", "meaning": "今朝", "example": "ドラえもんは、今朝早く起きた。", "translation": "Doraemon woke up early this morning."},
     {"word": "In front of", "meaning": "～の前に", "example": "ドラえもんは、学校の前にいる。", "translation": "Doraemon is in front of the school."},
     {"word": "First of all", "meaning": "まず第一に", "example": "ドラえもんは、まず第一に状況を把握しようとした。", "translation": "First of all, Doraemon tried to grasp the situation."},
     {"word": "More than", "meaning": "～よりも", "example": "ドラえもんは、のび太よりも早く走れる。", "translation": "Doraemon can run faster than Nobita."},
     {"word": "Catch a cold", "meaning": "風邪をひく", "example": "のび太は、また風邪をひいてしまった。", "translation": "Nobita caught a cold again."},
     {"word": "Plenty of", "meaning": "たくさんの～", "example": "ドラえもんは、たくさんのどら焼きを持ってきた。", "translation": "Doraemon brought plenty of dorayaki."},
     {"word": "Fall down", "meaning": "転ぶ", "example": "のび太は、いつも転んでしまう。", "translation": "Nobita always falls down."},
     {"word": "Start to learn", "meaning": "～を習い始める", "example": "のび太は、ドラえもんから勉強を教わり始めた。", "translation": "Nobita started to learn from Doraemon."},
     {"word": "every day", "meaning": "毎日", "example": "ドラえもんは、毎日、のび太と遊んでいる。", "translation": "Doraemon plays with Nobita every day."}
     ];
     break;
     case "中学英熟語36":
     item = [
     {"word": "How old", "meaning": "何歳", "example": "ドラえもんは、のび太に「何歳？」と聞いた。", "translation": "Doraemon asked Nobita, 'How old are you?'"},
     {"word": "Shall I?", "meaning": "～しましょうか", "example": "ドラえもんは、「手伝いましょうか？」と聞いた。", "translation": "Doraemon asked, 'Shall I help you?'"},
     {"word": "At school", "meaning": "学校で", "example": "ドラえもんは、学校で勉強を教えてくれた。", "translation": "Doraemon taught me at school."},
     {"word": "Move around", "meaning": "動き回る", "example": "ドラえもんは、自由に動き回ることができる。", "translation": "Doraemon can move around freely."},
     {"word": "Take me to", "meaning": "～に連れて行って", "example": "のび太は、ドラえもんに「遊園地に連れて行って」と頼んだ。", "translation": "Nobita asked Doraemon, 'Take me to the amusement park'."},
     {"word": "And so on", "meaning": "など", "example": "ドラえもんは、どら焼きやあんぱんなどを持ってきた。", "translation": "Doraemon brought snacks such as dorayaki and anpan."},
     {"word": "Believe in", "meaning": "～を信じる", "example": "ドラえもんは、のび太の可能性を信じている。", "translation": "Doraemon believes in Nobita's potential."},
     {"word": "Want you try", "meaning": "～に試して欲しい", "example": "ドラえもんは、のび太に「これを使ってみてほしい」と言った。", "translation": "Doraemon said to Nobita, 'I want you try this'."},
     {"word": "Ask him to", "meaning": "彼に～するように頼む", "example": "のび太は、ドラえもんに宿題を手伝うように頼んだ。", "translation": "Nobita asked Doraemon to help him with his homework."},
     {"word": "Learn about", "meaning": "～について学ぶ", "example": "ドラえもんは、歴史について学んだ。", "translation": "Doraemon learned about history."}
     ];
     break;
     case "中学英熟語37":
     item = [
     {"word": "Be glad to", "meaning": "～して嬉しい", "example": "ドラえもんは、のび太を助けることができて嬉しい。", "translation": "Doraemon is glad to help Nobita."},
     {"word": "Point to", "meaning": "～を指し示す", "example": "ドラえもんは、地図で目的地を指し示した。", "translation": "Doraemon pointed to the destination on the map."},
     {"word": "Get married", "meaning": "結婚する", "example": "のび太は、将来しずかちゃんと結婚する。", "translation": "Nobita will get married to Shizuka in the future."},
     {"word": "Look into", "meaning": "～を調べる", "example": "ドラえもんは、事件について調べてみた。", "translation": "Doraemon looked into the incident."},
     {"word": "By bus", "meaning": "バスで", "example": "ドラえもんは、バスで移動した。", "translation": "Doraemon went by bus."},
     {"word": "Get back", "meaning": "戻る", "example": "ドラえもんは、元の場所に戻った。", "translation": "Doraemon got back to his original location."},
     {"word": "On the phone", "meaning": "電話で", "example": "ドラえもんは、電話で友達と話した。", "translation": "Doraemon talked to his friend on the phone."},
     {"word": "Clean up", "meaning": "～を片付ける", "example": "ドラえもんは、散らかった部屋を片付けた。", "translation": "Doraemon cleaned up the messy room."},
     {"word": "Welcome to", "meaning": "～へようこそ", "example": "ドラえもんは、「未来へようこそ」と言った。", "translation": "Doraemon said, 'Welcome to the future'."},
     {"word": "For a while", "meaning": "しばらくの間", "example": "ドラえもんは、しばらくの間休憩した。", "translation": "Doraemon took a break for a while."}
     ];
     break;
     case "中学英熟語38":
     item = [
     {"word": "Worry about", "meaning": "～について心配する", "example": "ドラえもんは、のび太のことを心配している。", "translation": "Doraemon worries about Nobita."},
     {"word": "Have a cold", "meaning": "風邪をひいている", "example": "のび太は、風邪をひいて寝込んでいる。", "translation": "Nobita has a cold and is in bed."},
     {"word": "A great number of", "meaning": "非常に多くの～", "example": "ドラえもんは、非常にたくさんの道具を持っている。", "translation": "Doraemon has a great number of gadgets."},
     {"word": "Show you around", "meaning": "～を案内する", "example": "ドラえもんは、未来の街を案内してくれた。", "translation": "Doraemon showed me around the future city."},
     {"word": "At first", "meaning": "最初は", "example": "ドラえもんは、最初は失敗したが、後で成功した。", "translation": "At first, Doraemon failed but later succeeded."},
     {"word": "Take off", "meaning": "離陸する", "example": "ドラえもんは、飛行機が離陸するのを見た。", "translation": "Doraemon watched the airplane take off."},
     {"word": "a bit", "meaning": "少し", "example": "ドラえもんは、少しだけ疲れている。", "translation": "Doraemon is a bit tired."},
     {"word": "In order to", "meaning": "～するために", "example": "ドラえもんは、のび太を助けるために行動した。", "translation": "Doraemon acted in order to help Nobita."},
     {"word": "All the time", "meaning": "いつも", "example": "ドラえもんは、いつも優しい。", "translation": "Doraemon is kind all the time."},
     {"word": "This one", "meaning": "これ", "example": "ドラえもんは、「この道具を使って」と言った。", "translation": "Doraemon said, 'Use this one'."}
     ];
     break;
     case "中学英熟語39":
     item = [
     {"word": "Be made of", "meaning": "～でできている", "example": "ドラえもんの体は、金属でできている。", "translation": "Doraemon's body is made of metal."},
     {"word": "Go through", "meaning": "～を経験する", "example": "ドラえもんは、色々な経験をしてきた。", "translation": "Doraemon has gone through various experiences."},
     {"word": "What kind of", "meaning": "どんな～", "example": "ドラえもんは、「どんなものが欲しい？」と聞いた。", "translation": "Doraemon asked, 'What kind of gadget do you want?'"},
     {"word": "Agree with", "meaning": "～に賛成する", "example": "ドラえもんは、のび太の意見に賛成した。", "translation": "Doraemon agreed with Nobita's opinion."},
     {"word": "Be sick in bed", "meaning": "病気で寝ている", "example": "のび太は、風邪で寝込んでいる。", "translation": "Nobita is sick in bed due to a cold."},
     {"word": "Write back", "meaning": "返信する", "example": "ドラえもんは、手紙に返事を書いた。", "translation": "Doraemon wrote back in response to the letter."},
     {"word": "As hard as you can", "meaning": "できる限り", "example": "ドラえもんは、「できる限り頑張って」と言った。", "translation": "Doraemon said, 'Do your best as hard as you can'."},
     {"word": "Learn to", "meaning": "～することを学ぶ", "example": "ドラえもんは、料理することを学んだ。", "translation": "Doraemon learned to cook."},
     {"word": "Be good at", "meaning": "～が得意", "example": "ドラえもんは、道具を作るのが得意だ。", "translation": "Doraemon is good at making gadgets."},
     {"word": "Take out", "meaning": "～を取り出す", "example": "ドラえもんは、ポケットから道具を取り出した。", "translation": "Doraemon took out a gadget from his pocket."}
     ];
     break;
     case "中学英熟語40":
     item = [
     {"word": "Give up", "meaning": "諦める", "example": "のび太は、すぐにあきらめてしまう。", "translation": "Nobita gives up easily."},
     {"word": "Look like", "meaning": "～のように見える", "example": "ドラえもんは、猫のように見えると言われた。", "translation": "Doraemon was told he looks like a cat."},
     {"word": "A long time ago", "meaning": "昔", "example": "ドラえもんは、昔、タイムマシンを作った。", "translation": "Doraemon made a time machine a long time ago."},
     {"word": "In the end", "meaning": "結局", "example": "ドラえもんは、結局のび太を助けた。", "translation": "In the end, Doraemon helped Nobita."},
     {"word": "This time", "meaning": "今回は", "example": "ドラえもんは、今回は成功した。", "translation": "Doraemon succeeded this time."},
     {"word": "Be born", "meaning": "生まれる", "example": "ドラえもんは、未来で生まれた。", "translation": "Doraemon was born in the future."},
     {"word": "Have a headache", "meaning": "頭痛がする", "example": "のび太は、頭痛がして寝ている。", "translation": "Nobita has a headache and is in bed."},
     {"word": "On time", "meaning": "時間通りに", "example": "ドラえもんは、いつも時間通りに行動する。", "translation": "Doraemon always acts on time."},
     {"word": "After a while", "meaning": "しばらくして", "example": "ドラえもんは、しばらくして戻ってきた。", "translation": "Doraemon came back after a while."},
     {"word": "Most of", "meaning": "ほとんどの～", "example": "ドラえもんは、ほとんどの時間をのび太と過ごす。", "translation": "Doraemon spends most of his time with Nobita."},
     {"word": "Begin with", "meaning": "～から始める", "example": "ドラえもんは、挨拶から始めた。", "translation": "Doraemon began with a greeting."}
     ];
     break;
    
    
     
     case "高校英熟語11":
     item = [
     {"word": "consist of ～", "meaning": "～から構成される", "example": "ドラえもんの体は、多くの部品から構成されている。", "translation": "Doraemon's body consists of many parts."},
     {"word": "hope for ～", "meaning": "～を望む", "example": "ドラえもんは、のび太の成長を望んでいる。", "translation": "Doraemon hopes for Nobita's growth."},
     {"word": "over and over", "meaning": "何度も", "example": "のび太は、同じ失敗を何度も繰り返した。", "translation": "Nobita made the same mistake over and over."},
     {"word": "at the latest", "meaning": "遅くとも", "example": "ドラえもんは、「遅くとも明日までには返してね」と言った。", "translation": "Doraemon said, 'Return it by tomorrow at the latest'."},
     {"word": "deprive A of B", "meaning": "AからBを奪う", "example": "ドラえもんは、のび太から夢を奪うことは決してない。", "translation": "Doraemon never deprives Nobita of his dreams."},
     {"word": "would rather A (than B)", "meaning": "BよりAの方が好きだ", "example": "ドラえもんは、あんこよりもどら焼きの方が好きだ。", "translation": "Doraemon would rather have dorayaki than anko."},
     {"word": "be due to …", "meaning": "～が原因である", "example": "のび太の遅刻は、寝坊が原因である。", "translation": "Nobita being late is due to oversleeping."},
     {"word": "none the less", "meaning": "それにもかかわらず", "example": "ドラえもんは、大変だったが、それでもやり遂げた。", "translation": "Doraemon had a hard time but did it none the less."},
     {"word": "bring about ～", "meaning": "～を引き起こす", "example": "ドラえもんは、良い結果を引き起こした。", "translation": "Doraemon brought about a good result."},
     {"word": "in conclusion", "meaning": "結論として", "example": "ドラえもんは、結論として、こう言うしかないと言った。", "translation": "In conclusion, Doraemon said there's no other way."}
     ,{"word": "rob A of B", "meaning": "AからBを奪う", "example": "ドラえもんは、泥棒が町の人からお金を奪うのを防いだ。", "translation": "Doraemon prevented a thief from robbing the townspeople of their money."}
     ];
     break;
     case "高校英熟語12":
     item = [
     {"word": "ahead of ～", "meaning": "～よりも先に", "example": "ドラえもんは、のび太よりも先に行った。", "translation": "Doraemon went ahead of Nobita."},
     {"word": "think much of ～", "meaning": "～を重視する", "example": "ドラえもんは、友達をとても大切に思っている。", "translation": "Doraemon thinks much of his friends."},
     {"word": "close to ～", "meaning": "～に近い", "example": "ドラえもんは、のび太の家に近いところに住んでいる。", "translation": "Doraemon lives close to Nobita's house."},
     {"word": "keep away from ～", "meaning": "～に近づかない", "example": "ドラえもんは、危険な場所には近づかない。", "translation": "Doraemon keeps away from dangerous places."},
     {"word": "be related to ～", "meaning": "～と関係がある", "example": "ドラえもんの道具は、未来の技術と関係がある。", "translation": "Doraemon's gadgets are related to future technology."},
     {"word": "hundreds of ～", "meaning": "何百もの～", "example": "ドラえもんは、何百もの秘密道具を持っている。", "translation": "Doraemon has hundreds of secret gadgets."},
     {"word": "not to say ～", "meaning": "～とは言わないまでも", "example": "ドラえもんは、完璧とは言わないまでも、良いロボットだ。", "translation": "Not to say he's perfect, Doraemon is a good robot."},
     {"word": "fall asleep", "meaning": "眠ってしまう", "example": "のび太は、すぐに眠ってしまう。", "translation": "Nobita always falls asleep immediately."},
     {"word": "at the sight of ～", "meaning": "～を見ると", "example": "ドラえもんは、ネズミを見ると怖がる。", "translation": "Doraemon is afraid at the sight of mice."},
     {"word": "in spite of ～", "meaning": "～にもかかわらず", "example": "ドラえもんは、困難にもかかわらず諦めない。", "translation": "Doraemon doesn't give up in spite of the difficulties."}
     ];
     break;
     case "高校英熟語13":
     item = [
     {"word": "blame A for B", "meaning": "AをBのことで責める", "example": "ジャイアンは、のび太をいつも失敗のことで責める。", "translation": "Gian always blames Nobita for his mistakes."},
     {"word": "in detail", "meaning": "詳細に", "example": "ドラえもんは、問題を詳細に説明した。", "translation": "Doraemon explained the problem in detail."},
     {"word": "to make matters worse", "meaning": "さらに悪いことに", "example": "さらに悪いことに、雨まで降ってきた。", "translation": "To make matters worse, it started raining."},
     {"word": "by no means ～", "meaning": "決して～ない", "example": "ドラえもんは、決して嘘をつかない。", "translation": "Doraemon is by no means a liar."},
     {"word": "owe A to B", "meaning": "AはBのおかげである", "example": "のび太は、今の自分がいるのはドラえもんのおかげだと思っている。", "translation": "Nobita thinks he owes his current self to Doraemon."},
     {"word": "if any", "meaning": "もしあれば", "example": "ドラえもんは、もし何か困ったことがあれば言ってねと言った。", "translation": "Doraemon said, 'Tell me if any problems arise'."},
     {"word": "pass away", "meaning": "亡くなる", "example": "ドラえもんは、昔の友達が亡くなったのを知り悲しんだ。", "translation": "Doraemon was sad to hear that his friend from the past had passed away."},
     {"word": "as soon as possible", "meaning": "できるだけ早く", "example": "ドラえもんは、できるだけ早く問題を解決したかった。", "translation": "Doraemon wanted to solve the problem as soon as possible."},
     {"word": "derive A from B", "meaning": "AをBから得る", "example": "ドラえもんは、未来の知識を本から得ている。", "translation": "Doraemon derives his knowledge from books from the future."},
     {"word": "nothing but ～", "meaning": "～にすぎない", "example": "のび太は、宿題をするのが嫌いなだけの子供にすぎない。", "translation": "Nobita is nothing but a kid who dislikes doing homework."}
     ];
     break;
     case "高校英熟語14":
     item = [
     {"word": "but for ～", "meaning": "～がなければ", "example": "ドラえもんがいなければ、のび太は困ったことになっていた。", "translation": "But for Doraemon, Nobita would have been in trouble."},
     {"word": "in terms of ～", "meaning": "～の観点から", "example": "ドラえもんは、技術的な観点から問題を分析した。", "translation": "Doraemon analyzed the problem in terms of technology."},
     {"word": "come about", "meaning": "起こる", "example": "ドラえもんは、なぜこの出来事が起こったのか調べた。", "translation": "Doraemon investigated how this incident came about."},
     {"word": "search for ～", "meaning": "～を探す", "example": "ドラえもんは、失われた道具を探し続けた。", "translation": "Doraemon continued to search for the lost gadget."},
     {"word": "fall in love with ～", "meaning": "～に恋をする", "example": "ドラえもんは、未来の歌手に恋をした。", "translation": "Doraemon fell in love with a future singer."},
     {"word": "be equal to ～", "meaning": "～に等しい", "example": "ドラえもんは、のび太を友達として等しく大切に思っている。", "translation": "Doraemon values Nobita as an equal friend."},
     {"word": "if anything", "meaning": "どちらかといえば", "example": "ドラえもんは、どちらかといえば優しい。", "translation": "If anything, Doraemon is kind."},
     {"word": "to say nothing of ～", "meaning": "～は言うまでもなく", "example": "ドラえもんは、道具の性能は言うまでもなく、デザインも素晴らしい。", "translation": "To say nothing of the performance, Doraemon's gadgets also have a wonderful design."},
     {"word": "by virtue of ～", "meaning": "～のおかげで", "example": "ドラえもんは、道具のおかげで問題を解決した。", "translation": "Doraemon solved the problem by virtue of his gadgets."},
     {"word": "make sense", "meaning": "意味をなす", "example": "ドラえもんは、その説明は理にかなっていると言った。", "translation": "Doraemon said that explanation makes sense."}
     ];
     break;
     case "高校英語15":
     item = [
     {"word": "pay attention to ～", "meaning": "～に注意を払う", "example": "ドラえもんは、周囲の状況に注意を払った。", "translation": "Doraemon paid attention to his surroundings."},
     {"word": "all at once", "meaning": "同時に", "example": "ドラえもんは、道具を全て同時に使った。", "translation": "Doraemon used all his gadgets all at once."},
     {"word": "in exchange for ～", "meaning": "～と引き換えに", "example": "ドラえもんは、道具をどら焼きと交換した。", "translation": "Doraemon exchanged the gadget in exchange for dorayaki."},
     {"word": "cope with ～", "meaning": "～に対処する", "example": "ドラえもんは、困難な状況に対処した。", "translation": "Doraemon coped with a difficult situation."},
     {"word": "object to ～", "meaning": "～に反対する", "example": "ドラえもんは、暴力的な行為に反対した。", "translation": "Doraemon objected to the violent act."},
     {"word": "in the long run", "meaning": "長期的には", "example": "ドラえもんは、長期的には良い結果になるだろうと言った。", "translation": "Doraemon said that it will be a good result in the long run."},
     {"word": "second to none", "meaning": "誰にも劣らない", "example": "ドラえもんは、ロボットとしての能力は誰にも劣らない。", "translation": "Doraemon's abilities as a robot are second to none."},
     {"word": "in any case", "meaning": "いずれにせよ", "example": "ドラえもんは、いずれにせよ、助けると言った。", "translation": "Doraemon said he would help in any case."},
     {"word": "from ～ point of view", "meaning": "～の観点から", "example": "ドラえもんは、のび太の観点から問題を考えた。", "translation": "Doraemon considered the problem from Nobita's point of view."},
     {"word": "keep off ～", "meaning": "～に近づかない", "example": "ドラえもんは、危険な場所に近づかないように言った。", "translation": "Doraemon said to keep off from dangerous places."}
     ];
     break;
     case "高校英熟語16":
     item = [
     {"word": "at a loss", "meaning": "途方に暮れて", "example": "ドラえもんは、どうすれば良いか途方に暮れた。", "translation": "Doraemon was at a loss about what to do."},
     {"word": "to some extent", "meaning": "ある程度", "example": "ドラえもんは、ある程度問題を解決した。", "translation": "Doraemon solved the problem to some extent."},
     {"word": "do ～ good", "meaning": "～のためになる", "example": "ドラえもんは、運動をすると体によいと知っている。", "translation": "Doraemon knows that exercise does him good."},
     {"word": "make the best of ～", "meaning": "～を最大限に活かす", "example": "ドラえもんは、与えられた道具を最大限に活かした。", "translation": "Doraemon made the best of the gadgets he was given."},
     {"word": "be about to …", "meaning": "まさに～しようとしている", "example": "ドラえもんは、まさに未来へ出発しようとしていた。", "translation": "Doraemon was about to depart for the future."},
     {"word": "persuade A not to …", "meaning": "Aに～しないように説得する", "example": "ドラえもんは、のび太に悪いことをしないように説得した。", "translation": "Doraemon persuaded Nobita not to do bad things."},
     {"word": "find out ～", "meaning": "～を見つける", "example": "ドラえもんは、本当の犯人を見つけた。", "translation": "Doraemon found out who the real criminal was."},
     {"word": "seek to …", "meaning": "～しようと努める", "example": "ドラえもんは、問題を解決しようと努めた。", "translation": "Doraemon sought to solve the problem."},
     {"word": "by way of ～", "meaning": "～として", "example": "ドラえもんは、お礼として、どら焼きをあげた。", "translation": "Doraemon gave a dorayaki as a way of saying thanks."},
     {"word": "in favor of ～", "meaning": "～を支持して", "example": "ドラえもんは、のび太の意見を支持した。", "translation": "Doraemon sided with Nobita's opinion in favor of it."}
     ];
     break;
     case "高校英語7":
     item = [
     {"word": "hold ～ back", "meaning": "～を阻止する", "example": "ドラえもんは、敵の進撃を阻止した。", "translation": "Doraemon held back the enemy's advance."},
     {"word": "no less than ～", "meaning": "～に劣らず", "example": "ドラえもんは、のび太に劣らず優しい。", "translation": "Doraemon is no less kind than Nobita."},
     {"word": "break out", "meaning": "発生する", "example": "事件が突然発生した。", "translation": "An incident broke out suddenly."},
     {"word": "make do with ～", "meaning": "～で間に合わせる", "example": "ドラえもんは、あるもので間に合わせた。", "translation": "Doraemon made do with what he had."},
     {"word": "apply for ～", "meaning": "～に申し込む", "example": "ドラえもんは、新しい仕事に応募した。", "translation": "Doraemon applied for a new job."},
     {"word": "out loud", "meaning": "声に出して", "example": "ドラえもんは、秘密を声に出して言ってしまった。", "translation": "Doraemon said the secret out loud."},
     {"word": "except for ～", "meaning": "～を除いて", "example": "ドラえもんは、どら焼きを除いて、何でも食べる。", "translation": "Doraemon eats anything except for dorayaki."},
     {"word": "regardless of ～", "meaning": "～に関わらず", "example": "ドラえもんは、どんな状況に関わらず、諦めない。", "translation": "Regardless of the situation, Doraemon never gives up."},
     {"word": "be going to …", "meaning": "～する予定だ", "example": "ドラえもんは、明日、買い物に行く予定だ。", "translation": "Doraemon is going to go shopping tomorrow."},
     {"word": "in charge of ～", "meaning": "～を担当している", "example": "ドラえもんは、みんなの安全を担当している。", "translation": "Doraemon is in charge of everyone's safety."}
     ];
     break;
     case "高校英熟語8":
     item = [
     {"word": "before long", "meaning": "まもなく", "example": "ドラえもんは、まもなく帰ってくるだろう。", "translation": "Doraemon will return before long."},
     {"word": "in short", "meaning": "要するに", "example": "ドラえもんは、要するに、それは良いことだと言った。", "translation": "In short, Doraemon said it is a good thing."},
     {"word": "at large", "meaning": "逃走中の", "example": "ドラえもんは、逃走中の泥棒を追った。", "translation": "Doraemon chased after the thief at large."},
     {"word": "be apt to …", "meaning": "～しがちである", "example": "のび太は、遅刻しがちだ。", "translation": "Nobita is apt to be late."},
     {"word": "be made up of ～", "meaning": "～から構成されている", "example": "ドラえもんの体は、多くの部品から構成されている。", "translation": "Doraemon's body is made up of many parts."},
     {"word": "at present", "meaning": "現在", "example": "ドラえもんは、現在の状況を分析した。", "translation": "Doraemon analyzed the situation at present."},
     {"word": "for the time being", "meaning": "当分の間", "example": "ドラえもんは、当分の間、ここで休むことにした。", "translation": "Doraemon decided to rest here for the time being."},
     {"word": "No matter how ～", "meaning": "どんなに～でも", "example": "ドラえもんは、どんなに困難でも諦めない。", "translation": "No matter how difficult it is, Doraemon will not give up."},
     {"word": "as follows", "meaning": "以下の通り", "example": "ドラえもんは、次の通り説明を始めた。", "translation": "Doraemon began his explanation as follows."},
     {"word": "resort to ～", "meaning": "～に頼る", "example": "ドラえもんは、最後の手段として、その道具に頼った。", "translation": "Doraemon resorted to the gadget as a last resort."}
     ];
     break;
     case "高校英熟語9":
     item = [
     {"word": "give birth to ～", "meaning": "～を生み出す", "example": "ドラえもんは、新しい道具を生み出した。", "translation": "Doraemon gave birth to a new gadget."},
     {"word": "be likely to …", "meaning": "～しそうである", "example": "のび太は、また失敗しそうだ。", "translation": "Nobita is likely to fail again."},
     {"word": "be concerned with ～", "meaning": "～に関心がある", "example": "ドラえもんは、環境問題に関心がある。", "translation": "Doraemon is concerned with environmental issues."},
     {"word": "out of order", "meaning": "故障して", "example": "ドラえもんの道具が故障してしまった。", "translation": "Doraemon's gadget went out of order."},
     {"word": "rely on ～", "meaning": "～に頼る", "example": "のび太は、いつもドラえもんに頼っている。", "translation": "Nobita always relies on Doraemon."},
     {"word": "keep A from B", "meaning": "AがBするのを妨げる", "example": "ドラえもんは、のび太が悪いことをするのを妨げる。", "translation": "Doraemon keeps Nobita from doing bad things."},
     {"word": "account for ～", "meaning": "～を説明する", "example": "ドラえもんは、その出来事を説明した。", "translation": "Doraemon accounted for what happened."},
     {"word": "result from ～", "meaning": "～から生じる", "example": "この問題は、小さな誤解から生じた。", "translation": "This problem resulted from a small misunderstanding."},
     {"word": "fail to …", "meaning": "～することを怠る", "example": "のび太は、いつも宿題をすることを怠る。", "translation": "Nobita always fails to do his homework."},
     {"word": "be familiar with ～", "meaning": "～について詳しい", "example": "ドラえもんは、未来の技術について詳しい。", "translation": "Doraemon is familiar with future technology."}
     ];
     break;
     case "高校英熟語10":
     item = [
     {"word": "in common (with ～)", "meaning": "（～と）共通して", "example": "ドラえもんは、のび太と共通の趣味がある。", "translation": "Doraemon has a hobby in common with Nobita."},
     {"word": "cling to ～", "meaning": "～にしがみつく", "example": "ドラえもんは、ロープにしがみついた。", "translation": "Doraemon clung to the rope."},
     {"word": "in brief", "meaning": "手短に言うと", "example": "ドラえもんは、手短に状況を説明した。", "translation": "In brief, Doraemon explained the situation."},
     {"word": "no more A than B", "meaning": "Bと同様にAも～ない", "example": "のび太は、ジャイアンと同じように運動が得意ではない。", "translation": "Nobita is no more athletic than Gian."},
     {"word": "from ～ on", "meaning": "～から", "example": "ドラえもんは、今日からもっと頑張ると言った。", "translation": "Doraemon said he will try harder from today on."},
     {"word": "the last ～ to …", "meaning": "最も～しそうもない～", "example": "のび太は、最も勉強しそうもない人だ。", "translation": "Nobita is the last person to study."},
     {"word": "with respect to ～", "meaning": "～に関して", "example": "ドラえもんは、道具の使用方法に関して説明した。", "translation": "Doraemon explained with respect to how to use the gadgets."},
     {"word": "make out ～", "meaning": "～を理解する", "example": "ドラえもんは、難しいことをやっと理解した。", "translation": "Doraemon finally made out the difficult thing."},
     {"word": "be superior to ～", "meaning": "～より優れている", "example": "ドラえもんは、他のロボットよりも性能が優れている。", "translation": "Doraemon is superior to other robots in terms of performance."},
     {"word": "result in ～", "meaning": "～という結果になる", "example": "ドラえもんの行動は、良い結果を生んだ。", "translation": "Doraemon's action resulted in a good outcome."}
     ];
     break;
    
     
     case "高校英熟語11":
     item = [
     {"word": "consist of ～", "meaning": "～から構成される", "example": "ドラえもんの体は、多くの部品から構成されている。", "translation": "Doraemon's body consists of many parts."},
     {"word": "hope for ～", "meaning": "～を望む", "example": "ドラえもんは、のび太の成長を望んでいる。", "translation": "Doraemon hopes for Nobita's growth."},
     {"word": "over and over", "meaning": "何度も", "example": "のび太は、同じ失敗を何度も繰り返した。", "translation": "Nobita made the same mistake over and over."},
     {"word": "at the latest", "meaning": "遅くとも", "example": "ドラえもんは、「遅くとも明日までには返してね」と言った。", "translation": "Doraemon said, 'Return it by tomorrow at the latest'."},
     {"word": "deprive A of B", "meaning": "AからBを奪う", "example": "ドラえもんは、のび太から夢を奪うことは決してない。", "translation": "Doraemon never deprives Nobita of his dreams."},
     {"word": "would rather A (than B)", "meaning": "BよりAの方が好きだ", "example": "ドラえもんは、あんこよりもどら焼きの方が好きだ。", "translation": "Doraemon would rather have dorayaki than anko."},
     {"word": "be due to …", "meaning": "～が原因である", "example": "のび太の遅刻は、寝坊が原因である。", "translation": "Nobita being late is due to oversleeping."},
     {"word": "none the less", "meaning": "それにもかかわらず", "example": "ドラえもんは、大変だったが、それでもやり遂げた。", "translation": "Doraemon had a hard time but did it none the less."},
     {"word": "bring about ～", "meaning": "～を引き起こす", "example": "ドラえもんは、良い結果を引き起こした。", "translation": "Doraemon brought about a good result."},
     {"word": "in conclusion", "meaning": "結論として", "example": "ドラえもんは、結論として、こう言うしかないと言った。", "translation": "In conclusion, Doraemon said there's no other way."}
     ,{"word": "rob A of B", "meaning": "AからBを奪う", "example": "ドラえもんは、泥棒が町の人からお金を奪うのを防いだ。", "translation": "Doraemon prevented a thief from robbing the townspeople of their money."}
     ];
     break;
     case "高校英熟語12":
     item = [
     {"word": "ahead of ～", "meaning": "～よりも先に", "example": "ドラえもんは、のび太よりも先に行った。", "translation": "Doraemon went ahead of Nobita."},
     {"word": "think much of ～", "meaning": "～を重視する", "example": "ドラえもんは、友達をとても大切に思っている。", "translation": "Doraemon thinks much of his friends."},
     {"word": "close to ～", "meaning": "～に近い", "example": "ドラえもんは、のび太の家に近いところに住んでいる。", "translation": "Doraemon lives close to Nobita's house."},
     {"word": "keep away from ～", "meaning": "～に近づかない", "example": "ドラえもんは、危険な場所には近づかない。", "translation": "Doraemon keeps away from dangerous places."},
     {"word": "be related to ～", "meaning": "～と関係がある", "example": "ドラえもんの道具は、未来の技術と関係がある。", "translation": "Doraemon's gadgets are related to future technology."},
     {"word": "hundreds of ～", "meaning": "何百もの～", "example": "ドラえもんは、何百もの秘密道具を持っている。", "translation": "Doraemon has hundreds of secret gadgets."},
     {"word": "not to say ～", "meaning": "～とは言わないまでも", "example": "ドラえもんは、完璧とは言わないまでも、良いロボットだ。", "translation": "Not to say he's perfect, Doraemon is a good robot."},
     {"word": "fall asleep", "meaning": "眠ってしまう", "example": "のび太は、すぐに眠ってしまう。", "translation": "Nobita always falls asleep immediately."},
     {"word": "at the sight of ～", "meaning": "～を見ると", "example": "ドラえもんは、ネズミを見ると怖がる。", "translation": "Doraemon is afraid at the sight of mice."},
     {"word": "in spite of ～", "meaning": "～にもかかわらず", "example": "ドラえもんは、困難にもかかわらず諦めない。", "translation": "Doraemon doesn't give up in spite of the difficulties."}
     ];
     break;
     case "高校英熟語13":
     item = [
     {"word": "blame A for B", "meaning": "AをBのことで責める", "example": "ジャイアンは、のび太をいつも失敗のことで責める。", "translation": "Gian always blames Nobita for his mistakes."},
     {"word": "in detail", "meaning": "詳細に", "example": "ドラえもんは、問題を詳細に説明した。", "translation": "Doraemon explained the problem in detail."},
     {"word": "to make matters worse", "meaning": "さらに悪いことに", "example": "さらに悪いことに、雨まで降ってきた。", "translation": "To make matters worse, it started raining."},
     {"word": "by no means ～", "meaning": "決して～ない", "example": "ドラえもんは、決して嘘をつかない。", "translation": "Doraemon is by no means a liar."},
     {"word": "owe A to B", "meaning": "AはBのおかげである", "example": "のび太は、今の自分がいるのはドラえもんのおかげだと思っている。", "translation": "Nobita thinks he owes his current self to Doraemon."},
     {"word": "if any", "meaning": "もしあれば", "example": "ドラえもんは、もし何か困ったことがあれば言ってねと言った。", "translation": "Doraemon said, 'Tell me if any problems arise'."},
     {"word": "pass away", "meaning": "亡くなる", "example": "ドラえもんは、昔の友達が亡くなったのを知り悲しんだ。", "translation": "Doraemon was sad to hear that his friend from the past had passed away."},
     {"word": "as soon as possible", "meaning": "できるだけ早く", "example": "ドラえもんは、できるだけ早く問題を解決したかった。", "translation": "Doraemon wanted to solve the problem as soon as possible."},
     {"word": "derive A from B", "meaning": "AをBから得る", "example": "ドラえもんは、未来の知識を本から得ている。", "translation": "Doraemon derives his knowledge from books from the future."},
     {"word": "nothing but ～", "meaning": "～にすぎない", "example": "のび太は、宿題をするのが嫌いなだけの子供にすぎない。", "translation": "Nobita is nothing but a kid who dislikes doing homework."}
     ];
     break;
     case "高校英熟語14":
     item = [
     {"word": "but for ～", "meaning": "～がなければ", "example": "ドラえもんがいなければ、のび太は困っていた。", "translation": "But for Doraemon, Nobita would have been in trouble."},
     {"word": "in terms of ～", "meaning": "～の観点から", "example": "ドラえもんは、科学の観点から問題を考えた。", "translation": "Doraemon thought about the problem in terms of science."},
     {"word": "come about", "meaning": "起こる", "example": "ドラえもんは、なぜこの出来事が起こったのかを調べた。", "translation": "Doraemon investigated how this incident came about."},
     {"word": "search for ～", "meaning": "～を探す", "example": "ドラえもんは、宝物を探しに行った。", "translation": "Doraemon went to search for treasure."},
     {"word": "fall in love with ～", "meaning": "～に恋をする", "example": "のび太は、しずかちゃんに恋をしている。", "translation": "Nobita is in love with Shizuka."},
     {"word": "be equal to ～", "meaning": "～に等しい", "example": "ドラえもんは、誰に対しても平等だ。", "translation": "Doraemon is equal to everyone."},
     {"word": "if anything", "meaning": "どちらかといえば", "example": "ドラえもんは、どちらかといえば優しい。", "translation": "If anything, Doraemon is kind."},
     {"word": "to say nothing of ～", "meaning": "～は言うまでもなく", "example": "ドラえもんは、性能は言うまでもなく、見た目も素晴らしい。", "translation": "To say nothing of the performance, Doraemon's gadgets also have a wonderful design."},
     {"word": "by virtue of ～", "meaning": "～のおかげで", "example": "ドラえもんは、道具のおかげで問題を解決できた。", "translation": "Doraemon was able to solve the problem by virtue of his gadgets."},
     {"word": "make sense", "meaning": "意味をなす", "example": "ドラえもんは、その説明が理にかなっていると言った。", "translation": "Doraemon said that explanation makes sense."}
     ];
     break;
     case "高校英熟語15":
     item = [
     {"word": "pay attention to ～", "meaning": "～に注意を払う", "example": "ドラえもんは、周囲の音に注意を払った。", "translation": "Doraemon paid attention to the sounds around him."},
     {"word": "all at once", "meaning": "同時に", "example": "ドラえもんは、道具を全て同時に使った。", "translation": "Doraemon used all his gadgets all at once."},
     {"word": "in exchange for ～", "meaning": "～と引き換えに", "example": "ドラえもんは、道具とどら焼きを引き換えた。", "translation": "Doraemon exchanged a gadget in exchange for a dorayaki."},
     {"word": "cope with ～", "meaning": "～に対処する", "example": "ドラえもんは、困難な状況にも対処した。", "translation": "Doraemon coped with the difficult situation."},
     {"word": "object to ～", "meaning": "～に反対する", "example": "ドラえもんは、暴力的な行いに反対した。", "translation": "Doraemon objected to violent behavior."},
     {"word": "in the long run", "meaning": "長期的には", "example": "ドラえもんは、長期的にはそれが良い結果につながると言った。", "translation": "Doraemon said that in the long run it would lead to a good result."},
     {"word": "second to none", "meaning": "誰にも劣らない", "example": "ドラえもんは、料理の腕は誰にも劣らない。", "translation": "Doraemon's cooking skills are second to none."},
     {"word": "in any case", "meaning": "いずれにせよ", "example": "ドラえもんは、「いずれにせよ、助ける」と言った。", "translation": "Doraemon said, 'In any case, I will help you'."},
     {"word": "from ～ point of view", "meaning": "～の観点から", "example": "ドラえもんは、のび太の観点から考えてみた。", "translation": "Doraemon thought about the problem from Nobita's point of view."},
     {"word": "keep off ～", "meaning": "～に近づかない", "example": "ドラえもんは、危険な場所に近づかないようにと言った。", "translation": "Doraemon said to keep off dangerous places."}
     ];
     break;
     case "高校英熟語16":
     item = [
     {"word": "at a loss", "meaning": "途方に暮れて", "example": "ドラえもんは、どうすれば良いのか途方に暮れてしまった。", "translation": "Doraemon was at a loss about what to do."},
     {"word": "to some extent", "meaning": "ある程度", "example": "ドラえもんは、ある程度問題を解決できた。", "translation": "Doraemon was able to solve the problem to some extent."},
     {"word": "do ～ good", "meaning": "～のためになる", "example": "ドラえもんは、運動することが体のためになると知っている。", "translation": "Doraemon knows that exercise does his body good."},
     {"word": "make the best of ～", "meaning": "～を最大限に活かす", "example": "ドラえもんは、どんな状況でも最大限に活用した。", "translation": "Doraemon made the best of any situation."},
     {"word": "be about to …", "meaning": "まさに～しようとしている", "example": "ドラえもんは、まさに未来へ行こうとしていた。", "translation": "Doraemon was about to go to the future."},
     {"word": "persuade A not to …", "meaning": "Aに～しないように説得する", "example": "ドラえもんは、のび太に悪いことをしないように説得した。", "translation": "Doraemon persuaded Nobita not to do bad things."},
     {"word": "find out ～", "meaning": "～を見つけ出す", "example": "ドラえもんは、事件の真相を見つけ出した。", "translation": "Doraemon found out the truth of the incident."},
     {"word": "seek to …", "meaning": "～しようと努める", "example": "ドラえもんは、問題を解決しようと努めた。", "translation": "Doraemon sought to solve the problem."},
     {"word": "by way of ～", "meaning": "～として", "example": "ドラえもんは、お礼としてお菓子をあげた。", "translation": "Doraemon gave him a snack by way of thanks."},
     {"word": "in favor of ～", "meaning": "～を支持して", "example": "ドラえもんは、のび太の提案を支持した。", "translation": "Doraemon was in favor of Nobita's plan."}
     ];
     break;
     case "高校英熟語17":
     item = [
     {"word": "as for ～", "meaning": "～について言えば", "example": "ドラえもんについて言えば、とても優しいロボットだ。", "translation": "As for Doraemon, he is a very kind robot."},
     {"word": "keep up with ～", "meaning": "～についていく", "example": "のび太は、ドラえもんに何とかついて行こうとしている。", "translation": "Nobita is trying to keep up with Doraemon somehow."},
     {"word": "by accident", "meaning": "偶然に", "example": "ドラえもんは、偶然に宝物を見つけた。", "translation": "Doraemon found the treasure by accident."},
     {"word": "off duty", "meaning": "勤務時間外の", "example": "ドラえもんは、勤務時間外は自由に過ごしている。", "translation": "Doraemon spends his time freely off duty."},
     {"word": "generally speaking", "meaning": "一般的に言って", "example": "一般的に言って、ドラえもんは優しいロボットだ。", "translation": "Generally speaking, Doraemon is a kind robot."},
     {"word": "in the way", "meaning": "邪魔になって", "example": "ドラえもんは、邪魔にならないようにどいた。", "translation": "Doraemon moved so as not to be in the way."},
     {"word": "along with ～", "meaning": "～と一緒に", "example": "ドラえもんは、のび太と一緒に遊んだ。", "translation": "Doraemon played along with Nobita."},
     {"word": "to tell the truth", "meaning": "実を言うと", "example": "ドラえもんは、「実を言うと、僕もわからない」と言った。", "translation": "To tell the truth, Doraemon said, 'I don't know either'."},
     {"word": "come across ～", "meaning": "～に偶然出会う", "example": "ドラえもんは、偶然に昔の友達と出会った。", "translation": "Doraemon came across his friend from the past by accident."},
     {"word": "on account of ～", "meaning": "～が理由で", "example": "ドラえもんは、風邪のせいで学校を休んだ。", "translation": "Doraemon was absent from school on account of a cold."}
     ];
     break;
     case "高校英熟語18":
     item = [
     {"word": "be independent of ～", "meaning": "～から独立している", "example": "ドラえもんは、のび太の言うことにいつも従うわけではない。", "translation": "Doraemon is independent of Nobita's instructions."},
     {"word": "show up", "meaning": "現れる", "example": "ドラえもんは、困った時にいつも現れる。", "translation": "Doraemon always shows up when Nobita is in trouble."},
     {"word": "impose A on B", "meaning": "BにAを押し付ける", "example": "ドラえもんは、誰にも自分の意見を押し付けない。", "translation": "Doraemon does not impose his opinion on anyone."},
     {"word": "point out ～", "meaning": "～を指摘する", "example": "ドラえもんは、間違いを指摘してくれた。", "translation": "Doraemon pointed out the mistake."},
     {"word": "be sure to …", "meaning": "必ず～する", "example": "ドラえもんは、明日はきっと助けに来ると言った。", "translation": "Doraemon said that he would be sure to come help him tomorrow."},
     {"word": "translate A into B", "meaning": "AをBに翻訳する", "example": "ドラえもんは、古代の文字を翻訳した。", "translation": "Doraemon translated the ancient script."},
     {"word": "give rise to ～", "meaning": "～を引き起こす", "example": "ドラえもんは、新しい問題を引き起こした。", "translation": "Doraemon gave rise to a new problem."},
     {"word": "as such", "meaning": "それ自体", "example": "ドラえもんは、それ自体は悪いことではないと言った。", "translation": "Doraemon said that in itself it was not a bad thing."},
     {"word": "do ～ harm", "meaning": "～に害を及ぼす", "example": "ドラえもんは、環境に害を及ぼすことをしない。", "translation": "Doraemon does not do anything that would do harm to the environment."},
     {"word": "turn on ～", "meaning": "～をつける", "example": "ドラえもんは、テレビをつけた。", "translation": "Doraemon turned on the TV."},
     {"word": "in turn", "meaning": "順番に", "example": "ドラえもんは、順番にみんなに道具を貸した。", "translation": "Doraemon lent the gadgets to everyone in turn."}
     ];
     break;
     case "高校英熟語19":
     item = [
     {"word": "side by side", "meaning": "並んで", "example": "ドラえもんとのび太は、いつも並んで歩いている。", "translation": "Doraemon and Nobita are always walking side by side."},
     {"word": "at the expense of ～", "meaning": "～を犠牲にして", "example": "ドラえもんは、自分を犠牲にして、のび太を助けた。", "translation": "Doraemon helped Nobita at the expense of himself."},
     {"word": "make up for ～", "meaning": "～を埋め合わせる", "example": "ドラえもんは、失敗を挽回しようとした。", "translation": "Doraemon tried to make up for his mistake."},
     {"word": "be something of a ～", "meaning": "どちらかというと～である", "example": "ドラえもんは、どちらかというと世話焼きである。", "translation": "Doraemon is something of a busybody."},
     {"word": "in force", "meaning": "有効で", "example": "ドラえもんは、法律が有効であることを確かめた。", "translation": "Doraemon confirmed that the law is still in force."},
     {"word": "prefer A to B", "meaning": "BよりAを好む", "example": "ドラえもんは、アンコよりもどら焼きを好む。", "translation": "Doraemon prefers dorayaki to anko."},
     {"word": "blame A on B", "meaning": "AをBのせいにする", "example": "ジャイアンは、いつも自分の失敗をのび太のせいにする。", "translation": "Gian always blames his mistakes on Nobita."},
     {"word": "get in ～", "meaning": "～に入る", "example": "ドラえもんは、車の中に入った。", "translation": "Doraemon got in the car."},
     {"word": "as a result", "meaning": "結果として", "example": "ドラえもんが助けた結果、のび太は成功した。", "translation": "As a result of Doraemon's help, Nobita succeeded."},
     {"word": "correspond to ～", "meaning": "～に対応する", "example": "ドラえもんの言葉は、のび太の気持ちに対応していた。", "translation": "Doraemon's words corresponded to Nobita's feelings."}
     ];
     break;
     case "高校英熟語20":
     item = [
     {"word": "in a hurry", "meaning": "急いで", "example": "ドラえもんは、急いで出かけた。", "translation": "Doraemon left in a hurry."},
     {"word": "so to speak", "meaning": "いわば", "example": "ドラえもんは、いわば未来のロボットだ。", "translation": "Doraemon is so to speak, a robot from the future."},
     {"word": "be engaged to ～", "meaning": "～と婚約している", "example": "ドラえもんは、結婚を控えた友達を祝福した。", "translation": "Doraemon congratulated his friend who was engaged to be married."},
     {"word": "turn out ～", "meaning": "～を明らかにする", "example": "ドラえもんは、事件の真相を明らかにした。", "translation": "Doraemon turned out the truth of the incident."},
     {"word": "do away with ～", "meaning": "～を廃止する", "example": "ドラえもんは、不必要なルールを廃止した。", "translation": "Doraemon did away with the unnecessary rules."},
     {"word": "owing to ～", "meaning": "～が原因で", "example": "ドラえもんは、雨が降ったせいで家に帰った。", "translation": "Doraemon went home owing to the rain."},
     {"word": "prevent A from ～ing", "meaning": "Aが～するのを妨げる", "example": "ドラえもんは、のび太が悪いことをするのを妨げた。", "translation": "Doraemon prevented Nobita from doing bad things."},
     {"word": "with regard to ～", "meaning": "～に関して", "example": "ドラえもんは、時間に関して話した。", "translation": "Doraemon talked with regard to time."},
     {"word": "know better than to …", "meaning": "～するほど愚かではない", "example": "ドラえもんは、火を遊びで使うほど愚かではない。", "translation": "Doraemon knows better than to play with fire."},
     {"word": "begin with", "meaning": "～から始める", "example": "ドラえもんは、挨拶から始めた。", "translation": "Doraemon began with a greeting."}
     ];
     break;
    
     
     case "高校英熟語21":
     item = [
     {"word": "be fit for ～", "meaning": "～に適している", "example": "ドラえもんは、のび太の友達に適している。", "translation": "Doraemon is fit for being Nobita's friend."},
     {"word": "in vain", "meaning": "無駄に", "example": "ドラえもんは、無駄な努力はしない。", "translation": "Doraemon does not make efforts in vain."},
     {"word": "by chance", "meaning": "偶然に", "example": "ドラえもんは、偶然、過去の友達に会った。", "translation": "Doraemon met his friend from the past by chance."},
     {"word": "run across ～", "meaning": "～に偶然出会う", "example": "ドラえもんは、旅先で昔の友達に偶然出会った。", "translation": "Doraemon ran across an old friend during his journey."},
     {"word": "in a row", "meaning": "連続して", "example": "のび太は、テストで3回連続で0点を取った。", "translation": "Nobita got zero points on the tests three times in a row."},
     {"word": "sooner or later", "meaning": "遅かれ早かれ", "example": "ドラえもんは、「遅かれ早かれ、必ず解決する」と言った。", "translation": "Doraemon said, 'Sooner or later, it will be resolved'."},
     {"word": "all of a sudden", "meaning": "突然", "example": "ドラえもんは、突然姿を消した。", "translation": "Doraemon disappeared all of a sudden."},
     {"word": "give in", "meaning": "屈服する", "example": "ドラえもんは、悪の力に屈服しなかった。", "translation": "Doraemon did not give in to the power of evil."},
     {"word": "be satisfied with ～", "meaning": "～に満足する", "example": "ドラえもんは、どら焼きを食べて満足した。", "translation": "Doraemon was satisfied with eating his dorayaki."},
     {"word": "manage to …", "meaning": "何とか～する", "example": "ドラえもんは、なんとか問題を解決した。", "translation": "Doraemon managed to solve the problem."}
     ];
     break;
     case "高校英熟語22":
     item = [
     {"word": "call for ～", "meaning": "～を必要とする", "example": "この問題解決には、協力が必要だ。", "translation": "Solving this problem calls for cooperation."},
     {"word": "first of all", "meaning": "まず第一に", "example": "ドラえもんは、まず第一に、安全を確保した。", "translation": "First of all, Doraemon ensured everyone's safety."},
     {"word": "inform A of B", "meaning": "AにBを知らせる", "example": "ドラえもんは、のび太に危険を知らせた。", "translation": "Doraemon informed Nobita of the danger."},
     {"word": "at best", "meaning": "せいぜい", "example": "のび太は、せいぜい50点しか取れないだろう。", "translation": "At best, Nobita will only get a score of 50."},
     {"word": "laugh at ～", "meaning": "～を笑う", "example": "ジャイアンは、のび太を笑った。", "translation": "Gian laughed at Nobita."},
     {"word": "under ～ circumstances", "meaning": "～の状況下で", "example": "ドラえもんは、どんな状況下でも最善を尽くす。", "translation": "Doraemon always does his best under any circumstances."},
     {"word": "blow up", "meaning": "爆発する", "example": "ドラえもんは、爆弾が爆発しないように気をつけた。", "translation": "Doraemon was careful not to let the bomb blow up."},
     {"word": "on and off", "meaning": "断続的に", "example": "ドラえもんは、雨が降ったり止んだりする天気を心配した。", "translation": "Doraemon was worried about the on and off rain."},
     {"word": "get lost", "meaning": "道に迷う", "example": "のび太は、また道に迷ってしまった。", "translation": "Nobita got lost again."},
     {"word": "as a matter of fact", "meaning": "実際のところ", "example": "ドラえもんは、実を言うと、疲れていると言った。", "translation": "As a matter of fact, Doraemon said he is tired."}
     ];
     break;
     case "高校英熟語23":
     item = [
     {"word": "get over ～", "meaning": "～を克服する", "example": "ドラえもんは、困難を克服した。", "translation": "Doraemon got over the hardship."},
     {"word": "be bound to …", "meaning": "必ず～する", "example": "ドラえもんは、いつか未来に帰るだろう。", "translation": "Doraemon is bound to return to the future someday."},
     {"word": "in honor of ～", "meaning": "～を記念して", "example": "ドラえもんは、記念イベントに参加した。", "translation": "Doraemon participated in an event in honor of the anniversary."},
     {"word": "call ～ off", "meaning": "～を中止する", "example": "ドラえもんは、悪天候のため計画を中止した。", "translation": "Doraemon called off the plan because of bad weather."},
     {"word": "prove A (to be) B", "meaning": "AがBであると証明する", "example": "ドラえもんは、自分が正しいことを証明した。", "translation": "Doraemon proved himself to be correct."},
     {"word": "go on ～ing", "meaning": "～し続ける", "example": "ドラえもんは、のび太を助け続けた。", "translation": "Doraemon went on helping Nobita."},
     {"word": "under construction", "meaning": "建設中の", "example": "ドラえもんは、建設中の建物に近づかないようにした。", "translation": "Doraemon tried not to get close to the building under construction."},
     {"word": "ask for ～", "meaning": "～を求める", "example": "のび太は、ドラえもんに助けを求めた。", "translation": "Nobita asked Doraemon for help."},
     {"word": "come along", "meaning": "一緒に行く", "example": "ドラえもんは、のび太に「一緒に行こう」と誘った。", "translation": "Doraemon invited Nobita to come along with him."},
     {"word": "insist on ～", "meaning": "～を主張する", "example": "ドラえもんは、自分の意見を主張した。", "translation": "Doraemon insisted on his opinion."}
     ];
     break;
     case "高校英熟語24":
     item = [
     {"word": "stand by ～", "meaning": "～を支持する", "example": "ドラえもんは、いつも友達を支持する。", "translation": "Doraemon always stands by his friends."},
     {"word": "be free from ～", "meaning": "～がない", "example": "ドラえもんは、病気がない。", "translation": "Doraemon is free from sickness."},
     {"word": "call on ～", "meaning": "～を訪問する", "example": "ドラえもんは、昔の友達を訪問した。", "translation": "Doraemon called on his friend from the past."},
     {"word": "had better …", "meaning": "～した方が良い", "example": "ドラえもんは、「宿題はした方が良い」と言った。", "translation": "Doraemon said, 'You had better do your homework'."},
     {"word": "apply to ～", "meaning": "～に当てはまる", "example": "このルールは、みんなに当てはまる。", "translation": "This rule applies to everyone."},
     {"word": "provide A with B", "meaning": "AにBを提供する", "example": "ドラえもんは、のび太に秘密道具を提供した。", "translation": "Doraemon provided Nobita with a secret gadget."},
     {"word": "count on ～", "meaning": "～を頼りにする", "example": "のび太は、いつもドラえもんを頼りにしている。", "translation": "Nobita always counts on Doraemon."},
     {"word": "in a sense", "meaning": "ある意味で", "example": "ドラえもんは、「ある意味で、それは正しい」と言った。", "translation": "Doraemon said, 'In a sense, that's right'."},
     {"word": "differ from ～", "meaning": "～と異なる", "example": "ドラえもんと、のび太は考え方が異なる。", "translation": "Doraemon differs from Nobita in his way of thinking."},
     {"word": "mean to …", "meaning": "～するつもりだ", "example": "ドラえもんは、未来へ行くつもりだ。", "translation": "Doraemon means to go to the future."}
     ];
     break;
     case "高校英熟語25":
     item = [
     {"word": "get rid of ～", "meaning": "～を取り除く", "example": "ドラえもんは、悪を全て取り除こうとした。", "translation": "Doraemon tried to get rid of all the evil in the world."},
     {"word": "in itself", "meaning": "それ自体", "example": "ドラえもんは、それ自体は悪いことではないと言った。", "translation": "Doraemon said that in itself it is not a bad thing."},
     {"word": "urge A to …", "meaning": "Aに～するように促す", "example": "ドラえもんは、のび太に勉強するように促した。", "translation": "Doraemon urged Nobita to study."},
     {"word": "get used to ～", "meaning": "～に慣れる", "example": "ドラえもんは、現代の生活に慣れた。", "translation": "Doraemon got used to living in the present."},
     {"word": "on behalf of ～", "meaning": "～の代わりに", "example": "ドラえもんは、のび太の代わりに謝った。", "translation": "Doraemon apologized on behalf of Nobita."},
     {"word": "what we call ～", "meaning": "いわゆる～", "example": "ドラえもんは、いわゆるタイムマシンを使った。", "translation": "Doraemon used what we call a time machine."},
     {"word": "for instance", "meaning": "例えば", "example": "ドラえもんは、例えば、こんな道具を使うと良いと言った。", "translation": "Doraemon said that you should use a gadget like this, for instance."},
     {"word": "at hand", "meaning": "手元に", "example": "ドラえもんは、いつも道具が手元にある。", "translation": "Doraemon always has his gadgets at hand."},
     {"word": "even if ～", "meaning": "たとえ～でも", "example": "ドラえもんは、たとえ困難でも諦めない。", "translation": "Even if it's difficult, Doraemon vowed that he wouldn't give up."},
     {"word": "at the mercy of ～", "meaning": "～のなすがままに", "example": "ドラえもんは、強風になすがままに吹き飛ばされた。", "translation": "Doraemon was blown away at the mercy of the strong wind."}
     ];
     break;
     case "高校英熟語26":
     item = [
     {"word": "as to ～", "meaning": "～について", "example": "ドラえもんは、のび太の将来について話した。", "translation": "Doraemon talked about Nobita's future as to his career."},
     {"word": "provide for ～", "meaning": "～を養う", "example": "ドラえもんは、みんなを養うのが好きだ。", "translation": "Doraemon likes to provide for everyone."},
     {"word": "to begin with", "meaning": "まず最初に", "example": "ドラえもんは、まず最初に自己紹介を始めた。", "translation": "Doraemon began with a self-introduction to start with."},
     {"word": "be similar to ～", "meaning": "～と似ている", "example": "ドラえもんは、猫に少し似ている。", "translation": "Doraemon is similar to a cat."},
     {"word": "stand out", "meaning": "目立つ", "example": "ドラえもんは、いつも目立っている。", "translation": "Doraemon always stands out."},
     {"word": "come up with ～", "meaning": "～を思いつく", "example": "ドラえもんは、素晴らしいアイデアを思いついた。", "translation": "Doraemon came up with a wonderful idea."},
     {"word": "by means of ～", "meaning": "～を使って", "example": "ドラえもんは、秘密道具を使って問題を解決した。", "translation": "Doraemon solved the problem by means of his secret gadget."},
     {"word": "It goes without saying that ～", "meaning": "～は言うまでもない", "example": "ドラえもんが優しいことは言うまでもない。", "translation": "It goes without saying that Doraemon is kind."},
     {"word": "wear out", "meaning": "すり減らす", "example": "のび太は、いつも道具をすぐすり減らしてしまう。", "translation": "Nobita always wears out his things easily."},
     {"word": "as if ～", "meaning": "まるで～のように", "example": "ドラえもんは、まるで魔法使いのように魔法を使った。", "translation": "Doraemon used magic as if he was a wizard."}
     ];
     break;
     case "高校英熟語27":
     item = [
     {"word": "in a while", "meaning": "しばらくして", "example": "ドラえもんは、しばらくしてから戻ってきた。", "translation": "Doraemon came back in a while."},
     {"word": "boast of ～", "meaning": "～を自慢する", "example": "ジャイアンは、自分の強さを自慢した。", "translation": "Gian boasted of his strength."},
     {"word": "dozens of ～", "meaning": "数十の～", "example": "ドラえもんは、数十の秘密道具を持っている。", "translation": "Doraemon has dozens of secret gadgets."},
     {"word": "all the way", "meaning": "はるばる", "example": "ドラえもんは、はるばる未来からやってきた。", "translation": "Doraemon came all the way from the future."},
     {"word": "learn ～ by heart", "meaning": "～を暗記する", "example": "ドラえもんは、大切なことを暗記した。", "translation": "Doraemon learned the important things by heart."},
     {"word": "be true to ～", "meaning": "～に忠実である", "example": "ドラえもんは、友達に忠実であろうとしている。", "translation": "Doraemon tries to be true to his friends."},
     {"word": "put off ～", "meaning": "～を延期する", "example": "ドラえもんは、予定を延期した。", "translation": "Doraemon put off his plans."},
     {"word": "cannot afford to …", "meaning": "～する余裕がない", "example": "ドラえもんは、無駄遣いをする余裕がない。", "translation": "Doraemon cannot afford to waste money."},
     {"word": "more or less", "meaning": "だいたい", "example": "ドラえもんは、だいたいの時間を伝えた。", "translation": "Doraemon told me the time more or less."},
     {"word": "on duty", "meaning": "勤務中で", "example": "ドラえもんは、勤務中だったので、遊びにいけなかった。", "translation": "Doraemon was on duty, so he couldn't go out to play."}
     ];
     break;
     case "高校英熟語28":
     item = [
     {"word": "be inferior to ～", "meaning": "～より劣っている", "example": "ドラえもんは、他のロボットより性能が劣っているわけではない。", "translation": "Doraemon is not inferior to other robots in terms of performance."},
     {"word": "succeed in ～", "meaning": "～に成功する", "example": "ドラえもんは、ミッションを成功させた。", "translation": "Doraemon succeeded in his mission."},
     {"word": "have nothing to do with ～", "meaning": "～と関係がない", "example": "ドラえもんの事件は、私とは関係ない。", "translation": "Doraemon's case has nothing to do with me."},
     {"word": "compare A to B", "meaning": "AをBに例える", "example": "ドラえもんは、のび太の才能をダイヤモンドに例えた。", "translation": "Doraemon compared Nobita's talent to a diamond."},
     {"word": "put up with ～", "meaning": "～に耐える", "example": "ドラえもんは、のび太のわがままにいつも耐えている。", "translation": "Doraemon always puts up with Nobita's selfishness."},
     {"word": "take ～ for granted", "meaning": "～を当然のことと思う", "example": "のび太は、ドラえもんが助けてくれることを当然だと思っている。", "translation": "Nobita takes it for granted that Doraemon will help him."},
     {"word": "cannot help ～ing", "meaning": "～せずにはいられない", "example": "のび太は、マンガを読まずにはいられない。", "translation": "Nobita cannot help reading manga."},
     {"word": "It is no use ～ing", "meaning": "～しても無駄だ", "example": "ドラえもんは、「今さら後悔しても無駄だ」と言った。", "translation": "Doraemon said, 'It is no use regretting now'."},
     {"word": "when it comes to ～", "meaning": "～のこととなると", "example": "ドラえもんは、料理のこととなるとすごい腕を発揮する。", "translation": "When it comes to cooking, Doraemon is very skilled."},
     {"word": "approve of ～", "meaning": "～を認める", "example": "ドラえもんは、のび太の勇気を認めた。", "translation": "Doraemon approved of Nobita's bravery."}
     ];
     break;
     case "高校英熟語29":
     item = [
     {"word": "as far as ～", "meaning": "～に関する限り", "example": "ドラえもんは、知っている限り、真実を話した。", "translation": "Doraemon spoke the truth as far as he knew."},
     {"word": "long for ～", "meaning": "～を切望する", "example": "ドラえもんは、平和な世界を切望している。", "translation": "Doraemon longs for a peaceful world."},
     {"word": "call at ～", "meaning": "～に立ち寄る", "example": "ドラえもんは、友達の家へ立ち寄った。", "translation": "Doraemon called at his friend's house."},
     {"word": "in accordance with ～", "meaning": "～に従って", "example": "ドラえもんは、ルールに従って行動した。", "translation": "Doraemon acted in accordance with the rules."},
     {"word": "be certain to …", "meaning": "必ず～する", "example": "ドラえもんは、明日は必ず晴れると言った。", "translation": "Doraemon said that it will be certain to be sunny tomorrow."},
     {"word": "in other words", "meaning": "言い換えれば", "example": "ドラえもんは、言い換えれば、それは良い道具だと言った。", "translation": "In other words, Doraemon said that it was a good gadget."},
     {"word": "succeed to ～", "meaning": "～を継承する", "example": "ドラえもんは、先代の意思を継承した。", "translation": "Doraemon succeeded to his predecessor's will."},
     {"word": "cure A of B", "meaning": "AのBを治す", "example": "ドラえもんは、のび太の風邪を治した。", "translation": "Doraemon cured Nobita of his cold."},
     {"word": "on occasion", "meaning": "時々", "example": "ドラえもんは、時々昔の出来事を思い出す。", "translation": "On occasion, Doraemon recalls events from the past."},
     {"word": "break down", "meaning": "故障する", "example": "ドラえもんの道具が急に故障してしまった。", "translation": "Doraemon's gadget broke down suddenly."}
     ];
     break;
     case "高校英熟語30":
     item = [
     {"word": "put up with ～", "meaning": "～に耐える", "example": "ドラえもんは、のび太のわがままに耐えている。", "translation": "Doraemon puts up with Nobita's selfishness."},
     {"word": "be typical of ～", "meaning": "～に典型的な", "example": "のび太は、典型的な小学生だ。", "translation": "Nobita is typical of an elementary school student."},
     {"word": "on purpose", "meaning": "わざと", "example": "ジャイアンは、わざとのび太の道具を壊した。", "translation": "Gian broke Nobita's gadget on purpose."},
     {"word": "be liable to …", "meaning": "～しがちである", "example": "のび太は、いつも失敗しがちだ。", "translation": "Nobita is liable to make mistakes."},
     {"word": "take ～ in", "meaning": "～を取り入れる", "example": "ドラえもんは、新しい技術を取り入れている。", "translation": "Doraemon is taking in new technology."},
     {"word": "compare A with B", "meaning": "AをBと比較する", "example": "ドラえもんは、昔と今を比較した。", "translation": "Doraemon compared the past with the present."},
     {"word": "be worth ～ing", "meaning": "～する価値がある", "example": "ドラえもんは、冒険をする価値があると言った。", "translation": "Doraemon said it's worth going on an adventure."}
     ,
     ];
     break;

     }


     }

}




//}
