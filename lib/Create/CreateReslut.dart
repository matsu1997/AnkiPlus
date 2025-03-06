import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateResult extends StatefulWidget {
  @override
  CreateResult(this.item1,this.item2,this.item3,this.item4,this.itemAll,this.map,this.self);
  List <dynamic> item1; List <dynamic>item2; List<dynamic> item3; List<dynamic> item4;List <dynamic> itemAll;Map map;int self;

  @override
  State<CreateResult> createState() => _CreateResultState();
}

class _CreateResultState extends State<CreateResult> {
  var te = "";var te1 = "";var te2 = "";var te3 = "";var ID = "";var date = "";var tap = "";
  var AllItem = [];
  var ite1 = false;var ite2 = false;var ite3 = false;var ite4 = false;
  void initState() {
    super.initState();AllItem = widget.itemAll; FlutterAppBadger.removeBadge();
    setState(() { if(widget.item1.length != 0){te = "☆☆☆";ite1 = true;} if(widget.item2.length  != 0){te1 = "★☆☆";ite2 = true;} if(widget.item3.length  != 0){te2 = "★★☆";ite3 = true;} if(widget.item4.length  != 0){te3 = "★★★";ite4 = true;}});
    set();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        title: FittedBox(fit: BoxFit.fitWidth, child: Text("", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,), textAlign: TextAlign.center,),),
        iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
        automaticallyImplyLeading: false,
        actions: [IconButton(icon: const Icon(Icons.highlight_off,color: Colors.blueGrey,size: 30,), onPressed: () {int count = 0;Navigator.popUntil(context, (_) => count++ >= 2);},)],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(margin:EdgeInsets.only(top:10,bottom: 30),child:
            (widget.map["UID"] != ID && widget.self !=0 )?
            Column(mainAxisAlignment: MainAxisAlignment.center,children: [
              Container(margin:EdgeInsets.only(top:10),child: Text("保存",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,),),
              Container(margin:EdgeInsets.only(),child: (tap == "" )?
              Container(child:IconButton(icon: Icon(Icons.bookmark_add_outlined,color: Colors.orange,size: 30,), onPressed: () {add();},)) :
              Container(child:IconButton(icon: Icon(Icons.bookmark_add,color: Colors.orange,size: 30,), onPressed: () {},))
              )],):
            Container()
            ),
            Container(margin:EdgeInsets.only(top:0),child: Text(te,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20),textAlign: TextAlign.center,),),
            Visibility(visible : ite1,child : Divider(color: Colors.blueGrey,thickness: 3,indent: 150,endIndent: 150,),),
            Container(margin: EdgeInsets.all(10),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(),
              itemCount: widget.item1.length, itemBuilder: (context, index) {
                return Card(elevation: 0,color:Colors.grey[200],child: ListTile(
                  title: Text(widget.item1[index]["Q"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
                  onTap: (){showDialog(context: context, builder: (context) => AlertDialog(title: Text(widget.item1[index]["A"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center), ));},
                ),);},),),
            Container(margin:EdgeInsets.only(top:20),child: Text(te1,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20),textAlign: TextAlign.center,),),
            Visibility(visible : ite2,child : Divider(color: Colors.blueGrey,thickness: 3,indent: 150,endIndent: 150,),),
            Container(child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(),
              itemCount: widget.item2.length, itemBuilder: (context, index) {
                return Card(elevation: 0,color:Colors.grey[200],child: ListTile(
                  title: Text(widget.item2[index]["Q"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
                  onTap: (){showDialog(context: context, builder: (context) => AlertDialog(title: Text(widget.item2[index]["A"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center), ));},
                ),);},),),
            Container(margin:EdgeInsets.only(top:20),child: Text(te2,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20),textAlign: TextAlign.center,),),
            Visibility(visible : ite3,child : Divider(color: Colors.blueGrey,thickness: 3,indent: 150,endIndent: 150,),),
            Container(child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(),
              itemCount: widget.item3.length, itemBuilder: (context, index) {
                return Card(elevation: 0,color:Colors.grey[200],child: ListTile(
                  title: Text(widget.item3[index]["Q"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
                  onTap: (){showDialog(context: context, builder: (context) => AlertDialog(title: Text(widget.item3[index]["A"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center), ));},
                ),);},),),
            Container(margin:EdgeInsets.only(top:20),child: Text(te3,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20),textAlign: TextAlign.center,),),
            Visibility(visible : ite4,child : Divider(color: Colors.blueGrey,thickness: 3,indent: 150,endIndent: 150,),),
            Container(margin:EdgeInsets.only(bottom:60),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(),
              itemCount: widget.item4.length, itemBuilder: (context, index) {
                return Card(elevation: 0,color:Colors.grey[200],child: ListTile(
                  title: Text(widget.item4[index]["Q"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
                  onTap: (){showDialog(context: context, builder: (context) => AlertDialog(title: Text(widget.item4[index]["A"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center), ));},
                ),);},),),
          ],
        ),
      ),);
  }

  void set () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();ID =  prefs.getString("ID")!;
    DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(ID).collection("ミス").doc("ミス");
    ref.update({"All": FieldValue.arrayUnion(widget.itemAll),"ミス1": FieldValue.arrayUnion(widget.item2),"ミス2": FieldValue.arrayUnion(widget.item3),"ミス3": FieldValue.arrayUnion(widget.item4)});
    setState(() {});report(ID);
  }
  Future<void> add() async {
    DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(ID);
    ref.update({"問題集2": FieldValue.arrayUnion([widget.map]),});
    setState(() {tap = "tap";});
  }
  Future<void> report(text) async {
    var ran = randomString(4);
    DateTime now = DateTime.now();DateFormat outputFormat = DateFormat('yyyy年MM月dd日'); var date = outputFormat.format(now);
    DocumentReference ref = FirebaseFirestore.instance.collection('レポート').doc(date);
    ref.update({"Result" : FieldValue.arrayUnion([ran + ":C::" + text]),});
  }
  String randomString(int length) {
    const _randomChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    const _charsLength = _randomChars.length;
    final rand = new Random();
    final codeUnits = new List.generate(
      length, (index) {
      final n = rand.nextInt(_charsLength);
      return _randomChars.codeUnitAt(n);
    },);return new String.fromCharCodes(codeUnits);
  }
  // void ankert() {
  //   DateTime now = DateTime.now();DateFormat outputFormat = DateFormat('yyyy年MM月dd日');date = outputFormat.format(now);
  //   FirebaseFirestore.instance.collection('result').doc(date).update({"V1Q": FieldValue.arrayUnion([randomString(2) + widget.name2 + ID ]),});
  // }
  // String randomString(int length) {
  //   const _randomChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  //   const _charsLength = _randomChars.length;
  //   final rand = new Random();
  //   final codeUnits = new List.generate(
  //     length, (index) {
  //     final n = rand.nextInt(_charsLength);
  //     return _randomChars.codeUnitAt(n);
  //   },);return new String.fromCharCodes(codeUnits);
  // }

}