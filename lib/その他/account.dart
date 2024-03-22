import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../アカウント/SignUp.dart';


class Account extends StatefulWidget {
  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  var ID = "";var pass = "";
  @override
  void initState() {
    super.initState();
first();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor:  Colors.white,elevation: 0,
          title: Text("",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blue),),
          //  iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
          actions: <Widget>[IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.close,color: Colors.black87,))],
        ),
        body:SingleChildScrollView(child:Column(
            children:[
              // Row(  mainAxisAlignment: MainAxisAlignment.center,children: [
              //   Container(margin :EdgeInsets.only(top:50,right:5,),child:Text("ユーザー名:",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 15))),
              //   Container(margin :EdgeInsets.only(top:50,bottom: 0),child:SelectableText(ID.substring(2,8),style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 15))),
              // ]),
              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                Container(margin :EdgeInsets.only(top:30,right:5,),child:Text("ID:",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 15))),
                Container(margin :EdgeInsets.only(top:30,bottom: 0),child:SelectableText(ID,style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 15))),
              ]),
              Container(margin:EdgeInsets.only(top:40),color: Colors.white,width: double.infinity,alignment: Alignment.center,child:Text("再ログイン用パスワードを設定",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,)),
              Container(padding:EdgeInsets.all(20),color: Colors.white,width: double.infinity,alignment: Alignment.center,child:Text("パスワードが無い場合、再ログイン時のIDやパスワードの問い合わせを受け付ける事ができません",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 10),textAlign: TextAlign.center,)),
              Container(width: double.infinity, margin: EdgeInsets.only(top: 5, bottom: 5, left: 70, right: 70),
                            child: TextFormField(decoration: InputDecoration(labelText: 'password',),
                              onChanged: (String value) {setState(() {pass = value;});},),),
              Container(margin :EdgeInsets.only(top:20),width:100,child: ElevatedButton(
                child: Text('登録'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: const StadiumBorder(),),
                onPressed: () {Edite();},)),
          Container(margin :EdgeInsets.only(top:100),child:Text("アカウントを削除しますか？",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 15))),
        Container(margin :EdgeInsets.only(top:20),width:100,child: ElevatedButton(
                child: Text('はい'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, foregroundColor: Colors.white, shape: const StadiumBorder(),),
                onPressed: () {delete();},)),
            ])));}
  void first () async {
  SharedPreferences prefs = await SharedPreferences.getInstance();ID =  prefs.getString("ID")!;
  setState(() {});}

  void delete () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();prefs.setString("ID", "");
    setState(() {Navigator.pop(context);Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()),);});}

  void Edite (){
    DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(ID);
    ref.update({"pass": pass});Navigator.pop(context);
  }
}