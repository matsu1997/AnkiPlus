import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../V1/V1Q.dart';
import '../アカウント/SignUp.dart';


class First extends StatefulWidget {
  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0,
          title: Text("", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),),
          iconTheme: IconThemeData(color: Colors.white), centerTitle: true,
          // actions: <Widget>[IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.close, color: Colors.black87,))],
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
              Container(margin :EdgeInsets.only(top:100,bottom: 0,),child:Icon(Icons.message_outlined,color: Colors.green,size: 100,)),
              Container(width:double.infinity,margin :EdgeInsets.only(top: 0),child:Text("LINE.Open.chatに登録",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 22),textAlign: TextAlign.center,)),
              Container(width:double.infinity,margin :EdgeInsets.only(top: 30,bottom:10,left: 20,right: 20),child:Text("こちらでも英単語学習を行っています。\n匿名ですので是非登録してくださいね♪",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,)),
              Container(width:double.infinity,margin :EdgeInsets.only(top: 10,bottom:10,left: 20,right: 20),child:Text("",style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold,fontSize: 15,height: 3),textAlign: TextAlign.center,)),
              Container(margin: EdgeInsets.only(top: 20),width: 200, child: ElevatedButton(child:Text("登録"), style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.orange, shape: const StadiumBorder(),),
                onPressed: () {
                final url = Uri.parse('https://line.me/ti/g2/P1ynnbHk5gY8vvFNQBBF7goHY0WUb8KC0CTFZQ?utm_source=invitation&utm_medium=link_copy&utm_campaign=default');
                launchUrl(url);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {return V1Q("英単語","中学英語1",0,1);}),);},),),
            ])));
  }

}