import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../アカウント/SignUp.dart';

class V7Add extends StatefulWidget {
  V7Add(this.item,this.map);
  List item;Map map;
  @override

  State<V7Add> createState() => _V7AddState();
}

class _V7AddState extends State<V7Add> {

  var item = ["6:00~6:50","7:00~7:50","8:00~8:50","9:00~9:50","10:00~10:50","11:00~11:50","12:00~13:50","13:00~13:50","14:00~14:50","15:00~15:50","16:00~16:50","17:00~17:50","18:00~18:50","19:00~19:50","20:00~20:50","21:00~21:50","22:00~22:50","23:00~23:50","24:00~24:50"];
  @override
  void initState() {
    super.initState();
    set();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        title:  Text("", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 40), textAlign: TextAlign.center,),
        iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
        actions: [],),
      body: SingleChildScrollView(
          child: Column(children: [
            Container(margin:EdgeInsets.all(5),width:double.infinity,child:Text("何時に参加しますか?", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20,),textAlign: TextAlign.center,)),
            Container(margin:EdgeInsets.all(10),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(),
              itemCount: item.length, itemBuilder: (context, index) {
                return Card(elevation: 0,color:Colors.grey[200],
                  child:widget.item.contains(item[index])?
                  ListTile(
                  title: Text("登録済み",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
                  onTap: (){},):
                  ListTile(
                    title: Text(item[index],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
                    onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => V7Add2(item[index],widget.map)));},
                  )
                );},),),
          ])),);}
// ClipRect(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5,),),),
  void set (){


  }
}


class V7Add2 extends StatefulWidget {
  @override
  V7Add2(this.class1,this.map);
 String class1;Map map;
  State<V7Add2> createState() => _V7Add2State();
}

class _V7Add2State extends State<V7Add2> {

  var item = [];
  var profiel = [];
  var ID = "";
  var name = "";var hour = 0;var minute = 0;
  var co = 0;
  var map = {};
  @override
  void initState() {
    super.initState();
    switch(widget.class1){
      case "6:00~6:50":name = "A";hour = 6;break;case "7:00~7:50":name = "B";hour = 7;break;case "8:00~8:50":name = "C";hour = 8;break;case "9:00~9:50":name = "D";hour = 9;break;case "10:00~10:50":name = "E";hour = 10;break;case "11:00~11:50":name = "F";hour = 11;break;case "12:00~12:50":name = "G";hour = 12;break;case "13:00~13:50":name = "H";hour = 13;break;case "14:00~14:50":name = "J";hour = 14;break;case "15:00~15:50":name = "K";hour = 15;break;case "16:00~16:50":name = "L";hour = 16;break;
      case "17:00~17:50":name = "M";hour = 17;break;case "18:00~18:50":name = "N";hour = 18;break;case "19:00~19:50":name = "O";hour = 19;break;case "20:00~20:50":name = "P";hour = 20;break;case "21:00~21:50":name = "Q";hour = 21;break;case "22:00~22:50":name = "R";hour = 22;break;case "23:00~23:50":name = "S";hour = 23;break;

    }
  sign();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        title:  Text(widget.class1, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center,),
        iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
        actions: [],),
      body: SingleChildScrollView(
          child: Column(children: [
            Container(margin:EdgeInsets.all(5),width:double.infinity,child:Text("クラスを選択", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20,),textAlign: TextAlign.center,)),
            Container(margin:EdgeInsets.all(15),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(),
              itemCount: item.length, itemBuilder: (context, index) {
                return GestureDetector(onTap: () {DateTime now = DateTime.now();
                  if(item[index]["メンバー"].length < 1){
                         showDialog(context: context, builder: (context) => AlertDialog(
                           title: Text("参加しますか?",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
                           actions: [  Center(child: ElevatedButton(
                             child: Text('参加する'), style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, foregroundColor: Colors.white, shape: const StadiumBorder(),),
                             onPressed: () {print(profiel);
                              DocumentReference ref = FirebaseFirestore.instance.collection('クラス').doc(widget.class1).collection("V7Add").doc(item[index]["クラス名"]);ref.update({"メンバー": FieldValue.arrayUnion([ID])});
                              item[index]["メンバー"].addAll([ID]); map = {"ID":ID,"単位数":widget.map["単位数"],"名前":widget.map["名前"],"写真":widget.map["写真"],"一言":widget.map["一言"],"最終出席":now};
                               DocumentReference ref1 = FirebaseFirestore.instance.collection('クラス').doc(widget.class1).collection(item[index]["クラス名"]).doc(item[index]["クラス名"]); ref1.update({"メンバー": FieldValue.arrayUnion([map])});//ref1.update({"メンバー": FieldValue.arrayUnion([map])});
                               DocumentReference ref2 = FirebaseFirestore.instance.collection('users').doc(ID);ref2.update({"クラス": FieldValue.arrayUnion([{"クラス名":item[index]["クラス名"],"クラス番号":index,"時間":widget.class1,"時間時間":hour,"時間分":minute,}])});
                            Navigator.pop(context);Navigator.pop(context);Navigator.pop(context); },)),
                           ],));
                     }else{}},
                child: Card(elevation: 0,color:Colors.grey[200],
                    child: item[index]["メンバー"].length < 1?
                    Container(height:60,child:Row(mainAxisAlignment:MainAxisAlignment.center,children: [
                      Container(margin:EdgeInsets.only(top:5,bottom: 5,left: 20),alignment:Alignment.center,child: Text(item[index]["クラス名"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900]),),),
                      Container(margin:EdgeInsets.only(top:5,bottom: 5,left: 20),alignment:Alignment.center,child:Icon(Icons.accessibility)),
                      Container(margin:EdgeInsets.all(5),alignment:Alignment.center,child: Text(item[index]["メンバー"].length.toString()+ "人",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900]),),),
                    ])):
                    Container(height:60,child:Row(mainAxisAlignment:MainAxisAlignment.center,children: [
                      Container(margin:EdgeInsets.only(top:5,bottom: 5,left: 20),alignment:Alignment.center,child: Text(item[index]["クラス名"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[300]),),),
                      Container(margin:EdgeInsets.all(5),alignment:Alignment.center,child: Text(item[index]["メンバー"].length.toString()+ "人",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[300]),),),
                    ]))
                ) );},),),
          ])),);}
// ClipRect(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5,),),),

  void first () async {SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseFirestore.instance.collection('クラス').doc(widget.class1).collection("V7Add").get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {setState(() {item.add(doc);});;});});

  Future.delayed(Duration(seconds: 1)).then((_) {setState(() { for(int i = 0; i<item.length; i++){if (item[i]["メンバー"].length >= 1){co = co +1 ;}else{}} });});
  //  profiel = prefs.getStringList("プロフィール")?? [];
    Future.delayed(Duration(seconds: 2)).then((_) {setState(() {add();});});
    }

  // void first () async {SharedPreferences prefs = await SharedPreferences.getInstance();
  //  FirebaseFirestore.instance.collection('クラス').where("クラス名" ,isEqualTo: widget.class1).get().then((QuerySnapshot snapshot) {
  //     snapshot.docs.forEach((doc) {setState(() {item = doc["グループ"];
  //     for(int i = 0; i<item.length; i++){
  //       if (item[i]["メンバー"].length >= 1){co = co +1 ;}else{}}
  //     });;});});
  //   profiel = prefs.getStringList("プロフィール")?? [];
  //   Future.delayed(Duration(seconds: 2)).then((_) {setState(() {add();});});
  // }
  void sign() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ID = prefs.getString("ID") ?? "";first();
    if (ID == "") {Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()));}
  }

  Future<void> add () async {print(co);
  if (item.length == co) {
    var aa = item.length + 1;
    map = {"クラス名":name + aa.toString() + "組","クラス番号":item.length, "メンバー": [],};
    DocumentReference ref = FirebaseFirestore.instance.collection('クラス').doc(widget.class1).collection("V7Add").doc(name + aa.toString() + "組");
    ref.set({"クラス名":name + aa.toString() + "組","クラス番号":item.length, "メンバー": [],});

    DocumentReference ref1 = FirebaseFirestore.instance.collection('クラス').doc(widget.class1).collection(name + aa.toString() + "組").doc(name + aa.toString() + "組");
    ref1.set({"クラス名":name + aa.toString() + "組","クラス番号":item.length,"メンバー":[],"日付":"","チャット":[],"出席メンバー":[]});
    setState(() {item.add(map);});
  }
  }

  // Future<void> add () async {print(co);
  //   if (item.length == co) {
  //     var aa = item.length + 1;
  //     map = {"クラス名":name + aa.toString() + "組","クラス番号":item.length, "メンバー": [],};
  //     DocumentReference ref = FirebaseFirestore.instance.collection('クラス').doc(widget.class1);
  //     ref.update({"グループ": FieldValue.arrayUnion([map])});
  //     DocumentReference ref1 = FirebaseFirestore.instance.collection('クラス').doc(widget.class1).collection(name + aa.toString() + "組").doc(name + aa.toString() + "組");
  //     ref1.set({"クラス名":name + aa.toString() + "組","クラス番号":item.length,"メンバー":[],"日付":"","チャット":[],"出席メンバー":[]});
  //     setState(() {item.add(map);});
  //   }
  // }



}