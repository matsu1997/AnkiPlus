
import 'dart:async';

import 'package:anki/V8/V8Collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'V8First.dart';

class V8 extends StatefulWidget {

  @override
  State<V8> createState() => _V8State();
}

class _V8State extends State<V8> {
  var ID = "";
  var image = "";
  var point = 0;var pointText = "";
  var nextTime = "";var link = "";
  var check = false;
  bool _isEnabled = false;
  bool _isEnabled2 = false;
  var item2 = ["images/A1.PNG","images/A2.PNG","images/A3.PNG"];var item3 = ["images/B1.PNG","images/B2.PNG","images/B3.PNG","images/B4.PNG","images/B5.PNG","images/B6.PNG","images/B7.PNG","images/B8.PNG",];
  var item4 = ["images/C1.PNG","images/C2.PNG","images/C3.PNG","images/C4.PNG","images/C5.PNG","images/C6.PNG","images/C7.PNG","images/C8.PNG","images/C9.PNG","images/C10.PNG",
               "images/C11.PNG","images/C12.PNG","images/C13.PNG","images/C14.PNG","images/C15.PNG","images/C16.PNG","images/C17.PNG","images/C18.PNG","images/C19.PNG","images/C20.PNG",];
  void initState() {
    super.initState();loadData ();
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {set();},);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white,
          title:  Text("", style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center,),
          centerTitle: true,elevation: 0,
            leading:IconButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V8First()),);}, icon: Icon(Icons.info_outline,color: Colors.black87,)),
            actions: <Widget>[IconButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V8Collection()));}, icon: Icon(Icons.photo_album_outlined,color: Colors.black87,))]),
          body:SingleChildScrollView(child:Column(children: [
          Container(width:double.infinity,margin :EdgeInsets.only(top: 20),child:Text("LINE.OpenChat自習室",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,)),
          Divider(color: Colors.blueGrey,thickness: 3,indent: 80,endIndent: 80,),
          Container(width:double.infinity,margin :EdgeInsets.only(top: 5),child:Text(nextTime,style: TextStyle(color: Colors.blueGrey[800],fontSize: 15),textAlign: TextAlign.center,)),
            Container(width:double.infinity,margin :EdgeInsets.only(top: 5),child:Text("入室は10分前から可能",style: TextStyle(color: Colors.grey,fontSize: 10),textAlign: TextAlign.center,)),
            Container(margin :EdgeInsets.only(top:20),width:150,child: ElevatedButton(child: Text('参加'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: const StadiumBorder(),),
            onPressed:!_isEnabled ? null : () async {var now = DateTime.now();  final DateTime five = now.add(Duration(minutes: 50));
              SharedPreferences prefs = await SharedPreferences.getInstance();prefs.setString("Study", five.toString()); if (await canLaunch(link)) {await launch(link);}
            },)),
          Container(width:double.infinity,margin :EdgeInsets.only(top: 50,right: 80),child:Text("無駄機能",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 10),textAlign: TextAlign.center,)),
          Container(width:double.infinity,margin :EdgeInsets.only(top: 0),child:Text("ネコガチャ",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,)),
          Divider(color: Colors.blueGrey,thickness: 3,indent: 130,endIndent: 130,),
          Container(width:double.infinity,margin :EdgeInsets.only(top: 0),child:Text("①参加ボタンからLINEへ(必須)",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 10),textAlign: TextAlign.center,)),
          Container(width:double.infinity,margin :EdgeInsets.only(top: 0),child:Text("②終了後にこの画面でポイント付与",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 10),textAlign: TextAlign.center,)),
          Container(width:double.infinity,margin :EdgeInsets.only(top: 0),child:Text("③1限10P / 50Pで1回ガチャ",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 10),textAlign: TextAlign.center,)),
          Container(width:double.infinity,margin :EdgeInsets.only(top: 0),child:Text("④OpenChatのアイコンにして自慢しよう",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 10),textAlign: TextAlign.center,)),

          Container(width:double.infinity,margin :EdgeInsets.only(top: 20,left: 0),child:Text("現在ポイント",style: TextStyle(color: Colors.grey,fontSize: 10),textAlign: TextAlign.center,)),
          Container(width:double.infinity,margin :EdgeInsets.only(top: 0,left: 0),child:Text(point.toString() + "ポイント",style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,)),
          Container(width:double.infinity,margin :EdgeInsets.only(top: 3,left: 0),child:Text(pointText,style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 10),textAlign: TextAlign.center,)),
          Container(margin :EdgeInsets.only(top:20),width:150,child: ElevatedButton(child: Text('ガチャ'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, shape: const StadiumBorder(),),
            onPressed: !_isEnabled2 ? null : () {firebase ();},)),
        ],)));
  }

  void loadData () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();var aa =  prefs.getString("V8First")?? "";ID =  prefs.getString("ID")?? "";
    if (aa  == ""){ Navigator.of(context).push(MaterialPageRoute(builder: (context) => V8First()));}
    FirebaseFirestore.instance.collection('users').where("ID",isEqualTo: ID).get().then((QuerySnapshot snapshot) {
     snapshot.docs.forEach((doc) {point = doc["V8ポイント"];check = true;});});}

  void set () async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); var now = DateTime.now();var now2 =  prefs.getString("Study")?? "";print(now2);if (now2 == "0" ||now2 == "" ){now2 = now.toString();}
      if (check == true){ if (now.compareTo(DateTime.parse(now2)) > 0){point = point + 10;pointText = "10P付与されました!";prefs.setString("Study", now.add(Duration(days: 5000)).toString());FirebaseFirestore.instance.collection('users').doc(ID).update({"V8ポイント":point});}if (49 < point ){_isEnabled2 = true;}else{_isEnabled2 = false;}}
      var minute = DateTime.now().minute; var hour = DateTime.now().hour;
     if( 49 < minute == true && minute < 60 == true){link = "https://line.me/ti/g2/P1ynnbHk5gY8vvFNQBBF7goHY0WUb8KC0CTFZQ?utm_source=invitation&utm_medium=link_copy&utm_campaign=default";_isEnabled = true;nextTime = "次は" + (hour +1 ).toString() + "時" + "00分ー" + (hour +1 ).toString() + "時" + "50分";}
     if( -1 < minute == true && minute < 20 == true){_isEnabled = false;nextTime = "次は" + hour.toString() + "時" + "30分ー" + (hour +1 ).toString() + "時" + "20分";}
     if( 19 < minute == true && minute < 30 == true){link = "https://line.me/ti/g2/0nve2tmLQLzkAoD-tfOKgbjYdcotDQBY75-RkA?utm_source=invitation&utm_medium=link_copy&utm_campaign=default";_isEnabled = true;nextTime = "次は" + hour.toString() + "時" + "30分ー" + (hour +1 ).toString() + "時" + "20分";}
     if( 29 < minute == true && minute < 50 == true){_isEnabled = false;nextTime = "次は" + (hour +1 ).toString() + "時" + "00分ー" + (hour +1 ).toString() + "時" + "50分";}
     setState(()  { });}
   // 1      1   1
   // 3     10  3.3
   // 8     40   5
   // 20    150  7.5
   void firebase (){var random = math.Random(); var co = random.nextInt(3350);
     if(co == 0){image = "images/ガチャ/S1.PNG";Gacha();}//0
     if( 0 < co == true && co < 31 == true){image = item2[ random.nextInt(item2.length -1)];Gacha();}//1~30
     if( 30 < co == true && co < 351 == true){image = item3[ random.nextInt(item3.length -1)];Gacha();}//31~350
     if( 350 < co == true && co < 3351 == true){image = item4[ random.nextInt(item4.length -1)];Gacha();}//351~3350
     point = point - 50;
     FirebaseFirestore.instance.collection('users').doc(ID).update({"V8ポイント":point,"V8Collection": FieldValue.arrayUnion([image]),});
     }
  void Gacha() {
    showModalBottomSheet(context: context,backgroundColor: Colors.white,
      shape:  const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) { return StatefulBuilder(builder: (context, StateSetter setState) {
        return Container(color:Colors.transparent,height: 500,
            child: Column(children: [
              Container(margin :EdgeInsets.only(top: 30,left: 0),width:300,height:300,child: Image.asset(image)),
            ],));});}, ).whenComplete(() {setState(() {});});}

}
