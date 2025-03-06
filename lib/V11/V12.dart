import 'package:anki/V11/te.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// ↓ dart_openaiをインポート
import 'package:dart_openai/dart_openai.dart';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../AdManager.dart';
import 'dart:convert';
import '../../V11/test3.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';


class MyPlannerApp extends StatefulWidget {
  final V11A = V11();
  @override
  _MyPlannerAppState createState() => _MyPlannerAppState();
}

class _MyPlannerAppState extends State<MyPlannerApp> {
  String _selectedPlanType = "今日1日の予定";
  final List<String> planTypes = [
    "今日1日の予定",
    "今からの予定",
    "明日の予定",
  ];
 var item = [];
  // 外せない用事（タスク）を保持するリスト
  final List<_TaskModel> _tasks = [];
  final formatter = DateFormat('hh:mm:ss');
  // 終了時間のテキスト入力
  final TextEditingController _endTimeController = TextEditingController();
  var items = ["1","2","3","4","5","6","7","8","9","10"]; var items2 = ["25分","30分","45分","60分","90分"]; var items3 = ["イージー","ノーマル","ハード"];
  var count = "1";var lunch = "なし";var dinner = "なし";var time = "25分";var level = "ノーマル";var buss = "なし";
  late final GenerativeModel _model;
  var geminiText = "";
  var apiKey = "";
  Duration remainingTime = Duration(seconds: 0); Duration remainingTime1 = Duration(seconds: 0); Duration remainingTime2 = Duration(seconds: 0);
  var isOnA1 = false; var isOnA2 = false;var isOnA3 = false;
  var AddBool = false;var tap = "";
  var ID  = "";
  var now = DateTime.now();
  @override
  void initState() {
    super.initState();interstitialAd();
    // dart_openai の初期設定
    first ();
    Timer.periodic(Duration(seconds: 1), (timer) {setState(() {now = DateTime.now();});});
    _initializeModel();
    // 必要であればProxies設定・Organization設定などを行う
  }
  Future<void> _initializeModel() async {
    try{apiKey = dotenv.env['GEMINI_API_KEY']??"";  // YOUR_API_KEY を実際のAPIキーに置き換えてください。
    if (apiKey.isEmpty) {return;}
    _model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: apiKey);
    }catch(e){}}

  @override
  Widget build(BuildContext context) {
    return  Scaffold(backgroundColor: Colors.blueGrey[900],
        appBar: AppBar(backgroundColor: Colors.blueGrey[900],elevation: 0,
         // title: const Text('1日の計画を作る (Single Class)'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(margin: EdgeInsets.only(top: 10), alignment: Alignment.center, child: Text("スケジュールを最適化",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20))),
            Container(margin: EdgeInsets.only(top: 10), alignment: Alignment.center, child: Text("『今』からの1日のスケジュールをAIが作成",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 10))),
            // Container(margin: EdgeInsets.only(top: 0),
            //   child: PopupMenuButton<String>(
            //     child: Text( _selectedPlanType,style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 15)),
            //     onSelected: (value) {setState(() {_selectedPlanType = value;});},
            //itemBuilder: (BuildContext context) {return planTypes.map((item) {return PopupMenuItem<String>(value: item, child: Text(item),);}).toList();},),),
            //Row(mainAxisAlignment: MainAxisAlignment.center,children: [
              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
              Container(child: Text("昼食",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white,fontSize: 15),textAlign: TextAlign.center,),),
              Switch(value: isOnA1, onChanged: (bool? value) {if (value != null) {setState(() {isOnA1 = value!;if(isOnA1 == true){lunch = "あり";}else{lunch = "なし";}});}},),
                Container(margin: EdgeInsets.only(top: 0), child: TextButton( onPressed: () => _showTimerPicker("昼食"),  child: Text(formatDuration(remainingTime1), style: const TextStyle(fontSize: 20, color: Colors.orangeAccent, fontWeight: FontWeight.bold,),))),
              ],),
            Row(mainAxisAlignment: MainAxisAlignment.center,children: [
              Container(child: Text("夕食",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white,fontSize: 15),textAlign: TextAlign.center,),),
              Switch(value: isOnA2, onChanged: (bool? value) {if (value != null) {setState(() {isOnA2 = value!;if(isOnA2 == true){dinner = "あり";}else{dinner = "なし";}});}},),
              Container(margin: EdgeInsets.only(top: 0), child: TextButton( onPressed: () => _showTimerPicker("夕食"),  child: Text(formatDuration(remainingTime2), style: const TextStyle(fontSize: 20, color: Colors.orangeAccent, fontWeight: FontWeight.bold,),))),
            ],),
              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                Container(child: Text("お風呂",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white,fontSize: 15),textAlign: TextAlign.center,),),
                Switch(value: isOnA3, onChanged: (bool? value) {if (value != null) {setState(() {isOnA3 = value!;if(isOnA3 == true){buss = "あり";}else{buss = "なし";}});}},),
              ],),
            Row(mainAxisAlignment: MainAxisAlignment.center,children: [
              Container(child: Text("科目数 :  ",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white,fontSize: 15),textAlign: TextAlign.center,),),
              Container(margin: EdgeInsets.only(top: 0),
                child: PopupMenuButton<String>(
                  child: Text(count,style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 15)),
                  onSelected: (value) {setState(() {count= value;});},
                  itemBuilder: (BuildContext context) {return items.map((item) {return PopupMenuItem<String>(value: item, child: Text(item),);}).toList();},),),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center,children: [
              Container(child: Text("1回あたりの勉強時間 :  ",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white,fontSize: 15),textAlign: TextAlign.center,),),
              Container(margin: EdgeInsets.only(top: 0),
                child: PopupMenuButton<String>(
                  child: Text(time,style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 15)),
                  onSelected: (value) {setState(() {time= value;});},
                  itemBuilder: (BuildContext context) {return items2.map((item) {return PopupMenuItem<String>(value: item, child: Text(item),);}).toList();},),),
            ]),
            // Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            //   Container(child: Text("レベル :  ",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white,fontSize: 15),textAlign: TextAlign.center,),),
            //   Container(margin: EdgeInsets.only(top: 0),
            //     child: PopupMenuButton<String>(
            //       child: Text(level,style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 15)),
            //       onSelected: (value) {setState(() {level= value;});},
            //       itemBuilder: (BuildContext context) {return items3.map((item) {return PopupMenuItem<String>(value: item, child: Text(item),);}).toList();},),),
            // ]),
            Container(margin: EdgeInsets.only(top: 2), alignment: Alignment.center,child:Row(mainAxisAlignment:MainAxisAlignment.center,children: [
             Container(margin: EdgeInsets.only(top: 0), alignment: Alignment.center, child: Text("寝る時間",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15))),
             Container(margin: EdgeInsets.only(top: 0), child: TextButton( onPressed: () => _showTimerPicker("寝る"),  child: Text(formatDuration(remainingTime), style: const TextStyle(fontSize: 20, color: Colors.orangeAccent, fontWeight: FontWeight.bold,),))),
           ],)),

            // Container(margin: EdgeInsets.only(top: 2), alignment: Alignment.center,child:Row(mainAxisAlignment:MainAxisAlignment.center,children: [
            //   Container(height:30,margin: EdgeInsets.only(top: 0,left: 0), alignment: Alignment.center, child: Text("外せない用事",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15))),
            // Container(height:30,margin: EdgeInsets.only(top: 0),child:IconButton(
            //   onPressed: () { _addTask();}, icon:Icon(Icons.add_circle_outline,color: Colors.orangeAccent,size: 20,),
            // ))],)),
            //   ListView.builder(shrinkWrap: true, itemCount: _tasks.length, itemBuilder: (context, index) {final task = _tasks[index];
            //       return Container( decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.circular(8)), margin: EdgeInsets.only(top:10,left: 20,right: 20),child:
            //       ListTile(contentPadding: EdgeInsets.zero,
            //           leading: Container( margin:EdgeInsets.only(top:10,left: 10),child:Icon(Icons.event)),
            //         title:Text(task.startTime.toString(),style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
            //         subtitle: Text(task.title),
            //         trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () {setState(() {_tasks.removeAt(index);});},),
            //
            //       ));},),

           //   TextField(controller: _endTimeController, decoration: const InputDecoration(labelText: "終了時間 (例: 23:00)", border: OutlineInputBorder(),),),
            Container(margin :EdgeInsets.only(top:0),width:100,child: ElevatedButton(
              child: Text('作成'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, shape: const StadiumBorder(),),
              onPressed: () {main1(_tasks);
                //_sendMessage(formatDuration(remainingTime),_tasks.toString as String);
                },)),
            Container(margin: EdgeInsets.only(top: 10), alignment: Alignment.center, child: Text("表示まで10秒ほどかかります",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 7))),
            Container(margin: EdgeInsets.only(left: 20,right: 20,top: 20),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(), itemCount: item.length, itemBuilder: (context, index) {
                return GestureDetector(onTap: () {
                  print(item[index]["end"]);
                 // Navigator.of(context).push(MaterialPageRoute(builder: (context) => CountdownTimer2()),);
                  },
                    child: Container(margin: EdgeInsets.all(5),color: Colors.grey[200],child:
                     ( DateFormat('HH:mm:ss').parse(now.hour.toString() +":"+now.minute.toString()+":"+now.second.toString()).isAfter(DateFormat('HH:mm:ss').parse(item[index]["start"]+ ":00")) == true &&  DateFormat('HH:mm:ss').parse(now.hour.toString() +":"+now.minute.toString()+":"+now.second.toString()).isBefore( DateFormat('HH:mm:ss').parse(item[index]["end"]+ ":00")) == true)?
                        Container(color: Colors.orangeAccent.shade100,child:Column(children: [
                      Container(margin: EdgeInsets.all(5),width:double.infinity,child:Text(item[index]["start"]+"-"+item[index]["end"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                      Container(margin: EdgeInsets.all(5),width:double.infinity,child:Text(item[index]["task"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),],)
                        ):
                    Container(child:Column(children: [
                      Container(margin: EdgeInsets.all(5),width:double.infinity,child:Text(item[index]["start"]+"-"+item[index]["end"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                      Container(margin: EdgeInsets.all(5),width:double.infinity,child:Text(item[index]["task"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),],)
                     )  ));},),),
            Container(margin:EdgeInsets.only(top:0,bottom: 0),child: (AddBool == true)?
            Column(mainAxisAlignment: MainAxisAlignment.center,children: [
              Container(margin:EdgeInsets.only(),child: (tap == "" )?
              Container(child:IconButton(icon: Icon(Icons.bookmark_add_outlined,color: Colors.orange,size: 30,), onPressed: () {add();},)) :
              Container(child:IconButton(icon: Icon(Icons.bookmark_add,color: Colors.orange,size: 30,), onPressed: () {add();},)))
              ,Container(margin:EdgeInsets.only(top:0,bottom: 50),child: Text("保存",style: TextStyle(color:Colors.blueGrey[900],fontSize: 10),textAlign: TextAlign.center,),),
            ],):
            Container()
            ),
              ],),),);}
  DateTime? parseDate(String dateString) {try {return DateFormat('HH:mm').parse(dateString); } catch (e) {print('日付のパースに失敗しました: $e');return null;}}

  void main1(_tasks) {
    var text = "";
    for (int i = 0; i < _tasks.length ; i = i + 1) {
      text = text + formatter.format(_tasks[i].startTime) + "〜" + formatter.format(_tasks[i].endTime)+ "まで" + _tasks[i].title+ "がある。";print(text);
    }{ final now = DateTime.now();print(now.day);print(now.hour);print(now.minute);
      _sendMessage(formatDuration(Duration(hours:now.hour,minutes:now.minute)),formatDuration(remainingTime),text,lunch,dinner,count,time,level,buss,formatDuration(remainingTime1),formatDuration(remainingTime2));}
  }

  Future<void> add() async {
    final now = DateTime.now();
    DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(ID).collection("スケジュール").doc(now.year.toString()+now.month.toString()+now.day.toString());
    ref.set({"スケジュール": item,"日付":now.year.toString()+now.month.toString()+now.day.toString()});
    setState(() {tap = "tap";});
  }

  void first () async {
    final now = DateTime.now();
    SharedPreferences prefs = await SharedPreferences.getInstance();ID =  prefs.getString("ID")!;
    FirebaseFirestore.instance.collection('users').doc(ID).collection("スケジュール").where("日付" ,isEqualTo: now.year.toString()+now.month.toString()+now.day.toString()).get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {setState(() {item = doc["スケジュール"]??[]; //if(widget.co == 1){item.shuffle();}
      });;});});}

  Future<void> _sendMessage(String text01,String text0,String text1,String lunch,String dinner, String count,String time,String level,String buss,lunchTime,dinnerTime) async {
  setState(() {;});showInterstitialAd();
  text0 = text0.replaceAll(",", "、");
  // final text = "現在("+text01+")の時刻からの寝るまで("+text0+")の勉強タイムスケジュールを組んで(勉強時間は一回あたり60分まで)。このユーザーは" +text1+ "このような用事がありますので考慮し組み込んでください。出力は以下のJSON形式でしてください。不要な文章やvar list =などは必要ありません。例は[{\"時間\":\"6:00 - 6:30\", \"やること\":\"起床、朝日を浴びる\"},{\"時間\":\"6:30 - 7:00\", \"やること\":\"軽い朝食\"}]0";
 // final text = "現在の時刻("+text01+")から"+ "就寝の時刻("+ text0 +")までの勉強のタイムスケジュール(ハード目)を組んで。日常生活動作は一般的な時間にして。出力は次のようにしてJSON型で欲しい。余計な文章はいらない。[{'time': '10:50 - 11:00', 'task': '準備、今日の目標確認', 'duration': 10},{'time': '11:00 - 12:30', 'task': '科目A', 'duration': 90},{'time': '12:30 - 13:30', 'task': '昼食・休憩', 'duration': 60},{'time': '13:30 - 15:00', 'task': '科目B', 'duration': 90},{'time': '15:00 - 15:15', 'task': '休憩・気分転換', 'duration': 15},{'time': '15:15 - 16:45', 'task': '科目C', 'duration': 90},{'time': '16:45 - 17:00', 'task': '休憩・軽い運動', 'duration': 15},{'time': '17:00 - 18:30', 'task': '科目D', 'duration': 90},{'time': '18:30 - 19:30', 'task': '夕食', 'duration': 60},{'time': '19:30 - 21:00', 'task': '復習・弱点補強', 'duration': 90},{'time': '21:00 - 21:15', 'task': '休憩', 'duration': 15},{'time': '21:15 - 22:45', 'task': '明日への準備・予習', 'duration': 90},{'time': '22:45 - 23:00', 'task': '就寝準備・軽い読書など', 'duration': 15}];";
  final text = text01+"時(分は0,15,30,45の中でこれから近い所を選んで)から"+ "就寝の時刻("+ text0 +")までの勉強のタイムスケジュール("+level +")を組んで。条件は勉強時間は1回あたり大体"+time +"までで休憩を5~15分挟む。"+count +"科目する。昼食は大体"+lunchTime +":"+lunch +",夕食は大体"+dinnerTime +":"+dinner +",お風呂"+buss+"。出力は次のようにしてJSON型で余計な文章はいらない。[{'task': '準備、今日の目標確認','start': '10:50','end': '11:00',},{'task': '科目A','start': '11:00','end': '12:30',},...{'task': '休憩','start': '21:00','end': '21:15',},{'task': '明日への準備・予習','start': '21:15','end': '22:45',},{'task': '就寝準備・軽い読書など','start': '22:45','end': '23:00',},];];";
  if (text.isEmpty) return;
  try{
    final response = await _model.generateContent([Content.text(text)]);
    var geminiText = response.text ?? 'No response';
    geminiText = geminiText.replaceAll("```json", "");
    geminiText = geminiText.replaceAll("```", "");
    print(geminiText);
    final jsonResult = await main(geminiText);

    if (jsonResult != null) {
      setState(() {print(jsonResult);
        item = jsonResult;AddBool = true;
         });
    } else {
      setState(() {
      });
    }
  }catch(e){
    setState(() {});
  } finally {setState(() {});}
  }


  // jsonをパースする関数
  Future<dynamic> main(String geminiText) async {
    try {
      final dynamic parsedJson = jsonDecode(geminiText);
      return parsedJson;
    } catch (e) {
      print('JSON parse error: $e');
      return null; // パース失敗時はnullを返す
    }interstitialAd();
  }

  /// 外せない用事(タスク)を追加する処理
  Future<void> _addTask() async {
    // 開始時刻
    final startTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );
    if (startTime == null) return;

    // 終了時刻
    final endTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: startTime.hour + 1, minute: startTime.minute),
    );
    if (endTime == null) return;

    // タイトル入力
    final title = await showDialog<String>(
      context: context,
      builder: (_) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text("用事のタイトル"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "例: 会議"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text("キャンセル"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text("追加"),
            ),
          ],
        );
      },
    );

    // タイトルが空の場合はキャンセル扱い
    if (title == null || title.isEmpty) return;

    // TimeOfDay -> DateTime に変換
    final now = DateTime.now();
    final startDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      startTime.hour,
      startTime.minute,
    );
    final endDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      endTime.hour,
      endTime.minute,
    );

    setState(() {
      _tasks.add(_TaskModel(
        startTime: startDateTime,
        endTime: endDateTime,
        title: title,
      ));
    });
  }
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  Future<void> _showTimerPicker(String position) async {
    switch (position) {
      case"昼食":
        showModalBottomSheet(context: context, builder: (BuildContext builder) {
          return Container(height: 200, child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hm,
            initialTimerDuration: remainingTime1,
            onTimerDurationChanged: (Duration newDuration) {
              setState(() {remainingTime1 = newDuration;});},
          ));});
      case"夕食":
      showModalBottomSheet(context: context, builder: (BuildContext builder) {
        return Container(height: 200, child: CupertinoTimerPicker(
          mode: CupertinoTimerPickerMode.hm,
          initialTimerDuration: remainingTime2,
          onTimerDurationChanged: (Duration newDuration) {
            setState(() {remainingTime2 = newDuration;});},
        ));});
      case"寝る":
      showModalBottomSheet(context: context, builder: (BuildContext builder) {
        return Container(height: 200, child: CupertinoTimerPicker(
          mode: CupertinoTimerPickerMode.hm,
          initialTimerDuration: remainingTime,
          onTimerDurationChanged: (Duration newDuration) {
            setState(() {remainingTime = newDuration;});},
        ));});
    }
  }
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
  void interstitialAd() {
    if (ID != "FAP3jZy3pSTEmqJQN1ow"){
      InterstitialAd.load(adUnitId: Platform.isAndroid ? 'ca-app-pub-4716152724901069/2563672557' : 'ca-app-pub-4716152724901069/7560014210',
        request: AdRequest(),//ca-app-pub-4716152724901069/7560014210
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {_interstitialAd = ad;_isAdLoaded = true;},
          onAdFailedToLoad: (error) {
            print('Interstitial ad failed to load: $error');},),);}}

  void showInterstitialAd() {
    if (_isAdLoaded) {_interstitialAd?.fullScreenContentCallback;_interstitialAd?.show();
    } else {print('Interstitial ad is not yet loaded.');}}

  /// スケジュール作成ボタンを押したとき
//   Future<void> _onSubmit() async {
//     if (_endTimeController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("終了時間を入力してください")),
//       );
//       return;
//     }
//
//     // タスク情報を文字列にまとめる
//     final tasksStringList = _tasks.map((t) {
//       final start = DateFormat('HH:mm').format(t.startTime);
//       final end = DateFormat('HH:mm').format(t.endTime);
//       return "$start ~ $end ${t.title}";
//     }).toList();
//
//     // ChatGPTへ送るプロンプトを組み立てる
//     final prompt = '''
// あなたは私の1日のスケジュールを考えるアシスタントです。
// プランの種類: $_selectedPlanType
// 外せない予定:
// ${tasksStringList.isNotEmpty ? tasksStringList.map((t) => '- $t').join('\n') : '特に外せない予定はありません。'}
// 終了時間: ${_endTimeController.text}
//
// 上記を踏まえて、最適なスケジュールを提案してください。
// 可能であれば、時間帯ごとに箇条書きでわかりやすく提案をお願いします。
// ''';
//
//     try {
//       // ChatCompletionを作成して問い合わせ
//       final chatCompletion = await OpenAI.instance.chat.create(
//         model: _model,
//         messages: [
//           // systemロール
//           OpenAIChatCompletionChoiceMessageModel(
//             role: OpenAIChatMessageRole.system,
//             content: "あなたは予定管理に詳しいアシスタントです。",
//           ),
//           // userロール
//           OpenAIChatCompletionChoiceMessage(
//             role: OpenAIChatMessageRole.user,
//             content: prompt,
//           ),
//         ],
//       );
//
//       // 応答を取り出す
//       final responseText = chatCompletion.choices.first.message.content?.trim();
//       setState(() {
//         _chatGPTResponse = responseText;
//       });
//     } catch (e) {
//       setState(() {
//         _chatGPTResponse = "エラーが発生しました: $e";
//       });
//     }
//   }
}

/// タスクを表すクラス（同じファイル内に定義）
class _TaskModel {
  final DateTime startTime;
  final DateTime endTime;
  final String title;

  _TaskModel({
    required this.startTime,
    required this.endTime,
    required this.title,
  });
}

//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:http/http.dart' as http; // ChatGPT API用
// import 'package:timezone/timezone.dart' as tz;
// import 'package:http/http.dart' as http;
// import 'package:flutter/cupertino.dart';
// import 'package:timezone/data/latest.dart' as tz;
//
//
//
// class V11 extends StatefulWidget {
//   @override
//   State<V11> createState() => _V11State();
// }
//
// class _V11State extends State<V11> with WidgetsBindingObserver{
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(backgroundColor: Colors.blueGrey[900],
//       appBar: AppBar(backgroundColor: Colors.blueGrey[900],elevation: 0,
//         actions: [],),
//       body: Container(),
//     );
//   }
//
//
// }

