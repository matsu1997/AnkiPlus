
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
   var itemco = 0;var item = ["1円玉を作るのに3円の材料費がかかる","宝くじ１等が当たるより、隕石に当たる方が確率が高い","現在でも全体の海の5%しか解明されていない","「パフェ」の語源は、「パーフェクト」が由来","マクドナルドのロゴはMではない","コンビニより歯医者の方が多い","ラグビーが生まれたのは、少年がサッカーの試合中にボールを持って相手ゴールに走ったのが由来","電話の声は本人の声では無い","柚子胡椒に胡椒は入っていない","北極よりも南極の方が-30度ほど寒い",
    "南極では風邪を引かない","トウモロコシの粒は必ず偶数になる","かくれんぼ中に鬼が勝手に帰ると監禁罪になる","肘を思いっきりつねっても痛くない","下剤と下痢止めを同時に飲むと下痢になる","カルビは部位の名前ではない","チゲ鍋のチゲは鍋という意味","サハラ砂漠のサハラは砂漠という意味","サルサソースのサルサはソースという意味","サイコロの１が赤いのは日本のみ",
    "日本がティッシュの消費量世界一","1人の血管を繋げると地球2.5周の長さがある","エビチリと天津飯は日本で誕生した","オクラは英語","アイスクリームは賞味期限がない","ガスは無臭。気づくように匂いをつけている","自販機のボタン２つ同時に押すと左側が出る","太平洋より大西洋の方が海水がしょっぱい","鮭は白身魚","頑張っても肘をアゴに付けることは無理",
    "ディズニーランドのトイレには鏡がない","マリオはまだ２６歳","マリオの本名は「マリオ・マリオ」","ルイージの本名は「ルイージ・マリオ」","サザエさんはまだ２４歳","サザエさんに出てくるアナゴさんは２７歳","みかんの皮の汁を風船にかけると割れる","月は毎年約3cmずつ地球から遠ざかっている","マチュピチュの初代村長は野内与吉さんという日本人","訓読みの「訓」は音読み",
    "～」の正式名称は「波ダッシュ」という","歯ブラシは濡らさない方が綺麗に磨ける","力士が食べるものは全て「ちゃんこ」という","オリンピックの金メダルの材料は銀","果汁100%のジュースのみパッケージに果物の断面が使用できる","サザエさんのエンディングの曲は３番の歌詞","「々」の正式名称は「ノマ」","生卵は思いっきり握っても絶対に割れない","ロンドン王妃のわがままでフルマラソンは42.195kmになった","卓球のラケットのサイズはどんなに大きくても良い",
    "小便小僧がおしっこをしているのは爆弾の導火線の火を消すため","感情によって涙の味は変わる","固まった砂糖や塩は、電子レンジで加熱するとサラサラになる","コカ・コーラは元々薬として売っていた","人の腹筋は元々割れている","水を入れたビニール袋をライターで炙っても破れない","豚に真珠の由来はイエス・キリストの言葉","消しゴムがない時代は、鉛筆を消すのにパンが使っていた","保冷剤と消臭剤の中身は一緒","結婚式場の神父はほとんどが偽物",
    "マグロの「トロ」は昔は捨てられていた","ナポリタンは日本が発祥","ミラノ風ドリアは日本が発祥","くしゃみで飛び散るツバの初速は新幹線と同じスピード","剣道の公式試合は二刀流でも出場できる","人は一生のうちに平均15回殺人犯とすれ違っている","鉛筆1本で50km線を書ける","パンケーキの「パン」は食べるパンではなく、フライパンのパンのこと","ラムネとサイダーの違いは、容器が違うだけ","ドラえもんは3ミリ浮いている",
    "アンパンマンに出てくる犬のチーズは元々バイキンマンの手下","味噌汁は4リットル飲むと死ぬ","喉が痛い時はマシュマロを食べると痛みが緩和する","エベレストの山頂では水が71度で沸騰する","コンセントの穴は左の方が大きい","うなぎの旬は夏ではなく冬","幽霊に足がないのは日本だけ","辛味は味覚ではなく、痛覚や温覚に分類される","スイカは腐ると爆発する","蝶を数える時の正式な数え方は1頭、2頭",
    "サッカーにはレッドカード,イエローカード,グリーンカードがある","アンパンマンのあんこは粒あん","ドラミちゃんの本職は大学教授","Googleで「斜め」と検索すると検索画面が斜めになる","Googleで「1回転」と検索すると検索画面が1回転する","イクラはロシア語で「イクラー」という","ナマズは全身に味覚がある","風邪を治す薬は存在しない","オセロは日本が発祥","鯉には胃がない",
    "生海苔を消化できるのは日本人だけ","南極で息を吐いても白くならない","ブロッコリーはキャベツの突然変異で生まれた","虫歯があると宇宙に行けない","元旦は１月１日の朝のみをいう","新年最初のサザエさんは29年連続チョキを出している(2023年時点)","タコはストレスがたまると自分の足を食べる","神様を数える時の単位は「柱」","鼻をつまむと「ん」は発音できない","日本人の50%は他人が握ったおにぎりが食べられない",
     "ガリガリ君の当たり確率は3.2%","レモンの実に含まれるビタミンcはそれほど多い訳ではない","学生服の袖のボタンは鼻水を拭か無いようにつけた。","ウサギの数え方は一羽、二羽","人間は生まれた時にあった300本の骨は,大人になると２０６本に減る","猫は1日うち７０%は寝ている","ゴリラの血液型は全てＢ型","うたた寝でビクッとなる現象を「ジャーキング」という","SOSは何の略語でもない","前に歩くカニもいる",
     "カタツムリには性別がない","1万円札の福沢諭吉の顔は56歳の時","ホッキョクグマの体毛は白ではなく透明","世界で最も多い名前は「ムハンマド」","ルービックキューブは必ず20手以内で揃える事が出来る","氷を電子レンジで加熱しても溶けない","世界で最も多い名字は「張」","カツオやマグロは、泳ぎ続けないと死ぬ","タラバガニはカニではない","雨にはビタミンB12が含まれている",
     "牛乳は浄水器に通すと透明になる","ウサギは寂しくても死なない","「考える人」は考えているのではなく、地獄に落ちる人々を見下ろしている","お菓子のサラダ味の「サラダ」はサラダ油のこと","蚊の主食は血ではなく花の蜜","ナメクジは砂糖でもとける","目玉のオヤジは目を閉じて寝る","アリはどんなに高い所から落ちても死なない","イヌやネコも花粉症にかかる","牛の胃袋は４つある",
   ];
   // "","","","","","","","","","",
   // "","","","","","","","","","",
   // "","","","","","","","","","",
   // "","","","","","","","","","",
  final flnp = FlutterLocalNotificationsPlugin();var rand = new Random();
  var finishS = ["ひと休み!","全力で休憩!","頑張ったね!","良い調子!","集中できた？",];
  var finishR = ["ひと頑張りしますか？","頑張っちゃいますか？","スタートボタン押しちゃえ！","もう1セット行きますか？"];
  var ID = "";var date = "";var months = "";var yesterday = "";var name = "";var text = "勉強中";var start = "";var end = "";var a = "";
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
    day();
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
              Container(width:double.infinity,margin:EdgeInsets.only(top:50),child: Text(text,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 30),textAlign: TextAlign.center,)),
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
                  Container(margin: EdgeInsets.only(top: 100,right: 20),child: Text("勉強",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey[400],fontSize: 15),textAlign: TextAlign.center,)),
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
  void set (){if (co == 0){chishiki();data();co = 1;text = "休憩中";time = widget.B;}else{ankert();co = 0;text = "勉強中";time = widget.A;count = count + 1;}; controller = AnimationController(vsync: this, duration: Duration(seconds: time));
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
    ).then((_) => flnp.zonedSchedule(1, "勉強終了" , finishS[rand.nextInt(finishS.length)],
      tz.TZDateTime.now(tz.UTC).add(Duration(seconds:(controller.duration! * controller.value).inSeconds)),
      NotificationDetails(iOS:  DarwinNotificationDetails(badgeNumber: 1,),),
      androidAllowWhileIdle: true, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    ));
  }
  Future<void> notify2() async {
    return flnp.initialize(InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher'),),).then((_) => flnp.zonedSchedule(1,  "勉強終了" , finishS[rand.nextInt(finishS.length)],
      tz.TZDateTime.now(tz.UTC).add(Duration(seconds: (controller.duration! * controller.value).inSeconds)),
      NotificationDetails(android:  AndroidNotificationDetails( "勉強終了",  finishS[rand.nextInt(finishS.length)], importance: Importance.high, priority: Priority.high,),),
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

  void day (){
    DateTime now = DateTime.now();DateFormat outputFormat = DateFormat('yyyy年MM月dd日');date = outputFormat.format(now);
    yesterday = outputFormat.format(now.subtract(Duration(days: 1)));
    DateFormat outputFormat1 = DateFormat('yyyy年MM月');months = outputFormat1.format(now);
  }
  Future<void> data() async {SharedPreferences prefs = await SharedPreferences.getInstance();
    var renzoku = prefs.getInt("連続") ?? 0;
    var All = prefs.getInt("総勉強時間") ?? 0;
    var time = prefs.getInt(date)?? 0;
    var month = prefs.getInt(months)?? 0;
    var time2 = prefs.getInt(yesterday)?? 0;
    renzoku = renzoku + 1;
    if (time2 != 0 && time == 0){prefs.setInt("連続", renzoku);}
    if (time2 == 0){prefs.setInt("連続",1);}
    prefs.setInt(date, time + widget.A);prefs.setInt(months ,month + widget.A);
    prefs.setInt("総勉強時間" ,All + widget.A); }

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

  Future<void> chishiki() async {
    var co = rand.nextInt(item.length);
    FirebaseFirestore.instance.collection('users').doc(widget.ID).update({"知恵": FieldValue.arrayUnion([item[co]]),});
    showDialog(context: context, builder: (context) =>  AlertDialog(title: Text('お疲れ様でした!',style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
      actions: <Widget>[
        Column(mainAxisAlignment: MainAxisAlignment.center,children: [
          Container(width:double.infinity,margin:EdgeInsets.only(top:10),child: Text("雑学ガチャ",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 15),textAlign: TextAlign.center,)),
          Divider(color: Colors.blueGrey,thickness: 3,indent: 100,endIndent: 100),
          Container(width:double.infinity,margin:EdgeInsets.only(top:10,bottom: 30),child: Text(item[co],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[800],fontSize: 15),textAlign: TextAlign.center,)),
        ],)],));
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