


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class V8First extends StatefulWidget {

  @override
  State<V8First> createState() => _V8FirstState();
}

class _V8FirstState extends State<V8First> {



  @override
  void initState() {
    super.initState();
    set();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        title: Text("", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.center,),
        iconTheme: IconThemeData(color: Colors.black), centerTitle: true, elevation: 0, actions: [],),
      body: SingleChildScrollView(
          child: Column(children: [
            Container(width: 350, height: 150, child: Image.asset("images/school.png")),
            Container(width:double.infinity,margin :EdgeInsets.only(top: 30),child:Text("オンライン自習室のご案内",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,)),
            Container(width:double.infinity,margin :EdgeInsets.only(top:30,left: 20,right: 20),child:Text("1人だとついサボってしまう方・集中力が続かない方にオススメのLINE.OpenChatを使ったオンライン自習室です。１限50分・休憩10分のセットになっています。",style: TextStyle(color: Colors.black,fontSize: 15),textAlign: TextAlign.center,)),
            Container(width:double.infinity,margin :EdgeInsets.only(top: 30),child:Text("〇〇時00分スタート",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,)),
            Container(width:double.infinity,margin :EdgeInsets.only(top: 10),child:TextButton(onPressed: () async {final url = "https://line.me/ti/g2/P1ynnbHk5gY8vvFNQBBF7goHY0WUb8KC0CTFZQ?utm_source=invitation&utm_medium=link_copy&utm_campaign=default";
            if (await canLaunch(url)) {await launch(url);}}, child:Text("参加",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,))),
            Container(width:double.infinity,margin :EdgeInsets.only(top: 30),child:Text("〇〇時30分スタート",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,)),
            Container(width:double.infinity,margin :EdgeInsets.only(top: 10,bottom:30),child:TextButton(onPressed: () async {  final url = "https://line.me/ti/g2/0nve2tmLQLzkAoD-tfOKgbjYdcotDQBY75-RkA?utm_source=invitation&utm_medium=link_copy&utm_campaign=default";
            if (await canLaunch(url)) {await launch(url);}}, child:Text("参加",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,))),
            Container(height: 100,)

          ])),);
  }
  Future<void> set() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();var aa =  prefs.getString("V8First")?? "";var ID =  prefs.getString("ID")?? "";
    if (aa  == ""){prefs.setString("V8First", "1");
      FirebaseFirestore.instance.collection('users').doc(ID).update({"V8Collection":[],"V8ポイント":50});
    }}

}


class URL extends StatefulWidget {
  URL(this.url);
  String url;
  @override
  State<URL> createState() => _URLState();
}
class _URLState extends State<URL> {

  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse(widget.url),
      );
  }


  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,elevation: 0,
        title: Text("", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body:WebViewWidget(controller: controller,),

    );}

}