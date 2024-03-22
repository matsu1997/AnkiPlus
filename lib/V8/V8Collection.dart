
import 'package:anki/%E3%81%9D%E3%81%AE%E4%BB%96/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Create/CreateV1.dart';
import '../V2/V2.dart';
import '../アカウント/SignUp.dart';

class V8Collection extends StatefulWidget {

  @override
  State<V8Collection> createState() => _V8CollectionState();
}

class _V8CollectionState extends State<V8Collection> {
  var item = []; //Icons.history
  var ID = "";

  void initState() {
  super.initState();loadData ();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        title:  Text("コレクション", style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center,),
        centerTitle: true,elevation: 0, iconTheme: IconThemeData(color: Colors.black), ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
            Container(margin: EdgeInsets.only(top: 0, bottom: 30),
                child: GridView.count(padding: EdgeInsets.all(20.0),
                    crossAxisCount: 3, crossAxisSpacing: 20.0, mainAxisSpacing: 20.0, childAspectRatio: 1, shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                    children: List.generate(item.length, (index) {
                      return GestureDetector(
                          onTap: () {show(index);},
                          child: Container(alignment: Alignment.center, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [new BoxShadow(color: Colors.grey, offset: new Offset(1.0, 1.0), blurRadius: 3.0, spreadRadius: 1)],),
                            child: Column(children: <Widget>[
                                Container( child: Image.asset(item[index])),

                          ]),));}))),
            Container(height: 50,color: Colors.white,)
          ],),),);
  }

  void loadData () async {item = [];
  SharedPreferences prefs = await SharedPreferences.getInstance();ID =  prefs.getString("ID")!;
  FirebaseFirestore.instance.collection('users').where("ID",isEqualTo: ID).get().then((QuerySnapshot snapshot) {
    snapshot.docs.forEach((doc) {item = doc["V8Collection"];setState(() {});});});}

  void show (index){
    showDialog(context: context, builder: (context) => AlertDialog(
      title:  Container(margin :EdgeInsets.only(top: 0,left: 0),width:300,height:300,child: Image.asset(item[index])),));
  }
  }