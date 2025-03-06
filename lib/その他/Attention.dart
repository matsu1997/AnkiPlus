import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../9090/V8.dart';
import '../アカウント/SignUp.dart';
import 'Ankert.dart';


class Atention extends StatefulWidget {
  @override
  State<Atention> createState() => _AtentionState();
}

class _AtentionState extends State<Atention> {
  var item = [];
  var map = {};
  var user = "";
  var name = "";
  var ID = "";
  var message0 = "";
  var co = 0;
  var text = "";
  get onEng => null;var isOn = false;
  late TextEditingController _bodyController;
  var _scrollController = ScrollController();

  void initState() {
    super.initState();
    _bodyController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white,
          title: Text('開発者', style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),),
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          elevation: 0,
        ),
        body:SingleChildScrollView(child:Column(
            children:[
              Container(margin:EdgeInsets.only(top:40),color: Colors.white,width: double.infinity,alignment: Alignment.center,child:Text("メッセージ",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,)),
               Container(width: double.infinity, margin: EdgeInsets.only(top: 5, bottom: 5, left: 70, right: 70),
                child: TextFormField(maxLines: null, decoration: InputDecoration(labelText: 'テキスト',),
                  onChanged: (String value) {setState(() {text = value;});},),),
              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                Container(child: Text("レビュー",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,),),
                Switch(value: isOn, onChanged: (bool? value) {if (value != null) {setState(() {isOn = value!;});}},),
              ],),
              Container(margin :EdgeInsets.only(top:20),width:100,child: ElevatedButton(
                child: Text('送信'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: const StadiumBorder(),),
                onPressed: () {message();},)),
            ]))
    );
  }


  Future<void> message() async {
    var id = randomString(20);
      map = {"メッセージ": text, "ID": id, "レビューONOFF":isOn};
      await FirebaseFirestore.instance.collection('管理').doc("通知").update({"メッセージ": map});
      Navigator.pop(context);
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

}