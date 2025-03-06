
import 'dart:math';

import 'package:anki/Create/CreateFirst.dart';
import 'package:anki/Create/CreateQA.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../9090/V4/V4V2.dart';
import 'CreateAll.dart';
import 'CreateQ4.dart';
import 'CreateQAAdd.dart';

class Group extends StatefulWidget {
  Group(this.ID);
  String ID;
  @override
  State<Group> createState() => _GroupState();
}
class _GroupState extends State<Group> {
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
      appBar: AppBar(backgroundColor: Colors.white,
        title: Text("File共有", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
        iconTheme: IconThemeData(color: Colors.black), centerTitle: true, elevation: 0, actions: [],),
      floatingActionButtonLocation:FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.orange, child: const Icon(Icons.add),
        onPressed: () {StartView();},
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          // Container(margin: EdgeInsets.all(0), alignment: Alignment.center, child: Text("問題を作成", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center,),),
          Container(margin: EdgeInsets.all(20),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(), itemCount: item.length, itemBuilder: (context, index) {
            return GestureDetector(onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupV(item[index]["GID"],item[index]["name"])));},
                child: Container(margin: EdgeInsets.all(5),color: Colors.grey[200],child:Column(children: [
                  Container(margin: EdgeInsets.all(20),width:double.infinity,child:Text(item[index]["name"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                ],), )    );},),),
          SizedBox(height: 35,)],),),);
  }

  void first () async {
    FirebaseFirestore.instance.collection('users').where("ID" ,isEqualTo: widget.ID).get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {setState(() {item = doc["グループ"];});;});});}

  void StartView() {
    showModalBottomSheet(isScrollControlled: true,context: context,backgroundColor: Colors.white,
      shape:  const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) { return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Container(child:SingleChildScrollView(
                child: Column(children: <Widget>[
                  Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupAdd(widget.ID))).then((value) => first ());},
                    child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("File作成",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),),
                  Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupJoin(widget.ID))).then((value) => first ());},
                    child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("File参加",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),),
                    ],)),);});}, );}

}

class GroupV extends StatefulWidget {
  GroupV(this.GID,this.name,);
  String GID;String name;
  @override
  State<GroupV> createState() => _GroupVState();
}
class _GroupVState extends State<GroupV> {
  var map = {};var mapD = {};var ID = "";
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
      appBar: AppBar(backgroundColor: Colors.white,
        title: Text(widget.name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
        iconTheme: IconThemeData(color: Colors.black), centerTitle: true, elevation: 0, actions: [],),
      floatingActionButtonLocation:FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.orange, child:  Icon(Icons.add),
        onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyGroupAdd(widget.GID))).then((value) => first ());},),
      body: SingleChildScrollView(
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Container(margin :EdgeInsets.only(top:10,right:5,),child:Text("FileID:",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 10))),
            Container(margin :EdgeInsets.only(top:10,bottom: 0),child:SelectableText(widget.GID,style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 10))),
          ]),// Container(margin: EdgeInsets.all(0), alignment: Alignment.center, child: Text("問題を作成", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center,),),
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
    FirebaseFirestore.instance.collection('グループ').where("GID" ,isEqualTo: widget.GID).get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {setState(() {item = doc["問題集"];});;});});}

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
                  Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {delete(index);},
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
  Future<void> delete(index) async {
    showDialog(context: context, builder: (context) =>  AlertDialog(title: Text('削除しますか？',style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
      actions: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center,children: [
          Container(margin :EdgeInsets.only(right:10),width:100,child: ElevatedButton(child: Text('はい'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: const StadiumBorder(),),
            onPressed: () {DocumentReference ref = FirebaseFirestore.instance.collection('グループ').doc(widget.GID);
            setState(() {ref.update({"問題集" : FieldValue.arrayRemove([item[index]]),});item.removeAt(co); Navigator.pop(context);Navigator.pop(context);});},)),
          Container(margin :EdgeInsets.only(left:10),width:100,child: ElevatedButton(child: Text('いいえ'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: const StadiumBorder(),),
            onPressed: () {Navigator.pop(context);},)),
        ],)
      ],));
  }
}

class MyGroupAdd extends StatefulWidget {
  MyGroupAdd(this.GID);
  String GID;
  @override
  State<MyGroupAdd> createState() => _MyGroupAddState();
}
class _MyGroupAddState extends State<MyGroupAdd> {
  var map = {};var mapD = {};var ID = "";
  var date = "";var name = "";
  var co = 0;var select = 0;
  var item = [];

  void initState() {
    super.initState();first ();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
       // title: FittedBox(fit: BoxFit.fitWidth, child: Text("Create", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center,),),
        iconTheme: IconThemeData(color: Colors.black), centerTitle: true,
        elevation: 0,
        actions: [],),
      body: SingleChildScrollView(
        child: Column(children: [
          // Container(margin: EdgeInsets.all(0), alignment: Alignment.center, child: Text("問題を作成", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center,),),
          Container(margin: EdgeInsets.all(20),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(), itemCount: item.length, itemBuilder: (context, index) {
            return GestureDetector(onTap: () {attention(index);},
                child: Container(margin: EdgeInsets.all(5),color: Colors.grey[200],child:Column(children: [
                  Container(margin: EdgeInsets.all(20),width:double.infinity,child:Text(item[index]["name"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                ],), )    );},),),
          SizedBox(height: 35,)],),),);
  }

  void first () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();ID = prefs.getString("ID") ?? "";
    FirebaseFirestore.instance.collection('users').where("ID" ,isEqualTo: ID).get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {setState(() {item = doc["問題集2"];});;});});}

  void attention(index){showDialog(context: context, builder: (context) => AlertDialog(content: Container(height:200,child:Column(mainAxisAlignment:MainAxisAlignment.center,children: [
    Center(child:Text("『"+ item[index]["name"]+ "』"+ "を追加しますか?",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,)),
    Container(margin :EdgeInsets.only(top:10),width:100,child: ElevatedButton(
      child: Text('はい'), style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey[900], foregroundColor: Colors.white, shape: const StadiumBorder(),),
      onPressed: () {
        var map = {"UID":item[index]["UID"],"QID":item[index]["QID"],"name":item[index]["name"],"カテゴリー":item[index]["カテゴリー"],"秒数":item[index]["秒数"],"公開":item[index]["公開"],"レベル":item[index]["レベル"]};
        DocumentReference ref2 = FirebaseFirestore.instance.collection('グループ').doc(widget.GID);
        ref2.update({"問題集" : FieldValue.arrayUnion([map]),});
        Navigator.pop(context);
        },)),],))));}

}




class GroupAdd extends StatefulWidget {
  GroupAdd(this.ID);
  String ID;
  @override
  State<GroupAdd> createState() => _GroupAddState();
}

class _GroupAddState extends State<GroupAdd> {
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
      ref.update({"グループ": FieldValue.arrayUnion([Umap]),});
      //QID
      DocumentReference ref2 = FirebaseFirestore.instance.collection('グループ').doc(QID);
      ref2.set({"問題集" : [],"GID":QID,"グループ名":name});
      Navigator.pop(context);
    }
    if(isOn == false){
      DocumentReference ref3 = FirebaseFirestore.instance.collection('教材集').doc("教材集");
      ref3.update({"教材集": FieldValue.arrayUnion([Umap]),});;
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


class GroupJoin extends StatefulWidget {
  GroupJoin(this.ID);
  String ID;
  @override
  State<GroupJoin> createState() => _GroupJoinState();
}

class _GroupJoinState extends State<GroupJoin> {
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
              FirebaseFirestore.instance.collection('グループ').where("GID" ,isEqualTo: name).get().then((QuerySnapshot snapshot) {
                snapshot.docs.forEach((doc) {setState(() {
                 var  GID = doc["GID"]; var  name = doc["グループ名"]??"";
              if (name != "" ){
                Umap = {"UID":widget.ID,"GID":GID,"name":name,};
                DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(widget.ID);
                ref.update({"グループ": FieldValue.arrayUnion([Umap]),});
                Navigator.pop(context);
              }else{if(name == ""){showDialog(context: context, builder: (context) => AlertDialog(content: Container(child:Text("タイトルが入力されていません",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,)),),);};}
                });;});});},
          )),
        ],),),));
  }


  Future<void> send() async {
    var QID = randomString(20);
    if (name != "" ){
      Umap = {"UID":widget.ID,"GID":QID,"name":name,};
      DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(widget.ID);
      ref.update({"グループ": FieldValue.arrayUnion([Umap]),});
      //QID
      DocumentReference ref2 = FirebaseFirestore.instance.collection('グループ').doc(QID);
      ref2.set({"問題集" : [],"GID":QID,"グループ名":name});
      Navigator.pop(context);
    }
    if(name == ""){showDialog(context: context, builder: (context) => AlertDialog(content: Container(child:Text("タイトルが入力されていません",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,)),),);};
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