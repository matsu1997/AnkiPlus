import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../アカウント/SignUp.dart';


class Push extends StatefulWidget {
  @override
  State<Push> createState() => _PushState();
}

class _PushState extends State<Push> {
  var ID = "";var pass = "";
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor:  Colors.white,elevation: 0,
          title: Text("",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blue),),
          //  iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
          actions: <Widget>[IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.close,color: Colors.black87,))],
        ),
        body:SingleChildScrollView(child:Column(
            children:[
              Container(margin :EdgeInsets.only(top:10,bottom: 0,right: 20),width: 300,height: 300,
                child:Image(image: AssetImage("images/first.png"),),),
              Container(width:double.infinity,margin :EdgeInsets.only(top: 30),child:Text("継続の為にも通知を許可してみませんか？",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 22),textAlign: TextAlign.center,)),

            ])));}

}