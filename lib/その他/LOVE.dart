import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart' as ja;
import '../AdManager.dart';
import '../その他/mail.dart';
import 'package:timezone/timezone.dart' as tz;
import '../AdManager.dart';
import '../アカウント/SignUp.dart';

class LOVE extends StatefulWidget {

  @override
  State<LOVE> createState() => _LOVEState();
}
class _LOVEState extends State<LOVE> {

  var item = [];var map = {};var ID = "";var name = "";var startDate = "";var endDate = "";var text = "";
  var co = 0;
  get onEng => null;
  late TextEditingController _bodyController;
  var _scrollController = ScrollController();
  var StartTime = DateTime.now();var startBool = false;
  var EndTime = DateTime.now();var endBool = true;
  get myTimerProvider => null;
  late Timer timer;
  var time = "";
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  InterstitialAdManager interstitialAdManager = InterstitialAdManager();

  void initState() {
    super.initState();_bodyController = TextEditingController();
    first (); sign();
    appOpenAdManager.loadAd(); }

  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
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
    } else {print('Interstitial ad is not yet loaded.');}}
  @override
  FullScreenAdLoadErrorCallback get onAdFailedToLoad => throw UnimplementedError();
  @override
  GenericAdEventCallback<InterstitialAd> get onAdLoaded => throw UnimplementedError();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false, child:Scaffold(
        appBar: AppBar(backgroundColor: Colors.white,
          title: Text('',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 15),),
          elevation: 0,
          actions: <Widget>[IconButton(onPressed: () {if(startBool == true){attention();}else{Navigator.pop(context);}}, icon: Icon(Icons.highlight_off,size:30,color: Colors.blueGrey[800],))],
        ),
        body: GestureDetector( onTap: () => FocusScope.of(context).unfocus(),
          child:Container(color: Colors.white,
            child: Column(children: <Widget>[
              Expanded(
                child: ListView.builder(reverse: true,controller: _scrollController,itemCount: item.length, itemBuilder: (context, index) {
                  return Card(elevation:0,color:Colors.transparent,child: Container(margin: EdgeInsets.all(5),color: Colors.transparent,
                      child:Column(children: [
                        // Container(margin:EdgeInsets.all(5),width:double.infinity,alignment:Alignment.center,child: Text(item[index]["曜日"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white,fontSize: 15),),),
                        Container(child:item[index]["uid"] == "FAP3jZy3pSTEmqJQN1ow"|| item[index]["uid"] == "5k0Taw2GxH7TZyYH4wTM" ?Container(decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)), margin:EdgeInsets.only(left:0),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start,children:[
                            Container(alignment: Alignment.topLeft,margin:EdgeInsets.only(),width: 30, height:30, decoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle,),child: Text(" \n 開",softWrap: true,style: TextStyle(color:Colors.white,fontSize: 15,height: 0.7,letterSpacing: 2.5,),),),//image: DecorationImage(image:AssetImage("images/開発.PNG"), fit: BoxFit.cover,),),),
                            Flexible(child:Container(margin:EdgeInsets.only(left: 10),decoration: BoxDecoration(color: Colors.grey[200],borderRadius: BorderRadius.circular(10)),padding:EdgeInsets.all(10),child: Text(item[index]["メッセージ"],softWrap: true,style: TextStyle(color:Colors.black,fontSize: 15,height: 1.5,letterSpacing: 2,),))),
                            // Container(margin:EdgeInsets.only(left: 10,right: 10,top:10,bottom: 10),width: 40.0, height: 40.0, decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.fill, image: AssetImage("images/you.PNG"))),),
                            // Container(margin:EdgeInsets.only(right: 10,top:10,bottom: 10),child: Text(widget.name  + "様",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 15,height: 1.5,letterSpacing: 2,),),),
                            Column(children: [
                              Container(width: 80,alignment:Alignment.topLeft,margin:EdgeInsets.only(left: 10,top:10,bottom: 5,right: 0),child: Text(item[index]["日付"],style: TextStyle(color:Colors.black,fontSize: 7,height: 1.5,letterSpacing: 2,),)),
                              // Container(width: 80,alignment:Alignment.topLeft,margin:EdgeInsets.only(left: 10,top:0,bottom: 10,right: 0),child: Text("開発者",style: TextStyle(color:Colors.black,fontSize: 10,height: 1.5,letterSpacing: 2,),)),
                            ],) ,]),):
                        Container(decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)), margin:EdgeInsets.only(left:0),
                          child: Row(mainAxisAlignment:MainAxisAlignment.end, children:[
                            Container()
                            ,Container(width: 60,alignment:Alignment.bottomRight,margin:EdgeInsets.only(left: 10,top:10,bottom: 10,right: 10),child: Text(item[index]["日付"],style: TextStyle(color:Colors.black,fontSize: 7,height: 1.5,letterSpacing: 2,),maxLines: 2,)),
                            Flexible(child:Container(margin:EdgeInsets.only(right: 10),decoration: BoxDecoration(color: Colors.orange,borderRadius: BorderRadius.circular(10)),padding:EdgeInsets.all(10),child: Text(item[index]["メッセージ"],softWrap: true,style: TextStyle(color:Colors.black,fontSize: 15,height: 1.5,letterSpacing: 2,),))),
                            // Container(margin:EdgeInsets.only(left: 10,right: 10,top:10,bottom: 10),width: 40.0, height: 40.0, decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.fill, image: AssetImage("images/you.PNG"))),),
                            // Container(margin:EdgeInsets.only(right: 10,top:10,bottom: 10),child: Text(widget.name  + "様",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 15,height: 1.5,letterSpacing: 2,),),),
                          ],),)

                        )])));},),),
             // Container(height: 10,),
              Container(margin: EdgeInsets.only(bottom: 0),decoration: BoxDecoration(color: Colors.blueGrey[900], border: Border.all(color: Colors.blueGrey, width: 0),),
                  child:Column(children: [
                    Row(children: [
                      Expanded(child:Container(alignment: Alignment.center,margin:EdgeInsets.only(left: 40,top:10),child: Text("勉強",style: TextStyle(color:Colors.white,fontSize: 15,),))),
                      Container(margin:EdgeInsets.only(),child:IconButton(onPressed: () {mail();}, icon: Icon(Icons.mail_outline,size:20,color: Colors.white)))  ],),
                    Container(margin:EdgeInsets.only(left: 10,top:10,bottom: 10,right: 10),child: Text(text,style: TextStyle(color:Colors.white,fontSize: 15,),)),
                    Row(children: <Widget>[
                      Expanded(child: Container(height: 80, width: 80,
                            child:  ElevatedButton(child: const Text('開始',style: TextStyle(fontWeight: FontWeight.bold),),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange,
                                  shape: const CircleBorder(side: BorderSide(color: Colors.transparent, width: 1, style: BorderStyle.solid,),),),
                                onPressed: startBool ? null :() {interstitialAd();start();},
                              ),),),
                      Container(width: 10,),
                      Expanded(child: Container(height: 80, width: 80, child: ElevatedButton(
                          child:  Text('終了',style: TextStyle(fontWeight: FontWeight.bold),), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange,
                            shape:  CircleBorder(side: BorderSide(color: Colors.transparent, width: 1, style: BorderStyle.solid,),),), onPressed: endBool ? null : (){end();},
                        ),),)]),
                    Container(height: 20,),],)),],),),)));}
  // send();FocusScope.of(context).requestFocus(new FocusNode());

  void _loadData()  {item = [];
  FirebaseFirestore.instance.collection('users').where("ID" ,isEqualTo: ID).get().then((QuerySnapshot snapshot) {
    snapshot.docs.forEach((doc) {setState(() {item = doc["勉強メッセージ"];
    item = List.from(item.reversed);
    });;});});}

  Future<void> send() async {Navigator.pop(context);if(name != ""){DateTime now = DateTime.now();DateFormat outputFormat = DateFormat('yyyy/MM/dd'); var date = outputFormat.format(now);
  map = {"メッセージ":name,"uid":ID,"バグ対策":randomString(5),"日付":date};
  await FirebaseFirestore.instance.collection('users').doc(ID).update({"勉強メッセージ": FieldValue.arrayUnion([map])});
  setState(() {item.insert(0,map);item;});_bodyController.clear();name = "";
  await FirebaseFirestore.instance.collection('管理').doc("勉強メッセージ").update({"uid": FieldValue.arrayUnion([ID])});
  }}

  void start(){setState(() {endBool = false;startBool = true;StartTime = DateTime.now();  DateFormat formatter = DateFormat('HH時mm分');text  =  "開始：" + formatter.format(StartTime);});}

  Future<void> end()  async {endBool = true;startBool = false;var aa = DateTime.now().difference(StartTime).inMinutes; text = "勉強時間：" + aa.toString() +"分勉強";
  DateTime now = DateTime.now();DateFormat outputFormat = DateFormat('yyyy/MM/dd'); var date = outputFormat.format(now);
  map = {"メッセージ":aa.toString() +"分勉強しました","uid":ID,"バグ対策":randomString(5),"日付":date};
  await FirebaseFirestore.instance.collection('users').doc(ID).update({"勉強メッセージ": FieldValue.arrayUnion([map])});
 item.insert(0,map);item;_bodyController.clear();name = "";
  await FirebaseFirestore.instance.collection('管理').doc("勉強メッセージ").update({"uid": FieldValue.arrayUnion([ID])});
  setState(()  {});showInterstitialAd(); }

  void attention(){showDialog(context: context, builder: (context) => AlertDialog(content: Container(height: 90,child:Column(children: [
    Container(child:Text("勉強を中止しますか?",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,)),
    Container(margin :EdgeInsets.only(top:10),width:100,child: ElevatedButton(
      child: Text('はい'), style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey[900], foregroundColor: Colors.white, shape: const StadiumBorder(),),
      onPressed: () {Navigator.pop(context);Navigator.pop(context);},)),],)),));}

  void sign() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ID = prefs.getString("ID") ?? "";
    if (ID == "") {Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()));}else{_loadData();}
  }



  String randomString(int length) {
    const _randomChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    const _charsLength = _randomChars.length;
    final rand = new Random();
    final codeUnits = new List.generate(
      length,
          (index) {
        final n = rand.nextInt(_charsLength);
        return _randomChars.codeUnitAt(n);
      },);
    return new String.fromCharCodes(codeUnits);
  }

  Future<void> first () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var aa = prefs.getString("褒め")??"";
    if(aa == ""){Navigator.of(context).push(MaterialPageRoute(builder: (context) => LOVEFirst()));}
  }


  void mail() {
    showModalBottomSheet(isScrollControlled: true,context: context,backgroundColor: Colors.white,
      shape:   RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) { return StatefulBuilder(builder: (context, StateSetter setState) {
        return
          Container(color: Colors.blueGrey[900],height:  300 +MediaQuery.of(context).viewInsets.bottom,
        //decoration: BoxDecoration( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
        child:GestureDetector(behavior: HitTestBehavior.opaque,
                    onTap: () => FocusScope.of(context).unfocus(), child:SingleChildScrollView(child:Column(mainAxisSize: MainAxisSize.min,children: [
          Container(margin: EdgeInsets.only(bottom: 0),
              child:Row(children: <Widget>[
                Expanded(
                  child: Container(padding: EdgeInsets.symmetric(horizontal: 16.0,),margin: EdgeInsets.only(top: 10,bottom: 10),
                    decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(20),),
                    child: TextField(maxLines: null, controller: _bodyController,decoration: InputDecoration(fillColor: Colors.grey[50], filled: true,border: InputBorder.none,hintText: "message"),onChanged: (String value) {setState(() {name = value;});},),),
                ),
                Container(alignment: Alignment.topCenter,height:50,margin: EdgeInsets.only(right: 10),child:IconButton(
                  onPressed: () {send();FocusScope.of(context).requestFocus(new FocusNode());}, icon:Icon(Icons.send,color: Colors.orange,size: 30,),
                )),],)),],)),));
          // Container(color: Colors.blueGrey[900],height:  100 +MediaQuery.of(context).viewInsets.bottom,child:GestureDetector(behavior: HitTestBehavior.opaque,
          //             onTap: () => FocusScope.of(context).unfocus(), child:SingleChildScrollView(child:Column(children: [
          //   Container(margin: EdgeInsets.only(bottom: 0),
          //       child:Row(children: <Widget>[
          //         Expanded(
          //           child: Container(padding: EdgeInsets.symmetric(horizontal: 16.0,),margin: EdgeInsets.only(top: 10,bottom: 10),
          //             decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(20),),
          //             child: TextField(maxLines: null, controller: _bodyController,decoration: InputDecoration(fillColor: Colors.grey[50], filled: true,border: InputBorder.none,hintText: "message"),onChanged: (String value) {setState(() {name = value;});},),),
          //         ),
          //         Container(height:50,margin: EdgeInsets.only(right: 10),child:IconButton(
          //           onPressed: () {send();FocusScope.of(context).requestFocus(new FocusNode());}, icon:Icon(Icons.send,color: Colors.orange,size: 30,),
          //         )),],)),],)),));
        }, );});}

}

class LOVEFirst extends StatefulWidget {

  @override
  State<LOVEFirst> createState() => _LOVEFirstState();
}
class _LOVEFirstState extends State<LOVEFirst> {
  var rest = 0;
  var item = [];

  void initState() {
    super.initState();first();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false, child:Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
       title: Text("限定100名", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 25), textAlign: TextAlign.center,),

        elevation: 0,
        actions: [IconButton(onPressed: () {Navigator.pop(context);Navigator.pop(context);}, icon: Icon(Icons.highlight_off_outlined,color:Colors.blueGrey[300],))
        ],),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(margin:EdgeInsets.only(top:10),child:  Text("『 褒め 』",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey[800],fontSize: 25), textAlign: TextAlign.center)),
          Container(margin:EdgeInsets.all(30),child:  Text("「勉強疲れるな」\n「こんなに頑張っているのだから誰か褒めてくれよ」\nというあなた\n\n私が褒めるという\nシンプルな機能を作りました\n\n[内容]\n勉強開始ボタン\n↓\n 勉強終了ボタン\n ↓\n 私が褒める\n\nBOTではなく私がアナログで送る為、\n返信出来る人数に限界があるので100名限定にいたします。\n\n無料なのでお早めにどうぞ。",style: TextStyle(color: Colors.blueGrey[900],fontSize: 10), textAlign: TextAlign.center)),
          Container(width: 110.0, height: 110.0, decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.cover, image: AssetImage("images/toshi.png"))),child:TextButton(
            onPressed: () { attention(); }, child: Text(""),),),
          Container(margin:EdgeInsets.only(top:10),child:  Text("開発者「とし」",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey[900],fontSize: 15), textAlign: TextAlign.center)),
          Container(margin:EdgeInsets.only(top:10),child:  Text("参加可能人数：残り"+ rest.toString() + "名",style: TextStyle(color: Colors.blueGrey[800],fontSize: 15), textAlign: TextAlign.center)),
          Container(margin :EdgeInsets.only(top:10),width:100,child: ElevatedButton(
            child: Text('参加'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: const StadiumBorder(),),
            onPressed: () {add();},)),
          Container(width:double.infinity,margin :EdgeInsets.only(top: 30),child:Text("*1週間に1回は使わないと強制退会とします",style: TextStyle(color: Colors.grey,fontSize: 10),textAlign: TextAlign.center,)),
        ],),),));}

  Future<void> add () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();var ID = prefs.getString("ID")??"";
    if (rest<= 100){SharedPreferences prefs = await SharedPreferences.getInstance();prefs.setString("褒め", "1");
      DocumentReference ref = FirebaseFirestore.instance.collection('管理').doc("褒め");
      ref.update({"褒め" : FieldValue.arrayUnion([ID]),});}
    Navigator.pop(context);
  }

  void first(){
    FirebaseFirestore.instance.collection('管理').where("管理",isEqualTo: "褒め").get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) { setState(() {item = doc["褒め"];rest = 90 - item.length;});
      });});}

  void attention(){showDialog(context: context, builder: (context) => AlertDialog(content: Container(height:400,child:Column(children: [
    Container(width: 150.0, height: 150.0, decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.cover, image: AssetImage("images/toshi.png"))),child:TextButton(
      onPressed: () { attention(); }, child: Text(""),),),
    Container(margin:EdgeInsets.only(top:10),child:  Text("開発者「とし」",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey[900],fontSize: 15), textAlign: TextAlign.center)),
    Container(margin:EdgeInsets.all(20),child:  Text("27歳\n175cm・58kg\n趣味：プログラミング、ランニング\n学生時代は水泳部\n\n\n「学生時代こんなアプリがあったら良かったのに」と思えるようなアプリを作るようにしています。個人でアプリ開発を行なっているので、ご意見をいただけると非常に助かります。お互い目標の為に頑張りましょう！\n\n100名限定なので今のうちに友達に紹介してね♪",style: TextStyle(color: Colors.blueGrey[900],fontSize: 10), textAlign: TextAlign.center)),

  ],)),));}

}