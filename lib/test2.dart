import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';

final timerModel = TimerModel2();

class TimerModel2 extends ChangeNotifier {

  int _elapsedSeconds = 0;
  Timer? _timer;
  DateTime? _backgroundTime;
  bool _isRunning = false;
  bool _isFirstStart = true;
  String? _selectedSubject;
  Map<String, Map<String, Duration>> _studyTime = {};
  Duration _totalToday = Duration(seconds: 0);
  Duration _totalMonth = Duration(seconds: 0);
  Duration _totalAllTime = Duration(seconds: 0);

  List<String> items = ["Math", "Science", "History"];

  int get elapsedSeconds => _elapsedSeconds;
  bool get isRunning => _isRunning;
  String? get selectedSubject => _selectedSubject;
  Map<String, Map<String, Duration>> get studyTime => _studyTime;
  Duration get totalToday => _totalToday;
  Duration get totalMonth => _totalMonth;
  Duration get totalAllTime => _totalAllTime;

  TimerModel() {
    for (var subject in items) {
      _studyTime[subject] = {
        "today": Duration(seconds: 0),
        "month": Duration(seconds: 0),
        "total": Duration(seconds: 0),
      };
    }
    initFirstStart();
  }

  Future<void> initFirstStart() async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstStart = prefs.getBool('isFirstStart') ?? true;
    _isRunning = prefs.getBool('isRunning') ?? false;
    loadStudyData();
  }

  Future<void> _saveIsRunning() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isRunning', _isRunning);
  }


  void selectSubject(String subject) {
    _selectedSubject = subject;
    notifyListeners();
  }

  Future<void> startTimer() async {
    if (_isRunning || _selectedSubject == null) return;
    _isRunning = true;
    await _saveIsRunning();
    final prefs = await SharedPreferences.getInstance();
    if (_isFirstStart) {
      final storedTime = prefs.getInt('elapsedTime') ?? 0;
      _elapsedSeconds = storedTime;
      _isFirstStart = false;
      prefs.setBool('isFirstStart', false);
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
      notifyListeners();
    });
    notifyListeners();
  }


  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _saveIsRunning();
    if (_selectedSubject != null) {
      final todayKey = "${_selectedSubject!}_today_${DateFormat('yyyy-MM-dd').format(DateTime.now())}";
      final monthKey = "${_selectedSubject!}_month_${DateFormat('yyyy-MM').format(DateTime.now())}";
      final totalKey = "${_selectedSubject!}_total_";

      _studyTime[_selectedSubject!]!["today"] =
          (_studyTime[_selectedSubject!]!["today"] ?? Duration(seconds: 0)) + Duration(seconds: _elapsedSeconds);
      _studyTime[_selectedSubject!]!["month"] =
          (_studyTime[_selectedSubject!]!["month"] ?? Duration(seconds: 0)) + Duration(seconds: _elapsedSeconds);
      _studyTime[_selectedSubject!]!["total"] =
          (_studyTime[_selectedSubject!]!["total"] ?? Duration(seconds: 0)) + Duration(seconds: _elapsedSeconds);

      _totalToday += Duration(seconds: _elapsedSeconds);
      _totalMonth += Duration(seconds: _elapsedSeconds);
      _totalAllTime += Duration(seconds: _elapsedSeconds);

      saveStudyData(_selectedSubject!, Duration(seconds: _elapsedSeconds));
    }
    _elapsedSeconds = 0;
    notifyListeners();
  }

  Future<void> resetTimer() async {
    stopTimer();
    _elapsedSeconds = 0;
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('elapsedTime', 0);
    _isFirstStart = true;
    prefs.setBool('isFirstStart', true);
    notifyListeners();
  }

  Future<void> saveBackgroundTime() async {
    _backgroundTime = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('elapsedTime', _elapsedSeconds);
    if (_backgroundTime != null) {
      prefs.setInt('backgroundTime', _backgroundTime!.millisecondsSinceEpoch);
    }
  }

  Future<void> addBackgroundTime() async {
    final prefs = await SharedPreferences.getInstance();
    if(_isRunning) {
      int? backgroundTime = prefs.getInt('backgroundTime');
      if (backgroundTime != null) {
        DateTime storedBackgroundTime =
        DateTime.fromMillisecondsSinceEpoch(backgroundTime);
        final diff = DateTime.now().difference(storedBackgroundTime).inSeconds;
        _elapsedSeconds += diff;
        prefs.setInt('elapsedTime', _elapsedSeconds);
        prefs.remove('backgroundTime');
        notifyListeners();
      }
    }
  }

  Future<void> saveStudyData(String subject, Duration duration) async {
    final prefs = await SharedPreferences.getInstance();
    final todayKey = "${subject}_today_${DateFormat('yyyy-MM-dd').format(DateTime.now())}";
    final monthKey = "${subject}_month_${DateFormat('yyyy-MM').format(DateTime.now())}";
    final totalKey = "${subject}_total_";

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
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final month = DateFormat('yyyy-MM').format(DateTime.now());

    for (var subject in items) {
      final todayKey = "${subject}_today_$today";
      final monthKey = "${subject}_month_$month";
      final totalKey = "${subject}_total_";

      _studyTime[subject]!["today"] = Duration(seconds: prefs.getInt(todayKey) ?? 0);
      _studyTime[subject]!["month"] = Duration(seconds: prefs.getInt(monthKey) ?? 0);
      _studyTime[subject]!["total"] = Duration(seconds: prefs.getInt(totalKey) ?? 0);
    }
    _totalToday = Duration(seconds: prefs.getInt(DateFormat('yyyy-MM-dd').format(DateTime.now())) ?? 0);
    _totalMonth = Duration(seconds: prefs.getInt(DateFormat('yyyy-MM').format(DateTime.now())) ?? 0);
    _totalAllTime = Duration(seconds: prefs.getInt("total_all_time") ?? 0);
    notifyListeners();
  }
}

class TimerScreen2 extends StatefulWidget {
  const TimerScreen2({super.key});

  @override
  _TimerScreen2State createState() => _TimerScreen2State();
}

class _TimerScreen2State extends State<TimerScreen2> with WidgetsBindingObserver {

  String _selectedSubjectText = "科目を選択";
  List<String> items2 = ["合計","Math", "Science", "History"];
  List<Color> colors = [ Color.fromARGB(156, 4, 8, 186),Color.fromARGB(204, 87, 74, 16), Color.fromARGB(135, 62, 97, 51), Color.fromARGB(115, 36, 127, 32), Color.fromARGB(202, 48, 47, 100), Color.fromARGB(212, 11, 188, 2), Color.fromARGB(149, 27, 163, 19), Color.fromARGB(140, 17, 10, 189), Color.fromARGB(176, 54, 111, 66), Color.fromARGB(101, 169, 55, 41), Color.fromARGB(178, 37, 129, 107), Color.fromARGB(223, 234, 13, 29), Color.fromARGB(196, 70, 98, 113), Color.fromARGB(234, 41, 231, 10), Color.fromARGB(134, 50, 150, 110), Color.fromARGB(215, 201, 59, 53), Color.fromARGB(132, 224, 35, 55), Color.fromARGB(238, 14, 72, 233), Color.fromARGB(130, 48, 163, 115), Color.fromARGB(239, 43, 71, 225), Color.fromARGB(137, 241, 75, 53), Color.fromARGB(251, 15, 243, 111), Color.fromARGB(242, 127, 5, 242), Color.fromARGB(123, 160, 208, 8), Color.fromARGB(222, 243, 139, 5), Color.fromARGB(171, 126, 138, 128), Color.fromARGB(179, 187, 32, 173), Color.fromARGB(198, 217, 169, 10), Color.fromARGB(190, 222, 90, 88), Color.fromARGB(169, 92, 96, 213), Color.fromARGB(247, 52, 125, 229), Color.fromARGB(225, 92, 108, 220), Color.fromARGB(232, 169, 225, 44), Color.fromARGB(108, 180, 243, 15), Color.fromARGB(244, 40, 199, 206), Color.fromARGB(153, 204, 88, 156), Color.fromARGB(238, 237, 46, 184), Color.fromARGB(111, 185, 151, 135), Color.fromARGB(241, 242, 146, 90),Color.fromARGB(236, 177, 246, 84), Color.fromARGB(250, 161, 193, 164), Color.fromARGB(156, 203, 234, 82), Color.fromARGB(154, 195, 96, 231), Color.fromARGB(221, 219, 214, 103), Color.fromARGB(236, 247, 123, 174), Color.fromARGB(202, 196, 203, 162), Color.fromARGB(228, 216, 148, 198), Color.fromARGB(143, 252, 161, 180), Color.fromARGB(110, 247, 200, 236), Color.fromARGB(128, 251, 253, 246)];




  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    timerModel.addBackgroundTime();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // ライフサイクル監視を終了
    debugPrint('App Disposed');
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // ライフサイクルの状態を判別
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint('App in Foreground (resumed)');
        break;
      case AppLifecycleState.inactive:
        debugPrint('App is Inactive');
        break;
      case AppLifecycleState.paused:
        debugPrint('App in Background (paused)');
        break;
      case AppLifecycleState.detached:
        debugPrint('App Detached (detached)');
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
        throw UnimplementedError();
    }
  }


  String formatTime(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Widget buildPieChart(Duration totalTime, String title) {
    List<PieChartSectionData> sections = timerModel.items.map((subject) {
      final time = timerModel.studyTime[subject]![title]?.inSeconds ?? 0;
      final percentage = totalTime.inSeconds > 0 ? (time / totalTime.inSeconds) * 100 : 0;
      final color = colors[timerModel.items.indexOf(subject)];

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
  Widget buildLegend(String title,aa) {
    return Padding(padding: EdgeInsets.symmetric(vertical: 8.0),
        child:

        Container(margin: EdgeInsets.only(top: 0, bottom: 30),
    child: GridView.count(padding: EdgeInsets.all(20.0),
    crossAxisCount: 4, crossAxisSpacing: 5.0, mainAxisSpacing: 5.0, childAspectRatio: 0.8, shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
    children: List.generate(items2.length, (index) {if (index!= 0) {String formattedTime = formatDuration(timerModel.studyTime[items2[index]]![title] ?? Duration(seconds: 0));}
    return GestureDetector(onTap: () {},
    child:index == 0?
    Container(height:40,alignment: Alignment.center,decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), ),
    child: Column(children: <Widget>[
    Container(child: Icon(LineIcons.fire, color: Colors.blueGrey[900], size: 60,)),
    Container(margin: EdgeInsets.only(top:0,), child: Text("合計", style: TextStyle( overflow: TextOverflow.ellipsis, color: Colors.blueGrey[900],  fontSize: 10,fontWeight: FontWeight.bold,),maxLines: 2,textAlign:TextAlign.center,)),
    Container(margin: EdgeInsets.only(top:2,), child: Text(" ${formatDuration(aa)}", style: TextStyle( overflow: TextOverflow.ellipsis, color: Colors.blueGrey[900],  fontSize: 10,fontWeight: FontWeight.bold,),maxLines: 2,textAlign:TextAlign.center,)),
    ]),):
    Container(height:40,alignment: Alignment.center,decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), ),
    child: Column(children: <Widget>[
    Container(child: Icon(LineIcons.book, color: colors[index -1], size: 60,)),
    Container(margin: EdgeInsets.only(top:0,), child: Text(items2[index], style: TextStyle( overflow: TextOverflow.ellipsis, color: Colors.blueGrey[900],  fontSize: 10,fontWeight: FontWeight.bold,),maxLines: 2,textAlign:TextAlign.center,)),
  //  Container(margin: EdgeInsets.only(top:2,), child: Text("$formattedTime", style: TextStyle( overflow: TextOverflow.ellipsis, color: Colors.blueGrey[900],  fontSize: 10,fontWeight: FontWeight.bold,),maxLines: 2,textAlign:TextAlign.center,)),
    ],)));}))),);}
    @override
    Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.blueGrey[900],
    appBar: AppBar(
    backgroundColor: Colors.blueGrey[900],
    elevation: 0,
    title: Text("Study Timer", style: TextStyle(color: Colors.orange[300], fontWeight: FontWeight.bold)),
    actions: [
    IconButton(onPressed: () {report();}, icon: Icon(LineIcons.pieChart,color:Colors.orange[300],)),
    ],
    ),
    body: Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    AnimatedBuilder(
    animation: timerModel,
    builder: (context, child) => Text(
    formatTime(timerModel.elapsedSeconds),
    style: const TextStyle(fontSize: 60, color: Colors.white),
    ),
    ),
    const SizedBox(height: 20),
    PopupMenuButton<String>(
    child: Text(_selectedSubjectText,style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 15)),
    onSelected: (value) {setState(() {_selectedSubjectText = value;timerModel.selectSubject(value);});},
    itemBuilder: (BuildContext context) {return timerModel.items.map((item) {return PopupMenuItem<String>(value: item, child: Text(item),);}).toList();},),
    const SizedBox(height: 20),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    ElevatedButton(
    onPressed: () {
    if (timerModel.isRunning) {
    timerModel.stopTimer();
    } else {
    timerModel.startTimer();
    }
    },
    child: Text(timerModel.isRunning ? 'Stop' : 'Start'),
    ),
    const SizedBox(width: 10),
    ElevatedButton(
    onPressed: () => timerModel.resetTimer(),
    child: const Text('Reset'),
    ),
    ],
    ),
    ],
    ),
    ),
    );
    }
    void report() {
    showModalBottomSheet(isScrollControlled: false,context: context,backgroundColor: Colors.white,
    shape:  const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
    builder: (context) { return StatefulBuilder(builder: (context, StateSetter setState) {return  Container(height:500,child:SingleChildScrollView(
    child: Column(children: <Widget>[
    Container(margin:EdgeInsets.only(left: 0,top: 10),height: 500,
    child: PageView(
    children: [
    Column(children: [
    Container(width: double.infinity,margin:EdgeInsets.only(left: 10,top: 10),child: Text("Today",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), )),
    Container(alignment: Alignment.topLeft,width: double.infinity,margin:EdgeInsets.only(left: 10,top: 0),child: Row( children:[Container(margin:EdgeInsets.only(left: 3,top: 0),child: Icon(Icons.circle_rounded,size: 10,color: Colors.blueGrey[900],),), Container(margin:EdgeInsets.only(left: 10,top: 0),child: Icon(Icons.circle_rounded,size: 10,color: Colors.blueGrey[300]),), Container(margin:EdgeInsets.only(left:10,top: 0),child: Icon(Icons.circle_rounded,size: 10,color: Colors.blueGrey[300]),),],)),
    Container(height: 200, child: buildPieChart(timerModel.totalToday, 'today'),),
    buildLegend('today',timerModel.totalToday),
    ],),
    Column(children: [
    Container(width: double.infinity,margin:EdgeInsets.only(left: 10,top: 10),child: Text("Month",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), )),
    Container(alignment: Alignment.topLeft,width: double.infinity,margin:EdgeInsets.only(left: 10,top: 0),child: Row( children:[Container(margin:EdgeInsets.only(left: 3,top: 0),child: Icon(Icons.circle_rounded,size: 10,color: Colors.blueGrey[300],),), Container(margin:EdgeInsets.only(left: 10,top: 0),child: Icon(Icons.circle_rounded,size: 10,color: Colors.blueGrey[900]),), Container(margin:EdgeInsets.only(left:10,top: 0),child: Icon(Icons.circle_rounded,size: 10,color: Colors.blueGrey[300]),),],)),
    Container(height: 200, child: buildPieChart(timerModel.totalMonth, 'month'),),
    buildLegend('month',timerModel.totalMonth),
    ],),
    Column(children: [
    Container(width: double.infinity,margin:EdgeInsets.only(left: 10,top: 10),child: Text("Total",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), )),
    Container(alignment: Alignment.topLeft,width: double.infinity,margin:EdgeInsets.only(left: 10,top: 0),child: Row( children:[Container(margin:EdgeInsets.only(left: 3,top: 0),child: Icon(Icons.circle_rounded,size: 10,color: Colors.blueGrey[300],),), Container(margin:EdgeInsets.only(left: 8,top: 0),child: Icon(Icons.circle_rounded,size: 10,color: Colors.blueGrey[300]),), Container(margin:EdgeInsets.only(left:8,top: 0),child: Icon(Icons.circle_rounded,size: 10,color: Colors.blueGrey[900]),),],)),
    Container(height: 200, child: buildPieChart(timerModel.totalAllTime, 'total'),),
    buildLegend('total',timerModel.totalAllTime),
    ],),],),), ],)),);});}).whenComplete(() {});;}
  }