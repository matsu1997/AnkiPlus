import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:anki/V11/test3.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cloud Vision OCR',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TextRecognitionScreen(),
    );
  }
}

class TextRecognitionScreen extends StatefulWidget {
  @override
  _TextRecognitionScreenState createState() => _TextRecognitionScreenState();
}

class _TextRecognitionScreenState extends State<TextRecognitionScreen> {
  var ID  = "";  var date = "";var Q = "";var A= "";var name = "";var text = "";
  var map = {};var mapD = {};var mapE = {};var mapN = {};var open = false;var level = "";
  var co = 0;var count = 0;
  var item = [];
  String _recognizedText = "認識されたテキストが表示されます。";
  final ImagePicker _picker = ImagePicker();
  late TextEditingController _bodyController;late TextEditingController _bodyController2;late TextEditingController _bodyController3;late TextEditingController _bodyController4;late TextEditingController _bodyController5;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  late final GenerativeModel _model;
  bool _isLoading = false;


  Future<void> _initializeModel() async {
    try{final apiKey = dotenv.env['GEMINI_API_KEY']??"";  // YOUR_API_KEY を実際のAPIキーに置き換えてください。
    if (apiKey.isEmpty) {log('API_KEY is not set!');return;}
    _model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: apiKey);
    }catch(e){log('Error during model initialization: $e');}}

  Future<void> _sendMessage(text0) async {
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
      log('Error while generating content: $e');
    } finally {setState(() {_isLoading = false;});}}


  // 画像からテキストを認識するメソッド
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

  Future<void> _pickImageAndRecognizeText() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {await recognizeText(pickedFile.path);} else {setState(() {_recognizedText = '画像が選択されませんでした。';});}}
  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {await recognizeText(pickedFile.path);} else {setState(() {_recognizedText = '画像が選択されませんでした。';});}}


  void main(text) {
    final list2 = stringToList(text);
    for (int i = 0; i < list2.length ; i = i +2) {setState(() {item.add({"問題":list2[i],"答え":list2[i + 1]});});
    }_bodyController5.clear();text = "";}
  List<String> stringToList(String listAsString) {return listAsString.split(',').map<String>((String item) => item).toList();}

  void initState() {
    super.initState(); _initializeModel();_bodyController = TextEditingController();_bodyController2 = TextEditingController();_bodyController3 = TextEditingController();_bodyController4 = TextEditingController();_bodyController5 = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cloud Vision OCR'),
        actions: <Widget>[
          Row(children: [
            IconButton(onPressed: () {print(item);}, icon: Icon(Icons.person_3_outlined,color:Colors.blueGrey[300],))
          ],)],
      ),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Container( height:70,margin: EdgeInsets.all(25),child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed:  _pickImageAndRecognizeText,
                  icon: Icon(Icons.photo_library),
                  label: Text("アルバム"),
                ),
                ElevatedButton.icon(
                  onPressed: _pickImageFromCamera,
                  icon: Icon(Icons.camera_alt),
                  label: Text("カメラ"),
                ),
              ],
            )),

            SizedBox(height: 20),
            SizedBox(height: 10),
            Container( margin: EdgeInsets.all(25),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(), itemCount: item.length, itemBuilder: (context, index) {
              return GestureDetector(onTap: () {co = index;Q = item[index]["問題"];A = item[index]["答え"];},
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
            // Container(height: 300,
            //   child: ListView.builder(
            //     itemCount: 1,
            //     itemBuilder: (context, index) {
            //       return Padding(
            //         padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
            //         child: Text(
            //           _messages[1],
            //           style: TextStyle(fontSize: 16.0),
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}






//
//
// import 'dart:convert';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
//
//
// class App extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Cloud Vision OCR',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: TextRecognitionScreen(),
//     );
//   }
// }
//
// class TextRecognitionScreen extends StatefulWidget {
//   @override
//   _TextRecognitionScreenState createState() => _TextRecognitionScreenState();
// }
//
// class _TextRecognitionScreenState extends State<TextRecognitionScreen> {
//   var ID  = "";  var date = "";var Q = "";var A= "";var name = "";var text = "";
//   var map = {};var mapD = {};var mapE = {};var mapN = {};var open = false;var level = "";
//   var co = 0;var count = 0;
//   var item = [];
//   String _recognizedText = "認識されたテキストが表示されます。";
//   final ImagePicker _picker = ImagePicker();
//   late TextEditingController _bodyController;late TextEditingController _bodyController2;late TextEditingController _bodyController3;late TextEditingController _bodyController4;late TextEditingController _bodyController5;
//   final TextEditingController _controller = TextEditingController();
//   final List<String> _messages = [];
//   var apiKey = 'sk-svcacct-RyObuPYQpF_gX2rvKT-_qJzTznrFWbsEZUakpitVd3CIllblVHX2_aH9W4g0DT3BlbkFJvYQliHakE3TkoNWCbNy42vfbqGVtscSl5PJ-mpzjXYwZTuttAMz4qxV0NPaAQA';
//
//   Future<void> _sendMessage(String userInput) async {
//     final url = 'https://api.openai.com/v1/chat/completions';
//
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json; charset=utf-8',
//           'Authorization': 'Bearer $apiKey',
//         },
//         body: json.encode({
//           "model": "gpt-3.5-turbo-16k",
//           "messages": [
//             {"role": "user", "content": userInput}
//           ]
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         final decodedResponse = utf8.decode(response.bodyBytes); // UTF-8デコード
//         final data = json.decode(decodedResponse);
//         final chatResponse = data['choices'][0]['message']['content'];
//
//         setState(() {
//           _messages.add('User: $userInput');
//           _messages.add(chatResponse);
//           print("chatResponse:"+chatResponse);
//           String result = chatResponse.replaceAll("問い", "");
//           result = result.replaceAll("[", "(");
//           result = result.replaceAll("]", ")");
//           result = result.replaceAll(",", "、");
//         _sendMessage2("以下の文章から問題を[問題,答え],のようにDartのリスト型を10個以上作ってください。絶対条件は 1:問いと答えを半角カンマで区切る。2:無駄な文章は入れない。3:問題は疑問形で。4:問題と答えの文章に半角カンマは使わない。5:作成後に条件に合っているか見直してから出力してください。例は　[問い,答え],[問い2,答え2],[問い3,答え3],[問い4,答え4],[問い5,答え5]" + result);
//         });
//       } else {
//         setState(() {
//           _messages.add('Error: ${response.statusCode}');
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _messages.add('Error: $e');
//       });
//     }
//   }
//
//   Future<void> _sendMessage2(String userInput) async {
//     final url = 'https://api.openai.com/v1/chat/completions';
//
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json; charset=utf-8',
//           'Authorization': 'Bearer $apiKey',
//         },
//         body: json.encode({
//           "model": "gpt-3.5-turbo-16k",
//           "messages": [
//             {"role": "user", "content": userInput}
//           ]
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         final decodedResponse = utf8.decode(response.bodyBytes); // UTF-8デコード
//         final data = json.decode(decodedResponse);
//         final chatResponse = data['choices'][0]['message']['content'];
//
//         setState(() {
//           _messages.add('User: $userInput');
//           _messages.add(chatResponse);
//           print("result:"+ chatResponse);
//           String result = chatResponse.replaceAll("問い", "");
//           result = result.replaceAll("答え", "");
//           result = result.replaceAll("Q]", "");
//           result = result.replaceAll("A]", "");
//           result = result.replaceAll("\n", ",");
//           result = result.replaceAll("[", "");
//           result = result.replaceAll("]", ",");
//           result = result.replaceAll(",,", ",");
//           result = result.replaceAll(",,", ",");
//           result = result.replaceAll('"', '');
//           result = result.replaceAll(",,", "");
//           print("result:"+ result);
//           main(result);
//         });
//       } else {
//         setState(() {
//           _messages.add('Error: ${response.statusCode}');
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _messages.add('Error: $e');
//       });
//     }
//   }
//
//
//   // 画像からテキストを認識するメソッド
//   Future<void> recognizeText(String imagePath) async {
//     final apiKey = dotenv.env['ML_API_KEY']??"";  // ここにAPIキーを入力
//     final url = Uri.parse('https://vision.googleapis.com/v1/images:annotate?key=$apiKey');
//
//     // 画像ファイルをBase64エンコード
//     final imageBytes = File(imagePath).readAsBytesSync();
//     final base64Image = base64Encode(imageBytes);
//
//     final requestBody = json.encode({
//       "requests": [
//         {
//           "image": {
//             "content": base64Image,
//           },
//           "features": [
//             {
//               "type": "TEXT_DETECTION",  // OCRを有効にする
//             }
//           ]
//         }
//       ]
//     });
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: requestBody,
//       );
//
//       if (response.statusCode == 200) {
//         final responseJson = json.decode(response.body);
//         final textAnnotations = responseJson['responses'][0]['textAnnotations'];
//
//         if (textAnnotations != null && textAnnotations.isNotEmpty) {
//           final recognizedText = textAnnotations[0]['description'];
//           setState(() {
//
//              _recognizedText = recognizedText;
//             // _sendMessage("以下の文章から問題を作って。条件は 問いと答えを,で区切る。問題間も,で区切る。無駄な文章は入れない。例は　問い,答え,問い2,答え2,問い3,答え3,問い4,答え4,問い5,答え5。作成後に絶対に条件を見直して修正して" +_recognizedText);
//            // _sendMessage("全部リセットしてから次のステップで行動をしてください。ステップ１:以下の文章を知識を元に整え直し、文章中のカンマを全角にしてください。ステップ２：その文章から問題を[問題,答え],のようにDartのリスト型を作ってください。条件は 1:問いと答えを,で区切る。2:無駄な文章は入れない。3:問題は疑問形で。4:問題と答えの中のカンマは全角を使う。例は　[問い,答え],[問い2,答え2],[問い3,答え3],[問い4,答え4],[問い5,答え5]\nもし左側に問題や右側に答えがない場合は修正して" +_recognizedText);
//             _sendMessage("全部リセットしてから行動をしてください。以下の文章の誤字脱字を修正し綺麗な文章に整え直してください。文章中のカンマは全角にしてください。" +_recognizedText);
//
//            });
//         } else {
//           setState(() {
//             _recognizedText = 'テキストが認識できませんでした。';
//           });
//         }
//       } else {
//         setState(() {
//           _recognizedText = 'APIリクエストエラー: ${response.statusCode}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _recognizedText = 'エラーが発生しました: $e';
//       });
//     }
//   }
//
//   // 画像を選択して認識を開始するメソッド
//   Future<void> _pickImageAndRecognizeText() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       await recognizeText(pickedFile.path);
//     } else {
//       setState(() {
//         _recognizedText = '画像が選択されませんでした。';
//       });
//     }
//   }
//   Future<void> _pickImageFromCamera() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.camera);
//
//     if (pickedFile != null) {
//         await recognizeText(pickedFile.path);
//     } else {
//       setState(() {
//         _recognizedText = '画像が選択されませんでした。';
//       });
//     }
//   }
//   void main(text) {
//     text = text.replaceAll('「', '');
//     text = text.replaceAll("」", "");
//     final list2 = stringToList(text);
//     // print('String（カンマ区切り）→List<int>');//a,aa,b,bb,c,cc,d,dd,aa
//
//     for (int i = 0; i < list2.length ; i = i +2) {
//      // list2[i] = list2[i].replaceAll('"','');list2[i+ 1] = list2[i+ 1].replaceAll('"' ,'');
//       setState(() {item.add({"問題":list2[i],"答え":list2[i + 1]});});
//      // print("item"); print(item);
//     }_bodyController5.clear();text = "";
//   }
//   List<String> stringToList(String listAsString) {return listAsString.split(',').map<String>((String item) => item).toList();}
//
//   void initState() {
//   super.initState();_bodyController = TextEditingController();_bodyController2 = TextEditingController();_bodyController3 = TextEditingController();_bodyController4 = TextEditingController();_bodyController5 = TextEditingController();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Cloud Vision OCR'),
//         actions: <Widget>[
//           Row(children: [
//              IconButton(onPressed: () {print(item);}, icon: Icon(Icons.person_3_outlined,color:Colors.blueGrey[300],))
//           ],)],
//       ),
//       body: SingleChildScrollView(
//        // padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//
//             Container( height:70,margin: EdgeInsets.all(25),child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed:  _pickImageAndRecognizeText,
//                   icon: Icon(Icons.photo_library),
//                   label: Text("アルバム"),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: _pickImageFromCamera,
//                   icon: Icon(Icons.camera_alt),
//                   label: Text("カメラ"),
//                 ),
//               ],
//             )),
//
//             SizedBox(height: 20),
//             SizedBox(height: 10),
//             Container( margin: EdgeInsets.all(25),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(), itemCount: item.length, itemBuilder: (context, index) {
//               return GestureDetector(onTap: () {co = index;Q = item[index]["問題"];A = item[index]["答え"];},
//                   child: Card(elevation:0,color:Colors.white,child: Container(decoration: BoxDecoration( border: Border.all(color: Colors.black),color: Colors.white, borderRadius: BorderRadius.circular(5),),margin: EdgeInsets.all(0),
//                       child:Column(children: [
//                         Container(margin: EdgeInsets.only(top:5,right: 5),alignment: Alignment.centerRight,child:Icon(Icons.edit_rounded,color: Colors.blueGrey,size: 15,)),
//                         Row(children: [
//                           Container(alignment: Alignment.centerLeft,margin:EdgeInsets.only(top:15,left:15,right:15),child:Text("問題",style: TextStyle(color: Colors.blueGrey[500],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
//                           Expanded(child: Container(alignment: Alignment.centerLeft,margin:EdgeInsets.only(top:10),child:Text(item[index]["問題"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900]),),)),],),
//                         Divider(color: Colors.blueGrey,thickness: 1,indent: 20,endIndent: 20,),
//                         Container(alignment: Alignment.centerLeft,margin:EdgeInsets.only(bottom: 20),child:Row(children: [Container(alignment: Alignment.centerLeft,margin:EdgeInsets.only(left:15,right:15),child:Text("答え",style: TextStyle(color: Colors.blueGrey[500],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center),),
//                           Expanded(child: Text(item[index]["答え"],style: TextStyle(fontWeight: FontWeight.bold,color:Colors.blueGrey[900]),),),]))
//                       ]))));},),),
//             // Container(height: 300,
//             //   child: ListView.builder(
//             //     itemCount: 1,
//             //     itemBuilder: (context, index) {
//             //       return Padding(
//             //         padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
//             //         child: Text(
//             //           _messages[1],
//             //           style: TextStyle(fontSize: 16.0),
//             //         ),
//             //       );
//             //     },
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
