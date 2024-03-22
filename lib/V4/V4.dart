import 'dart:math';
import 'package:anki/V4/V4Gacha.dart';
import 'package:anki/V4/V4V2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../アカウント/SignUp.dart';
import 'V4Add.dart';
import 'V4Check.dart';
import 'V4Data.dart';
import 'V4Dril.dart';

class V4 extends StatefulWidget {
  @override
  State<V4> createState() => _V4State();
}

class _V4State extends State<V4> {
  var ID = "";
  var item = [];var check = [];var dril = [];var chie = [];
  void initState() {
    super.initState();
    sign();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        title: FittedBox(fit: BoxFit.fitWidth, child: Text("", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 40), textAlign: TextAlign.center,),),
        iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
        actions: [
          IconButton(icon:  Icon(Icons.more_time_rounded,color: Colors.blue,size: 30,), onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V4Add())).then((value) => first());},),
          IconButton(icon:  Icon(Icons.check_circle_outline,color: Colors.green,size: 30,), onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V4Check(check,ID,item))).then((value) => first());},),
       //   IconButton(icon:  Icon(Icons.stacked_bar_chart,color: Colors.orangeAccent,size: 30,), onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V4Data()));},),
          IconButton(icon:  Icon(Icons.school,color: Colors.brown,size: 30,), onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V4Gacha(chie)));},),
          IconButton(icon:  Icon(Icons.book_outlined,color: Colors.pink,size: 30,), onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V4Dril(dril,ID,item)));},),
         // IconButton(icon:  Icon(Icons.directions_run,color: Colors.purpleAccent,size: 30,), onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V4Add())).then((value) => first());},),
        ],),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(margin: EdgeInsets.only(top:10),width:double.infinity,child:Text("おすすめ",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
          GestureDetector(
            onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V4V2(1500,300,"",ID)));},
            child: Container(margin: EdgeInsets.all(15),color: Colors.grey[200],child:Column(children: [
              Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("勉強時間:　　0:25:00　　",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
              Container(margin: EdgeInsets.all(5),width:double.infinity,child:Text("休憩時間:　　0:05:00" ,style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),)
            ],), ) ,
          ),
          GestureDetector(
            onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V4V2(750,150,"",ID)));},
            child: Container(margin: EdgeInsets.only(left:15,right:15,bottom: 10),color: Colors.grey[200],child:Column(children: [
              Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("勉強時間:　　0:12:30　　",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
              Container(margin: EdgeInsets.all(5),width:double.infinity,child:Text("休憩時間:　　0:02:30" ,style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),)
            ],), ) ,
          ),
          Divider(color: Colors.grey,thickness: 1,indent: 100,endIndent: 100,),
         Container(margin: EdgeInsets.all(10),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(),
            itemCount: item.length, itemBuilder: (context, index) {
             return GestureDetector(
                 onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V4V2(item[index]["勉強"],item[index]["休憩"],"",ID)));},
                 child: Container(margin: EdgeInsets.all(5),color: Colors.grey[200],child:Column(children: [
                   Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("勉強時間:　　" + '${(item[index]["勉強"] / (60 * 60)).floor()}:${((item[index]["勉強"] % (60 * 60) / 60).floor()).toString().padLeft(2, '0')}:${(item[index]["勉強"] % (60 * 60) % 60).toString().padLeft(2, '0')}',style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                   Container(margin: EdgeInsets.all(5),width:double.infinity,child:Text("休憩時間:　　" +'${(item[index]["休憩"] / (60 * 60)).floor()}:${((item[index]["休憩"] % (60 * 60) / 60).floor()).toString().padLeft(2, '0')}:${(item[index]["休憩"] % (60 * 60) % 60).toString().padLeft(2, '0')}',style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),)
                 ],), )    );
             },),),
        ],),),);
  }

  void sign() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ID = prefs.getString("ID") ?? "";first();
    if (ID == "") {Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()));}
    Future.delayed(Duration(seconds: 1), () {setState(() {setState(() {});});});
  }

  void first () async {
  FirebaseFirestore.instance.collection('users').where("ID" ,isEqualTo: ID).get().then((QuerySnapshot snapshot) {
    snapshot.docs.forEach((doc) {setState(() {item = doc["タイマー"];check = doc["チェック"];dril = doc["ドリル"];chie = doc["知恵"];});;});});}
}

