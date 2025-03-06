import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:line_icons/line_icons.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CreateAll extends StatefulWidget {
  CreateAll(this.name,this.ID,this.ID2,this.co,this.count,this.map,this.self);
  String name;String ID;String ID2;int co;int count;Map map;int self;
  @override
  State<CreateAll> createState() => _CreateAllState();
}

class _CreateAllState extends State<CreateAll> {
  var item = [];
  var ID = "";var tap = "";
  List<String> prefItem = [];List<String> prefItem2 = [];
  var compare = true;
  void initState() {
    super.initState();first (); interstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(backgroundColor: Colors.white,
          appBar: AppBar(backgroundColor: Colors.white,
            title: Text(widget.map["name"], style: TextStyle(color: Colors.black, fontSize: 15), textAlign: TextAlign.center,), iconTheme: IconThemeData(color: Colors.black), centerTitle: true, elevation: 0,
            actions: [
              Row(children: [
               // Container(child: widget.name == "漢文単語" || widget.name == "古文"?Container(): IconButton(icon:  Icon(Icons.volume_up,color: Colors.blueGrey,), onPressed: () {_speak();},)),
                Container(child: IconButton(icon:  Icon(Icons.compare_arrows,color: Colors.blueGrey,), onPressed: () {if(compare == true){compare = false;}else{compare = true;};first();},)),
              ],)     ],  ),
          body: SingleChildScrollView(
            child: Column(children: <Widget>[
              Container(margin:EdgeInsets.only(top:10,bottom: 0),child:
              (widget.map["UID"] != ID && widget.self !=0 )?
              Column(mainAxisAlignment: MainAxisAlignment.center,children: [
                Container(margin:EdgeInsets.only(),child: (tap == "" )?
                Container(child:IconButton(icon: Icon(Icons.bookmark_add_outlined,color: Colors.orange,size: 30,), onPressed: () {add();},)) :
                Container(child:IconButton(icon: Icon(Icons.bookmark_add,color: Colors.orange,size: 30,), onPressed: () {},)))
                ,Container(margin:EdgeInsets.only(top:0),child: Text("保存",style: TextStyle(color:Colors.blueGrey[900],fontSize: 10),textAlign: TextAlign.center,),),
              ],):
              Container()
              ),
                Container(margin: EdgeInsets.all(10),
                  child: ListView.builder(
                    shrinkWrap: true, physics: NeverScrollableScrollPhysics(),reverse: true,
                    itemCount: item.length, itemBuilder: (context, index) {
                    return compare == true ?Card(
                      elevation: 0, color: Colors.grey[200], child: ListTile(
                      trailing: Container(margin: EdgeInsets.only(top: 0), child:prefItem2.contains(item[index]["問題"]+item[index]["答え"]) == true ? Icon(LineIcons.times,color: Colors.black,):Container(child:prefItem.contains(item[index]["問題"]+item[index]["答え"]) == true ? Icon(Icons.circle_outlined,color: Colors.red,):Container(width: 0,))),
                      title: Text(item[index]["問題"], style: TextStyle(
                          color: Colors.blueGrey[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 15), textAlign: TextAlign.center),
                      onTap: () {
                        showDialog(context: context, builder: (context) => AlertDialog(
                            insetPadding: EdgeInsets.zero,
                            title: Column(children: [
                              Text(item[index]["答え"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
                              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                                Container(margin: EdgeInsets.only(top: 10),width: 50, child: IconButton(
                                  onPressed: () {Correct(index);Navigator.pop(context);}, icon: Icon(Icons.circle_outlined,color: Colors.red,), ),),
                                Container(margin: EdgeInsets.only(top: 10),width: 50, child: IconButton(
                                  onPressed: () {firebase(index);Navigator.pop(context);}, icon: Icon(LineIcons.times,color: Colors.black,), ),),
                              ],),
                              Container(height: 0,width: double.infinity,color: Colors.black,margin:EdgeInsets.only(top:20,bottom: 0)),
                            ],)));show ();    },
                    ),):
                    Card(
                      elevation: 0, color: Colors.grey[200], child: ListTile(
                      trailing: Container(margin: EdgeInsets.only(top: 0), child:prefItem2.contains(item[index]["答え"]+item[index]["問題"]) == true ? Icon(LineIcons.times,color: Colors.black,):Container(child:prefItem.contains(item[index]["答え"]+item[index]["問題"]) == true ? Icon(Icons.circle_outlined,color: Colors.red,):Container(width: 0,))),
                      title: Text(item[index]["答え"], style: TextStyle(
                          color: Colors.blueGrey[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 15), textAlign: TextAlign.center),
                      onTap: () {
                        showDialog(context: context, builder: (context) => AlertDialog(
                            insetPadding: EdgeInsets.zero,
                            title: Column(children: [
                              Text(item[index]["問題"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
                              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                                Container(margin: EdgeInsets.only(top: 10),width: 50, child: IconButton(
                                  onPressed: () {Correct(index);Navigator.pop(context);}, icon: Icon(Icons.circle_outlined,color: Colors.red,), ),),
                                Container(margin: EdgeInsets.only(top: 10),width: 50, child: IconButton(
                                  onPressed: () {firebase(index);Navigator.pop(context);}, icon: Icon(LineIcons.times,color: Colors.black,), ),),
                              ],),
                              Container(height: 0,width: double.infinity,color: Colors.black,margin:EdgeInsets.only(top:20,bottom: 0)),
                            ],)));show ();    },
                    ),) ;

                  },),),
              ],
            ),
          ),);
  }
  void first () async {
 SharedPreferences prefs = await SharedPreferences.getInstance();ID =  prefs.getString("ID")!;
 setState(() {prefItem = prefs.getStringList("Man4単語帳") ?? [];prefItem2 = prefs.getStringList("Man4単語帳バツ") ?? [];});
    FirebaseFirestore.instance.collection('users').doc(widget.ID).collection("問題集").where("ID" ,isEqualTo: widget.ID2).get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {setState(() {item = doc["問題"]??[]; //if(widget.co == 1){item.shuffle();}
      });;});});}

  Future<void> add() async {
    DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(ID);
    ref.update({"問題集2": FieldValue.arrayUnion([widget.map]),});
    setState(() {tap = "tap";});
  }
  Future<void> firebase(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefItem2 = prefs.getStringList("Man4単語帳バツ") ?? [];
    if(compare ==true) {
      prefItem2.add(item[index]["問題"] + item[index]["答え"]);
      if (prefItem2.contains(item[index]["問題"] + item[index]["答え"]) == false) {} else {prefs.setStringList("Man4単語帳バツ", prefItem2);}
    }else{
      prefItem2.add(item[index]["答え"] + item[index]["問題"]);
      if (prefItem2.contains(item[index]["答え"] + item[index]["問題"]) == false) {} else {prefs.setStringList("Man4単語帳バツ", prefItem2);}
    }
    setState(() {});
  }
  Future<void> Correct(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefItem = prefs.getStringList("Man4単語帳") ?? [];prefItem2 = prefs.getStringList("Man4単語帳バツ") ?? [];
    if(compare ==true) {
      prefItem.add(item[index]["問題"]+item[index]["答え"]);prefItem2.remove(item[index]["問題"]+item[index]["答え"]);prefs.setStringList("Man4単語帳バツ", prefItem2);
      if(prefItem.contains(item[index]["問題"]+item[index]["答え"]) == false){print(0);}else{prefs.setStringList("Man4単語帳", prefItem);print(1);}
    }else{
      prefItem.add(item[index]["答え"]+item[index]["問題"]);prefItem2.remove(item[index]["答え"]+item[index]["問題"]);prefs.setStringList("Man4単語帳バツ", prefItem2);
      if(prefItem.contains(item[index]["答え"]+item[index]["問題"]) == false){print(0);}else{prefs.setStringList("Man4単語帳", prefItem);print(1);}
    }
      setState(() {});}



  Future<void> report(text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var ID = prefs.getString("ID") ?? "";
    var ran = randomString(4);
    DateTime now = DateTime.now();
    DateFormat outputFormat = DateFormat('yyyy年MM月dd日');
    var date = outputFormat.format(now);
    DocumentReference ref = FirebaseFirestore.instance.collection('レポート')
        .doc(date);
    ref.update({
      "ResultAll": FieldValue.arrayUnion(
          [ran + ":ID:" + text.substring(0, 3) + ":V:"  + ID.substring(0, 3)]),
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

}