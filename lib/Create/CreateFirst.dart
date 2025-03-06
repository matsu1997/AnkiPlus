import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AdManager.dart';

class CreateFirst extends StatefulWidget {
  CreateFirst(this.ID);
  String ID;
  @override
  State<CreateFirst> createState() => _CreateFirstState();
}

class _CreateFirstState extends State<CreateFirst> {
  var Qmap = {}; var Umap = {};var mapE = {};
  var id = "";var date = "";var name = "";var category = "カテゴリー";var swi = false;var text = "";
  var co = 0;var select = 0;var count = 2;var Q = "";var A = "";var grade = "レベル";
  late TextEditingController _bodyController; late TextEditingController _bodyController2; late TextEditingController _bodyController3;late TextEditingController _bodyController4;late TextEditingController _bodyController5;
  var item = [];
  var isOn = false;
  final _tab = <Tab> [Tab( child:Text("一つ",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
    Tab( child:Text("一括",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
    Tab( child:Text("csv",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
  ];
  void initState() {
    super.initState();_bodyController = TextEditingController();_bodyController2 = TextEditingController();_bodyController3 = TextEditingController();_bodyController4 = TextEditingController();_bodyController5 = TextEditingController();
   }

  @override
  Widget build(BuildContext context) {
    return   GestureDetector(onTap: () => primaryFocus?.unfocus(),child:Scaffold(backgroundColor: Colors.white,
          appBar: AppBar(backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
            actions: [TextButton(onPressed: () {send();}, child: Text("保存",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.orange,fontSize: 20),textAlign: TextAlign.center,),)],
          ),
      floatingActionButtonLocation:FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.orange, child: const Icon(Icons.add),
        onPressed: () {AddView();},),
          body: SingleChildScrollView(
            child: Column(children: <Widget>[
              Container(padding: EdgeInsets.symmetric(horizontal: 10.0,),margin: EdgeInsets.only(top:10,left: 30,right: 30,bottom: 10),width:double.infinity,height:50,
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5),),
                child: TextField(controller: _bodyController,decoration: InputDecoration(border: InputBorder.none,hintText: "タイトル"),onChanged: (String value) {setState(() {name = value;});},),),
              // Container(margin: EdgeInsets.only(top:10,left: 30,right: 30,bottom: 10),width:double.infinity,height:50,decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5)),child:TextButton(onPressed: () {SearchShow();},
              // child: Align(alignment: Alignment.centerLeft, child: Text(category,style: TextStyle(color: Colors.blueGrey[900]), textAlign: TextAlign.left),  ))),
              // Container(margin: EdgeInsets.only(top:10,left: 30,right: 30,bottom: 10),width:double.infinity,height:50,decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5)),child:TextButton(onPressed: () {grade1();},
              //     child: Align(alignment: Alignment.centerLeft, child: Text(grade,style: TextStyle(color: Colors.blueGrey[900]), textAlign: TextAlign.left),  ))),
              Container(padding: EdgeInsets.symmetric(horizontal: 10.0,),margin: EdgeInsets.only(top:10,left: 30,right: 30,bottom: 10),width:double.infinity,height:50,
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5),),
                child: TextField(keyboardType: TextInputType.numberWithOptions(decimal: true),controller: _bodyController2,decoration: InputDecoration(border: InputBorder.none,hintText: "解答表示までの秒数(2秒)"),onChanged: (String value) {setState(() {count = int.parse(value);});},),),
              // Container(margin:EdgeInsets.only(top:10,bottom: 10),height:30,child:Row(mainAxisAlignment: MainAxisAlignment.center,children: [
              //   Container(child: Text("非公開にする",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,),),
              //   Switch(value: isOn, onChanged: (bool? value) {if (value != null) {setState(() {isOn = value;});}},),
              // ],)),
             Container(child: item.length == 0 ?
             Container(width: double.infinity,margin:EdgeInsets.only(top:100,left:15,right:15),child:Text("最低5つ問題を作りましょう\n↓",style: TextStyle(color: Colors.blueGrey[500],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),):
                 Container( margin: EdgeInsets.all(30),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(), itemCount: item.length, itemBuilder: (context, index) {
                return GestureDetector(onTap: () {co = index;Q = item[index]["問題"];A = item[index]["答え"];_bodyController3.text = Q;_bodyController4.text = A;delete();},
                    child: Card(elevation:0,color:Colors.white,child: Container(decoration: BoxDecoration( border: Border.all(color: Colors.black),color: Colors.white, borderRadius: BorderRadius.circular(5),),margin: EdgeInsets.all(0),
                        child:Column(children: [
                          Container(margin: EdgeInsets.only(top:5,right: 5),alignment: Alignment.centerRight,child:Icon(Icons.edit_rounded,color: Colors.blueGrey,size: 15,)),
                          Row(children: [
                            Container(alignment: Alignment.centerLeft,margin:EdgeInsets.only(top:15,left:15,right:15),child:Text("問題",style: TextStyle(color: Colors.blueGrey[500],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                            Expanded(child: Container(alignment: Alignment.centerLeft,margin:EdgeInsets.only(top:10),child:Text(item[index]["問題"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900]),),)),],),
                          Divider(color: Colors.blueGrey,thickness: 1,indent: 20,endIndent: 20,),
                          Container(alignment: Alignment.centerLeft,margin:EdgeInsets.only(bottom: 20),child:Row(children: [Container(alignment: Alignment.centerLeft,margin:EdgeInsets.only(left:15,right:15),child:Text("答え",style: TextStyle(color: Colors.blueGrey[500],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                            Expanded(child: Text(item[index]["答え"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900]),),),]))
                        ]))));},),))
              ],),),));
  }


  Future<void> send() async {
    var QID = randomString(20);
    if (name != "" )
     //   && category != "カテゴリー"  &&  grade != "レベル" && item.length >4 )
    {
      //UID
      Umap = {"UID":widget.ID,"QID":QID,"name":name,"カテゴリー":category,"秒数":count,"公開":isOn,"レベル":grade};
      DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(widget.ID);
      ref.update({"問題集2": FieldValue.arrayUnion([Umap]),});
      //QID
      DocumentReference ref2 = FirebaseFirestore.instance.collection('users').doc(widget.ID).collection("問題集").doc(QID);
      ref2.set({"問題" : item,"ID":QID});
      //公開
      // if(isOn == false){
      //   DocumentReference ref3 = FirebaseFirestore.instance.collection('問題集').doc("問題集");
      //   ref3.update({"問題集": FieldValue.arrayUnion([Umap]),});;
      // }
     Navigator.pop(context);
    }
    if(name == ""){showDialog(context: context, builder: (context) => AlertDialog(content: Container(child:Text("タイトルが入力されていません",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,)),),);};
    // if(category == "カテゴリー"){showDialog(context: context, builder: (context) => AlertDialog(content: Container(child:Text("カテゴリーが選択されていません",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,)),),);};
    // if(grade == "レベル"){showDialog(context: context, builder: (context) => AlertDialog(content: Container(child:Text("大体のレベルを選択してください",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,)),),);};
     if(item.length < 5){showDialog(context: context, builder: (context) => AlertDialog(content: Container(child:Text("最低5つ問題を作りましょう",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,)),),);};
     }

  Future<void> add() async {
    if ( Q != "" && A != ""){
      Qmap = {"問題":Q,"答え":A};item.add(Qmap);
      setState(() {Q= "";A= "";_bodyController3.clear();_bodyController4.clear();});
    }}

  Future<void> delete() async {
    showDialog(context: context, builder: (context) => WillPopScope(
        child:  AlertDialog(
          content: Container(child:
          SingleChildScrollView(child:Column(children: [
            Container(width: double.infinity,child:Text("編集",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
            Divider(color: Colors.blueGrey,thickness: 3,indent: 170,endIndent: 170,),
            Container(alignment: Alignment.center,margin:EdgeInsets.only(),child:Text("問題",style: TextStyle(color: Colors.blueGrey[900],fontSize: 15), textAlign: TextAlign.center),),
            Container(width: double.infinity,margin:EdgeInsets.all(5), decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5),),
              child: TextField(keyboardType: TextInputType.multiline, maxLines: null,controller: _bodyController3,decoration: InputDecoration(border: InputBorder.none, hintText: Q,),onChanged: (String value) {setState(() {Q = value;});},),),
            Container(alignment: Alignment.center,margin:EdgeInsets.only(),child:Text("答え",style: TextStyle(color: Colors.blueGrey[900],fontSize: 15), textAlign: TextAlign.center),),
            Container(width: double.infinity,margin:EdgeInsets.all(5), decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5),),
              child: TextField(keyboardType: TextInputType.multiline, maxLines: null,controller: _bodyController4,decoration: InputDecoration(border: InputBorder.none, hintText: A,),onChanged: (String value) {setState(() {A = value;});},),),
            Container(margin :EdgeInsets.all(10),width:100,child: ElevatedButton(child: Text('変更'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, shape: const StadiumBorder(),),
              onPressed: () {DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(widget.ID).collection("問題集").doc(widget.ID);
              setState(() {mapE = {"問題":Q,"答え":A};item[co] = mapE;Q= "";A= "";_bodyController3.clear();_bodyController4.clear();}); Navigator.pop(context);},)),

            Divider(color: Colors.blueGrey,thickness: 1,),
            Container(margin:EdgeInsets.all(15),width: double.infinity,child:Text("削除しますか?",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
            Row(mainAxisAlignment: MainAxisAlignment.center,children: [
              Container(margin :EdgeInsets.only(),width:100,child: ElevatedButton(child: Text('はい'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: const StadiumBorder(),),
                onPressed: () {DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(widget.ID).collection("問題集").doc(widget.ID);
                setState(() {item.removeAt(co);}); ref.update({"問題" : item,});Navigator.pop(context);},)),
            ],)
          ],)),),
        ),onWillPop: () async {setState(() {Q= "";A= "";_bodyController3.clear();_bodyController4.clear();});return true;
    }),);
  }


  void AddView() {
    showModalBottomSheet(isScrollControlled: true,context: context,backgroundColor: Colors.white,
      shape:   RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) { return StatefulBuilder(builder: (context, StateSetter setState) {
            return  Container(height:  350 +MediaQuery.of(context).viewInsets.bottom,decoration: BoxDecoration(color: Colors.white,  borderRadius: BorderRadius.vertical(top: Radius.circular(0.0),), boxShadow: [new BoxShadow(color: Colors.grey, offset: new Offset(1.0, 1.0), blurRadius: 3.0, spreadRadius: 1)],),
              //decoration: BoxDecoration( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
              child:DefaultTabController(length: _tab.length, child: Scaffold(backgroundColor:Colors.white,appBar: AppBar(backgroundColor:Colors.white,elevation: 0,//iconTheme: IconThemeData(),
                   title:  TabBar(tabs: _tab),actions: [TextButton(onPressed: (){}, child: Text(""))],),
                  body: TabBarView(
                      children: <Widget> [
                  GestureDetector(behavior: HitTestBehavior.opaque,
                      onTap: () => FocusScope.of(context).unfocus(), child:SingleChildScrollView(child:Column(children: <Widget>[Container(height: 20,),
                                Container(alignment: Alignment.center,margin:EdgeInsets.only(),child:Text("問題",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                              Container(width: double.infinity,margin:EdgeInsets.only(top:10,bottom: 10,left: 20,right: 20), decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5),),
                                child: TextField(style: TextStyle(color: Colors.black,),keyboardType: TextInputType.multiline, maxLines: null,controller: _bodyController3,decoration: InputDecoration(border: InputBorder.none,),onChanged: (String value) {setState(() {Q = value;});},),),
                              Container(alignment: Alignment.center,margin:EdgeInsets.only(),child:Text("答え",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                              Container(width: double.infinity,margin:EdgeInsets.only(top:10,bottom: 10,left: 20,right: 20),
                                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5),),
                                child: TextField(style: TextStyle(color: Colors.black,),keyboardType: TextInputType.multiline, maxLines: null,controller: _bodyController4,decoration: InputDecoration(border: InputBorder.none,),onChanged: (String value) {setState(() {A = value;});},),),
                               Container(margin : EdgeInsets.only(top:10,bottom: 30,left: 20,right: 20),child: ElevatedButton(child: Text("追加"), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, shape: const StadiumBorder(),),
                                  onPressed: () async {add();FocusScope.of(context).requestFocus(new FocusNode());Navigator.pop(context);})),

                                   ],))),
                        GestureDetector(behavior: HitTestBehavior.opaque,
                      onTap: () => FocusScope.of(context).unfocus(), child:SingleChildScrollView(child:Column(children: [
                          Container(alignment: Alignment.center,margin:EdgeInsets.only(top:20),child:Text("『 , 』で区切った文章を一括で追加",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center),),
                          Container(alignment: Alignment.center,margin:EdgeInsets.only(),child:Text("例：りんご,apple,みかん,orange,ぶどう,grapes",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center),),
                        Container(alignment: Alignment.center,margin:EdgeInsets.only(),child:Text("注意：カンマは半角。文章のカンマは全角で。問→答の順で数が合うように。",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center),),
                          Container(width: double.infinity,margin:EdgeInsets.only(top:50,bottom: 10,left: 20,right: 20), decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5),),
                          child: TextField(style: TextStyle(color: Colors.black,),keyboardType: TextInputType.multiline, maxLines: null,controller: _bodyController5,decoration: InputDecoration(border: InputBorder.none,),onChanged: (String value) {setState(() {text = value;});},),),
                        Container(margin : EdgeInsets.only(top:10,bottom: 30,left: 20,right: 20),child: ElevatedButton(child: Text("追加"), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, shape: const StadiumBorder(),),
                            onPressed: () async {main();}))],),)),

                       Container(child:Column(children: [
                         Container(alignment: Alignment.center,margin:EdgeInsets.only(top:20),child:Text("ExcelやNumbersでリストを一括で追加",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center),),
                         Container(alignment: Alignment.center,margin:EdgeInsets.only(top:0),child:Text("csvに変換してファイルに保存",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center),),
                         Container(child: TextButton(onPressed: () {
                           showDialog(context: context, builder: (context) => AlertDialog(content: Container(child:Image.asset("images/例.jpg")),),);
                           }, child: Text("例"),),),
                         Container(margin : EdgeInsets.only(top:10,bottom: 30,left: 20,right: 20),child: ElevatedButton(child: Text("ファイルを開く"), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, shape: const StadiumBorder(),),
                            onPressed: () async {_pickAndLoadCsv();})),
                       ]))
                      ]),)));});}, );}

  Future<void> _pickAndLoadCsv() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom, allowedExtensions: ['csv'],);
    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      String content = await file.readAsString();_parseCsv(content);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ファイルの選択がキャンセルされました。')),);}}
  void _parseCsv(String content) {
    List<String> lines = content.split('\n');
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim();
      if (line.isEmpty) continue; // 空行をスキップ
      List<String> parts = line.split(',');
      if (parts.length < 2) continue; // 不完全な行をスキップ
      try {item.add({"問題":parts[0].trim(),"答え":parts[1].trim()});
      } catch (e) {continue;}}
    setState(() {Navigator.pop(context);});
  }

  void main() {
    final list2 = stringToList(text);["1","2","3","4"];
    print('String（カンマ区切り）→List<int>');//a,aa,b,bb,c,cc,d,dd,aa
    print(list2.runtimeType);
    print(list2);
    for (int i = 0; i < list2.length ; i = i +2) {
      setState(() {item.add({"問題":list2[i],"答え":list2[i + 1]});});
        print(i);
    }_bodyController5.clear();text = "";Navigator.pop(context);
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


