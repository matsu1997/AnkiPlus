
import 'package:anki/%E3%81%9D%E3%81%AE%E4%BB%96/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class V5Range extends StatefulWidget {

  @override
  State<V5Range> createState() => _V5RangeState();
}

class _V5RangeState extends State<V5Range> {
  var CountTime = 0.0;
  var co = 0;
  //
  var A = 0.0; var B = 0.0; var C = 0.0; var D = 0.0; var E = 0.0;var F = 0.0;var G = 0.0;
  var itemA = ["0","0"]; var itemB = ["0"];var itemC = ["0"];var itemD = ["0","0","0","0"];var itemE = ["0","0","0","0"];var itemF = ["0"];var itemG = ["0","0","0","0"];
  var isOnA1 = false; var isOnA2 = false;
  var isOnB1 = false;
  var isOnC1 = false;
  var isOnD1 = false; var isOnD2 = false; var isOnD3 = false; var isOnD4 = false;
  var isOnE1 = false; var isOnE2 = false; var isOnE3 = false; var isOnE4 = false;
  var isOnF1 = false;
  var isOnG1 = false;var isOnG2 = false;var isOnG3 = false;var isOnG4 = false;
  //
  late TextEditingController _bodyController;

  void initState() {
    super.initState(); _bodyController = TextEditingController();
    Future.delayed(Duration(seconds: 1), () {setState(() {first();});});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white,
          title: Text("",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blue),),
          iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(backgroundColor: Colors.black, child: Text("登録"),
          onPressed: () {set ();},),
      body:  SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(margin:EdgeInsets.only(top:20),child: Text("英単語",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20),textAlign: TextAlign.center,),),
          Divider(color: Colors.blueGrey,thickness: 3,indent: 170,endIndent: 170,),
          TextButton(child: RichText(text: TextSpan(style: Theme.of(context).textTheme.bodyMedium,
              children:  [
                TextSpan(text: A.toString(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.orange)),
                TextSpan(text: " 秒後に答えを表示", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
              ]),), onPressed: () {co = 1;Edite();},),
         Row(mainAxisAlignment: MainAxisAlignment.center,children: [
           Container(child: Text("中学英単語",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,),),
           Switch(value: isOnA1, onChanged: (bool? value) {if (value != null) {setState(() {isOnA1 = value!;if(isOnA1 == true){itemA[0] = "1";}else{itemA[0] = "0";}});}},),
         ],),
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Container(child: Text("高校英単語",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,),),
            Switch(value: isOnA2, onChanged: (bool? value) {if (value != null) {setState(() {isOnA2 = value;if(isOnA2 == true){itemA[1] = "1";}else{itemA[1] = "0";}});}},),
          ],),
          Container(margin:EdgeInsets.only(top:50),child: Text("漢字",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20),textAlign: TextAlign.center,),),
          Divider(color: Colors.blueGrey,thickness: 3,indent: 180,endIndent: 180,),
          TextButton(child: RichText(text: TextSpan(style: Theme.of(context).textTheme.bodyMedium,
              children:  [
                TextSpan(text: B.toString(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.orange)),
                TextSpan(text: " 秒後に答えを表示", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
              ]),), onPressed: () {co = 2;Edite();},),
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Container(child: Text("中高漢字",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,),),
            Switch(value: isOnB1, onChanged: (bool? value) {if (value != null) {setState(() {isOnB1 = value;if(isOnB1 == true){itemB[0] = "1";}else{itemB[0] = "0";}});}},),
          ],),
          Container(margin:EdgeInsets.only(top:50),child: Text("古文",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20),textAlign: TextAlign.center,),),
          Divider(color: Colors.blueGrey,thickness: 3,indent: 180,endIndent: 180,),
          TextButton(child: RichText(text: TextSpan(style: Theme.of(context).textTheme.bodyMedium,
              children:  [
                TextSpan(text:C.toString(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.orange)),
                TextSpan(text: " 秒後に答えを表示", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
              ]),), onPressed: () {co = 3;Edite();},),
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Container(child: Text("古文単語",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,),),
            Switch(value: isOnC1, onChanged: (bool? value) {if (value != null) {setState(() {isOnC1 = value;if(isOnC1 == true){itemC[0] = "1";}else{itemC[0] = "0";}});}},),
          ],),

          Container(margin:EdgeInsets.only(top:50),child: Text("世界史",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20),textAlign: TextAlign.center,),),
          Divider(color: Colors.blueGrey,thickness: 3,indent: 170,endIndent: 170,),
          TextButton(child: RichText(text: TextSpan(style: Theme.of(context).textTheme.bodyMedium,
              children:  [
                TextSpan(text: D.toString(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.orange)),
                TextSpan(text: " 秒後に答えを表示", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
              ]),), onPressed: () {co = 4;Edite();},),
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Container(child: Text("先史・古代",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,),),
            Switch(value: isOnD1, onChanged: (bool? value) {if (value != null) {setState(() {isOnD1 = value;if(isOnD1 == true){itemD[0] = "1";}else{itemD[0] = "0";}});}},),
          ],),
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Container(child: Text("中世",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,),),
            Switch(value: isOnD2, onChanged: (bool? value) {if (value != null) {setState(() {isOnD2 = value;if(isOnD2== true){itemD[1] = "1";}else{itemD[1] = "0";}});}},),
          ],),
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Container(child: Text("近世",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,),),
            Switch(value: isOnD3, onChanged: (bool? value) {if (value != null) {setState(() {isOnD3 = value;if(isOnD3 == true){itemD[2] = "1";}else{itemD[2] = "0";}});}},),
          ],),

          Container(margin:EdgeInsets.only(top:50),child: Text("日本史",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20),textAlign: TextAlign.center,),),
          Divider(color: Colors.blueGrey,thickness: 3,indent: 170,endIndent: 170,),
          TextButton(child: RichText(text: TextSpan(style: Theme.of(context).textTheme.bodyMedium,
              children:  [
                TextSpan(text: E.toString(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.orange)),
                TextSpan(text: " 秒後に答えを表示", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
              ]),), onPressed: () {co = 5;Edite();},),
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Container(child: Text("原始~平安",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,),),
            Switch(value: isOnE1, onChanged: (bool? value) {if (value != null) {setState(() {isOnE1 = value;if(isOnE1 == true){itemE[0] = "1";}else{itemE[0] = "0";}});}},),
          ],),
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Container(child: Text("鎌倉〜安土桃山",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,),),
            Switch(value: isOnE2, onChanged: (bool? value) {if (value != null) {setState(() {isOnE2 = value;if(isOnE2 == true){itemE[1] = "1";}else{itemE[1] = "0";}});}},),
          ],),
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Container(child: Text("江戸・明治",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,),),
            Switch(value: isOnE3, onChanged: (bool? value) {if (value != null) {setState(() {isOnE3 = value;if(isOnE3 == true){itemE[2] = "1";}else{itemE[2] = "0";}});}},),
          ],),
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Container(child: Text("日清戦争~",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,),),
            Switch(value: isOnE4, onChanged: (bool? value) {if (value != null) {setState(() {isOnE4 = value;if(isOnE4 == true){itemE[3] = "1";}else{itemE[3] = "0";}});}},),
          ],),
          Container(margin:EdgeInsets.only(top:50),child: Text("漢文単語",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20),textAlign: TextAlign.center,),),
          Divider(color: Colors.blueGrey,thickness: 3,indent: 160,endIndent: 160,),
          TextButton(child: RichText(text: TextSpan(style: Theme.of(context).textTheme.bodyMedium,
              children:  [
                TextSpan(text:F.toString(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.orange)),
                TextSpan(text: " 秒後に答えを表示", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
              ]),), onPressed: () {co = 6;Edite();},),
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Container(child: Text("漢文単語",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,),),
            Switch(value: isOnF1, onChanged: (bool? value) {if (value != null) {setState(() {isOnF1 = value;if(isOnF1 == true){itemF[0] = "1";}else{itemF[0] = "0";}});}},),
          ],),
          Container(margin:EdgeInsets.only(top:50),child: Text("生物",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20),textAlign: TextAlign.center,),),
          Divider(color: Colors.blueGrey,thickness: 3,indent: 180,endIndent: 180,),
          TextButton(child: RichText(text: TextSpan(style: Theme.of(context).textTheme.bodyMedium,
              children:  [
                TextSpan(text:G.toString(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.orange)),
                TextSpan(text: " 秒後に答えを表示", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
              ]),), onPressed: () {co = 7;Edite();},),
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Container(child: Text("細胞",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,),),
            Switch(value: isOnG1, onChanged: (bool? value) {if (value != null) {setState(() {isOnG1 = value;if(isOnG1 == true){itemG[0] = "1";}else{itemG[0] = "0";}});}},),
          ],),
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Container(child: Text("植物と動物の生殖と発生",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,),),
            Switch(value: isOnG2, onChanged: (bool? value) {if (value != null) {setState(() {isOnG2 = value;if(isOnG2 == true){itemG[1] = "1";}else{itemG[1] = "0";}});}},),
          ],),
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Container(child: Text("植物の成長",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,),),
            Switch(value: isOnG3, onChanged: (bool? value) {if (value != null) {setState(() {isOnG3 = value;if(isOnG3 == true){itemG[2] = "1";}else{itemG[2] = "0";}});}},),
          ],),
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Container(child: Text("ヒトの身体",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,),),
            Switch(value: isOnG4, onChanged: (bool? value) {if (value != null) {setState(() {isOnG4 = value;if(isOnG4 == true){itemG[3] = "1";}else{itemG[3] = "0";}});}},),
          ],),

          Container(height: 50,)
         ],),));
  }

  Future<void> Edite() async {
    var name = "";
    switch (co) {
      case 1:name = "英単語"; break;
      case 2:name = "漢字"; break;
      case 3:name = "古文"; break;
      case 4:name = "世界史"; break;
      case 5:name = "日本史"; break;
      case 6:name = "漢文単語"; break;
      case 7:name = "生物"; break;
    }
    showDialog(context: context, builder: (context) =>  AlertDialog(title: Text('時間の変更',style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
      actions: <Widget>[
        Column(mainAxisAlignment: MainAxisAlignment.center,children: [
          Container(child:Text('長文問題以外はなるべく短い時間でお願いします\n(アプリのコンセプト『即答できなきゃ覚えてない』の範囲内)',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10,color: Colors.grey,), textAlign: TextAlign.center,),),
          Container(width: double.infinity,margin:EdgeInsets.all(5), decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5),),
            child: TextField( keyboardType: TextInputType.numberWithOptions(decimal: true), inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d+(\.\d*)?')),], maxLines: null,controller: _bodyController,decoration: InputDecoration(border: InputBorder.none, ),onChanged: (String value) {CountTime = double.parse(value);},),),
          Container(margin :EdgeInsets.all(10),child: ElevatedButton(child: Text(name + 'はこの時間'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, shape: const StadiumBorder(),),
            onPressed: () async {SharedPreferences prefs = await SharedPreferences.getInstance();prefs.setDouble("CountTime" + name,CountTime);
            switch (co) {
              case 1:A = CountTime; break;
              case 2:B = CountTime; break;
              case 3:C = CountTime; break;
              case 4:D = CountTime; break;
              case 5:E = CountTime; break;
              case 6:F = CountTime; break;
              case 7:G = CountTime; break;
            }setState(() {Navigator.pop(context);});
            },)),
        ],)],));
  }

  Future<void> first() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    A =  prefs.getDouble("CountTime" + "英単語")?? 1.5;
    B =  prefs.getDouble("CountTime" + "漢字")?? 1.5;
    C =  prefs.getDouble("CountTime" + "古文")?? 1.5;
    D =  prefs.getDouble("CountTime" + "世界史")?? 2.0;
    E =  prefs.getDouble("CountTime" + "日本史")?? 2.0;
    F =  prefs.getDouble("CountTime" + "漢文単語")?? 2.0;
    G =  prefs.getDouble("CountTime" + "生物")?? 2.0;

    itemA = prefs.getStringList("V5英単語") ??["1","1"] ;
    if(itemA[0] == "1"){isOnA1 = true;} if(itemA[1] == "1"){isOnA2 = true;}
    itemB = prefs.getStringList("V5漢字") ??["1"] ;
    if(itemB[0] == "1"){isOnB1 = true;}
    itemC = prefs.getStringList("V5古文") ??["1"] ;
    if(itemC[0] == "1"){isOnC1 = true;}
    itemD = prefs.getStringList("V5世界史") ??["1","1","1","1"] ;
    if(itemD[0] == "1"){isOnD1 = true;} if(itemD[1] == "1"){isOnD2 = true;} if(itemD[2] == "1"){isOnD3 = true;} if(itemD[3] == "1"){isOnD4 = true;}
    itemE = prefs.getStringList("V5日本史") ??["1","1","1","1"] ;
    if(itemE[0] == "1"){isOnE1 = true;} if(itemE[1] == "1"){isOnE2 = true;} if(itemE[2] == "1"){isOnE3 = true;} if(itemE[3] == "1"){isOnE4 = true;}
    itemF = prefs.getStringList("V5漢文単語") ??["1"] ;
    if(itemF[0] == "1"){isOnF1 = true;}
    itemG = prefs.getStringList("V5生物") ??["1","1","1","1"] ;
    if(itemG[0] == "1"){isOnG1 = true;} if(itemG[1] == "1"){isOnG2 = true;} if(itemG[2] == "1"){isOnG3 = true;} if(itemG[3] == "1"){isOnG4 = true;}
    setState(() async { });}


  Future<void> set () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("V5英単語", itemA);
    prefs.setStringList("V5漢字", itemB);
    prefs.setStringList("V5古文", itemC);
    prefs.setStringList("V5世界史", itemD);
    prefs.setStringList("V5日本史", itemE);
    prefs.setStringList("V5漢文単語", itemF);
    prefs.setStringList("V5生物", itemG);

  }


}