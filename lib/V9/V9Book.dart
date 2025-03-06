
import 'dart:math';

import 'package:anki/Create/CreateQA.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_box_thumbnail/youtube_box_thumbnail.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class V9Book extends StatefulWidget {
  @override
  State<V9Book> createState() => _V9BookState();
}
class _V9BookState extends State<V9Book> {


  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  var boo = false;
  var co = 50.0;
  var date = "";
  var item = [];
  List<String> BookList = [];
  Color colors = Colors.black;
  @override
  void initState() {
  super.initState();
  first ();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  _controller = YoutubePlayerController(initialVideoId: "",
  flags: YoutubePlayerFlags(mute: false, autoPlay: false, disableDragSeek: false, loop: false, isLive: false, forceHD: false, enableCaption: false,),)..addListener(listener);
  _idController = TextEditingController();
  _seekToController = TextEditingController();
  _videoMetaData = YoutubeMetaData();
  _playerState = PlayerState.unknown;
  }

  void listener() {
  if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
  setState(() {
  _playerState = _controller.value.playerState;
  _videoMetaData = _controller.metadata;
  });
  }
  }

  @override
  void deactivate() {
  // Pauses video while navigating to next page.
  _controller.pause();
  super.deactivate();
  }

  @override
  void dispose() {
  _controller.dispose();
  _idController.dispose();
  _seekToController.dispose();
  super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(backgroundColor: Colors.white,
  appBar: AppBar(backgroundColor: Colors.white, iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,),
  body: Container(child:ListView.builder( itemCount: item.length, itemBuilder: (context, index) {
  return GestureDetector(
  onTap: () {//Navigator.of(context).push(MaterialPageRoute(builder: (context) => V9V2(widget.item[index])));
  },
  child:Stack(children: [
  YoutubeBoxThumbnail(url: "https://www.youtube.com/watch?v=" + item[index],),
  GestureDetector(onTap: () {show(item[index],index);
  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => V9V2(widget.item[index])));
  },
  child: Container(color:Colors.transparent,height: 100,width: double.infinity))
  ],),);},
  ),
  ));
  }
  void ww (){
    setState(() {  var ss = _videoMetaData.duration;print(ss.inSeconds);
    var hours = ss.inSeconds / 3600;
    var minutes = ss.inSeconds % 3600 / 60;
    var seconds = ss.inSeconds % 60;
    date = hours.toInt().toString() + "時間" + minutes.toInt().toString() + "分" + seconds.toInt().toString() + "秒";});
  }

  void show (ID,index){
  _controller = YoutubePlayerController(initialVideoId: ID,
  flags: YoutubePlayerFlags(mute: false, autoPlay: true, disableDragSeek: false, loop: false, isLive: false, forceHD: false, enableCaption: false,),
  )..addListener(listener);//ww();
  showModalBottomSheet(isScrollControlled: true,context: context,backgroundColor: Colors.white,
  shape:   RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
  builder: (context) { return StatefulBuilder(
  builder: (context, StateSetter setState) {
  return    Container(margin:EdgeInsets.only(top:co),child:  YoutubePlayerBuilder(
  onEnterFullScreen: (){setState(() {co = 0;}); },
  onExitFullScreen: () {setState(() {SystemChrome.setPreferredOrientations(DeviceOrientation.values);co = 50;});},
  player: YoutubePlayer(controller: _controller, showVideoProgressIndicator: true, progressIndicatorColor: Colors.blueAccent, onReady: () {_isPlayerReady = true;},
  onEnded: (data) {_controller.load(item[(item.indexOf(data.videoId) + 1) % item.length]);},),
  builder: (context, player) =>
  ListView(children: [
  player,
  Padding(padding: const EdgeInsets.all(8.0),
  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
  Text( _videoMetaData.title,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
  Text( _videoMetaData.author,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
  Text( date,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),),
  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
  // IconButton(icon: const Icon(Icons.skip_previous),
  //   onPressed: _isPlayerReady ? () => _controller.load(widget.item[(widget.item.indexOf(_controller.metadata.videoId) - 1) % widget.item.length]) : null,),
  // IconButton(icon: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow,),
  // onPressed: _isPlayerReady ? () {_controller.value.isPlaying ? _controller.pause() : _controller.play();
  // setState(() {});} : null,),
  // IconButton(icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
  //   onPressed: _isPlayerReady ? () {_muted ? _controller.unMute() : _controller.mute();
  //     setState(() {_muted = !_muted;});} : null,),
  // FullScreenButton(controller: _controller, color: Colors.black,),
  //  IconButton(icon: const Icon(Icons.skip_next),
  //    onPressed: _isPlayerReady ? () => _controller.load(widget.item[(widget.item.indexOf(_controller.metadata.videoId) + 1) % widget.item.length]) : null,),
    IconButton(icon: Icon(LineIcons.youtube), onPressed: () {
      final url = Uri.parse("https://www.youtube.com/watch?v=" + _videoMetaData.videoId);launchUrl(url);
    } ),
  IconButton(icon: Icon(Icons.bookmark_remove_outlined,color: colors,), onPressed: () {delete(index);} ),
  ],),

    Container(margin:EdgeInsets.only(top:50),child:IconButton(icon:  Icon(Icons.highlight_off,color: Colors.blueGrey[300],size: 40,),
      onPressed: () {Navigator.pop(context);setState(() async {item = BookList;});
        //setState(() {boo = true;});
      },)),

  ],),),

  ],),),);});}, );

  }

  void first () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {item = prefs.getStringList("動画") ?? [];});BookList = item as List<String>;
  }
  Future<void> delete(index)  async {
    setState(() async {colors = Colors.orange;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    BookList = prefs.getStringList("動画") ?? [];BookList.remove(item[index]);prefs.setStringList("動画", BookList);item = [];//item = BookList;
    }); }
}