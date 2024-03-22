
import 'package:anki/%E3%81%9D%E3%81%AE%E4%BB%96/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import '../Create/CreateV1.dart';
import '../V2/V2.dart';
import '../アカウント/SignUp.dart';
import 'V1V2.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
class V1 extends StatefulWidget {

  @override
  State<V1> createState() => _V1State();
}

class _V1State extends State<V1> {
  var item = ["自作","復習","英単語", "漢字", "古文", "漢文単語", "世界史", "日本史", "地理", "生物", "物理", "化学",]; //Icons.history
  var item1 = [ Icons.create_new_folder,Icons.history,Icons.format_color_text_outlined, Icons.edit_outlined,Icons.receipt_long,Icons.edit_note, Icons.language_outlined, Icons.history_edu, Icons.pin_drop_outlined, Icons.coronavirus_outlined, Icons.rocket_launch_outlined, Icons.science_outlined,];
  final _pageController = PageController(viewportFraction: 0.877);final flnp = FlutterLocalNotificationsPlugin();
  double currentPage = 0;
  var ID  = "";

  void initState() {DateTime now = DateTime.now();DateFormat outputFormat = DateFormat('yyyy年MM月dd日'); var date = outputFormat.format(now);print(date);

  _pageController.addListener(() {setState(() {currentPage = _pageController.page!.toDouble();});});
    super.initState();_scheduleDaily8AMNotification();
    sign();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        title:  Text("", style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center,),
        centerTitle: true,elevation: 0,
          leading:IconButton(onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => Account()),);}, icon: Icon(Icons.person_3_outlined,color: Colors.black87,)),
          actions: <Widget>[IconButton(onPressed: () {start();}, icon: Icon(Icons.info_outline,color: Colors.black87,))],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
          //  Container(color: Colors.white,width: double.infinity, height: 60),
             Container(child: Container(margin: EdgeInsets.only(top: 0.0), color: Colors.white,
                child: Column(children: <Widget>[
                  Container(margin: EdgeInsets.only(top: 10.0), height: 200,
                    child: PageView(physics: BouncingScrollPhysics(), controller: _pageController, scrollDirection: Axis.horizontal,
                      children: [
                        // GestureDetector(onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateV1(ID)));
                        // }, child:Container(margin: EdgeInsets.only(right: 15), width: 350, height: 250, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),  border: Border.all(color: Colors.grey),),
                        //     child:Column(children: [
                        //       Expanded(child:Container(width: 350, height: 150, child: Image.asset("images/happy.png"))),
                        //       Container(margin:EdgeInsets.all(5),child:Text("問題を作成してみよう!", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15,),)),
                        //       Container(margin:EdgeInsets.only(top:5,bottom: 10),child:Text("覚えたい事を単語帳にしよう", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10,),textAlign: TextAlign.center,))],)),
                        // ),
                        Container(margin: EdgeInsets.only(right: 15), width: 350, height: 250, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),  border: Border.all(color: Colors.grey.shade300),),
                            child:Column(children: [
                              Expanded(child:Container(width: 350, height: 150, child: Image.asset("images/happy.png"))),
                              Container(margin:EdgeInsets.all(5),child:Text("アップデート情報", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15,),textAlign: TextAlign.center,)),
                              Container(margin:EdgeInsets.only(top:5,bottom: 10),child:Text("表示秒数を小数点を使えるようになりました。", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10,),textAlign: TextAlign.center,))],)),

                        Container(margin: EdgeInsets.only(right: 15), width: 350, height: 250, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),  border: Border.all(color: Colors.grey.shade300),),
                            child:Column(children: [
                              Expanded(child:Container(width: 350, height: 150, child: Image.asset("images/attention.png"))),
                              Container(margin:EdgeInsets.all(5),child:Text("英単語・漢字・古文・漢文単語・世界史・日本史・生物を学習可能です。", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15,),textAlign: TextAlign.center,)),
                              Container(margin:EdgeInsets.only(top:5,bottom: 10),child:Text("その他は問題作成中です。少々お待ちください", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10,),textAlign: TextAlign.center,))],)),

                        Container(margin: EdgeInsets.only(right: 15), width: 350, height: 250,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),  border: Border.all(color: Colors.grey.shade300),),
                            child:Column(children: [
                              Expanded(child:Container(width: 350, height: 150, child: Image.asset("images/focus.png"))),
                              Container(margin:EdgeInsets.all(5),child:Text("集中力が落ちてきたあなたへ", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15,),)),
                              Container(margin:EdgeInsets.only(top:5,bottom: 10),child:Text("水を飲む・軽い運動・瞑想・昼寝をご検討ください", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10,),textAlign: TextAlign.center))],)),
                        Container(margin: EdgeInsets.only(right: 15), width: 350, height: 250,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),  border: Border.all(color: Colors.grey.shade300),),
                            child:Column(children: [
                              Expanded(child:Container(width: 350, height: 150, child: Image.asset("images/idea.png"))),
                              Container(margin:EdgeInsets.all(5),child:Text("やる気を出すには？", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15,),)),
                              Container(margin:EdgeInsets.only(top:5,bottom: 10),child:Text("背筋を伸ばす・軽い運動(腹筋20回など)・ルーティン作成\nコーヒー・勉強をしないデメリットを書きまくる", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10,),textAlign: TextAlign.center,))],)),
                        Container(margin: EdgeInsets.only(right: 15), width: 350, height: 250,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),  border: Border.all(color: Colors.grey.shade300),),
                            child:Column(children: [
                              Expanded(child:Container(width: 350, height: 150, child: Image.asset("images/study.png"))),
                              Container(margin:EdgeInsets.all(5),child:Text("効率の良い勉強法は？", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15,),)),
                              Container(margin:EdgeInsets.only(top:5,bottom: 10),child:Text("検索練習・教えるつもり勉強・インターリービング・記憶の宮殿\nネットで検索してみては？", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10,),textAlign: TextAlign.center,))],)),
                      ],),),
                  Container(width: double.infinity, alignment: Alignment.center, padding: EdgeInsets.only(top:10),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                          return Container(margin: EdgeInsets.only(right: 10), alignment: Alignment.center, height: 9, width: 9,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: currentPage == index ? Colors.black : Colors.black12,),);},),),),
                ]))),
            Container(margin: EdgeInsets.only(top: 0, bottom: 30),
                child: GridView.count(padding: EdgeInsets.all(20.0),
                    crossAxisCount: 3, crossAxisSpacing: 10.0, mainAxisSpacing: 0.0, childAspectRatio: 1, shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                    children: List.generate(item.length, (index) {
                      return GestureDetector(
                          onTap: () {if (item[index] == "英単語" || item[index] == "漢字" || item[index] == "古文"|| item[index] == "漢文単語"||item[index] == "世界史"|| item[index] == "日本史"|| item[index] == "生物"){Navigator.of(context).push(MaterialPageRoute(builder: (context) => V1V2(item[index])),);}else{
                            if (item[index] == "自作" ){Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateV1(ID)));}else{};
                            if (item[index] == "復習" ){Navigator.of(context).push(MaterialPageRoute(builder: (context) => V2()));}else{};
                          }},
                          child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), ),
                            child: Column(children: <Widget>[
                                Container(alignment: Alignment.bottomCenter,child:item[index] == "英単語"|| item[index] == "漢字" || item[index] == "古文"||item[index] == "漢文単語"|| item[index] == "世界史"|| item[index] == "日本史" || item[index] == "生物" ?Container(child: Icon(item1[index], color: Colors.blue, size: 60,)):
                                Container(alignment: Alignment.bottomCenter,child:item[index] == "自作"?Container(child: Icon(item1[index], color: Colors.orange, size: 60,)):
                                Container(alignment: Alignment.bottomCenter,child:item[index] == "復習"?Container(child: Icon(item1[index], color: Colors.green, size: 60,)):
                                Container(alignment: Alignment.bottomCenter,child:Container(child: Icon(item1[index], color: Colors.grey, size: 60,)))))),
                               Container(margin: EdgeInsets.all(0),alignment: Alignment.center, child: Text(item[index], style: TextStyle(color: Colors.blueGrey[800], fontWeight: FontWeight.bold, fontSize: 10,),)),

                            ]),));
                    }))),
            Container(height: 50,color: Colors.white,)
          ],),),);
  }
  void start(){showModalBottomSheet(isScrollControlled: true, context: context,backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) {return Container(height: 700,
          child: SingleChildScrollView(
              child: Column(children: <Widget>[
                Container(margin :EdgeInsets.only(top:30,bottom: 0,right: 20),width: 150,height: 150, child:Image(image: AssetImage("images/first.png"),),),
                Container(width:double.infinity,margin :EdgeInsets.only(top: 30),child:Text("即答出来なきゃ覚えてない",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 22),textAlign: TextAlign.center,)),
                Container(width:double.infinity,margin :EdgeInsets.only(top: 10,bottom:50,left: 10,right: 10),child:Text("このアプリは暗記を目的に作りました\n問題の表示から数秒で解答が表示されます\n即答出来るまで繰り返し表示されます\n復習は「覚えるまで掛かった回数による難易度別」や「忘却曲線による問題」などあります\n答えに表示されるのが全ての答えでは無い場合があります。あくまで学習の第一歩としてご利用頂けたらと思います。",style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold,fontSize: 15,height: 3),textAlign: TextAlign.center,)),

              ])));});}
  void sign() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ID = prefs.getString("ID") ?? "";
    if (ID == "") {Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()));}else{}
  }


  _nextInstanceOf8AM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, 8);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
  Future<void> _scheduleDaily8AMNotification() async {
    await flnp.zonedSchedule(1343663, 'AnkiPlus', 'おはようございます!ちょこっと解いてみてはいかが？', _nextInstanceOf8AM(),
      const NotificationDetails(
        android: AndroidNotificationDetails('AnkiPlus', 'おはようございます!ちょこっと解いてみてはいかが？', channelDescription: 'Face photo notification',
        ),
        iOS: DarwinNotificationDetails(badgeNumber: 1,),
      ),
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidAllowWhileIdle: true,
    );
  }

}




