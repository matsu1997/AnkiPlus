import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'V7.dart';



class V7First extends StatefulWidget {
  V7First(this.tani);
  int tani;
  @override

  State<V7First> createState() => _V7FirstState();
}

class _V7FirstState extends State<V7First> {


  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        title: FittedBox(fit: BoxFit.fitWidth, child: Text("", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 40), textAlign: TextAlign.center,),),
        automaticallyImplyLeading: false, elevation: 0,
        actions: [],),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(margin:EdgeInsets.all(5),width:double.infinity,child:Text("自習クラスに参加する", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 25,),textAlign: TextAlign.center,)),
            Container(margin:EdgeInsets.all(5),width:double.infinity,child:Text("決まった時間に集合し自習するクラス(最高40名)を作成します。", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15,),textAlign: TextAlign.center,)),
            Container(margin:EdgeInsets.all(5),width:double.infinity,child:Text("ルール1", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15,),textAlign: TextAlign.center,)),
            Container(margin:EdgeInsets.all(5),width:double.infinity,child:Text("１クラス50分。複数の時間のクラスに参加出来ます", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15,),textAlign: TextAlign.center,)),
            Container(margin:EdgeInsets.all(5),width:double.infinity,child:Text("ルール2", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15,),textAlign: TextAlign.center,)),
            Container(margin:EdgeInsets.all(5),width:double.infinity,child:Text("時間5分前から出席タイムカードを押せます。遅刻は5分後まで", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15,),textAlign: TextAlign.center,)),
            Container(margin:EdgeInsets.all(5),width:double.infinity,child:Text("ルール3", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15,),textAlign: TextAlign.center,)),
            Container(margin:EdgeInsets.all(5),width:double.infinity,child:Text("退席タイムカードを終了後5分以内に押さないと欠席扱いになります。", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15,),textAlign: TextAlign.center,)),
            Container(margin:EdgeInsets.all(5),width:double.infinity,child:Text("ルール4", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15,),textAlign: TextAlign.center,)),
            Container(margin:EdgeInsets.all(5),width:double.infinity,child:Text("最低週に1回出席しないと単位が足りず強制退学になります。再度入学しましょう。", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15,),textAlign: TextAlign.center,)),
            Container(margin:EdgeInsets.all(5),width:double.infinity,child:Text("ルール5", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15,),textAlign: TextAlign.center,)),
            Container(margin:EdgeInsets.all(5),width:double.infinity,child:Text("クラス内チャットは前後10分間解放されます。皆んな、アナタと同じく目標に向かって頑張っています。優しいクラスでありましょう。\n問題発言のある生徒は校長(開発者)による強制退学もあるかも・・・", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15,),textAlign: TextAlign.center,)),
            Container(margin :EdgeInsets.only(top:80),width:100,child: ElevatedButton(
              child: Text('参加する'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, foregroundColor: Colors.white, shape: const StadiumBorder(),),
              onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V7First2(widget.tani)));},)),

          ])),);}
// ClipRect(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5,),),),

}



class V7First2 extends StatefulWidget {
  V7First2(this.tani);
  int tani;
  @override

  State<V7First2> createState() => _V7First2State();
}

class _V7First2State extends State<V7First2> {

  String name = '';

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        title:  Text("戻る", style: TextStyle(color: Colors.black, ), textAlign: TextAlign.center,),
        iconTheme: IconThemeData(color: Colors.black), elevation: 0,
        actions: [],),
      body: SingleChildScrollView(
          child: Column(children: [
            Container(margin: EdgeInsets.only(top: 100, bottom: 5, left: 30, right: 30),child:Text("ニックネームを入力",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
            Container(width: double.infinity, margin: EdgeInsets.only(top: 50, bottom: 5, left: 30, right: 30),
              child: TextFormField(onChanged: (String value) {setState(() {name = value;});},
                decoration: InputDecoration(focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide:  BorderSide(color: Colors.blueGrey, width: 2.0,),),
                  labelStyle: TextStyle(fontSize: 12, color: Colors.blueGrey[900],), labelText: 'ニックネーム',
                  floatingLabelStyle: const TextStyle(fontSize: 12),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.blueGrey[300]!, width: 1.0,
                    ),),),)),
            Container(margin :EdgeInsets.only(top:80),width:100,child: ElevatedButton(
              child: Text('登録'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, foregroundColor: Colors.white, shape: const StadiumBorder(),),
              onPressed: () {if(name != ""){Navigator.of(context).push(MaterialPageRoute(builder: (context) => V7First3(name,widget.tani)));}},)),
          ])),);}

}


class V7First3 extends StatefulWidget {
  V7First3(this.name,this.tani);
  String name;int tani;
  @override

  State<V7First3> createState() => _V7First3State();
}

class _V7First3State extends State<V7First3> {

 var item = ["images/10men1.png","images/10men2.png","images/10men3.png","images/10men4.png","images/10men5.png","images/10men6.png","images/10men7.png","images/10men8.png",
   "images/20men1.png","images/20men2.png","images/20men3.png","images/20men4.png","images/20men5.png","images/20men6.png","images/20men7.png","images/20men8.png",
   "images/10women1.png","images/10women2.png","images/10women3.png","images/10women4.png","images/10women5.png","images/10women6.png","images/10women7.png","images/10women8.png",
   "images/20women1.png","images/20women2.png","images/20women3.png","images/20women4.png","images/20women5.png","images/20women6.png","images/20women7.png","images/20women8.png",];

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white,
          title:  Text("戻る", style: TextStyle(color: Colors.black, ), textAlign: TextAlign.center,),
          iconTheme: IconThemeData(color: Colors.black), elevation: 0,
          actions: [],),
      body: SingleChildScrollView(
          child: Column(children: [ Container(margin:EdgeInsets.all(5),width:double.infinity,child:Text("アバターを選択", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 25,),textAlign: TextAlign.center,)),
            Container(margin: EdgeInsets.only(top: 0, bottom: 30),
                child: GridView.count(padding: EdgeInsets.all(20.0),
                    crossAxisCount: 4, crossAxisSpacing: 20.0, mainAxisSpacing: 20.0, childAspectRatio: 1, shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                    children: List.generate(item.length, (index) {
                      return GestureDetector(onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V7First4(widget.name,item[index],widget.tani)));},
                          child: Container(alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [new BoxShadow(color: Colors.grey, offset: new Offset(1.0, 1.0), blurRadius: 3.0, spreadRadius: 1)],),
                            child: Column(children: <Widget>[
                               Container(child: Image.asset(item[index]))]),));
                    })))    ])),);}


  // Future<void> set() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString("ID", name);
  // }
}

class V7First4 extends StatefulWidget {
  V7First4(this.name,this.image,this.tani);
  String name;String image;int tani;
  @override

  State<V7First4> createState() => _V7First4State();
}

class _V7First4State extends State<V7First4> {

  String name = '';
  List<String> item = [];
  @override
  void initState() {
    super.initState();
    item = [widget.name,widget.image,""];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        title: FittedBox(fit: BoxFit.fitWidth, child: Text("", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 40), textAlign: TextAlign.center,),),
        iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
        actions: [],),
      body: SingleChildScrollView(
          child: Column(children: [
            Container(margin: EdgeInsets.only(top: 100, bottom: 5, left: 30, right: 30),width:70,height:70,child:Image(image: AssetImage(widget.image),),),
            Container(margin: EdgeInsets.only(top: 10, bottom: 5, left: 30, right: 30),child:Text(widget.name,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
            Container(margin: EdgeInsets.only(top: 100, bottom: 5, left: 30, right: 30),child:Text("クラスメイトに簡単なご挨拶",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
            Container(width: double.infinity, margin: EdgeInsets.only(top: 50, bottom: 5, left: 30, right: 30),
                child: TextFormField(onChanged: (String value) {setState(() {name = value;});},
                  decoration: InputDecoration(focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide:  BorderSide(color: Colors.blueGrey, width: 2.0,),),
                    labelStyle: TextStyle(fontSize: 12, color: Colors.blueGrey[900],), labelText: 'ひと言',
                    floatingLabelStyle: const TextStyle(fontSize: 12),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.blueGrey[300]!, width: 1.0,
                    ),),),)),
             Container(margin :EdgeInsets.only(top:80),width:100,child: ElevatedButton(
              child: Text('登録'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, foregroundColor: Colors.white, shape: const StadiumBorder(),),
              onPressed: () {set();},)),
          ])),);}

Future<void> set() async {item[2] = name;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var ID = prefs.getString("ID") ?? "";
  prefs.setStringList("プロフィール", item);prefs.setString("プロフィール2", "item");
  if (widget.tani ==0 ){ DocumentReference ref2 = FirebaseFirestore.instance.collection('users').doc(ID);ref2.update({"プロフィール": {"名前":widget.name,"写真":widget.image,"一言":name,"単位数":widget.tani,"ID":ID},"クラス":[]});
  }else{DocumentReference ref2 = FirebaseFirestore.instance.collection('users').doc(ID);ref2.update({"プロフィール": {"名前":widget.name,"写真":widget.image,"一言":name,"単位数":widget.tani,"ID":ID}});}
int count = 0;Navigator.popUntil(context, (_) => count++ >= 4);
}
}
