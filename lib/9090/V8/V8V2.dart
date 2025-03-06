


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class V8V2 extends StatefulWidget {

  @override
  State<V8V2> createState() => _V8V2State();
}

class _V8V2State extends State<V8V2> {



  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white,
          title:  Text("", style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center,),
          centerTitle: true,elevation: 0,
          leading:IconButton(onPressed: () {}, icon: Icon(Icons.person_3_outlined,color: Colors.black87,)),
          actions: <Widget>[IconButton(onPressed: () {}, icon: Icon(Icons.info_outline,color: Colors.black87,))],
        ),
        body:Container(child:Column(children: [


        ],)));
  }

}