import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'V4V2.dart';

class V4Check extends StatefulWidget {
  V4Check(this.check,this.ID,this.item);
  List check;String ID;List item;
  @override
  State<V4Check> createState() => _V4CheckState();
}

class _V4CheckState extends State<V4Check> {
  var map = {};var mapD = {};
  var date = "";var name = "";
  var co = 0;
  late TextEditingController _bodyController;
  void initState() {
    super.initState();_bodyController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white,//Colors.blue[200],
          title: Text("やること",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black),),
          iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
          actions: <Widget>[],
          leading: IconButton(icon:  Icon(Icons.arrow_back_ios,color: Colors.blueGrey,), onPressed: () {Navigator.pop(context);},)
        ),
        body: GestureDetector( onTap: () => FocusScope.of(context).unfocus(),
          child:Container(color: Colors.white,
            child: Column(
              children: <Widget>[
            Container(height: 20,),
                Expanded(
                  child: ListView.builder(itemCount: widget.check.length, itemBuilder: (context, index) {
                    return GestureDetector(onTap: () {co = index;start();},
                    child: Card(elevation:0,color:Colors.grey[200],child: Container(margin: EdgeInsets.all(15),color: Colors.transparent,
                        child:Column(children: [
                            Container(margin:EdgeInsets.all(5),width:double.infinity,alignment:Alignment.center,child: Text(widget.check[index]["name"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900]),),),
                             ]))));},),),
                Container(height: 68,color: Colors.white,
                    child:Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(padding: EdgeInsets.symmetric(horizontal: 16.0,),margin:EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5),),
                            child: TextField(controller: _bodyController,decoration: InputDecoration(border: InputBorder.none,),onChanged: (String value) {setState(() {name = value;});},),),
                        ),
                        IconButton(
                          onPressed: () {send();FocusScope.of(context).requestFocus(new FocusNode());},
                          icon: Icon(Icons.add_task), iconSize: 28, color: Colors.green,
                        ),],))
              ],),),));}
  // send();FocusScope.of(context).requestFocus(new FocusNode());

  Future<void> send() async {
    if (name != ""){
    map = {"name":name};widget.check.insert(0,map);
    DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(widget.ID);
    ref.update({"チェック" : FieldValue.arrayUnion([map]),});setState(() {_bodyController.clear();});
    }name = "";
  }
  void start(){showModalBottomSheet(isScrollControlled: true, context: context,backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) {return Container(
          child: SingleChildScrollView(
            child: Column(children: [
              Container(margin :EdgeInsets.only(top:30),width:100,child: ElevatedButton(
                child: Text('終わった!'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: const StadiumBorder(),),
                onPressed: () {delete();Navigator.pop(context);},)),
              Container(margin: EdgeInsets.only(top:30),width:double.infinity,child:Text("おすすめ",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
              GestureDetector(
                onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V4V2(1500,300,widget.check[co]["name"],widget.ID)));},
                child: Container(margin: EdgeInsets.all(15),color: Colors.grey[200],child:Column(children: [
                  Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("勉強時間:　　0:25:00　　",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                  Container(margin: EdgeInsets.all(5),width:double.infinity,child:Text("休憩時間:　　0:05:00" ,style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),)
                ],), ) ,
              ),
              GestureDetector(
                onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V4V2(750,150,widget.check[co]["name"],widget.ID)));},
                child: Container(margin: EdgeInsets.only(left:15,right:15,bottom: 5),color: Colors.grey[200],child:Column(children: [
                  Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("勉強時間:　　0:12:30　　",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                  Container(margin: EdgeInsets.all(5),width:double.infinity,child:Text("休憩時間:　　0:02:30" ,style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),)
                ],), ) ,
              ),
              Divider(color: Colors.grey,thickness: 1,indent: 100,endIndent: 100,),
              Container(margin: EdgeInsets.all(10),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(),
                itemCount: widget.item.length, itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V4V2(widget.item[index]["勉強"],widget.item[index]["休憩"],widget.check[co]["name"],widget.ID)));},
                      child: Container(margin: EdgeInsets.all(5),color: Colors.grey[200],child:Column(children: [
                        Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("勉強時間:　　" + '${(widget.item[index]["勉強"] / (60 * 60)).floor()}:${((widget.item[index]["勉強"] % (60 * 60) / 60).floor()).toString().padLeft(2, '0')}:${(widget.item[index]["勉強"] % (60 * 60) % 60).toString().padLeft(2, '0')}',style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                        Container(margin: EdgeInsets.all(5),width:double.infinity,child:Text("休憩時間:　　" +'${(widget.item[index]["休憩"] / (60 * 60)).floor()}:${((widget.item[index]["休憩"] % (60 * 60) / 60).floor()).toString().padLeft(2, '0')}:${(widget.item[index]["休憩"] % (60 * 60) % 60).toString().padLeft(2, '0')}',style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),)
                      ],), )    );
                },),),
            ],),),);});}

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

  Future<void> delete() async {mapD = {"name":widget.check[co]["name"]};
      DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(widget.ID);
      ref.update({"チェック" : FieldValue.arrayRemove([mapD]),});setState(() {widget.check.removeAt(co);});
  }

}