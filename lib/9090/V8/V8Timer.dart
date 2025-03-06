import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'V8First.dart';

class V8Timer extends StatefulWidget {

  @override
  State<V8Timer> createState() => _V8TimerState();
}

class _V8TimerState extends State<V8Timer> {
  var ID = "";
  var image = "";
  var point = 0;var pointText = "";
  var nextTime = "";var link = "";
  var check = false;
  bool _isEnabled = false;
  bool _isEnabled2 = false;
   void initState() {
    super.initState();loadData ();
    Timer.periodic( Duration(seconds: 1), (Timer timer) {},);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white,
            title:  Text("", style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center,),
            centerTitle: true,elevation: 0,
            leading:IconButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V8First()),);}, icon: Icon(Icons.info_outline,color: Colors.black87,)),
            //actions: <Widget>[IconButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V8Collection()));}, icon: Icon(Icons.photo_album_outlined,color: Colors.black87,))]
        ),
        body:SingleChildScrollView(child:Column(children: [
             ],)));
  }

  void loadData () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();ID =  prefs.getString("ID")?? "";
    FirebaseFirestore.instance.collection('users').where("ID",isEqualTo: ID).get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {point = doc["V8ポイント"];check = true;});});}


}
