// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:google_books_api/google_books_api.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:http/http.dart' as http;
//
// class test extends StatefulWidget {
//
//   @override
//   State<test> createState() => _testState();
// }
//
// class _testState extends State<test> {
//
//   var aa= "";
//   var bb = "";
//   var image = "";
//
//   void initState() {
//
//   }
//
//   BarcodeType? codeType;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(aa )),
//       body:
//       MobileScanner(
//         // fit: BoxFit.contain,
//         onDetect: (capture) {
//           final List<Barcode> barcodes = capture.barcodes;
//           codeType = capture.barcodes.first.type;
//           // final Uint8List? image = capture.image;
//           for (final barcode in barcodes) {
//             debugPrint('Barcode found! ${barcode.displayValue}');
//
//             BarcodeType.isbn;
//             setState(() {aa = barcode.displayValue!;print(aa);});
//
//            Navigator.of(context).push(MaterialPageRoute(builder: (context) => test2(aa)));
//           }
//         },
//       ),
//     );
//   }
//
// }
//
//
// class Album {
//   final String userId;
//   final String  title;
//   final String  image;
//
//   const Album({
//     required this.userId,
//     required this.title,
//     required this.image,
//   });
//
//   factory Album.fromJson(Map<String, dynamic> json) {
//     return Album(
//       userId: json['kind'],
//       title: json['items'][0]["volumeInfo"]["title"],
//       image: json['items'][0]["volumeInfo"]["imageLinks"]["thumbnail"],
//     );
//   }
// }
//
//
//
// class test2 extends StatefulWidget {
// test2(this.ID);
// String ID;
//   @override
//   State<test2> createState() => _test2State();
// }
//
// class _test2State extends State<test2> {
//
//   var aa= "";
//   var bb = "";
//   var image = "";
//
//   Future<Album>  fetchBookfromIsbn(String isbn) async {
//     final String url = 'https://www.googleapis.com/books/v1/volumes?q=isbn:';
//     final uri = Uri.parse(url + isbn);
//     final result = await http.get(uri);
//     //  final result1 = await fetchBookfromIsbn(result.body);
//     if (result == null) {
//       throw ("book not found");
//     }
//     // String.parse(result);
//     print(result.body);
//     final node = result.body;
//     // final node = json.decode(result.toString());
//     var aa = Album.fromJson(jsonDecode(node));
//     setState(() {bb = aa.title ;image = aa.image;});
//     return Album.fromJson(jsonDecode(node));
//   }
//
//
//
//   void initState() {
//     fetchBookfromIsbn(widget.ID);
//   }
//
//   BarcodeType? codeType;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("")),
//       body:Container(
//
//           child:Column(children: [
//             Container(width: 350, height: 150, child: Image.network(image)),
//             Container(width:double.infinity,margin :EdgeInsets.only(top: 30),child:Text(bb,style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 22),textAlign: TextAlign.center,)),
//
//           ],)
//       )
//     );
//   }
//
// }
//
//
//
//
//
