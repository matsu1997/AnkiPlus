
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

class Ankert extends StatefulWidget {
  @override
  State<Ankert> createState() => _AnkertState();
}

class _AnkertState extends State<Ankert> {
  var Q1A = 0;
  var Q1B = 0;
  var Q1C = 0;
  var Q1D = 0;
  var Q2A = 0;
  var Q2B = 0;
  var Q3A = 0;
  var Q3B = 0;
  var Q3C = 0;
  var Q3D = 0;
  var Q4A = 0;
  var Q4B = 0;
  var Q5A = 0;
  var Q5B = 0;
  var Q1Az = 0;
  var Q1Bz = 0;
  var Q1Cz = 0;
  var Q1Dz = 0;
  var Q2Az = 0;
  var Q2Bz = 0;
  var Q3Az = 0;
  var Q3Bz = 0;
  var Q3Cz = 0;
  var Q3Dz = 0;
  var Q4Az = 0;
  var Q4Bz = 0;
  var Q5Az = 0;
  var Q5Bz = 0;
  var count = 0;
  var All = 0;
  var text = "";
  var uid = "";
  var L1 = "";
  var L2 = "";
  var L3 = "";
  var L4 = "";
  var L5 = "";
  var  Q1 = true;
  var  Q2 = true;
  var  Q3 = true;
  var  Q4 = true;
  var  Q5 = true;
  var _controller = TextEditingController();
  void initState() {
    super.initState();
    inputData();
    _loadData();
    _requestReview();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("アンケート",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black),),
          centerTitle: true,),
        body:GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child:  SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(margin: EdgeInsets.only(top: 10,bottom: 10),
                  child: TextButton(child:  Text('リセット',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),), onPressed: () {Reset();},
                  ),),
                Container(margin:EdgeInsets.only(top:20),child:Column(children: [Container(margin:EdgeInsets.only(bottom: 10),child: Text("目指す資格は？:" + L1,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20),),),
                  Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                    Container(child: ElevatedButton(child: const Text('鍼灸'), onPressed: !Q1 ? null : () {Q1 = false; Q1Az = 1;setState(() { L1 = "鍼灸";co();});},),),
                    Container(child: ElevatedButton(child: const Text('柔整'), onPressed:!Q1 ? null : () {Q1 = false; Q1Bz = 1;setState(() {L1 = "柔整";co();});},),),
                    Container(child: ElevatedButton(child: const Text('両方'), onPressed: !Q1 ? null :() {Q1 = false; Q1Cz = 1;setState(() {L1 = "両方";co();});},),),
                    Container(child: ElevatedButton(child: const Text('その他'), onPressed: !Q1 ? null :() {Q1 = false; Q1Dz = 1;setState(() {L1 = "その他";co();});},),)],),],)),   Divider(color: Colors.grey, thickness: 3, height: 10, indent: 20, endIndent: 20,),
                Container(margin:EdgeInsets.only(top:20),child: Column(children: [Container(margin:EdgeInsets.only(bottom: 10),child: Text("ATは受講してますか？:"+ L2,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20),),),
                  Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                    Container(child: ElevatedButton(child: const Text('はい'), onPressed:!Q2 ? null : () {Q2 = false; Q2Az = 1;setState(() {L2 = "はい";co();});},),),
                    Container(child: ElevatedButton(child: const Text('いいえ'), onPressed:!Q2 ? null : () {Q2 = false; Q2Bz = 1;setState(() {L2 = "いいえ";co();});},),)],),],)), Divider(color: Colors.grey, thickness: 3, height: 10, indent: 20, endIndent: 20,),
                Container(margin:EdgeInsets.only(top:20),child:Column(children: [Container(margin:EdgeInsets.only(bottom: 10),child: Text("現在の学年は？:"+ L3,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20),),),
                  Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                    Container(child: ElevatedButton(child: const Text('1年'), onPressed:!Q3 ? null : () {Q3 = false; Q3Az = 1;setState(() {L3 = "1年";co();});},),),
                    Container(child: ElevatedButton(child: const Text('2年'), onPressed: !Q3 ? null : () {Q3 = false; Q3Bz = 1;setState(() {L3 = "2年";co();});},),),
                    Container(child: ElevatedButton(child: const Text('3年'), onPressed:!Q3 ? null :  () {Q3 = false; Q3Cz = 1;setState(() {L3 = "3年";co();});},),),
                    Container(child: ElevatedButton(child: const Text('その他'), onPressed:!Q3 ? null :  () {Q3 = false; Q3Dz = 1;setState(() {L3 = "その他";co();});},),)
                  ],),],)), Divider(color: Colors.grey, thickness: 3, height: 10, indent: 20, endIndent: 20,),
                Container(margin:EdgeInsets.only(top:20),child:Column(children: [Container(margin:EdgeInsets.only(bottom: 10),child: Text("お使いのデバイスは？:"+ L4,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20),),),
                  Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                    Container(child: ElevatedButton(child: const Text('スマホ'), onPressed:!Q4 ? null :  () {Q4 = false; Q4Az = 1;setState(() {L4 = "スマホ";co();});},),),
                    Container(child: ElevatedButton(child: const Text('タブレット'), onPressed:!Q4 ? null : () {Q4 = false; Q4Bz = 1;setState(() {L4 = "タブレット";co();});},),),
                  ],),],)), Divider(color: Colors.grey, thickness: 3, height: 10, indent: 20, endIndent: 20,),
                Container(margin:EdgeInsets.only(top:20),child:Column(children: [Container(margin:EdgeInsets.only(bottom: 10),child: Text("お使いの機種は？:"+ L5,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20),),),
                  Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                    Container(child: ElevatedButton(child: const Text('iOS'), onPressed:!Q5 ? null :  () {Q5 = false; Q5Az = 1;setState(() {L5 = "iOS";co();});},),),
                    Container(child: ElevatedButton(child: const Text('Android'), onPressed:!Q5 ? null :  () {Q5 = false; Q5Bz = 1;setState(() {L5 = "Android";co();});},),),
                  ],),],)), Divider(color: Colors.grey, thickness: 3, height: 10, indent: 20, endIndent: 20,),
                Container(margin:EdgeInsets.all(20),child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  TextFormField(controller: _controller, decoration: InputDecoration(labelText: 'ご要望がありましたら教えてください!'), onChanged: (String value) {setState(() {text = value;});},)])),
                Container(margin: EdgeInsets.only(top:50),child:Text("ご協力ありがとうございました!\n   国試合格を心よりお祈りいたします。",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black),textAlign: TextAlign.center,),),
                Container(margin: EdgeInsets.only(top: 20,bottom: 20),
                  child: ElevatedButton(child: const Text('送信'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow[800], foregroundColor: Colors.white, shape: const StadiumBorder(),),
                    onPressed: () {Add();},
                  ),)
              ],),),));}
  Future<void> Add() async {
    if (text != "") {
      FirebaseFirestore.instance.collection('アンケート').doc(uid).set({
        "text": text,"co":"1"});_controller.clear();}
    if (count >= 5){
      FirebaseFirestore.instance.collection('アンケート').doc("0").update({
        "鍼灸":Q1A+Q1Az,"柔整":Q1B+Q1Bz,"両方":Q1C+Q1Cz,"その他":Q1D+Q1Dz,
        "ATはい":Q2A+Q2Az,"ATいいえ":Q2B+Q2Bz,
        "1年":Q3A+Q3Az,"2年":Q3B+Q3Bz,"3年":Q3C+Q3Cz,"その他学年":Q3D+Q3Dz,
        "スマホ":Q4A+Q4Az,"タブレット":Q4B+Q4Bz,
        "IOS":Q5A+Q5Az,"Android":Q5B+Q5Bz,
        "All":All + 1,
      });Navigator.of(context).pop();}
  }

  Future<String> inputData() async {
    final  user = await FirebaseAuth.instance.currentUser!;
    String id = user.uid.toString();
    uid = id;return id;}

  void _loadData()  {
    FirebaseFirestore.instance.collection('アンケート').where("co" ,isEqualTo: "0").get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        setState(() {
          Q1A = doc["鍼灸"];Q1B = doc["柔整"]; Q1C = doc["両方"];Q1D = doc["その他"];Q2A = doc["ATはい"];Q2B = doc["ATいいえ"];Q3A = doc["1年"];Q3B = doc["2年"];
          Q3C = doc["3年"];Q3D =doc["その他学年"];Q4A = doc["スマホ"];Q4B = doc["タブレット"];Q5A = doc["IOS"];Q5B = doc["Android"];All = doc["All"];
          ;});});});
    setState(() {});}
  Future<void> _requestReview() async {
    final InAppReview inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }
  void co (){count = count + 1;}
  void Reset(){count = 0;
  Q1Az = 0;Q1Bz = 0;Q1Cz = 0;Q1Dz = 0;Q2Az = 0;Q2Bz = 0;Q3Az = 0;Q3Bz = 0;Q3Cz = 0;Q3Dz = 0;Q4Az = 0;Q4Bz = 0;Q5Az = 0;Q5Bz = 0;
  L1 = "";L2 = "";L3 = "";L4 = "";L5 = "";
  Q1 = true;Q2 = true;Q3 = true;Q4 = true;Q5 = true; setState(() {});
  }
}