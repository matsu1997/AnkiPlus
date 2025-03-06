import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../アカウント/SignUp.dart';


class Price extends StatefulWidget {
  @override
  State<Price> createState() => _PriceState();
}

class _PriceState extends State<Price> {

  var map = {};
  var name = "";var text = "";
  late TextEditingController _bodyController;
  @override
  void initState() {
    super.initState();_bodyController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0,
          title: Text("", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),),
          iconTheme: IconThemeData(color: Colors.black), centerTitle: true,
          // actions: <Widget>[IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.close, color: Colors.black87,))],
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
              Container(margin :EdgeInsets.only(top:30,bottom: 0,),child:Icon(Icons.key,color: Colors.blueGrey,size: 100,)),
              Container(width:double.infinity,margin :EdgeInsets.only(top: 0),child:Text("ロック解除",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 22),textAlign: TextAlign.center,)),
              Container(width:double.infinity,margin :EdgeInsets.only(top: 30,bottom:10,left: 20,right: 20),child:Text("Ankiplusのtiktok投稿のコメント欄に\nパスワードが記載されています",style: TextStyle(color: Colors.blueGrey[500],fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,)),
              Container(width: double.infinity,height: 30,
                child: ElevatedButton(child: Text("tiktokを見る"),
                  onPressed: () async {final url = "https://www.tiktok.com/@ankiplus2023?_t=ZS-8txKanKfHnM&_r=1";
                  if (await canLaunch(url)) {await launch(url);}},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Colors.black,),),),
              Container(margin :EdgeInsets.only(top:30,bottom: 0,),color: Colors.white,
                  child:Row(children: <Widget>[
                    Expanded(
                      child: Container(padding: EdgeInsets.symmetric(horizontal: 16.0,),margin: EdgeInsets.only(top: 0,bottom: 10),
                        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(40),),
                        child: TextField(maxLines: null, controller: _bodyController,decoration: InputDecoration(enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey, width: 1),),fillColor: Colors.grey[50], filled: true,border: InputBorder.none,hintText: "パスワード"), onChanged: (String value) {setState(() {name = value;});},),),
                    ),
                  ],)),
              Container(margin: EdgeInsets.only(top: 20),width: 200, child: ElevatedButton(child:Text("解除"), style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.black, shape: const StadiumBorder(),),
                onPressed: () { send(); },),),
            ])));
  }
  Future<void> send() async {FocusScope.of(context).unfocus();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(name == "59273"){  prefs.setString("ロック解除", "解除");Navigator.pop(context);}}


}



// import 'dart:math';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../アカウント/SignUp.dart';
//
//
// class Price extends StatefulWidget {
//   @override
//   State<Price> createState() => _PriceState();
// }
//
// class _PriceState extends State<Price> {
//
//   var map = {};
//   var name = "";var text = "";
//   late TextEditingController _bodyController;
//   @override
//   void initState() {
//     super.initState();_bodyController = TextEditingController();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(backgroundColor: Colors.white,
//         appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0,
//           title: Text("", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),),
//           iconTheme: IconThemeData(color: Colors.black), centerTitle: true,
//           // actions: <Widget>[IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.close, color: Colors.black87,))],
//         ),
//         body: SingleChildScrollView(
//             child: Column(children: <Widget>[
//               Container(margin :EdgeInsets.only(top:30,bottom: 0,),child:Icon(Icons.currency_yen,color: Colors.orange,size: 100,)),
//               Container(width:double.infinity,margin :EdgeInsets.only(top: 0),child:Text("有料化への対策",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 22),textAlign: TextAlign.center,)),
//               Container(width:double.infinity,margin :EdgeInsets.only(top: 30,bottom:10,left: 20,right: 20),child:Text("『有料化はしたくない。でも活動費用は必要になる』この葛藤が当初より頭の中を渦巻いております。さらにMacBookを買い替えないと5/1よりアップデートも出来ないという始末。\nこれに伴い『課金しない課金』を開始します。\n具体的には『ポイ活アプリでポイントを貯めてアマゾンギフト券による課金』でございます。これであればお金を払わずにお金を頂ける!勝手ではございますがご協力お願いいたします。大体1ヶ月で貯める事が出来る500円分で1年間ご利用頂けます。1ヶ月の間に無料エリアを覚えてしまいましょう!",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,)),
//               Container(width:double.infinity,margin :EdgeInsets.only(top: 10,bottom:10,left: 20,right: 20),child:Text("おすすめアプリ :トリマ , ステッパー , Powl",style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold,fontSize: 10,height: 1),textAlign: TextAlign.center,)),
//
//               Container(color: Colors.white,
//                   child:Row(children: <Widget>[
//                     Expanded(
//                       child: Container(padding: EdgeInsets.symmetric(horizontal: 16.0,),margin: EdgeInsets.only(top: 0,bottom: 10),
//                         decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(40),),
//                         child: TextField(maxLines: null, controller: _bodyController,decoration: InputDecoration(enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey, width: 1),),fillColor: Colors.grey[50], filled: true,border: InputBorder.none,hintText: "ギフト番号"), onChanged: (String value) {setState(() {name = value;});},),),
//                     ),
//                   ],)),
//               Container(margin: EdgeInsets.only(top: 20),width: 200, child: ElevatedButton(child:Text("課金申請"), style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.green, shape: const StadiumBorder(),),
//                 onPressed: () { send(); },),),
//               Container(width:double.infinity,margin :EdgeInsets.only(top: 0,left: 20,right: 20),child:Text(text,style: TextStyle(color: Colors.blueGrey[800],fontSize: 10),textAlign: TextAlign.center,)),
//               Container(width:double.infinity,margin :EdgeInsets.only(top: 0,left: 20,right: 20),child:Text("ギフトは複数枚でも500円分になればOKです。",style: TextStyle(color: Colors.blueGrey[400],fontSize: 10),textAlign: TextAlign.center,)),
//               Container(width:double.infinity,margin :EdgeInsets.only(top: 0,left: 20,right: 20),child:Text("過払い分の返金は出来かねます。",style: TextStyle(color: Colors.blueGrey[400],fontSize: 10),textAlign: TextAlign.center,)),
//               Container(width:double.infinity,margin :EdgeInsets.only(top: 0,bottom:50,left: 20,right: 20),child:Text("申請後、ギフトを確認してから有料エリアのロック解除しますので少々お待ちください。(最大1日)",style: TextStyle(color: Colors.blueGrey[400],fontSize: 10),textAlign: TextAlign.center,)),
//
//             ])));
//   }
//   Future<void> send() async {FocusScope.of(context).unfocus();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var ID = prefs.getString("ID") ?? "";
//     if(name != ""){DateTime now = DateTime.now();DateFormat outputFormat = DateFormat('yyyy/MM/dd'); var date = outputFormat.format(now);
//   map = {"メッセージ":name,"uid":ID,"バグ対策":randomString(5),"日付":date};
//   await FirebaseFirestore.instance.collection('users').doc(ID).update({"メッセージ": FieldValue.arrayUnion([map])});
//    _bodyController.clear();name = "";
//   await FirebaseFirestore.instance.collection('管理').doc("メッセージ").update({"uid": FieldValue.arrayUnion([ID])});
//   }setState(() {text = "課金申請しました！";});}
//
//   String randomString(int length) {
//     const _randomChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
//     const _charsLength = _randomChars.length;
//     final rand = new Random();
//     final codeUnits = new List.generate(
//       length,
//           (index) {
//         final n = rand.nextInt(_charsLength);
//         return _randomChars.codeUnitAt(n);
//       },);
//     return new String.fromCharCodes(codeUnits);
//   }
// }