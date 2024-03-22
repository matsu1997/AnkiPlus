import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Star extends StatefulWidget {
  @override
  State<Star> createState() => _StarState();
}

class _StarState extends State<Star> {
  @override

  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor:  Colors.white,
          title: Text("",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blue),),elevation: 0,
          actions: <Widget>[IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.close,color: Colors.black87,))],
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
              Container(margin :EdgeInsets.only(top:10,bottom: 0,right: 20),width: 300,height: 300,
                child:Image(image: AssetImage("images/first.png"),),),
            Container(width:double.infinity,alignment:Alignment.center,child:Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
              Icon(Icons.star_border, color: Colors.orange, size: 50,),
              Container(margin :EdgeInsets.only(left: 10),child:Text("１発即答5問以下",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 22),textAlign: TextAlign.center,)),
            ],),),
              Container(width:double.infinity,alignment:Alignment.center,child:Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                Icon(Icons.star_half, color: Colors.orange, size: 50,),
                Container(margin :EdgeInsets.only(left: 10),child:Text("１発即答5",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 22),textAlign: TextAlign.center,)),
              ],),),
              Container(width:double.infinity,alignment:Alignment.center,child:Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                Icon(Icons.star, color: Colors.orange, size: 50,),
                Container(margin :EdgeInsets.only(left: 10),child:Text("全問1発",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 22),textAlign: TextAlign.center,)),
              ],),),


            ])));}


}