

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../AdManager.dart';
import 'dart:convert';
import '../V11/test3.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';


class CreateQAAdd extends StatefulWidget {
  CreateQAAdd(this.ID,this.ID2,this.name,this.Int,this.item);
  String ID;String ID2;String name;int Int;List item;
  @override
  State<CreateQAAdd> createState() => _CreateQAAddState();
}

class _CreateQAAddState extends State<CreateQAAdd> {
  var ID  = "";  var date = "";var Q = "";var A= "";var name = "";var text = "";
  var map = {};var mapD = {};var mapE = {};var mapN = {};var open = false;var level = "";
  var co = 0;var count = 0;
  var item = [];
  late TextEditingController _bodyController;late TextEditingController _bodyController2;late TextEditingController _bodyController3;late TextEditingController _bodyController4;late TextEditingController _bodyController5;
  final _tab = <Tab> [
    Tab( child:Text("自動生成",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
    Tab( child:Text("一つ",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
    Tab( child:Text("一括",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
    Tab( child:Text("csv",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
  ];

  String _recognizedText = "認識されたテキストが表示されます。";
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  late final GenerativeModel _model;
  bool _isLoading = false;


  Future<void> _initializeModel() async {
    try{final apiKey = dotenv.env['GEMINI_API_KEY']??"";  // YOUR_API_KEY を実際のAPIキーに置き換えてください。
    if (apiKey.isEmpty) {return;}
    _model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: apiKey);
    }catch(e){}}

  Future<void> _sendMessage(text0) async {showInterstitialAd();
  setState(() {_isLoading = true;});
  text0 = text0.replaceAll(",", "、");
  final text = "以下の文章から問題を8個以上作ってください。条件1:半角カンマで問題と答えを区切って交互に作ってください。条件2:問題文や答えに絶対に『 , 』を使わないでください。条件3:問題間も半角カンマで区切ってください。条件4:無駄な文章は入れないでください。条件5:問題文はなるべく?を使って疑問形にして。例は問題,答え,問題2,答え2,問題3,答え3,問題4,答え4,問題5,答え5,\n" + text0;
  if (text.isEmpty) return;
  _textController.clear(); // 入力欄をクリア
  setState(() {_messages.add(ChatMessage(sender: 'User', text: text));});
  try{
    final response = await _model.generateContent([Content.text(text)]);
    final geminiText = response.text ?? 'No response';
    main(geminiText);
    setState(() {_messages.add(ChatMessage(sender: 'Gemini', text: geminiText));});
  }catch(e){
    setState(() {_messages.add(ChatMessage(sender: 'Gemini', text: 'Error: $e'));});
  } finally {setState(() {_isLoading = false;});}
  }


  Future<void> recognizeText(String imagePath) async {
    final apiKey = dotenv.env['ML_API_KEY']??"";  // ここにAPIキーを入力
    final url = Uri.parse('https://vision.googleapis.com/v1/images:annotate?key=$apiKey');
    final imageBytes = File(imagePath).readAsBytesSync();
    final base64Image = base64Encode(imageBytes);
    final requestBody = json.encode({"requests": [{"image": {"content": base64Image,}, "features": [{"type": "TEXT_DETECTION",}]}]});

    try {final response = await http.post(url, headers: {"Content-Type": "application/json"}, body: requestBody,);
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      final textAnnotations = responseJson['responses'][0]['textAnnotations'];
      if (textAnnotations != null && textAnnotations.isNotEmpty) {
        final recognizedText = textAnnotations[0]['description'];
        setState(() {_recognizedText = recognizedText; _sendMessage(_recognizedText) ;      });
      } else {
        setState(() {_recognizedText = 'テキストが認識できませんでした。';});}} else {setState(() {_recognizedText = 'APIリクエストエラー: ${response.statusCode}';});}
    } catch (e) {setState(() {_recognizedText = 'エラーが発生しました: $e';});}
  }

  Future<void> _pickImageAndRecognizeText() async {interstitialAd();
  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {await recognizeText(pickedFile.path);} else {setState(() {_recognizedText = '画像が選択されませんでした。';});}}
  Future<void> _pickImageFromCamera() async {interstitialAd();
  final pickedFile = await _picker.pickImage(source: ImageSource.camera);
  if (pickedFile != null) {await recognizeText(pickedFile.path);} else {setState(() {_recognizedText = '画像が選択されませんでした。';});}}

  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
  void interstitialAd() {
    if (ID != "FAP3jZy3pSTEmqJQN1ow"){
      InterstitialAd.load(adUnitId: Platform.isAndroid ? 'ca-app-pub-4716152724901069/2563672557' : 'ca-app-pub-4716152724901069/7560014210',
        request: AdRequest(),//ca-app-pub-4716152724901069/7560014210
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {_interstitialAd = ad;_isAdLoaded = true;},
          onAdFailedToLoad: (error) {
            print('Interstitial ad failed to load: $error');},),);}}

  void showInterstitialAd() {
    if (_isAdLoaded) {_interstitialAd?.fullScreenContentCallback;_interstitialAd?.show();
    } else {print('Interstitial ad is not yet loaded.');}}
  @override
  FullScreenAdLoadErrorCallback get onAdFailedToLoad => throw UnimplementedError();
  @override
  GenericAdEventCallback<InterstitialAd> get onAdLoaded => throw UnimplementedError();

  void main(text) {
    final list2 = stringToList(text);["1","2","3","4"];
    for (int i = 0; i < list2.length ; i = i +2) {
      setState(() {item.add({"問題":list2[i],"答え":list2[i + 1]});});
    }_bodyController5.clear();text = "";
    Future.delayed(Duration(seconds: 5), () {interstitialAd();});//Navigator.pop(context);
    //Navigator.pop(context);
  }
  List<String> stringToList(String listAsString) {return listAsString.split(',').map<String>((String item) => item).toList();}




  void initState() {first();_initializeModel();interstitialAd();;
     super.initState();_bodyController = TextEditingController();_bodyController2 = TextEditingController();_bodyController3 = TextEditingController();_bodyController4 = TextEditingController();_bodyController5 = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,resizeToAvoidBottomInset: false,
      appBar: AppBar(backgroundColor: Colors.white,
        title:  Text(widget.name, style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold,fontSize:15,),textAlign: TextAlign.center,),
        centerTitle: true,elevation: 0,leading: IconButton(icon:  Icon(Icons.arrow_back_ios,color: Colors.blueGrey,), onPressed: () {Navigator.pop(context);},),
        actions: <Widget>[IconButton(onPressed: () {Edite();}, icon: Icon(Icons.edit_rounded,color: Colors.blueGrey[500],))],
      ),
        floatingActionButtonLocation:FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(backgroundColor: Colors.orange, child: const Icon(Icons.add),
          onPressed: () {AddView();},),
      body: GestureDetector( onTap: () => FocusScope.of(context).unfocus(),
        child:SingleChildScrollView(child:Container(color: Colors.white,
          child: Column(children: <Widget>[
              Container(height: 0,),
            Container(margin:EdgeInsets.only(top:10,bottom: 0),height:30,child:Row(mainAxisAlignment: MainAxisAlignment.center,children: [
              Container(child: Text("非公開にする",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,),),
              Switch(value: open, onChanged: (bool? value) {if (value != null) {setState(() {open = value;swi();});}},)])),

            Container( margin: EdgeInsets.all(25),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(),reverse: true, itemCount: item.length, itemBuilder: (context, index) {
                return GestureDetector(onTap: () {co = index;Q = item[index]["問題"];A = item[index]["答え"];_bodyController.text = Q;_bodyController2.text = A;delete();},
                    child: Card(elevation:0,color:Colors.white,child: Container(decoration: BoxDecoration( border: Border.all(color: Colors.black),color: Colors.white, borderRadius: BorderRadius.circular(5),),margin: EdgeInsets.all(0),
                        child:Column(children: [
                          Container(margin: EdgeInsets.only(top:5,right: 5),alignment: Alignment.centerRight,child:Icon(Icons.edit_rounded,color: Colors.blueGrey,size: 15,)),
                          Row(children: [
                            Container(alignment: Alignment.centerLeft,margin:EdgeInsets.only(top:15,left:15,right:15),child:Text("問題",style: TextStyle(color: Colors.blueGrey[500],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                            Expanded(child: Container(alignment: Alignment.centerLeft,margin:EdgeInsets.only(top:10),child:Text(item[index]["問題"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900]),),)),],),
                          Divider(color: Colors.blueGrey,thickness: 1,indent: 20,endIndent: 20,),
                          Container(alignment: Alignment.centerLeft,margin:EdgeInsets.only(bottom: 20),child:Row(children: [Container(alignment: Alignment.centerLeft,margin:EdgeInsets.only(left:15,right:15),child:Text("答え",style: TextStyle(color: Colors.blueGrey[500],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                            Expanded(child: Text(item[index]["答え"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900]),),),]))
                        ]))));},),),
            ],),),)));}

  void first () async {count = widget.item[widget.Int]["秒数"];open = widget.item[widget.Int]["公開"];level = widget.item[widget.Int]["レベル"];name = widget.name;
    FirebaseFirestore.instance.collection('users').doc(widget.ID).collection("問題集").where("ID" ,isEqualTo: widget.ID2).get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {setState(() {item = doc["問題"];});;});});}

  Future<void> send() async {
    if (Q != "" && A != ""){
      map = {"問題":Q,"答え":A};item.insert(item.length,map);
      DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(widget.ID).collection("問題集").doc(widget.ID2);
      ref.update({"問題" : FieldValue.arrayUnion([map]),});setState(() {Q= "";A= "";_bodyController.clear();_bodyController2.clear();_bodyController3.clear();_bodyController4.clear();});
    }}

  Future<void> delete() async {
    showDialog(context: context, builder: (context) => WillPopScope(
      child:  AlertDialog(
        content: Container(child:
        SingleChildScrollView(child:Column(children: [
          Container(width: double.infinity,child:Text("編集",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
          Divider(color: Colors.blueGrey,thickness: 3,indent: 170,endIndent: 170,),
          Container(alignment: Alignment.center,margin:EdgeInsets.only(),child:Text("問題",style: TextStyle(color: Colors.blueGrey[900],fontSize: 15), textAlign: TextAlign.center),),
          Container(width: double.infinity,margin:EdgeInsets.all(5), decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5),),
            child: TextField(keyboardType: TextInputType.multiline, maxLines: null,controller: _bodyController,decoration: InputDecoration(border: InputBorder.none, hintText: Q,),onChanged: (String value) {setState(() {Q = value;});},),),
          Container(alignment: Alignment.center,margin:EdgeInsets.only(),child:Text("答え",style: TextStyle(color: Colors.blueGrey[900],fontSize: 15), textAlign: TextAlign.center),),
          Container(width: double.infinity,margin:EdgeInsets.all(5), decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5),),
            child: TextField(keyboardType: TextInputType.multiline, maxLines: null,controller: _bodyController2,decoration: InputDecoration(border: InputBorder.none, hintText: A,),onChanged: (String value) {setState(() {A = value;});},),),
          Container(margin :EdgeInsets.all(10),width:100,child: ElevatedButton(child: Text('変更'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, shape: const StadiumBorder(),),
            onPressed: () {DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(widget.ID).collection("問題集").doc(widget.ID2);
            setState(() {mapE = {"問題":Q,"答え":A};item[co] = mapE;Q= "";A= "";_bodyController.clear();_bodyController2.clear();}); ref.update({"問題" : item,});Navigator.pop(context);},)),

          Divider(color: Colors.blueGrey,thickness: 1,),
          Container(margin:EdgeInsets.all(15),width: double.infinity,child:Text("削除しますか?",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Container(margin :EdgeInsets.only(),width:100,child: ElevatedButton(child: Text('はい'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: const StadiumBorder(),),
              onPressed: () {DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(widget.ID).collection("問題集").doc(widget.ID2);
              setState(() {item.removeAt(co);}); ref.update({"問題" : item,});Navigator.pop(context);},)),
          ],)
        ],)),),
    ),onWillPop: () async {setState(() {Q= "";A= "";_bodyController.clear();_bodyController2.clear();});return true;
    }),);
  }

  Future<void> Edite() async {
    showDialog(context: context, builder: (context) => WillPopScope(
        child:  AlertDialog(
          content: Container(child:
          SingleChildScrollView(child:Column(children: [
            Container(width: double.infinity,child:Text("タイトルの編集",style: TextStyle(color: Colors.blueGrey[900],fontSize: 15), textAlign: TextAlign.center),),
            //Divider(color: Colors.blueGrey,thickness: 3,indent: 170,endIndent: 170,),
            // Container(alignment: Alignment.center,margin:EdgeInsets.only(left:0),child:Text(widget.name ,style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
            // Container(alignment: Alignment.center,margin:EdgeInsets.only(left:0),child:Text("↓" ,style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
            Container(width: double.infinity,margin:EdgeInsets.all(5), decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5),),
              child: TextField(keyboardType: TextInputType.multiline, maxLines: null,controller: _bodyController3,decoration: InputDecoration(border: InputBorder.none, hintText: widget.name),onChanged: (String value) {setState(() {name = value;});},),),

            Container(margin:EdgeInsets.only(top:20),width: double.infinity,child:Text("表示までの秒数",style: TextStyle(color: Colors.blueGrey[900],fontSize: 15), textAlign: TextAlign.center),),
            // Container(alignment: Alignment.center,margin:EdgeInsets.only(left:0),child:Text(count.toString()+"秒" ,style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
            // Container(alignment: Alignment.center,margin:EdgeInsets.only(left:0),child:Text("↓" ,style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
            Container(width: double.infinity,margin:EdgeInsets.all(5), decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5),),
              child: TextField(keyboardType: TextInputType.numberWithOptions(), maxLines: null,controller: _bodyController4,decoration: InputDecoration(border: InputBorder.none, hintText: count.toString(),),onChanged: (String value) {setState(() {count = int.parse(value);});},),),

              Container(margin :EdgeInsets.only(top:20),width:100,child: ElevatedButton(child: Text('変更'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: const StadiumBorder(),),
              onPressed: () {
                var OpenName = widget.item[widget.Int]["name"];var OpenCount = widget.item[widget.Int]["秒数"];
                widget.item[widget.Int] = {"UID":widget.ID,"QID":widget.ID2,"name":name,"カテゴリー":widget.item[widget.Int]["カテゴリー"],"秒数":count,"公開":open,"レベル":level};
                DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(widget.ID);
                setState(() {}); ref.update({"問題集2" : widget.item,});
                DocumentReference ref1 = FirebaseFirestore.instance.collection('問題集').doc("問題集");
                if(open == false){
                  ref1.update({"問題集" : FieldValue.arrayRemove([{"UID":widget.ID,"QID":widget.ID2,"name":widget.name,"カテゴリー":widget.item[widget.Int]["カテゴリー"],"秒数":OpenCount,"公開":open,"レベル":level}]),});
                  ref1.update({"問題集" : FieldValue.arrayUnion([widget.item[widget.Int]]),});}
                Navigator.pop(context);widget.name = name;},)),
          ],)),),
        ),onWillPop: () async {setState(() {});return true;
    }),);
  }
 void swi(){
    var map = {"UID":widget.ID,"QID":widget.ID2,"name":widget.name,"カテゴリー":widget.item[widget.Int]["カテゴリー"],"秒数":count,"公開":open,"レベル":level};
  widget.item[widget.Int] = map;print(widget.ID);print(widget.item);
  DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(widget.ID);
  setState(() {}); ref.update({"問題集2" : widget.item,});widget.name = name;

    var map1 = {"UID":widget.ID,"QID":widget.ID2,"name":widget.name,"カテゴリー":widget.item[widget.Int]["カテゴリー"],"秒数":count,"公開":false,"レベル":level};
    DocumentReference ref1 = FirebaseFirestore.instance.collection('問題集').doc("問題集");
    if(open == false){ref1.update({"問題集" : FieldValue.arrayUnion([map1]),});
    }else{ref1.update({"問題集" : FieldValue.arrayRemove([map1]),});}
  }

  void AddView() {
    showModalBottomSheet(isScrollControlled: true,context: context,backgroundColor: Colors.white,
      shape:   RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) { return StatefulBuilder(builder: (context, StateSetter setState) {
        return  Container(height:  350 +MediaQuery.of(context).viewInsets.bottom,decoration: BoxDecoration(color: Colors.white,  borderRadius: BorderRadius.vertical(top: Radius.circular(0.0),), boxShadow: [new BoxShadow(color: Colors.grey, offset: new Offset(1.0, 1.0), blurRadius: 3.0, spreadRadius: 1)],),
            //decoration: BoxDecoration( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
            child:DefaultTabController(length: _tab.length, child: Scaffold(backgroundColor:Colors.white,appBar: PreferredSize(preferredSize: Size.fromHeight(56.0), child:  TabBar(isScrollable: false,tabs: _tab),),
        body: TabBarView(children: <Widget> [
                    Container(child:Column(children: [
                      Container(margin: EdgeInsets.only(top:50),alignment: Alignment.center,child:Text("画像から問題を自動生成\n教科書やプリントから問題を作ってみましょう\n作成中CM流れます",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 12), textAlign: TextAlign.center),),
                      Container( margin: EdgeInsets.only(top:10),child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [ElevatedButton.icon(onPressed:  _pickImageAndRecognizeText,icon: Icon(Icons.photo_library), label: Text("アルバム"),), ElevatedButton.icon(onPressed: _pickImageFromCamera, icon: Icon(Icons.camera_alt), label: Text("カメラ"),),],)),
                    ])),
                    GestureDetector(behavior: HitTestBehavior.opaque,
                        onTap: () => FocusScope.of(context).unfocus(), child:SingleChildScrollView(child:Column(children: <Widget>[Container(height: 20,),
                          Container(alignment: Alignment.center,margin:EdgeInsets.only(),child:Text("問題",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                          Container(width: double.infinity,margin:EdgeInsets.only(top:10,bottom: 10,left: 20,right: 20), decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5),),
                            child: TextField(style: TextStyle(color: Colors.black,),keyboardType: TextInputType.multiline, maxLines: null,controller: _bodyController3,decoration: InputDecoration(border: InputBorder.none,),onChanged: (String value) {setState(() {Q = value;});},),),
                          Container(alignment: Alignment.center,margin:EdgeInsets.only(),child:Text("答え",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                          Container(width: double.infinity,margin:EdgeInsets.only(top:10,bottom: 10,left: 20,right: 20),
                            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5),),
                            child: TextField(style: TextStyle(color: Colors.black,),keyboardType: TextInputType.multiline, maxLines: null,controller: _bodyController4,decoration: InputDecoration(border: InputBorder.none,),onChanged: (String value) {setState(() {A = value;});},),),
                          Container(margin : EdgeInsets.only(top:10,bottom: 30,left: 20,right: 20),child: ElevatedButton(child: Text("追加"), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, shape: const StadiumBorder(),),
                              onPressed: () async {send();FocusScope.of(context).requestFocus(new FocusNode());Navigator.pop(context);})),

                        ],))),
                 GestureDetector(behavior: HitTestBehavior.opaque,
                  onTap: () => FocusScope.of(context).unfocus(), child:SingleChildScrollView(child:Column(children: [
                      Container(alignment: Alignment.center,margin:EdgeInsets.only(top:20),child:Text("『 , 』で区切った文章を一括で追加",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center),),
                      Container(alignment: Alignment.center,margin:EdgeInsets.only(),child:Text("例：りんご,apple,みかん,orange,ぶどう,grapes",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center),),
                      Container(alignment: Alignment.center,margin:EdgeInsets.only(),child:Text("注意：カンマは半角。文章のカンマは全角で。問→答の順で数が合うように",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center),),
                      Container(width: double.infinity,margin:EdgeInsets.only(top:50,bottom: 10,left: 20,right: 20), decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5),),
                        child: TextField(style: TextStyle(color: Colors.black,),keyboardType: TextInputType.multiline, maxLines: null,controller: _bodyController5,decoration: InputDecoration(border: InputBorder.none,),onChanged: (String value) {setState(() {text = value;});},),),
                      Container(margin : EdgeInsets.only(top:10,bottom: 30,left: 20,right: 20),child: ElevatedButton(child: Text("追加"), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, shape: const StadiumBorder(),),
                          onPressed: () async {main(text);}))],)),),

                    Container(child:Column(children: [
                      Container(alignment: Alignment.center,margin:EdgeInsets.only(top:20),child:Text("ExcelやNumbersでリストを一括で追加",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center),),
                      Container(alignment: Alignment.center,margin:EdgeInsets.only(top:0),child:Text("csvに変換してファイルに保存",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center),),
                      Container(child: TextButton(onPressed: () {
                        showDialog(context: context, builder: (context) => AlertDialog(content: Container(child:Image.asset("images/例.jpg")),),);
                      }, child: Text("例"),),),
                      Container(margin : EdgeInsets.only(top:10,bottom: 30,left: 20,right: 20),child: ElevatedButton(child: Text("ファイルを開く"), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, shape: const StadiumBorder(),),
                          onPressed: () async {_pickAndLoadCsv();})),
                    ]))
                  ]),)));});}, );}

  Future<void> _pickAndLoadCsv() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom, allowedExtensions: ['csv'],);
    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      String content = await file.readAsString();_parseCsv(content);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ファイルの選択がキャンセルされました。')),);}}
  void _parseCsv(String content) {
    List<String> lines = content.split('\n');
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim();
      if (line.isEmpty) continue; // 空行をスキップ
      List<String> parts = line.split(',');
      if (parts.length < 2) continue; // 不完全な行をスキップ
      try {item.add({"問題":parts[0].trim(),"答え":parts[1].trim()});
      } catch (e) {continue;}}
    setState(() {
      DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(widget.ID).collection("問題集").doc(widget.ID2);ref.update({"問題" : item,});
    Navigator.pop(context);});
  }

  // void main() {
  //   final list2 = stringToList(text);["1","2","3","4"];
  //   print('String（カンマ区切り）→List<int>');//a,aa,b,bb,c,cc,d,dd,aa
  //   print(list2.runtimeType);
  //   print(list2);
  //   for (int i = 0; i < list2.length ; i = i +2) {
  //     setState(() {item.add({"問題":list2[i],"答え":list2[i + 1]});});
  //     print(i);
  //   }_bodyController5.clear();text = "";
  //   DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(widget.ID).collection("問題集").doc(widget.ID2);
  //   ref.update({"問題" : item,});
  //   Navigator.pop(context);
  // }
  // List<String> stringToList(String listAsString) {return listAsString.split(',').map<String>((String item) => item).toList();}



}