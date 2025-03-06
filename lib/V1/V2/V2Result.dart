import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class V2Result extends StatefulWidget {
  @override
  V2Result(this.item1,this.item2,this.item3,this.item4,this.name,this.itemAll,this.All);
  List <dynamic> item1; List <dynamic>item2; List<dynamic> item3; List<dynamic> item4;String name; List <dynamic> itemAll;List <dynamic> All;

  @override
  State<V2Result> createState() => _V2ResultState();
}

class _V2ResultState extends State<V2Result> {
  var te = "";var te1 = "";var te2 = "";var te3 = "";var ID = "";var date = "";
  List <dynamic> item2 = []; List <dynamic> item3 = []; List <dynamic> item4 = [];
  var Ei = [];var Ka = [];var Ko = [];var Se = [];var Ni = [];var Ti = [];var SeI = [];var Bu = [];var KaG = [];var All = [];
  var ite1 = false;var ite2 = false;var ite3 = false;var ite4 = false;


  void initState() {
    super.initState();print("widget.itemAll");print(widget.itemAll);
    setState(() { if(widget.item1.length != 0){te = "☆☆☆";ite1 = true;} if(widget.item2.length  != 0){te1 = "★☆☆";ite2 = true;} if(widget.item3.length  != 0){te2 = "★★☆";ite3 = true;} if(widget.item4.length  != 0){te3 = "★★★";ite4 = true;}});
   Future.delayed(Duration(seconds: 2)).then((_) {add();});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
     child: Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        title: FittedBox(fit: BoxFit.fitWidth, child: Text("", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,), textAlign: TextAlign.center,),),
        iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
        automaticallyImplyLeading: false,
        actions: [IconButton(icon: const Icon(Icons.highlight_off,color: Colors.blueGrey,), onPressed: () {int count = 0;Navigator.popUntil(context, (_) => count++ >= 2);},)],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(margin:EdgeInsets.only(top:0),child: Text(te,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20),textAlign: TextAlign.center,),),
            Visibility(visible : ite1,child : Divider(color: Colors.blueGrey,thickness: 3,indent: 150,endIndent: 150,),),
            Container(margin: EdgeInsets.all(10),child: ListView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.item1.length, itemBuilder: (context, index) {
                return Card(elevation: 0,color:Colors.grey[200],child: ListTile(
                  title: Text(widget.item1[index]["Q"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
                  onTap: (){showDialog(context: context, builder: (context) => AlertDialog(title: Text(widget.item1[index]["A"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center), ));},
                ),);},),),
            Container(margin:EdgeInsets.only(top:20),child: Text(te1,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20),textAlign: TextAlign.center,),),
            Visibility(visible : ite2,child : Divider(color: Colors.blueGrey,thickness: 3,indent: 150,endIndent: 150,),),
            Container(child: ListView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.item2.length, itemBuilder: (context, index) {
                return Card(elevation: 0,color:Colors.grey[200],child: ListTile(
                  title: Text(widget.item2[index]["Q"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
                  onTap: (){showDialog(context: context, builder: (context) => AlertDialog(title: Text(widget.item2[index]["A"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center), ));},
                ),);},),),
            Container(margin:EdgeInsets.only(top:20),child: Text(te2,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20),textAlign: TextAlign.center,),),
            Visibility(visible : ite3,child : Divider(color: Colors.blueGrey,thickness: 3,indent: 150,endIndent: 150,),),
            Container(child: ListView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.item3.length, itemBuilder: (context, index) {
                return Card(elevation: 0,color:Colors.grey[200],child: ListTile(
                  title: Text(widget.item3[index]["Q"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
                  onTap: (){showDialog(context: context, builder: (context) => AlertDialog(title: Text(widget.item3[index]["A"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center), ));},
                ),);},),),
            Container(margin:EdgeInsets.only(top:20),child: Text(te3,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20),textAlign: TextAlign.center,),),
            Visibility(visible : ite4,child : Divider(color: Colors.blueGrey,thickness: 3,indent: 150,endIndent: 150,),),
            Container(margin:EdgeInsets.only(bottom:60),child: ListView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.item4.length, itemBuilder: (context, index) {
                return Card(elevation: 0,color:Colors.grey[200],child: ListTile(
                  title: Text(widget.item4[index]["Q"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
                  onTap: (){showDialog(context: context, builder: (context) => AlertDialog(title: Text(widget.item4[index]["A"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center), ));},
                ),);},),),
          ],
        ),
      ),));
  }
  void ankert() {
    DateTime now = DateTime.now();DateFormat outputFormat = DateFormat('yyyy年MM月dd日');date = outputFormat.format(now);
    FirebaseFirestore.instance.collection('result').doc(date).update({"V2Q": FieldValue.arrayUnion([randomString(2) + widget.name + ID ]),});
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
  Future<void> add () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();ID =  prefs.getString("ID")!;
    DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(ID).collection("ミス").doc("ミス");
    switch (widget.name){
      // case "おすすめ" :ref.update({"All": widget.itemAll},);;break;
      case "昨日正解" :ref.update({"All": widget.All},);;break;
      case "7日前正解" :ref.update({"All": widget.All},);;break;
      case "30日前正解" :ref.update({"All": widget.All},);;break;
      case "★" :ref.update({"ミス1": widget.itemAll},);;break;
      case "★★" :ref.update({"ミス2": widget.itemAll},);;break;
      case "★★★" :ref.update({"ミス3": widget.itemAll},);;break;
      default: ref.update({widget.name: widget.itemAll,},);;break;
    }ankert();
  }


}