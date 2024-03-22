import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';



class mail extends StatefulWidget {
  @override
  mail(this.name,this.name2,this.text,this.text2);
  String name;String name2;String text;String text2;
  State<mail> createState() => _mailState();
}

class _mailState extends State<mail> {
  late TextEditingController _emailController;

  late TextEditingController _bodyController;

  late TextEditingController _subjectController;

  late TextEditingController _ccController;

  late TextEditingController _bccController;

  var text = "";
  var map = {};
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _bodyController = TextEditingController();
    _subjectController = TextEditingController();
    _ccController = TextEditingController();
    _bccController = TextEditingController();
    text = widget.name  + "("+widget.name2 + ")" + "\n"+"問題:"+widget.text  + "　答え:"+widget.text2;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _bodyController.dispose();
    _subjectController.dispose();
    _ccController.dispose();
    _bccController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('メール送信',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black),),
        centerTitle: true,elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 100),
              Text(widget.name  + "("+widget.name2 + ")" + "\n"+"問題:"+widget.text  + "　答え:"+widget.text2),
              const SizedBox(height: 20),
              TextFormField(
                controller: _bodyController,
                decoration: InputDecoration(hintText: '本文'),
              ),
              const SizedBox(height: 40),
              ElevatedButton(onPressed: send, child: Text('送信する')),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> send() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   var  ID = prefs.getString("ID") ?? "";
    if(_bodyController.text != ""){DateTime now = DateTime.now();DateFormat outputFormat = DateFormat('yyyy年MM月dd日'); var date = outputFormat.format(now);
  map = {"メッセージ":"間違いメッセージ" + "\n"+ widget.name  + "("+widget.name2 + ")" + "\n"+"問題:"+widget.text + "\n"+  "　答え:"+widget.text2+ "\n"+  _bodyController.text,"uid":ID,"バグ対策":randomString(5),"日付":date};
  await FirebaseFirestore.instance.collection('users').doc(ID).update({"メッセージ": FieldValue.arrayUnion([map])});
  await FirebaseFirestore.instance.collection('管理').doc("メッセージ").update({"uid": FieldValue.arrayUnion([ID])}); _bodyController.clear();Navigator.pop(context);
  }}

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


  Future<void> _sendEmail() async {
    final email = Email(
      body: _bodyController.text,
      subject: widget.name  + "("+widget.name2 + ")" + "\n"+"問題:"+widget.text  + "　答え:"+widget.text2,
      recipients: ["sutadirumu@gmail.com"],
      // cc: [_ccController.text],
      // bcc: [_bccController.text],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
    _bodyController.clear();
  }
}
