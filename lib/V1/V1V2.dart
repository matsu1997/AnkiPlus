import 'package:anki/Price.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'V1All.dart';
import '../その他/Star.dart';
import '../アカウント/SignUp.dart';
import 'V1Q.dart';
import 'V1Q4.dart';


class V1V2 extends StatefulWidget {
  V1V2(this.name);
  String name;
  @override
  State<V1V2> createState() => _V1V2State();
}

class _V1V2State extends State<V1V2> {
  @override
  var ID = ""; var text = "";var text2 = "";var lock = "";
  int _selectedFruit = 0; double _kItemExtent = 32.0; var co = 0;
  var item1 = [];var searchItem = [];var  item = [];
  var boo = false;var select = 0;
  var controller = AutoScrollController();
  void initState() {
    super.initState();
    sign();first (); set();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),),
          iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
          actions: <Widget>[IconButton(onPressed: () {show ();
           // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Star()),);
            }, icon: Icon(Icons.skip_next,color: Colors.blueGrey[300],))],
        ),
        body: Container(
            child: Column(children: <Widget>[
              Expanded(child:GridView.count(controller: controller,padding: EdgeInsets.all(10.0), crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0, childAspectRatio: 3, shrinkWrap: true,
                  children: List.generate(item.length, (index) {
                    return GestureDetector(
                        onTap: () {
                          if(lock == ""){Navigator.of(context).push(MaterialPageRoute(builder: (context) => Price())).then((value) => sign());}else{co = index;StartView();}},
                        child:AutoScrollTag(key: ValueKey(index), controller: controller, index: index,
                        child: Container(alignment: Alignment.center, decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10),),// boxShadow: [new BoxShadow(color: Colors.grey, offset: new Offset(1.0, 1.0), blurRadius: 3.0,spreadRadius: 1)],),
                          child: Row(children: <Widget>[
                           Expanded(child:Container(margin:EdgeInsets.only(top:5,bottom: 5,left:10,right: 5),child:Text(item[index],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),)),
                         Container(child: item1[index] == 0 ?
                        Container():
                        Container(child: item1[index] == 1 ?// <5
                        Container(margin:EdgeInsets.only(top:5,bottom: 5,right:5),alignment:Alignment.centerRight,child: Icon(Icons.star_border,color: Colors.orange,size: 20,),):
                          Container(child: item1[index] == 5 ?//5<9
                          Container(margin:EdgeInsets.only(top:5,bottom: 5,right:5),alignment:Alignment.centerRight,child: Icon(Icons.star_half,color: Colors.orange,size: 20),): //10
                        Container(margin:EdgeInsets.only(top:5,bottom: 5,right:5),alignment:Alignment.centerRight,child: Icon(Icons.star,color: Colors.orange,size: 20),)))),
                        Container(child: lock == "" ?Container(child: index  %2 == 1 ?Container(child: Icon(Icons.key,color: Colors.blueGrey,size: 20,),):Container()):Container())
                        ]))));})))
                ])));}

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
  void StartView() {

    switch (widget.name) {
      case "英単語":text = "英→日";text2 = "日→英"; break;
      case "英熟語":text = "英→日";text2 = "日→英"; break;
      case "漢字":text = "漢→ひ";text2 = "ひ→漢"; break;
      case "古文":text = "単語→意味";text2 = "意味→単語"; break;
      case "漢文単語":text = "単語→読み/意味";text2 = "読み/意味→単語"; break;
      case "世界史":text = "問題(年表)→解答(出来事)";text2 = "解答(出来事)→問題(年表)";  break;
      case "日本史":text = "問題(年表)→解答(出来事)";text2 = "解答(出来事)→問題(年表)"; break;
      case "地理":text = "問題→答え";text2 = "答え→問題"; break;
      case "生物":text = "問題→答え";text2 = "答え→問題"; break;}
      showModalBottomSheet(isScrollControlled: true,context: context,backgroundColor: Colors.white,
      shape:  const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) { return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Container(child:SingleChildScrollView(
                child: Column(children: <Widget>[
                  Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {  Navigator.of(context).push(MaterialPageRoute(builder: (context) => V1All(widget.name,item[co]))).then((value) => judge(item[co]));},
                    child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("一覧",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),),
                  Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {select = 0;Connect();},
                    child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text(text,style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),),
                  Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { select = 1;Connect();},
                    child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text(text2,style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),),),
           ],)),);});}, );


  }


  Future<void> judge (text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(text, 1);
    showDialog(context: context, builder: (context) => AlertDialog(
      actions:[
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
          IconButton(onPressed: () { prefs.setInt(text, 1);set();Navigator.pop(context); Navigator.pop(context); }, icon: Icon(Icons.star_border,size: 30,),),
          IconButton(onPressed: () { prefs.setInt(text, 5);set();Navigator.pop(context); Navigator.pop(context); }, icon: Icon(Icons.star_half,size: 30),),
          IconButton(onPressed: () { prefs.setInt(text, 10);set();Navigator.pop(context); Navigator.pop(context); }, icon: Icon(Icons.star,size: 30),)
        ],)
      ],
      title: Text(text+"は覚えた?",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
    ));
  }


  Future<void> set () async {
    item1 = [];SharedPreferences prefs = await SharedPreferences.getInstance();boo = prefs.getBool("有料判定1")?? true;
  for(int i = 0; i< item.length; i++){
    switch (prefs.getInt(item[i])?? 0){
    case 0 :item1.add(0);break;
    case 1 :item1.add(1);break;
    case 5 :item1.add(5);break;
    case 10 :item1.add(10);break;
    default:print("");break;
  }
} setState(() {  });
  }

  void Connect() async{
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
   if (connectivityResult.contains(ConnectivityResult.none)) {
     showDialog(context: context, builder: (context) => AlertDialog(title:Container(child: Column(children: [
       Container(child:  Text("インターネットに接続されていません。",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center)),
     ],),)  ));} else{
    if(select == 0){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => V1Q(widget.name,item[co],0,1))).then((value) => judge(item[co]));
    }else{
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => V1Q(widget.name,item[co],1,1))).then((value) => judge(item[co]));
    }}
  }
  void first (){
    switch (widget.name){
      case "英単語" :searchItem = [["中学英語1",0],["中学英語50",49],["中学英語100",99],["高校英語1",140],["高校英語50",190],["高校英語100",240],["高校英語150",290]];
       item = ["中学英語1","中学英語2","中学英語3","中学英語4","中学英語5","中学英語6","中学英語7","中学英語8","中学英語9","中学英語10","中学英語11","中学英語12","中学英語13","中学英語14","中学英語15","中学英語16","中学英語17","中学英語18","中学英語19","中学英語20","中学英語21","中学英語22","中学英語23","中学英語24","中学英語25","中学英語26","中学英語27","中学英語28","中学英語29","中学英語30","中学英語31","中学英語32","中学英語33","中学英語34","中学英語35","中学英語36","中学英語37","中学英語38","中学英語39","中学英語40","中学英語41","中学英語42","中学英語43","中学英語44","中学英語45","中学英語46",
        "中学英語47","中学英語48","中学英語49","中学英語50","中学英語51","中学英語52","中学英語53","中学英語54","中学英語55","中学英語56","中学英語57","中学英語58","中学英語59","中学英語60","中学英語61","中学英語62","中学英語63","中学英語64","中学英語65","中学英語66","中学英語67","中学英語68","中学英語69","中学英語70","中学英語71","中学英語72","中学英語73","中学英語74","中学英語75","中学英語76","中学英語77","中学英語78","中学英語79","中学英語80","中学英語81","中学英語82","中学英語83","中学英語84","中学英語85","中学英語86","中学英語87","中学英語88","中学英語89","中学英語90","中学英語91","中学英語92","中学英語93","中学英語94","中学英語95","中学英語96","中学英語97","中学英語98","中学英語99","中学英語100","中学英語101","中学英語102","中学英語103","中学英語104","中学英語105","中学英語106","中学英語107","中学英語108","中学英語109","中学英語110","中学英語111","中学英語112","中学英語113","中学英語114","中学英語115","中学英語116","中学英語117","中学英語118","中学英語119","中学英語120","中学英語121","中学英語122","中学英語123","中学英語124","中学英語125","中学英語126","中学英語127","中学英語128","中学英語129","中学英語130","中学英語131","中学英語132","中学英語133","中学英語134","中学英語135","中学英語136","中学英語137","中学英語138","中学英語139","中学英語140","中学英語141",
        "高校英語1","高校英語2","高校英語3","高校英語4","高校英語5","高校英語6","高校英語7","高校英語8","高校英語9","高校英語10","高校英語11","高校英語12","高校英語13","高校英語14","高校英語15","高校英語16","高校英語17","高校英語18","高校英語19","高校英語20","高校英語21","高校英語22","高校英語23","高校英語24","高校英語25","高校英語26","高校英語27","高校英語28","高校英語29","高校英語30","高校英語31","高校英語32","高校英語33","高校英語34","高校英語35","高校英語36","高校英語37","高校英語38","高校英語39","高校英語40","高校英語41","高校英語42","高校英語43","高校英語44","高校英語45","高校英語46","高校英語47","高校英語48","高校英語49","高校英語50","高校英語51","高校英語52","高校英語53","高校英語54","高校英語55","高校英語56","高校英語57","高校英語58","高校英語59","高校英語60","高校英語61","高校英語62","高校英語63","高校英語64","高校英語65","高校英語66","高校英語67","高校英語68","高校英語69","高校英語70","高校英語71","高校英語72","高校英語73","高校英語74","高校英語75","高校英語76","高校英語77","高校英語78","高校英語79","高校英語80","高校英語81","高校英語82","高校英語83","高校英語84","高校英語85","高校英語86","高校英語87","高校英語88","高校英語89","高校英語90","高校英語91","高校英語92","高校英語93","高校英語94","高校英語95","高校英語96","高校英語97","高校英語98","高校英語99","高校英語100","高校英語101","高校英語102","高校英語103","高校英語104","高校英語105","高校英語106","高校英語107","高校英語108","高校英語109","高校英語110",
        "高校英語111","高校英語112","高校英語113","高校英語114","高校英語115","高校英語116","高校英語117","高校英語118","高校英語119","高校英語120","高校英語121","高校英語122","高校英語123","高校英語124","高校英語125","高校英語126","高校英語127","高校英語128","高校英語129","高校英語130","高校英語131","高校英語132","高校英語133","高校英語134","高校英語135","高校英語136","高校英語137","高校英語138","高校英語139","高校英語140","高校英語141","高校英語142","高校英語143","高校英語144","高校英語145","高校英語146","高校英語147","高校英語148","高校英語149","高校英語150","高校英語151","高校英語152","高校英語153","高校英語154","高校英語155","高校英語156","高校英語157","高校英語158","高校英語159","高校英語160","高校英語161","高校英語162","高校英語163","高校英語164","高校英語165","高校英語166","高校英語167","高校英語168","高校英語169","高校英語170","高校英語171","高校英語172","高校英語173","高校英語174","高校英語175","高校英語176","高校英語177","高校英語178","高校英語179",
     ]; ;break;
      case "英熟語" :searchItem = [["中学英熟語1",0],["高校英熟語1",40],];
      item = [ "中学英熟語1","中学英熟語2","中学英熟語3","中学英熟語4","中学英熟語5","中学英熟語6","中学英熟語7","中学英熟語8","中学英熟語9","中学英熟語10","中学英熟語11","中学英熟語12","中学英熟語13","中学英熟語14","中学英熟語15","中学英熟語16","中学英熟語17","中学英熟語18","中学英熟語19","中学英熟語20","中学英熟語21","中学英熟語22","中学英熟語23","中学英熟語24","中学英熟語25","中学英熟語26","中学英熟語27","中学英熟語28","中学英熟語29","中学英熟語30","中学英熟語31","中学英熟語32","中学英熟語33","中学英熟語34","中学英熟語35","中学英熟語36","中学英熟語37","中学英熟語38","中学英熟語39","中学英熟語40",
        "高校英熟語1","高校英熟語2","高校英熟語3","高校英熟語4","高校英熟語5","高校英熟語6","高校英熟語7","高校英熟語8","高校英熟語9","高校英熟語10",  "高校英熟語11","高校英熟語12","高校英熟語13","高校英熟語14","高校英熟語15","高校英熟語16","高校英熟語17","高校英熟語18","高校英熟語19","高校英熟語20",  "高校英熟語21","高校英熟語22","高校英熟語23","高校英熟語24","高校英熟語25","高校英熟語26","高校英熟語27","高校英熟語28","高校英熟語29","高校英熟語30"]; ;break;

      case "漢字" :searchItem =[["中高漢字1",0],["中高漢字50",49],["中高漢字82",81],];setState(() { item = ["中高漢字1","中高漢字2","中高漢字3","中高漢字4","中高漢字5","中高漢字6","中高漢字7","中高漢字8","中高漢字9","中高漢字10","中高漢字11","中高漢字12","中高漢字13","中高漢字14","中高漢字15","中高漢字16","中高漢字17","中高漢字18","中高漢字19","中高漢字20","中高漢字21","中高漢字22","中高漢字23","中高漢字24","中高漢字25","中高漢字26","中高漢字27","中高漢字28","中高漢字29","中高漢字30","中高漢字31","中高漢字32","中高漢字33","中高漢字34","中高漢字35","中高漢字36","中高漢字37","中高漢字38","中高漢字39","中高漢字40","中高漢字41","中高漢字42","中高漢字43","中高漢字44","中高漢字45","中高漢字46","中高漢字47","中高漢字48","中高漢字49","中高漢字50","中高漢字51","中高漢字52","中高漢字53","中高漢字54","中高漢字55","中高漢字56","中高漢字57","中高漢字58","中高漢字59","中高漢字60","中高漢字61","中高漢字62","中高漢字63","中高漢字64","中高漢字65","中高漢字66","中高漢字67","中高漢字68","中高漢字69","中高漢字70","中高漢字71","中高漢字72","中高漢字73","中高漢字74","中高漢字75","中高漢字76","中高漢字77","中高漢字78","中高漢字79","中高漢字80","中高漢字81","中高漢字82",];});break;
      case "古文" :searchItem = [["古文単語1",0],["古文単語40",39],];setState(() { item = ["古文単語1","古文単語2","古文単語3","古文単語4","古文単語5","古文単語6","古文単語7","古文単語8","古文単語9","古文単語10","古文単語11","古文単語12","古文単語13","古文単語14","古文単語15","古文単語16","古文単語17","古文単語18","古文単語19","古文単語20","古文単語21","古文単語22","古文単語23","古文単語24","古文単語25","古文単語26","古文単語27","古文単語28","古文単語29","古文単語30","古文単語31","古文単語32","古文単語33","古文単語34","古文単語35","古文単語36","古文単語37","古文単語38","古文単語39","古文単語40",];});break;
      case "漢文単語" :searchItem = [];setState(() { item = ["漢文単語1","漢文単語2","漢文単語3","漢文単語4","漢文単語5","漢文単語6","漢文単語7","漢文単語8","漢文単語9"];});
      case "世界史" :searchItem = [["世界史年表1",0],["先史時代1",36],["中国(明)1",86],["第一次世界大戦までの世界1",135]];setState(() { item = ["世界史年表1","世界史年表2","世界史年表3","世界史年表4","世界史年表5","世界史年表6","世界史年表7","世界史年表8","世界史年表9","世界史年表10","世界史年表11","世界史年表12","世界史年表13","世界史年表14","世界史年表15","世界史年表16","世界史年表17","世界史年表18","世界史年表19","世界史年表20","世界史年表21","世界史年表22","世界史年表23","世界史年表24","世界史年表25","世界史年表26","世界史年表27","世界史年表28","世界史年表29","世界史年表30","世界史年表31","世界史年表32","世界史年表33","世界史年表34","世界史年表35","世界史年表36","先史時代1","先史時代2","古代オリエント1","古代オリエント2","古代オリエント3","古代オリエント4","古代エジプト1","古代エジプト2","古代ギリシア1","古代ギリシア2","古代ギリシア3","古代ギリシア4","古代ギリシア5","古代ローマ1","古代ローマ2","古代ローマ3","古代インド1","古代インド2","古代インド3","古代インド4","古代東南アジア1","古代南北アメリカ1","中国(先史~漢)1","中国(先史~漢)2","中国(先史~漢)3","中国(先史~漢)4","中国(魏晋南北朝)1","中国(魏晋南北朝)2","中国(隋と唐)1","中国(隋と唐)2","中国(隋と唐)3","中世(アジア)1","中世(アジア)2","中世(アジア)3","中世(モンゴル)1","中世(モンゴル)2","中世(モンゴル)3","中世(イスラム)1","中世(イスラム)2","中世(イスラム)3","中世(イスラム)4","中世(西ヨーロッパ・前半)1","中世(西ヨーロッパ・前半)2","中世(西ヨーロッパ・前半)3","中世(西ヨーロッパ・後半)1","中世(西ヨーロッパ・後半)2","中世(西ヨーロッパ・後半)3","中世(西ヨーロッパ・後半)4","中世(東ヨーロッパ)1","交易1", "中国(明)1", "中国(明)2", "中国(明)3","近世(トルコ)1","近世(トルコ)2","近世(アジア、ムガル帝国)1","近世(アジア、ムガル帝国)2","近世(大航海時代)1","近世(大航海時代)2","近世(ルネサンス)1","近世(ルネサンス)2","近世(宗教改革)1","近世(宗教改革)2"
          "近世(イギリス)1","近世(イギリス)2","近世(ヨーロッパでの出来事)1","近世(ヨーロッパでの出来事)2","近世(ヨーロッパでの出来事)3","近世(ヨーロッパの海外進出)1","近世(ヨーロッパの海外進出)2","近世(ヨーロッパの海外進出)3","近世(ヨーロッパの海外進出)4","近世(ヨーロッパ文化)1","近世(ヨーロッパ文化)2","近世(産業革命)1","近世(フランス)1","近世(フランス)2","近世(フランス)3","近世(フランス)4","近世(ウィーン会議以降のヨーロッパ社会)1","近世(ウィーン会議以降のヨーロッパ社会)2","近世(ウィーン会議以降のヨーロッパ社会)3","近世(ウィーン会議以降のヨーロッパ社会)4","近世(アメリカ)1","近世(アメリカ)2","近世(アメリカ)3","近世(アメリカ)4","近世(アメリカ)5","近世(中東・エジプトの出来事)1","近世(中東・エジプトの出来事)2","中国(清)1","中国(清)2","中国(清)3","中国(清)4","近世(ロシア)1","近世(ロシア)2","第一次世界大戦までの世界1","第一次世界大戦までの世界2","第一次世界大戦までの世界3","第一次世界大戦までの世界4","第一次世界大戦までの世界5","第一次世界大戦1","第一次世界大戦後1","第一次世界大戦後2","第一次世界大戦後3","第一次世界大戦後4","第二次世界大戦までの世界1","第二次世界大戦までの世界2","第二次世界大戦1","第二次世界大戦後(~’54)1","第二次世界大戦後(~’54)2","第二次世界大戦後(~’68)1","第二次世界大戦後(~’68)2","第二次世界大戦後(~’97)1","第二次世界大戦後(~’97)2"];});break;
      case "日本史" :searchItem = [["日本史年表1",0],["奈良時代1",38],["鎌倉時代(初期)1",57],["江戸時代(初期)1",81],["明治時代(前期)1",103],["日清・日露戦争1",121]];setState(() { item = ["日本史年表1","日本史年表2","日本史年表3","日本史年表4","日本史年表5","日本史年表6","日本史年表7","日本史年表8","日本史年表9","日本史年表10","日本史年表11","日本史年表12","日本史年表13","日本史年表14","日本史年表15","日本史年表16","日本史年表17","日本史年表18","旧石器縄文時代・縄文時代1","旧石器縄文時代・縄文時代2","弥生時代1","弥生時代2","弥生時代3","古墳時代1","古墳時代2","ヤマト政権1","ヤマト政権2","ヤマト政権3","ヤマト政権4","飛鳥時代1","飛鳥時代2","飛鳥時代3","飛鳥時代4","飛鳥時代5","飛鳥時代(大宝律令)1","飛鳥時代(大宝律令)2","飛鳥時代(大宝律令)3","飛鳥時代(大宝律令)4","飛鳥時代(大宝律令)5","奈良時代1","奈良時代2","奈良時代3","奈良時代4","奈良時代5","平安時代(初期)1","平安時代(初期)2","平安時代(初期)3","平安時代(初期)4","平安時代(中期)1","平安時代(中期)2","平安時代(中期)3","平安時代(中期)4","平安時代(中期)5","平安時代(中期)6","平安時代(後期)1","平安時代(後期)2","平安時代(後期)3","平安時代(後期)4","平安時代(後期)5","平安時代(後期)6","鎌倉時代(初期)1","鎌倉時代(初期)2","鎌倉時代(初期)3","鎌倉時代(初期)4","鎌倉時代(中期)1","鎌倉時代(中期)2","鎌倉時代(後期)1","鎌倉時代(文化)1","鎌倉時代(文化)2","鎌倉時代(文化)3","鎌倉時代(文化)4","南北朝時代1","南北朝時代2","室町時代(初期)1","室町時代(初期)2","室町時代(中期)1","室町時代(中期)2","室町時代(中期)3","室町時代(中期)4","戦国時代1","戦国時代2","安土桃山時代1","安土桃山時代2","安土桃山時代3","江戸時代(初期)1","江戸時代(初期)2","江戸時代(初期)3","江戸時代(初期)4","江戸時代(初期)5","江戸時代(初期)6","江戸時代(中期)1","江戸時代(中期)2","江戸時代(中期)3","江戸時代(中期)4","江戸時代(中期)5","江戸時代(後期)1","江戸時代(後期)2","江戸時代(後期)3","江戸時代(後期)4","江戸時代(後期)5","江戸時代(後期)6","江戸時代(後期)7","江戸時代(後期)8","江戸時代(後期)9","江戸時代(後期)10"
      ,"明治時代(前期)1","明治時代(前期)2","明治時代(前期)3","明治時代(前期)4","明治時代(前期)5","明治時代(前期)6","明治時代(前期)7","明治時代(前期)8","明治時代(前期)9","明治時代(後期)1","明治時代(後期)2","明治時代(後期)3","明治時代(後期)4","明治時代(後期)5","明治時代(文化)1","明治時代(文化)2","明治時代(文化)3","明治時代(文化)4", "日清・日露戦争1", "日清・日露戦争2", "日清・日露戦争3", "日清・日露戦争4", "第一次世界大戦1", "第一次世界大戦2", "第一次世界大戦3","大正時代1","大正時代2","大正時代3","大正時代4","昭和時代(初期)1","昭和時代(初期)2","昭和時代(初期)3","第二次世界大戦1","第二次世界大戦2","終戦後1","終戦後2","終戦後3"];});break;

      case "地理" :searchItem = [["",0],["",0],["",0],["",0],["",0],["",0],];setState(() { item = ["地球と地図","地球と地図2","地球と地図3","地球と地図4","地球と地図5","地球と地図6","地球と地図7","大地形","大地形2","大地形3","大地形4","大地形5","大地形6","大地形7","小地形","小地形2","小地形3","小地形4","小地形5","小地形6","小地形7","小地形8","小地形9","地形図","地形図2","地形図3","地形図4","地形図5","気候要素と気候因子","気候要素と気候因子2","気候要素と気候因子3","気候要素と気候因子4","気候要素と気候因子5","気候要素と気候因子6","気候要素と気候因子7","気候要素と気候因子8","気候区分","気候区分2","気候区分3","気候区分4","気候区分5","気候区分6","気候区分7","気候区分8","気候区分9","陸水と海洋","陸水と海洋2","陸水と海洋3","陸水と海洋4","自然災害と防災","自然災害と防災2","自然災害と防災3","自然災害と防災4","自然災害と防災5","自然災害と防災6","自然災害と防災7","農業","農業2","農業3","農業4","農業5","農業6","農業7","農業8","農業9","農業10","農業11","農業12","林業と水産業","林業と水産業2","林業と水産業3","林業と水産業4","商業と観光業","商業と観光業2","商業と観光業3","商業と観光業4","エネルギーと鉱山資源","エネルギーと鉱山資源2","エネルギーと鉱山資源3","エネルギーと鉱山資源4","エネルギーと鉱山資源5","エネルギーと鉱山資源6","エネルギーと鉱山資源7","エネルギーと鉱山資源8","工業","工業2","工業3","工業4","工業5","工業6","工業7","地域開発と環境問題","地域開発と環境問題2","地域開発と環境問題3","地域開発と環境問題4","地域開発と環境問題5","地域開発と環境問題6","人口","人口2","人口3","人口4","人口5","人口6","人口7","人口8","村落と都市","村落と都市2","村落と都市3","村落と都市4","村落と都市5","村落と都市6",
        "交通と通信","交通と通信2","交通と通信3","交通と通信4","交通と通信5","交通と通信6","交通と通信7","貿易と資本の移動","貿易と資本の移動2","貿易と資本の移動3","貿易と資本の移動4","貿易と資本の移動5","貿易と資本の移動6","国家と民族","国家と民族2","国家と民族3","国家と民族4","国家と民族5","国家と民族6","国家と民族7","東アジア","東アジア2","東アジア3","東アジア4","東アジア5","東アジア6","東アジア7","東アジア8","東アジア9","東南アジアと南アジア","東南アジアと南アジア2","東南アジアと南アジア3","東南アジアと南アジア4","東南アジアと南アジア5","東南アジアと南アジア6","東南アジアと南アジア7","東南アジアと南アジア8","西アジアとアフリカ","西アジアとアフリカ2","西アジアとアフリカ3","西アジアとアフリカ4","西アジアとアフリカ5","西アジアとアフリカ6","西アジアとアフリカ7","西アジアとアフリカ8","ヨーロッパ","ヨーロッパ2","ヨーロッパ3","ヨーロッパ4","ヨーロッパ5","ヨーロッパ6","ヨーロッパ7","ヨーロッパ8","ヨーロッパ9","ヨーロッパ10","ロシアと周辺地域","ロシアと周辺地域2","ロシアと周辺地域3","ロシアと周辺地域4","ロシアと周辺地域5","ロシアと周辺地域6","アングロアメリカ","アングロアメリカ2","アングロアメリカ3","アングロアメリカ4","アングロアメリカ5","アングロアメリカ6","アングロアメリカ7","アングロアメリカ8","アングロアメリカ9","アングロアメリカ10","アングロアメリカ11","ラテンアメリカ","ラテンアメリカ2","ラテンアメリカ3","ラテンアメリカ4","ラテンアメリカ5","オセアニア","オセアニア2","オセアニア3","オセアニア4","オセアニア5","日本","日本2","日本3","日本4","日本5","日本6","日本7","日本8",];});break;
      case "生物" :searchItem = [];setState(() { item = ["細胞の基礎1","細胞の基礎2","細胞の基礎3","細胞の基礎4","細胞の基礎5","細胞の基礎6","細胞の基礎7","細胞分裂1","細胞分裂2","細胞分裂3","単細胞生物と多細胞生物1","単細胞生物と多細胞生物2","単細胞生物と多細胞生物3","無性生殖と有性生殖1","無性生殖と有性生殖2","植物と動物の生殖1","植物と動物の生殖2","発生1","発生2","発生3","遺伝1","遺伝2","遺伝3","遺伝4","遺伝5","神経1","神経2","神経3","神経4","神経5","神経6","血液と循環1","血液と循環2","内蔵の働き1","内蔵の働き2","ホルモンと自律神経1","ホルモンと自律神経2","植物の種類と水の吸収1","光と植物1","植物の成長1","植物の成長2","発芽1","発芽2","発芽3","植物ホルモン1"];});break;
      case "物理" :searchItem = [["",0],["",0],["",0],["",0],["",0],["",0],];setState(() { item = ["","","",];});break;
      case "化学" :searchItem = [["",0],["",0],["",0],["",0],["",0],["",0],];setState(() { item = ["","","",];});break;
      default:print("");break;

  }}
  void sign() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {ID = prefs.getString("ID") ?? ""; lock = prefs.getString("ロック解除") ?? "";});
    if (ID == "") {Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()));}
  }
 void show (){
   _showDialog(CupertinoPicker(
       magnification: 1.22, squeeze: 1.2, useMagnifier: true, itemExtent: _kItemExtent,
       scrollController: FixedExtentScrollController(initialItem: _selectedFruit,),
       onSelectedItemChanged: (int selectedItem) {
         setState(() {_selectedFruit = selectedItem;aa(selectedItem);});},
       children: List<Widget>.generate(searchItem.length, (int index) { return Center(child: Text(searchItem[index][0]));co =searchItem[index][1]; }),
     ),);}

  void aa(int a){
    controller.scrollToIndex(searchItem[a][1], preferPosition: AutoScrollPosition.begin,);}


  // void start(){showDialog(context: context, builder: (context) => AlertDialog(
  //   title: Text("英単語　→　日本語",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center), ));}

 }
