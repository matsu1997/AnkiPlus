
import 'dart:io';

import 'package:anki/%E3%81%9D%E3%81%AE%E4%BB%96/Support.dart';
import 'package:anki/%E3%81%9D%E3%81%AE%E4%BB%96/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Coin.dart';
import '../Create/CreateV1.dart';
import '../V5/V5.dart';
import '../その他/LOVE.dart';
import '../アカウント/FirstQ.dart';
import '../アカウント/SignUp.dart';
import 'V1V2.dart';
import 'V2/V2.dart';

class V1 extends StatefulWidget {

  @override
  State<V1> createState() => _V1State();
}

class _V1State extends State<V1> {
  // var item = ["自作","復習","","英単語", "漢字", "古文", "漢文単語", "世界史", "日本史", "地理", "生物", "物理", "化学",]; //Icons.history
  // var item1 = [ Icons.create_new_folder,Icons.history,Icons.e_mobiledata,Icons.format_color_text_outlined, Icons.edit_outlined,Icons.receipt_long,Icons.edit_note, Icons.language_outlined, Icons.history_edu, Icons.pin_drop_outlined, Icons.coronavirus_outlined, Icons.rocket_launch_outlined, Icons.science_outlined,];
  var item = ["英単語", "英熟語",  "漢字", "古文", "漢文単語", "世界史", "日本史", "地理","生物","short","復習",]; //Icons.history
  var item1 = [LineIcons.font,LineIcons.info, LineIcons.pen,LineIcons.torah,LineIcons.fileInvoice, LineIcons.globe, LineIcons.map,LineIcons.mapMarker, LineIcons.bug, Icons.timeline_sharp,LineIcons.history];
  final _pageController = PageController(viewportFraction: 0.877);final flnp = FlutterLocalNotificationsPlugin();
  double currentPage = 0;
  var ID  = "";


  void initState() {
  _pageController.addListener(() {setState(() {currentPage = _pageController.page!.toDouble();});});
    super.initState();
    sign();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        title:  Text("", style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center,),
        centerTitle: true,elevation: 0,
           actions: <Widget>[
            Row(children: [
              IconButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => Coin()),);}, icon: Icon(LineIcons.coins,color:Colors.blueGrey[300],)),
              IconButton(onPressed: () {start();}, icon: Icon(Icons.info_outline,color: Colors.blueGrey[300],)),
              IconButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => Support()),);}, icon: Icon(Icons.mail_outline,color: Colors.blueGrey[300],)),
              IconButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => Account()),);}, icon: Icon(Icons.person_3_outlined,color:Colors.blueGrey[300],))
            ],)],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
            Container(margin: EdgeInsets.only(top: 0, bottom: 30),
                child: GridView.count(padding: EdgeInsets.only(left: 20.0,right:  20.0),
                    crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0, childAspectRatio: 1.5, shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                    children: List.generate(item.length, (index) {
                      return GestureDetector(
                          onTap: () {if (item[index] == "英単語" ||item[index] == "英熟語" || item[index] == "漢字" || item[index] == "古文"|| item[index] == "漢文単語"||item[index] == "世界史"|| item[index] == "日本史"|| item[index] == "地理"||item[index] == "生物"){Navigator.of(context).push(MaterialPageRoute(builder: (context) => V1V2(item[index])),);}else{
                            if (item[index] == "short" ){Navigator.of(context).push(MaterialPageRoute(builder: (context) => V5()));}else{};
                            if (item[index] == "復習" ){Navigator.of(context).push(MaterialPageRoute(builder: (context) => V2()));}else{};
                            if (item[index] == "褒め" ){Navigator.of(context).push(MaterialPageRoute(builder: (context) => LOVE()));}else{};
                          }},
                          child: Container(alignment: Alignment.center,decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), ),
                            child: Column(children: <Widget>[
                                Expanded(child:Container(alignment: Alignment.bottomCenter,child:item[index] == "英単語"||item[index] == "英熟語"|| item[index] == "漢字" || item[index] == "古文"||item[index] == "漢文単語"|| item[index] == "世界史"|| item[index] == "日本史" || item[index] == "地理"||item[index] == "生物" ?Container(child: Icon(item1[index], color: Colors.black, size: 70,)):
                                Container(alignment: Alignment.bottomCenter,child:item[index] == "short"?Container(child: Icon(item1[index], color: Colors.black, size: 70,)):
                                Container(alignment: Alignment.bottomCenter,child:item[index] == "復習"?Container(child: Icon(item1[index], color: Colors.black,  size: 70,)):
                             //   Container(alignment: Alignment.bottomCenter,child:item[index] == "褒め"?Container(child: Icon(item1[index], color: Colors.black,  size: 70,)):
                                Container(alignment: Alignment.bottomCenter,child:item[index] == ""?Container(child: Icon(item1[index], color: Colors.white, size: 70,)):
                                Container(alignment: Alignment.bottomCenter,child:Container(child: Icon(item1[index], color: Colors.black, size: 70,)))))))),
                               Container(margin: EdgeInsets.only(top:0), child: Text(item[index], style: TextStyle(color: Colors.blueGrey[800],  fontSize: 15,),)),

                            ]),));
                    }))),
            Container(height: 50,color: Colors.white,)
          ],),),);
  }
  void start(){showModalBottomSheet(isScrollControlled: true, context: context,backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) {return Container(height: 700,
          child: SingleChildScrollView(
              child: Column(children: <Widget>[
                Container(margin :EdgeInsets.only(top:30,bottom: 0,right: 20),width: 150,height: 150, child:Image(image: AssetImage("images/name.PNG"),),
                ),
                Container(width:double.infinity,margin :EdgeInsets.only(top: 30),child:Text("即答出来なきゃ覚えてない",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 22),textAlign: TextAlign.center,)),
                Container(width:double.infinity,margin :EdgeInsets.only(top: 10,bottom:50,left: 20,right: 20),child:Text("暗記機能は即答×繰り返しのアウトプット重視で覚えるのを目的にしています。答えに表示されるのが全ての答えでは無い場合があります。あくまで学習の第一歩としてご利用頂けたらと思います。\nタイマー機能には勉強のサポートとしてAI先生や問題自動生成機能があります。ぜひご活用ください。",style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.bold,fontSize: 15,height: 3),textAlign: TextAlign.center,)),

              ])));});}
  void sign() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    ID = prefs.getString("ID") ?? "";
   // var test = prefs.getInt("テスト結果1") ?? 0;
    if (ID == "") {Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()));}else{
     // if (test == 0) {Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  FirstQ()));}else{
        FirebaseFirestore.instance.collection('users').doc(ID).collection('判定').doc("有料").get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          FirebaseFirestore.instance.collection('users').where("ID",isEqualTo: ID).get().then((QuerySnapshot snapshot) {
            snapshot.docs.forEach((doc) {

              List cc = doc.data().toString().contains('問題集2') ? doc.get('問題集2') : [];
              if(cc.length == 0){
                FirebaseFirestore.instance.collection('users').doc(ID).update({"問題集2":[]});
              }

              var bb = doc["有料"]; if (DateTime.now().millisecondsSinceEpoch < bb.millisecondsSinceEpoch) {
              prefs.setBool("有料判定1", true);
            }else{prefs.setBool("有料判定1", false);}

             });});}else {
          Timestamp priceDate = Timestamp.fromDate(DateTime.now().add(Duration(days:-1)));
          FirebaseFirestore.instance.collection('users').doc(ID).update({"有料":priceDate});
          FirebaseFirestore.instance.collection('users').doc(ID).collection('判定').doc("有料").set({"有料":priceDate});
          prefs.setBool("有料判定1", false);
        }
      });message ();}
       var aa = prefs.getString("広告非表示宣伝")??"";
       if (aa == ""){;prefs.setString("広告非表示宣伝","aa");Navigator.of(context).push(MaterialPageRoute(builder: (context) => Coin()));}
        }


   Future<void> message () async {
     var map = {};var id = "";SharedPreferences prefs = await SharedPreferences.getInstance();
     FirebaseFirestore.instance.collection('管理').where("管理" ,isEqualTo: "通知").get().then((QuerySnapshot snapshot) {
       snapshot.docs.forEach((doc) {setState(() {map = doc["メッセージ"]; id = map["ID"];var aa = prefs.getString(id)??"";
        if (aa == ""){ prefs.setString(id, "value");
       showDialog(context: context, builder: (context) => AlertDialog(title:Container(child: Column(children: [
         Container(child:  Text("皆さんへのメッセージ",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center)),
         Container(margin :EdgeInsets.only(top:10),child:  Text(map["メッセージ"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center)),
         Container(child: map["レビューONOFF"] == true ?Container(
       child: Container(margin :EdgeInsets.only(top:10),width:100,child: ElevatedButton(
        child: Text('レビュー'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: const StadiumBorder(),),
        onPressed: () {_requestReview();},)),
    ):Container())   ],),)  )); }  });;});});
   }

  Future<void> _requestReview() async {
    // final InAppReview inAppReview = InAppReview.instance;
    // if (await inAppReview.isAvailable()) {inAppReview.requestReview();}
    if(Platform.isAndroid) {
      final url = Uri.parse('https://play.google.com/store/apps/details?id=com.anki.anki.anki&hl=ja-JP');
      launchUrl(url);
    } else if(Platform.isIOS) {
      final url = Uri.parse('https://apps.apple.com/jp/app/ankiplus/id6450143151');
      launchUrl(url);
    }
  }




}




