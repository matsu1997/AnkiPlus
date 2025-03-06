
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:timezone/timezone.dart' as tz;
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class V4V2 extends StatefulWidget {
  V4V2(this.A,this.B,this.name,this.ID);
  int A; int B;String name;String ID;
  @override
  State<V4V2> createState() => _V4V2State();
}

class _V4V2State extends State<V4V2> with TickerProviderStateMixin , WidgetsBindingObserver{
   var itemco = 0;
  final flnp = FlutterLocalNotificationsPlugin();var rand = new Random();
  var finishS = ["ひと休み!","全力で休憩!","頑張ったね!","良い調子!","集中できた？",];
  var finishR = ["ひと頑張りしますか？","頑張っちゃいますか？","スタートボタン押しちゃえ！","もう1セット行きますか？"];
  var ID = "";var date = "";var months = "";var years = "";var yesterday = "";var name = "";var text = "集中";var start = "";var end = "";var a = "";
  var co = 0;var time = 0;var count = 1;
  bool isPlaying = false;
  late AnimationController controller;
  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${controller.duration!.inHours}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }
  double progress = 1.0;

  void initState() {
    super.initState(); WidgetsBinding.instance!.addObserver(this);
    time = widget.A;
    start = '${(widget.A / (60 * 60)).floor()}:${((widget.A % (60 * 60) / 60).floor()).toString().padLeft(2, '0')}:${(widget.A % (60 * 60) % 60).toString().padLeft(2, '0')}';
    end = '${(widget.B / (60 * 60)).floor()}:${((widget.B % (60 * 60) / 60).floor()).toString().padLeft(2, '0')}:${(widget.B % (60 * 60) % 60).toString().padLeft(2, '0')}';
    controller = AnimationController(vsync: this, duration: Duration(seconds: time),);
    controller.addListener(() {notify();
      if (controller.isAnimating) {setState(() {progress = controller.value;});} else {setState(() {progress = 1.0;isPlaying = false;});}
});
  }
  @override
  void dispose() {
   // controller.dispose();
    super.dispose();flnp.cancelAll();controller.reset();setState(() {isPlaying = false;});
  }
  void didChangeAppLifecycleState(AppLifecycleState state) {print("stete = $state");
    switch (state) {
      case AppLifecycleState.inactive:print('非アクティブになったときの処理');break;
      case AppLifecycleState.paused:print('停止されたときの処理');break;
      case AppLifecycleState.resumed:
        if ((controller.duration! * controller.value).inSeconds == 0) {setState(() {set ();print(10);}) ;}print(1);break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
      case AppLifecycleState.detached:print('破棄されたときの処理');break;}
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white,
          title: Text("", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,), textAlign: TextAlign.center,),
          iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0, automaticallyImplyLeading: false,
          actions: [IconButton(icon:  Icon(Icons.highlight_off,color: Colors.blueGrey,size: 40,), onPressed: () {Navigator.pop(context);},)],
        ),
        body:SingleChildScrollView(
            child: Column(children: <Widget>[
              Container(width:double.infinity,margin:EdgeInsets.only(top:30),child: Text(widget.name,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.grey,fontSize: 20),textAlign: TextAlign.center,)),
              Container(width:double.infinity,margin:EdgeInsets.only(top:50),child: Text(text,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey,fontSize: 15),textAlign: TextAlign.center,)),
             // Container(width:double.infinity,margin:EdgeInsets.only(top:5),child: Text(count.toString() + "回目",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.grey,fontSize: 10),textAlign: TextAlign.center,)),
              Container(margin: EdgeInsets.only(top: 30,bottom: 30),color: Colors.transparent, width: double.infinity, alignment: Alignment.center, child: Text(countText, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 50), textAlign: TextAlign.center,)),
              Container(height:100,width:double.infinity,child:Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    GestureDetector(
                      onTap: () {
                        if (controller.isAnimating) {controller.stop();setState(() {isPlaying = false;});
                         flnp.cancel(1);
                        } else {
                        if (co == 0){notify1();notify2();}else{notify3();notify4();};
                        controller.reverse(from: controller.value == 0 ? 1.0 : controller.value);
                          setState(() {isPlaying = true;});}},
                      child: RoundButton(icon: isPlaying == true ? Icons.pause : Icons.play_arrow,),
                    ),
                    GestureDetector(onTap: () {flnp.cancelAll();controller.reset();setState(() {isPlaying = false;});},
                      child: RoundButton(icon: Icons.stop,),),
                  ],)),
              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                Column(children: <Widget>[
                  Container(margin: EdgeInsets.only(top: 100,right: 20),child: Text("集中",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey[400],fontSize: 15),textAlign: TextAlign.center,)),
                  Container(margin: EdgeInsets.only(top:5,right: 20,bottom: 10),  alignment: Alignment.center, child: Text(start, style: TextStyle(color: Colors.blueGrey[400], fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center,)),]),
                Column(children: <Widget>[
                  Container(margin: EdgeInsets.only(top:100,left: 20),child: Text("休憩",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey[400],fontSize: 15),textAlign: TextAlign.center,)),
                  Container(margin: EdgeInsets.only(top:5,left: 20,bottom: 10), alignment: Alignment.center, child: Text(end, style: TextStyle(color: Colors.blueGrey[400], fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center,)),]),
              ],),
            Row(mainAxisAlignment: MainAxisAlignment.center,children: [
              IconButton(icon:  Icon(Icons.sunny,color: Colors.blue,size: 40,), onPressed: () {study();},),Container(width: 70,),
              IconButton(icon:  Icon(Icons.bedtime_outlined,color: Colors.blue,size: 40,), onPressed: () {rest();},),
            ],)
            ],),),);}

  void notify() {if (countText == '0:00:00') {flnp.cancel(1);setState(() {set ();}) ;} }
  void set (){if (co == 0){data();co = 1;text = "休憩中";time = widget.B;}else{ankert();co = 0;text = "集中";time = widget.A;count = count + 1;}; controller = AnimationController(vsync: this, duration: Duration(seconds: time));
   controller.addListener(() {notify();if (controller.isAnimating) {setState(() {progress = controller.value;});} else {setState(() {progress = 1.0;isPlaying = false;});}});}

  void study(){showModalBottomSheet(isScrollControlled: true, context: context,
      shape: const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) {return Container(
          child: SingleChildScrollView(
              child: Column(children: <Widget>[
                Container(width:double.infinity,margin :EdgeInsets.only(top: 30),child:Text("勉強の鉄則",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 22),textAlign: TextAlign.center,)),
                Container(width:double.infinity,margin :EdgeInsets.only(top: 10,left: 10,right: 10),child:Text("1.まずは集中力を高める",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,)),
                Container(width:double.infinity,margin :EdgeInsets.only(top: 10,bottom:10,left: 20,right: 20),child:Text("背筋を伸ばす・瞑想・水を飲む",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,)),
                Container(width:double.infinity,margin :EdgeInsets.only(top: 20,left: 10,right: 10),child:Text("2.このあと誰かに教えるつもりで",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,)),
                Container(width:double.infinity,margin :EdgeInsets.only(top: 10,bottom:10,left: 20,right: 20),child:Text("覚えないと教えられないと思う気持ちが大切。覚えたつもりを防ぐ。",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,)),
                Container(width:double.infinity,margin :EdgeInsets.only(top: 10,left: 10,right: 10),child:Text("3.勉強の最後40秒は復習にあてる",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,)),
                Container(width:double.infinity,margin :EdgeInsets.only(top: 10,bottom:50,left: 20,right: 20),child:Text("習った内容をざっと思い出すだけでも記憶の残り方が違うそう",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,)),
              ])));});}

  void rest(){showModalBottomSheet(isScrollControlled: true, context: context,
      shape: const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) {return Container(
          child: SingleChildScrollView(
              child: Column(children: <Widget>[
                Container(width:double.infinity,margin :EdgeInsets.only(top: 30),child:Text("休憩の過ごし方",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 25),textAlign: TextAlign.center,)),
                Container(width:double.infinity,margin :EdgeInsets.only(top: 20,left: 10,right: 10),child:Text("1.何もしない",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,)),
                Container(width:double.infinity,margin :EdgeInsets.only(top: 10,bottom:10,left: 20,right: 20),child:Text("5分間ほど目を瞑りぼーっとするだけで記憶の定着が加速するのだとか。",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,)),
                Container(width:double.infinity,margin :EdgeInsets.only(top: 10,left: 10,right: 10),child:Text("2.軽い運動",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,)),
                Container(width:double.infinity,margin :EdgeInsets.only(top: 10,bottom:10,left: 20,right: 20),child:Text("5分間ほど散歩程度の運動をするだけで記憶の定着が加速するのだとか。",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,)),
                Container(width:double.infinity,margin :EdgeInsets.only(top: 10,left: 10,right: 10),child:Text("3.昼寝",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,)),
                Container(width:double.infinity,margin :EdgeInsets.only(top: 10,bottom:50,left: 20,right: 20),child:Text("15分程度がベスト!(目を瞑るだけでもOK)。認知力UP・集中力UP・記憶力UP",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,)),
              ])));});}

  Future<void> notify1() async {
    return flnp.initialize(InitializationSettings(iOS: DarwinInitializationSettings(),),
    ).then((_) => flnp.zonedSchedule(1, "集中終了" , finishS[rand.nextInt(finishS.length)],
      tz.TZDateTime.now(tz.UTC).add(Duration(seconds:(controller.duration! * controller.value).inSeconds)),
      NotificationDetails(iOS:  DarwinNotificationDetails(badgeNumber: 1,),),
      androidAllowWhileIdle: true, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    ));
  }
  Future<void> notify2() async {
    return flnp.initialize(InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher'),),).then((_) => flnp.zonedSchedule(1,  "集中終了" , finishS[rand.nextInt(finishS.length)],
      tz.TZDateTime.now(tz.UTC).add(Duration(seconds: (controller.duration! * controller.value).inSeconds)),
      NotificationDetails(android:  AndroidNotificationDetails( "集中終了",  finishS[rand.nextInt(finishS.length)], importance: Importance.high, priority: Priority.high,),),
      androidAllowWhileIdle: true, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,));

  }
  Future<void> notify3() async {
  return flnp.initialize(InitializationSettings(iOS: DarwinInitializationSettings(),),
    ).then((_) => flnp.zonedSchedule(1, "休憩終了" , finishR[rand.nextInt(finishR.length)],
      tz.TZDateTime.now(tz.UTC).add(Duration(seconds:(controller.duration! * controller.value).inSeconds)),
      NotificationDetails(iOS:  DarwinNotificationDetails(badgeNumber: 1,),),
      androidAllowWhileIdle: true, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    ));}
  Future<void> notify4() async {
  return flnp.initialize(InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher'),),).then((_) => flnp.zonedSchedule(1,  "休憩終了" , finishR[rand.nextInt(finishR.length)],
      tz.TZDateTime.now(tz.UTC).add(Duration(seconds: (controller.duration! * controller.value).inSeconds)),
      NotificationDetails(android:  AndroidNotificationDetails( "休憩終了",  finishR[rand.nextInt(finishR.length)], importance: Importance.high, priority: Priority.high,),),
      androidAllowWhileIdle: true, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,));
  }

  void ankert() {FirebaseFirestore.instance.collection('result').doc(date).update({"タイマー": FieldValue.arrayUnion([widget.A.toString() + "*"+ randomString(3) +"*"+ widget.ID]),});}


  Future<void> data() async {
    DateTime now = DateTime.now();DateFormat outputFormat = DateFormat('yyyy年MM月dd日');date = outputFormat.format(now);
    DateFormat outputFormat1 = DateFormat('yyyy年MM月');months = outputFormat1.format(now);
    DateFormat outputFormat2 = DateFormat('yyyy年');years = outputFormat2.format(now);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var coin = prefs.getInt("コイン") ?? 0;
    coin = coin  + widget.A;
    prefs.setInt("コイン" ,coin);
    var time = prefs.getInt(date)?? 0;
    var month = prefs.getInt(months)?? 0;
    var year = prefs.getInt(years)?? 0;
    prefs.setInt(date, time + widget.A);
    prefs.setInt(months ,month + widget.A);
    prefs.setInt(years ,year + widget.A);
  }

  void start12(){showModalBottomSheet(isScrollControlled: true, context: context,backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) {return Container(
          child: SingleChildScrollView(
              child: Column(children: <Widget>[
                Container(margin :EdgeInsets.only(top:30,bottom: 0,right: 20),width: 150,height: 150, child:Image(image: AssetImage("images/first.png"),),),
                Container(width:double.infinity,margin :EdgeInsets.only(top: 30),child:Text(a,style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 22),textAlign: TextAlign.center,)),
                Container(margin :EdgeInsets.only(top:20),width:100,child: ElevatedButton(
                  child: Text('ガチャ'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: const StadiumBorder(),),
                  onPressed: () {setState(() {a = "お疲れ";});
                  },)),

              ])));});}



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




















class RoundButton extends StatelessWidget {
  const RoundButton({
    Key? key,
    required this.icon,
  }) : super(key: key);
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: CircleAvatar(
        radius: 30,
        child: Icon(
          icon,
          size: 36,
        ),
      ),
    );
  }
}