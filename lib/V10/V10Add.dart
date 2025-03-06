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



class V10Add extends StatefulWidget {
  V10Add(this.GID,this.co);
  String GID;int co;
  @override
  State<V10Add> createState() => _V10AddState();
}

class _V10AddState extends State<V10Add> {
  var Qmap = {}; var Umap = {};var mapE = {};
  var id = "";var date = "";var name = "";var category = "カテゴリー";var swi = false;var text = "";
  var co = 0;var select = 0;var count = 2;var Q = "";var A = "";var grade = "レベル";
  late TextEditingController _bodyController; late TextEditingController _bodyController2; late TextEditingController _bodyController3;late TextEditingController _bodyController4;late TextEditingController _bodyController5;
  var item = [];
  var isOn = false;var ID  = "";
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



  void initState() {_initializeModel();interstitialAd();;
  super.initState();first();_bodyController = TextEditingController();_bodyController2 = TextEditingController();_bodyController3 = TextEditingController();_bodyController4 = TextEditingController();_bodyController5 = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return   GestureDetector(onTap: () => primaryFocus?.unfocus(),child:Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
        actions: [TextButton(onPressed: () {if(widget.co == 0){send();}else{send2();}}, child: Text("保存",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.orange,fontSize: 20),textAlign: TextAlign.center,),)],
      ),
      floatingActionButtonLocation:FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.orange, child: const Icon(Icons.add),
        onPressed: () {AddView();},),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(padding: EdgeInsets.symmetric(horizontal: 10.0,),margin: EdgeInsets.only(top:10,left: 30,right: 30,bottom: 10),width:double.infinity,height:50,
            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5),),
            child: TextField(controller: _bodyController,decoration: InputDecoration(border: InputBorder.none,hintText: "タイトル"),onChanged: (String value) {setState(() {name = value;});},),),
          Container(padding: EdgeInsets.symmetric(horizontal: 10.0,),margin: EdgeInsets.only(top:10,left: 30,right: 30,bottom: 10),width:double.infinity,height:50,
            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5),),
            child: TextField(keyboardType: TextInputType.numberWithOptions(decimal: true),controller: _bodyController2,decoration: InputDecoration(border: InputBorder.none,hintText: "解答表示までの秒数(2秒)"),onChanged: (String value) {setState(() {count = int.parse(value);});},),),

          Container(child: item.length == 0 ?
          Container(width: double.infinity,margin:EdgeInsets.only(top:100,left:15,right:15),child:Text("最低5つ問題を作りましょう\n↓",style: TextStyle(color: Colors.blueGrey[500],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),):
          Container( margin: EdgeInsets.all(30),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(), itemCount: item.length, itemBuilder: (context, index) {
            return GestureDetector(onTap: () {co = index;Q = item[index]["問題"];A = item[index]["答え"];_bodyController3.text = Q;_bodyController4.text = A;delete();},
                child: Card(elevation:0,color:Colors.white,child: Container(decoration: BoxDecoration( border: Border.all(color: Colors.black),color: Colors.white, borderRadius: BorderRadius.circular(5),),margin: EdgeInsets.all(0),
                    child:Column(children: [
                      Container(margin: EdgeInsets.only(top:5,right: 5),alignment: Alignment.centerRight,child:Icon(Icons.edit_rounded,color: Colors.blueGrey,size: 15,)),
                      Row(children: [
                        Container(alignment: Alignment.centerLeft,margin:EdgeInsets.only(top:15,left:15,right:15),child:Text("問題",style: TextStyle(color: Colors.blueGrey[500],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                        Expanded(child: Container(alignment: Alignment.centerLeft,margin:EdgeInsets.only(top:10),child:Text(item[index]["問題"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900]),),)),],),
                      Divider(color: Colors.blueGrey,thickness: 1,indent: 20,endIndent: 20,),
                      Container(alignment: Alignment.centerLeft,margin:EdgeInsets.only(bottom: 20),child:Row(children: [Container(alignment: Alignment.centerLeft,margin:EdgeInsets.only(left:15,right:15),child:Text("答え",style: TextStyle(color: Colors.blueGrey[500],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                        Expanded(child: Text(item[index]["答え"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900]),),),]))
                    ]))));},),))
        ],),),));
  }


  Future<void> send() async {
    var QID = randomString(20);
    if (name != "" && item.length >4 ){
      //UID
      Umap = {"UID":ID,"QID":QID,"name":name,"カテゴリー":category,"秒数":count,"公開":isOn,"レベル":grade};
      DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(ID);
      ref.update({"問題集2": FieldValue.arrayUnion([Umap]),});
      //QID
      DocumentReference ref2 = FirebaseFirestore.instance.collection('users').doc(ID).collection("問題集").doc(QID);
      ref2.set({"問題" : item,"ID":QID});

      var map = {"UID":ID,"QID":QID,"name":name,"カテゴリー":category,"秒数":count,"公開":isOn,"レベル":grade};
      DocumentReference ref3 = FirebaseFirestore.instance.collection('教材').doc(widget.GID);
      ref3.update({"教材" : FieldValue.arrayUnion([map]),});


      Navigator.pop(context);
    }
    if(name == ""){showDialog(context: context, builder: (context) => AlertDialog(content: Container(child:Text("タイトルが入力されていません",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,)),),);};
    if(item.length < 5){showDialog(context: context, builder: (context) => AlertDialog(content: Container(child:Text("最低5つ問題を作りましょう",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,)),),);};
  }

  Future<void> send2() async {
    var QID = randomString(20);
    if (name != "" )
      //   && category != "カテゴリー"  &&  grade != "レベル" && item.length >4 )
        {
      //UID
      Umap = {"UID":ID,"QID":QID,"name":name,"カテゴリー":category,"秒数":count,"公開":isOn,"レベル":grade};
      DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(ID);
      ref.update({"問題集2": FieldValue.arrayUnion([Umap]),});
      //QID
      DocumentReference ref2 = FirebaseFirestore.instance.collection('users').doc(ID).collection("問題集").doc(QID);
      ref2.set({"問題" : item,"ID":QID});
      //公開
      // if(isOn == false){
      //   DocumentReference ref3 = FirebaseFirestore.instance.collection('問題集').doc("問題集");
      //   ref3.update({"問題集": FieldValue.arrayUnion([Umap]),});;
      // }
      Navigator.pop(context);
    }
    if(name == ""){showDialog(context: context, builder: (context) => AlertDialog(content: Container(child:Text("タイトルが入力されていません",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,)),),);};
    // if(category == "カテゴリー"){showDialog(context: context, builder: (context) => AlertDialog(content: Container(child:Text("カテゴリーが選択されていません",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,)),),);};
    // if(grade == "レベル"){showDialog(context: context, builder: (context) => AlertDialog(content: Container(child:Text("大体のレベルを選択してください",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,)),),);};
    if(item.length < 5){showDialog(context: context, builder: (context) => AlertDialog(content: Container(child:Text("最低5つ問題を作りましょう",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,)),),);};
  }

  Future<void> add() async {
    if ( Q != "" && A != ""){
      Qmap = {"問題":Q,"答え":A};item.add(Qmap);
      setState(() {Q= "";A= "";_bodyController3.clear();_bodyController4.clear();});
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
              child: TextField(keyboardType: TextInputType.multiline, maxLines: null,controller: _bodyController3,decoration: InputDecoration(border: InputBorder.none, hintText: Q,),onChanged: (String value) {setState(() {Q = value;});},),),
            Container(alignment: Alignment.center,margin:EdgeInsets.only(),child:Text("答え",style: TextStyle(color: Colors.blueGrey[900],fontSize: 15), textAlign: TextAlign.center),),
            Container(width: double.infinity,margin:EdgeInsets.all(5), decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5),),
              child: TextField(keyboardType: TextInputType.multiline, maxLines: null,controller: _bodyController4,decoration: InputDecoration(border: InputBorder.none, hintText: A,),onChanged: (String value) {setState(() {A = value;});},),),
            Container(margin :EdgeInsets.all(10),width:100,child: ElevatedButton(child: Text('変更'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, shape: const StadiumBorder(),),
              onPressed: () {DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(ID).collection("問題集").doc(ID);
              setState(() {mapE = {"問題":Q,"答え":A};item[co] = mapE;Q= "";A= "";_bodyController3.clear();_bodyController4.clear();}); Navigator.pop(context);},)),

            Divider(color: Colors.blueGrey,thickness: 1,),
            Container(margin:EdgeInsets.all(15),width: double.infinity,child:Text("削除しますか?",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
            Row(mainAxisAlignment: MainAxisAlignment.center,children: [
              Container(margin :EdgeInsets.only(),width:100,child: ElevatedButton(child: Text('はい'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: const StadiumBorder(),),
                onPressed: () {DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(ID).collection("問題集").doc(ID);
                setState(() {item.removeAt(co);}); ref.update({"問題" : item,});Navigator.pop(context);},)),
            ],)
          ],)),),
        ),onWillPop: () async {setState(() {Q= "";A= "";_bodyController3.clear();_bodyController4.clear();});return true;
    }),);
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
                              onPressed: () async {add();FocusScope.of(context).requestFocus(new FocusNode());Navigator.pop(context);})),

                        ],))),
                    GestureDetector(behavior: HitTestBehavior.opaque,
                        onTap: () => FocusScope.of(context).unfocus(), child:SingleChildScrollView(child:Column(children: [
                          Container(alignment: Alignment.center,margin:EdgeInsets.only(top:20),child:Text("『 , 』で区切った文章を一括で追加",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center),),
                          Container(alignment: Alignment.center,margin:EdgeInsets.only(),child:Text("例：りんご,apple,みかん,orange,ぶどう,grapes",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center),),
                          Container(alignment: Alignment.center,margin:EdgeInsets.only(),child:Text("注意：カンマは半角。文章のカンマは全角で。問→答の順で数が合うように。",style: TextStyle(color: Colors.blueGrey[400],fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center),),
                          Container(width: double.infinity,margin:EdgeInsets.only(top:50,bottom: 10,left: 20,right: 20), decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5),),
                            child: TextField(style: TextStyle(color: Colors.black,),keyboardType: TextInputType.multiline, maxLines: null,controller: _bodyController5,decoration: InputDecoration(border: InputBorder.none,),onChanged: (String value) {setState(() {text = value;});},),),
                          Container(margin : EdgeInsets.only(top:10,bottom: 30,left: 20,right: 20),child: ElevatedButton(child: Text("追加"), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, shape: const StadiumBorder(),),
                              onPressed: () async {main(text);}))],),)),

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
    setState(() {Navigator.pop(context);});
  }

  void main(text) {
  final list2 = stringToList(text);["1","2","3","4"];
    for (int i = 0; i < list2.length ; i = i +2) {
      setState(() {item.add({"問題":list2[i],"答え":list2[i + 1]});});
    }_bodyController5.clear();text = "";
   Future.delayed(Duration(seconds: 5), () {interstitialAd();});//Navigator.pop(context);
    //Navigator.pop(context);
  }
  List<String> stringToList(String listAsString) {return listAsString.split(',').map<String>((String item) => item).toList();}



  void SearchShow() {
    showModalBottomSheet(isScrollControlled: false,context: context,backgroundColor: Colors.white,
        shape:  const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
        builder: (context) { return  Container(child:SingleChildScrollView(
            child: Column(children: <Widget>[
              SizedBox(height: 30,),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { category = "英語";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("英語",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "数学";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("数学",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "国語";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("国語",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "漢字";setState(() {Navigator.pop(context);});},
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("漢字",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "古文";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("古文",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "漢文単語";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("漢文単語",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "社会"; setState(() {Navigator.pop(context);});},
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("社会",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "世界史";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("世界史",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "日本史";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("日本史",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "理科";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("理科",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "生物";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("生物",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "化学";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("化学",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "物理";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("物理",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {category = "その他";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("その他",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              //   Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () {name = "リセット";setState(() {widget.item = item0;}); },
              //     child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("リセット",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
            ],)),);});}

  void grade1() {
    showModalBottomSheet(isScrollControlled: false,context: context,backgroundColor: Colors.white,
        shape:  const RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
        builder: (context) { return  Container(child:SingleChildScrollView(
            child: Column(children: <Widget>[
              SizedBox(height: 30,),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { grade = "小学生";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("小学生",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { grade = "中1";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("中1",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { grade = "中2";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("中2",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { grade = "中3";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("中3",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { grade = "高1";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("高1",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { grade = "高2";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("高2",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { grade = "高3";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("高3",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { grade = "大学";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("大学",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
              Container(margin: EdgeInsets.all(10),child:GestureDetector(onTap: () { grade = "その他";setState(() {Navigator.pop(context);}); },
                child: Container(margin: EdgeInsets.all(10),width:double.infinity,child:Text("その他",style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center),),),),
            ],)),);});}

  String randomString(int length) {
    const _randomChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    const _charsLength = _randomChars.length;
    final rand = new Random();
    final codeUnits = new List.generate(
      length, (index) {
      final n = rand.nextInt(_charsLength);
      return _randomChars.codeUnitAt(n);
    },);return new String.fromCharCodes(codeUnits);
  }

  void first() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ID = prefs.getString("ID") ?? "";}
}


class V10AddLast extends StatefulWidget {
  V10AddLast(this.GID);
  String GID;
  @override
  State<V10AddLast> createState() => _V10AddLastState();
}
class _V10AddLastState extends State<V10AddLast> {
  var map = {};var mapD = {};var ID = "";
  var date = "";var name = "";
  var co = 0;var select = 0;
  var item = [];

  void initState() {
    super.initState();first ();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
        // title: FittedBox(fit: BoxFit.fitWidth, child: Text("Create", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20), textAlign: TextAlign.center,),),
        iconTheme: IconThemeData(color: Colors.black), centerTitle: true,
        elevation: 0,
        actions: [],),
      body: SingleChildScrollView(
        child: Column(children: [
          // Container(margin: EdgeInsets.all(0), alignment: Alignment.center, child: Text("問題を作成", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 10), textAlign: TextAlign.center,),),
          Container(margin: EdgeInsets.all(20),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(), itemCount: item.length, itemBuilder: (context, index) {
            return GestureDetector(onTap: () {attention(index);},
                child: Container(margin: EdgeInsets.all(5),color: Colors.grey[200],child:Column(children: [
                  Container(margin: EdgeInsets.all(20),width:double.infinity,child:Text(item[index]["name"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
                ],), )    );},),),
          SizedBox(height: 35,)],),),);
  }

  void first () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();ID = prefs.getString("ID") ?? "";
    FirebaseFirestore.instance.collection('users').where("ID" ,isEqualTo: ID).get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {setState(() {item = doc["問題集2"];});;});});}

  void attention(index){showDialog(context: context, builder: (context) => AlertDialog(content: Container(height:200,child:Column(mainAxisAlignment:MainAxisAlignment.center,children: [
    Center(child:Text("『"+ item[index]["name"]+ "』"+ "を追加しますか?",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900],fontSize: 15),textAlign: TextAlign.center,)),
    Container(margin :EdgeInsets.only(top:10),width:100,child: ElevatedButton(
      child: Text('はい'), style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey[900], foregroundColor: Colors.white, shape: const StadiumBorder(),),
      onPressed: () {
        var map = {"UID":item[index]["UID"],"QID":item[index]["QID"],"name":item[index]["name"],"カテゴリー":item[index]["カテゴリー"],"秒数":item[index]["秒数"],"公開":item[index]["公開"],"レベル":item[index]["レベル"]};
        DocumentReference ref2 = FirebaseFirestore.instance.collection('教材').doc(widget.GID);
        ref2.update({"教材" : FieldValue.arrayUnion([map]),});

        Navigator.pop(context);
      },)),],))));}

}


