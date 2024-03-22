import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../V8.dart';
import '../アカウント/SignUp.dart';
import 'Ankert.dart';


class Support extends StatefulWidget {
  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  var item = [];var map = {};
  var user = "";var name = "";var ID = "";var message0 = "";
  var co = 0;
  get onEng => null;
  late TextEditingController _bodyController;
  var _scrollController = ScrollController();
  void initState() {
    super.initState();_bodyController = TextEditingController();
    sign(); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white,
          title: Text('開発者',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 15),),
          iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
        actions: <Widget>[IconButton(onPressed: () {if (ID == "5k0Taw2GxH7TZyYH4wTM"){Navigator.of(context).push(MaterialPageRoute(builder: (context) => SupportOner()));}else{start();}}, icon: Icon(Icons.flag,size:30,color: Colors.blueGrey[800],))],
        ),
        body: GestureDetector( onTap: () => FocusScope.of(context).unfocus(),
          child:Container(color: Colors.white,
            child: Column(children: <Widget>[
              Expanded(
                child: ListView.builder(reverse: true,controller: _scrollController,itemCount: item.length, itemBuilder: (context, index) {
                  return Card(elevation:0,color:Colors.transparent,child: Container(margin: EdgeInsets.all(5),color: Colors.transparent,
                      child:Column(children: [
                        // Container(margin:EdgeInsets.all(5),width:double.infinity,alignment:Alignment.center,child: Text(item[index]["曜日"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white,fontSize: 15),),),
                        Container(child:item[index]["uid"] == "5k0Taw2GxH7TZyYH4wTM" ?Container(decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)), margin:EdgeInsets.only(left:0),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start,children:[
                            Container(alignment: Alignment.topLeft,margin:EdgeInsets.only(),width: 30, height:30, decoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle,),child: Text(" \n 開",softWrap: true,style: TextStyle(color:Colors.white,fontSize: 15,height: 0.7,letterSpacing: 2.5,),),),//image: DecorationImage(image:AssetImage("images/開発.PNG"), fit: BoxFit.cover,),),),
                            Flexible(child:Container(margin:EdgeInsets.only(left: 10),decoration: BoxDecoration(color: Colors.grey[200],borderRadius: BorderRadius.circular(10)),padding:EdgeInsets.all(10),child: Text(item[index]["メッセージ"],softWrap: true,style: TextStyle(color:Colors.black,fontSize: 15,height: 1.5,letterSpacing: 2,),))),
                            // Container(margin:EdgeInsets.only(left: 10,right: 10,top:10,bottom: 10),width: 40.0, height: 40.0, decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.fill, image: AssetImage("images/you.PNG"))),),
                            // Container(margin:EdgeInsets.only(right: 10,top:10,bottom: 10),child: Text(widget.name  + "様",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 15,height: 1.5,letterSpacing: 2,),),),
                            Column(children: [
                              Container(width: 80,alignment:Alignment.topLeft,margin:EdgeInsets.only(left: 10,top:10,bottom: 5,right: 0),child: Text(item[index]["日付"],style: TextStyle(color:Colors.black,fontSize: 7,height: 1.5,letterSpacing: 2,),)),
                             // Container(width: 80,alignment:Alignment.topLeft,margin:EdgeInsets.only(left: 10,top:0,bottom: 10,right: 0),child: Text("開発者",style: TextStyle(color:Colors.black,fontSize: 10,height: 1.5,letterSpacing: 2,),)),
                            ],) ,]),):
                        Container(decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)), margin:EdgeInsets.only(left:0),
                          child: Row(mainAxisAlignment:MainAxisAlignment.end, children:[
                            Container()
                            ,Container(width: 60,alignment:Alignment.bottomRight,margin:EdgeInsets.only(left: 10,top:10,bottom: 10,right: 10),child: Text(item[index]["日付"],style: TextStyle(color:Colors.black,fontSize: 7,height: 1.5,letterSpacing: 2,),maxLines: 2,)),
                            Flexible(child:Container(margin:EdgeInsets.only(right: 10),decoration: BoxDecoration(color: Colors.orange,borderRadius: BorderRadius.circular(10)),padding:EdgeInsets.all(10),child: Text(item[index]["メッセージ"],softWrap: true,style: TextStyle(color:Colors.black,fontSize: 15,height: 1.5,letterSpacing: 2,),))),
                            // Container(margin:EdgeInsets.only(left: 10,right: 10,top:10,bottom: 10),width: 40.0, height: 40.0, decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.fill, image: AssetImage("images/you.PNG"))),),
                            // Container(margin:EdgeInsets.only(right: 10,top:10,bottom: 10),child: Text(widget.name  + "様",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 15,height: 1.5,letterSpacing: 2,),),),
                          ],),)

                        )])));},),),
              Container(height: 10,),
              Container(color: Colors.grey[100],
                  child:Row(children: <Widget>[
                    Expanded(
                      child: Container(padding: EdgeInsets.symmetric(horizontal: 16.0,),margin: EdgeInsets.only(top: 10,bottom: 10),
                        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(40),),
                        child: TextField(maxLines: null, controller: _bodyController,decoration: InputDecoration(fillColor: Colors.grey[50], filled: true,border: InputBorder.none,hintText: "message"),onChanged: (String value) {setState(() {name = value;});},),),
                    ),
                    Container(margin: EdgeInsets.only(right: 10),child:TextButton(
                      onPressed: () {send();FocusScope.of(context).requestFocus(new FocusNode());}, child: Text("Send",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.orange,fontSize: 15,height: 1.5,letterSpacing: 2,)),
                    )),],)),
              Container(height: 50,),
            ],),),));}
  // send();FocusScope.of(context).requestFocus(new FocusNode());

  void _loadData()  {item = [];
    FirebaseFirestore.instance.collection('users').where("ID" ,isEqualTo: ID).get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {setState(() {item = doc["メッセージ"];
      item = List.from(item.reversed);
      });;});});}

  Future<void> send() async {if(name != ""){DateTime now = DateTime.now();DateFormat outputFormat = DateFormat('yyyy/MM/dd'); var date = outputFormat.format(now);
  map = {"メッセージ":name,"uid":ID,"バグ対策":randomString(5),"日付":date};
  await FirebaseFirestore.instance.collection('users').doc(ID).update({"メッセージ": FieldValue.arrayUnion([map])});
   setState(() {item.insert(0,map);item;});_bodyController.clear();name = "";
  await FirebaseFirestore.instance.collection('管理').doc("メッセージ").update({"uid": FieldValue.arrayUnion([ID])});
  }}

  Future<void> message() async {
    message0 = "ダウンロードありがとうございます!こちらは開発者にメッセージを送れます。内容は「3000英単語覚えるぞ!(目標の宣言)」「今日は3時間勉強できた!(学習報告)」「アプリの不明点」「バグの報告」「開発者への応援メッセージ」など基本なんでもOKです。アプリのお知らせやコラムも投稿させて頂きます。あなた様の学習のお役に立てれば幸いです。\nまだまだ弱小アプリ。少しでも良いなと思ったら是非友達に勧めて下さいね。よろしくお願い致します。";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _counter = prefs.getInt("メッセージ1")?? 0;
    if (_counter == 0){prefs.setInt("メッセージ1",1);
    DateTime now = DateTime.now();DateFormat outputFormat = DateFormat('yyyy/MM/dd'); var date = outputFormat.format(now);
    map = {"メッセージ":message0,"uid":"5k0Taw2GxH7TZyYH4wTM","バグ対策":"メッセージ1","日付":date};
    await FirebaseFirestore.instance.collection('users').doc(ID).update({"メッセージ": FieldValue.arrayUnion([map])});
    //setState(() {item.insert(0,map);item;});
    }
   }

  void sign() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ID = prefs.getString("ID") ?? "";
    if (ID == "") {Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()));}else{message();_loadData();}
  }

  void start(){showModalBottomSheet(isScrollControlled: true, context: context,
      shape: const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) {return Container(height: 300,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Container(child: Icon(Icons.message,size: 80,color:Colors.orange),),
           // Container(margin:EdgeInsets.all(10),child: Text("" ,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20),),),
            Container(margin:EdgeInsets.all(5),child: Text("勉強頑張ったよ報告\nこんな機能あったらいいな\nアプリのご不明\n開発者への応援メッセージなど\nご気軽にメッセージ下さい" ,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.grey,fontSize: 15,height: 2),textAlign: TextAlign.center,),),
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

  // void _getCounterValue() async { SharedPreferences prefs = await SharedPreferences.getInstance();
  // var _counter = prefs.getInt("開発者メッセージ")?? 0;
  // if (_counter == 0){ Navigator.pop(context);Navigator.of(context).push(MaterialPageRoute(builder: (context) => Ankert()),).then((value) {});
  // prefs.setInt("開発者メッセージ",1);}else{}
  // }

}


class SupportOner extends StatefulWidget {
  @override
  State<SupportOner> createState() => _SupportOnerState();
}

class _SupportOnerState extends State<SupportOner> {
  var item = [];var map = {};
  var uid = "";var date = "";var dateSt2 = "";
  var user = "";var name = "";
  var co = 0;
  get onEng => null;
  late TextEditingController _bodyController;
  void initState() {
    super.initState();_bodyController = TextEditingController();
    _loadData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white,
          title: Text('報告',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black),),
          iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
          //actions: <Widget>[IconButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V81()));}, icon: Icon(Icons.flag_circle_rounded,size:30,color: Colors.white,))],
        ),
        body: GestureDetector( onTap: () => FocusScope.of(context).unfocus(),
          child:Container(color: Colors.white,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(),
                    itemCount: item.length, itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => SupportOnerShow(item[index])));},
                          child: Container(margin: EdgeInsets.all(5),color: Colors.grey[200],child:Column(children: [
                            Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text(item[index],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                          ],), )    );
                    },)),
              ],),),));}
  void _loadData()  {item = [];
  FirebaseFirestore.instance.collection('管理').where("管理" ,isEqualTo: "メッセージ").get().then((QuerySnapshot snapshot) {
    snapshot.docs.forEach((doc) {setState(() {item = doc["uid"];
    });;});});}
}



class SupportOnerShow extends StatefulWidget {
  SupportOnerShow(this.ID);
  String ID;
  @override
  State<SupportOnerShow> createState() => _SupportOnerShowState();
}

class _SupportOnerShowState extends State<SupportOnerShow> {
  var item = [];var map = {};
  var user = "";var name = "";
  var co = 0;
  get onEng => null;
  late TextEditingController _bodyController;
  var _scrollController = ScrollController();
  void initState() {
    super.initState();_bodyController = TextEditingController();
    _loadData(); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white,
          title: Text('開発者',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black),),
          iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
          ),
        body: GestureDetector( onTap: () => FocusScope.of(context).unfocus(),
          child:Container(color: Colors.white,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(reverse: true,controller: _scrollController,itemCount: item.length, itemBuilder: (context, index) {
                    return Card(elevation:0,color:Colors.transparent,child: Container(margin: EdgeInsets.all(5),color: Colors.transparent,
                        child:Column(children: [
                          // Container(margin:EdgeInsets.all(5),width:double.infinity,alignment:Alignment.center,child: Text(item[index]["曜日"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white,fontSize: 15),),),
                          Container(child:item[index]["uid"] != "5k0Taw2GxH7TZyYH4wTM" ?Container(decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10), boxShadow: [new BoxShadow(color: Colors.grey, offset: new Offset(1.0, 1.0), blurRadius: 3.0, spreadRadius: 1)],), margin:EdgeInsets.only(left:0),
                            child:Column(children: [
                              Row(children:[
                                Container(margin:EdgeInsets.only(left: 10,right: 10,top:10,bottom: 10),width: 40.0, height: 40.0, decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.fill, image: AssetImage("images/you.PNG"))),),
                                Container(margin:EdgeInsets.only(right: 10,top:10,bottom: 10),child: Text("YOU",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 15,height: 1.5,letterSpacing: 2,),),),
                                Expanded(child: Container(alignment:Alignment.centerRight,margin:EdgeInsets.only(right: 20,top:10,bottom: 10),child: Text(item[index]["日付"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[800],fontSize: 15,height: 1.5,letterSpacing: 2,),)),),
                              ]),
                              Container(margin:EdgeInsets.only(left: 60,right: 10,top:0,bottom: 20),width:double.infinity,child: Text(item[index]["メッセージ"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 15,height: 1.5,letterSpacing: 2,),),),
                            ],),):
                          Container(decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10), boxShadow: [new BoxShadow(color: Colors.grey, offset: new Offset(1.0, 1.0), blurRadius: 3.0, spreadRadius: 1)],), margin:EdgeInsets.only(left:0),
                            child:Column(children: [
                              Row(children:[
                                Container(margin:EdgeInsets.only(left: 10,right: 10,top:10,bottom: 10),width: 40.0, height: 40.0, decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.fill, image: AssetImage("images/開発.PNG"))),),
                                Container(margin:EdgeInsets.only(right: 10,top:10,bottom: 10),child: Text("開発者",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 15,height: 1.5,letterSpacing: 2,),),),
                                Expanded(child: Container(alignment:Alignment.centerRight,margin:EdgeInsets.only(right: 20,top:10,bottom: 10),child: Text(item[index]["日付"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[800],fontSize: 15,height: 1.5,letterSpacing: 2,),)),),
                              ]),
                              Container(margin:EdgeInsets.only(left: 60,right: 10,top:0,bottom: 20),width:double.infinity,child: Text(item[index]["メッセージ"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 15,height: 1.5,letterSpacing: 2,),),),
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

  void _loadData()  {item = [];
  FirebaseFirestore.instance.collection('users').where("ID" ,isEqualTo: widget.ID).get().then((QuerySnapshot snapshot) {
    snapshot.docs.forEach((doc) {setState(() {item = doc["メッセージ"];
    item = List.from(item.reversed);
    });;});});}

  Future<void> send() async {if(name != ""){DateTime now = DateTime.now();DateFormat outputFormat = DateFormat('yyyy/MM/dd'); var date = outputFormat.format(now);
  map = {"メッセージ":name,"uid":"5k0Taw2GxH7TZyYH4wTM","バグ対策":randomString(5),"日付":date};
  await FirebaseFirestore.instance.collection('users').doc(widget.ID).update({"メッセージ": FieldValue.arrayUnion([map])});
  setState(() {item.insert(0,map);item;});_bodyController.clear();name = "";
  await FirebaseFirestore.instance.collection('管理').doc("メッセージ").update({"uid": FieldValue.arrayRemove([widget.ID])});
  }}

  // Future<void> delete() async {map = {"メッセージ":name,"uid":"5k0Taw2GxH7TZyYH4wTM","バグ対策":randomString(5)};
  // await FirebaseFirestore.instance.collection('users').doc(widget.ID).update({"メッセージ": FieldValue.arrayUnion([map])});
  // setState(() {item.insert(0,map);item;});_bodyController.clear();name = "";
  // await FirebaseFirestore.instance.collection('管理').doc("メッセージ").update({"uid": FieldValue.arrayRemove([widget.ID])});
  // }


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
