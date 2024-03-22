import 'dart:math';

import 'package:anki/V1/V1Result.dart';
import 'package:audio_session/audio_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'V2Result.dart';


class V2Q extends StatefulWidget {
  V2Q(this.name,this.item,this.All);
  String name;List item;List All;
  @override
  State<V2Q> createState() => _V2QState();
}

class _V2QState extends State<V2Q>with TickerProviderStateMixin , WidgetsBindingObserver {
  var item = [];
  var item1 = [];var item2 = [];var item3 = [];var item4 = [];
  var text = "";var text2 = "";var ID = "";
  var date = ""; var date1 = ""; var date7 = ""; var date30 = "";
  var map = {};
  var count = 0;var itemco = 0;var time = 1;var startTime = "3";
  var co = 0;var CountTime = 0.0;
  var OK = false;var _visible = true;
  Color color  = Colors.red;
  FlutterTts flutterTts = FlutterTts();
  final _player = ja.AudioPlayer(handleInterruptions: false, androidApplyAudioAttributes: false, handleAudioSessionActivation: false,);

  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    getID (); item = widget.item;first ();co = item.length;getTime();
    Future.delayed(Duration(seconds: 3), () {setState(() {startTime = "";_visible = false;OK = true;set();});});
    Future.delayed(Duration(seconds: 2), () {setState(() {startTime = "1";});});
    Future.delayed(Duration(seconds: 1), () {setState(() {startTime = "2";});});
    AudioSession.instance.then((audioSession) async {
      await audioSession.configure(AudioSessionConfiguration.speech());
      _handleInterruptions(audioSession);
    });

  }

  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white,
          leading: Container(alignment: Alignment.center,child:Text(startTime.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 30), textAlign: TextAlign.center,),),
          title: FittedBox(fit: BoxFit.fitWidth, child: Text(time.toString() + "周目", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,), textAlign: TextAlign.center,),),
          automaticallyImplyLeading: false, centerTitle: true,elevation: 0,
          actions: [IconButton(icon: const Icon(Icons.highlight_off,color: Colors.blueGrey,size: 30,), onPressed: () {Navigator.pop(context);},)],
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
              // Container(child: Visibility(visible: _visible, child: Column(children: <Widget>[
              //   Container(width: double.infinity,margin:EdgeInsets.only(top: 100),child:Text(startTime.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 50), textAlign: TextAlign.center,),)
              // ]))),
              Container(margin: EdgeInsets.only(top: 30,bottom:5),width:double.infinity,alignment: Alignment.center, child: Text(item[itemco]["科目"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.grey,fontSize: 15), textAlign: TextAlign.center,),),
              Container(child: Column(children: <Widget>[
                // Container(child: Visibility(visible: _visible, child: Column(children: <Widget>[
                //   Container(width: double.infinity,margin:EdgeInsets.only(top: 30),child:Text(startTime.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 50), textAlign: TextAlign.center,),)
                // ]))),
                Container(margin: EdgeInsets.only(bottom: 5, left: 20, right: 20), child:Text('問題',style: TextStyle(fontWeight: FontWeight.bold),),),
                Container(margin: EdgeInsets.only(top: 3, left: 20, right: 20), width: double.infinity,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.grey.shade200, spreadRadius: 5, blurRadius: 5, offset: Offset(1, 1),),], color: Colors.white,),
                    child: Column(children: <Widget>[
                      Container(margin: EdgeInsets.only(top: 30, left: 10, right: 10,bottom:30),width:double.infinity,alignment: Alignment.center, child: Text(text,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20), textAlign: TextAlign.center,),),
                    ])),
                Container(margin: EdgeInsets.only(top:20,bottom: 5, left: 20, right: 20), child:Text('答え',style: TextStyle(fontWeight: FontWeight.bold),),),
                Container(margin: EdgeInsets.only(top: 3, left: 20, right: 20), width: double.infinity,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.grey.shade200, spreadRadius: 5, blurRadius: 5, offset: Offset(1, 1),),], color: color,),
                    child: Column(children: <Widget>[
                      Container(margin: EdgeInsets.only(top: 30, left: 10, right: 10,bottom:30),width:double.infinity,alignment: Alignment.center, child: Text(text2,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.red,fontSize: 20), textAlign: TextAlign.center,),),
                    ])),
                Container(margin: EdgeInsets.all(10), alignment: Alignment.center, child: Text(CountTime.toString() + "秒後に答えが出ます", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center,),),
                Container(margin: EdgeInsets.all(0), alignment: Alignment.center, child: Text("科目が変わる時に秒数が変わらない事があります", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center,),),
                Container(margin: EdgeInsets.only(top: 30, left: 10, right: 10),
                    child: Row(children: <Widget>[
                      Expanded(
                          child: Container(height: 90, width: 90,
                            child: Visibility(visible: OK,
                              child: ElevatedButton(
                                child: const Text('覚えた',style: TextStyle(fontWeight: FontWeight.bold),),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green,
                                  shape: const CircleBorder(side: BorderSide(color: Colors.green, width: 1, style: BorderStyle.solid,),),),
                                onPressed: () {add();correct();getTime ();set();},
                              ),),)),
                      Container(width: 10,),
                      Expanded(child: Container(height: 90, width: 90, child: Visibility(visible: OK,
                        child: ElevatedButton(
                          child: const Text('まだ',style: TextStyle(fontWeight: FontWeight.bold),),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red,
                            shape: const CircleBorder(side: BorderSide(color: Colors.red, width: 1, style: BorderStyle.solid,),),),
                          onPressed: () {itemco = itemco + 1;getTime ();set();},
                        ),),))])),
              Container(margin:EdgeInsets.only(top:20,bottom: 20,left: 50,right: 50),child:
              ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(5)), child: LinearProgressIndicator(
                value: item.length / co, valueColor: AlwaysStoppedAnimation(getCurrentHpColor(10)),
                backgroundColor: Colors.grey, minHeight: 20,),),),
              Text('${item.length.toString().padLeft(0, '  ')}/${co.toString()}'),
              ],)),])
        ));}

  Color getCurrentHpColor(int hp) {
    if (hp > co / 2) {return const Color(0xFF00D308);}
    if (hp > co / 5) {return const Color(0xFFFFC107);}
    return const Color(0xFFFF0707);
  }

  void first (){if (widget.item.length > 10){ item = item.take(10).toList();}}
 Future<void> getID () async {SharedPreferences prefs = await SharedPreferences.getInstance();ID =  prefs.getString("ID")!;}
  Future<void> getTime () async {SharedPreferences prefs = await SharedPreferences.getInstance();  CountTime =  prefs.getDouble("CountTime" + item[itemco]["科目"])?? 0;
  if (CountTime == 0){
    switch (item[itemco]["科目"]) {
      case "英単語":CountTime = 1.5; break;
      case "漢字":CountTime = 1.5; break;
      case "古文":CountTime = 1.5; break;
      case "漢文単語":CountTime = 1.5; break;
      case "世界史":CountTime = 2.0; break;
      case "日本史":CountTime = 2.0; break;
      case "生物":CountTime = 2.0; break;
      case "自作":CountTime = 2.0; break;
    }}}
  void set (){setState(() {
     // final rand = new Random();print(item);
     // itemco = rand.nextInt(item.length);print(itemco);
    if (item.length != 0){getTime ();
      if (itemco < item.length){
        color = Colors.red;text = item[itemco]["Q"];text2 = item[itemco]["A"];
        speak();Future.delayed(Duration(seconds: CountTime.toInt()), () {setState(() {color = Colors.white;});});
      }else{itemco = 0;time = time + 1;
      color = Colors.red;text = item[itemco]["Q"];text2 = item[itemco]["A"];
      speak();Future.delayed(Duration(seconds: CountTime.toInt()), () {setState(() {color = Colors.white;});});
      }
    }else{Navigator.of(context).push(MaterialPageRoute(builder: (context) => V2Result(item1,item2,item3,item4,widget.name,widget.item,widget.All)),);}
  });}

  void add (){
    switch (time){
      case 1 :item1.add({"Q":item[itemco]["Q"],"A":item[itemco]["A"],"レベル":0,"date":date});break;
      case 2 :item2.add({"Q":item[itemco]["Q"],"A":item[itemco]["A"],"レベル":1,"date":date});break;
      case 3 :item3.add({"Q":item[itemco]["Q"],"A":item[itemco]["A"],"レベル":2,"date":date});break;
      default:item4.add({"Q":item[itemco]["Q"],"A":item[itemco]["A"],"レベル":3,"date":date});break;
    }
  }

  void correct (){
    if(widget.name == "昨日正解" ||widget.name == "7日前正解"||widget.name == "30日前正解"){
      switch (widget.name){
        case "昨日正解" :
        for(int i = 0; i< widget.All.length; i++){setState(() {if(widget.All[i]["Q"] == item[itemco]["Q"] ){widget.All[i]["dateC"] = 1;}});};break;
        case "7日前正解" : for(int i = 0; i< widget.All.length; i++){setState(() {if(widget.All[i]["Q"] == item[itemco]["Q"] ){widget.All[i]["dateC"] = 2;}});};break;
        case "30日前正解" : for(int i = 0; i< widget.All.length; i++){setState(() {if(widget.All[i]["Q"] == item[itemco]["Q"] ){widget.All[i]["dateC"] = 3;}});};break;
        default:;break;
      }
     // widget.item[itemco]["dateC"] = 1;
      item.removeAt(itemco);
    }else{
      if(co > 9){
        print(itemco);print(widget.item);print(item);
        item.removeAt(itemco);
        widget.item.removeAt(itemco);}else{
        item.removeAt(itemco);
      }}
  }

  Future<void> speak() async {
    if (item[itemco]["科目"] == "英単語"){await flutterTts.setLanguage("en-US");} else{flutterTts.setLanguage("ja-JP");}
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);
    await flutterTts.setVolume(1.0);
    if (item[itemco]["科目"] == "漢字" ||item[itemco]["科目"] == "世界史" ||item[itemco]["科目"] == "日本史" ||item[itemco]["科目"] == "漢文単語"||item[itemco]["科目"] == "生物" ){ await flutterTts.speak("");} else{ await flutterTts.speak(text);}
  }


  Future initAudioService() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.mixWithOthers,
      avAudioSessionMode: AVAudioSessionMode.defaultMode,
      avAudioSessionRouteSharingPolicy:
      AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: AndroidAudioAttributes(
        contentType: AndroidAudioContentType.music,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.media,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransientMayDuck,
      androidWillPauseWhenDucked: true,
    ));
  }


  Future<void> _handleInterruptions(AudioSession audioSession) async {
    bool playInterrupted = false;
    audioSession.becomingNoisyEventStream.listen((_) {
    });
    _player.playingStream.listen((playing) {
      playInterrupted = false;
      if (playing) {
        audioSession.setActive(true);
      }
    });
    audioSession.interruptionEventStream.listen((event) async {
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            if (audioSession.androidAudioAttributes!.usage ==
                AndroidAudioUsage.game) {
              _player.setVolume(_player.volume / 1.5);
            }
            playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            initAudioService();
            break;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            _player.setVolume(min(1.0, _player.volume * 2));
            playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
            if (playInterrupted) _player.play();
            playInterrupted = false;
            break;
          case AudioInterruptionType.unknown:
            playInterrupted = false;
            break;
        }
      }
    });
  }
  Future<void> initializeService1() async {
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart1,
        autoStart: false,
        isForegroundMode: false,
        notificationChannelId: 'my_foreground',
        initialNotificationTitle: 'AWESOME SERVICE',
        initialNotificationContent: 'Initializing',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: onStart1,
      ),);
    service.startService();
  }

  @pragma('vm:entry-point')
  void onStart1(ServiceInstance service) async {
    service.stopSelf();
  }


}

