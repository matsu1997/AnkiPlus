import 'dart:math';

//import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:anki/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'First.dart';
import 'FirstQ.dart';
import 'Login.dart';

void main() async {
  // 初期化処理を追加
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

/* --- 省略 --- */

// ログイン画面用Widget
class SignUp extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<SignUp> {
  var ID = "";
  var uid = "";
  var pass = "";
  var error = "";
  var bool = false;
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => initPlugin());
    ID = randomString(20);
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor:  Colors.white,elevation: 0,automaticallyImplyLeading: false,
          title: Text("",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blue),),
          //  iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
          //actions: <Widget>[IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.close,color: Colors.black87,))],
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
              Container(margin :EdgeInsets.only(top:10,bottom: 0,right: 10),width: 150,height: 150,
                child:Image(image: AssetImage("images/name.PNG"),),),
              Container(width: double.infinity,
                              child: ElevatedButton(child: Text("プライバシーポリシー"),
                                onPressed: () async {final url = "https://note.com/kintore19970107/n/n86fbb6c19b5f";
                                if (await canLaunch(url)) {await launch(url);}},
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Colors.black,),),),
                            Container(width: double.infinity,height: 30,
                              child: ElevatedButton(child: Text("利用規約"),
                                onPressed: () async {final url = "https://note.com/kintore19970107/n/nfb0e515adfe4";
                                if (await canLaunch(url)) {await launch(url);}},
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Colors.black,),),),
              Container(width: double.infinity,alignment:Alignment.center,child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                Container(margin :EdgeInsets.only(),child:Text("上記二つに同意",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15,),textAlign: TextAlign.center,)),
                Switch( value: bool, onChanged: (value){setState(() { bool = value;});})
              ],)),
              Container(margin: EdgeInsets.only(top: 50),width: 200, child: ElevatedButton(child:Text("始める"), style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.black, shape: const StadiumBorder(),),
                onPressed: () {add2();},),),
              // Container(margin :EdgeInsets.only(top: 20),width: double.infinity, child: ElevatedButton(child: Text("上記に同意して始める",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,), onPressed: () async {add2();},
              //   style: ElevatedButton.styleFrom(foregroundColor: Colors.orange, backgroundColor: Colors.white,elevation: 0, ),),),
            //  Container(margin :EdgeInsets.only(top: 10),child : Divider(color: Colors.grey,thickness: 1,indent: 130,endIndent: 130,),),
              Container(margin :EdgeInsets.all(0),width: double.infinity, child: ElevatedButton(child: Text("アカウントをお持ちの方",style: TextStyle(color: Colors.grey[700],fontSize: 13),textAlign: TextAlign.center,),
                onPressed: () async {Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()),);},
                style: ElevatedButton.styleFrom(foregroundColor: Colors.green, backgroundColor: Colors.white,elevation: 0, ),),),
            ]))));}

  String randomString(int length) {
    const _randomChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    const _charsLength = _randomChars.length;
    final rand = new Random();
    final codeUnits = new List.generate(
      length,
          (index) {
        final n = rand.nextInt(_charsLength);
        return _randomChars.codeUnitAt(n);
      },
    );
    return new String.fromCharCodes(codeUnits);
  }

  Future<void> add2() async {
    if (bool == true){
      FirebaseFirestore.instance.collection('users').doc(ID).set({"問題集2":[],
        "ID": ID, "pass": pass, "createdAt": Timestamp.now(),"有料": Timestamp.now(),"タイマー":[],"チェック":[],"ドリル":[],"知恵":[],});
      FirebaseFirestore.instance.collection('users').doc(ID).collection("ミス").doc("ミス").set({
        "ミス1": [], "ミス2": [],"ミス3": [],"All":[],
        "英単語": [],"漢字": [],"古文":[] ,"世界史":[] ,"日本史": [],"地理":[] ,"生物": [],"物理":[] ,"化学":[],
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("ID", ID);Navigator.pop(context);
     // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {return FirstQ();}),);
    }


  }

  Future<void> initPlugin() async {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await Future.delayed(const Duration(milliseconds: 200));
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }
}

