import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class V3V2 extends StatefulWidget {
  V3V2(this.name);
  String name;
  @override
  State<V3V2> createState() => _V3V2State();
}

class _V3V2State extends State<V3V2> {
  var item = [];
  var map = {};
  var ID = "";var date = "";var name = "";
  var co = 0;
  late TextEditingController _bodyController;
  void initState() {
    super.initState();_bodyController = TextEditingController();
    date1 (); _loadData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white,//Colors.blue[200],
          title: Text(widget.name,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black),),
          iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
          actions: <Widget>[],
        ),
        body: GestureDetector( onTap: () => FocusScope.of(context).unfocus(),
          child:Container(color: Colors.blue[200],
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(reverse:true,itemCount: item.length, itemBuilder: (context, index) {
                    return Card(elevation:0,color:Colors.blue[200],child: Container(margin: EdgeInsets.all(5),color: Colors.transparent,
                        child:Column(children: [
                          Container(margin:EdgeInsets.all(5),width:double.infinity,alignment:Alignment.center,child: Text(item[index]["曜日"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white,fontSize: 15),),),
                          Container(child:item[index]["ID"] == ID ?Container(decoration: BoxDecoration(color: Colors.orange[200],borderRadius: BorderRadius.circular(10),), margin:EdgeInsets.only(left:0),
                            child:Column(children: [
                              Container(margin:EdgeInsets.only(left: 10,right: 10,top:10,bottom: 10),width:double.infinity,child: Text(item[index]["メッセージ"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 15,height: 1.5,letterSpacing: 2,),),),
                            ],),):
                          Container(decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10),), margin:EdgeInsets.only(right:0),
                            child:Column(children: [
                              Container(margin:EdgeInsets.only(left: 10,right: 10,top:10,bottom: 10),width:double.infinity,child: Text(item[index]["メッセージ"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 15,height: 1.5,letterSpacing: 2,),),),
                            ],),))
                        ])));},),),
                Container(height: 68,color: Colors.white,
                    child:Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(padding: EdgeInsets.symmetric(horizontal: 16.0,),
                            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(40),),
                            child: TextField(controller: _bodyController,decoration: InputDecoration(border: InputBorder.none,),onChanged: (String value) {setState(() {name = value;});},),),
                        ),
                        IconButton(
                          onPressed: () {send();FocusScope.of(context).requestFocus(new FocusNode());},
                          icon: Icon(Icons.send), iconSize: 28, color: Colors.blue,
                        ),],))
              ],),),));}
  // send();FocusScope.of(context).requestFocus(new FocusNode());

  Future<void> _loadData()  async {item = [];  SharedPreferences prefs = await SharedPreferences.getInstance();ID =  prefs.getString("ID")!;
  FirebaseFirestore.instance.collection('トーク').where("name", isEqualTo: widget.name ).get().then((QuerySnapshot snapshot) {
    snapshot.docs.forEach((doc) {setState(() {item = doc["メッセージ"];});});});
  }
  Future<void> send() async {
    if (name != ""){date1();
    map = {"メッセージ":name,"ID":ID,"名前":ID.substring(0,5)+ "さん","曜日":date,};item.insert(0,map);
    DocumentReference ref = FirebaseFirestore.instance.collection('トーク').doc(widget.name);
    ref.update({"メッセージ" : FieldValue.arrayUnion([map]),});setState(() {_bodyController.clear();});
      }name = "";
  }

  Future<void> attention() async {
    map = {"番号":co,"メッセージ":item[co]["メッセージ"],"名前":item[co]["名前"],"板名":widget.name,"曜日":item[co]["曜日"]};
    DocumentReference ref = FirebaseFirestore.instance.collection('管理').doc("通報");
    ref.update({"メッセージ" : FieldValue.arrayUnion([map]),});//Navigator.pop(context);
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
  void date1 (){DateTime now = DateTime.now();DateFormat outputFormat = DateFormat('MM/dd  hh:mm');date = outputFormat.format(now);}


}