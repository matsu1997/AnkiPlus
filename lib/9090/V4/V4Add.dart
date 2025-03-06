import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class V4Add extends StatefulWidget {
  @override
  _V4AddState createState() => _V4AddState();
}

class _V4AddState extends State<V4Add>  with TickerProviderStateMixin , WidgetsBindingObserver {
  var text = "";var ID = "";
  var study = 0;var rest = 0;var co = 0;
  late AnimationController controller;
 var map = {};

  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(seconds: 300));controller.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor:Colors.white ,
      appBar: AppBar(backgroundColor: Colors.white,//Colors.blue[200],
          title: Text("",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black),),
          iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
          actions: <Widget>[],
          leading: IconButton(icon:  Icon(Icons.arrow_back_ios,color: Colors.blueGrey,), onPressed: () {Navigator.pop(context);},)
      ),
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
                Container(margin:EdgeInsets.only(top:100),child: Text("勉強時間",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20),textAlign: TextAlign.center,),),
                Divider(color: Colors.blueGrey,thickness: 3,indent: 150,endIndent: 150,),
                TextButton(child: Text('${(study / (60 * 60)).floor()}:${((study % (60 * 60) / 60).floor()).toString().padLeft(2, '0')}:${(study % (60 * 60) % 60).toString().padLeft(2, '0')}', style: TextStyle(decoration: TextDecoration.underline,fontWeight: FontWeight.bold,color:Colors.blue,fontSize: 30)), onPressed: () async {co = 0;show();},),
            Container(margin:EdgeInsets.only(top:40),child: Text("休憩時間",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20),textAlign: TextAlign.center,),),
            Divider(color: Colors.blueGrey,thickness: 3,indent: 150,endIndent: 150,),
            TextButton(child: Text('${(rest / (60 * 60)).floor()}:${((rest % (60 * 60) / 60).floor()).toString().padLeft(2, '0')}:${(rest % (60 * 60) % 60).toString().padLeft(2, '0')}', style: TextStyle(decoration: TextDecoration.underline,fontWeight: FontWeight.bold,color:Colors.blue,fontSize: 30)), onPressed: () async {co = 1;show();},),
              Container(margin :EdgeInsets.only(top:80),width:100,child: ElevatedButton(
                child: Text('登録'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, foregroundColor: Colors.white, shape: const StadiumBorder(),),
                onPressed: () {add();},)),
            Container(margin:EdgeInsets.only(top:20),child: Text(text,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20),textAlign: TextAlign.center,),),
          ],),),);}

  Future<void> add () async {map = {"勉強":study,"休憩":rest,};
    SharedPreferences prefs = await SharedPreferences.getInstance();ID =  prefs.getString("ID")!;
    DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(ID);
    ref.update({"タイマー": FieldValue.arrayUnion([map])});setState(() {text = "登録しました!";});Future.delayed(Duration(seconds: 2)).then((_) {setState(() {text = "";});});
  }


  void show (){
    showModalBottomSheet(context: context, builder: (context) => Container(height: 200,
      child: CupertinoTimerPicker(initialTimerDuration: controller.duration!,
        onTimerDurationChanged: (time) {
          setState(() {controller.duration = time;
          if ( co == 0){study = controller.duration!.inSeconds;}else{rest = controller.duration!.inSeconds;}
          });},),),);}


}
