// import 'dart:ui';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../アカウント/SignUp.dart';
// import 'V7Add.dart';
// import 'V7First.dart';
// import 'V7V2.dart';
//
//
//
// class V7 extends StatefulWidget {
//   @override
//
//   State<V7> createState() => _V7State();
// }
//
// class _V7State extends State<V7> {
//   var ID = "";
//   var item1 = [];var Additem = [];var profiel = [];var map = {};
//   var date = "";var months = "";var years = "";
//   // var item =  [FlSpot(0.0, 3.0),FlSpot(1.0, 13.0),FlSpot(2.0, 22.0),FlSpot(3.0, 1.0),FlSpot(4.0, 35.0),FlSpot(5.0, 53.0),FlSpot(6.0, 31.0),FlSpot(7.0, 3.0),FlSpot(8.0, 38.0),FlSpot(9.0, 83.0),FlSpot(10.0, 31.0),FlSpot(11.0, 3.0),FlSpot(12.0, 31.0),FlSpot(13.0, 33.0),FlSpot(14.0, 23.0),FlSpot(15.0, 13.0),FlSpot(16.0, 3.0),FlSpot(17.0, 63.0),FlSpot(18.0, 113.0),FlSpot(19.0, 13.0),FlSpot(20.0, 3.0),FlSpot(21.0, 3.0),FlSpot(22.0, 73.0),FlSpot(23.0, 3.0),FlSpot(24.0, 13.0),FlSpot(25.0, 3.0),FlSpot(26.0, 3.0),FlSpot(27.0, 3.0),FlSpot(28.0, 32.0),FlSpot(29.0, 13.0)];
//   var day = "";var item =  [FlSpot(0.0, 3.0)];var A = false;var compareI = 0.0;var compareT = "";var maxValue1 = 130;
//   var day2 = "";var item2 =  [FlSpot(0.0, 3.0)];var B = false;var compareI2 = 0.0;var compareT2 = "";var maxValue2 = 130;
//   var day3 = "";var item3 =  [FlSpot(0.0, 3.0)];var C = false;var compareI3 = 0.0;var compareT3 = "";var maxValue3 = 130;
//   var Alltime = "";
//   final _pageController = PageController(viewportFraction: 0.877); double currentPage = 0;
//   var co = 0;var time = 0;var renzoku = 0;
//   DateTime now = DateTime.now();DateFormat outputFormat = DateFormat('yyyy年MM月dd日');DateFormat outputFormat2 = DateFormat('yyyy年MM月');
//
//   @override
//   void initState() {
//     super.initState();firbase();
//     sign(); }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(backgroundColor: Colors.white,
//       appBar: AppBar(backgroundColor: Colors.white,
//         title:Text("", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 40), textAlign: TextAlign.center,),
//         iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
//         actions: [],),
//       body: SingleChildScrollView(
//           child: Column(children: [
//             Container(margin:EdgeInsets.only(top:50,bottom: 0,left: 20,right: 20),width:double.infinity,child:Text("プロフィール",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
//             Divider(color: Colors.blueGrey,thickness: 3,indent: 150,endIndent: 150,),
//             GestureDetector(onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V7First2(map["単位数"]))).then((value) => set());
//               },child:Container(margin:EdgeInsets.all(20),decoration: BoxDecoration(color: Colors.grey[50],borderRadius: BorderRadius.circular(10)),child:Row(children: [
//               Container(margin :EdgeInsets.only(top:20,bottom: 20,right: 20,left: 50),width: 50,height: 50, child:Image(image: AssetImage(map["写真"]),),),
//               Column(children: [
//                 Container(margin:EdgeInsets.only(right: 10,top:0,bottom: 0),child: Text(map["名前"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15,height: 1.5,letterSpacing: 2,),),),
//                 Container(margin:EdgeInsets.only(right: 10,top:0,bottom: 0),child: Text(map["一言"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15,height: 1.5,letterSpacing: 2,),),),
//               ],),
//               Expanded(child:Container(alignment: Alignment.center,margin:EdgeInsets.only(right: 10,top:0,bottom: 0),child: Text("単位数：" + map["単位数"].toString(),style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15,height: 1.5,letterSpacing: 2,),)),),
//             ],))),
//             Container(margin:EdgeInsets.only(top:30,bottom: 0,left: 20,right: 20),width:double.infinity,child:Text("クラス",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
//             Divider(color: Colors.blueGrey,thickness: 3,indent: 150,endIndent: 150,),
//               Container(margin:EdgeInsets.only(top:10,bottom: 0,left: 20,right: 20),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(),
//               itemCount: item1.length, itemBuilder: (context, index) {
//                 return GestureDetector(onTap: () {
//                   var aa  = DateTime(2023, 1, 1, item1[index]["時間時間"], item1[index]["時間分"]);
//                   //var aa  = DateTime(2023, 1, 1, 7, 20);DateTime now = DateTime.now();
//                   var bb = DateTime(2023, 1, 1, now.hour, now.minute);
//                   var dif = bb.difference(aa).inSeconds;print(dif);
//                   if ( -600 <= dif == true &&   dif <= 300 == true){
//                     Navigator.of(context).push(MaterialPageRoute(builder: (context) => V7V2(item1[index])));
//                   }
//                   else{showDialog(context: context, builder: (context) => AlertDialog(title: Text("現在入室出来ません",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center), ));
//                   }
//
//                 },
//                     child:Card(elevation: 0,color:Colors.grey[200], child:Container(child:Column(children: [
//                       Container(margin:EdgeInsets.all(5),child:Text(item1[index]["クラス名"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
//                      Container(margin:EdgeInsets.all(5),child:Text(item1[index]["時間"],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center)),
//                     ],),)));},),),
//                Container(margin:EdgeInsets.only(top:0,bottom: 80),width:150,child: ElevatedButton(child:  Text('クラスに参加'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),), onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V7Add(Additem,map))).then((value) => set());},)),
//               // Container(color: Colors.transparent,margin: EdgeInsets.only(top: 10.0), height: 350, child: PageView(physics: BouncingScrollPhysics(), controller: _pageController, scrollDirection: Axis.horizontal,
//               // children: [
//               //   Column(children: [
//               //     Container(margin: EdgeInsets.only(left: 10.0),color: Colors.transparent, width: double.infinity, alignment: Alignment.centerLeft, child: Text("今日の勉強時間", style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.center,)),
//               //     Row(children: [Container(margin: EdgeInsets.only(left: 10.0),color: Colors.transparent,alignment: Alignment.centerLeft, child: Text(day, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center,)),
//               //       Container(child: A == false ?Icon(Icons.trending_down,color: Colors.blue,): Icon(Icons.trending_up,color: Colors.red,))],),
//               //     Container(margin: EdgeInsets.only(left: 10.0,bottom: 10),color: Colors.transparent, width: double.infinity, alignment: Alignment.centerLeft, child: Text(compareT, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10), textAlign: TextAlign.center,)),
//               //     Container(margin: EdgeInsets.only(right: 10.0),child:  AspectRatio(aspectRatio: 1.414, child: DecoratedBox(decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(18),), color:Color(0xff37434d),),
//               //       child: Padding(padding: const EdgeInsets.only(right: 18, left: 12, top: 24, bottom: 12,),
//               //         child: LineChart(mainData(),),),),))]),
//               //   Column(children: [
//               //     Container(margin: EdgeInsets.only(left: 10.0),color: Colors.transparent, width: double.infinity, alignment: Alignment.centerLeft, child: Text("週の勉強時間", style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.center,)),
//               //     Row(children: [Container(margin: EdgeInsets.only(left: 10.0),color: Colors.transparent,alignment: Alignment.centerLeft, child: Text(day2, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center,)),
//               //       Container(child: B == false ?Icon(Icons.trending_down,color: Colors.blue,): Icon(Icons.trending_up,color: Colors.red,))],),
//               //     Container(margin: EdgeInsets.only(left: 10.0,bottom: 10),color: Colors.transparent, width: double.infinity, alignment: Alignment.centerLeft, child: Text(compareT2, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10), textAlign: TextAlign.center,)),
//               //     Container(margin: EdgeInsets.only(right: 10.0),child:  AspectRatio(aspectRatio: 1.414, child: DecoratedBox(decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(18),), color:Color(0xff37434d),),
//               //       child: Padding(padding: const EdgeInsets.only(right: 18, left: 12, top: 24, bottom: 12,),
//               //         child: LineChart(mainData2(),),),),))]),
//               //   Column(children: [
//               //     Container(margin: EdgeInsets.only(left: 10.0),color: Colors.transparent, width: double.infinity, alignment: Alignment.centerLeft, child: Text("月の勉強時間", style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.center,)),
//               //     Row(children: [Container(margin: EdgeInsets.only(left: 10.0),color: Colors.transparent,alignment: Alignment.centerLeft, child: Text(day3, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center,)),
//               //       Container(child: C == false ?Icon(Icons.trending_down,color: Colors.blue,): Icon(Icons.trending_up,color: Colors.red,))],),
//               //     Container(margin: EdgeInsets.only(left: 10.0,bottom: 10),color: Colors.transparent, width: double.infinity, alignment: Alignment.centerLeft, child: Text(compareT3, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10), textAlign: TextAlign.center,)),
//               //     Container(margin: EdgeInsets.only(right: 10.0),child:  AspectRatio(aspectRatio: 1.414, child: DecoratedBox(decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(18),), color:Color(0xff37434d),),
//               //       child: Padding(padding: const EdgeInsets.only(right: 18, left: 12, top: 24, bottom: 12,),
//               //         child: LineChart(mainData3(),),),),))]),
//               // ],),),
//
//           ])),);}
//
//   Future<void> firbase () async {
//     var item = ["6:00~6:50","7:00~7:50","8:00~8:50","9:00~9:50","10:00~10:50","11:00~11:50","12:00~13:50","13:00~13:50","14:00~14:50","15:00~15:50","16:00~16:50","17:00~17:50","18:00~18:50","19:00~19:50","20:00~20:50","21:00~21:50","22:00~22:50","23:00~23:50","24:00~24:50"];
//     for(int i = 0; i<item.length; i++){
//     await FirebaseFirestore.instance.collection('クラス').doc(item[i]).set({"クラス名":item[i] });
//   }}
//
//  void set (){
//     FirebaseFirestore.instance.collection('users').where("ID" ,isEqualTo: ID).get().then((QuerySnapshot snapshot) {
//       snapshot.docs.forEach((doc) {setState(() {map = doc["プロフィール"];item1 = doc["クラス"];
//       for(int i = 0; i<item1.length; i++){Additem.add(item1[i]["時間"]);}
//       });});
//   });}
//   void sign() async {SharedPreferences prefs = await SharedPreferences.getInstance();
//     ID = prefs.getString("ID") ?? "";
//     if (ID == "") {Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()));}else{
//       if (map == null) {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V7First(0))).then((value) => set());}
//     }  set();
//   }
//
//
//
//
//
//
// List<LineTooltipItem> defaultLineTooltipItem(List<LineBarSpot> touchedSpots) {
//   return touchedSpots.map((LineBarSpot touchedSpot) {
//     final textStyle = TextStyle(color: touchedSpot.bar.gradient?.colors.first ?? touchedSpot.bar.color ?? Colors.blueGrey, fontWeight: FontWeight.bold,fontSize: 14,);
//     return LineTooltipItem('${(touchedSpot.y / (60 * 60)).floor()}時間${((touchedSpot.y % (60 * 60) / 60).floor()).toString().padLeft(2, '0')}分${(touchedSpot.y % (60 * 60) % 60).toInt().toString().padLeft(2, '0')}', textStyle);
//   }).toList();
// }
// LineChartData mainData() {
//   return LineChartData(
//     lineTouchData: LineTouchData(handleBuiltInTouches: true, getTouchedSpotIndicator: defaultTouchedIndicators,
//       touchTooltipData: LineTouchTooltipData(getTooltipItems: defaultLineTooltipItem,  tooltipRoundedRadius: 2.0,),),
//     gridData: FlGridData(show: true, drawVerticalLine: true, horizontalInterval: 1.0, verticalInterval: 1.0,
//       getDrawingHorizontalLine: (value) {return FlLine(color: Color(0xff37434d), strokeWidth: 1.0,);},
//       getDrawingVerticalLine: (value) {return FlLine(color: Color(0xff37434d), strokeWidth: 1.0,);},
//     ),
//     titlesData: FlTitlesData(show: true, rightTitles: AxisTitles(), topTitles: AxisTitles(),
//       bottomTitles: AxisTitles(
//         axisNameWidget: const Text("[曜日]", style: TextStyle(color: Color(0xff68737d),),), axisNameSize: 22.0,
//         sideTitles: SideTitles(showTitles: true, interval: 1.0, reservedSize: 40.0, getTitlesWidget: bottomTitleWidgets,),),
//       leftTitles: AxisTitles(axisNameSize: 28.0,
//         sideTitles: SideTitles(showTitles: true, interval: 1.0, reservedSize: 42.0, getTitlesWidget: leftTitleWidgets,),),),
//     borderData: FlBorderData(show: true, border: Border.all(color: Color(0xff37434d),),),
//     minX: 0.0, maxX: item.length.toDouble(), minY: 0.0, maxY: maxValue1.toDouble(),
//     lineBarsData: [
//       LineChartBarData(
//         spots: item, isCurved: false, barWidth: 1.0, isStrokeCapRound: false, dotData: FlDotData(show: true,
//         getDotPainter: (spot, percent, barData, index) =>
//             FlDotCirclePainter(radius: 2.0, color: Colors.blue, strokeWidth: 2.0, strokeColor: Colors.blue,),),
//         belowBarData: BarAreaData(show: false,),),],);}
//
// Widget bottomTitleWidgets(double value, TitleMeta meta) {
//   const style = TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16.0,);Widget text;
//   switch (value.toInt()) {
//     case 0:text =  Text('月', style: style);break;
//     case 1:text =  Text('火', style: style);break;
//     case 2:text =  Text('水', style: style);break;
//     case 3:text =  Text('木', style: style);break;
//     case 4:text =  Text('金', style: style);break;
//     case 5:text =  Text('土', style: style);break;
//     case 6:text =  Text('日', style: style);break;
//     default:text =  Text('', style: style);break;
//   }return SideTitleWidget(axisSide: meta.axisSide, child: text,);}
//
// Widget leftTitleWidgets(double value, TitleMeta meta) {
//   const style = TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 15.0,);
//   String text;
//   switch (value.toInt()) {
//     case 1:text = '';break;
//     case 3:text = '';break;
//     case 10:text = '';//text = maxValue1.toString();
//     break;
//     default:return Container();}
//   return Text(text, style: style, textAlign: TextAlign.left);
// }
//
// LineChartData mainData2() {
//   return LineChartData(
//     lineTouchData: LineTouchData(handleBuiltInTouches: true, getTouchedSpotIndicator: defaultTouchedIndicators,
//       touchTooltipData: LineTouchTooltipData(getTooltipItems: defaultLineTooltipItem,tooltipRoundedRadius: 2.0,),),
//     gridData: FlGridData(show: true, drawVerticalLine: true, horizontalInterval: 1.0, verticalInterval: 1.0,
//       getDrawingHorizontalLine: (value) {return FlLine(color: Color(0xff37434d), strokeWidth: 1.0,);},
//       getDrawingVerticalLine: (value) {return FlLine(color: Color(0xff37434d), strokeWidth: 1.0,);},
//     ),
//     titlesData: FlTitlesData(show: true, rightTitles: AxisTitles(), topTitles: AxisTitles(),
//       bottomTitles: AxisTitles(
//         axisNameWidget: const Text("[日]", style: TextStyle(color: Color(0xff68737d),),), axisNameSize: 22.0,
//         sideTitles: SideTitles(showTitles: true, interval: 1.0, reservedSize: 40.0, getTitlesWidget: bottomTitleWidgets2,),),
//       leftTitles: AxisTitles(axisNameSize: 28.0,
//         sideTitles: SideTitles(showTitles: true, interval: 1.0, reservedSize: 42.0, getTitlesWidget: leftTitleWidgets,),),),
//     borderData: FlBorderData(show: true, border: Border.all(color: Color(0xff37434d),),),
//     minX: 0.0, maxX: item2.length.toDouble(), minY: 0.0, maxY: maxValue2.toDouble(),
//     lineBarsData: [
//       LineChartBarData(
//         spots: item2, isCurved: false, barWidth: 1.0, isStrokeCapRound: false, dotData: FlDotData(show: true,
//         getDotPainter: (spot, percent, barData, index) =>
//             FlDotCirclePainter(radius: 2.0, color: Colors.blue, strokeWidth: 2.0, strokeColor: Colors.blue,),),
//         belowBarData: BarAreaData(show: false,),),],);}
//
// Widget bottomTitleWidgets2(double value, TitleMeta meta) {
//   const style = TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16.0,);Widget text;
//   switch (value.toInt()) {
//     case 0:text =  Text('1', style: style);break;
//     case 6:text =  Text('7', style: style);break;
//     case 13:text =  Text('14', style: style);break;
//     case 20:text =  Text('21', style: style);break;
//     case 27:text =  Text('28', style: style);break;
//     case 30:text =  Text('31', style: style);break;
//     default:text =  Text('', style: style);break;
//   }return SideTitleWidget(axisSide: meta.axisSide, child: text,);}
//
//
// LineChartData mainData3() {
//   return LineChartData(
//     lineTouchData: LineTouchData(handleBuiltInTouches: true, getTouchedSpotIndicator: defaultTouchedIndicators,
//       touchTooltipData: LineTouchTooltipData(getTooltipItems: defaultLineTooltipItem,  tooltipRoundedRadius: 2.0,),),
//     gridData: FlGridData(show: true, drawVerticalLine: true, horizontalInterval: 1.0, verticalInterval: 1.0,
//       getDrawingHorizontalLine: (value) {return FlLine(color: Color(0xff37434d), strokeWidth: 1.0,);},
//       getDrawingVerticalLine: (value) {return FlLine(color: Color(0xff37434d), strokeWidth: 1.0,);},
//     ),
//     titlesData: FlTitlesData(show: true, rightTitles: AxisTitles(), topTitles: AxisTitles(),
//       bottomTitles: AxisTitles(
//         axisNameWidget: const Text("[月]", style: TextStyle(color: Color(0xff68737d),),), axisNameSize: 22.0,
//         sideTitles: SideTitles(showTitles: true, interval: 1.0, reservedSize: 40.0, getTitlesWidget: bottomTitleWidgets3,),),
//       leftTitles: AxisTitles(axisNameSize: 28.0,
//         sideTitles: SideTitles(showTitles: true, interval: 1.0, reservedSize: 42.0, getTitlesWidget: leftTitleWidgets,),),),
//     borderData: FlBorderData(show: true, border: Border.all(color: Color(0xff37434d),),),
//     minX: 0.0, maxX: item3.length.toDouble(), minY: 0.0, maxY: maxValue3.toDouble(),
//     lineBarsData: [
//       LineChartBarData(
//         spots: item3, isCurved: false, barWidth: 1.0, isStrokeCapRound: false, dotData: FlDotData(show: true,
//         getDotPainter: (spot, percent, barData, index) =>
//             FlDotCirclePainter(radius: 2.0, color: Colors.blue, strokeWidth: 2.0, strokeColor: Colors.blue,),),
//         belowBarData: BarAreaData(show: false,),),],);}
//
// Widget bottomTitleWidgets3(double value, TitleMeta meta) {
//   const style = TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16.0,);Widget text;
//   switch (value.toInt()) {
//     case 0:text =  Text('1', style: style);break;
//     case 1:text =  Text('2', style: style);break;
//     case 2:text =  Text('3', style: style);break;
//     case 3:text =  Text('4', style: style);break;
//     case 4:text =  Text('5', style: style);break;
//     case 5:text =  Text('6', style: style);break;
//     case 6:text =  Text('7', style: style);break;
//     case 7:text =  Text('8', style: style);break;
//     case 8:text =  Text('9', style: style);break;
//     case 9:text =  Text('10', style: style);break;
//     case 10:text =  Text('11', style: style);break;
//     case 11:text =  Text('12', style: style);break;
//     default:text =  Text('', style: style);break;
//   }return SideTitleWidget(axisSide: meta.axisSide, child: text,);}
//
// }