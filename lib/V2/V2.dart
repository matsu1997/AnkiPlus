import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../アカウント/SignUp.dart';
import 'V2Q.dart';

class V2 extends StatefulWidget {

  @override
  State<V2> createState() => _V2State();
}

class _V2State extends State<V2> {

  var ID = "";
  var item1 = [];var itemDate1 = [];var itemDate7 = [];var itemDate30 = [];var itemDateOsu = [];var itemStar1 = [];var itemStar2 = [];var itemStar3 = [];
  var item = ["昨日正解","7日前正解","30日前正解","★","★★","★★★","英単語", "漢字", "古文", "漢文単語", "世界史", "日本史", "地理", "生物", "物理", "化学"]; //Icons.history
  var itemBool = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
  var itemAll =[[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]];
  var date = ""; var date1 = ""; var date7 = ""; var date30 = "";
  @override
  void initState() {
    super.initState();sign();main();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent,
          title: Text("",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blue),),
          iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
        ),
          body:SingleChildScrollView(
            child:Column(children: [
              Container(margin: EdgeInsets.only(top: 0),color: Colors.transparent, width: double.infinity, alignment: Alignment.center, child: Text("review", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 40), textAlign: TextAlign.center,)),
              Container(margin: EdgeInsets.only(top: 5),color: Colors.transparent, width: double.infinity, alignment: Alignment.center, child: Text("1度で答えられなかった問題", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10), textAlign: TextAlign.center,)),
              Container(margin: EdgeInsets.only(top: 0, bottom: 30),
                  child: GridView.count(padding: EdgeInsets.all(20.0),
                      crossAxisCount: 2, crossAxisSpacing: 20.0, mainAxisSpacing: 20.0, childAspectRatio: 2, shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                      children: List.generate(item.length, (index) {
                        return GestureDetector(
                            onTap: () {if(itemBool[index] != 0){Navigator.of(context).push(MaterialPageRoute(builder: (context) => V2Q(item[index],itemAll[index],item1[0]["All"])),).then((value) => first());}},
                            child: itemBool[index] != 0 ?
                              Container(alignment: Alignment.center, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [new BoxShadow(color: Colors.grey, offset: new Offset(1.0, 1.0), blurRadius: 3.0, spreadRadius: 1)],),
                              child: Column(children: <Widget>[
                               Expanded(child:Container(margin: EdgeInsets.only(),alignment: Alignment.center, child: Text(item[index], style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold, fontSize: 20,),))),
                               Container(margin: EdgeInsets.only(bottom: 5),alignment: Alignment.center, child: Text(itemBool[index].toString() + "問", style: TextStyle(color: Colors.blueGrey[300], fontWeight: FontWeight.bold, fontSize: 10,),)),]),)
                        :Container(alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [new BoxShadow(color: Colors.grey, offset: new Offset(1.0, 1.0), blurRadius: 3.0, spreadRadius: 1)],),
                        child: Column(children: <Widget>[
                        Expanded(child:Container(margin: EdgeInsets.only(),alignment: Alignment.center, child: Text(item[index], style: TextStyle(color: Colors.blueGrey[300], fontWeight: FontWeight.bold, fontSize: 20,),))),
                        Container(margin: EdgeInsets.only(bottom: 5),alignment: Alignment.center, child: Text(itemBool[index].toString() + "問", style: TextStyle(color: Colors.blueGrey[300], fontWeight: FontWeight.bold, fontSize: 10,),)),]),)
                        );})))
            ],)));}

  void first () async {item1 = [];itemBool = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];itemAll =[[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]];item1 = []; itemDate1 = [];itemDate7 = [];itemDate30 = [];itemDateOsu = []; itemStar1 = [];itemStar2 = []; itemStar3 = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();ID =  prefs.getString("ID")!;
    FirebaseFirestore.instance.collection('users').doc(ID).collection("ミス").get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {item1.add(doc);select ();});});}

  Future<void> select () async { //await showLoadingDialog(context: context);
    setState(() {
    for(int i = 0; i< item1[0]["All"].length; i++){setState(() {if(item1[0]["All"][i]["date"] == date1 && item1[0]["All"][i]["dateC"] != 1){itemDate1.add(item1[0]["All"][i]);}});}
    if (itemDate1.length != 0){itemBool[0] = itemDate1.length;itemAll[0] = itemDate1;}
    for(int i = 0; i< item1[0]["All"].length; i++){setState(() {if(item1[0]["All"][i]["date"] == date7 && item1[0]["All"][i]["dateC"] != 2){itemDate7.add(item1[0]["All"][i]);}});}
    if (itemDate7.length != 0){itemBool[1] = itemDate7.length;itemAll[1] = itemDate7;}
    for(int i = 0; i< item1[0]["All"].length; i++){setState(() {if(item1[0]["All"][i]["date"] == date30 && item1[0]["All"][i]["dateC"] != 3){itemDate30.add(item1[0]["All"][i]);}});}
    if (itemDate30.length != 0){itemBool[2] = itemDate30.length;itemAll[2] = itemDate30;}
    if (item1[0]["ミス1"].length != 0){itemBool[3] = item1[0]["ミス1"].length;itemAll[3] = item1[0]["ミス1"];}
    if (item1[0]["ミス2"].length != 0){itemBool[4] = item1[0]["ミス2"].length;itemAll[4] = item1[0]["ミス2"];}
    if (item1[0]["ミス3"].length != 0){itemBool[5] = item1[0]["ミス3"].length;itemAll[5] = item1[0]["ミス3"];}
    if (item1[0]["英単語"].length != 0){itemBool[6] = item1[0]["英単語"].length;itemAll[6] = item1[0]["英単語"];}
  if (item1[0]["漢字"].length != 0){itemBool[7] = item1[0]["漢字"].length;itemAll[7] = item1[0]["漢字"];}
  if (item1[0]["古文"].length != 0){itemBool[8] = item1[0]["古文"].length;itemAll[8] = item1[0]["古文"];}
    if (item1[0]["漢文単語"].length != 0){itemBool[9] = item1[0]["漢文単語"].length;itemAll[9] = item1[0]["漢文単語"];}
      if (item1[0]["世界史"].length != 0){itemBool[10] = item1[0]["世界史"].length;itemAll[10] = item1[0]["世界史"];}
  if (item1[0]["日本史"].length != 0){itemBool[11] = item1[0]["日本史"].length;itemAll[11] = item1[0]["日本史"];}
  if (item1[0]["地理"].length != 0){itemBool[12] = item1[0]["地理"].length;itemAll[12] = item1[0]["地理"];}
  if (item1[0]["生物"].length != 0){itemBool[13] = item1[0]["生物"].length;itemAll[13] = item1[0]["生物"];}
  if (item1[0]["物理"].length != 0){itemBool[14] = item1[0]["物理"].length;itemAll[14] = item1[0]["物理"];}
  if (item1[0]["化学"].length != 0){itemBool[15] = item1[0]["化学"].length;itemAll[15] = item1[0]["化学"];}

  });}

  void main() {DateFormat outputFormat = DateFormat('yyyy年MM月dd日');
  DateTime now = DateTime.now();date = outputFormat.format(now);
  DateTime now1 = DateTime.now().subtract(Duration(days: 1));date1 = outputFormat.format(now1);
  DateTime now7 = DateTime.now().subtract(Duration(days: 7));date7 = outputFormat.format(now7);
  DateTime now30 = DateTime.now().subtract(Duration(days: 30));date30 = outputFormat.format(now30);
  first();
  }
  void sign() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ID = prefs.getString("ID") ?? "";
    if (ID == "") {Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()));}
  }


  Future <void> showLoadingDialog({
    required BuildContext context,
  }) async {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 250),
        barrierColor: Colors.black.withOpacity(0.5), // 画面マスクの透明度
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return  WillPopScope(
            onWillPop: ()async=> false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  Text("読み込み中"),
                ],
              ),
            ),
          );
        });
  }
}
