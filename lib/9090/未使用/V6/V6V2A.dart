import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class V6V2A extends StatefulWidget {
  @override

  State<V6V2A> createState() => _V6V2AState();
}

class _V6V2AState extends State<V6V2A> {
  var item = ["知識","朝習慣","夜習慣",]; //Icons.history
  var item1 = [ Icons.school,Icons.sunny_snowing,Icons.mode_night, ];


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blue),),
        iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
        //actions: <Widget>[IconButton(onPressed: () {}, icon: Icon(Icons.skip_next))],
      ),
        body: SingleChildScrollView(
          child:Column(children: [
            Container(width:double.infinity,margin:EdgeInsets.only(top:15,left: 20),child:Text("1週目の目標", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 25,),)),
            Container(width:double.infinity,margin:EdgeInsets.only(top:15,left: 30),child:Text("・知識①を使ってみる", style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,  fontSize: 15,),)),
            Container(width:double.infinity,margin:EdgeInsets.only(top:5,left: 30),child:Text("　　20個の知識を読む", style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,  fontSize: 10,),)),
            Container(width:double.infinity,margin:EdgeInsets.only(top:5,left: 30),child:Text("・朝の習慣(level:1)を手に入れる", style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,  fontSize: 15,),)),
            Container(width:double.infinity,margin:EdgeInsets.only(top:5,left: 30),child:Text("　　30分学習　5分運動　朝日を浴びる　", style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,  fontSize: 10,),)),
            Container(width:double.infinity,margin:EdgeInsets.only(top:5,left: 30),child:Text("・夜の習慣(level:1)を手に入れる", style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,  fontSize: 15,),)),
            Container(width:double.infinity,margin:EdgeInsets.only(top:5,left: 30),child:Text("　　30分学習　5分運動　朝日を浴びる　", style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,  fontSize: 10,),)),
            Container(width:double.infinity,margin:EdgeInsets.only(top:30,left: 20),child:Text("テーマ", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 25,),)),
            Container(width:double.infinity,margin:EdgeInsets.only(top:15,left: 30,),child:Text("一番最初が一番キツイ。現状維持バイアスを壊す", style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,  fontSize: 15,))),
            Container(width:double.infinity,margin:EdgeInsets.only(top:60,left: 20),child:Text("始める", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 25,),)),
            Container(margin: EdgeInsets.only(top: 0, ), child: GridView.count(padding: EdgeInsets.all(20.0), crossAxisCount: 3, crossAxisSpacing: 20.0, mainAxisSpacing: 20.0, childAspectRatio: 1, shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                    children: List.generate(item.length, (index) {return GestureDetector(onTap: () {
                      switch(index){
                        case 0: Navigator.of(context).push(MaterialPageRoute(builder: (context) => V6V2A1()));break;
                        case 1: Navigator.of(context).push(MaterialPageRoute(builder: (context) => V6V2A2()));break;
                        case 2:Navigator.of(context).push(MaterialPageRoute(builder: (context) => V6V2A3())); break;
                      }},
                          child: Container(alignment: Alignment.center, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [new BoxShadow(color: Colors.grey, offset: new Offset(1.0, 1.0), blurRadius: 3.0, spreadRadius: 1)],),
                            child: Column(children: <Widget>[Expanded(child: Icon(item1[index], color: Colors.green, size: 50,)), Container(margin: EdgeInsets.all(5),alignment: Alignment.center, child: Text(item[index], style: TextStyle(color: Colors.blueGrey[800], fontWeight: FontWeight.bold, fontSize: 15,),)),])));}))),
          //  Container(width:double.infinity,margin:EdgeInsets.only(top:30,left: 20),child:Text("ステージの仲間達の部屋", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 25,),)),


          ])));}
}

class V6V2A1 extends StatefulWidget {

  @override
  State<V6V2A1> createState() => _V6V2A1State();
}

class _V6V2A1State extends State<V6V2A1> {
  var item = ["aa","hhjjk"];
  var item1 = [0,0];
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,//Colors.blue[200],
          title: Icon(Icons.school, color: Colors.green, size: 40,),
          iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
          actions: <Widget>[],
          leading: IconButton(icon:  Icon(Icons.arrow_back_ios,color: Colors.blueGrey,), onPressed: () {Navigator.pop(context);},)
      ),
      body:Container(color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(height: 20,),
            Expanded(child: ListView.builder(itemCount:item.length, itemBuilder: (context, index) {
              return GestureDetector(onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V6V2A11(index,item[index])));},
                  child: Card(elevation:0,color:Colors.grey[200],child: Container(margin: EdgeInsets.all(15),color: Colors.transparent,
                      child:Row(children: [
                        Container(child: Text(index.toString(),style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,)),),
                        Expanded(child: Text(item[index],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900]),textAlign: TextAlign.center,),),
                        Container(child: item1[index] == 0 ?Icon(Icons.done,color: Colors.green,size: 30,):Container())
                      ]))));},),),


            // Expanded(child: ListView.builder(itemCount:item.length, itemBuilder: (context, index) {
            //   return GestureDetector(onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V6V2A11(index,item[index])));},
            //       child: Card(elevation:0,color:Colors.grey[200],child: Container(margin: EdgeInsets.all(15),color: Colors.transparent,
            //           child:Row(children: [
            //             Container(child: Text(index.toString(),style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,)),),
            //             Expanded(child: Text(item[index],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900]),textAlign: TextAlign.center,),),
            //             Container(child: item1[index] == 0 ?Icon(Icons.done,color: Colors.green,size: 30,):Container())
            //           ]))));},),),
          ],),),);}
}

class V6V2A11 extends StatefulWidget {
  V6V2A11(this.co,this.text);
  int co ; String text;
  @override
  State<V6V2A11> createState() => _V6V2A11State();
}

class _V6V2A11State extends State<V6V2A11> {

  var text2 = "";var image = "";

  void initState() {
    super.initState();
    set ();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,//Colors.blue[200],
          title: Text("",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black),),
          iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
          actions: <Widget>[],
          leading: IconButton(icon:  Icon(Icons.arrow_back_ios,color: Colors.blueGrey,), onPressed: () {Navigator.pop(context);},)
      ),
      body:SingleChildScrollView(
        child: Column(children: <Widget>[
            Container(height: 20,),
            Container(width: 350, height: 150, child: Image.asset("images/study.png")),
          Container(margin:EdgeInsets.only(top:15,bottom: 10),child:Text(widget.text, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 25,),)),
          Container(margin:EdgeInsets.only(top:15,bottom: 10),child:Text(text2, style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 15,),textAlign: TextAlign.center,))


        ],),),);}

  void set (){
    switch(widget.co){
      case 0:text2 = "";break;
    }}

  void done (){

  }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class V6V2A2 extends StatefulWidget {

  @override
  State<V6V2A2> createState() => _V6V2A2State();
}

class _V6V2A2State extends State<V6V2A2> {
  List<String> item = [];
  var text = "";
  var co = "";
  late Model model ;
  late List<Model> modelList;
  late TextEditingController _bodyController;

  void initState() {
    super.initState();_bodyController = TextEditingController();
    set ();
      modelList = [];for (int i = 0; i < item.length; i++) {Model model = Model(title: item[i], key: i.toString(),);modelList.add(model);}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,//Colors.blue[200],
          title: Icon(Icons.sunny_snowing, color: Colors.green, size: 40,),
          iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
          actions: <Widget>[],
          leading: IconButton(icon:  Icon(Icons.arrow_back_ios,color: Colors.blueGrey,), onPressed: () {Navigator.pop(context);},)
      ),
      body:GestureDetector( onTap: () => FocusScope.of(context).unfocus(),
       child:Container(color: Colors.white,
        child: Column(children: <Widget>[
            Container(margin: EdgeInsets.only(top:20,bottom: 20),width:double.infinity,child: Text("朝のルーティンを作成する",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900]),textAlign: TextAlign.center,),),
          Expanded(child: ReorderableListView(padding: EdgeInsets.all(10.0),
              onReorder: (oldIndex, newIndex) {if (oldIndex < newIndex) {newIndex -= 1;}
                 model = modelList.removeAt(oldIndex);  final item0 = item.removeAt(oldIndex);
                setState(() {modelList.insert(newIndex, model);item.insert(newIndex, item0);save ();});
              },
              children: modelList.map((Model model) {
                  return GestureDetector(key: Key(model.key), onTap: () {co = model.title ;Edite();},child: Card( key: Key(model.key),elevation:0,color:Colors.grey[200],child: Container(margin: EdgeInsets.all(15),color: Colors.transparent,
                        child:Row(children: [
                          Expanded(child: Text(model.title,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900]),textAlign: TextAlign.center,),),
                          Container(child:Icon(Icons.format_line_spacing_outlined,color: Colors.blueGrey[800],size: 30,))
                        ]))));},).toList(),),),
          Container(height: 68,decoration: BoxDecoration(color: Colors.white,  borderRadius: BorderRadius.vertical(top: Radius.circular(15.0),), boxShadow: [new BoxShadow(color: Colors.grey.shade400, offset: new Offset(1.0, 1.0), blurRadius: 3.0, spreadRadius: 1)],),
              child:Row(children: <Widget>[
                  Expanded(child: Container(margin: EdgeInsets.only(left: 10),padding: EdgeInsets.symmetric(horizontal: 16.0,), decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10),),
                      child: TextField(style: TextStyle(color: Colors.black,),keyboardType: TextInputType.multiline, maxLines: null,controller: _bodyController,decoration: InputDecoration(border: InputBorder.none,hintText: "追加ルーティン"),onChanged: (String value) {setState(() {text = value;});},),),
                  ),
                  IconButton( icon: Icon(Icons.send), iconSize: 28, color: Colors.orange,
                    onPressed: () {add ();FocusScope.of(context).requestFocus(new FocusNode());_bodyController.clear();},
                  ),],))
          ],),)),);}

  Future<void> set () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
      item = prefs.getStringList("朝ルーティン1") ?? ["日を浴びる", "水を飲む", "顔洗う", "5分運動", "朝ご飯", "歯を磨く", "身支度", "30分学習"];
      modelList = [];
      for (int i = 0; i < item.length; i++) {
        Model model = Model(title: item[i], key: i.toString(),);modelList.add(model);
      }});
}
  Future<void> save () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("朝ルーティン1", item);
  }
  Future<void> add () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {item.add(text);});prefs.setStringList("朝ルーティン1", item);set();
  }
  Future<void> Edite() async {
    if(co == "日を浴びる" || co == "" || co == ""  ){
      showDialog(context: context, builder: (context) => WillPopScope(
          child:  AlertDialog(content: Container(margin: EdgeInsets.all(10),child: Text("この項目は削除できません",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center), ),
          ),onWillPop: () async {setState(() {});return true;}),);
    }else{
      showDialog(context: context, builder: (context) => WillPopScope(
          child:  AlertDialog(content: Container(child:
          SingleChildScrollView(child:Column(children: [
            Container(margin: EdgeInsets.all(10),child: Text(co,style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center), ),
            Container(margin: EdgeInsets.only(top:0), child:IconButton(icon:Icon(Icons.delete_forever,color: Colors.black,size: 20,), onPressed: () { setState(() {item.remove(co);save();set();});Navigator.pop(context);  },)),],)),),
          ),onWillPop: () async {setState(() {});return true;}),);}}


}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class V6V2A3 extends StatefulWidget {

  @override
  State<V6V2A3> createState() => _V6V2A3State();
}

class _V6V2A3State extends State<V6V2A3> {
  List<String> item = [];
  var text = "";
  var co = "";
  late Model model ;
  late List<Model> modelList;
  late TextEditingController _bodyController;

  void initState() {
    super.initState();_bodyController = TextEditingController();
    set ();
    modelList = [];for (int i = 0; i < item.length; i++) {Model model = Model(title: item[i], key: i.toString(),);modelList.add(model);}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,//Colors.blue[200],
          title: Icon(Icons.mode_night_rounded, color: Colors.green, size: 40,),
          iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
          actions: <Widget>[],
          leading: IconButton(icon:  Icon(Icons.arrow_back_ios,color: Colors.blueGrey,), onPressed: () {Navigator.pop(context);},)
      ),
      body:GestureDetector( onTap: () => FocusScope.of(context).unfocus(),
          child:Container(color: Colors.white,
            child: Column(children: <Widget>[
              Container(margin: EdgeInsets.only(top:20,bottom: 20),width:double.infinity,child: Text("夜のルーティンを作成する",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900]),textAlign: TextAlign.center,),),
              Expanded(child: ReorderableListView(padding: EdgeInsets.all(10.0),
                onReorder: (oldIndex, newIndex) {if (oldIndex < newIndex) {newIndex -= 1;}
                model = modelList.removeAt(oldIndex);  final item0 = item.removeAt(oldIndex);
                setState(() {modelList.insert(newIndex, model);item.insert(newIndex, item0);save ();});
                },
                children: modelList.map((Model model) {
                  return GestureDetector(key: Key(model.key), onTap: () {co = model.title ;Edite();},child: Card( key: Key(model.key),elevation:0,color:Colors.grey[200],child: Container(margin: EdgeInsets.all(15),color: Colors.transparent,
                      child:Row(children: [
                        Expanded(child: Text(model.title,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900]),textAlign: TextAlign.center,),),
                        Container(child:Icon(Icons.format_line_spacing_outlined,color: Colors.blueGrey[800],size: 30,))
                      ]))));},).toList(),),),
              Container(height: 68,decoration: BoxDecoration(color: Colors.white,  borderRadius: BorderRadius.vertical(top: Radius.circular(15.0),), boxShadow: [new BoxShadow(color: Colors.grey.shade400, offset: new Offset(1.0, 1.0), blurRadius: 3.0, spreadRadius: 1)],),
                  child:Row(children: <Widget>[
                    Expanded(child: Container(margin: EdgeInsets.only(left: 10),padding: EdgeInsets.symmetric(horizontal: 16.0,), decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10),),
                      child: TextField(style: TextStyle(color: Colors.black,),keyboardType: TextInputType.multiline, maxLines: null,controller: _bodyController,decoration: InputDecoration(border: InputBorder.none,hintText: "追加ルーティン"),onChanged: (String value) {setState(() {text = value;});},),),
                    ),
                    IconButton( icon: Icon(Icons.send), iconSize: 28, color: Colors.orange,
                      onPressed: () {add ();FocusScope.of(context).requestFocus(new FocusNode());_bodyController.clear();},
                    ),],))
            ],),)),);}

  Future<void> set () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      item = prefs.getStringList("夜ルーティン1") ?? ["日を浴びる", "水を飲む", "顔洗う", "5分運動", "朝ご飯", "歯を磨く", "身支度", "30分学習"];
      modelList = [];
      for (int i = 0; i < item.length; i++) {
        Model model = Model(title: item[i], key: i.toString(),);modelList.add(model);
      }});
  }
  Future<void> save () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("夜ルーティン1", item);
  }
  Future<void> add () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {item.add(text);});prefs.setStringList("夜ルーティン1", item);set();
  }
  Future<void> Edite() async {
    if(co == "日を浴びる" || co == "" || co == ""  ){
      showDialog(context: context, builder: (context) => WillPopScope(
          child:  AlertDialog(content: Container(margin: EdgeInsets.all(10),child: Text("この項目は削除できません",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center), ),
          ),onWillPop: () async {setState(() {});return true;}),);
    }else{
      showDialog(context: context, builder: (context) => WillPopScope(
          child:  AlertDialog(content: Container(child:
          SingleChildScrollView(child:Column(children: [
            Container(margin: EdgeInsets.all(10),child: Text(co,style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center), ),
            Container(margin: EdgeInsets.only(top:0), child:IconButton(icon:Icon(Icons.delete_forever,color: Colors.black,size: 20,), onPressed: () { setState(() {item.remove(co);save();set();});Navigator.pop(context);  },)),],)),),
          ),onWillPop: () async {setState(() {});return true;}),);}}


}

class Model {
  final String title;final String key;
  Model({required this.title, required this.key,});
}