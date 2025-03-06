import 'package:anki/V11/te.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // For formatting dates
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' as http; // ChatGPT API用
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:ui';
import 'package:timezone/data/latest.dart' as tz;

import 'V12.dart';



class V11 extends StatefulWidget {
  @override
  State<V11> createState() => _V11State();
}

class _V11State extends State<V11> with WidgetsBindingObserver{

  List<String> items = [];
  List<String> items2 = ["合計"];
  final List<Color> colors = [
    Color(0xFF5F9EA0), // CadetBlue
    Color(0xFF4682B4), // SteelBlue
    Color(0xFF7B68EE), // MediumSlateBlue
    Color(0xFFFA8072), // Salmon
    Color(0xFFFFD700), // Gold
    Color(0xFFFF4500), // OrangeRed
    Color(0xFF4169E1), // RoyalBlue
    Color(0xFF32CD32), // LimeGreen
    Color(0xFF2E8B57), // SeaGreen
    Color(0xFF00CED1), // DarkTurquoise
    Color(0xFF40E0D0), // Turquoise
    Color(0xFF008080), // Teal
    Color(0xFFB22222), // FireBrick
    Color(0xFF8B0000), // DarkRed
    Color(0xFF800080), // Purp
    Color(0xFF6A5ACD), // SlateBlue// le
    Color(0xFF4B0082),
    Color(0xFF0000FF), //// Indigo
    Color(0xFF808000), // Olive
    Color(0xFFFFE4B5), // Moccasin
    Color(0xFFADFF2F), // GreenYellow
    Color(0xFF7FFF00), // Chartreuse
    Color(0xFFFF6347), // Tomato
    Color(0xFFFFA500), // Orange
    Color(0xFFFFC0CB), // Pink
    Color(0xFFFF69B4), // HotPink
    Color(0xFFFF1493), // DeepPink
    Color(0xFFDC143C), // Crimson
    Color(0xFFFF0000), // Red
    Color(0xFF00FF00), // GreenBlue
    Color(0xFFFFFF00), // Yellow
    Color(0xFF00FFFF), // Cyan
    Color(0xFFFF00FF), // Magenta
    Color(0xFFFF8C00), // DarkOrange
    Color(0xFF9400D3), // DarkViolet
    Color(0xFF008B8B), // DarkCyan
    Color(0xFF1E90FF), // DodgerBlue
    Color(0xFF8A2BE2), // BlueViolet
    Color(0xFFFF00FF), // Fuchsia
  ];
  List<String> item= ["Today", "Month", "Total"];List<String> item2 = ["StopWatch", "Countdown"];var co = 0;var text = "Today";
  String? selectedSubject = "選択なし";
  Duration elapsedTime = Duration(seconds: 0);
  Map<String, Map<String, Duration>> studyTime = {}; // 科目ごとの今日・今月・総計時間
  Duration totalToday = Duration(seconds: 0);
  Duration totalMonth = Duration(seconds: 0);
  Duration totalAllTime = Duration(seconds: 0);
  Timer? _timer;
  bool isRunning = false;
  var todayKey = "";
  var monthKey = ""; Duration addTime = Duration(seconds: 0);
  var totalKey = "全体";var formattedTime ="";var text2 ="選択なし";var  WitchTimer = "";
  int _currentPageIndex = 0;  Duration remainingTime = Duration(seconds: 0);
  var _isScrollable  = true;
  PageController _pageController = PageController();late TextEditingController _bodyController;
  @override
  void initState() {
    super.initState();first();start();_bodyController = TextEditingController();
    WidgetsBinding.instance.addObserver(this);no(); debugPrint('initState');
  }

  Future<void> no () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bb = prefs.getInt("V11")?? 0;
    if (bb == 0){
      showDialog(context: context, builder: (context) => AlertDialog(title:Container(child: Column(children: [
        Container(child:  Text("こちらはテストリリースになります。バグや感想などの報告をぜひお願いいたします🙇",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center)),
         ],),)  ));
      prefs.setInt("V11",1);
    }else{}
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this); // ライフサイクル監視を終了
    debugPrint('App Disposed');
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // ライフサイクルの状態を判別
    switch (state) {
      case AppLifecycleState.resumed:
        // WidgetsBinding.instance.removeObserver(this);
        // first();start();_bodyController = TextEditingController();
        // WidgetsBinding.instance.addObserver(this);
        break;
      case AppLifecycleState.inactive:
        if (WitchTimer == "1"){
          _timer?.cancel();
        WidgetsBinding.instance.removeObserver(this);
        first();start();_bodyController = TextEditingController();
        WidgetsBinding.instance.addObserver(this);}
        debugPrint('App is Inactive');
        break;
      case AppLifecycleState.paused:_timer?.cancel();
        debugPrint('App in Background (paused)');
        break;
      case AppLifecycleState.detached:
        debugPrint('App Detached (detached)');
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
      //  throw UnimplementedError();
    }
  }

  var StartTime = DateTime.now();var startBool = false;
  var EndTime = DateTime.now();var endBool = true;
  var dif = 0;

  void toggleIsActive(bool value) {
    setState(() {
      _isScrollable = value;
    });
  }
  Future<void> start() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var bb = prefs.getInt("StartTime")?? 0; WitchTimer = prefs.getString("どっちのタイマー")??"";
  if (bb == 0){}else{ selectedSubject = prefs.getString("選択科目")??"選択なし";text2 = prefs.getString("選択科目")??"選択なし";end();
  }setState(()  {if(WitchTimer == "2"){_pageController.jumpToPage(1);_isScrollable  = false;}if(WitchTimer == "1"){_isScrollable  = false;}});}

  Future<void> end()  async {endBool = true;startBool = false;
  SharedPreferences prefs = await SharedPreferences.getInstance();
    var bb = prefs.getInt("StartTime")?? 0;
    var aa = DateTime.now().millisecondsSinceEpoch~/ 1000;
  setState(()  {   dif = (aa - bb);isRunning = false;startTimer(dif);});
  }

  Future<void> startTimer(add) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    WitchTimer = prefs.getString("どっちのタイマー")??"";
    if (WitchTimer == "1"){
    if (!isRunning ) {
      elapsedTime = Duration(seconds: add);
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {elapsedTime = elapsedTime + Duration(seconds: 1);});});
      setState(() {isRunning = true;});}}}

  void stopTimer() {
    if (isRunning) {
      _timer?.cancel();
      if (selectedSubject != null) {
        studyTime[selectedSubject!]![todayKey] =
            (studyTime[selectedSubject!]![todayKey] ?? Duration(seconds: 0)) + elapsedTime;
        studyTime[selectedSubject!]![monthKey] =
            (studyTime[selectedSubject!]![monthKey] ?? Duration(seconds: 0)) + elapsedTime;
        studyTime[selectedSubject!]![totalKey] =
            (studyTime[selectedSubject!]![totalKey] ?? Duration(seconds: 0)) + elapsedTime;
        totalToday += elapsedTime;
        totalMonth += elapsedTime;
        totalAllTime += elapsedTime;
        saveStudyData(selectedSubject!, elapsedTime);}
      setState(() {loadStudyData();isRunning = false;elapsedTime = Duration(seconds: 0);});}
  }

  Future<void> toggleTimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isRunning) {
      prefs.setInt("StartTime",0);
      prefs.setString("選択科目","選択なし");prefs.setString("どっちのタイマー","");_isScrollable  = true;
      stopTimer();report("_today_${DateFormat('yyyy-MM-dd').format(DateTime.now())}","_month_${DateFormat('yyyy-MM').format(DateTime.now())}");
    } else {
      endBool = false;startBool = true;StartTime = DateTime.now();
      var aa =  DateTime.now().millisecondsSinceEpoch~/ 1000;;
      prefs.setInt("StartTime",aa);_isScrollable  = false;
      prefs.setString("選択科目",text2); prefs.setString("どっちのタイマー","1");
      startTimer(0);
    }
  }

  Future<void> resetTimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("StartTime",0);prefs.setString("選択科目","選択なし");prefs.setString("どっちのタイマー","");_isScrollable  = true;
    stopTimer();
    setState(() {
      elapsedTime = Duration(seconds: 0);
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  Future<void> saveStudyData(String subject, Duration duration) async {
    final prefs = await SharedPreferences.getInstance();
    todayKey = "${subject}_today_${DateFormat('yyyy-MM-dd').format(DateTime.now())}";
    monthKey = "${subject}_month_${DateFormat('yyyy-MM').format(DateTime.now())}";
    totalKey = "${subject}_total_";

    prefs.setInt(todayKey, (prefs.getInt(todayKey) ?? 0) + duration.inSeconds);
    prefs.setInt(monthKey, (prefs.getInt(monthKey) ?? 0) + duration.inSeconds);
    prefs.setInt(totalKey, (prefs.getInt(totalKey) ?? 0) + duration.inSeconds);
    prefs.setInt(DateFormat('yyyy-MM-dd').format(DateTime.now()),
        (prefs.getInt(DateFormat('yyyy-MM-dd').format(DateTime.now())) ?? 0) + duration.inSeconds);
    prefs.setInt(DateFormat('yyyy-MM').format(DateTime.now()),
        (prefs.getInt(DateFormat('yyyy-MM').format(DateTime.now())) ?? 0) + duration.inSeconds);
    prefs.setInt("total_all_time", (prefs.getInt("total_all_time") ?? 0) + duration.inSeconds);
  }

  Future<void> loadStudyData() async {
    print("diohif;kalsueh");
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final month = DateFormat('yyyy-MM').format(DateTime.now());

    for (var subject in items) {
      todayKey = "${subject}_today_$today";
      monthKey = "${subject}_month_$month";
      totalKey = "${subject}_total_";

      setState(() {
        studyTime[subject]!["today"] = Duration(seconds: prefs.getInt(todayKey) ?? 0);
        studyTime[subject]!["month"] = Duration(seconds: prefs.getInt(monthKey) ?? 0);
        studyTime[subject]!["total"] = Duration(seconds: prefs.getInt(totalKey) ?? 0);
      });
    }

    setState(() {
      totalToday = Duration(seconds: prefs.getInt(DateFormat('yyyy-MM-dd').format(DateTime.now())) ?? 0);
      totalMonth = Duration(seconds: prefs.getInt(DateFormat('yyyy-MM').format(DateTime.now())) ?? 0);
      totalAllTime = Duration(seconds: prefs.getInt("total_all_time") ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MM/dd(E)', 'en_US').format(DateTime.now());
    return Scaffold(backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(backgroundColor: Colors.blueGrey[900],elevation: 0,
        actions: [
          Row(children: [
            IconButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  MyPlannerApp())) ;}, icon: Icon(LineIcons.calendarWithDayFocus,color: Colors.orange[300],)),
            IconButton(onPressed: () {report("_today_${DateFormat('yyyy-MM-dd').format(DateTime.now())}","_month_${DateFormat('yyyy-MM').format(DateTime.now())}");}, icon: Icon(LineIcons.pieChart,color:Colors.orange[300],)),
            IconButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  V11V2())) ;}, icon: Icon(LineIcons.grinningFace,color: Colors.orange[300],)),
            IconButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  V11V3(""))) ;}, icon: Icon(Icons.quora,color: Colors.orange[300],)),
            IconButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  V11ListAdd())).then((value) => first ());}, icon: Icon(Icons.add,color: Colors.orange[300],)),
          ],)
        ],),
      body: Container(child:Column( mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,children: [
        Expanded(child:Container(
            child: Column(mainAxisAlignment:MainAxisAlignment.end,children: [
              Container(padding: EdgeInsets.only(bottom: 10),child:Text(item2[_currentPageIndex], style: TextStyle(fontSize: 15,color: Colors.orange),)),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (index) => Container(margin: const EdgeInsets.symmetric(horizontal: 8), width: 5, height: 5,
                  decoration: BoxDecoration(color: _currentPageIndex == index ? Colors.orange : Colors.grey, shape: BoxShape.circle,),),),),
              SizedBox(height: 20),
            ],
            ))),
          Expanded(child:  PageView(  physics: _isScrollable ? ScrollPhysics() : NeverScrollableScrollPhysics(), controller: _pageController,onPageChanged: (index) {setState(() {_currentPageIndex = index;text = item[index];});},
            // if(WitchTimer == ""){setState(() {_currentPageIndex = index;text = item[index];});}else{}},
            //
            children: [
              Column(  children: [
                Container(margin: EdgeInsets.only(top: 10), child: Text(formatDuration(elapsedTime), style: const TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold,),)),
                SizedBox(height: 8),
                Container(margin: EdgeInsets.only(top: 0),
                  child: PopupMenuButton<String>(
                    child: Text(text2,style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 15)),
                    onSelected: (value) {setState(() {selectedSubject = value;text2 = value;});},
                    itemBuilder: (BuildContext context) {return items.map((item) {return PopupMenuItem<String>(value: item, child: Text(item),);}).toList();},),),
                Container(margin: EdgeInsets.only(top: 20,right: 12),child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(onPressed: toggleTimer, icon: Icon(isRunning ? Icons.pause : Icons.play_arrow,color: Colors.orange,size: 40,),),
                  // SizedBox(width: 40),
                  // IconButton(onPressed: resetTimer, icon: Icon(Icons.refresh,color: Colors.orange,size: 37,),),
                ],)),
             ],),
            CountdownTimer( isActive: _isScrollable, onToggle: toggleIsActive,load:first,)

         ],)),SizedBox(height: 80),])),
    );
  }

  Widget buildPieChart(Duration totalTime, String title) {
    List<PieChartSectionData> sections = items.map((subject) {
      final time = studyTime[subject]![title]?.inSeconds ?? 0;
      final percentage = totalTime.inSeconds > 0 ? (time / totalTime.inSeconds) * 100 : 0;
      final color = colors[items.indexOf(subject)];

      return PieChartSectionData(
        value: time.toDouble(),
        title: "${percentage.toStringAsFixed(1)}%",
        color: color,
        radius: 50,
        titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();

    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }
  Widget buildLegend(String title,aa,day) {
    return SingleChildScrollView(physics:  NeverScrollableScrollPhysics(),
      child: Container(margin: EdgeInsets.only(top: 0, bottom: 30),
          child: GridView.count(padding: EdgeInsets.all(20.0),shrinkWrap: true, physics:  NeverScrollableScrollPhysics(), crossAxisCount: 4, crossAxisSpacing: 5.0, mainAxisSpacing: 5.0, childAspectRatio: 0.8,
              children: List.generate(items2.length, (index) {
                if (index!= 0) {final time = studyTime[items2[index]]![title]?.inSeconds ?? 0;   formattedTime = formatDuration(Duration(seconds: time));}
                return GestureDetector(onTap: () {_showTimerPicker(items2[index]);},
                    child:index == 0?
                    Container(height:40,alignment: Alignment.center,decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), ),
                      child: Column(children: <Widget>[
                        Container(child: Icon(LineIcons.fire, color: Colors.blueGrey[900], size: 60,)),
                        Container(margin: EdgeInsets.only(top:0,), child: Text("合計", style: TextStyle( overflow: TextOverflow.ellipsis, color: Colors.blueGrey[900],  fontSize: 10,fontWeight: FontWeight.bold,),maxLines: 2,textAlign:TextAlign.center,)),
                        Container(margin: EdgeInsets.only(top:2,), child: Text(" ${formatDuration(aa)}", style: TextStyle( overflow: TextOverflow.ellipsis, color: Colors.blueGrey[900],  fontSize: 10,fontWeight: FontWeight.bold,),maxLines: 2,textAlign:TextAlign.center,)),
                        //   Container(margin: EdgeInsets.only(top:3,),width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: color,),),
                      ]),):
                    Container(height:40,alignment: Alignment.center,decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), ),
                      child: Column(children: <Widget>[
                        Container(child: Icon(LineIcons.book, color: colors[index -1], size: 60,)),
                        Container(margin: EdgeInsets.only(top:0,), child: Text(items2[index], style: TextStyle( overflow: TextOverflow.ellipsis, color: Colors.blueGrey[900],  fontSize: 10,fontWeight: FontWeight.bold,),maxLines: 2,textAlign:TextAlign.center,)),
                        Container(margin: EdgeInsets.only(top:2,), child: Text( "$formattedTime", style: TextStyle( overflow: TextOverflow.ellipsis, color: Colors.blueGrey[900],  fontSize: 10,fontWeight: FontWeight.bold,),maxLines: 2,textAlign:TextAlign.center,)),
                        //   Container(margin: EdgeInsets.only(top:3,),width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: color,),),
                      ]),));}))),);}


  Future<void> _showTimerPicker(name) async {
    showModalBottomSheet(context: context, builder: (BuildContext builder) {
      return Container(color:Colors.blueGrey[900],height: 400, child:
      Column(children: [
        Container(margin: EdgeInsets.only(top:10,bottom: 10), child: Text( name, style: TextStyle( overflow: TextOverflow.ellipsis, color: Colors.orange,  fontSize: 20,fontWeight: FontWeight.bold,),maxLines: 2,textAlign:TextAlign.center,)),
      Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4),),],),
      padding: EdgeInsets.all(16),child: CupertinoTimerPicker(backgroundColor: Colors.white, mode: CupertinoTimerPickerMode.hm, initialTimerDuration: remainingTime,
        onTimerDurationChanged: (Duration newDuration) {setState(() {addTime = newDuration; });},)),
        Container(margin :EdgeInsets.all(10),width:100,child: ElevatedButton(child: Text('追加'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, shape: const StadiumBorder(),),
        onPressed: () {saveStudyData2(name, addTime);},)),]));});
  }

  Future<void> saveStudyData2(String subject, Duration duration) async {
    print("subject"); print(subject);  print("duration"); print(duration.inMinutes);print(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    final prefs = await SharedPreferences.getInstance();
    todayKey = "${subject}_today_${DateFormat('yyyy-MM-dd').format(DateTime.now())}";
    monthKey = "${subject}_month_${DateFormat('yyyy-MM').format(DateTime.now())}";
    totalKey = "${subject}_total_";

    prefs.setInt(todayKey, (prefs.getInt(todayKey) ?? 0) + duration.inSeconds);
    prefs.setInt(monthKey, (prefs.getInt(monthKey) ?? 0) + duration.inSeconds);
    prefs.setInt(totalKey, (prefs.getInt(totalKey) ?? 0) + duration.inSeconds);
    prefs.setInt(DateFormat('yyyy-MM-dd').format(DateTime.now()),
        (prefs.getInt(DateFormat('yyyy-MM-dd').format(DateTime.now())) ?? 0) + duration.inSeconds);
    prefs.setInt(DateFormat('yyyy-MM').format(DateTime.now()),
        (prefs.getInt(DateFormat('yyyy-MM').format(DateTime.now())) ?? 0) + duration.inSeconds);
    prefs.setInt("total_all_time", (prefs.getInt("total_all_time") ?? 0) + duration.inSeconds);loadStudyData();Navigator.pop(context);Navigator.pop(context);
  }

  void report(day,month) {
    showModalBottomSheet(isScrollControlled: false,context: context,backgroundColor: Colors.white,
        shape:  const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
        builder: (context) { return StatefulBuilder(builder: (context, StateSetter setState) {return  Container(height:700,child:SingleChildScrollView(
            child: Column(children: <Widget>[
              Container(margin:EdgeInsets.only(left: 0,top: 10),height: 700,
                child: PageView(onPageChanged: (index) {setState(() {text = item[index];});},
                  children: [
                    SingleChildScrollView(child:Column(children: [
                      Container(width: double.infinity,margin:EdgeInsets.only(left: 10,top: 10),child: Text("Today",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), )),
                      Container(alignment: Alignment.topLeft,width: double.infinity,margin:EdgeInsets.only(left: 10,top: 0),child: Row( children:[Container(margin:EdgeInsets.only(left: 3,top: 0),child: Icon(Icons.circle_rounded,size: 10,color: Colors.blueGrey[900],),), Container(margin:EdgeInsets.only(left: 10,top: 0),child: Icon(Icons.circle_rounded,size: 10,color: Colors.blueGrey[300]),), Container(margin:EdgeInsets.only(left:10,top: 0),child: Icon(Icons.circle_rounded,size: 10,color: Colors.blueGrey[300]),),],)),
                      Container(height: 200, child: buildPieChart(totalToday, 'today'),),
                        Container(height: 300, child: buildLegend('today',totalToday,day)),
                    ],)),
          SingleChildScrollView(child: Column(children: [
                      Container(width: double.infinity,margin:EdgeInsets.only(left: 10,top: 10),child: Text("Month",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), )),
                      Container(alignment: Alignment.topLeft,width: double.infinity,margin:EdgeInsets.only(left: 10,top: 0),child: Row( children:[Container(margin:EdgeInsets.only(left: 3,top: 0),child: Icon(Icons.circle_rounded,size: 10,color: Colors.blueGrey[300],),), Container(margin:EdgeInsets.only(left: 10,top: 0),child: Icon(Icons.circle_rounded,size: 10,color: Colors.blueGrey[900]),), Container(margin:EdgeInsets.only(left:10,top: 0),child: Icon(Icons.circle_rounded,size: 10,color: Colors.blueGrey[300]),),],)),
                      Container(height: 200, child: buildPieChart(totalMonth, 'month'),),
                      buildLegend('month',totalMonth,month),
                    ],)),
            SingleChildScrollView(child:Column(children: [
                      Container(width: double.infinity,margin:EdgeInsets.only(left: 10,top: 10),child: Text("Total",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), )),
                      Container(alignment: Alignment.topLeft,width: double.infinity,margin:EdgeInsets.only(left: 10,top: 0),child: Row( children:[Container(margin:EdgeInsets.only(left: 3,top: 0),child: Icon(Icons.circle_rounded,size: 10,color: Colors.blueGrey[300],),), Container(margin:EdgeInsets.only(left: 8,top: 0),child: Icon(Icons.circle_rounded,size: 10,color: Colors.blueGrey[300]),), Container(margin:EdgeInsets.only(left:8,top: 0),child: Icon(Icons.circle_rounded,size: 10,color: Colors.blueGrey[900]),),],)),
                      Container(height: 200, child: buildPieChart(totalAllTime, 'total'),),
                      buildLegend('total',totalAllTime,"_total_"),
                    ],),)],),), ],)),);});}).whenComplete(() {});;}

  void first() async {items = [];items2 = ["合計"];
  SharedPreferences prefs = await SharedPreferences.getInstance();
  items = prefs.getStringList("科目リスト")??["選択なし","国語","数学","理科","社会","英語"];
  items2.addAll(items);
  setState(() {
    for (var subject in items) {
      studyTime[subject] = {
        "today": Duration(seconds: 0),
        "month": Duration(seconds: 0),
        "total": Duration(seconds: 0),
      };}loadStudyData();});
  }

}




class V11V2 extends StatefulWidget {
  @override
  _V11V2State createState() => _V11V2State();
}

class _V11V2State extends State<V11V2> {
  File? _image;
  String _extractedText = '';
  var recognizedText = "";
  String _generatedExplanation = '';
  var ID  = "";
  final ImagePicker _picker = ImagePicker();
  late final GenerativeModel _model;
  bool _isLoading = false; bool _isLoading2 = false; bool _isLoading3 = false;
  late TextEditingController _bodyController;
  var text = "";

  Future<void> _pickImageAndRecognizeText() async {
  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {await recognizeText(pickedFile.path);} else {setState(() {});}}
  Future<void> _pickImageFromCamera() async {
  final pickedFile = await _picker.pickImage(source: ImageSource.camera);
  if (pickedFile != null) {await recognizeText(pickedFile.path);} else {setState(() {});}}

  Future<void> recognizeText(String imagePath) async {
    final apiKey = dotenv.env['ML_API_KEY']??"";  // ここにAPIキーを入力
    final url = Uri.parse('https://vision.googleapis.com/v1/images:annotate?key=$apiKey');
    final imageBytes = File(imagePath).readAsBytesSync();
    final base64Image = base64Encode(imageBytes);
    final requestBody = json.encode({"requests": [{"image": {"content": base64Image,}, "features": [{"type": "TEXT_DETECTION",}]}]});

    try {final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: requestBody,);
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      final textAnnotations = responseJson['responses'][0]['textAnnotations'];
      if (textAnnotations != null && textAnnotations.isNotEmpty) {
        recognizedText = textAnnotations[0]['description'];
        setState(() { _sendMessage(recognizedText) ;      });
      } else {
        setState(() {});}} else {setState(() {});}
    } catch (e) {setState(() {});}
  }


  Future<void> _sendMessage(text0) async {showInterstitialAd();
  setState(() {_isLoading = true;});
  final text = "あなたは優秀な教師です。あとでこの内容からテストをするので、学生に身近なものに例えてわかりやすく滑らかに説明して。挨拶やまとめはいらないので解説からお願い。\n" + text0;

  //final text = "あなたは小学生を担当する個別授業の塾講師です。生徒にわかりやすく説明できます.注意として『小学生相手にしゃべっているな』と悟られないようにしてね。\n" + text0;
  if (text.isEmpty) return;
  setState(() {});
  try{
    final response = await _model.generateContent([Content.text(text)]);
    final geminiText = response.text ?? 'No response';
    _generatedExplanation = geminiText + "\n確認のテストやってみる?";_isLoading2 = true;_isLoading3 = false;
    setState(() {_generatedExplanation = _generatedExplanation.replaceAll("*", "");});
  }catch(e){
    setState(() {});
  } finally {setState(() {_isLoading = false;});}   Future.delayed(Duration(seconds: 5), () {interstitialAd();});//Navigator.pop(context);
  }

  Future<void> _sendMessage2(text0) async {showInterstitialAd();
  setState(() {_isLoading = true;});
  final text = "あなたは優秀な教師です。学生に身近なものに例えてわかりやすく滑らかに受験に出そうな知識を含みながら説明して。挨拶やまとめはいらないので解説からお願い。\n" + text0;

  //final text = "あなたは小学生を担当する個別授業の塾講師です。生徒にわかりやすく説明できます.注意として『小学生相手にしゃべっているな』と悟られないようにしてね。\n" + text0;
  if (text.isEmpty) return;
  setState(() {});
  try{
    final response = await _model.generateContent([Content.text(text)]);
    final geminiText = response.text ?? 'No response';
    _generatedExplanation = geminiText ;_isLoading2 = false;_isLoading3 = true;
    setState(() {_generatedExplanation = _generatedExplanation.replaceAll("*", "");});
  }catch(e){
    setState(() {});
  } finally {setState(() {_isLoading = false;});}   Future.delayed(Duration(seconds: 5), () {interstitialAd();});//Navigator.pop(context);
  }


  Future<void> _initializeModel() async {
    try{final apiKey = dotenv.env['GEMINI_API_KEY']??"";  // YOUR_API_KEY を実際のAPIキーに置き換えてください。
    if (apiKey.isEmpty) {return;}
    _model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: apiKey);
    }catch(e){}}

  void initState() {
    interstitialAd();_initializeModel();first();_bodyController = TextEditingController();
  super.initState();  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(backgroundColor: Colors.blueGrey[900],elevation: 0,
        title: Text(''),
      ),
      body: GestureDetector( onTap: () => FocusScope.of(context).unfocus(),
       child:SingleChildScrollView(child: Column(
          children: [
            Container(width: 110.0, height: 110.0, decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.fill, image: AssetImage("images/teacher.png"))),),
            // Container(margin:EdgeInsets.all(10),child:Text("チャラ男先生",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
            // Container(margin:EdgeInsets.all(0),child:Text("わからない所をチャラくわかりやすく解説\nCMという名の報酬を求めたがります\nグラフなどの図は苦手💦\n大体表示まで7秒かかる",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center),),
            Container(margin:EdgeInsets.all(10),child:Text("AI先生",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
            Container(margin:EdgeInsets.all(0),child:Text("わからない所をわかりやすく解説\nCMという名の報酬が必要\nグラフなどの図は苦手💦\n大体表示まで7秒かかる",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center),),
            Container(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(onPressed: _pickImageFromCamera, icon: Icon(Icons.camera_alt,color: Colors.orange,size: 40,),),
              SizedBox(width: 40),
              IconButton(onPressed: _pickImageAndRecognizeText, icon: Icon(LineIcons.image,color: Colors.orange,size: 37,),
              ),],)),
            Container(margin: EdgeInsets.all(10),
                child:Row(children: <Widget>[
                  Expanded(
                    child: Container(padding: EdgeInsets.symmetric(horizontal: 16.0,),margin: EdgeInsets.only(top: 10,bottom: 10),
                      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(40),),
                      child: Container(margin:EdgeInsets.all(5),child: TextField(maxLines: null, controller: _bodyController,decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Colors.white,),), fillColor: Colors.grey[50], filled: true,border: InputBorder.none,hintText: "message"),onChanged: (String value) {setState(() {text = value;});},),),
                  )),
                  Container(alignment: Alignment.topCenter,height:50,margin: EdgeInsets.only(right: 0),child:IconButton(
                    onPressed: () {_sendMessage2(text);FocusScope.of(context).requestFocus(new FocusNode());}, icon:Icon(Icons.mail_outline,color: Colors.orange,size: 30,),
                  )),],)),
            Container(margin:EdgeInsets.all(10),child:Text(_generatedExplanation,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
            Visibility(visible:_isLoading2,child:
            Container(margin :EdgeInsets.only(top:10,bottom: 30),width:100,child: ElevatedButton(
              child: Text('問題作成'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, shape: const StadiumBorder(),),
              onPressed: () { Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  V11V3(recognizedText))) ;},)),
            ),
          ],
        ),
      ),
      ));
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

  void showInterstitialAd() {print("yjg");
    if (_isAdLoaded) {_interstitialAd?.fullScreenContentCallback;_interstitialAd?.show();
    } else {print('Interstitial ad is not yet loaded.');}}
  @override
  FullScreenAdLoadErrorCallback get onAdFailedToLoad => throw UnimplementedError();
  @override
  GenericAdEventCallback<InterstitialAd> get onAdLoaded => throw UnimplementedError();
  void first() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ID = prefs.getString("ID") ?? "";}
}


class V11V3 extends StatefulWidget {
  V11V3(this.text);
  String text;
  @override
  State<V11V3> createState() => _V11V3State();
}

class _V11V3State extends State<V11V3> {
  var Qmap = {}; var Umap = {};var mapE = {};
  var id = "";var date = "";var name = "";var category = "カテゴリー";var swi = false;var text = "";
  var co = 0;var select = 0;var count = 2;var Q = "";var A = "";var grade = "レベル";
  late TextEditingController _bodyController; late TextEditingController _bodyController2; late TextEditingController _bodyController3;late TextEditingController _bodyController4;late TextEditingController _bodyController5;
  var item = [];
  List<String> prefItem = [];List<String> prefItem2 = [];
  var isOn = false;var ID  = "";
  final _tab = <Tab> [
    Tab( child:Text("自動生成",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
    Tab( child:Text("一つ",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
    Tab( child:Text("一括",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
    Tab( child:Text("csv",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
  ];
  String _recognizedText = "認識されたテキストが表示されます。";
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  late final GenerativeModel _model;
  bool _isLoading = false;
  var boo = false;var firstboo = false;


  Future<void> _initializeModel() async {
    try{final apiKey = dotenv.env['GEMINI_API_KEY']??"";  // YOUR_API_KEY を実際のAPIキーに置き換えてください。
    if (apiKey.isEmpty) {return;}
    _model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: apiKey);
    }catch(e){}}

  Future<void> _sendMessage(text0) async {
  setState(() {_isLoading = true;});
  text0 = text0.replaceAll(",", "、");
  final text = "以下の文章から問題を8個以上作ってください。条件1:半角カンマで問題と答えを区切って交互に作ってください。条件2:問題文や答えに絶対に『 , 』を使わないでください。条件3:問題間も半角カンマで区切ってください。条件4:無駄な文章は入れないでください。条件5:問題文はなるべく?を使って疑問形にして。例は問題,答え,問題2,答え2,問題3,答え3,問題4,答え4,問題5,答え5,\n" + text0;
  if (text.isEmpty) return;
  _textController.clear(); // 入力欄をクリア
  setState(() {_messages.add(ChatMessage(sender: 'User', text: text));});
  try{
    final response = await _model.generateContent([Content.text(text)]);
    final geminiText = response.text ?? 'No response';
    main(geminiText);
    setState(() {_messages.add(ChatMessage(sender: 'Gemini', text: geminiText));});
  }catch(e){
    setState(() {_messages.add(ChatMessage(sender: 'Gemini', text: 'Error: $e'));});
  } finally {setState(() {_isLoading = false;});}   Future.delayed(Duration(seconds: 5), () {interstitialAd();});//Navigator.pop(context);
  }


  Future<void> recognizeText(String imagePath) async {
    final apiKey = dotenv.env['ML_API_KEY']??"";  // ここにAPIキーを入力
    final url = Uri.parse('https://vision.googleapis.com/v1/images:annotate?key=$apiKey');
    final imageBytes = File(imagePath).readAsBytesSync();
    final base64Image = base64Encode(imageBytes);
    final requestBody = json.encode({"requests": [{"image": {"content": base64Image,}, "features": [{"type": "TEXT_DETECTION",}]}]});

    try {final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: requestBody,);
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      final textAnnotations = responseJson['responses'][0]['textAnnotations'];
      if (textAnnotations != null && textAnnotations.isNotEmpty) {
        final recognizedText = textAnnotations[0]['description'];
        setState(() {_recognizedText = recognizedText;showInterstitialAd(); _sendMessage(_recognizedText) ;      });
      } else {
        setState(() {_recognizedText = 'テキストが認識できませんでした。';});}} else {setState(() {_recognizedText = 'APIリクエストエラー: ${response.statusCode}';});}
    } catch (e) {setState(() {_recognizedText = 'エラーが発生しました: $e';});}
  }

  Future<void> _pickImageAndRecognizeText() async {interstitialAd();
  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {await recognizeText(pickedFile.path);} else {setState(() {_recognizedText = '画像が選択されませんでした。';});}}
  Future<void> _pickImageFromCamera() async {interstitialAd();
  final pickedFile = await _picker.pickImage(source: ImageSource.camera);
  if (pickedFile != null) {await recognizeText(pickedFile.path);} else {setState(() {_recognizedText = '画像が選択されませんでした。';});}}

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
  @override
  FullScreenAdLoadErrorCallback get onAdFailedToLoad => throw UnimplementedError();
  @override
  GenericAdEventCallback<InterstitialAd> get onAdLoaded => throw UnimplementedError();



  void initState() {_initializeModel();interstitialAd();;
  super.initState();first();_bodyController = TextEditingController();_bodyController2 = TextEditingController();_bodyController3 = TextEditingController();_bodyController4 = TextEditingController();_bodyController5 = TextEditingController();
  }

  void first() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ID = prefs.getString("ID") ?? "";
    setState(() { if(widget.text == ""){ firstboo = true;}else{firstboo = false;_sendMessage(widget.text) ;Future.delayed(Duration(seconds: 3), () {showInterstitialAd();});};}); }


  @override
  Widget build(BuildContext context) {
    return   GestureDetector(onTap: () => primaryFocus?.unfocus(),child:Scaffold(backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(backgroundColor: Colors.blueGrey[900], centerTitle: true,elevation: 0,
        actions: [
          Container(child: boo == true ?  Container(child:IconButton(icon: Icon(Icons.bookmark_add_outlined,color: Colors.orange,size: 30,), onPressed: () {AddView();},)) :Container())],
      ),
      // floatingActionButtonLocation:FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(backgroundColor: Colors.orange, child: const Icon(Icons.add),
      //   onPressed: () {AddView();},),
      body: SingleChildScrollView(child: Column(
        children: [
          Visibility(visible: firstboo,child: Column(children: [
          Container(margin:EdgeInsets.all(10),child:Text("勉強したページの確認テストをしてみよう\nグラフなどの図は苦手💦\n作成中CM出ます",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center),),
          Container(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            IconButton(onPressed: _pickImageFromCamera, icon: Icon(Icons.camera_alt,color: Colors.orange,size: 40,),),
            SizedBox(width: 40),
            IconButton(onPressed: _pickImageAndRecognizeText, icon: Icon(LineIcons.image,color: Colors.orange,size: 37,),
            ),],)),
           ],),),
          Container(margin: EdgeInsets.all(10),
            child: ListView.builder(
              shrinkWrap: true, physics: NeverScrollableScrollPhysics(),reverse: true,
              itemCount: item.length, itemBuilder: (context, index) {
              return Card(
                elevation: 0, color: Colors.grey[200], child: ListTile(
                trailing: Container(margin: EdgeInsets.only(top: 0), child:prefItem2.contains(item[index]["問題"]+item[index]["答え"]) == true ? Icon(LineIcons.times,color: Colors.black,):Container(child:prefItem.contains(item[index]["問題"]+item[index]["答え"]) == true ? Icon(Icons.circle_outlined,color: Colors.red,):Container(width: 0,))),
                title: Text(item[index]["問題"], style: TextStyle(
                    color: Colors.blueGrey[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 15), textAlign: TextAlign.center),
                onTap: () {
                  showDialog(context: context, builder: (context) => AlertDialog(
                      insetPadding: EdgeInsets.zero,
                      title: Column(children: [
                        Text(item[index]["答え"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
                        Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                          Container(margin: EdgeInsets.only(top: 10),width: 50, child: IconButton(
                            onPressed: () {Correct(index);Navigator.pop(context);}, icon: Icon(Icons.circle_outlined,color: Colors.red,), ),),
                          Container(margin: EdgeInsets.only(top: 10),width: 50, child: IconButton(
                            onPressed: () {firebase(index);Navigator.pop(context);}, icon: Icon(LineIcons.times,color: Colors.black,), ),),
                        ],),],)
                  ));},
              ),);},),),],),),));
  }

  Future<void> firebase(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefItem2 = prefs.getStringList("Man4単語帳バツ") ?? [];prefItem2.add(item[index]["問題"]+item[index]["答え"]);
    if(prefItem2.contains(item[index]["問題"]+item[index]["答え"]) == false){}else{prefs.setStringList("Man4単語帳バツ", prefItem2);}
    //Navigator.pop(context);
    setState(() {});
  }
  Future<void> Correct(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefItem = prefs.getStringList("Man4単語帳") ?? [];prefItem2 = prefs.getStringList("Man4単語帳バツ") ?? [];
    prefItem.add(item[index]["問題"]+item[index]["答え"]);prefItem2.remove(item[index]["問題"]+item[index]["答え"]);prefs.setStringList("Man4単語帳バツ", prefItem2);
    if(prefItem.contains(item[index]["問題"]+item[index]["答え"]) == false){print(0);}else{prefs.setStringList("Man4単語帳", prefItem);print(1);}
    // Navigator.pop(context);
    setState(() {});
  }

  Future<void> send() async {
    var QID = randomString(20);
    if (name != "" ){
      //UID
      Umap = {"UID":ID,"QID":QID,"name":name,"カテゴリー":category,"秒数":count,"公開":isOn,"レベル":grade};
      DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(ID);
      ref.update({"問題集2": FieldValue.arrayUnion([Umap]),});
      //QID
      DocumentReference ref2 = FirebaseFirestore.instance.collection('users').doc(ID).collection("問題集").doc(QID);
      ref2.set({"問題" : item,"ID":QID});
      Navigator.pop(context);
    }
    if(name == ""){showDialog(context: context, builder: (context) => AlertDialog(content: Container(child:Text("タイトルが入力されていません",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,)),),);};
    }

  Future<void> add() async {
    if ( Q != "" && A != ""){
      Qmap = {"問題":Q,"答え":A};item.add(Qmap);
      setState(() {Q= "";A= "";_bodyController3.clear();_bodyController4.clear();});
    }}



  void AddView() {
    showModalBottomSheet(isScrollControlled: true,context: context,backgroundColor: Colors.blueGrey[900],
      shape:   RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) { return StatefulBuilder(builder: (context, StateSetter setState) {
        return  Container(height:  350 +MediaQuery.of(context).viewInsets.bottom,decoration: BoxDecoration(color: Colors.white,  borderRadius: BorderRadius.vertical(top: Radius.circular(0.0),), boxShadow: [new BoxShadow(color: Colors.grey, offset: new Offset(1.0, 1.0), blurRadius: 3.0, spreadRadius: 1)],),
            //decoration: BoxDecoration( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
            child:Container(color: Colors.blueGrey[900],child:
              SingleChildScrollView(child:Column(children: [
                Container(padding: EdgeInsets.symmetric(horizontal: 10.0,),margin: EdgeInsets.only(top:50,left: 30,right: 30,bottom: 10),width:double.infinity,height:50,
                  decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5),),
                  child: TextField(controller: _bodyController,decoration: InputDecoration(border: InputBorder.none,hintText: "タイトル"),onChanged: (String value) {setState(() {name = value;});},),),
                Container(padding: EdgeInsets.symmetric(horizontal: 10.0,),margin: EdgeInsets.only(top:10,left: 30,right: 30,bottom: 10),width:double.infinity,height:50,
                  decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5),),
                  child: TextField(keyboardType: TextInputType.numberWithOptions(decimal: true),controller: _bodyController2,decoration: InputDecoration(border: InputBorder.none,hintText: "解答表示までの秒数(2秒)"),onChanged: (String value) {setState(() {count = int.parse(value);});},),),
                Container(margin :EdgeInsets.only(top:20),width:100,child: ElevatedButton(
                  child: Text('保存'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, shape: const StadiumBorder(),),
                  onPressed: () {send();},)),
              ],)),),);});}, );}


  void main(text) {
    final list2 = stringToList(text);["1","2","3","4"];
    for (int i = 0; i < list2.length ; i = i +2) {
      setState(() {item.add({"問題":list2[i],"答え":list2[i + 1]});boo = true;});
    }_bodyController5.clear();text = "";
    Future.delayed(Duration(seconds: 5), () {interstitialAd();});//Navigator.pop(context);
  }
  List<String> stringToList(String listAsString) {return listAsString.split(',').map<String>((String item) => item).toList();}



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


class ChatPage2 extends StatefulWidget {
  @override
  _ChatPage2State createState() => _ChatPage2State();
}

class _ChatPage2State extends State<ChatPage2> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  late final GenerativeModel _model;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeModel();
  }

  Future<void> _initializeModel() async {
    try{final apiKey = dotenv.env['GEMINI_API_KEY']??"";  // YOUR_API_KEY を実際のAPIキーに置き換えてください。
      if (apiKey.isEmpty) {return;}
      _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    }catch(e){}}

  Future<void> _sendMessage() async {
    setState(() {_isLoading = true;});
    final text = _textController.text;
    if (text.isEmpty) return;
    _textController.clear(); // 入力欄をクリア
    setState(() {_messages.add(ChatMessage(sender: 'User', text: text));});
    try{
      final response = await _model.generateContent([Content.text(text)]);
      final geminiText = response.text ?? 'No response';
      setState(() {_messages.add(ChatMessage(sender: 'Gemini', text: geminiText));});
    }catch(e){
      setState(() {_messages.add(ChatMessage(sender: 'Gemini', text: 'Error: $e'));});
    } finally {setState(() {_isLoading = false;});}}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Gemini'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            ),
          ),
          if (_isLoading)
            const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      labelText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String sender;
  final String text;

  ChatMessage({required this.sender, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('$sender: $text'),
      contentPadding: const EdgeInsets.all(8),
      tileColor: sender == 'User' ? Colors.grey[200] : Colors.lightBlue[100],
    );
  }
}




class V11ListAdd extends StatefulWidget {
  @override
  State<V11ListAdd> createState() => _V11ListAddState();
}

class _V11ListAddState extends State<V11ListAdd> {
  List<String> item = [];
  late TextEditingController _bodyController;
  var text = "";
  void initState() {
    super.initState();first();_bodyController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(backgroundColor:  Colors.blueGrey[900],iconTheme: IconThemeData(color: Colors.orange),
        title: Text("科目追加", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center,), centerTitle: true,
        elevation: 0,),
      body:  SingleChildScrollView(child:Column(children: <Widget>[
        Container(margin: EdgeInsets.all(30),
            child:Row(children: <Widget>[
              Expanded(
                child: Container(padding: EdgeInsets.symmetric(horizontal: 16.0,),margin: EdgeInsets.only(top: 10,bottom: 10,left: 15),
                  decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(20),),
                  child: TextField(maxLines: null, controller: _bodyController,decoration: InputDecoration(fillColor: Colors.grey[50], filled: true,border: InputBorder.none,hintText: "name"),onChanged: (String value) {setState(() {text = value;});},),),),
              Container(alignment: Alignment.topCenter,height:50,margin: EdgeInsets.only(right: 0),child:IconButton(
                onPressed: () {Add(text);FocusScope.of(context).requestFocus(new FocusNode());}, icon:Icon(Icons.add_circle_outline,color: Colors.orange,size: 30,),
              )),],)),
          Container(margin: EdgeInsets.only(top:5,left:15,right: 15,),
            child: ListView.builder(shrinkWrap: true, physics: NeverScrollableScrollPhysics(), itemCount: item.length,
              itemBuilder: (context, index) {
                return Card(elevation: 0, color: Colors.grey[200], child: ListTile(
                  title: Text(item[index], style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.center),
                  onTap: () {
                    showDialog(context: context, builder: (context) => AlertDialog(
                        insetPadding: EdgeInsets.zero,
                        title: Column(children: [
                          Text(item[index],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
                             Container(margin: EdgeInsets.only(top: 0),width: 50, child: IconButton(
                              onPressed: () {delete(index);Navigator.pop(context);}, icon: Icon(Icons.clear,color: Colors.red,), ),),
                          Container(height: 0,width: double.infinity,color: Colors.black,margin:EdgeInsets.only(top:10,bottom: 0)),
                               ],)));},),);},),),

      ],)));}


  void first() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    item = prefs.getStringList("科目リスト")??["選択なし","国語","数学","理科","社会","英語"];
    setState(() {});
  }

  Future<void> delete(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    item.removeAt(index);prefs.setStringList("科目リスト", item);
    setState(() {});
  }
  Future<void> Add(text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    item.add(text);prefs.setStringList("科目リスト", item);
    setState(() {_bodyController.clear();text = "";});
  }

}