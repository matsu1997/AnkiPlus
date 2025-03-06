import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'V4V2.dart';

class V4Dril extends StatefulWidget {
  V4Dril(this.doril,this.ID,this.item);
  List doril;String ID;List item;
  @override
  State<V4Dril> createState() => _V4DrilState();
}

class _V4DrilState extends State<V4Dril> {
  var map = {};var mapD = {};
  var date = "";var name = "";var dateC = "";var text = "";
  var co = 0;
  var page = 0;var av = 0.0;var count = 1;
  var now = DateTime.now();var dt = DateTime.now();var dt2= DateTime.now();
  TextEditingController dateInput = TextEditingController();
  TextEditingController dateInput2 = TextEditingController();
  DateFormat outputFormat = DateFormat('MM月dd日');
  DateFormat outputFormat2 = DateFormat('yyyy年MM月dd日');
  void initState() {
    super.initState();dateInput.text = "";dateInput2.text = "";dt = DateTime(now.year,now.month,now.day);
    date = outputFormat2.format(DateTime.now());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white,//Colors.blue[200],
          title: Text("教科書・ドリルが勝手に終わる計算",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 15),),
          iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
          actions: <Widget>[],
          leading: IconButton(icon:  Icon(Icons.arrow_back_ios,color: Colors.blueGrey,), onPressed: () {Navigator.pop(context);},),
        ),
        floatingActionButton: FloatingActionButton(backgroundColor: Colors.pink, child: const Icon(Icons.add),
          onPressed: () {start();},
        ),
        body: Container(color: Colors.white,
            child: Column(children: <Widget>[
                Container(height: 20,),
                Expanded(
                  child: ListView.builder(itemCount: widget.doril.length, itemBuilder: (context, index) {
                    return GestureDetector(onTap: () { if (outputFormat2.format(widget.doril[index]["終了"].toDate()) != date){text = "  P${widget.doril[index]["現在ページ"]+ 1}〜${(widget.doril[index]["現在ページ"] + (widget.doril[index]["page"] - widget.doril[index]["現在ページ"]) /(widget.doril[index]["終了"].toDate().difference(DateTime(now.year, now.month, now.day)).inDays)).ceil()}"; }else{text = "  P" + (widget.doril[index]["現在ページ"]+ 1).toString() + "〜" + widget.doril[index]["page"].toString();}co = index; start1();},
                        child: Card(elevation:0,color:Colors.grey[200],child: Container(margin: EdgeInsets.all(15),color: Colors.transparent,
                            child:Column(children: [
                              Row(children: [
                                Expanded(child: Text(widget.doril[index]["name"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 20),),),
                                Container(margin:EdgeInsets.only(right:5),alignment:Alignment.centerRight,child: Text("終了日: "+ outputFormat.format(widget.doril[index]["終了"].toDate()),style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),),),
                              ],),
                                //Expanded(child: Text("今日の範囲",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 10),),),
                              Container(child: widget.doril[index]["開始"] != date ?
                                        Container(child:outputFormat2.format(widget.doril[index]["終了"].toDate()) != date ?
                                        Container(margin:EdgeInsets.only(right:5),alignment:Alignment.centerRight,child: Text('今日の範囲  P${widget.doril[index]["現在ページ"]+ 1}〜${(widget.doril[index]["現在ページ"] + (widget.doril[index]["page"] - widget.doril[index]["現在ページ"]) /(widget.doril[index]["終了"].toDate().difference(DateTime(now.year, now.month, now.day)).inDays)).ceil()}',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),),)
                                        :Container(margin:EdgeInsets.only(right:5),alignment:Alignment.centerRight,child: Text("今日の範囲  P" + (widget.doril[index]["現在ページ"]+ 1).toString() + "〜" + widget.doril[index]["page"].toString(),style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),),)
                                        )
                                      : Container(child: Container(margin:EdgeInsets.only(right:5),alignment:Alignment.centerRight,child: Text("済み　"  + "〜 " + widget.doril[index]["現在ページ"].toString() + "P",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),))))
                                  ]))));},),),
              ],),),);}
  // send();FocusScope.of(context).requestFocus(new FocusNode());

  Future<void> send() async {
    if (name != ""){
      map = {"name":name,"page":page,"開始":"","終了":Timestamp.fromDate(dt2),"現在ページ":0};widget.doril.insert(0,map);
      DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(widget.ID);
      ref.update({"ドリル" : FieldValue.arrayUnion([map]),});setState(() {Navigator.pop(context);});
     name = "";page = 0;dateInput.text = "";dateInput2.text = "";count = 1 ;
    }}

  Future<void> done() async {
    widget.doril[co] = {"name":widget.doril[co]["name"],"page":widget.doril[co]["page"],"開始":date,
      "終了":widget.doril[co]["終了"],
      "現在ページ":(widget.doril[co]["現在ページ"] + (widget.doril[co]["page"] - widget.doril[co]["現在ページ"]) /(widget.doril[co]["終了"].toDate().difference(DateTime(now.year, now.month, now.day)).inDays)).ceil()};
    DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(widget.ID);
    ref.update({"ドリル" : widget.doril,});setState(() {});
    name = "";page = 0;dateInput.text = "";dateInput2.text = "";count = 1 ;
  }
  Future<void> Edite() async {
    widget.doril[co] = {"name":widget.doril[co]["name"],"page":widget.doril[co]["page"],"開始":widget.doril[co]["開始"], "終了":Timestamp.fromDate(dt2), "現在ページ":widget.doril[co]["現在ページ"]};
    DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(widget.ID);
    ref.update({"ドリル" : widget.doril,});setState(() {});
    name = "";page = 0;dateInput.text = "";dateInput2.text = "";count = 1 ;
  }
  Future<void> hand() async {
    widget.doril[co] = {"name":widget.doril[co]["name"],"page":widget.doril[co]["page"],"開始":widget.doril[co]["開始"], "終了":widget.doril[co]["終了"], "現在ページ":page};
    DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(widget.ID);
    ref.update({"ドリル" : widget.doril,});setState(() {});
    name = "";page = 0;dateInput.text = "";dateInput2.text = "";count = 1 ;
  }


  void start(){showModalBottomSheet(isScrollControlled: true, context: context,backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) { return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Container(child:SingleChildScrollView(
              child:Container(child: Column(children: <Widget>[
                Container(margin: EdgeInsets.only(top:30),child:Text("何を?" ,style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15),),),
                Row(children: [
                  Container(width: 10,),
                  Expanded(child: TextFormField(decoration: InputDecoration(labelText: 'ex.歴史の教科書',
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey, width: 3),)),
                    onChanged: (String value) {setState(() {name = value;});},),),
                  Container(width: 10,),Container(width: 100, child: TextFormField( keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "ページ数", enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey, width: 3),)),
                    onChanged: (String value) {setState(() {page = int.parse(value);count = dt2.difference(dt).inDays; av = page / count;});},),),
                  Container(width: 10,), ],),

                Container(margin: EdgeInsets.only(top:20),width:double.infinity,child:Text("いつまでに終わらせる?" ,style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                Container(padding: EdgeInsets.all(5),
                    child: Center(child: TextField(controller: dateInput2,
                        decoration: InputDecoration(icon: Icon(Icons.calendar_today), labelText: "Enter Date"), readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1950), lastDate: DateTime(2100));
                          if (pickedDate != null) {setState(() {dt2 = pickedDate;String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);count = dt2.difference(dt).inDays; av = page / count;dateInput2.text = formattedDate;});}else {};  }))),
                Container(margin: EdgeInsets.only(top:30),child:Text(count.toString() + "日間" ,style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15),),),
                Container(margin: EdgeInsets.only(top:10),child:Text("1日平均: "+ av.toStringAsFixed(1).toString() +"ページ"  ,style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15),),),
                Container(margin :EdgeInsets.only(top:50,bottom:40),width:100,child: ElevatedButton(
                  child: Text('登録'), style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white, shape: const StadiumBorder(),),
                  onPressed: () {send();},)),
              ],),),),);});});}

  void start1(){showModalBottomSheet(isScrollControlled: true, context: context,backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) {return Container(height: 500,
        child: SingleChildScrollView(
          child: Column(children: [
            Row(children: [
              Expanded(child: Container()),
              Container(margin :EdgeInsets.all(5),alignment:Alignment.centerRight,child:IconButton(icon:  Icon(Icons.edit,color: Colors.pink,size: 30,), onPressed: () {handEdit();},),),
              Container(margin :EdgeInsets.all(5),alignment:Alignment.centerRight,child:IconButton(icon:  Icon(Icons.calendar_month_rounded,color: Colors.pink,size: 30,), onPressed: () {calendar();},),),
              Container(margin :EdgeInsets.all(5),alignment:Alignment.centerRight,child:IconButton(icon:  Icon(Icons.delete_forever,color: Colors.pink,size: 30,), onPressed: () {delete();},),),
            ],),
           Container(child: widget.doril[co]["開始"] != date ?
            Container(margin :EdgeInsets.only(top:0),width:150,child: ElevatedButton(child: Text('今日の分終わった!'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: const StadiumBorder(),),
              onPressed: () {done();Navigator.pop(context);},))
           : Container(margin :EdgeInsets.only(top:0),width:150,child: ElevatedButton(child: Text('手動で入力'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, shape: const StadiumBorder(),),
              onPressed: () {handEdit();},))),
            Container(margin: EdgeInsets.only(top:30),width:double.infinity,child:Text("おすすめ",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
            GestureDetector(
              onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V4V2(1500,300,widget.doril[co]["name"] + text,widget.ID)));},
              child: Container(margin: EdgeInsets.all(15),color: Colors.grey[200],child:Column(children: [
                Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("勉強時間:　　0:25:00　　",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                Container(margin: EdgeInsets.all(5),width:double.infinity,child:Text("休憩時間:　　0:05:00" ,style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),)
              ],), ) ,
            ),
            GestureDetector(
              onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V4V2(750,150,widget.doril[co]["name"] + text,widget.ID)));},
              child: Container(margin: EdgeInsets.only(left:15,right:15,bottom: 5),color: Colors.grey[200],child:Column(children: [
                Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("勉強時間:　　0:12:30　　",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                Container(margin: EdgeInsets.all(5),width:double.infinity,child:Text("休憩時間:　　0:02:30" ,style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),)
              ],), ) ,
            ),
            Divider(color: Colors.grey,thickness: 1,indent: 100,endIndent: 100,),
            Container(margin: EdgeInsets.all(10),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(),
              itemCount: widget.item.length, itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V4V2(widget.item[index]["勉強"],widget.item[index]["休憩"],widget.doril[co]["name"]+ text,widget.ID)));},
                    child: Container(margin: EdgeInsets.all(5),color: Colors.grey[200],child:Column(children: [
                      Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("勉強時間:　　" + '${(widget.item[index]["勉強"] / (60 * 60)).floor()}:${((widget.item[index]["勉強"] % (60 * 60) / 60).floor()).toString().padLeft(2, '0')}:${(widget.item[index]["勉強"] % (60 * 60) % 60).toString().padLeft(2, '0')}',style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                      Container(margin: EdgeInsets.all(5),width:double.infinity,child:Text("休憩時間:　　" +'${(widget.item[index]["休憩"] / (60 * 60)).floor()}:${((widget.item[index]["休憩"] % (60 * 60) / 60).floor()).toString().padLeft(2, '0')}:${(widget.item[index]["休憩"] % (60 * 60) % 60).toString().padLeft(2, '0')}',style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),)
                    ],), )    );
              },),),
          ],),),);});}


  Future<void> delete() async {
    showDialog(context: context, builder: (context) =>  AlertDialog(title: Text('削除しますか？',style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
      actions: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center,children: [
          Container(margin :EdgeInsets.only(right:10),width:100,child: ElevatedButton(child: Text('はい'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: const StadiumBorder(),),
            onPressed: () {DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(widget.ID);
            setState(() {widget.doril.removeAt(co);}); ref.update({"ドリル" : widget.doril,});Navigator.pop(context);Navigator.pop(context);},)),
          Container(margin :EdgeInsets.only(left:10),width:100,child: ElevatedButton(child: Text('いいえ'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: const StadiumBorder(),),
          onPressed: () {Navigator.pop(context);},)),
           ],)
        ],));
  }

  Future<void> calendar() async {
    showDialog(context: context, builder: (context) { return StatefulBuilder(
        builder: (context, StateSetter setState) {
          return   AlertDialog(title: Text('終了日を変更しますか？',style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
      actions: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center,children: [
          Container(margin :EdgeInsets.only(right:10),width:100,child: ElevatedButton(child: Text('はい'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: const StadiumBorder(),),
            onPressed: () async {                      DateTime? pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1950), lastDate: DateTime(2100));
            if (pickedDate != null) {setState(() {dt2 = pickedDate;String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);count = dt2.difference(DateTime(now.year, now.month, now.day)).inDays; av = widget.doril[co]["page"] / count;dateC  = formattedDate;});}else {}; },)),
          Container(margin :EdgeInsets.only(left:10),width:100,child: ElevatedButton(child: Text('いいえ'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: const StadiumBorder(),),
            onPressed: () {Navigator.pop(context);},)),
            ],),
        Container(alignment: Alignment.center,width:double.infinity,margin: EdgeInsets.only(top:10),child:Text(dateC ,style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15),),),
        Container(alignment: Alignment.center,width:double.infinity,margin: EdgeInsets.only(top:10),child:Text(count.toString() + "日間" ,style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15),),),
        Container(alignment: Alignment.center,width:double.infinity,margin: EdgeInsets.only(top:10,bottom: 20),child:Text("1日平均: "+ av.toStringAsFixed(1).toString() +"ページ"  ,style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15),),),
        Center(child: ElevatedButton(child: Text('変更'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, shape: const StadiumBorder(),),
          onPressed: () {Edite();Navigator.pop(context);},)),
      ],);});});

  }
  Future<void> handEdit() async {
    showDialog(context: context, builder: (context) { return StatefulBuilder(
        builder: (context, StateSetter setState) {
          return   AlertDialog(title: Text('手動入力',style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),
            actions: <Widget>[
              Container(alignment: Alignment.center,width:double.infinity,margin: EdgeInsets.only(top:0),child:Text("何ページまで終わりましたか？" ,style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15),),),
              Center(child:Container(alignment: Alignment.center,margin: EdgeInsets.all(10),width: 100, child: TextFormField( keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "ページ数", enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey, width: 3),)),
                onChanged: (String value) {setState(() {page = int.parse(value);});},),)),
              Center(child: ElevatedButton(child: Text('入力'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, shape: const StadiumBorder(),),
                onPressed: () {hand();Navigator.pop(context);Navigator.pop(context);},)),
            ],);});});

  }


  String randomString(int length) {
    const _randomChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    const _charsLength = _randomChars.length;
    final rand = new Random();
    final codeUnits = new List.generate(
      length,
          (index) {
        final n = rand.nextInt(_charsLength);
        return _randomChars.codeUnitAt(n);
      },);
    return new String.fromCharCodes(codeUnits);
  }


}