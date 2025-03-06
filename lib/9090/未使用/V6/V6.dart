import 'dart:ui';

import 'package:flutter/material.dart';
import 'V6V2A.dart';



class V6 extends StatefulWidget {
  @override

  State<V6> createState() => _V6State();
}

class _V6State extends State<V6> {
 var co = 1;
  @override
  void initState() {
    super.initState();
   }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black,
      body: SingleChildScrollView(
         child: co == 0 ?Column(children: [
           Container(alignment: Alignment.center,width: double.infinity,margin:EdgeInsets.only(top:200,left: 10,right: 10,bottom: 20),child:Text("学習を効率的にする\nプログラム", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 35,),textAlign: TextAlign.center,)),
           Divider(color: Colors.blueGrey,thickness: 3,indent: 70,endIndent: 70,),
           Container(alignment: Alignment.center,width: double.infinity,margin:EdgeInsets.only(top:50,left: 60,right: 60),child:Text("記憶力・モチベーションを上げ、学習を習慣化する事を目標に1ヶ月のプログラムを作りました。終了時には、無理なく効率的な学習を手に入れる事でしょう。\nたぶん。", style: TextStyle(color: Colors.white,  fontSize: 15,),textAlign: TextAlign.center,)),
           Container(margin :EdgeInsets.only(top:60),width:100,child: ElevatedButton(child: Text('始める'), style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey[800], foregroundColor: Colors.white, shape: const StadiumBorder(),),
             onPressed: () {},)),
         ],):
      Center(child:  Column(mainAxisSize: MainAxisSize.min,children: [
               GestureDetector(onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V6V2A()));},
                   child: Container(margin: EdgeInsets.only(top:100,left: 20,right: 10),child: Stack(children: <Widget>[
                   Container(height:150,margin: EdgeInsets.all(10),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),  border: Border.all(color: Colors.white),),
                   child: ClipRRect(borderRadius: BorderRadius.circular(8.0), child: Image.asset("images/study.png", fit: BoxFit.cover,)),),
                   ]),) ),
          Container(margin: EdgeInsets.only(top:5),child:Icon(Icons.arrow_drop_down,color: Colors.white,size: 30,)),
           GestureDetector(onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V6V2A()));},
               child: Container(margin: EdgeInsets.only(top:5,left: 20,right: 10),child: Stack(children: <Widget>[
                 Container(height:150,margin: EdgeInsets.all(10),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),  border: Border.all(color: Colors.white),),
                   child: ClipRRect(borderRadius: BorderRadius.circular(8.0), child: Image.asset("images/study.png", fit: BoxFit.cover,)),),
               ]),) ),
           Container(margin: EdgeInsets.only(top:5),child:Icon(Icons.arrow_drop_down,color: Colors.white,size: 30,)),
           GestureDetector(onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V6V2A()));},
               child: Container(margin: EdgeInsets.only(top:5,left: 20,right: 10),child: Stack(children: <Widget>[
                 Container(height:150,margin: EdgeInsets.all(10),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),  border: Border.all(color: Colors.white),),
                   child: ClipRRect(borderRadius: BorderRadius.circular(8.0), child: Image.asset("images/study.png", fit: BoxFit.cover,)),),
               ]),) ),
           Container(margin: EdgeInsets.only(top:5),child:Icon(Icons.arrow_drop_down,color: Colors.white,size: 30,)),
           GestureDetector(onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V6V2A()));},
               child: Container(margin: EdgeInsets.only(top:5,left: 20,right: 10,bottom: 100),child: Stack(children: <Widget>[
                 Container(height:150,margin: EdgeInsets.all(10),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),  border: Border.all(color: Colors.white),),
                   child: ClipRRect(borderRadius: BorderRadius.circular(8.0), child: Image.asset("images/study.png", fit: BoxFit.cover,)),),
               ]),) ),
         ])
      ),));}
// ClipRect(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5,),),),

}