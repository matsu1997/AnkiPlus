
import 'dart:math';

import 'package:anki/Create/CreateFirst.dart';
import 'package:anki/Create/CreateQA.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import '../9090/V4/V4V2.dart';
import 'CreateAll.dart';
import 'CreateQ4.dart';
import 'CreateQAAdd.dart';
import 'Group.dart';

class Create extends StatefulWidget {
  Create(this.ID);
  String ID;
  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  @override


  void initState() {
    super.initState();}

  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(length: 2,
        child: Scaffold(
          appBar:AppBar(backgroundColor: Colors.white,elevation: 0,
        title:Text("Create", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center,),
             iconTheme: IconThemeData(color: Colors.black), centerTitle: true,
            actions: [Row(children: [
              IconButton(onPressed: () => {Navigator.of(context).push(MaterialPageRoute(builder: (context) => Group(widget.ID)))}, icon: Icon(LineIcons.userFriends, color: Colors.blueGrey[800]),),
              IconButton(onPressed: () => {Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateV3(widget.ID)))}, icon: Icon(Icons.do_disturb_alt, color: Colors.red),)
            ],)],
            bottom: TabBar(indicatorColor: Colors.orange,
              tabs: [
                Tab(child: Text("My",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),),
                Tab(child: Text("Everyone",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),),
              ],),),
          body: TabBarView(
            children: [CreateV1(widget.ID),CreateV2(widget.ID),],
          ),
        ),
      ),
    );
  }



}


class CreateV1 extends StatefulWidget {
  CreateV1(this.ID);
  String ID;
  @override
  State<CreateV1> createState() => _CreateV1State();
}
class _CreateV1State extends State<CreateV1> {
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
        actions: [],),
      floatingActionButtonLocation:FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.orange, child: const Icon(Icons.create_new_folder),
        onPressed: () {
         // AddVsiew();
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateFirst(widget.ID))).then((value) => first ());
        },
      ),
      body: SingleChildScrollView(
        child: Column(children: [
         // Container(margin: EdgeInsets.all(0), alignment: Alignment.center, child: Text("問題を作成", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center,),),
          Container(margin: EdgeInsets.all(20),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(), itemCount: item.length, itemBuilder: (context, index) {
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


class CreateV2 extends StatefulWidget {
  CreateV2(this.ID);
  String ID;
  @override
  State<CreateV2> createState() => _CreateV2State();
}
class _CreateV2State extends State<CreateV2> {
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
      body: SingleChildScrollView(
        child: Column(children: [
          Row(mainAxisAlignment:MainAxisAlignment.start,children: [
            Container(margin: EdgeInsets.only(top:20,left: 30,right: 10), alignment: Alignment.center, child: Text(category, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center,),),
            Container(margin: EdgeInsets.only(top:20,left: 10), alignment: Alignment.center, child: Text(grade, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center,),),
          ],),
          Container(margin: EdgeInsets.only(top:5,left: 20,right: 20,bottom: 20),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(), itemCount: item.length, itemBuilder: (context, index) {
            return GestureDetector(onTap: () {co = index;StartView();},
                child: Container(margin: EdgeInsets.all(5),color: Colors.grey[200],child:Column(children: [
                  Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text(item[index]["name"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                  Container(margin: EdgeInsets.only(top:0,bottom: 5),width:double.infinity,child:
                  Row(mainAxisAlignment:MainAxisAlignment.center,children: [
                  Container(margin: EdgeInsets.only(right:10),child:Text(item[index]["レベル"],style: TextStyle(color: Colors.blueGrey[900],fontSize: 10), textAlign: TextAlign.center)),
                    Container(margin: EdgeInsets.only(left:10,right:10),child:Text(item[index]["カテゴリー"],style: TextStyle(color: Colors.blueGrey[900],fontSize: 10), textAlign: TextAlign.center)),
                    Container(margin: EdgeInsets.only(left:10),child:Text(item[index]["UID"].substring(2, 6) +"さん",style: TextStyle(color: Colors.blueGrey[900],fontSize: 10), textAlign: TextAlign.center)),

                ],))],), )    );},),),
          SizedBox(height: 35,)  ],),),);
  }

  void first () async {
    FirebaseFirestore.instance.collection("問題集").where("タイプ" ,isEqualTo:"問題集").get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {setState(() {item = doc["問題集"];itemAll = doc["問題集"];});;});});}

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
            ],)),);});}



}


class CreateV3 extends StatefulWidget {
  CreateV3(this.ID);
  String ID;
  @override
  State<CreateV3> createState() => _CreateV3State();
}
class _CreateV3State extends State<CreateV3> {
  var map = {};var mapD = {};var id = "";
  var date = "";var name = "";
  var co = 0;var select = 0;
  late TextEditingController _bodyController; late TextEditingController _bodyController2;
  var item = [];
  var category = "カテゴリー";var swi = false;
  var Qmap = {}; var Umap = {};  var isOn = false;var count = 2;var grade = "レベル";
  void initState() {
    super.initState();first ();_bodyController = TextEditingController();_bodyController2 = TextEditingController();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        title:Text("移行", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center,),
       iconTheme: IconThemeData(color: Colors.black), centerTitle: true,
        elevation: 0,
        actions: [],),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(margin: EdgeInsets.all(0), alignment: Alignment.center, child: Text("システム変更に伴い追加登録をお願いします", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center,),),
          Container(margin: EdgeInsets.all(20),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(), itemCount: item.length, itemBuilder: (context, index) {
            return GestureDetector(onTap: () { Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateV3B(widget.ID,index,item))).then((value) => first ());},
                child: Container(margin: EdgeInsets.all(5),color: Colors.grey[200],child:Column(children: [
                  Container(margin: EdgeInsets.all(20),width:double.infinity,child:Text(item[index]["name"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                ],), )    );},),),
        ],),),);
  }

  void first () async {
    FirebaseFirestore.instance.collection('users').where("ID" ,isEqualTo: widget.ID).get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {setState(() {item = doc["問題集"];});;});});}




}


class CreateV3B extends StatefulWidget {
  CreateV3B(this.ID,this.index,this.item);
  String ID;int index;List item;
  @override
  State<CreateV3B> createState() => _CreateV3BState();
}
class _CreateV3BState extends State<CreateV3B> {
  var map = {};var mapD = {};var id = "";
  var date = "";var name = "";
  var co = 0;var select = 0;
  late TextEditingController _bodyController; late TextEditingController _bodyController2;
  var category = "カテゴリー";var swi = false;
  var Qmap = {}; var Umap = {};  var isOn = false;var count = 2;var grade = "レベル";
  void initState() {
    super.initState();_bodyController = TextEditingController();_bodyController2 = TextEditingController();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        title:Text("移行", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center,),
        iconTheme: IconThemeData(color: Colors.black), centerTitle: true,
        elevation: 0,
        actions: [],),
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Container(margin: EdgeInsets.only(top:30,left: 30,right: 30,bottom: 10), alignment: Alignment.center, child: Text(widget.item[widget.index]["name"], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center,),),
            Container(margin: EdgeInsets.only(top:10,left: 30,right: 30,bottom: 10),width:double.infinity,height:50,decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5)),child:TextButton(onPressed: () {SearchShow();},
                child: Align(alignment: Alignment.centerLeft, child: Text(category,style: TextStyle(color: Colors.blueGrey[900]), textAlign: TextAlign.left),  ))),
            Container(margin: EdgeInsets.only(top:10,left: 30,right: 30,bottom: 10),width:double.infinity,height:50,decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5)),child:TextButton(onPressed: () {grade1();},
                child: Align(alignment: Alignment.centerLeft, child: Text(grade,style: TextStyle(color: Colors.blueGrey[900]), textAlign: TextAlign.left),  ))),
            Container(padding: EdgeInsets.symmetric(horizontal: 10.0,),margin: EdgeInsets.only(top:10,left: 30,right: 30,bottom: 10),width:double.infinity,height:50,
              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5),),
              child: TextField(keyboardType: TextInputType.numberWithOptions(decimal: true),controller: _bodyController2,decoration: InputDecoration(border: InputBorder.none,hintText: "解答表示までの秒数(2秒)"),onChanged: (String value) {setState(() {count = int.parse(value);});},),),
            Container(margin:EdgeInsets.only(top:10,bottom: 10),height:30,child:Row(mainAxisAlignment: MainAxisAlignment.center,children: [
              Container(child: Text("非公開にする",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,),),
              Switch(value: isOn, onChanged: (bool? value) {if (value != null) {setState(() {isOn = value;});}},),
            ],)),
            Container(margin :EdgeInsets.only(top:20,bottom: 20),width:100,child: ElevatedButton(
              child: Text('登録'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, foregroundColor: Colors.white, shape: const StadiumBorder(),),
              onPressed: () {

                var QID = widget.item[widget.index]["ID"];
                var name = widget.item[widget.index]["name"];
                if (category != "カテゴリー"  &&  grade != "レベル" ){
                  //UID
                  Umap = {"UID":widget.ID,"QID":QID,"name":name,"カテゴリー":category,"秒数":count,"公開":isOn,"レベル":grade};
                  DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(widget.ID);
                  ref.update({"問題集2": FieldValue.arrayUnion([Umap]),});
                  DocumentReference ref2 = FirebaseFirestore.instance.collection('users').doc(widget.ID);
                  ref.update({"問題集": FieldValue.arrayRemove([{"ID":QID,"name":name}]),});
                //  setState(() { widget.item.removeAt(widget.index);});

                  //公開
                  if(isOn == false){
                    DocumentReference ref3 = FirebaseFirestore.instance.collection('問題集').doc("問題集");
                    ref3.update({"問題集": FieldValue.arrayUnion([Umap]),});;
                  }

                  Navigator.pop(context);
                }
                if(category == "カテゴリー"){showDialog(context: context, builder: (context) => AlertDialog(content: Container(child:Text("カテゴリーが選択されていません",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,)),),);};
                if(grade == "レベル"){showDialog(context: context, builder: (context) => AlertDialog(content: Container(child:Text("大体のレベルを選択してください",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,)),),);};

              },)),],)));
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




//
// class CreateV1A extends StatefulWidget {
//   @override
//   State<CreateV1A> createState() => _CreateV1AState();
// }
// class _CreateV1AState extends State<CreateV1A> {
//   var ID = "";
//   var map = {};var mapD = {};
//   var date = "";var name = "";
//   var co = 0;
//   late TextEditingController _bodyController;
//   var item = [];
//   void initState() {
//     super.initState();_bodyController = TextEditingController();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(backgroundColor: Colors.white,
//       appBar: AppBar(backgroundColor: Colors.white,
//         title: FittedBox(fit: BoxFit.fitWidth, child: Text("Create", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 30), textAlign: TextAlign.center,),),
//         iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
//         actions: [],),
//       floatingActionButton: FloatingActionButton(backgroundColor: Colors.pink, child: const Icon(Icons.create_new_folder),
//         onPressed: () {AddView();},
//       ),
//       body: SingleChildScrollView(
//         child: Column(children: [
//           Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("問題集",style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
//           Container(margin: EdgeInsets.all(10),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(), itemCount: item.length, itemBuilder: (context, index) {
//             return GestureDetector(onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V4V2(item[index]["勉強"],item[index]["休憩"],"",ID)));},
//                 child: Container(margin: EdgeInsets.all(5),color: Colors.grey[200],child:Column(children: [
//                   Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("勉強時間:　　" + '${(item[index]["勉強"] / (60 * 60)).floor()}:${((item[index]["勉強"] % (60 * 60) / 60).floor()).toString().padLeft(2, '0')}:${(item[index]["勉強"] % (60 * 60) % 60).toString().padLeft(2, '0')}',style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
//                   Container(margin: EdgeInsets.all(5),width:double.infinity,child:Text("休憩時間:　　" +'${(item[index]["休憩"] / (60 * 60)).floor()}:${((item[index]["休憩"] % (60 * 60) / 60).floor()).toString().padLeft(2, '0')}:${(item[index]["休憩"] % (60 * 60) % 60).toString().padLeft(2, '0')}',style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),)
//                 ],), )    );},),),
//         ],),),);
//   }
//
//   void AddView() {
//     showModalBottomSheet(isScrollControlled: true,context: context,backgroundColor: Colors.white,
//       shape:  const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
//       builder: (context) { return StatefulBuilder(
//           builder: (context, StateSetter setState) {
//             return Container(child:SingleChildScrollView(
//               child: Column(children: <Widget>[
//                 Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("問題集",style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
//                   Container(padding: EdgeInsets.symmetric(horizontal: 16.0,),margin:EdgeInsets.only(left: 10),
//                     decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5),),
//                     child: TextField(controller: _bodyController,decoration: InputDecoration(border: InputBorder.none,),onChanged: (String value) {setState(() {name = value;});},),),
//                 Container(margin: EdgeInsets.all(10),child:IconButton(onPressed: () {send();FocusScope.of(context).requestFocus(new FocusNode());},
//                     icon: Icon(Icons.create_new_folder_outlined), iconSize: 28, color: Colors.green,
//                 )),],)),);});}, );}
//
//   Future<void> send() async {
//     if (name != ""){
//       map = {"name":name};item.insert(0,map);
//       DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(ID);
//       ref.update({"問題集2": FieldValue.arrayUnion([map]),});setState(() {_bodyController.clear();});
//     }name = "";
//   }
//
// }
//
//
//
// class CreateV1B extends StatefulWidget {
//   @override
//   State<CreateV1B> createState() => _CreateV1BState();
// }
// class _CreateV1BState extends State<CreateV1B> {
//   var ID = "";
//   var map = {};var mapD = {};
//   var date = "";var name = "";
//   var co = 0;
//   late TextEditingController _bodyController;
//   var item = [];
//   void initState() {
//     super.initState();_bodyController = TextEditingController();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(backgroundColor: Colors.white,
//       appBar: AppBar(backgroundColor: Colors.white,
//         title: FittedBox(fit: BoxFit.fitWidth, child: Text("Create", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 30), textAlign: TextAlign.center,),),
//         iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
//         actions: [],),
//       floatingActionButton: FloatingActionButton(backgroundColor: Colors.pink, child: const Icon(Icons.search),
//         onPressed: () {;},
//       ),
//       body: SingleChildScrollView(
//         child: Column(children: [
//           Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("問題集",style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
//           Container(margin: EdgeInsets.all(10),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(), itemCount: item.length, itemBuilder: (context, index) {
//             return GestureDetector(onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V4V2(item[index]["勉強"],item[index]["休憩"],"",ID)));},
//                 child: Container(margin: EdgeInsets.all(5),color: Colors.grey[200],child:Column(children: [
//                   Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("勉強時間:　　" + '${(item[index]["勉強"] / (60 * 60)).floor()}:${((item[index]["勉強"] % (60 * 60) / 60).floor()).toString().padLeft(2, '0')}:${(item[index]["勉強"] % (60 * 60) % 60).toString().padLeft(2, '0')}',style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
//                   Container(margin: EdgeInsets.all(5),width:double.infinity,child:Text("休憩時間:　　" +'${(item[index]["休憩"] / (60 * 60)).floor()}:${((item[index]["休憩"] % (60 * 60) / 60).floor()).toString().padLeft(2, '0')}:${(item[index]["休憩"] % (60 * 60) % 60).toString().padLeft(2, '0')}',style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),)
//                 ],), )    );},),),
//         ],),),);
//   }
//
//
// }
//
