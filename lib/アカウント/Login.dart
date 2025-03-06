import 'dart:math';

//import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:anki/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../V1/V1.dart';
import 'SignUp.dart';

void main() async {
  // 初期化処理を追加
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

/* --- 省略 --- */

// ログイン画面用Widget
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String text = '';
  var password = '';
  var ID = "";

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                  Container(margin: EdgeInsets.only(top: 100, bottom: 30,), child: Text("Login", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 40)),),
                  Container(width: double.infinity, margin: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    child: TextFormField(decoration: InputDecoration(labelText: 'ID',
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey, width: 3),)),
                      onChanged: (String value) {setState(() {ID = value;});},),),
                  Container(width: double.infinity, margin: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    child: TextFormField(decoration: InputDecoration(labelText: 'Password',
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey, width: 3),)),
                      onChanged: (String value) {setState(() {password = value;});},),),
                  Container(padding: EdgeInsets.all(8), child: Text(text,style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,)),
                Container(margin: EdgeInsets.only(top: 20,bottom: 30),width: 100,
                child: ElevatedButton(child:Text('Login'), style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, shape: const StadiumBorder(),),
                  onPressed: () {login();},),),
               Container(width: double.infinity, child: ElevatedButton(child: Text("アカウントをお持ちでない方"),
                onPressed: () async {Navigator.pop(context);},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Colors.grey[700],),),),

            ],),),),);
  }
  void login () async {
    FirebaseFirestore.instance.collection('users').where("ID", isEqualTo:ID ).get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) async {
        if (password == doc["pass"]){
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("ID", ID);
          Navigator.pop(context);Navigator.pop(context);
        }else{
        }});});
    setState(() {text = "IDかPasswordが違います";});}
}