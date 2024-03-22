import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../アカウント/SignUp.dart';
import 'V3V2.dart';

class V3 extends StatefulWidget {
  @override
  State<V3> createState() => _V3State();
}

class _V3State extends State<V3> {
  var item = ["やる気が出ない人々","これから勉強するぞ!の人々","ひと休憩の人々","目標を掲げる人々","雑談したい人々","誰でも良いから悩みを聞いて欲しい人々","中1の人々","中2の人々","中3の人々","高1の人々","高2の人々","高3の人々","大学生の人々","社会人の人々"];
 var ID  = "";
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
        actions: [IconButton(icon:  Icon(Icons.info_outline,color: Colors.blue,size: 30,), onPressed: () {start();},)],
      ),
      body: SingleChildScrollView(
          child: Container(margin: EdgeInsets.all(10),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(),
              itemCount: item.length, itemBuilder: (context, index) {
                return Card(elevation: 0,color:Colors.grey[200],child: ListTile(
                  title: Text(item[index],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
                  onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => V3V2(item[index])),);},
                ),);},),),
      ),);
  }
  void start(){showModalBottomSheet(isScrollControlled: true, context: context,
      shape: const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) {return Container(height: 500,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(children: [
          Container(margin: EdgeInsets.only(top: 30),color: Colors.transparent, width: double.infinity, alignment: Alignment.center, child:Icon(Icons.rule,color: Colors.blueGrey[800],size: 60,)),
          Container(margin: EdgeInsets.only(top: 20),color: Colors.transparent, width: double.infinity, alignment: Alignment.center, child: Text("悪口を言わない", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center,)),
        Container(margin: EdgeInsets.only(top: 20),color: Colors.transparent, width: double.infinity, alignment: Alignment.center, child: Text("下ネタを言わない", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center,)),
        Container(margin: EdgeInsets.only(top: 20),color: Colors.transparent, width: double.infinity, alignment: Alignment.center, child: Text("暴力的なことを言わない", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center,)),
        Container(margin: EdgeInsets.only(top: 20),color: Colors.transparent, width: double.infinity, alignment: Alignment.center, child: Text("不快なことを言わない", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center,)),
        Container(margin: EdgeInsets.only(top: 20),color: Colors.transparent, width: double.infinity, alignment: Alignment.center, child: Text("個人情報を載せない", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center,)),
        Container(margin: EdgeInsets.only(top: 20),color: Colors.transparent, width: double.infinity, alignment: Alignment.center, child: Text("勧誘をしない", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center,)),

        ],)));});}
  void sign() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ID = prefs.getString("ID") ?? "";
    if (ID == "") {Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()));}
  }
}


