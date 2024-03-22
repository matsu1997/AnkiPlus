import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'V4V2.dart';

class V4Gacha extends StatefulWidget {
  V4Gacha(this.chie);
  List chie;
  @override
  State<V4Gacha> createState() => _V4GachaState();
}

class _V4GachaState extends State<V4Gacha> {
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white,//Colors.blue[200],
            title: Text("集めた雑学",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black),),
            iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
            actions: <Widget>[Container(alignment:Alignment.center,margin: EdgeInsets.all(10),child:Text(widget.chie.length.toString()+ "/130",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),],
            leading: IconButton(icon:  Icon(Icons.arrow_back_ios,color: Colors.blueGrey,), onPressed: () {Navigator.pop(context);},)
        ),
        body:Container(color: Colors.white,
            child: Column(
              children: <Widget>[
                Container(height: 20,),
                Expanded(child: ListView.builder(itemCount: widget.chie.length, itemBuilder: (context, index) {
                    return GestureDetector(onTap: () {},
                        child: Card(elevation:0,color:Colors.grey[200],child: Container(margin: EdgeInsets.all(15),color: Colors.transparent,
                            child:Column(children: [
                              Container(margin:EdgeInsets.all(5),width:double.infinity,alignment:Alignment.center,child: Text(widget.chie[index],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900]),textAlign: TextAlign.center,),),
                            ]))));},),),
              ],),),);}
}