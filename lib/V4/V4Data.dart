
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';

class V4Data extends StatefulWidget {
  @override
  State<V4Data> createState() => _V4DataState();
}
//FlSpot(0.0, 3.0),
class _V4DataState extends State<V4Data> {
  var date = "";var months = "";var years = "";
  // var item =  [FlSpot(0.0, 3.0),FlSpot(1.0, 13.0),FlSpot(2.0, 22.0),FlSpot(3.0, 1.0),FlSpot(4.0, 35.0),FlSpot(5.0, 53.0),FlSpot(6.0, 31.0),FlSpot(7.0, 3.0),FlSpot(8.0, 38.0),FlSpot(9.0, 83.0),FlSpot(10.0, 31.0),FlSpot(11.0, 3.0),FlSpot(12.0, 31.0),FlSpot(13.0, 33.0),FlSpot(14.0, 23.0),FlSpot(15.0, 13.0),FlSpot(16.0, 3.0),FlSpot(17.0, 63.0),FlSpot(18.0, 113.0),FlSpot(19.0, 13.0),FlSpot(20.0, 3.0),FlSpot(21.0, 3.0),FlSpot(22.0, 73.0),FlSpot(23.0, 3.0),FlSpot(24.0, 13.0),FlSpot(25.0, 3.0),FlSpot(26.0, 3.0),FlSpot(27.0, 3.0),FlSpot(28.0, 32.0),FlSpot(29.0, 13.0)];
  var day = "";var item =  [FlSpot(0.0, 3.0)];var A = false;var compareI = 0.0;var compareT = "";var maxValue1 = 130;
  var day2 = "";var item2 =  [FlSpot(0.0, 3.0)];var B = false;var compareI2 = 0.0;var compareT2 = "";var maxValue2 = 130;
  var day3 = "";var item3 =  [FlSpot(0.0, 3.0)];var C = false;var compareI3 = 0.0;var compareT3 = "";var maxValue3 = 130;
  var Alltime = "";
  final _pageController = PageController(viewportFraction: 0.877); double currentPage = 0;
  var co = 0;var time = 0;var renzoku = 0;
  DateTime now = DateTime.now();DateFormat outputFormat = DateFormat('yyyy年MM月dd日');DateFormat outputFormat2 = DateFormat('yyyy年MM月');
  @override
  void initState() { _pageController.addListener(() {setState(() {currentPage = _pageController.page!.toDouble();});});
  super.initState();
  data();renzo (); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent,
        title: Text("", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,), textAlign: TextAlign.center,),
        iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
            ),
      body: SingleChildScrollView(
        // グラフ表示画面(大枠)の設定
        child: Column(children: [
           Container(color: Colors.transparent,margin: EdgeInsets.only(top: 10.0), height: 350, child: PageView(physics: BouncingScrollPhysics(), controller: _pageController, scrollDirection: Axis.horizontal,
              children: [
               Column(children: [
                Container(margin: EdgeInsets.only(left: 10.0),color: Colors.transparent, width: double.infinity, alignment: Alignment.centerLeft, child: Text("今日の勉強時間", style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.center,)),
                Row(children: [Container(margin: EdgeInsets.only(left: 10.0),color: Colors.transparent,alignment: Alignment.centerLeft, child: Text(day, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center,)),
                  Container(child: A == false ?Icon(Icons.trending_down,color: Colors.blue,): Icon(Icons.trending_up,color: Colors.red,))],),
                Container(margin: EdgeInsets.only(left: 10.0,bottom: 10),color: Colors.transparent, width: double.infinity, alignment: Alignment.centerLeft, child: Text(compareT, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10), textAlign: TextAlign.center,)),
                Container(margin: EdgeInsets.only(right: 10.0),child:  AspectRatio(aspectRatio: 1.414, child: DecoratedBox(decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(18),), color:Color(0xff37434d),),
                  child: Padding(padding: const EdgeInsets.only(right: 18, left: 12, top: 24, bottom: 12,),
                    child: LineChart(mainData(),),),),))]),
                Column(children: [
                  Container(margin: EdgeInsets.only(left: 10.0),color: Colors.transparent, width: double.infinity, alignment: Alignment.centerLeft, child: Text("週の勉強時間", style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.center,)),
                  Row(children: [Container(margin: EdgeInsets.only(left: 10.0),color: Colors.transparent,alignment: Alignment.centerLeft, child: Text(day2, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center,)),
                    Container(child: B == false ?Icon(Icons.trending_down,color: Colors.blue,): Icon(Icons.trending_up,color: Colors.red,))],),
                  Container(margin: EdgeInsets.only(left: 10.0,bottom: 10),color: Colors.transparent, width: double.infinity, alignment: Alignment.centerLeft, child: Text(compareT2, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10), textAlign: TextAlign.center,)),
                  Container(margin: EdgeInsets.only(right: 10.0),child:  AspectRatio(aspectRatio: 1.414, child: DecoratedBox(decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(18),), color:Color(0xff37434d),),
                    child: Padding(padding: const EdgeInsets.only(right: 18, left: 12, top: 24, bottom: 12,),
                      child: LineChart(mainData2(),),),),))]),
                Column(children: [
                  Container(margin: EdgeInsets.only(left: 10.0),color: Colors.transparent, width: double.infinity, alignment: Alignment.centerLeft, child: Text("月の勉強時間", style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.center,)),
                  Row(children: [Container(margin: EdgeInsets.only(left: 10.0),color: Colors.transparent,alignment: Alignment.centerLeft, child: Text(day3, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center,)),
                    Container(child: C == false ?Icon(Icons.trending_down,color: Colors.blue,): Icon(Icons.trending_up,color: Colors.red,))],),
                  Container(margin: EdgeInsets.only(left: 10.0,bottom: 10),color: Colors.transparent, width: double.infinity, alignment: Alignment.centerLeft, child: Text(compareT3, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10), textAlign: TextAlign.center,)),
                  Container(margin: EdgeInsets.only(right: 10.0),child:  AspectRatio(aspectRatio: 1.414, child: DecoratedBox(decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(18),), color:Color(0xff37434d),),
                    child: Padding(padding: const EdgeInsets.only(right: 18, left: 12, top: 24, bottom: 12,),
                      child: LineChart(mainData3(),),),),))]),
              ],),),
          Container(margin:EdgeInsets.only(top:20),child: Text("総勉強時間",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[600],fontSize: 15),textAlign: TextAlign.center,),),
          Container(margin:EdgeInsets.only(top:0),child: Text(Alltime,style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20),textAlign: TextAlign.center,),),
          Visibility(child : Divider(color: Colors.blueGrey,thickness: 3,indent: 150,endIndent: 150,),),
          Container(margin:EdgeInsets.only(top:20),child: Text("連続日数",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[600],fontSize: 15),textAlign: TextAlign.center,),),
          Container(margin:EdgeInsets.only(top:0),child: Text(renzoku.toString() + "日",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 20),textAlign: TextAlign.center,),),
          Visibility(child : Divider(color: Colors.blueGrey,thickness: 3,indent: 150,endIndent: 150,),),

        ],)),);}
  void data() async {date = outputFormat.format(now);var yesterday = outputFormat.format(now.subtract(Duration(days: 1)));
  SharedPreferences prefs = await SharedPreferences.getInstance();
    renzoku = prefs.getInt("連続") ?? 0;
    time = prefs.getInt("総勉強時間") ?? 0;
    Alltime = '${(time / (60 * 60)).floor()}時間${((time % (60 * 60) / 60).floor()).toString().padLeft(2, '0')}分${(time % (60 * 60) % 60).toString().padLeft(2, '0')}';
    var dayT = prefs.getInt(date) ?? 0;var yesterdayT = prefs.getInt(yesterday) ?? 0;
    compareI = dayT / yesterdayT * 100;
    if (dayT > yesterdayT){A = true;compareT = "昨日より" + compareI.toStringAsFixed(1).toString() + "%増えています";}else{A = false;compareI = 100 - compareI; compareT = "昨日より" + compareI.toStringAsFixed(1).toString() + "%減っています";}
    if (dayT == 0 || yesterdayT == 0){compareT = "";}
    day = '${(dayT / (60 * 60)).floor()}時間${((dayT % (60 * 60) / 60).floor()).toString().padLeft(2, '0')}分${(dayT % (60 * 60) % 60).toString().padLeft(2, '0')}';
  week ();month ();year ();
  Future.delayed(Duration(seconds: 1), () {setState(() {setState(() {});});});
  }

  Future<void> week () async {item = [];var weekT = 0;var weekT2 = 0;
     date = outputFormat.format(now);
    var startweek = outputFormat.format(now.subtract(Duration(days: now.weekday - 1)));
    SharedPreferences prefs = await SharedPreferences.getInstance();
     var set = prefs.getInt(startweek) ?? 0;
    item.add(FlSpot(0.0, set.toDouble()));
    var max1 = <int>[];max1.add(set);
    for(int i = 0; i<7; i++){
      DateTime tomorrow = now.subtract(Duration(days: now.weekday - 1)).add(Duration(days:i));
      String tomorrowString = outputFormat.format(tomorrow);
      var set = prefs.getInt(tomorrowString) ?? 0;weekT = weekT + set;
      day2 = '${(weekT / (60 * 60)).floor()}時間${((weekT % (60 * 60) / 60).floor()).toString().padLeft(2, '0')}分${(weekT % (60 * 60) % 60).toString().padLeft(2, '0')}';
      item.add(FlSpot(i.toDouble(), set.toDouble()));max1.add(set);
  }
    //先週と比較
  var lastweek = DateTime.now().subtract(Duration(days: 7));
  for(int i = 0; i<7; i++){
    DateTime tomorrow = lastweek.subtract(Duration(days: lastweek.weekday - 1)).add(Duration(days:i));
    String tomorrowString = outputFormat.format(tomorrow);
    var set = prefs.getInt(tomorrowString) ?? 0;weekT2 = weekT2 + set;
  }
  compareI2 = weekT / weekT2 * 100;
  if (weekT > weekT2){B = true;compareT2 = "先週より" + compareI2.toStringAsFixed(1).toString() + "%増えています";}else{B = false;compareI2 = 100 - compareI2; compareT2 = "先週より" + compareI2.toStringAsFixed(1).toString() + "%減っています";}
  if (weekT == 0 || weekT2 == 0){compareT2 = "";}

  maxValue1 =  max1.reduce(max);
  }

  Future<void> month () async {item2 = [];
  DateTime result = DateTime(now.year, now.month, 1);
  months = outputFormat.format(result);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var set = prefs.getInt(months) ?? 0;
  item2.add(FlSpot(0.0, set.toDouble()));
  var max1 = <int>[];max1.add(set);
  for(int i = 1; i<31; i++){
    DateTime tomorrow = result.add(Duration(days:i));
    String tomorrowString = outputFormat.format(tomorrow);
    var set = prefs.getInt(tomorrowString) ?? 0;
    item2.add(FlSpot(i.toDouble(), set.toDouble()));max1.add(set);
  }
  maxValue2 =  max1.reduce(max);
  }

  Future<void> year () async {item3 = [];
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var max1 = <int>[];
  years = outputFormat2.format(now);var set = prefs.getInt(years) ?? 0;print(years);
  day3 = '${(set / (60 * 60)).floor()}時間${((set % (60 * 60) / 60).floor()).toString().padLeft(2, '0')}分${(set % (60 * 60) % 60).toString().padLeft(2, '0')}';
  var lastmonths = DateTime(now.year, now.month - 1);
  years = outputFormat2.format(lastmonths);var set2 = prefs.getInt(years) ?? 0;
  compareI3 = set / set2 * 100;
  if (set > set2){C = true;compareT3 = "先月より" + compareI3.toStringAsFixed(1).toString() + "%増えています";}else{C = false;compareI3 = 100 - compareI3; compareT3 = "先月より" + compareI3.toStringAsFixed(1).toString() + "%減っています";}
  if (set == 0 || set2 == 0){compareT3 = "";}

  for(int i = 0; i<12; i++){
    DateTime year = DateTime(now.year,i +1);
    years = outputFormat2.format(year);
    var set = prefs.getInt(years) ?? 0;
    item3.add(FlSpot(i.toDouble(), set.toDouble()));max1.add(set);
  }
  maxValue3 =  max1.reduce(max);
  }

  Future<void> renzo () async {
    DateTime now = DateTime.now();DateFormat outputFormat = DateFormat('yyyy年MM月dd日');var yesterday2 = outputFormat.format(now.subtract(Duration(days: 2)));
    var yesterday = outputFormat.format(now.subtract(Duration(days: 1)));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var time2 = prefs.getInt(yesterday2)?? 0;var time1 = prefs.getInt(yesterday)?? 0;var time0 = prefs.getInt(date)?? 0;
    if (time2 == 0 && time1 == 0){prefs.setInt("連続", 0);} if (time2 == 0 && time1 == 0 && time0 != 0){prefs.setInt("連続", 1);}if (time2 == 0 && time1 != 0 && time0 != 0){prefs.setInt("連続", 2);}
  }






  List<LineTooltipItem> defaultLineTooltipItem(List<LineBarSpot> touchedSpots) {
    return touchedSpots.map((LineBarSpot touchedSpot) {
      final textStyle = TextStyle(color: touchedSpot.bar.gradient?.colors.first ?? touchedSpot.bar.color ?? Colors.blueGrey, fontWeight: FontWeight.bold,fontSize: 14,);
      return LineTooltipItem('${(touchedSpot.y / (60 * 60)).floor()}時間${((touchedSpot.y % (60 * 60) / 60).floor()).toString().padLeft(2, '0')}分${(touchedSpot.y % (60 * 60) % 60).toInt().toString().padLeft(2, '0')}', textStyle);
    }).toList();
  }
  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(handleBuiltInTouches: true, getTouchedSpotIndicator: defaultTouchedIndicators,
        touchTooltipData: LineTouchTooltipData(getTooltipItems: defaultLineTooltipItem, tooltipBgColor: Colors.white, tooltipRoundedRadius: 2.0,),),
      gridData: FlGridData(show: true, drawVerticalLine: true, horizontalInterval: 1.0, verticalInterval: 1.0,
        getDrawingHorizontalLine: (value) {return FlLine(color: Color(0xff37434d), strokeWidth: 1.0,);},
        getDrawingVerticalLine: (value) {return FlLine(color: Color(0xff37434d), strokeWidth: 1.0,);},
      ),
      titlesData: FlTitlesData(show: true, rightTitles: AxisTitles(), topTitles: AxisTitles(),
        bottomTitles: AxisTitles(
          axisNameWidget: const Text("[曜日]", style: TextStyle(color: Color(0xff68737d),),), axisNameSize: 22.0,
          sideTitles: SideTitles(showTitles: true, interval: 1.0, reservedSize: 40.0, getTitlesWidget: bottomTitleWidgets,),),
        leftTitles: AxisTitles(axisNameSize: 28.0,
          sideTitles: SideTitles(showTitles: true, interval: 1.0, reservedSize: 42.0, getTitlesWidget: leftTitleWidgets,),),),
      borderData: FlBorderData(show: true, border: Border.all(color: Color(0xff37434d),),),
      minX: 0.0, maxX: item.length.toDouble(), minY: 0.0, maxY: maxValue1.toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: item, isCurved: false, barWidth: 1.0, isStrokeCapRound: false, dotData: FlDotData(show: true,
           getDotPainter: (spot, percent, barData, index) =>
            FlDotCirclePainter(radius: 2.0, color: Colors.blue, strokeWidth: 2.0, strokeColor: Colors.blue,),),
          belowBarData: BarAreaData(show: false,),),],);}

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16.0,);Widget text;
    switch (value.toInt()) {
      case 0:text =  Text('月', style: style);break;
      case 1:text =  Text('火', style: style);break;
      case 2:text =  Text('水', style: style);break;
      case 3:text =  Text('木', style: style);break;
      case 4:text =  Text('金', style: style);break;
      case 5:text =  Text('土', style: style);break;
      case 6:text =  Text('日', style: style);break;
      default:text =  Text('', style: style);break;
    }return SideTitleWidget(axisSide: meta.axisSide, child: text,);}

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 15.0,);
    String text;
    switch (value.toInt()) {
      case 1:text = '';break;
      case 3:text = '';break;
      case 10:text = '';//text = maxValue1.toString();
        break;
      default:return Container();}
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData2() {
    return LineChartData(
      lineTouchData: LineTouchData(handleBuiltInTouches: true, getTouchedSpotIndicator: defaultTouchedIndicators,
        touchTooltipData: LineTouchTooltipData(getTooltipItems: defaultLineTooltipItem, tooltipBgColor: Colors.white, tooltipRoundedRadius: 2.0,),),
      gridData: FlGridData(show: true, drawVerticalLine: true, horizontalInterval: 1.0, verticalInterval: 1.0,
        getDrawingHorizontalLine: (value) {return FlLine(color: Color(0xff37434d), strokeWidth: 1.0,);},
        getDrawingVerticalLine: (value) {return FlLine(color: Color(0xff37434d), strokeWidth: 1.0,);},
      ),
      titlesData: FlTitlesData(show: true, rightTitles: AxisTitles(), topTitles: AxisTitles(),
        bottomTitles: AxisTitles(
          axisNameWidget: const Text("[日]", style: TextStyle(color: Color(0xff68737d),),), axisNameSize: 22.0,
          sideTitles: SideTitles(showTitles: true, interval: 1.0, reservedSize: 40.0, getTitlesWidget: bottomTitleWidgets2,),),
        leftTitles: AxisTitles(axisNameSize: 28.0,
          sideTitles: SideTitles(showTitles: true, interval: 1.0, reservedSize: 42.0, getTitlesWidget: leftTitleWidgets,),),),
      borderData: FlBorderData(show: true, border: Border.all(color: Color(0xff37434d),),),
      minX: 0.0, maxX: item2.length.toDouble(), minY: 0.0, maxY: maxValue2.toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: item2, isCurved: false, barWidth: 1.0, isStrokeCapRound: false, dotData: FlDotData(show: true,
          getDotPainter: (spot, percent, barData, index) =>
              FlDotCirclePainter(radius: 2.0, color: Colors.blue, strokeWidth: 2.0, strokeColor: Colors.blue,),),
          belowBarData: BarAreaData(show: false,),),],);}

  Widget bottomTitleWidgets2(double value, TitleMeta meta) {
    const style = TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16.0,);Widget text;
    switch (value.toInt()) {
      case 0:text =  Text('1', style: style);break;
      case 6:text =  Text('7', style: style);break;
      case 13:text =  Text('14', style: style);break;
      case 20:text =  Text('21', style: style);break;
      case 27:text =  Text('28', style: style);break;
      case 30:text =  Text('31', style: style);break;
      default:text =  Text('', style: style);break;
    }return SideTitleWidget(axisSide: meta.axisSide, child: text,);}


  LineChartData mainData3() {
    return LineChartData(
      lineTouchData: LineTouchData(handleBuiltInTouches: true, getTouchedSpotIndicator: defaultTouchedIndicators,
        touchTooltipData: LineTouchTooltipData(getTooltipItems: defaultLineTooltipItem, tooltipBgColor: Colors.white, tooltipRoundedRadius: 2.0,),),
      gridData: FlGridData(show: true, drawVerticalLine: true, horizontalInterval: 1.0, verticalInterval: 1.0,
        getDrawingHorizontalLine: (value) {return FlLine(color: Color(0xff37434d), strokeWidth: 1.0,);},
        getDrawingVerticalLine: (value) {return FlLine(color: Color(0xff37434d), strokeWidth: 1.0,);},
      ),
      titlesData: FlTitlesData(show: true, rightTitles: AxisTitles(), topTitles: AxisTitles(),
        bottomTitles: AxisTitles(
          axisNameWidget: const Text("[月]", style: TextStyle(color: Color(0xff68737d),),), axisNameSize: 22.0,
          sideTitles: SideTitles(showTitles: true, interval: 1.0, reservedSize: 40.0, getTitlesWidget: bottomTitleWidgets3,),),
        leftTitles: AxisTitles(axisNameSize: 28.0,
          sideTitles: SideTitles(showTitles: true, interval: 1.0, reservedSize: 42.0, getTitlesWidget: leftTitleWidgets,),),),
      borderData: FlBorderData(show: true, border: Border.all(color: Color(0xff37434d),),),
      minX: 0.0, maxX: item3.length.toDouble(), minY: 0.0, maxY: maxValue3.toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: item3, isCurved: false, barWidth: 1.0, isStrokeCapRound: false, dotData: FlDotData(show: true,
          getDotPainter: (spot, percent, barData, index) =>
              FlDotCirclePainter(radius: 2.0, color: Colors.blue, strokeWidth: 2.0, strokeColor: Colors.blue,),),
          belowBarData: BarAreaData(show: false,),),],);}

  Widget bottomTitleWidgets3(double value, TitleMeta meta) {
    const style = TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16.0,);Widget text;
    switch (value.toInt()) {
      case 0:text =  Text('1', style: style);break;
      case 1:text =  Text('2', style: style);break;
      case 2:text =  Text('3', style: style);break;
      case 3:text =  Text('4', style: style);break;
      case 4:text =  Text('5', style: style);break;
      case 5:text =  Text('6', style: style);break;
      case 6:text =  Text('7', style: style);break;
      case 7:text =  Text('8', style: style);break;
      case 8:text =  Text('9', style: style);break;
      case 9:text =  Text('10', style: style);break;
      case 10:text =  Text('11', style: style);break;
      case 11:text =  Text('12', style: style);break;
      default:text =  Text('', style: style);break;
    }return SideTitleWidget(axisSide: meta.axisSide, child: text,);}

}