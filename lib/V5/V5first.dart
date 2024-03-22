import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../アカウント/SignUp.dart';


class V5first extends StatefulWidget {
  @override
  State<V5first> createState() => _V5firstState();
}

class _V5firstState extends State<V5first> {


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0,
          title: Text("", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),),
          //  iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
         // actions: <Widget>[IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.close, color: Colors.black87,))],
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
              Container(margin :EdgeInsets.only(top:30,bottom: 0,right: 20),width: 150,height: 150, child:Image(image: AssetImage("images/first.png"),),),
              Container(width:double.infinity,margin :EdgeInsets.only(top: 30),child:Text("分散・シャッフル学習「short」",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 22),textAlign: TextAlign.center,)),
              Container(width:double.infinity,margin :EdgeInsets.only(top: 30),child:Text("短時間で多くの問題に触れる",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,)),
              Container(width:double.infinity,margin :EdgeInsets.only(top: 10,bottom:50,left: 20,right: 20),child:Text("あなたが覚えてない、解いてない問題・復習すべき問題をチョイスして表示されます。画面右上のアイコンより範囲を選択し、学習を始めましょう。忘却曲線を元に復習問題が表示されます。なるべく毎日使うようにしましょう!",style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold,fontSize: 15,height: 3),textAlign: TextAlign.center,)),

            ])));
  }


}