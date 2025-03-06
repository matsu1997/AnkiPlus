
import 'dart:io';
import 'dart:math';

import 'package:anki/%E3%81%9D%E3%81%AE%E4%BB%96/Support.dart';
import 'package:anki/%E3%81%9D%E3%81%AE%E4%BB%96/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Create/CreateAll.dart';
import '../Create/CreateQA.dart';
import '../Create/CreateQAAdd.dart';
import '../Create/CreateV1.dart';
import '../Create/Group.dart';
import '../その他/LOVE.dart';
import '../アカウント/FirstQ.dart';
import '../アカウント/SignUp.dart';
import 'V10Add.dart';

class V10 extends StatefulWidget {

  @override
  State<V10> createState() => _V10State();
}

class _V10State extends State<V10> {
   var item = []; //Icons.history
  var item1 = [LineIcons.font, LineIcons.pen,LineIcons.torah,LineIcons.fileInvoice, LineIcons.globe, LineIcons.map, LineIcons.bug, LineIcons.plusSquare,LineIcons.history,LineIcons.heart];
  final _pageController = PageController(viewportFraction: 0.877);final flnp = FlutterLocalNotificationsPlugin();
  double currentPage = 0;
  var ID  = "";


  void initState() {
     super.initState();first ();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        title:  Text("", style: TextStyle(color: Colors.blueGrey[300], fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center,), centerTitle: true,elevation: 0,
        actions: <Widget>[
          Row(children: [
            IconButton(onPressed: () {StartView();}, icon: Icon(Icons.add,color: Colors.blueGrey[300],)),
            IconButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) =>   V10V2(ID))).then((value) => first ()); }, icon: Icon(Icons. file_copy_outlined,color: Colors.blueGrey[300],)),])],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(margin: EdgeInsets.only(top: 0, bottom: 30),
              child: GridView.count(padding: EdgeInsets.all(20.0),
                  crossAxisCount: 4, crossAxisSpacing: 5.0, mainAxisSpacing: 5.0, childAspectRatio: 0.9, shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                  children: List.generate(item.length, (index) {
                    return GestureDetector(onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V10V(item[index]["GID"],item[index]["name"],item,index)));},
                        child: Container(alignment: Alignment.center,decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), ),
                          child: Column(children: <Widget>[
                            Container(child: Icon(LineIcons.book, color: Colors.black, size: 60,)),
                            Container(margin: EdgeInsets.only(top:0,left: 3,right: 3), child: Text(item[index]["name"], style: TextStyle( overflow: TextOverflow.ellipsis, color: Colors.black,  fontSize: 10,),maxLines: 2,textAlign:TextAlign.center,)),
                          ]),));}))),
          Container(height: 50,color: Colors.white,)
        ],),),);
  }

   void StartView() {
     showModalBottomSheet(isScrollControlled: true,context: context,backgroundColor: Colors.white,
       shape:  const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
       builder: (context) { return StatefulBuilder(
           builder: (context, StateSetter setState) {
             return Container(child:SingleChildScrollView(
                 child: Column(children: <Widget>[
                   Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V10FileAdd (ID))).then((value) => first ()); },
                     child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("ファイル作成",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),),
                   Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V10EveryOne())).then((value) => first ());},
                     child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("みんなのファイル",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),),
                   Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V10Join(ID))).then((value) => first ());},
                     child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("ID検索",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),),
                 ],)),);});}, );}

  void first () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ID = prefs.getString("ID") ?? "";
    FirebaseFirestore.instance.collection('users').where("ID" ,isEqualTo: ID).get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {setState(() {item = doc["教材"]??[];});;});});}
}


class V10V2 extends StatefulWidget {
  V10V2(this.ID);
  String ID;
  @override
  State<V10V2> createState() => _V10V2State();
}
class _V10V2State extends State<V10V2> {
  var map = {};var mapD = {};var id = "";
  var date = "";var name = "";
  var co = 0;var select = 0;
  late TextEditingController _bodyController;
  var item = [];

  void initState() {
    super.initState();first ();_bodyController = TextEditingController();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,iconTheme: IconThemeData(color: Colors.black),
        // title: FittedBox(fit: BoxFit.fitWidth, child: Text("Create", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center,),),
        // iconTheme: IconThemeData(color: Colors.black), centerTitle: true,
        elevation: 0,
        actions: [Row(children: [
          IconButton(onPressed: () => {Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateV3(widget.ID)))}, icon: Icon(Icons.do_disturb_alt, color: Colors.black),)
        ],)],),
      floatingActionButtonLocation:FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.black, child: const Icon(Icons.create_new_folder),
        onPressed: () {
          // AddVsiew();
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => V10Add(widget.ID,1))).then((value) => first ());
        },
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          // Container(margin: EdgeInsets.all(0), alignment: Alignment.center, child: Text("問題を作成", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center,),),
          Container(margin: EdgeInsets.all(20),child: ListView.builder(reverse: true,shrinkWrap: true, physics:  NeverScrollableScrollPhysics(), itemCount: item.length, itemBuilder: (context, index) {
            return GestureDetector(onTap: () {co = index;StartView();},
                child: Container(margin: EdgeInsets.all(5),color: Colors.grey[200],child:Column(children: [
                  Container(margin: EdgeInsets.all(20),width:double.infinity,child:Text(item[index]["name"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                ],), )    );},),),
          SizedBox(height: 35,)],),),);
  }

  void first () async {
    FirebaseFirestore.instance.collection('users').where("ID" ,isEqualTo: widget.ID).get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {setState(() {item = doc["問題集2"];});;});});}

  void StartView() {
    showModalBottomSheet(isScrollControlled: true,context: context,backgroundColor: Colors.white,
      shape:  const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) { return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Container(child:SingleChildScrollView(
                child: Column(children: <Widget>[
                  Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateAll("自作",item[co]["UID"],item[co]["QID"],0,item[co]["秒数"],item[co],0)));},
                    child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("一覧",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),),
                  Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {select = 0;Connect();},
                    child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("問題→解答",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),),
                  Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {select = 1;Connect();},
                    child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("解答→問題",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),),
                  Container(child: (item[co]["UID"] == widget.ID)?
                  Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateQAAdd(widget.ID,item[co]["QID"],item[co]["name"],co,item))).then((value) => first ());;},
                    child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("編集",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),)
                      :Container()),
                  Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {delete();},
                    child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("削除",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),)
                ],)),);});}, );}

  void Connect() async{
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      showDialog(context: context, builder: (context) => AlertDialog(title:Container(child: Column(children: [
        Container(child:  Text("インターネットに接続されていません。",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center)),
      ],),)  ));} else{
      if(select == 0){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateQA("自作",item[co]["UID"],item[co]["QID"],0,item[co]["秒数"],item[co],0)));
      }else{
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateQA("自作",item[co]["UID"],item[co]["QID"],1,item[co]["秒数"],item[co],0)));  }}

  }

  void AddVsiew() {
    showModalBottomSheet(isScrollControlled: true,context: context,backgroundColor: Colors.white,
      shape:  const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) { return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Container(height: 200 +MediaQuery.of(context).viewInsets.bottom,
              child:SingleChildScrollView(
                  child: Column(children: <Widget>[
                    Container(margin: EdgeInsets.all(20),width:double.infinity,child:Text("タイトル",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                    Container(padding: EdgeInsets.symmetric(horizontal: 16.0,),margin:EdgeInsets.only(left: 10,right:10),
                      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5),),
                      child: TextField(controller: _bodyController,decoration: InputDecoration(border: InputBorder.none,),onChanged: (String value) {setState(() {name = value;});},),),
                    Container(margin :EdgeInsets.only(top:20,bottom: 20),width:100,child: ElevatedButton(
                      child: Text('登録'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, foregroundColor: Colors.white, shape: const StadiumBorder(),),
                      onPressed: () {
                        if (name != ""){id = randomString(20);
                        map = {"name":name,"ID":id};item.insert(0,map);
                        DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(widget.ID);
                        ref.update({"問題集": FieldValue.arrayUnion([map]),});
                        FirebaseFirestore.instance.collection('users').doc(widget.ID).collection("問題集").doc(id).set({"問題":[],"ID":id});
                        setState(() {_bodyController.clear();});
                        }name = "";Navigator.pop(context);
                      },)),],)),);});}, );}

  Future<void> delete() async {
    showDialog(context: context, builder: (context) =>  AlertDialog(title: Text('削除しますか？',style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
      actions: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center,children: [
          Container(margin :EdgeInsets.only(right:10),width:100,child: ElevatedButton(child: Text('はい'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: const StadiumBorder(),),
            onPressed: () {DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(widget.ID);;ref.collection("問題集").doc(item[co]["ID"]).delete();
            setState(() {item.removeAt(co);}); ref.update({"問題集2" : item,});Navigator.pop(context);Navigator.pop(context);},)),
          Container(margin :EdgeInsets.only(left:10),width:100,child: ElevatedButton(child: Text('いいえ'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: const StadiumBorder(),),
            onPressed: () {Navigator.pop(context);},)),
        ],)
      ],));
  }

  Future<void> open() async {
    showDialog(context: context, builder: (context) =>  AlertDialog(title: Text('他のユーザーに公開しますか？',style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
      actions: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center,children: [
          Container(margin :EdgeInsets.only(right:10),width:100,child: ElevatedButton(child: Text('はい'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: const StadiumBorder(),),
            onPressed: () {FirebaseFirestore.instance.collection('users').doc(widget.ID).set({});Navigator.pop(context);Navigator.pop(context);},)),
          Container(margin :EdgeInsets.only(left:10),width:100,child: ElevatedButton(child: Text('いいえ'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: const StadiumBorder(),),
            onPressed: () {Navigator.pop(context);},)),
        ],)
      ],));
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
}


class V10V extends StatefulWidget {
  V10V(this.GID,this.name,this.item,this.co);
  String GID;String name;List item;int co;
  @override
  State<V10V> createState() => _V10VState();
}
class _V10VState extends State<V10V> {
  var map = {};var mapD = {};var ID = "";
  var date = "";var name = "";
  var co = 0;var select = 0;
  late TextEditingController _bodyController;
  var item = [];var open = false;

  void initState() {
    super.initState();first ();_bodyController = TextEditingController();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        title: Text(widget.name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
        iconTheme: IconThemeData(color: Colors.black), centerTitle: true, elevation: 0, actions: [],),
      floatingActionButtonLocation:FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton:  Container(child:ID == widget.item[widget.co]["UID"]?FloatingActionButton(backgroundColor: Colors.orange, child:  Icon(Icons.add),onPressed: () {StartView2();},):Container()),
      body: SingleChildScrollView(
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Container(margin :EdgeInsets.only(top:10,right:5,),child:Text("FileID:",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 10))),
            Container(margin :EdgeInsets.only(top:10,bottom: 0),child:SelectableText(widget.GID,style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 10))),
          ]),
          Container(margin:EdgeInsets.only(top:10,bottom: 0),height:30,child:ID == widget.item[widget.co]["UID"]? Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Container(child: Text("非公開にする",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,),),
            Switch(value: open, onChanged: (bool? value) {if (value != null) {setState(() {open = value;swi();});}},)]):Container()),
// Container(margin: EdgeInsets.all(0), alignment: Alignment.center, child: Text("問題を作成", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center,),),
          Container(margin: EdgeInsets.all(20),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(), itemCount: item.length, itemBuilder: (context, index) {
            return GestureDetector(onTap: () {
              co = index;StartView(index);
            },
                child: Container(margin: EdgeInsets.all(5),color: Colors.grey[200],child:Column(children: [
                  Container(margin: EdgeInsets.all(20),width:double.infinity,child:Text(item[index]["name"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                ],), )    );},),),
          SizedBox(height: 35,)],),),);
  }

  void first () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ID = prefs.getString("ID") ?? "";
    FirebaseFirestore.instance.collection('教材').where("GID" ,isEqualTo: widget.GID).get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {setState(() {item = doc["教材"];open = doc["公開"];});;});});}

  void StartView(index) {
    var count = item[co]["秒数"];print(count);
    FirebaseFirestore.instance.collection('users').where("ID" ,isEqualTo: ID).get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {setState(() {var item2 = doc["問題集2"];
      for(int i = 0; i< item2.length; i++){if(item2[i]["QID"] == item[co]["QID"]){count = item2[i]["秒数"];print(count); }else{print("count"); }}
      });;});});
    showModalBottomSheet(isScrollControlled: true,context: context,backgroundColor: Colors.white,
      shape:  const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) { return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Container(child:SingleChildScrollView(
                child: Column(children: <Widget>[
                  Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateAll("自作",item[co]["UID"],item[co]["QID"],0,item[co]["秒数"],item[co],0)));},
                    child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("一覧",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),),
                  Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {select = 0;Connect(count);},
                    child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("問題→解答",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),),
                  Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {select = 1;Connect(count);},
                    child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("解答→問題",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),),
                  Container(child: (item[co]["UID"] == ID)?
                  Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {Navigator.pop(context);Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateQAAdd(ID,item[co]["QID"],item[co]["name"],co,item))).then((value) => first ());;},
                    child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("編集",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),)
                      :Container()),
                Container(child: (item[co]["UID"] == ID)?
                Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {delete(index);},
                    child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("削除",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),) :Container()),
                ],)),);});}, );}

  void Connect(count) async{
  final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      showDialog(context: context, builder: (context) => AlertDialog(title:Container(child: Column(children: [
        Container(child:  Text("インターネットに接続されていません。",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center)),
      ],),)  ));} else{
      if(select == 0){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateQA("自作",item[co]["UID"],item[co]["QID"],0,count,item[co],0)));
      }else{
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateQA("自作",item[co]["UID"],item[co]["QID"],1,count,item[co],0)));  }}
  }
  Future<void> delete(index) async {
    showDialog(context: context, builder: (context) =>  AlertDialog(title: Text('削除しますか？',style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
      actions: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center,children: [
          Container(margin :EdgeInsets.only(right:10),width:100,child: ElevatedButton(child: Text('はい'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: const StadiumBorder(),),
            onPressed: () {DocumentReference ref = FirebaseFirestore.instance.collection('教材').doc(widget.GID);
            setState(() {ref.update({"教材" : FieldValue.arrayRemove([item[index]]),});item.removeAt(co); Navigator.pop(context);Navigator.pop(context);});},)),
          Container(margin :EdgeInsets.only(left:10),width:100,child: ElevatedButton(child: Text('いいえ'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: const StadiumBorder(),),
            onPressed: () {Navigator.pop(context);},)),
        ],)
      ],));
  }
  void swi(){
    var map = {"UID":widget.item[widget.co]["UID"],"GID":widget.item[widget.co]["GID"],"name":widget.item[widget.co]["name"],"カテゴリー":widget.item[widget.co]["カテゴリー"],"公開":open,"レベル":widget.item[widget.co]["レベル"]};
    widget.item[widget.co] = map;
    DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(ID);
    setState(() {}); ref.update({"教材" : widget.item,});

    DocumentReference ref2 = FirebaseFirestore.instance.collection('教材').doc(widget.item[widget.co]["GID"]);
    setState(() {}); ref2.update({"公開" : open});

    var map2 = {"UID":widget.item[widget.co]["UID"],"GID":widget.item[widget.co]["GID"],"name":widget.item[widget.co]["name"],"カテゴリー":widget.item[widget.co]["カテゴリー"],"公開":false,"レベル":widget.item[widget.co]["レベル"]};
    DocumentReference ref1 = FirebaseFirestore.instance.collection('問題集').doc("教材");
    if(open == false){ref1.update({"教材公開" : FieldValue.arrayUnion([map]),});
    }else{ref1.update({"教材公開" : FieldValue.arrayRemove([map2]),});}
  }

  void StartView2() {
    showModalBottomSheet(isScrollControlled: true,context: context,backgroundColor: Colors.white,
      shape:  const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) { return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Container(child:SingleChildScrollView(
                child: Column(children: <Widget>[
                  Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V10Add(widget.GID,0))).then((value) => first ());},
                    child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("作成",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),),
                  Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { Navigator.of(context).push(MaterialPageRoute(builder: (context) => V10AddLast(widget.GID))).then((value) => first ());},
                    child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("作成済み",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),),
                      ],)),);});}, );}
}



class V10FileAdd extends StatefulWidget {
  V10FileAdd (this.ID);
  String ID;
  @override
  State<V10FileAdd > createState() => _V10FileAddState();
}

class _V10FileAddState extends State<V10FileAdd > {
  var Qmap = {}; var Umap = {};var name = "";
  var grade = "レベル";var category = "カテゴリー";
  late TextEditingController _bodyController;
  late TextEditingController _bodyController2;
  var isOn = false;
  var count = 2;

  void initState() {
    super.initState();_bodyController = TextEditingController();_bodyController2 = TextEditingController();  }

  @override
  Widget build(BuildContext context) {
    return   GestureDetector(onTap: () => primaryFocus?.unfocus(),child:Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
        actions: [TextButton(onPressed: () {send();}, child: Text("保存",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.orange,fontSize: 20),textAlign: TextAlign.center,),)],
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(padding: EdgeInsets.symmetric(horizontal: 10.0,),margin: EdgeInsets.only(top:10,left: 30,right: 30,bottom: 10),width:double.infinity,height:50,
            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5),),
            child: TextField(controller: _bodyController,decoration: InputDecoration(border: InputBorder.none,hintText: "タイトル・教材名"),onChanged: (String value) {setState(() {name = value;});},),),
          Container(margin: EdgeInsets.only(top:10,left: 30,right: 30,bottom: 10),width:double.infinity,height:50,decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5)),child:TextButton(onPressed: () {SearchShow();},
              child: Align(alignment: Alignment.centerLeft, child: Text(category,style: TextStyle(color: Colors.blueGrey[900]), textAlign: TextAlign.left),  ))),
          Container(margin: EdgeInsets.only(top:10,left: 30,right: 30,bottom: 10),width:double.infinity,height:50,decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5)),child:TextButton(onPressed: () {grade1();},
              child: Align(alignment: Alignment.centerLeft, child: Text(grade,style: TextStyle(color: Colors.blueGrey[900]), textAlign: TextAlign.left),  ))),
          Container(margin:EdgeInsets.only(top:10,bottom: 10),height:30,child:Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Container(child: Text("非公開にする",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,),),
            Switch(value: isOn, onChanged: (bool? value) {if (value != null) {setState(() {isOn = value;});}},),
          ],)),
        ],),),));
  }


  // Future<void> send() async {
  //   var QID = randomString(20);
  //   if (name != "" && category != "カテゴリー"  &&  grade != "レベル" ){
  //     Umap = {"UID":widget.ID,"GID":QID,"name":name,};
  //     DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(widget.ID);
  //     ref.update({"グループ": FieldValue.arrayUnion([Umap]),});
  //     //QID
  //     DocumentReference ref2 = FirebaseFirestore.instance.collection('グループ').doc(QID);
  //     ref2.set({"問題集" : [],"GID":QID,"グループ名":name});
  //     Navigator.pop(context);
  //   }
  //   if(name == ""){showDialog(context: context, builder: (context) => AlertDialog(content: Container(child:Text("タイトルが入力されていません",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,)),),);};
  //   }
  Future<void> send() async {
    var QID = randomString(20);
    if (name != "" && category != "カテゴリー"  &&  grade != "レベル" ){
      Umap = {"UID":widget.ID,"GID":QID,"name":name,"カテゴリー":category,"公開":isOn,"レベル":grade};
      DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(widget.ID);
      ref.update({"教材": FieldValue.arrayUnion([Umap]),});
      //QID
      DocumentReference ref2 = FirebaseFirestore.instance.collection('教材').doc(QID);
      ref2.set({"教材" : [],"UID":widget.ID,"GID":QID,"グループ名":name,"カテゴリー":category,"公開":isOn,"レベル":grade});
      Navigator.pop(context);
    }

    if(isOn == false){
      DocumentReference ref3 = FirebaseFirestore.instance.collection('問題集').doc("教材");
      ref3.update({"教材公開": FieldValue.arrayUnion([Umap]),});;
    }

    if(name == ""){showDialog(context: context, builder: (context) => AlertDialog(content: Container(child:Text("タイトルが入力されていません",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,)),),);};
    if(category == "カテゴリー"){showDialog(context: context, builder: (context) => AlertDialog(content: Container(child:Text("カテゴリーが選択されていません",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,)),),);};
    if(grade == "レベル"){showDialog(context: context, builder: (context) => AlertDialog(content: Container(child:Text("大体のレベルを選択してください",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,)),),);};
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
  void SearchShow() {
    showModalBottomSheet(isScrollControlled: false,context: context,backgroundColor: Colors.white,
        shape:  const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
        builder: (context) { return  Container(child:SingleChildScrollView(
            child: Column(children: <Widget>[
              SizedBox(height: 30,),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { category = "英語";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("英語",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "数学";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("数学",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "国語";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("国語",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "漢字";setState(() {Navigator.pop(context);});},
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("漢字",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "古文";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("古文",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "漢文単語";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("漢文単語",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "社会"; setState(() {Navigator.pop(context);});},
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("社会",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "世界史";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("世界史",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "日本史";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("日本史",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "理科";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("理科",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "生物";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("生物",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "化学";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("化学",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "物理";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("物理",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "その他";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("その他",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              //   Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {name = "リセット";setState(() {widget.item = item0;}); },
              //     child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("リセット",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
            ],)),);});}

  void grade1() {
    showModalBottomSheet(isScrollControlled: false,context: context,backgroundColor: Colors.white,
        shape:  const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
        builder: (context) { return  Container(child:SingleChildScrollView(
            child: Column(children: <Widget>[
              SizedBox(height: 30,),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { grade = "小学生";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("小学生",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { grade = "中1";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("中1",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { grade = "中2";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("中2",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { grade = "中3";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("中3",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { grade = "高1";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("高1",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { grade = "高2";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("高2",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { grade = "高3";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("高3",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { grade = "大学";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("大学",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { grade = "その他";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("その他",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
            ],)),);});}

}



class V10EveryOne extends StatefulWidget {

  @override
  State<V10EveryOne> createState() => _V10EveryOneState();
}

class _V10EveryOneState extends State<V10EveryOne> {
  var map = {};var mapD = {};var id = "";
  var date = "";var name = "";var grade = "";var category = "";var gradeSelect = "";var categorySelect = "";
  var co = 0;var select = 0;
  late TextEditingController _bodyController;
  var item = [];var itemAll = [];

  void initState() {
    super.initState();first ();_bodyController = TextEditingController();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        title:  Text("みんなのファイル", style: TextStyle(color: Colors.black, fontSize: 15), textAlign: TextAlign.center,), centerTitle: true,elevation: 0,leading: IconButton( onPressed: () { Navigator.pop(context); }, icon: Icon(Icons.arrow_back_ios,color: Colors.black,),),
        //actions: <Widget>[  IconButton(onPressed: () {StartView();}, icon: Icon(Icons.add,color: Colors.blueGrey[300],)),],
      ),
      floatingActionButtonLocation:FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: Row(mainAxisAlignment: MainAxisAlignment.end,children: [
        FloatingActionButton(backgroundColor: Colors.white, child:  Icon(Icons.highlight_off_outlined,color: Colors.black,),
          onPressed: () {setState(() {grade = "";category = "";gradeSelect = "";categorySelect = "";item = itemAll;});},),
        SizedBox(width: 20,),
        FloatingActionButton(backgroundColor: Colors.orange, child: const Icon(Icons.search),
          onPressed: () {SearchKamoku();},),
        SizedBox(width: 20,),
        FloatingActionButton(backgroundColor: Colors.red, child: const Icon(Icons.search),
          onPressed: () {SearchGrade();},),

      ],),
      body:  SingleChildScrollView(
        child: Column(children: [
          Container(margin: EdgeInsets.only(top: 0, bottom: 30),
              child: GridView.count(padding: EdgeInsets.all(20.0),
                  crossAxisCount: 4, crossAxisSpacing: 5.0, mainAxisSpacing: 5.0, childAspectRatio: 0.9, shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                  children: List.generate(item.length, (index) {
                    return GestureDetector(onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V10EveryoneShow(item[index])));},
                        child: Container(alignment: Alignment.center,decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), ),
                          child: Column(children: <Widget>[
                            Container(child: Icon(LineIcons.book, color: Colors.black, size: 60,)),
                            Container(margin: EdgeInsets.only(top:0,left: 3,right: 3), child: Text(item[index]["name"], style: TextStyle( overflow: TextOverflow.ellipsis, color: Colors.blueGrey[900],  fontSize: 10,),maxLines: 2,textAlign:TextAlign.center,)),
                          ]),));}))),
          Container(height: 50,color: Colors.white,)
        ],),),);
  }

  void first () async {
    FirebaseFirestore.instance.collection("問題集").where("タイプ" ,isEqualTo:"教材").get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {setState(() {item = doc["教材公開"];itemAll = doc["教材公開"];
      // for(int i = 0; i< item[i].length; i++){
      //   if(item[in]){}
      // }
      });;});});}

  void StartView() {
    showModalBottomSheet(isScrollControlled: true,context: context,backgroundColor: Colors.white,
      shape:  const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) { return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Container(child:SingleChildScrollView(
                child: Column(children: <Widget>[
                  Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateAll("自作",item[co]["UID"],item[co]["QID"],0,item[co]["秒数"],item[co],1)));},
                    child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("一覧",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),),
                  Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {select = 0;Connect();},
                    child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("問題→解答",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),),
                  Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {select = 1;Connect();},
                    child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("解答→問題",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),),
                  // Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateQAAdd(widget.ID,item[co]["QID"],item[co]["name"],co,item))).then((value) => first ());;},
                  //   child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("編集",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),),
                  // // Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {open();},
                  //     child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("問題集を公開する",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
                ],)),);});}, );}

  void Connect() async{
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      showDialog(context: context, builder: (context) => AlertDialog(title:Container(child: Column(children: [
        Container(child:  Text("インターネットに接続されていません。",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center)),
      ],),)  ));} else{

      if(select == 0){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateQA("自作",item[co]["UID"],item[co]["QID"],0,item[co]["秒数"],item[co],1)));
      }else{
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateQA("自作",item[co]["UID"],item[co]["QID"],1,item[co]["秒数"],item[co],1)));  }}
  }


  void SearchKamoku() {
    showModalBottomSheet(isScrollControlled: false,context: context,backgroundColor: Colors.white,
        shape:  const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
        builder: (context) { return  Container(child:SingleChildScrollView(
            child: Column(children: <Widget>[
              SizedBox(height: 30,),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { category = "英語";setState(() {kamoku (0);Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("英語",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "数学";setState(() {kamoku (0);Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("数学",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "国語";setState(() {kamoku (0);Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("国語",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "漢字";setState(() {kamoku (0);Navigator.pop(context);});},
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("漢字",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "古文";setState(() {kamoku (0);Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("古文",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "漢文単語";setState(() {kamoku (0);Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("漢文単語",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "社会"; setState(() {kamoku (0);Navigator.pop(context);});},
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("社会",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "世界史";setState(() {kamoku (0);Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("世界史",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "日本史";setState(() {kamoku (0);Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("日本史",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "理科";setState(() {kamoku (0);Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("理科",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "生物";setState(() {kamoku (0);Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("生物",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "化学";setState(() {kamoku (0);Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("化学",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "物理";setState(() {kamoku (0);Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("物理",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "その他";setState(() {kamoku (0);Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("その他",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              //   Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {name = "リセット";setState(() {widget.item = item0;}); },
              //     child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("リセット",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
            ],)),);});



  }
  //小学生英語、小学生国語、中１英語、中２世界史、中3国語
  void kamoku (index){
    if(categorySelect == "" && gradeSelect == ""){
      var itemS = item;item = [];
      for(int i = 0; i<itemS.length; i++){
        if(index == 0){if(itemS[i]["カテゴリー"] == category){ setState(() {item.add(itemS[i]);});}}else{
          if(itemS[i]["レベル"] == grade){ setState(() {item.add(itemS[i]);});}}}}
    else{
      if(categorySelect != "" && gradeSelect == ""){
        var itemS = itemAll;item = [];
        for(int i = 0; i<itemS.length; i++){
          if(index == 0){
            if(itemS[i]["カテゴリー"] == category){ setState(() {item.add(itemS[i]);});}}else{
            if(itemS[i]["レベル"] == grade && itemS[i]["カテゴリー"] == category ){ setState(() {item.add(itemS[i]);});}}}
      }
      if(categorySelect == "" && gradeSelect != ""){
        var itemS = itemAll;item = [];
        for(int i = 0; i<itemS.length; i++){
          if(index == 0){
            if(itemS[i]["カテゴリー"] == category && itemS[i]["レベル"] == grade){ setState(() {item.add(itemS[i]);});}}else{
            if(itemS[i]["レベル"] == grade){ setState(() {item.add(itemS[i]);});}
          }}
      }
      if(categorySelect != "" && gradeSelect != ""){
        var itemS = itemAll;item = [];
        for(int i = 0; i<itemS.length; i++){
          if(itemS[i]["カテゴリー"] == category && itemS[i]["レベル"] == grade){ setState(() {item.add(itemS[i]);});}}
      } }

    if (index == 0){categorySelect = "a";}else{gradeSelect = "a";}
  }
  void SearchGrade() {
    showModalBottomSheet(isScrollControlled: false,context: context,backgroundColor: Colors.white,
        shape:  const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
        builder: (context) { return  Container(child:SingleChildScrollView(
            child: Column(children: <Widget>[
              SizedBox(height: 30,),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { grade = "小学生";setState(() {kamoku (1);Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("小学生",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { grade = "中1";setState(() {kamoku (1);Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("中1",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { grade = "中2";setState(() {kamoku (1);Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("中2",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { grade = "中3";setState(() {kamoku (1);Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("中3",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { grade = "高1";setState(() {kamoku (1);Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("高1",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { grade = "高2";setState(() {kamoku (1);Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("高2",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { grade = "高3";setState(() {kamoku (1);Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("高3",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { grade = "大学";setState(() {kamoku (1);Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("大学",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { grade = "その他";setState(() {kamoku (1);Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("その他",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
            ],)),);});}}


class V10EveryoneShow extends StatefulWidget {
  V10EveryoneShow(this.map);
  Map map;
  @override
  State<V10EveryoneShow> createState() => _V10EveryoneShowState();
}
class _V10EveryoneShowState extends State<V10EveryoneShow> {
  var map = {};var mapD = {};var ID = "";
  var date = "";var name = "";
  var co = 0;var select = 0;
  late TextEditingController _bodyController;
  var item = [];
  var tap = "";
  void initState() {
    super.initState();first ();_bodyController = TextEditingController();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        title: Text(widget.map["name"], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
        iconTheme: IconThemeData(color: Colors.black), centerTitle: true, elevation: 0, actions: [],),
      floatingActionButtonLocation:FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: Container(child:ID == widget.map["UID"]?FloatingActionButton(backgroundColor: Colors.orange, child:  Icon(Icons.add), onPressed: () {StartView2();},):Container()),
      body: SingleChildScrollView(
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Container(margin :EdgeInsets.only(top:10,right:5,),child:Text("FileID:",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 10))),
            Container(margin :EdgeInsets.only(top:10,bottom: 0),child:SelectableText(widget.map["GID"],style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 10))),
          ]),
          Container(margin:EdgeInsets.only(top:10,bottom: 0),child:
          (widget.map["UID"] != ID)?
          Column(mainAxisAlignment: MainAxisAlignment.center,children: [
            Container(margin:EdgeInsets.only(),child: (tap == "" )?
            Container(child:IconButton(icon: Icon(Icons.bookmark_add_outlined,color: Colors.orange,size: 30,), onPressed: () {
             var Umap = {"UID":widget.map["UID"],"GID":widget.map["GID"],"name":widget.map["name"],"カテゴリー":widget.map["カテゴリー"],"公開":widget.map["公開"],"レベル":widget.map["レベル"]};
              DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(ID);
              ref.update({"教材": FieldValue.arrayUnion([Umap]),});
            },)) :
            Container(child:IconButton(icon: Icon(Icons.bookmark_add,color: Colors.orange,size: 30,), onPressed: () {},)))
            ,Container(margin:EdgeInsets.only(top:0),child: Text("保存",style: TextStyle(color:Colors.blueGrey[900],fontSize: 10),textAlign: TextAlign.center,),),
          ],):
          Container()
          ),// Container(margin: EdgeInsets.all(0), alignment: Alignment.center, child: Text("問題を作成", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center,),),
          Container(margin: EdgeInsets.all(20),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(), itemCount: item.length, itemBuilder: (context, index) {
            return GestureDetector(onTap: () {
              co = index;StartView(index);
            },
                child: Container(margin: EdgeInsets.all(5),color: Colors.grey[200],child:Column(children: [
                  Container(margin: EdgeInsets.all(20),width:double.infinity,child:Text(item[index]["name"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                ],), )    );},),),
          SizedBox(height: 35,)],),),);
  }

  void first () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ID = prefs.getString("ID") ?? "";
    FirebaseFirestore.instance.collection('教材').where("GID" ,isEqualTo: widget.map["GID"]).get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {setState(() {item = doc["教材"];});;});});}

  void StartView(index) {
    showModalBottomSheet(isScrollControlled: true,context: context,backgroundColor: Colors.white,
      shape:  const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) { return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Container(child:SingleChildScrollView(
                child: Column(children: <Widget>[
                  Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateAll("自作",item[co]["UID"],item[co]["QID"],0,item[co]["秒数"],item[co],0)));},
                    child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("一覧",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),),
                  Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {select = 0;Connect();},
                    child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("問題→解答",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),),
                  Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {select = 1;Connect();},
                    child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("解答→問題",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),),
                  Container(child: (item[co]["UID"] == ID)?
                  Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateQAAdd(ID,item[co]["QID"],item[co]["name"],co,item))).then((value) => first ());;},
                    child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("編集",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),)
                      :Container()),
                    Container(child: (item[co]["UID"] == ID)?Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {delete(index);},
                    child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("削除",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),)),) :Container()),
                ],)),);});}, );}

  void Connect() async{
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      showDialog(context: context, builder: (context) => AlertDialog(title:Container(child: Column(children: [
        Container(child:  Text("インターネットに接続されていません。",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center)),
      ],),)  ));} else{
      if(select == 0){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateQA("自作",item[co]["UID"],item[co]["QID"],0,item[co]["秒数"],item[co],0)));
      }else{
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateQA("自作",item[co]["UID"],item[co]["QID"],1,item[co]["秒数"],item[co],0)));  }}
  }
  Future<void> delete(index) async {
    showDialog(context: context, builder: (context) =>  AlertDialog(title: Text('削除しますか？',style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
      actions: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center,children: [
          Container(margin :EdgeInsets.only(right:10),width:100,child: ElevatedButton(child: Text('はい'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: const StadiumBorder(),),
            onPressed: () {DocumentReference ref = FirebaseFirestore.instance.collection('教材').doc(widget.map["GID"]);
            setState(() {ref.update({"教材" : FieldValue.arrayRemove([item[index]]),});item.removeAt(co); Navigator.pop(context);Navigator.pop(context);});},)),
          Container(margin :EdgeInsets.only(left:10),width:100,child: ElevatedButton(child: Text('いいえ'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: const StadiumBorder(),),
            onPressed: () {Navigator.pop(context);},)),
        ],)
      ],));
  }

  void StartView2() {
    showModalBottomSheet(isScrollControlled: true,context: context,backgroundColor: Colors.white,
      shape:  const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) { return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Container(child:SingleChildScrollView(
                child: Column(children: <Widget>[
                  Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V10Add(widget.map["GID"],0))).then((value) => first ());},
                    child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("作成",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),),
                  Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { Navigator.of(context).push(MaterialPageRoute(builder: (context) => V10AddLast(widget.map["GID"]))).then((value) => first ());},
                    child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("作成済み",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),),
                   ],)),);});}, );}
}




class V10Join extends StatefulWidget {
  V10Join(this.ID);
  String ID;
  @override
  State<V10Join> createState() => _V10JoinState();
}

class _V10JoinState extends State<V10Join> {
  var Qmap = {}; var Umap = {};var name = "";
  late TextEditingController _bodyController;
  void initState() {
    super.initState();_bodyController = TextEditingController();  }

  @override
  Widget build(BuildContext context) {
    return   GestureDetector(onTap: () => primaryFocus?.unfocus(),child:Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
        // actions: [TextButton(onPressed: () {send();}, child: Text("保存",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.orange,fontSize: 20),textAlign: TextAlign.center,),)],
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(padding: EdgeInsets.symmetric(horizontal: 10.0,),margin: EdgeInsets.only(top:10,left: 30,right: 30,bottom: 10),width:double.infinity,height:50,
            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5),),
            child: TextField(controller: _bodyController,decoration: InputDecoration(border: InputBorder.none,hintText: "FileID"),onChanged: (String value) {setState(() {name = value;});},),),
          Container(margin :EdgeInsets.only(top:20,bottom: 20),width:100,child: ElevatedButton(
            child: Text('登録'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, foregroundColor: Colors.white, shape: const StadiumBorder(),),
            onPressed: () {
              FirebaseFirestore.instance.collection('教材').where("GID" ,isEqualTo: name).get().then((QuerySnapshot snapshot) {
                snapshot.docs.forEach((doc) {setState(() {
                   var  name = doc["グループ名"]??"";
                  if (name != "" ){
                    Umap = {"UID":doc["UID"],"GID":doc["GID"],"name":doc["グループ名"],"カテゴリー":doc["カテゴリー"],"公開":doc["公開"],"レベル":doc["レベル"]};
                    DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(widget.ID);
                    ref.update({"教材": FieldValue.arrayUnion([Umap]),});
                    Navigator.pop(context);
                  }else{if(name == ""){showDialog(context: context, builder: (context) => AlertDialog(content: Container(child:Text("タイトルが入力されていません",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,)),),);};}
                });;});});},
          )),
        ],),),));
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
}