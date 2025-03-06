import 'package:anki/V11/test3.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class CountdownTimer extends StatefulWidget {
  final bool isActive;
  final ValueChanged<bool> onToggle;
  final  load;

  CountdownTimer({required this.isActive, required this.onToggle,required this.load});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> with WidgetsBindingObserver {

  List<String> items = [];
  List<String> items2 = ["合計"];
  final List<Color> colors = [
    Color(0xFF5F9EA0), Color(0xFF4682B4), Color(0xFF7B68EE), Color(0xFFFA8072),
    Color(0xFFFFD700), Color(0xFFFF4500), Color(0xFF4169E1), Color(0xFF32CD32),
    Color(0xFF2E8B57), Color(0xFF00CED1), Color(0xFF40E0D0), Color(0xFF008080),
    Color(0xFFB22222), Color(0xFF8B0000), Color(0xFF800080), Color(0xFF6A5ACD),
    Color(0xFF4B0082), Color(0xFF0000FF), Color(0xFF808000), Color(0xFFFFE4B5),
    Color(0xFFADFF2F), Color(0xFF7FFF00), Color(0xFFFF6347), Color(0xFFFFA500),
    Color(0xFFFFC0CB), Color(0xFFFF69B4), Color(0xFFFF1493), Color(0xFFDC143C),
    Color(0xFFFF0000), Color(0xFF00FF00), Color(0xFFFFFF00), Color(0xFF00FFFF),
    Color(0xFFFF00FF), Color(0xFFFF8C00), Color(0xFF9400D3), Color(0xFF008B8B),
    Color(0xFF1E90FF), Color(0xFF8A2BE2), Color(0xFFFF00FF),
  ];
  List<String> item = ["Today", "Month", "Total"];
  var co = 0;
  var text = "Today";
  var selectedSubject  = "選択なし";
  Duration remainingTime = Duration(seconds: 0);
  Duration _originalRemainingTime = Duration(seconds: 0); // タイマー開始時の時間を保持
  Map<String, Map<String, Duration>> studyTime = {};
  Duration totalToday = Duration(seconds: 0);
  Duration totalMonth = Duration(seconds: 0);
  Duration totalAllTime = Duration(seconds: 0);
  Timer? _timer;
  bool isRunning = false;
  var todayKey = "";
  var monthKey = "";
  var totalKey = "全体";
  var formattedTime = "";
  var text2 = "選択なし";
  int _currentPageIndex = 0;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  var lastPausedTime = 0;
  bool _isAppInBackground = false;
  var StartTime = DateTime.now();var startBool = false;


  @override
  void initState() {
    super.initState();
    first();
    WidgetsBinding.instance.addObserver(this);
    _initializeNotifications();
  }
  @override
  void dispose() {
    _timer?.cancel();endtime ();widget.onToggle(true);
    WidgetsBinding.instance.removeObserver(this);// ライフサイクル監視を終了
    debugPrint('App Disposed');
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // ライフサイクルの状態を判別
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint('App is resumed');
        _timer?.cancel();
        WidgetsBinding.instance.removeObserver(this);
        first();
        WidgetsBinding.instance.addObserver(this);
        break;
      case AppLifecycleState.inactive:
        debugPrint('App is Inactive');
        break;
      case AppLifecycleState.paused:_timer?.cancel();endtime ();
      //WidgetsBinding.instance.removeObserver(this);
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

  void first() async {
    items = [];items2 = ["合計"];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    items = prefs.getStringList("科目リスト") ?? ["選択なし","国語", "数学", "理科", "社会", "英語"];
    items2.addAll(items);
    setState(() {for (var subject in items) {studyTime[subject] = {"today": Duration(seconds: 0), "month": Duration(seconds: 0), "total": Duration(seconds: 0),};}});
    start();
  }

  Future<void> start() async { loadStudyData();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var count = prefs.getInt("カウントダウン時間")?? 0;
  remainingTime = Duration(seconds:prefs.getInt("経過時間")??0);var end = prefs.getInt("EndTime") ?? 0;
  selectedSubject = prefs.getString("選択科目") ?? "";text2 = prefs.getString("選択科目") ?? "";
  if (count == 0) {} else {
    // _isAppInBackground = false;isRunning = prefs.getBool('isRunning') ?? false;
     isRunning = prefs.getBool('isRunning') ?? false;print("isRunning");
     print("-3");
    if (isRunning) {
      if(!_isAppInBackground){
        var aa = DateTime.now().millisecondsSinceEpoch ~/ 1000;var dif = (aa - end) ;
        // remainingTime = remainingTime - Duration(seconds: dif);
        remainingTime = remainingTime - Duration(seconds: dif);
        if(remainingTime.inSeconds > 0){startTimer();}else{ resetTimer();}
      }else{if(remainingTime.inSeconds > 0){startTimer();}else{resetTimer();}}

    }if(selectedSubject != null){text2 = selectedSubject!;}}
  setState(() {});
  }

  Future<void> endtime () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var aa = DateTime.now().millisecondsSinceEpoch~/ 1000;;prefs.setInt("EndTime",aa);prefs.setInt("経過時間", remainingTime.inSeconds);
  }


  Future<void> startTimer() async {
    if (remainingTime.inSeconds >0) {
      _originalRemainingTime = remainingTime; // タイマー開始時の時間を保存
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {if (remainingTime.inSeconds > 0) {remainingTime = remainingTime - Duration(seconds: 1);} else {resetTimer();}});});
      setState(() {isRunning = true;});}else{resetTimer();  }
  }

  void stopTimer() {_timer?.cancel();
  if (isRunning) {
    _timer?.cancel();
    if (selectedSubject != null && remainingTime.inSeconds == 0) {
      studyTime[selectedSubject!]![todayKey] =
          (studyTime[selectedSubject!]![todayKey] ?? Duration(seconds: 0)) + _originalRemainingTime;
      studyTime[selectedSubject!]![monthKey] =
          (studyTime[selectedSubject!]![monthKey] ?? Duration(seconds: 0)) + _originalRemainingTime;
      studyTime[selectedSubject!]![totalKey] =
          (studyTime[selectedSubject!]![totalKey] ?? Duration(seconds: 0)) + _originalRemainingTime;
      totalToday += _originalRemainingTime;
      totalMonth += _originalRemainingTime;
      totalAllTime += _originalRemainingTime;
      saveStudyData(selectedSubject!, _originalRemainingTime);
    }
    setState(() {
      loadStudyData();
      _cancelNotification(selectedSubject!);
      isRunning = false;
      remainingTime = Duration(seconds: 0);
    });
  }
  }

  Future<void> toggleTimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isRunning) {resetTimer();
    } else {
      startBool = true;widget.onToggle(false);
      var aa = DateTime.now().millisecondsSinceEpoch~/ 1000;;prefs.setString("どっちのタイマー","2");prefs.setInt("カウントダウン時間",remainingTime.inMinutes);
      prefs.setInt("StartTime",aa); prefs.setInt("EndTime",aa);prefs.setString("選択科目",text2);prefs.setInt("経過時間", remainingTime.inSeconds);prefs.setBool('isRunning', true);
      final now = tz.TZDateTime.now(tz.local);
      final scheduledTime = now.add(remainingTime);
      if (selectedSubject != null) {_scheduleNotification(selectedSubject!, scheduledTime);}
      start();
    }
  }

  Future<void> resetTimer() async
  {final prefs = await SharedPreferences.getInstance();
    _originalRemainingTime = Duration(minutes: prefs.getInt("カウントダウン時間")??0);
    saveStudyData(selectedSubject!, _originalRemainingTime);
    widget.onToggle(false); prefs.setBool('isRunning', false);stopTimer();
  widget.onToggle(true);isRunning = false;remainingTime = Duration(seconds: 0);prefs.setInt("カウントダウン時間",0);
  prefs.setString("どっちのタイマー","");prefs.setInt("StartTime",0);prefs.setBool('isRunning', false);prefs.setString("選択科目","選択なし");prefs.setInt("経過時間", 0);remainingTime = Duration(seconds: 0);
  _cancelNotification(selectedSubject!);prefs.setString("どっちのタイマー","");prefs.setInt("StartTime",0);prefs.setBool('isRunning', false);prefs.setString("選択科目","選択なし");prefs.setInt("経過時間", 0);remainingTime = Duration(seconds: 0);setState(() {remainingTime = Duration(seconds: 0);});}
  void setTime(int seconds) {setState(() {remainingTime = Duration(seconds: seconds);if (isRunning) {startTimer();}});}



  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.blueGrey[900],
      body: Container(
          child: Column(//mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(margin: EdgeInsets.only(top: 0), child: TextButton( onPressed: () => _showTimerPicker(),  child: Text(formatDuration(remainingTime), style: const TextStyle(fontSize: 45, color: Colors.white, fontWeight: FontWeight.bold,),))),
              // Container(margin: EdgeInsets.only(top: 0), child: Text(formatDuration(remainingTime), style: const TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold,),)),
              SizedBox(height: 8),
              Container(margin: EdgeInsets.only(top: 0), child: PopupMenuButton<String>(child: Text(text2, style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 15)),
                onSelected: (value) {setState(() {selectedSubject = value;text2 = value;});},
                itemBuilder: (BuildContext context) {return items.map((item) {return PopupMenuItem<String>(value: item, child: Text(item),);}).toList();},),),
              Container(margin: EdgeInsets.only(top: 15,right: 12),child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: () {toggleTimer();}, icon: Icon(isRunning ? Icons.refresh : Icons.play_arrow, color: Colors.orange, size: 40,),),
                ],)),
            ],)),);
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
    prefs.setBool('isRunning', false);widget.load;
    //  report();
  }

  Future<void> loadStudyData() async {
    remainingTime = Duration(seconds: 0);isRunning = false;
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
      });}
    setState(() {
      totalToday = Duration(seconds: prefs.getInt(DateFormat('yyyy-MM-dd').format(DateTime.now())) ?? 0);
      totalMonth = Duration(seconds: prefs.getInt(DateFormat('yyyy-MM').format(DateTime.now())) ?? 0);
      totalAllTime = Duration(seconds: prefs.getInt("total_all_time") ?? 0);
    });}

  Future<void> _initializeNotifications() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Tokyo'));
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true,);
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS, // iOS の設定を追加
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (NotificationResponse details) {});
  }

  Future<void> _scheduleNotification(String subject, tz.TZDateTime scheduledTime) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'timer_channel_id', 'Timer Channel',
      channelDescription: 'Channel for timer notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    final id = _generateNotificationId(subject);
    await flutterLocalNotificationsPlugin.zonedSchedule(id, 'タイマー終了', 'タイマーが終了しました。',
      scheduledTime,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  int _generateNotificationId(String subject) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return '$subject-$now'.hashCode;
  }

  Future<void> _cancelNotification(String subject) async {
    final id = _generateNotificationId(subject);
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'timer_channel_id', 'Timer Channel',
      channelDescription: 'Channel for timer notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(0, 'タイマー終了', '設定した時間が経過しました。',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }
  Future<void> _showTimerPicker() async {
    showModalBottomSheet(context: context, builder: (BuildContext builder) {
      return Container(height: 200, child: CupertinoTimerPicker(
        mode: CupertinoTimerPickerMode.hm,
        initialTimerDuration: remainingTime,
        onTimerDurationChanged: (Duration newDuration) {
          setState(() {
            remainingTime = newDuration;
            //  if(isRunning){startTimer();}
          });
        },
      ));});
  }


}


class CountdownTimer2 extends StatefulWidget {
  // final bool isActive;
  // final ValueChanged<bool> onToggle;
  // final  load;
  //
  // CountdownTimer2({required this.isActive, required this.onToggle,required this.load});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimer2State extends State<CountdownTimer> with WidgetsBindingObserver {

  List<String> items = [];
  List<String> items2 = ["合計"];
  final List<Color> colors = [
    Color(0xFF5F9EA0), Color(0xFF4682B4), Color(0xFF7B68EE), Color(0xFFFA8072),
    Color(0xFFFFD700), Color(0xFFFF4500), Color(0xFF4169E1), Color(0xFF32CD32),
    Color(0xFF2E8B57), Color(0xFF00CED1), Color(0xFF40E0D0), Color(0xFF008080),
    Color(0xFFB22222), Color(0xFF8B0000), Color(0xFF800080), Color(0xFF6A5ACD),
    Color(0xFF4B0082), Color(0xFF0000FF), Color(0xFF808000), Color(0xFFFFE4B5),
    Color(0xFFADFF2F), Color(0xFF7FFF00), Color(0xFFFF6347), Color(0xFFFFA500),
    Color(0xFFFFC0CB), Color(0xFFFF69B4), Color(0xFFFF1493), Color(0xFFDC143C),
    Color(0xFFFF0000), Color(0xFF00FF00), Color(0xFFFFFF00), Color(0xFF00FFFF),
    Color(0xFFFF00FF), Color(0xFFFF8C00), Color(0xFF9400D3), Color(0xFF008B8B),
    Color(0xFF1E90FF), Color(0xFF8A2BE2), Color(0xFFFF00FF),
  ];
  List<String> item = ["Today", "Month", "Total"];
  var co = 0;
  var text = "Today";
  var selectedSubject  = "選択なし";
  Duration remainingTime = Duration(seconds: 0);
  Duration _originalRemainingTime = Duration(seconds: 0); // タイマー開始時の時間を保持
  Map<String, Map<String, Duration>> studyTime = {};
  Duration totalToday = Duration(seconds: 0);
  Duration totalMonth = Duration(seconds: 0);
  Duration totalAllTime = Duration(seconds: 0);
  Timer? _timer;
  bool isRunning = false;
  var todayKey = "";
  var monthKey = "";
  var totalKey = "全体";
  var formattedTime = "";
  var text2 = "選択なし";
  int _currentPageIndex = 0;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  var lastPausedTime = 0;
  bool _isAppInBackground = false;
  var StartTime = DateTime.now();var startBool = false;


  @override
  void initState() {
    super.initState();
    first();
    WidgetsBinding.instance.addObserver(this);
    _initializeNotifications();
  }
  @override
  void dispose() {
    _timer?.cancel();endtime ();widget.onToggle(true);
    WidgetsBinding.instance.removeObserver(this);// ライフサイクル監視を終了
    debugPrint('App Disposed');
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // ライフサイクルの状態を判別
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint('App is resumed');
        _timer?.cancel();
        WidgetsBinding.instance.removeObserver(this);
        first();
        WidgetsBinding.instance.addObserver(this);
        break;
      case AppLifecycleState.inactive:
        debugPrint('App is Inactive');
        break;
      case AppLifecycleState.paused:_timer?.cancel();endtime ();
      //WidgetsBinding.instance.removeObserver(this);
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
  DateTime? parseDate(String dateString) {
    try {
      return DateFormat('HH:mm').parse(dateString); // フォーマットを指定
    } catch (e) {
      print('日付のパースに失敗しました: $e');
      return null;
    }
  }

  void first() async {
    items = [];items2 = ["合計"];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    items = prefs.getStringList("科目リスト") ?? ["選択なし","国語", "数学", "理科", "社会", "英語"];
    items2.addAll(items);
    setState(() {for (var subject in items) {studyTime[subject] = {"today": Duration(seconds: 0), "month": Duration(seconds: 0), "total": Duration(seconds: 0),};}});
    start();
  }

  Future<void> start() async { loadStudyData();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var count = prefs.getInt("カウントダウン時間")?? 0;
  remainingTime = Duration(seconds:prefs.getInt("経過時間")??0);var end = prefs.getInt("EndTime") ?? 0;
  selectedSubject = prefs.getString("選択科目") ?? "";text2 = prefs.getString("選択科目") ?? "";
  if (count == 0) {} else {
    // _isAppInBackground = false;isRunning = prefs.getBool('isRunning') ?? false;
    isRunning = prefs.getBool('isRunning') ?? false;print("isRunning");
    print("-3");
    if (isRunning) {
      if(!_isAppInBackground){
        var aa = DateTime.now().millisecondsSinceEpoch ~/ 1000;var dif = (aa - end) ;
        // remainingTime = remainingTime - Duration(seconds: dif);
        remainingTime = remainingTime - Duration(seconds: dif);
        if(remainingTime.inSeconds > 0){startTimer();}else{ resetTimer();}
      }else{if(remainingTime.inSeconds > 0){startTimer();}else{resetTimer();}}

    }if(selectedSubject != null){text2 = selectedSubject!;}}
  setState(() {});
  }

  Future<void> endtime () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var aa = DateTime.now().millisecondsSinceEpoch~/ 1000;;prefs.setInt("EndTime",aa);prefs.setInt("経過時間", remainingTime.inSeconds);
  }


  Future<void> startTimer() async {
    if (remainingTime.inSeconds >0) {
      _originalRemainingTime = remainingTime; // タイマー開始時の時間を保存
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {if (remainingTime.inSeconds > 0) {remainingTime = remainingTime - Duration(seconds: 1);} else {resetTimer();}});});
      setState(() {isRunning = true;});}else{resetTimer();  }
  }

  void stopTimer() {_timer?.cancel();
  if (isRunning) {
    _timer?.cancel();
    if (selectedSubject != null && remainingTime.inSeconds == 0) {
      studyTime[selectedSubject!]![todayKey] =
          (studyTime[selectedSubject!]![todayKey] ?? Duration(seconds: 0)) + _originalRemainingTime;
      studyTime[selectedSubject!]![monthKey] =
          (studyTime[selectedSubject!]![monthKey] ?? Duration(seconds: 0)) + _originalRemainingTime;
      studyTime[selectedSubject!]![totalKey] =
          (studyTime[selectedSubject!]![totalKey] ?? Duration(seconds: 0)) + _originalRemainingTime;
      totalToday += _originalRemainingTime;
      totalMonth += _originalRemainingTime;
      totalAllTime += _originalRemainingTime;
      saveStudyData(selectedSubject!, _originalRemainingTime);
    }
    setState(() {
      loadStudyData();
      _cancelNotification(selectedSubject!);
      isRunning = false;
      remainingTime = Duration(seconds: 0);
    });
  }
  }

  Future<void> toggleTimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isRunning) {resetTimer();
    } else {
      startBool = true;widget.onToggle(false);
      var aa = DateTime.now().millisecondsSinceEpoch~/ 1000;;prefs.setString("どっちのタイマー","2");prefs.setInt("カウントダウン時間",remainingTime.inMinutes);
      prefs.setInt("StartTime",aa); prefs.setInt("EndTime",aa);prefs.setString("選択科目",text2);prefs.setInt("経過時間", remainingTime.inSeconds);prefs.setBool('isRunning', true);
      final now = tz.TZDateTime.now(tz.local);
      final scheduledTime = now.add(remainingTime);
      if (selectedSubject != null) {_scheduleNotification(selectedSubject!, scheduledTime);}
      start();
    }
  }

  Future<void> resetTimer() async
  {final prefs = await SharedPreferences.getInstance();
  _originalRemainingTime = Duration(minutes: prefs.getInt("カウントダウン時間")??0);
  saveStudyData(selectedSubject!, _originalRemainingTime);
  widget.onToggle(false); prefs.setBool('isRunning', false);stopTimer();
  widget.onToggle(true);isRunning = false;remainingTime = Duration(seconds: 0);prefs.setInt("カウントダウン時間",0);
  prefs.setString("どっちのタイマー","");prefs.setInt("StartTime",0);prefs.setBool('isRunning', false);prefs.setString("選択科目","選択なし");prefs.setInt("経過時間", 0);remainingTime = Duration(seconds: 0);
  _cancelNotification(selectedSubject!);prefs.setString("どっちのタイマー","");prefs.setInt("StartTime",0);prefs.setBool('isRunning', false);prefs.setString("選択科目","選択なし");prefs.setInt("経過時間", 0);remainingTime = Duration(seconds: 0);setState(() {remainingTime = Duration(seconds: 0);});}
  void setTime(int seconds) {setState(() {remainingTime = Duration(seconds: seconds);if (isRunning) {startTimer();}});}



  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.blueGrey[900],
      body: Container(
          child: Column(//mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(margin: EdgeInsets.only(top: 0), child: TextButton( onPressed: () => _showTimerPicker(),  child: Text(formatDuration(remainingTime), style: const TextStyle(fontSize: 45, color: Colors.white, fontWeight: FontWeight.bold,),))),
              // Container(margin: EdgeInsets.only(top: 0), child: Text(formatDuration(remainingTime), style: const TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold,),)),
              SizedBox(height: 8),
              Container(margin: EdgeInsets.only(top: 0), child: PopupMenuButton<String>(child: Text(text2, style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 15)),
                onSelected: (value) {setState(() {selectedSubject = value;text2 = value;});},
                itemBuilder: (BuildContext context) {return items.map((item) {return PopupMenuItem<String>(value: item, child: Text(item),);}).toList();},),),
              Container(margin: EdgeInsets.only(top: 15,right: 12),child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: () {toggleTimer();}, icon: Icon(isRunning ? Icons.refresh : Icons.play_arrow, color: Colors.orange, size: 40,),),
                ],)),
            ],)),);
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
    prefs.setBool('isRunning', false);widget.load;
    //  report();
  }

  Future<void> loadStudyData() async {
    remainingTime = Duration(seconds: 0);isRunning = false;
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
      });}
    setState(() {
      totalToday = Duration(seconds: prefs.getInt(DateFormat('yyyy-MM-dd').format(DateTime.now())) ?? 0);
      totalMonth = Duration(seconds: prefs.getInt(DateFormat('yyyy-MM').format(DateTime.now())) ?? 0);
      totalAllTime = Duration(seconds: prefs.getInt("total_all_time") ?? 0);
    });}

  Future<void> _initializeNotifications() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Tokyo'));
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true,);
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS, // iOS の設定を追加
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (NotificationResponse details) {});
  }

  Future<void> _scheduleNotification(String subject, tz.TZDateTime scheduledTime) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'timer_channel_id', 'Timer Channel',
      channelDescription: 'Channel for timer notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    final id = _generateNotificationId(subject);
    await flutterLocalNotificationsPlugin.zonedSchedule(id, 'タイマー終了', 'タイマーが終了しました。',
      scheduledTime,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  int _generateNotificationId(String subject) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return '$subject-$now'.hashCode;
  }

  Future<void> _cancelNotification(String subject) async {
    final id = _generateNotificationId(subject);
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'timer_channel_id', 'Timer Channel',
      channelDescription: 'Channel for timer notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(0, 'タイマー終了', '設定した時間が経過しました。',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }
  Future<void> _showTimerPicker() async {
    showModalBottomSheet(context: context, builder: (BuildContext builder) {
      return Container(height: 200, child: CupertinoTimerPicker(
        mode: CupertinoTimerPickerMode.hm,
        initialTimerDuration: remainingTime,
        onTimerDurationChanged: (Duration newDuration) {
          setState(() {
            remainingTime = newDuration;
            //  if(isRunning){startTimer();}
          });
        },
      ));});
  }


}



// class CountdownTimer extends StatefulWidget {
//   @override
//   _CountdownTimerState createState() => _CountdownTimerState();
// }
//
// class _CountdownTimerState extends State<CountdownTimer> with WidgetsBindingObserver {
//   List<String> items = [];
//   List<String> items2 = ["合計"];
//   final List<Color> colors = [
//     Color(0xFF5F9EA0), Color(0xFF4682B4), Color(0xFF7B68EE), Color(0xFFFA8072),
//     Color(0xFFFFD700), Color(0xFFFF4500), Color(0xFF4169E1), Color(0xFF32CD32),
//     Color(0xFF2E8B57), Color(0xFF00CED1), Color(0xFF40E0D0), Color(0xFF008080),
//     Color(0xFFB22222), Color(0xFF8B0000), Color(0xFF800080), Color(0xFF6A5ACD),
//     Color(0xFF4B0082), Color(0xFF0000FF), Color(0xFF808000), Color(0xFFFFE4B5),
//     Color(0xFFADFF2F), Color(0xFF7FFF00), Color(0xFFFF6347), Color(0xFFFFA500),
//     Color(0xFFFFC0CB), Color(0xFFFF69B4), Color(0xFFFF1493), Color(0xFFDC143C),
//     Color(0xFFFF0000), Color(0xFF00FF00), Color(0xFFFFFF00), Color(0xFF00FFFF),
//     Color(0xFFFF00FF), Color(0xFFFF8C00), Color(0xFF9400D3), Color(0xFF008B8B),
//     Color(0xFF1E90FF), Color(0xFF8A2BE2), Color(0xFFFF00FF),
//   ];
//   List<String> item = ["Today", "Month", "Total"];
//   var co = 0;
//   var text = "Today";
//   var selectedSubject  = "選択なし";
//   Duration remainingTime = Duration(seconds: 0);
//   Duration _originalRemainingTime = Duration(seconds: 0); // タイマー開始時の時間を保持
//   Map<String, Map<String, Duration>> studyTime = {};
//   Duration totalToday = Duration(seconds: 0);
//   Duration totalMonth = Duration(seconds: 0);
//   Duration totalAllTime = Duration(seconds: 0);
//   Timer? _timer;
//   bool isRunning = false;
//   var todayKey = "";
//   var monthKey = "";
//   var totalKey = "全体";
//   var formattedTime = "";
//   var text2 = "選択なし";
//   int _currentPageIndex = 0;
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   var lastPausedTime = 0;
//   bool _isAppInBackground = false;
//   var StartTime = DateTime.now();var startBool = false;
//
//
//   @override
//   void initState() {
//     super.initState();
//     first();
//     WidgetsBinding.instance.addObserver(this);
//     _initializeNotifications();
//   }
//   @override
//   void dispose() {
//     _timer?.cancel();endtime ();
//     WidgetsBinding.instance.removeObserver(this);// ライフサイクル監視を終了
//     debugPrint('App Disposed');
//     super.dispose();
//   }
//
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     // ライフサイクルの状態を判別
//     switch (state) {
//       case AppLifecycleState.resumed:
//         debugPrint('App is resumed');
//         _timer?.cancel();
//         WidgetsBinding.instance.removeObserver(this);
//         first();
//         WidgetsBinding.instance.addObserver(this);
//         break;
//       case AppLifecycleState.inactive:
//         debugPrint('App is Inactive');
//       break;
//       case AppLifecycleState.paused:_timer?.cancel();endtime ();
//       //WidgetsBinding.instance.removeObserver(this);
//       debugPrint('App in Background (paused)');
//       break;
//       case AppLifecycleState.detached:
//         debugPrint('App Detached (detached)');
//         break;
//       case AppLifecycleState.hidden:
//       // TODO: Handle this case.
//       //  throw UnimplementedError();
//     }
//   }
//
//   void first() async {
//     items = [];items2 = ["合計"];
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     items = prefs.getStringList("科目リスト") ?? ["選択なし","国語", "数学", "理科", "社会", "英語"];
//     items2.addAll(items);
//     setState(() {for (var subject in items) {studyTime[subject] = {"today": Duration(seconds: 0), "month": Duration(seconds: 0), "total": Duration(seconds: 0),};}});
//     start();
//   }
//
//   Future<void> start() async {loadStudyData();
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   var count = prefs.getInt("カウントダウン時間")?? 0;
//   remainingTime = Duration(seconds:prefs.getInt("経過時間")??0);var end = prefs.getInt("EndTime") ?? 0;
//   selectedSubject = prefs.getString("選択科目") ?? "";text2 = prefs.getString("選択科目") ?? "";
//   if (count == 0) {} else {
//     _isAppInBackground = false;isRunning = prefs.getBool('isRunning') ?? false;
//   if (isRunning) {
//     if(!_isAppInBackground){
//       var aa = DateTime.now().millisecondsSinceEpoch ~/ 1000;var dif = (aa - end) ;print(dif);
//       // remainingTime = remainingTime - Duration(seconds: dif);
//       remainingTime = remainingTime - Duration(seconds: dif);
//       if(remainingTime.inSeconds > 0){startTimer();}else{ saveStudyData(selectedSubject!, _originalRemainingTime);remainingTime = Duration(seconds: 0);isRunning = false;}
//     }else{if(remainingTime.inSeconds > 0){startTimer();}else{ saveStudyData(selectedSubject!, _originalRemainingTime);remainingTime = Duration(seconds: 0);isRunning = false;}}
//
//   }if(selectedSubject != null){text2 = selectedSubject!;}}
//   setState(() {});
//   }
//
//    Future<void> endtime () async {
//      SharedPreferences prefs = await SharedPreferences.getInstance();
//      var aa = DateTime.now().millisecondsSinceEpoch~/ 1000;;prefs.setInt("EndTime",aa);prefs.setInt("経過時間", remainingTime.inSeconds);
//    }
//
//
//   Future<void> startTimer() async {V11A.end;
//     if (remainingTime.inSeconds >0) {
//       _originalRemainingTime = remainingTime; // タイマー開始時の時間を保存
//       final now = tz.TZDateTime.now(tz.local);
//       final scheduledTime = now.add(remainingTime);
//       if (selectedSubject != null) {_scheduleNotification(selectedSubject!, scheduledTime);}
//       _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//         setState(() {
//           if (remainingTime.inSeconds > 0) {remainingTime = remainingTime - Duration(seconds: 1);} else {_timer?.cancel();_cancelNotification(selectedSubject!);isRunning = false;_showNotification();
//           }});});
//       setState(() {isRunning = true;});}
//   }
//
//   void stopTimer() {_timer?.cancel();
//     if (isRunning) {
//       _timer?.cancel();
//       if (selectedSubject != null && remainingTime.inSeconds == 0) {
//         studyTime[selectedSubject!]![todayKey] =
//             (studyTime[selectedSubject!]![todayKey] ?? Duration(seconds: 0)) + _originalRemainingTime;
//         studyTime[selectedSubject!]![monthKey] =
//             (studyTime[selectedSubject!]![monthKey] ?? Duration(seconds: 0)) + _originalRemainingTime;
//         studyTime[selectedSubject!]![totalKey] =
//             (studyTime[selectedSubject!]![totalKey] ?? Duration(seconds: 0)) + _originalRemainingTime;
//         totalToday += _originalRemainingTime;
//         totalMonth += _originalRemainingTime;
//         totalAllTime += _originalRemainingTime;
//         saveStudyData(selectedSubject!, _originalRemainingTime);
//       }
//       setState(() {
//         loadStudyData();
//         _cancelNotification(selectedSubject!);
//         isRunning = false;
//         remainingTime = Duration(seconds: 0);
//       });
//     }
//   }
//
//   Future<void> toggleTimer() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     if (isRunning) {
//       _cancelNotification(selectedSubject!);prefs.setString("どっちのタイマー","");
//       prefs.setInt("StartTime",0);prefs.setBool('isRunning', false);prefs.setString("選択科目","選択なし");prefs.setInt("経過時間", 0);
//       stopTimer();
//     } else {
//       startBool = true;
//       var aa = DateTime.now().millisecondsSinceEpoch~/ 1000;;prefs.setString("どっちのタイマー","2");
//       prefs.setInt("StartTime",aa); prefs.setInt("EndTime",aa);prefs.setString("選択科目",text2);prefs.setInt("経過時間", remainingTime.inSeconds);prefs.setBool('isRunning', true);
//       start();
//     }
//   }
//
//   Future<void> resetTimer() async { final prefs = await SharedPreferences.getInstance();prefs.setBool('isRunning', false);stopTimer();setState(() {remainingTime = Duration(seconds: 0);});}
//   void setTime(int seconds) {setState(() {remainingTime = Duration(seconds: seconds);if (isRunning) {startTimer();}});}
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(backgroundColor: Colors.blueGrey[900],
//       body: Container(
//           child: Column(//mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(margin: EdgeInsets.only(top: 0), child: TextButton( onPressed: () => _showTimerPicker(),  child: Text(formatDuration(remainingTime), style: const TextStyle(fontSize: 45, color: Colors.white, fontWeight: FontWeight.bold,),))),
//               // Container(margin: EdgeInsets.only(top: 0), child: Text(formatDuration(remainingTime), style: const TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold,),)),
//               SizedBox(height: 8),
//               Container(margin: EdgeInsets.only(top: 0), child: PopupMenuButton<String>(child: Text(text2, style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 15)),
//                 onSelected: (value) {setState(() {selectedSubject = value;text2 = value;});},
//                 itemBuilder: (BuildContext context) {return items.map((item) {return PopupMenuItem<String>(value: item, child: Text(item),);}).toList();},),),
//               Container(margin: EdgeInsets.only(top: 15,right: 12),child: Row(mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   IconButton(onPressed: () {toggleTimer();}, icon: Icon(isRunning ? Icons.refresh : Icons.play_arrow, color: Colors.orange, size: 40,),),
//                    ],)),
//             ],)),);
//   }
//
//   Future<void> saveStudyData(String subject, Duration duration) async {
//     final prefs = await SharedPreferences.getInstance();
//     todayKey = "${subject}_today_${DateFormat('yyyy-MM-dd').format(DateTime.now())}";
//     monthKey = "${subject}_month_${DateFormat('yyyy-MM').format(DateTime.now())}";
//     totalKey = "${subject}_total_";
//     prefs.setInt(todayKey, (prefs.getInt(todayKey) ?? 0) + duration.inSeconds);
//     prefs.setInt(monthKey, (prefs.getInt(monthKey) ?? 0) + duration.inSeconds);
//     prefs.setInt(totalKey, (prefs.getInt(totalKey) ?? 0) + duration.inSeconds);
//     prefs.setInt(DateFormat('yyyy-MM-dd').format(DateTime.now()),
//         (prefs.getInt(DateFormat('yyyy-MM-dd').format(DateTime.now())) ?? 0) + duration.inSeconds);
//     prefs.setInt(DateFormat('yyyy-MM').format(DateTime.now()),
//         (prefs.getInt(DateFormat('yyyy-MM').format(DateTime.now())) ?? 0) + duration.inSeconds);
//     prefs.setInt("total_all_time", (prefs.getInt("total_all_time") ?? 0) + duration.inSeconds);
//     prefs.setBool('isRunning', false);
//     //  report();
//   }
//
//   Future<void> loadStudyData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
//     final month = DateFormat('yyyy-MM').format(DateTime.now());
//     for (var subject in items) {
//       todayKey = "${subject}_today_$today";
//       monthKey = "${subject}_month_$month";
//       totalKey = "${subject}_total_";
//       setState(() {
//         studyTime[subject]!["today"] = Duration(seconds: prefs.getInt(todayKey) ?? 0);
//         studyTime[subject]!["month"] = Duration(seconds: prefs.getInt(monthKey) ?? 0);
//         studyTime[subject]!["total"] = Duration(seconds: prefs.getInt(totalKey) ?? 0);
//       });}
//     setState(() {
//       totalToday = Duration(seconds: prefs.getInt(DateFormat('yyyy-MM-dd').format(DateTime.now())) ?? 0);
//       totalMonth = Duration(seconds: prefs.getInt(DateFormat('yyyy-MM').format(DateTime.now())) ?? 0);
//       totalAllTime = Duration(seconds: prefs.getInt("total_all_time") ?? 0);
//     });}
//   Future<void> _initializeNotifications() async {
//     tz.initializeTimeZones();
//     tz.setLocalLocation(tz.getLocation('Asia/Tokyo'));
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//     const DarwinInitializationSettings initializationSettingsIOS =
//     DarwinInitializationSettings(requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true,);
//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS, // iOS の設定を追加
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (NotificationResponse details) {});
//   }
//   Future<void> _scheduleNotification(String subject, tz.TZDateTime scheduledTime) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//     AndroidNotificationDetails(
//       'timer_channel_id', 'Timer Channel',
//       channelDescription: 'Channel for timer notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//     );
//     final id = _generateNotificationId(subject);
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       'タイマー終了',
//       '$subjectのタイマーが終了しました。',
//       scheduledTime,
//       notificationDetails,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//       androidAllowWhileIdle: true,
//     );
//   }
//
//   int _generateNotificationId(String subject) {
//     final now = DateTime.now().millisecondsSinceEpoch;
//     return '$subject-$now'.hashCode;
//   }
//   Future<void> _cancelNotification(String subject) async {
//     final id = _generateNotificationId(subject);
//     await flutterLocalNotificationsPlugin.cancel(id);
//   }
//   Future<void> _showNotification() async {
//     const AndroidNotificationDetails androidNotificationDetails =
//     AndroidNotificationDetails(
//       'timer_channel_id', 'Timer Channel',
//       channelDescription: 'Channel for timer notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//     );
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'タイマー終了',
//       '設定した時間が経過しました。',
//       tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
//       notificationDetails,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//       androidAllowWhileIdle: true,
//     );
//   }
//   String formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String hours = twoDigits(duration.inHours);
//     String minutes = twoDigits(duration.inMinutes.remainder(60));
//     String seconds = twoDigits(duration.inSeconds.remainder(60));
//     return "$hours:$minutes:$seconds";
//   }
//   Future<void> _showTimerPicker() async {
//     showModalBottomSheet(context: context, builder: (BuildContext builder) {
//       return Container(height: 200, child: CupertinoTimerPicker(
//         mode: CupertinoTimerPickerMode.hm,
//         initialTimerDuration: remainingTime,
//         onTimerDurationChanged: (Duration newDuration) {
//           setState(() {
//             remainingTime = newDuration;
//             //  if(isRunning){startTimer();}
//           });
//         },
//       ));});
//   }
//
//
// }


// class CountdownTimer extends StatefulWidget {
//   @override
//   _CountdownTimerState createState() => _CountdownTimerState();
// }
//
// class _CountdownTimerState extends State<CountdownTimer> with WidgetsBindingObserver {
//   List<String> items = [];
//   List<String> items2 = ["合計"];
//   final List<Color> colors = [
//     Color(0xFF5F9EA0), Color(0xFF4682B4), Color(0xFF7B68EE), Color(0xFFFA8072),
//     Color(0xFFFFD700), Color(0xFFFF4500), Color(0xFF4169E1), Color(0xFF32CD32),
//     Color(0xFF2E8B57), Color(0xFF00CED1), Color(0xFF40E0D0), Color(0xFF008080),
//     Color(0xFFB22222), Color(0xFF8B0000), Color(0xFF800080), Color(0xFF6A5ACD),
//     Color(0xFF4B0082), Color(0xFF0000FF), Color(0xFF808000), Color(0xFFFFE4B5),
//     Color(0xFFADFF2F), Color(0xFF7FFF00), Color(0xFFFF6347), Color(0xFFFFA500),
//     Color(0xFFFFC0CB), Color(0xFFFF69B4), Color(0xFFFF1493), Color(0xFFDC143C),
//     Color(0xFFFF0000), Color(0xFF00FF00), Color(0xFFFFFF00), Color(0xFF00FFFF),
//     Color(0xFFFF00FF), Color(0xFFFF8C00), Color(0xFF9400D3), Color(0xFF008B8B),
//     Color(0xFF1E90FF), Color(0xFF8A2BE2), Color(0xFFFF00FF),
//   ];
//   List<String> item = ["Today", "Month", "Total"];
//   var co = 0;
//   var text = "Today";
//   String? selectedSubject;
//   Duration remainingTime = Duration(seconds: 0);
//   Duration _originalRemainingTime = Duration(seconds: 0); // タイマー開始時の時間を保持
//   Map<String, Map<String, Duration>> studyTime = {};
//   Duration totalToday = Duration(seconds: 0);
//   Duration totalMonth = Duration(seconds: 0);
//   Duration totalAllTime = Duration(seconds: 0);
//   Timer? _timer;
//   bool isRunning = false;
//   var todayKey = "";
//   var monthKey = "";
//   var totalKey = "全体";
//   var formattedTime = "";
//   var text2 = "科目を選択";
//   int _currentPageIndex = 0;
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   var lastPausedTime = 0;
//   bool _isAppInBackground = false;
//   var StartTime = DateTime.now();var startBool = false;
//
//
//   @override
//   void initState() {
//     super.initState();
//     first();
//     WidgetsBinding.instance.addObserver(this);
//     _initializeNotifications();
//   }
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     debugPrint('App Disposed');
//     super.dispose();
//   }
//
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     switch (state) {
//       case AppLifecycleState.resumed:
//         debugPrint('App in Foreground (resumed)');
//         first();
//         break;
//       case AppLifecycleState.inactive:
//         debugPrint('App is Inactive');
//         break;
//       case AppLifecycleState.paused:
//         debugPrint('App in Background (paused)');
//         _isAppInBackground = true;
//         _saveTimerState();
//         break;
//       case AppLifecycleState.detached:
//         debugPrint('App Detached (detached)');
//         break;
//       case AppLifecycleState.hidden:
//     }
//   }
//
//   void first() async {
//     items = [];items2 = ["合計"];
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     items = prefs.getStringList("科目リスト") ?? ["選択なし","国語", "数学", "理科", "社会", "英語"];
//     items2.addAll(items);
//     setState(() {for (var subject in items) {studyTime[subject] = {"today": Duration(seconds: 0), "month": Duration(seconds: 0), "total": Duration(seconds: 0),};}});
//     start();
//   }
//   Future<void> start() async {loadStudyData();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var bb = prefs.getInt("StartTime") ?? 0;
//     selectedSubject = prefs.getString("選択科目") ?? "";text2 = prefs.getString("選択科目") ?? "";
//     if (bb == 0) {} else {_isAppInBackground = false;
//         isRunning = prefs.getBool('isRunning') ?? false;
//         if (isRunning) {
//           if(!_isAppInBackground){
//             var aa = DateTime.now().millisecondsSinceEpoch ~/ 1000;var dif = (aa - bb);
//             remainingTime = remainingTime - Duration(seconds: dif);
//             if(remainingTime.inSeconds > 0){startTimer();}else{ saveStudyData(selectedSubject!, _originalRemainingTime);remainingTime = Duration(seconds: 0);isRunning = false;}
//           }else{if(remainingTime.inSeconds > 0){startTimer();}else{ saveStudyData(selectedSubject!, _originalRemainingTime);remainingTime = Duration(seconds: 0);isRunning = false;}}
//
//         }if(selectedSubject != null){text2 = selectedSubject!;}}
//     setState(() {});
//   }
//
//   Future<void> _saveTimerState() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setBool('isRunning', isRunning);
//     prefs.setInt('remainingTime', remainingTime.inSeconds);
//     prefs.setString('selectedSubject', selectedSubject ?? '');
//     if (isRunning) {lastPausedTime = DateTime.now().millisecondsSinceEpoch~/ 1000;}
//     prefs.setInt('lastPausedTime', lastPausedTime);
//   }
//
//   // Future<void> _loadTimerState() async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   setState(() {
//   //     isRunning = prefs.getBool('isRunning') ?? false;
//   //     int savedRemainingSeconds = prefs.getInt('remainingTime') ?? 0;
//   //     remainingTime = Duration(seconds: savedRemainingSeconds);
//   //     selectedSubject = prefs.getString('selectedSubject');
//   //     lastPausedTime = prefs.getInt('lastPausedTime') ?? 0;
//   //     if (isRunning) {
//   //       if(!_isAppInBackground){
//   //         var aa = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//   //         var dif = (aa - lastPausedTime);
//   //         remainingTime = remainingTime - Duration(seconds: dif);
//   //         if(remainingTime.inSeconds > 0){startTimer();}else{ saveStudyData(selectedSubject!, _originalRemainingTime);remainingTime = Duration(seconds: 0);
//   //         isRunning = false;
//   //         }
//   //       }else{
//   //         if(remainingTime.inSeconds > 0){startTimer();}else{ saveStudyData(selectedSubject!, _originalRemainingTime);remainingTime = Duration(seconds: 0);
//   //         isRunning = false;}}}
//   //     if(selectedSubject != null){text2 = selectedSubject!;}});
//   // }
//
//
//   void startTimer() {
//   if (remainingTime.inSeconds >0) {
//   _originalRemainingTime = remainingTime; // タイマー開始時の時間を保存
//   final now = tz.TZDateTime.now(tz.local);
//   final scheduledTime = now.add(remainingTime);
//   if (selectedSubject != null) {_scheduleNotification(selectedSubject!, scheduledTime);}
//   _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//     setState(() {
//       if (remainingTime.inSeconds > 0) {remainingTime = remainingTime - Duration(seconds: 1);} else {_timer?.cancel();_cancelNotification(selectedSubject!);isRunning = false;_showNotification();
//       }});});
//   setState(() {isRunning = true;});}
//   }
//
//   void stopTimer() {
//     if (isRunning) {
//       _timer?.cancel();
//       if (selectedSubject != null && remainingTime.inSeconds == 0) {
//         studyTime[selectedSubject!]![todayKey] =
//             (studyTime[selectedSubject!]![todayKey] ?? Duration(seconds: 0)) + _originalRemainingTime;
//         studyTime[selectedSubject!]![monthKey] =
//             (studyTime[selectedSubject!]![monthKey] ?? Duration(seconds: 0)) + _originalRemainingTime;
//         studyTime[selectedSubject!]![totalKey] =
//             (studyTime[selectedSubject!]![totalKey] ?? Duration(seconds: 0)) + _originalRemainingTime;
//         totalToday += _originalRemainingTime;
//         totalMonth += _originalRemainingTime;
//         totalAllTime += _originalRemainingTime;
//         saveStudyData(selectedSubject!, _originalRemainingTime);
//       }
//       setState(() {
//         loadStudyData();
//         _cancelNotification(selectedSubject!);
//         isRunning = false;
//         remainingTime = Duration(seconds: 0);
//       });
//     }
//   }
//
//   Future<void> toggleTimer() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     if (isRunning) {
//       _cancelNotification(selectedSubject!);
//       prefs.setInt("StartTime",0);prefs.setBool('isRunning', false);prefs.setString("選択科目","選択なし");
//       stopTimer();
//     } else {
//       startBool = true;
//       var aa = DateTime.now().millisecondsSinceEpoch~/ 1000;;
//       prefs.setInt("StartTime",aa);prefs.setString("選択科目",text2);prefs.setBool('isRunning', true);
//       startTimer();
//     }
//   }
//
//   Future<void> resetTimer() async { final prefs = await SharedPreferences.getInstance();prefs.setBool('isRunning', false);stopTimer();setState(() {remainingTime = Duration(seconds: 0);});}
//   void setTime(int seconds) {setState(() {remainingTime = Duration(seconds: seconds);if (isRunning) {startTimer();}});}
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(backgroundColor: Colors.blueGrey[900],
//       body: Container(
//           child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(margin: EdgeInsets.only(top: 0), child: TextButton( onPressed: () => _showTimerPicker(),  child: Text(formatDuration(remainingTime), style: const TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold,),))),
//               // Container(margin: EdgeInsets.only(top: 0), child: Text(formatDuration(remainingTime), style: const TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold,),)),
//               SizedBox(height: 8),
//               Container(margin: EdgeInsets.only(top: 0), child: PopupMenuButton<String>(child: Text(text2, style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 15)),
//                 onSelected: (value) {setState(() {selectedSubject = value;text2 = value;});},
//                 itemBuilder: (BuildContext context) {
//                   return items.map((item) {return PopupMenuItem<String>(value: item, child: Text(item),);
//                   }).toList();},),),
//               Container(child: Row(mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(onPressed: () {toggleTimer();}, icon: Icon(isRunning ? Icons.pause : Icons.play_arrow, color: Colors.orange, size: 40,),),
//                       SizedBox(width: 40),
//                       IconButton(onPressed: resetTimer, icon: Icon(Icons.refresh, color: Colors.orange, size: 37,),),
//                     ],)),
//             ],)),);
//   }
//
//   Future<void> saveStudyData(String subject, Duration duration) async {
//     final prefs = await SharedPreferences.getInstance();
//     todayKey = "${subject}_today_${DateFormat('yyyy-MM-dd').format(DateTime.now())}";
//     monthKey = "${subject}_month_${DateFormat('yyyy-MM').format(DateTime.now())}";
//     totalKey = "${subject}_total_";
//     prefs.setInt(todayKey, (prefs.getInt(todayKey) ?? 0) + duration.inSeconds);
//     prefs.setInt(monthKey, (prefs.getInt(monthKey) ?? 0) + duration.inSeconds);
//     prefs.setInt(totalKey, (prefs.getInt(totalKey) ?? 0) + duration.inSeconds);
//     prefs.setInt(DateFormat('yyyy-MM-dd').format(DateTime.now()),
//         (prefs.getInt(DateFormat('yyyy-MM-dd').format(DateTime.now())) ?? 0) + duration.inSeconds);
//     prefs.setInt(DateFormat('yyyy-MM').format(DateTime.now()),
//         (prefs.getInt(DateFormat('yyyy-MM').format(DateTime.now())) ?? 0) + duration.inSeconds);
//     prefs.setInt("total_all_time", (prefs.getInt("total_all_time") ?? 0) + duration.inSeconds);
//     prefs.setBool('isRunning', false);
//     //  report();
//     }
//
//   Future<void> loadStudyData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
//     final month = DateFormat('yyyy-MM').format(DateTime.now());
//     for (var subject in items) {
//       todayKey = "${subject}_today_$today";
//       monthKey = "${subject}_month_$month";
//       totalKey = "${subject}_total_";
//       setState(() {
//         studyTime[subject]!["today"] = Duration(seconds: prefs.getInt(todayKey) ?? 0);
//         studyTime[subject]!["month"] = Duration(seconds: prefs.getInt(monthKey) ?? 0);
//         studyTime[subject]!["total"] = Duration(seconds: prefs.getInt(totalKey) ?? 0);
//       });}
//     setState(() {
//       totalToday = Duration(seconds: prefs.getInt(DateFormat('yyyy-MM-dd').format(DateTime.now())) ?? 0);
//       totalMonth = Duration(seconds: prefs.getInt(DateFormat('yyyy-MM').format(DateTime.now())) ?? 0);
//       totalAllTime = Duration(seconds: prefs.getInt("total_all_time") ?? 0);
//     });}
//   Future<void> _initializeNotifications() async {
//     tz.initializeTimeZones();
//     tz.setLocalLocation(tz.getLocation('Asia/Tokyo'));
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//     const DarwinInitializationSettings initializationSettingsIOS =
//     DarwinInitializationSettings(requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true,);
//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS, // iOS の設定を追加
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (NotificationResponse details) {});
//   }
//   Future<void> _scheduleNotification(String subject, tz.TZDateTime scheduledTime) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//     AndroidNotificationDetails(
//       'timer_channel_id', 'Timer Channel',
//       channelDescription: 'Channel for timer notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//     );
//     final id = _generateNotificationId(subject);
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       'タイマー終了',
//       '$subjectのタイマーが終了しました。',
//       scheduledTime,
//       notificationDetails,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//       androidAllowWhileIdle: true,
//     );
//   }
//
//   int _generateNotificationId(String subject) {
//     final now = DateTime.now().millisecondsSinceEpoch;
//     return '$subject-$now'.hashCode;
//   }
//   Future<void> _cancelNotification(String subject) async {
//     final id = _generateNotificationId(subject);
//     await flutterLocalNotificationsPlugin.cancel(id);
//   }
//   Future<void> _showNotification() async {
//     const AndroidNotificationDetails androidNotificationDetails =
//     AndroidNotificationDetails(
//       'timer_channel_id', 'Timer Channel',
//       channelDescription: 'Channel for timer notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//     );
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'タイマー終了',
//       '設定した時間が経過しました。',
//       tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
//       notificationDetails,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//       androidAllowWhileIdle: true,
//     );
//   }
//   String formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String hours = twoDigits(duration.inHours);
//     String minutes = twoDigits(duration.inMinutes.remainder(60));
//     String seconds = twoDigits(duration.inSeconds.remainder(60));
//     return "$hours:$minutes:$seconds";
//   }
//   Future<void> _showTimerPicker() async {
//     showModalBottomSheet(context: context, builder: (BuildContext builder) {
//       return Container(height: 200, child: CupertinoTimerPicker(
//         mode: CupertinoTimerPickerMode.hm,
//         initialTimerDuration: remainingTime,
//         onTimerDurationChanged: (Duration newDuration) {
//           setState(() {
//             remainingTime = newDuration;
//           //  if(isRunning){startTimer();}
//           });
//         },
//       ));});
//   }
//
//
// }




// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
//
// class CountdownTimer extends StatefulWidget {
//   @override
//   _CountdownTimerState createState() => _CountdownTimerState();
// }
//
// class _CountdownTimerState extends State<CountdownTimer> with WidgetsBindingObserver {
//   List<String> items = [];
//   List<String> items2 = ["合計"];
//   final List<Color> colors = [
//     Color(0xFF5F9EA0), Color(0xFF4682B4), Color(0xFF7B68EE), Color(0xFFFA8072),
//     Color(0xFFFFD700), Color(0xFFFF4500), Color(0xFF4169E1), Color(0xFF32CD32),
//     Color(0xFF2E8B57), Color(0xFF00CED1), Color(0xFF40E0D0), Color(0xFF008080),
//     Color(0xFFB22222), Color(0xFF8B0000), Color(0xFF800080), Color(0xFF6A5ACD),
//     Color(0xFF4B0082), Color(0xFF0000FF), Color(0xFF808000), Color(0xFFFFE4B5),
//     Color(0xFFADFF2F), Color(0xFF7FFF00), Color(0xFFFF6347), Color(0xFFFFA500),
//     Color(0xFFFFC0CB), Color(0xFFFF69B4), Color(0xFFFF1493), Color(0xFFDC143C),
//     Color(0xFFFF0000), Color(0xFF00FF00), Color(0xFFFFFF00), Color(0xFF00FFFF),
//     Color(0xFFFF00FF), Color(0xFFFF8C00), Color(0xFF9400D3), Color(0xFF008B8B),
//     Color(0xFF1E90FF), Color(0xFF8A2BE2), Color(0xFFFF00FF),
//   ];
//   List<String> item = ["Today", "Month", "Total"];
//   var co = 0;
//   var text = "Today";
//   String? selectedSubject;
//   Duration remainingTime = Duration(seconds: 0);
//   Duration _originalRemainingTime = Duration(seconds: 0); // タイマー開始時の時間を保持
//   Map<String, Map<String, Duration>> studyTime = {};
//   Duration totalToday = Duration(seconds: 0);
//   Duration totalMonth = Duration(seconds: 0);
//   Duration totalAllTime = Duration(seconds: 0);
//   Timer? _timer;
//   bool isRunning = false;
//   var todayKey = "";
//   var monthKey = "";
//   var totalKey = "全体";
//   var formattedTime = "";
//   var text2 = "科目を選択";
//   int _currentPageIndex = 0;
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   var lastPausedTime = 0;
//   bool _isAppInBackground = false;
//
//
//   @override
//   void initState() {
//     super.initState();
//     first();
//     WidgetsBinding.instance.addObserver(this);
//     _initializeNotifications();
//   }
//
//   Future<void> _initializeNotifications() async {
//     tz.initializeTimeZones();
//     tz.setLocalLocation(tz.getLocation('Asia/Tokyo'));
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     // iOS の初期化設定を追加
//     const DarwinInitializationSettings initializationSettingsIOS =
//     DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
//
//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS, // iOS の設定を追加
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: (NotificationResponse details) {
//           // TODO: Handle action click
//         });
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     debugPrint('App Disposed');
//     _isAppInBackground = true;
//     _saveTimerState();
//     super.dispose();
//   }
//
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     switch (state) {
//       case AppLifecycleState.resumed:
//         debugPrint('App in Foreground (resumed)');
//         _isAppInBackground = false;
//         _loadTimerState();
//         break;
//       case AppLifecycleState.inactive:
//         debugPrint('App is Inactive');
//         break;
//       case AppLifecycleState.paused:
//         debugPrint('App in Background (paused)');
//         _isAppInBackground = true;
//         _saveTimerState();
//         break;
//       case AppLifecycleState.detached:
//         debugPrint('App Detached (detached)');
//         break;
//       case AppLifecycleState.hidden:
//     }
//   }
//
//   Future<void> start() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var bb = prefs.getInt("StartTime") ?? 0;
//     selectedSubject = prefs.getString("選択科目") ?? "";
//     text2 = prefs.getString("選択科目") ?? "";
//     if (bb == 0) {} else {
//       _isAppInBackground = false;
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       setState(() {
//         isRunning = prefs.getBool('isRunning') ?? false;
//         int savedRemainingSeconds = prefs.getInt('remainingTime') ?? 0;
//         remainingTime = Duration(seconds: savedRemainingSeconds);
//         selectedSubject = prefs.getString('selectedSubject');
//         lastPausedTime = prefs.getInt('lastPausedTime') ?? 0;
//         if (isRunning) {
//           if(!_isAppInBackground){
//             var aa = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//             var dif = (aa - lastPausedTime);
//             remainingTime = remainingTime - Duration(seconds: dif);
//             // if(remainingTime.inSeconds > 0){startTimer();}else{remainingTime = Duration(seconds: 0);
//             // isRunning = false;
//             // }
//           }else{
//             // if(remainingTime.inSeconds > 0){startTimer();}else{remainingTime = Duration(seconds: 0);
//             // isRunning = false;
//             // }
//           }
//         }
//
//         if(selectedSubject != null){
//           text2 = selectedSubject!;
//         }
//       });
//
//       end();}
//     setState(() {});
//   }
//
//   Future<void> end() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var bb = prefs.getInt("StartTime") ?? 0;
//     var aa = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//     setState(() {
//       var dif = (aa - bb);
//       if (dif > 0) {
//         remainingTime = remainingTime - Duration(seconds: dif);
//         if(remainingTime.inSeconds > 0){startTimer();}else{remainingTime = Duration(seconds: 0);
//         }
//       }
//     });
//   }
//
//   void startTimer() {print("0");
//     if (remainingTime.inSeconds >0) {print("1");
//       _originalRemainingTime = remainingTime; // タイマー開始時の時間を保存
//       final now = tz.TZDateTime.now(tz.local);
//       final scheduledTime = now.add(remainingTime);
//       if (selectedSubject != null) {
//         _scheduleNotification(selectedSubject!, scheduledTime);
//       }
//       _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//         setState(() {
//           if (remainingTime.inSeconds > 0) {
//             remainingTime = remainingTime - Duration(seconds: 1);
//           } else {
//             _timer?.cancel();
//             _cancelNotification(selectedSubject!);
//             isRunning = false;
//             _showNotification();
//           }
//         });
//       });
//       setState(() {
//         isRunning = true;
//       });
//     }
//   }
//
//   void stopTimer() {
//     if (isRunning) {
//       _timer?.cancel();
//       if (selectedSubject != null && remainingTime.inSeconds == 0) {
//         studyTime[selectedSubject!]![todayKey] =
//             (studyTime[selectedSubject!]![todayKey] ?? Duration(seconds: 0)) + _originalRemainingTime;
//         studyTime[selectedSubject!]![monthKey] =
//             (studyTime[selectedSubject!]![monthKey] ?? Duration(seconds: 0)) + _originalRemainingTime;
//         studyTime[selectedSubject!]![totalKey] =
//             (studyTime[selectedSubject!]![totalKey] ?? Duration(seconds: 0)) + _originalRemainingTime;
//         totalToday += _originalRemainingTime;
//         totalMonth += _originalRemainingTime;
//         totalAllTime += _originalRemainingTime;
//         saveStudyData(selectedSubject!, _originalRemainingTime);
//       }
//       setState(() {
//         loadStudyData();
//         _cancelNotification(selectedSubject!);
//         isRunning = false;
//         remainingTime = Duration(seconds: 0);
//       });
//     }
//   }
//   Future<void> toggleTimer() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     if (isRunning) {
//       _cancelNotification(selectedSubject!);
//       prefs.setInt("StartTime",0);
//       prefs.setString("選択科目","選択なし");
//       stopTimer();
//     } else {
//       startBool = true;
//       var aa = DateTime.now().millisecondsSinceEpoch~/ 1000;;
//       prefs.setInt("StartTime",aa);
//       prefs.setString("選択科目",text2);
//       startTimer();
//     }
//   }
//
//   var StartTime = DateTime.now();var startBool = false;
//
//   void resetTimer() {
//     stopTimer();
//     setState(() {
//       remainingTime = Duration(seconds: 0);
//     });
//   }
//
//   Future<void> _showTimerPicker() async {
//     showModalBottomSheet(context: context, builder: (BuildContext builder) {
//       return Container(height: 200, child: CupertinoTimerPicker(
//         mode: CupertinoTimerPickerMode.hm,
//         initialTimerDuration: remainingTime,
//         onTimerDurationChanged: (Duration newDuration) {
//           setState(() {
//             remainingTime = newDuration;
//             if(isRunning){startTimer();}
//           });
//         },
//       ));});
//   }
//   void setTime(int seconds) {
//     setState(() {
//       remainingTime = Duration(seconds: seconds);
//       if (isRunning) {startTimer();}
//     });
//   }
//   Future<void> _scheduleNotification(String subject, tz.TZDateTime scheduledTime) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//     AndroidNotificationDetails(
//       'timer_channel_id', 'Timer Channel',
//       channelDescription: 'Channel for timer notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//     );
//     final id = _generateNotificationId(subject);
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       'タイマー終了',
//       '$subjectのタイマーが終了しました。',
//       scheduledTime,
//       notificationDetails,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//       androidAllowWhileIdle: true,
//     );
//   }
//
//   int _generateNotificationId(String subject) {
//     final now = DateTime.now().millisecondsSinceEpoch;
//     return '$subject-$now'.hashCode;
//   }
//   Future<void> _cancelNotification(String subject) async {
//     final id = _generateNotificationId(subject);
//     await flutterLocalNotificationsPlugin.cancel(id);
//   }
//   Future<void> _showNotification() async {
//     const AndroidNotificationDetails androidNotificationDetails =
//     AndroidNotificationDetails(
//       'timer_channel_id', 'Timer Channel',
//       channelDescription: 'Channel for timer notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//     );
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'タイマー終了',
//       '設定した時間が経過しました。',
//       tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
//       notificationDetails,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//       androidAllowWhileIdle: true,
//     );
//   }
//   String formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String hours = twoDigits(duration.inHours);
//     String minutes = twoDigits(duration.inMinutes.remainder(60));
//     String seconds = twoDigits(duration.inSeconds.remainder(60));
//     return "$hours:$minutes:$seconds";
//   }
//
//   Future<void> saveStudyData(String subject, Duration duration) async {
//     final prefs = await SharedPreferences.getInstance();
//     todayKey = "${subject}_today_${DateFormat('yyyy-MM-dd').format(DateTime.now())}";
//     monthKey = "${subject}_month_${DateFormat('yyyy-MM').format(DateTime.now())}";
//     totalKey = "${subject}_total_";
//
//     prefs.setInt(todayKey, (prefs.getInt(todayKey) ?? 0) + duration.inSeconds);
//     prefs.setInt(monthKey, (prefs.getInt(monthKey) ?? 0) + duration.inSeconds);
//     prefs.setInt(totalKey, (prefs.getInt(totalKey) ?? 0) + duration.inSeconds);
//     prefs.setInt(DateFormat('yyyy-MM-dd').format(DateTime.now()),
//         (prefs.getInt(DateFormat('yyyy-MM-dd').format(DateTime.now())) ?? 0) + duration.inSeconds);
//     prefs.setInt(DateFormat('yyyy-MM').format(DateTime.now()),
//         (prefs.getInt(DateFormat('yyyy-MM').format(DateTime.now())) ?? 0) + duration.inSeconds);
//     prefs.setInt("total_all_time", (prefs.getInt("total_all_time") ?? 0) + duration.inSeconds);
//   }
//
//   Future<void> loadStudyData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
//     final month = DateFormat('yyyy-MM').format(DateTime.now());
//
//     for (var subject in items) {
//       todayKey = "${subject}_today_$today";
//       monthKey = "${subject}_month_$month";
//       totalKey = "${subject}_total_";
//
//       setState(() {
//         studyTime[subject]!["today"] = Duration(seconds: prefs.getInt(todayKey) ?? 0);
//         studyTime[subject]!["month"] = Duration(seconds: prefs.getInt(monthKey) ?? 0);
//         studyTime[subject]!["total"] = Duration(seconds: prefs.getInt(totalKey) ?? 0);
//       });
//     }
//
//     setState(() {
//       totalToday = Duration(seconds: prefs.getInt(DateFormat('yyyy-MM-dd').format(DateTime.now())) ?? 0);
//       totalMonth = Duration(seconds: prefs.getInt(DateFormat('yyyy-MM').format(DateTime.now())) ?? 0);
//       totalAllTime = Duration(seconds: prefs.getInt("total_all_time") ?? 0);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String formattedDate = DateFormat('MM/dd(E)', 'en_US').format(DateTime.now());
//     return Scaffold(backgroundColor: Colors.blueGrey[900],
//       body: Container(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(margin: EdgeInsets.only(top: 0), child: TextButton( onPressed: () => _showTimerPicker(),  child: Text(formatDuration(remainingTime), style: const TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold,),))),
//               // Container(margin: EdgeInsets.only(top: 0), child: Text(formatDuration(remainingTime), style: const TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold,),)),
//               SizedBox(height: 8),
//               Container(margin: EdgeInsets.only(top: 0), child: PopupMenuButton<String>(child: Text(text2, style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 15)),
//                 onSelected: (value) {setState(() {selectedSubject = value;text2 = value;});},
//                 itemBuilder: (BuildContext context) {
//                   return items.map((item) {
//                     return PopupMenuItem<String>(
//                       value: item,
//                       child: Text(item),
//                     );
//                   }).toList();
//                 },
//               ),
//               ),
//               Container(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           toggleTimer();
//                         },
//                         icon: Icon(
//                           isRunning ? Icons.pause : Icons.play_arrow,
//                           color: Colors.orange,
//                           size: 40,
//                         ),
//                       ),
//                       SizedBox(width: 40),
//                       IconButton(
//                         onPressed: resetTimer,
//                         icon: Icon(
//                           Icons.refresh,
//                           color: Colors.orange,
//                           size: 37,
//                         ),
//                       ),
//                     ],
//                   )),
//             ],
//           )),
//     );
//   }
//
//
//   Future<void> _saveTimerState() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setBool('isRunning', isRunning);
//     prefs.setInt('remainingTime', remainingTime.inSeconds);
//     prefs.setString('selectedSubject', selectedSubject ?? '');
//     if (isRunning) {lastPausedTime = DateTime.now().millisecondsSinceEpoch~/ 1000;}
//     prefs.setInt('lastPausedTime', lastPausedTime);
//   }
//
//   Future<void> _loadTimerState() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       isRunning = prefs.getBool('isRunning') ?? false;
//       int savedRemainingSeconds = prefs.getInt('remainingTime') ?? 0;
//       remainingTime = Duration(seconds: savedRemainingSeconds);
//       selectedSubject = prefs.getString('selectedSubject');
//       lastPausedTime = prefs.getInt('lastPausedTime') ?? 0;
//       if (isRunning) {
//         if(!_isAppInBackground){
//           var aa = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//           var dif = (aa - lastPausedTime);
//           remainingTime = remainingTime - Duration(seconds: dif);
//           if(remainingTime.inSeconds > 0){startTimer();}else{remainingTime = Duration(seconds: 0);
//           isRunning = false;
//           }
//         }else{
//           if(remainingTime.inSeconds > 0){startTimer();}else{remainingTime = Duration(seconds: 0);
//           isRunning = false;
//           }
//         }
//       }
//
//       if(selectedSubject != null){
//         text2 = selectedSubject!;
//       }
//     });
//   }
//
//
//   void first() async {
//     items = [];
//     items2 = ["合計"];
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     items = prefs.getStringList("科目リスト") ?? ["国語", "数学", "理科", "社会", "英語"];
//     items2.addAll(items);
//     setState(() {
//       for (var subject in items) {
//         studyTime[subject] = {
//           "today": Duration(seconds: 0),
//           "month": Duration(seconds: 0),
//           "total": Duration(seconds: 0),
//         };
//       }
//       loadStudyData();
//     });
//     start();
//   }
// }