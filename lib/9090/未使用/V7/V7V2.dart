import 'dart:async';
import 'dart:math' as math;
import 'dart:math';
import 'dart:ui';
import 'package:bordered_text/bordered_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../V1/V1.dart';
import '../../../V5/V5.dart';

class V7V2 extends StatefulWidget {
  V7V2(this.map);
  Map map;
  @override

  State<V7V2> createState() => _V7V2State();
}

class _V7V2State extends State<V7V2> {

  var item = [];var item2 = [];var item3 = [];
  var map = {};var profiel = {};
  var user = "";var name = "";var ID = "";var message0 = "";var date = "";var date2 = "";var text = "";
  var startCo = 0; var endCo = 0;
  get onEng => null; var ite1 = true;
  late TextEditingController _bodyController;
  var _scrollController = ScrollController();
  DateTime now = DateTime.now();DateFormat outputFormat = DateFormat('yyyy年MM月dd日');
  @override
  void initState() {
    super.initState();
     _bodyController = TextEditingController();
     Timer.periodic(Duration(seconds: 1), _onTimer);  set();

  }
  void _onTimer(Timer timer) {
    var now = DateTime.now();
      var aa  = DateTime(2023, 1, 1, widget.map["時間時間"],  widget.map["時間分"]);
      var bb = DateTime(2023, 1, 1, now.hour, now.minute);
      var dif = bb.difference(aa).inSeconds;
    if ( -1 >= dif == true){ setState((){ite1 = true;var dif2 = dif / 60 * -1; text = "開始まで" +dif2.toString() +"分";});}
    if ( -1 <= dif == true  && startCo == 0  ){setState((){ite1 = false;text = "";startCo = 1;start();});}
    if ( 3000 <= dif == true  && endCo == 0  ){setState((){ite1 = false;text = "";endCo = 1;end();});}

  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async => false,
      child: Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor:  Colors.white, elevation: 0,centerTitle: false, automaticallyImplyLeading: false,
        title: Container(width:100,child:TextButton.icon(onPressed: () {show();}, icon: Icon(Icons.accessibility,color: Colors.blueGrey[900],), label: Text(widget.map["クラス名"].toString(),style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20),))),
        actions: <Widget>[IconButton(onPressed: () {
          if (endCo == 0){Navigator.pop(context);}else{
            showDialog(context: context, builder: (context) => AlertDialog(
              title: Text("退出すると今日は戻れなくなります。\n退出しますか?",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
              actions: [  Center(child: ElevatedButton(child: Text('退出する'), style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, foregroundColor: Colors.white, shape: const StadiumBorder(),),
                onPressed: () {Navigator.pop(context);Navigator.pop(context); },)),],));
          }}, icon: Icon(Icons.exit_to_app,size:30,color: Colors.blueGrey[800],))],
      ), body: GestureDetector( onTap: () => FocusScope.of(context).unfocus(),
         child:SingleChildScrollView(
          child: Column(children: [
            Container(width:double.infinity,child:Text(text,style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
            Visibility(visible : ite1,child : Divider(color: Colors.blueGrey,thickness: 3,indent: 150,endIndent: 150,),),

            Container(width:double.infinity,child:Text("出席中",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
            Divider(color: Colors.blueGrey,thickness: 3,indent: 150,endIndent: 150,),
            Container(decoration: BoxDecoration(color: Colors.grey[50],borderRadius: BorderRadius.circular(10)),margin: EdgeInsets.only(top: 10,left: 20,right: 20),width:double.infinity,
                  child: GridView.count(padding: EdgeInsets.all(20.0),shrinkWrap: true, physics:  NeverScrollableScrollPhysics(),
                      crossAxisCount: 4, crossAxisSpacing: 20.0, mainAxisSpacing: 20.0, childAspectRatio: 1, //shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                      children: List.generate(item.length, (index) {return GestureDetector(onTap: () {
                        showDialog(context: context, builder: (context) => AlertDialog(actions: [
                             Column(mainAxisAlignment:MainAxisAlignment.center,children: [
                               Container(padding: EdgeInsets.all(5),width: 70,height: 70,child:Image(image: AssetImage(item[index]["写真"]),),),
                               Container(padding: EdgeInsets.all(5),width:double.infinity,child:Text(item[index]["名前"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),
                               Container(padding: EdgeInsets.all(5),child:Text(item[index]["一言"],style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                               Container(alignment: Alignment.center,margin:EdgeInsets.only(right: 10,top:0,bottom: 0),child: Text("単位数：" + item[index]["単位数"].toString(),style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[800],fontSize: 10,height: 1.5,letterSpacing: 2,),)),

                        ],),],));},
                            child: Container(alignment: Alignment.center,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [new BoxShadow(color: Colors.grey, offset: new Offset(1.0, 1.0), blurRadius: 3.0, spreadRadius: 1)],),
                              child: Stack(children: <Widget>[
                                Container(padding: EdgeInsets.all(5),width: 70,height: 70,decoration: BoxDecoration(shape: BoxShape.circle,),child:Image(image: AssetImage(item[index]["写真"]),),),
                                Container(child:Image(image: AssetImage(item[index]["写真"]),),),
                                Container(alignment:Alignment.bottomCenter,width:double.infinity,child:BorderedText(child:Text(item[index]["名前"],style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center),strokeWidth: 2.0,strokeColor: Colors.black, )),
                              ]),));}))),
            Container(margin: EdgeInsets.only(top: 50,),width:double.infinity,child:Text("トーク",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
            Divider(color: Colors.blueGrey,thickness: 3,indent: 150,endIndent: 150,),
              Container(decoration: BoxDecoration(color: Colors.grey[50],borderRadius: BorderRadius.circular(10)),margin: EdgeInsets.only(top: 10,left: 20,right: 20),height:400,child:ListView.builder(reverse: true,controller: _scrollController,itemCount: item2.length, itemBuilder: (context, index) {
                  return Card(elevation:0,color:Colors.transparent,child: Container(margin: EdgeInsets.all(5),color: Colors.transparent,
                      child: StreamBuilder<QuerySnapshot>(
                        // 投稿メッセージ一覧を取得（非同期処理）
                        // 投稿日時でソート
                        stream: FirebaseFirestore.instance.collection('クラス').doc(widget.map["時間"]).collection(widget.map["クラス名"]).where("クラス名",isEqualTo:widget.map["クラス名"] ).snapshots(),
                        builder: (context, snapshot) {return Column(children: [
                          // Container(margin:EdgeInsets.all(5),width:double.infinity,alignment:Alignment.center,child: Text(item[index]["曜日"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white,fontSize: 15),),),
                          Container(child:item2[index]["判定"] == 0 ?
                          Container(width: double.infinity,padding:EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),decoration: BoxDecoration(color: Colors.black.withOpacity(0.2),borderRadius: BorderRadius.circular(10)),margin:EdgeInsets.only(left:0),
                            child: Text(item2[index]["メッセージ"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white,fontSize: 10,height: 1.5,letterSpacing: 2,),textAlign: TextAlign.center,),):
                          Container( margin:EdgeInsets.only(left:0),
                            child:Column(children: [
                              Row(children:[
                                Container(margin:EdgeInsets.only(left: 10,right: 10,top:5,bottom: 0),width: 40.0, height: 40.0, decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.fill, image: AssetImage(item2[index]["写真"]))),),
                                Container(margin:EdgeInsets.only(right: 10,top:0,bottom: 0),child: Text(item2[index]["名前"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[800],fontSize: 10,height: 1.5,letterSpacing: 2,),),),
                              ]),
                              Row(children:[
                                Container(decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),margin:EdgeInsets.only(left: 60,right: 10,top:0,bottom: 10),padding:EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10) ,child: Text(item2[index]["メッセージ"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 15,height: 1.5,letterSpacing: 2,),),),
                                Expanded(child: Container())]),
                            ],),))
                        ]); },
                      ),));},),),
            Container(margin: EdgeInsets.only(top: 0,left: 20,right: 20,bottom: 30),height: 68,width: double.infinity,color: Colors.transparent,
                child:TextField(keyboardType: TextInputType.multiline, maxLines: null,controller: _bodyController,onChanged: (String value) {setState(() {name = value;});},
                  decoration: InputDecoration(enabledBorder: new OutlineInputBorder(borderRadius: new BorderRadius.circular(25.0), borderSide: BorderSide(color: Colors.black,),),
                    //Focusしているとき
                    focusedBorder: OutlineInputBorder(borderRadius: new BorderRadius.circular(25.0), borderSide: BorderSide(color: Colors.blueGrey, width: 3.0,),),
                    hintText: 'message', contentPadding: EdgeInsets.all(16.0),
                    suffixIcon: IconButton(icon: Icon(Icons.send, color: Colors.black,),
                      onPressed: () {send();FocusScope.of(context).requestFocus(new FocusNode());},
                    ),
                  ),
                )
                // child:Row(
                //   children: <Widget>[
                //     Expanded(
                //       child: Container(padding: EdgeInsets.symmetric(horizontal: 10.0,),
                //         decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(40),),
                //         child: TextField(style: TextStyle(color: Colors.black,),keyboardType: TextInputType.multiline, maxLines: null,controller: _bodyController,decoration: InputDecoration(border: InputBorder.none,),onChanged: (String value) {setState(() {name = value;});},),),
                //     ),
                //     IconButton(
                //       onPressed: () {send();FocusScope.of(context).requestFocus(new FocusNode());},
                //       icon: Icon(Icons.send), iconSize: 28, color: Colors.blue,
                //     ),],)
                //
            )
          ])),)));}


// ClipRect(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5,),),),
  Future<void> set () async { DateTime now = DateTime.now();DateFormat outputFormat = DateFormat('yyyy年MM月dd日'); var date = outputFormat.format(now);print(date);SharedPreferences prefs = await SharedPreferences.getInstance();ID = prefs.getString("ID") ?? "";
  FirebaseFirestore.instance.collection('users').where("ID",isEqualTo:ID).get().then((QuerySnapshot snapshot) {snapshot.docs.forEach((doc) {profiel = doc["プロフィール"];
  FirebaseFirestore.instance.collection('クラス').doc(widget.map["時間"]).collection(widget.map["クラス名"]).doc(widget.map["クラス名"] ).update({"出席メンバー": FieldValue.arrayUnion([profiel]),"チャット": FieldValue.arrayUnion([{"ID":ID,"バグ対策":"","日付":date,"メッセージ":"名前が出席をしました!","判定":0}])});
  FirebaseFirestore.instance.collection('クラス').doc(widget.map["時間"]).collection(widget.map["クラス名"]).where("クラス名",isEqualTo:widget.map["クラス名"] ).get().then((QuerySnapshot snapshot) {
    snapshot.docs.forEach((doc) {setState(()  {item2 = doc["チャット"];item3 = doc["メンバー"];item = doc["出席メンバー"];delete();date2 = doc["日付"];
    if(date2 != date){setState((){FirebaseFirestore.instance.collection('クラス').doc(widget.map["時間"]).collection(widget.map["クラス名"]).doc(widget.map["クラス名"]).update({"日付": date, "出席メンバー": [profiel]});item = [profiel];}); }});});});

  });});}

  Future<void> send() async {  SharedPreferences prefs = await SharedPreferences.getInstance();
  ID = prefs.getString("ID") ?? "";if(name != ""){
  map = {"メッセージ":name,"ID":ID,"バグ対策":randomString(5),"日付":date,"判定":1,"名前":profiel["名前"],"写真":profiel["写真"],};
  await FirebaseFirestore.instance.collection('クラス').doc(widget.map["時間"]).collection(widget.map["クラス名"]).doc(widget.map["クラス名"] ).update({"チャット": FieldValue.arrayUnion([map])});
  setState(() {item2.insert(0,map);item2;});_bodyController.clear();name = "";
 // await FirebaseFirestore.instance.collection('管理').doc("メッセージ").update({"uid": FieldValue.arrayUnion([ID])});
  }}

  Future<void> delete() async {
  for(int i = 0; i<item3.length; i++){
      var aa = item3[i]["最終出席"].toDate();var bb = now;   var dif = bb.difference(aa).inDays;print(dif);
      if(dif >= 8){//var aaa = int.parse(widget.map["クラス番号"]);
        await FirebaseFirestore.instance.collection('users').doc(item3[i]["ID"]).update({"クラス": FieldValue.arrayRemove([widget.map])});
        await FirebaseFirestore.instance.collection('クラス').doc(widget.map["時間"]).collection(widget.map["クラス名"]).doc(widget.map["クラス名"] ).update({"メンバー": FieldValue.arrayRemove([item3[i]])});
        await FirebaseFirestore.instance.collection('クラス').doc(widget.map["時間"]).collection("V7Add").doc(widget.map["クラス名"]).update({"メンバー":FieldValue.arrayRemove([item3[i]["ID"]])});
      }}
    }

    // Future<void> ss () async {
    //   await FirebaseFirestore.instance.collection('クラス').doc(widget.map["時間"]).update({"グループ":[0]["メンバー"] = []});
    //
    // }


  void show(){showModalBottomSheet(isScrollControlled: true, context: context,
      shape: const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) {return Container(height: 750,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Container(child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(),
              itemCount: item3.length, itemBuilder: (context, index) {
                return Card(elevation: 0,color:Colors.grey[200],child:
                Row(children: [
                  Container(margin :EdgeInsets.only(top:0,bottom: 0,right: 20),width: 50,height: 50, child:Image(image: AssetImage(item3[index]["写真"]),),),
                  Column(children: [
                    Container(margin:EdgeInsets.only(right: 10,top:0,bottom: 0),child: Text(item3[index]["名前"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[800],fontSize: 10,height: 1.5,letterSpacing: 2,),),),
                    Container(margin:EdgeInsets.only(right: 10,top:0,bottom: 0),child: Text(item3[index]["単位数"].toString(),style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[800],fontSize: 10,height: 1.5,letterSpacing: 2,),),),
                  ],),
                ],));},),),
             ],),),);});}

  void start(){showModalBottomSheet(backgroundColor: Colors.white,isScrollControlled: true, context: context,//enableDrag: false,isDismissible: false,
      shape: const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) {return Container(height: double.infinity,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Container(margin:EdgeInsets.only(top:100,bottom: 0),child: Text("学習中",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[800],fontSize: 30,height: 1.5,letterSpacing: 2,),),),
            Container(margin:EdgeInsets.only(top:50,),width: 350, height: 150, child: Image.asset("images/school.png")),
            Container(margin:EdgeInsets.only(top:30,bottom: 0),child: Text(item.length.toString() + "人が出席しています",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[800],fontSize: 10,height: 1.5,letterSpacing: 2,),textAlign: TextAlign.center),),
            Container(margin:EdgeInsets.only(top:100,),width:150,child: ElevatedButton(child:  Text('このアプリを使う'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),), onPressed: () { Navigator.of(context).push(MaterialPageRoute(builder: (context) => V7V3()));},)),
            ],),),);});}

  void end(){showModalBottomSheet(backgroundColor: Colors.white,isScrollControlled: true, context: context,//enableDrag: false,isDismissible: false,
      shape: const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) {return Container(height: double.infinity,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Container(margin:EdgeInsets.only(top:100,bottom: 0),child: Text("終了",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[800],fontSize: 30,height: 1.5,letterSpacing: 2,),),),
            Container(margin:EdgeInsets.only(top:50,),width: 350, height: 150, child: Image.asset("images/end.png")),
            Container(margin:EdgeInsets.only(top:30,bottom: 0),child: Text("お疲れさまでした!\nあなたは着実に成長しています。",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[800],fontSize: 10,height: 1.5,letterSpacing: 2,),textAlign: TextAlign.center,),),
            Container(margin:EdgeInsets.only(top:100,),width:150,child: ElevatedButton(child: Text('退室'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),),
              onPressed: () {endB ();Navigator.pop(context);Navigator.pop(context);},
            )),
          ],),),);});}

  Future<void> endB () async {
    profiel["単位数"] = profiel["単位数"] + 1;
    await FirebaseFirestore.instance.collection('users').doc(ID).update({"プロフィール": profiel});
  }
  void update (){}




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





class V7V3 extends StatefulWidget {

  @override

  State<V7V3> createState() => _V7V3State();
}

class _V7V3State extends State<V7V3> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(backgroundColor:  Colors.blueGrey[100],
            //title:  Text("", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center,),
           // iconTheme: IconThemeData(color: Colors.black), elevation: 0,
            actions: <Widget>[IconButton(onPressed: () {Navigator.pop(context);},
                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => V7V3(widget.map)));},
                icon: Icon(Icons.highlight_off,size:30,color: Colors.blueGrey[800],))],
            bottom: TabBar(tabs: <Widget>[
              Tab(text:"anki"),
              Tab(text:"short"),
            ]), ),

          body: TabBarView(
              children: <Widget> [V1(),V5()]
          ),
        ),
      ),
    );
  }
}



