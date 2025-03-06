
import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_box_thumbnail/youtube_box_thumbnail.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'V9Book.dart';


class V9 extends StatefulWidget {
  @override
  State<V9> createState() => _V9State();
}

class _V9State extends State<V9>  with SingleTickerProviderStateMixin  {
  var item = ["BGM","勉強法","英語","数学","物理","化学","生物","国語","世界史","日本史","地理","公民",];
  List<List> list = [
    //BGM
    [{"単元":"","配列":["1時間","1時間30分","2時間","2時間30分","3時間","3時間30分","4時間","4時間30分","5時間超"]},],
    // 勉強法
    [{"単元":"","配列":["英語勉強法","数学勉強法","物理勉強法","化学勉強法","生物勉強法","国語勉強法","世界史勉強法","日本史勉強法","地理勉強法","公民勉強法","脳機能","科目別勉強法","ルーティン","NG行動","睡眠・休憩","モチベーション","集中","アイテム","勉強法","テスト対策","環境作り","ノート術",]}],
    // 英語

  ];

  var name = "";
  TabController? _tabController;
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
    _tabController!.index = 0;show ();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }


  void _onItemTapped(int index) {setState(() {});}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
        home: DefaultTabController(length: 2,
            child: Scaffold(backgroundColor: Colors.white,appBar:  AppBar(backgroundColor: Colors.white,elevation: 0,
              actions: [ IconButton(icon: Icon(Icons.bookmark_border,color: Colors.black,), onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V9Book()));} ),
              ],
              bottom: TabBar(controller: _tabController, onTap: _onItemTapped,
                isScrollable: true, unselectedLabelColor: Colors.black.withOpacity(0.3), unselectedLabelStyle: TextStyle(fontSize: 12.0),
                labelColor: Colors.black, labelStyle: TextStyle(fontSize: 16.0), indicatorColor: Colors.black, indicatorWeight: 2.0,
                tabs: [
                  Tab(child: Text('BGM'),), Tab(child: Text('勉強法'), ),
                ],),
              title: Text("おすすめYouTube", style: TextStyle(color: Colors.blueGrey[800], fontWeight: FontWeight.bold, fontSize: 15,),textAlign: TextAlign.center,),iconTheme: IconThemeData(color: Colors.black),
              //actions: <Widget>[IconButton(onPressed: () {}, icon: Icon(Icons.info_outline,color: Colors.black87,))],
            ),
                body:TabBarView(children: [_createTab(_tabController!.index), _createTab(_tabController!.index),
                ]) )));}
  Widget _createTab(int index0){
    return SingleChildScrollView(child:Column(children: <Widget>[
      Container(child:
      Container(margin: EdgeInsets.all(10),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(),
        itemCount: list[index0].length, itemBuilder: (context, index1) {
          return Card(elevation: 0,color:Colors.white,child:
          Column(children: <Widget>[
            Container(width: double.infinity,child:Text(list[index0][index1]["単元"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.left,)),
            GridView.count(padding: EdgeInsets.all(5.0), crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0, childAspectRatio: 3.5, shrinkWrap: true, physics:  NeverScrollableScrollPhysics(),//controller: controller,
                children: List.generate(list[index0][index1]["配列"].length, (index2) {
                  return GestureDetector(onTap: () {
                    aa(index0,index1,index2);
                    //var name = list[index]["配列"][index1];Navigator.of(context).push(MaterialPageRoute(builder: (context) => V9List(list[index]["配列"])));
                  },
                    child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(spreadRadius: 0.5, blurRadius:0.5, color: Colors.grey, )]),alignment:Alignment.center,child:Text(list[index0][index1]["配列"][index2],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,)),
                  );})), Container(height: 30,),]));},),),
      ),
      Container(height: 80,),
    ]) );
  }
  void aa (index0,index1,index2){
    name = list[index0][index1]["配列"][index2];itemSet ();Navigator.of(context).push(MaterialPageRoute(builder: (context) => V9List(item)));
  }
  void itemSet (){
    switch (name) {
    //BGM
      case "1時間" :item = ["p8O7wHutr-A?si","e51dROrMSl8?si","kEBTHBeKHIQ?","IfqIkAteIus?si","Tfs2bS887eM?si","cH-in55hG8Q?si","kMCbva2SvMU?si","iL2PJcgjIe0?si","NpZu4WopfCc?si","htuETHL9zlk?si","Tfs2bS887eM?si","HcH-zLsgjNc?si","hp89NlDBJCY?si","SmyXDAJB2CQ?si",];break;
      case "1時間30分" :item = ["RHD7TI6RrGU?si","k7RAe2R_ji4?si","7Cq4EGyRce8?si","McCWKdUlpQg?si","KHnceddxIsQ?si","2hjU3Wb3WS4?si","wxjB3m5aZqI?si","YjohMzHkBqI?si","P1z6TjQIjVY?si","7Cq4EGyRce8?si","RcVKAIMCqXQ?si","J6IVI1NRl6E?si","KHnceddxIsQ?si","LOFNQH8egc4?si","o9Ssorhig58?si",];break;
      case "2時間" :item = ["4YUwV8kIYdc?si","vr9dLvJs7VE?si","t_8uSnwvUeQ?si","-xSUH9lHCRA?si","ww-YBK4NAvY?si","F-hhrQ3BjRI?si","8z67h6GgcOw?si","_kWiCprt41g?si","ZmNsrIjhl8E?si","H8KpW6ul9Rk?si","TuTzuVDeGAc?si","i2BO46TSD-o?si","-Zk7Y-8mf6Q?si","hpjX0YNorCg?si","CK-9hmcNQLM?si",];break;
      case "2時間30分" :item = ["sUwD3GRPJos?si","RooDETdsaVg?si","hXh38YLaFrs?si","4yR6fccyc4Q?si"];break;
      case "3時間" :item = ["HvOQZj87yNc?si","298Fo2EKY4g?si","by7xeG0mqus?si","hqvs7ZGquls?si","h7vNpMjmudA?si","jChKQOPBEhI?si","POY_lDQddDE?si","GqFrgJxZvOs?si","PiPoUiFUrLg?si","by7xeG0mqus?si","21AIFyxLRN0?si","UFiztcMoKa8?si",];break;
      case "3時間30分" :item = ["UpxX6moYv5Y?si","DGgsZ3vFNxU?si","02azSAMtZWU?si","UwQp8vOlD14?si","k_3DFCzcMC4?si","WzK_BscP9Ms?si","_mP1PVebplE?si","31tGP36PyDg?si","3GBr42aixUU?si","QE-5no9V5k8?si","pebGxJZwt6k?si",];break;
      case "4時間" :item = ["DXT9dF-WK-I?si","sZgHdaDvEfI?si","UTtbOGRfG9E?si","hhSTf2xF3wQ?si","ZJQVKX-8abI?si","Da9q7yrijCk?si","6sZnNr0RY5w?si","y49Z_TRiRlU?si","UTtbOGRfG9E?si","SNl5tIzHGFU?si","rEiAWdzZObw?si","QYpDQxHfTPk?si","nF1fSKEiyA0?si","6sZnNr0RY5w?si","eB0arUZ-63I?si",];break;
      case "4時間30分" :item = ["Xh1j2CLHuSI?si"];break;
      case "5時間超" :item = ["YdtBEFK_HgI?si","1gSFPnt4ob4?si","XQ2XXyoAW1c?si","WvGqxftJvKE?si","2j4yHnBFs4g?si","lLR5kzg80EY?si","UbFziX8cScc?si","CNWzP_aQ7es?si","OgWi4H-77wc?si","K-bvRdCzGGw?si"];break;
    //勉強法　200
      case "脳機能" :item = ["R_WbZkOVOYc?si","rDp1ic_3HIQ?si","j404x7m7KZY?si"];break;
      case "勉強法" :item = ["ZcjPV3qhcSA?si","CG_HDGkTz58?si","aFYWMjelhXI?si","yTQYlatTlWo?si","6th3K6ncBCU?si","1ZmSvTRgOik?si","YnjkabXq_gw?si","RNNLJGbcfU0?si","PEn_Agkvr5I?si","wxZ2U24U6c0?si","-V23yAzw8uY?s","fodz0pKf3C8?si","8A7hClSOerE?si","gUC5WONL72Y?si","V4KMrfMMIEA?si","0SqAn3cR81g?si","1bm_E-DodDs?si","GAi-YQMRe58?si","-vfOlm1ychc?si","7bkTblBnHwA?si","me44kgiCfAA?si","g5lTzgrMLOY?si",];break;
      case "科目別勉強法" :item = ["Q1S9lKA6Fvc?si","xYWr1IoOBSM?si","x9UGWo-5kdU?si","NAtrIyYHxHA?si",];break;
      case "ルーティン" :item = ["mTSm7Jc6gcA?si","mchOSVgqdOc?si","mpr31kJy94Q?si","Ms3ipuJU8ZM?si","ztxOdHKR-I4?si","bJLIIFYP1a4?si","PhinoDXJJv4?si","nEHsYVtGZVg?si","rQFZXfUWBmU?si","tUzUksQTcEQ?si","KW8a-rO98uk?si","I8BQXdfvEm8?si","fu8VJW9TfCA?si","_WozMXynr1w?si","d5BTPxkq4Fg?si",];break;
      case "睡眠・休憩" :item = ["quUk5ElA_Mc?si","qxCovc9FlEE?si","NCO_egXJFd0?si","hisF_Fl7Ips?si","OKAkbw1z30E?si","nPThxKobfv8?si","kiY7fRh7N1g?si","uA3eMaIjTNY?si","IsbCgG3NEdM?si","baS-4q5jd9Y?si","TgCkGJfLXRY?si","xpBBZdE_pbY?si","OrsBSrGqRW0?si",];break;
      case "モチベーション" :item = ["YR_-LwWHceU?si","wmM85EVTCd8?si","iALi9EdFRB0?si","GpowViccdFY?si","8U6FEpLDIwk?si","DfvNM_0Bbf0?si","3vPvVx-xGEY?si","Q4OTnSbVuCg?si","vg_xrukcJIo?si","p4pBxkCLKNI?si","EWWhqD1qqWQ?si","NJxy7r5TTzQ?si","UamNi6o-sQk?si","m0e53tqjmlo?si","E4RVNRihuBI?si","Wpulnegj3_Q?si"];break;
      case "集中" :item = ["ijktD-l-7kY?si","N5GwgiADv50?si","dqFgGnLQgVs?si","2tu48V0LBhA?si","vTpylvMJ9NY?si","jvEpMsdPT-Q?si"];break;
      case "アイテム" :item = ["_rnsgn5i848?si","Lp5PRYg3dHM?si","ieAJTYADaRE?si","FEApSBT34mo?si","yiO6rr73blA?si","cbp_F7W-9BA?si","v2gR4sBLCoo?si","JS_G8tlr4ys?si","GX4zNJIYtZA?si","pb39DHfa0hQ?si",];break;
      case "テスト対策" :item = ["ufSHrSPiBFM?si","ClK3rH0CTgE?si","uxuWjiwFkAI?si","q9dFQdJFDqY?si","_oMo2i4Lo7Y?si","k4HaPvEIPuk?si","SyIpxXOXIeE?si","cBX9X6RI5vA?si","89Voc8AJyPA?si","PfBFmz-qjDM?si","cfW9AtVyY5c?si","RFOaPHF05J8?si","X7flW0mJJzE?si",];break;
      case "NG行動" :item = ["CnFxmvmO80o?si","WQ2--v1HnCY?si","NtKUqx8_ji8?si","FatUC3RMQZc?si","SV1CfQdetbE?si","xcnV8mLsCOs?si","KGF5xajXnfg?si","kMADUly7xB0?si","ytG8eGZ9Hh4?si","cevWT8y-2NY?si","GWQmu5Frvw8?si","neTdlhkdydo?si","Gz1dkxJ1Uuc?si","jlfI8IDfpn0?si","FD3ebQJgZB0?si","5h9QU6NkfL8?si","NrjVqF-VDM8?si","8CKaHIK0kyc?si","9aXHV-HnL0s?si","Gi4eMLuq008?si","AOt7hZZfTSU?si","KeB2Tj4x4_E?si","3ntXUoEJCVY?si","D3EHg4Wgdlw?si","nx4plADmVzg?si","IIr00kXImBk?si","fUISMvfHc-M?si","FeAZrMLZ13c?si",];break;
      case "環境作り" :item = ["8jkV9ompdzM?si","-5Tgaw62hRs?si","2qSoTDyBveA?si","-kdt10lxCmo?si","tKoJsg8QDek?si","ZDDTzRmOUWg?si","VXcVMjZwbB4?si","-dlJbGidzQs?si","jaxgVOjVyZI?si","z4sbuI9VCUk?si","mCSQrGhqrn4?si",];break;
      case "ノート術" :item = ["Ps0Z-Gem6A0?si","x2E-7AI1IQE?si","tnyKqnXQirk?si","g66wEXHvxRY?si",];break;
      case "目標の立て方" :item = ["8EXZXBqdc2E?si"];break;
      case "英語勉強法" :item = ["TM3rVHtSPxU?si","II38yQXdRAo?si","9R15VNwbhwk?si","aBAsipIoCpE?si","B2ZV4sAm4rQ?si","hM6K1031jqY?si","EalEzLQ7-rw?si","oRFSScY4eg8?si","jhVTnhMzmCs?si","-sFpqvUd2rs?si","SFhM0uXNqjs?si","CaLJLP9bW-4?si","Bd9KiWtXUeU?si","PJT9UWM0sz0?si","zGmYgzpG7_U?si",];break;
      case "数学勉強法" :item = ["Usb5SSzavZk?si","9TzXD8dt7ks?si","X14mYj39r7c?si","d1qos0sAD8E?si","73nSiYKeu7M?si","ss---nzprVI?si"];break;
      case "物理勉強法" :item = ["2JnVYXsk1C8?si","-iKUV0kFcQA?si","E2-kMwMEIp8?si","CBTxpJ01zsY?si","sB-k8tQNTYc?si","MPiYa-rTUE4?si","3YfsGUG6n14?si"];break;
      case "化学勉強法" :item = ["56Jni7N6oqw?si","Uy2Xh0tMN7Q?si","yITqGoh7w2o?si","Z-bwDMKLRqE?si","k9Db0EkWbj4?si","mzTjPJmry84?si","BBifo_TpnFY?si","Bknag20lHHw?si",];break;
      case "生物勉強法" :item = ["n4RvlsRT4-4?si","vyi7KiaLw7o?si","DTEF3wItPkk?si","0_38_VuKTbM?si","YDZ0par9Erg?si","kA9_-QX-poM?si","SsP4hsE-Z5c?s","JMItllVVJ_s?si",];break;
      case "国語勉強法" :item = ["wMBqXks1A5Q?si","oM2aswUnmJA?si","jkJLWePKDwo?si","ekDJWlm4Bsw?si","0eaw0xsva-4?si","VOegbPclh9c?si","bCR_OVo_XS4?si","xznaa5kTR0s?si","0eaw0xsva-4?si","EvaCrUweYF8?si","z-md4fsV7-I?si","wjZfcTJF7qI?si","BjE51RFLjiM?si","CEKfqVSE8QI?si","M_amEBL9qhU?si","FaD5Dg9eSag?si"];break;
      case "世界史勉強法" :item = ["9YfmiN6MeKI?si","OmpddaXHgZM?si","1R_QKUvmiTw?si","lorf-2JQcns?si","Isz1xz5ZyLI?si","CfgbbjdLMMQ?si","TJsWj_FV_kw?si","JL1LUQ7XdBM?si","JrDM7C6LUg0?si",];break;
      case "日本史勉強法" :item = ["-SIJiFOXl60?si","BXRo73NmJ4k?si","mVLI5iGZQYk?si","CzFxdJTu55c?si","JL1LUQ7XdBM?si","xi4ormgd0s4?si","SNmMlOMFujQ?si","qTrrIFpheuQ?si","HyLecw35-2s?si","oyqt9UkP0B4?si","4Zv5eW9YRr8?si","OFwmJREGdqU?si","SAjotU10ZK8?si","Cw483101U3I?si","pSZSOd2JeA0?si","wNfViqwNeh8?si","jq7Xh84BRDI?si","9rVHr87CUNY?si",];break;
      case "地理勉強法" :item = ["0gJBCQhqmfY?si","tbb1MGGCuEM?si","o6BBym9i968?si","CuxGDK8p3ks?si","r40bnH0HC54?si","8Mh5m2g2Lr4?si","A_5gOwMwhqo?si","gzYvHk4dnKU?si","GeJ45sp5F58?si","kwA9T8FUSF4?si"];break;
      case "公民勉強法" :item = ["Ue5P-6wBA2Y?si","GeJ45sp5F58?si",];break;

    }}

  Future<void> show () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var ID = prefs.getString("V9First") ?? "";
    if(ID == ""){
      showDialog(context: context, builder: (context) => AlertDialog(title: Container(child:  Text("こちらは真面目に作っていないです。\n使いづらかったらすみません🙏",style: TextStyle(color: Colors.blueGrey[800],fontWeight: FontWeight.bold,fontSize: 15), textAlign: TextAlign.center))));}
    prefs.setString("V9First", "1");}

}
//
// import 'dart:async';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'dart:developer';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:line_icons/line_icons.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:youtube_box_thumbnail/youtube_box_thumbnail.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//
// import 'V9Book.dart';
//
//
// class V9 extends StatefulWidget {
//   @override
//   State<V9> createState() => _V9State();
// }
//
// class _V9State extends State<V9>  with SingleTickerProviderStateMixin  {
//   var item = ["BGM","勉強法","英語","数学","物理","化学","生物","国語","世界史","日本史","地理","公民",];
//  List<List> list = [
//    //BGM
//    [{"単元":"","配列":["1時間","1時間30分","2時間","2時間30分","3時間","3時間30分","4時間","4時間30分","5時間超"]},],
//   // 勉強法
//    [{"単元":"","配列":["脳機能","科目別勉強法","ルーティン","NG行動","睡眠・休憩","モチベーション","集中","アイテム","勉強法","テスト対策","環境作り","ノート術",]}],
//   // 英語
//    [{"単元":"","配列":["英語勉強法"]},
//      {"単元":"中1","配列":["アルファベットの読み書き","be動詞の文","一般動詞の文","複数形の文","命令形の文","三人称の文","what を使った疑問文","who,which,where を使った疑問文","whose,when,why,how を使った疑問文","her,him を使った文","現在進行形を使った文","can を使った文"]},
//      {"単元":"中2","配列":["過去形を使った文","知覚動詞を使った文","未来形（be going to）を使った文","give,show,buy を使った文","call を使った文","不定詞を使った文","have to を使った文","未来形（will）を使った文","must を使った文","接続詞を使った文","There is ～ を使った文","動名詞を使った文","比較級や最上級を使った文","as ～ as を使った文","Can I ～?を使った文","Can you ～ ?,Could you ～ ?を使った文"]},
//      {"単元":"中3","配列":["受動態を使った文","make を使った文","現在完了を使った文","to + 動詞 を使った文","what,where,when,why を使った文","名詞につけたす表現",]},
//      {"単元":"高1","配列":["","","","","","","","","","","","","","","","","","","","",]},
//      {"単元":"高2","配列":["","","","","","","","","","","","","","","","","","","","",]},
//      {"単元":"高3","配列":["","","","","","","","","","","","","","","","","","","","",]},
//      {"単元":"高校英文法","配列":["時制","受動態","助動詞","不定詞","動名詞","分詞","仮定法","比較","関係詞","接続詞","動詞","名詞・冠詞","代名詞","前置詞","形容詞・副詞","５文型","強調・倒置・挿入・省略・同格"]},
//      {"単元":"英語構文","配列":["英文の眺め方","前置詞＋名詞の眺め方","動詞の眺め方","準動詞の眺め方","関係詞の眺め方","等位接続詞の眺め方","従属接続詞の眺め方","It構文の眺め方","名詞構文の眺め方","比較の眺め方","否定の眺め方","倒置の眺め方","仮定法・その他構文"]},
//    ],
//    // 数学
//    [{"単元":"","配列":["数学勉強法"]},
//      {"単元":"中1","配列":["正の数・負の数","乗法・除法","四則演算","加法・減法","文章題と図形問題","文字と式","文字を含んだ式","等式と不等式","方程式","方程式の移項","方程式の文章題","比例と反比例","比例のグラフ","反比例のグラフ","比例と反比例の文章題","平面図形","空間図形","資料の散らばりと代表値","近似値と有効数字"]},
//      {"単元":"中2","配列":["式の計算","単項式の計算","文字式の乗法・除法など","連立方程式","連立方程式の文章題","１次関数","１次関数のグラフ","直線の式","２元１次方程式","１次関数の文章題","図形の性質","図形の合同","図形の証明のコツ","三角形の証明","平行四辺形の証明","三角形と四角形の関係","確率","確率・組合せ","確率・余事象"]},
//      {"単元":"中3","配列":["単項式・多項式の計算と乗法公式","素因数分解","因数分解","因数分解を用いる問題","平方根・ルートの計算","平方根・ルートの乗法・除法","平方根の有理化","２次方程式・解の公式","２次方程式・因数分解","２次方程式の文章題","２次関数の基本","２次関数の文章題","図形と相似","平行線と比","相似の証明","中点連結定理","面積比と体積比","三平方の定理","円周角と接線","円の性質と証明","標本調査"]},
//      {"単元":"数学Ⅰ","配列":["数と式","方程式の展開","因数分解・たすきがけ","有理数・無理数・平方根","方程式と不等式","絶対値・方程式","２次方程式","集合","命題と必要条件・十分条件","２次関数のグラフ","２次関数の最大・最小","２次関数の応用","放物線と直線の共有点","２次不等式","三角比","正弦定理・余弦定理","面積や体積への応用","データの散らばりと相関"]},
//      {"単元":"数学Ａ","配列":["集合・補集合","場合の数（樹形図・和の法則・積の法則）","順列","円順列と重複順列","組合せ nCr","組合せの活用","組み分け","確率","確率　和事象と余事象","確率　サイコロ・独立試行","確率　サイコロ・反復試行","確率　くじ・乗法定理","整数の性質","素因数分解","倍数と約数・互いに素","方程式の整数解","方程式の整数解　割り算の商と余り","ユークリッドの互除法・１次不定方程式","分数と小数","n進法","線分の内分・外分・平行線の性質","三角形の角の二等分線","三角形の外心・内心・重心","チェバ・メネラウスの定理","円周角の定理・内接","円の接線・接弦定理・方べきの定理","２つの円の共通接線","作図","直線と平面の関係","正多面体",]},
//      {"単元":"数学Ⅱ","配列":["展開・因数分解と２項定理","分数式の計算・求値問題","整式の割り算・剰余の定理","方程式と恒等式の証明問題","複素数","２次方程式の解の判別・解と係数の関係","高次方程式","直線上の点・平面上の点","直線・２直線の平行垂直","円と直線・２つの円の関係","軌跡と領域","三角比と三角関数","sinθ・cosθの関係","sinθ・cosθ・tanθの方程式と一般角","三角関数のグラフと加法定理","三角関数の合成","指数関数","対数関数","極限と微分関数","微分法","積分法"]},
//      {"単元":"数学Ｂ","配列":["等差数列（一般項と和）","等比数列（一般項と和）","等差・等比数列の応用","数列・Σの計算","階差数列","特殊な数列の和","漸化式と数学的帰納法","ベクトルの定義・成分","ベクトルの内積・垂直条件","分点公式と直線のベクトル方程式","空間ベクトル"]},
//      {"単元":"数学Ⅲ","配列":["複素数平面","極形式","ド・モアブルの定理","複素数と図形","２次曲線","媒介変数表示と極座標","分数関数","無理関数","逆関数と合成関数","数列の極限","関数の極限","導関数","いろいろな関数の導関数","導関数の応用","方程式・不等式への応用","不定積分","定積分","積分法の応用",]},
//    ],
//    // 物理
//    [{"単元":"","配列":["物理勉強法"]},
//      {"単元":"","配列":["","","","","","","","","","","","","","","","","","","","",]},
//    ],
//    // 化学
//    [{"単元":"","配列":["化学勉強法"]},
//      {"単元":"","配列":["","","","","","","","","","","","","","","","","","","","",]},
//    ],
//    // 生物
//    [{"単元":"","配列":["生物勉強法"]},
//      {"単元":"","配列":["","","","","","","","","","","","","","","","","","","","",]},
//    ],
//    // 国語
//    [{"単元":"","配列":["国語勉強法"]},
//      {"単元":"","配列":["","","","","","","","","","","","","","","","","","","","",]},
//    ],
//    // 世界史
//    [{"単元":"","配列":["世界史勉強法"]},
//      {"単元":"","配列":["","","","","","","","","","","","","","","","","","","","",]},
//    ],
//    // 日本史
//    [{"単元":"","配列":["日本史勉強法"]},
//      {"単元":"","配列":["","","","","","","","","","","","","","","","","","","","",]},
//    ],
//    // 地理
//    [{"単元":"","配列":["地理勉強法"]},
//      {"単元":"","配列":["","","","","","","","","","","","","","","","","","","","",]},
//    ],
//    // 公民
//    [{"単元":"","配列":["公民勉強法"]},
//      {"単元":"","配列":["","","","","","","","","","","","","","","","","","","","",]},
//    ],
//  ];
//
//  var name = "";
//   TabController? _tabController;
//
//   //var item = ["","","","","",""];
//   void initState() {
//     super.initState();
//     _tabController = new TabController(vsync: this, length: item.length);
//     _tabController!.index = 0;
//   }
//
//   @override
//   void dispose() {
//     _tabController?.dispose();
//     super.dispose();
//   }
//
//
//   void _onItemTapped(int index) {
//     //Tapされたindexを上記_currentPageIndexに代入するメソッド
//     setState(() {
//
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(debugShowCheckedModeBanner: false,
//       home: DefaultTabController(length: 12,
//         child: Scaffold(backgroundColor: Colors.white,appBar:  AppBar(backgroundColor: Colors.white,elevation: 0,
//           actions: [ IconButton(icon: Icon(Icons.bookmark_border,color: Colors.black,), onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => V9Book()));} ),
//         ],
//           bottom: TabBar(controller: _tabController, onTap: _onItemTapped,
//             isScrollable: true, unselectedLabelColor: Colors.black.withOpacity(0.3), unselectedLabelStyle: TextStyle(fontSize: 12.0),
//             labelColor: Colors.black, labelStyle: TextStyle(fontSize: 16.0), indicatorColor: Colors.black, indicatorWeight: 2.0,
//             tabs: [
//               Tab(child: Text('BGM'),), Tab(child: Text('勉強法'),), Tab(child: Text('英語'),), Tab(child: Text('数学'),), Tab(child: Text('物理'),), Tab(child: Text('化学'),), Tab(child: Text('生物'),), Tab(child: Text('国語'),), Tab(child: Text('世界史'),), Tab(child: Text('日本史'),), Tab(child: Text('地理'),), Tab(child: Text('公民'),),
//             ],),
//           title: Text("勉強限定YouTube", style: TextStyle(color: Colors.blueGrey[800], fontWeight: FontWeight.bold, fontSize: 15,),textAlign: TextAlign.center,),iconTheme: IconThemeData(color: Colors.black),
//           //actions: <Widget>[IconButton(onPressed: () {}, icon: Icon(Icons.info_outline,color: Colors.black87,))],
//         ),
//           body:TabBarView(children: [
//             _createTab(_tabController!.index),
//             _createTab(_tabController!.index), _createTab(_tabController!.index), _createTab(_tabController!.index), _createTab(_tabController!.index), _createTab(_tabController!.index), _createTab(_tabController!.index), _createTab(_tabController!.index), _createTab(_tabController!.index), _createTab(_tabController!.index), _createTab(_tabController!.index), _createTab(_tabController!.index),
//           ]) )));}
//   Widget _createTab(int index0){
//     return SingleChildScrollView(child:Column(children: <Widget>[
//       Container(child:
//       Container(margin: EdgeInsets.all(10),child: ListView.builder(shrinkWrap: true, physics:  NeverScrollableScrollPhysics(),
//         itemCount: list[index0].length, itemBuilder: (context, index1) {
//           return Card(elevation: 0,color:Colors.white,child:
//           Column(children: <Widget>[
//             Container(width: double.infinity,child:Text(list[index0][index1]["単元"],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.left,)),
//             GridView.count(padding: EdgeInsets.all(5.0), crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0, childAspectRatio: 3.5, shrinkWrap: true, physics:  NeverScrollableScrollPhysics(),//controller: controller,
//                 children: List.generate(list[index0][index1]["配列"].length, (index2) {
//                   return GestureDetector(onTap: () {
//                     aa(index0,index1,index2);
//                     //var name = list[index]["配列"][index1];Navigator.of(context).push(MaterialPageRoute(builder: (context) => V9List(list[index]["配列"])));
//                     },
//                     child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(spreadRadius: 0.5, blurRadius:0.5, color: Colors.grey, )]),alignment:Alignment.center,child:Text(list[index0][index1]["配列"][index2],style: TextStyle(color: Colors.blueGrey[900],fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,)),
//                   );})), Container(height: 30,),]));},),),
//       ),
//       Container(height: 80,),
//     ]) );
//   }
//   void aa (index0,index1,index2){
//     name = list[index0][index1]["配列"][index2];itemSet ();Navigator.of(context).push(MaterialPageRoute(builder: (context) => V9List(item)));
//   }
//   void itemSet (){
//     switch (name) {
//      //BGM
//       case "1時間" :item = ["p8O7wHutr-A?si","e51dROrMSl8?si","kEBTHBeKHIQ?","IfqIkAteIus?si","Tfs2bS887eM?si","cH-in55hG8Q?si","kMCbva2SvMU?si","iL2PJcgjIe0?si","NpZu4WopfCc?si","htuETHL9zlk?si","Tfs2bS887eM?si","HcH-zLsgjNc?si","hp89NlDBJCY?si","SmyXDAJB2CQ?si",];break;
//       case "1時間30分" :item = ["RHD7TI6RrGU?si","k7RAe2R_ji4?si","7Cq4EGyRce8?si","McCWKdUlpQg?si","KHnceddxIsQ?si","2hjU3Wb3WS4?si","wxjB3m5aZqI?si","YjohMzHkBqI?si","P1z6TjQIjVY?si","7Cq4EGyRce8?si","RcVKAIMCqXQ?si","J6IVI1NRl6E?si","KHnceddxIsQ?si","LOFNQH8egc4?si","o9Ssorhig58?si",];break;
//       case "2時間" :item = ["4YUwV8kIYdc?si","vr9dLvJs7VE?si","t_8uSnwvUeQ?si","-xSUH9lHCRA?si","ww-YBK4NAvY?si","F-hhrQ3BjRI?si","8z67h6GgcOw?si","_kWiCprt41g?si","ZmNsrIjhl8E?si","H8KpW6ul9Rk?si","TuTzuVDeGAc?si","i2BO46TSD-o?si","-Zk7Y-8mf6Q?si","hpjX0YNorCg?si","CK-9hmcNQLM?si",];break;
//       case "2時間30分" :item = ["sUwD3GRPJos?si","RooDETdsaVg?si","hXh38YLaFrs?si","4yR6fccyc4Q?si"];break;
//       case "3時間" :item = ["HvOQZj87yNc?si","298Fo2EKY4g?si","by7xeG0mqus?si","hqvs7ZGquls?si","h7vNpMjmudA?si","jChKQOPBEhI?si","POY_lDQddDE?si","GqFrgJxZvOs?si","PiPoUiFUrLg?si","by7xeG0mqus?si","21AIFyxLRN0?si","UFiztcMoKa8?si",];break;
//       case "3時間30分" :item = ["UpxX6moYv5Y?si","DGgsZ3vFNxU?si","02azSAMtZWU?si","UwQp8vOlD14?si","k_3DFCzcMC4?si","WzK_BscP9Ms?si","_mP1PVebplE?si","31tGP36PyDg?si","3GBr42aixUU?si","QE-5no9V5k8?si","pebGxJZwt6k?si",];break;
//       case "4時間" :item = ["DXT9dF-WK-I?si","sZgHdaDvEfI?si","UTtbOGRfG9E?si","hhSTf2xF3wQ?si","ZJQVKX-8abI?si","Da9q7yrijCk?si","6sZnNr0RY5w?si","y49Z_TRiRlU?si","UTtbOGRfG9E?si","SNl5tIzHGFU?si","rEiAWdzZObw?si","QYpDQxHfTPk?si","nF1fSKEiyA0?si","6sZnNr0RY5w?si","eB0arUZ-63I?si",];break;
//       case "4時間30分" :item = ["Xh1j2CLHuSI?si","","","","","","","","","","","","","","",];break;
//       case "5時間超" :item = ["YdtBEFK_HgI?si","1gSFPnt4ob4?si","XQ2XXyoAW1c?si","WvGqxftJvKE?si","2j4yHnBFs4g?si","lLR5kzg80EY?si","UbFziX8cScc?si","CNWzP_aQ7es?si","OgWi4H-77wc?si","K-bvRdCzGGw?si"];break;
//       //勉強法　200
//       case "脳機能" :item = ["R_WbZkOVOYc?si","rDp1ic_3HIQ?si","j404x7m7KZY?si","","","","","","","","","","","","",];break;
//       case "勉強法" :item = ["ZcjPV3qhcSA?si","CG_HDGkTz58?si","aFYWMjelhXI?si","yTQYlatTlWo?si","6th3K6ncBCU?si","1ZmSvTRgOik?si","YnjkabXq_gw?si","RNNLJGbcfU0?si","PEn_Agkvr5I?si","wxZ2U24U6c0?si","-V23yAzw8uY?s","fodz0pKf3C8?si","8A7hClSOerE?si","gUC5WONL72Y?si","V4KMrfMMIEA?si","0SqAn3cR81g?si","1bm_E-DodDs?si","GAi-YQMRe58?si","-vfOlm1ychc?si","7bkTblBnHwA?si","me44kgiCfAA?si","g5lTzgrMLOY?si",];break;
//       case "科目別勉強法" :item = ["Q1S9lKA6Fvc?si","xYWr1IoOBSM?si","x9UGWo-5kdU?si","NAtrIyYHxHA?si",];break;
//       case "ルーティン" :item = ["mTSm7Jc6gcA?si","mchOSVgqdOc?si","mpr31kJy94Q?si","Ms3ipuJU8ZM?si","ztxOdHKR-I4?si","bJLIIFYP1a4?si","PhinoDXJJv4?si","nEHsYVtGZVg?si","rQFZXfUWBmU?si","tUzUksQTcEQ?si","KW8a-rO98uk?si","I8BQXdfvEm8?si","fu8VJW9TfCA?si","_WozMXynr1w?si","d5BTPxkq4Fg?si",];break;
//       case "睡眠・休憩" :item = ["quUk5ElA_Mc?si","qxCovc9FlEE?si","NCO_egXJFd0?si","hisF_Fl7Ips?si","OKAkbw1z30E?si","nPThxKobfv8?si","kiY7fRh7N1g?si","uA3eMaIjTNY?si","IsbCgG3NEdM?si","baS-4q5jd9Y?si","TgCkGJfLXRY?si","xpBBZdE_pbY?si","OrsBSrGqRW0?si",];break;
//       case "モチベーション" :item = ["YR_-LwWHceU?si","wmM85EVTCd8?si","iALi9EdFRB0?si","GpowViccdFY?si","8U6FEpLDIwk?si","DfvNM_0Bbf0?si","3vPvVx-xGEY?si","Q4OTnSbVuCg?si","vg_xrukcJIo?si","p4pBxkCLKNI?si","EWWhqD1qqWQ?si","NJxy7r5TTzQ?si","UamNi6o-sQk?si","m0e53tqjmlo?si","E4RVNRihuBI?si","Wpulnegj3_Q?si"];break;
//       case "集中" :item = ["ijktD-l-7kY?si","N5GwgiADv50?si","dqFgGnLQgVs?si","2tu48V0LBhA?si","vTpylvMJ9NY?si","jvEpMsdPT-Q?si"];break;
//       case "アイテム" :item = ["_rnsgn5i848?si","Lp5PRYg3dHM?si","ieAJTYADaRE?si","FEApSBT34mo?si","yiO6rr73blA?si","cbp_F7W-9BA?si","v2gR4sBLCoo?si","JS_G8tlr4ys?si","GX4zNJIYtZA?si","pb39DHfa0hQ?si",];break;
//       case "テスト対策" :item = ["ufSHrSPiBFM?si","ClK3rH0CTgE?si","uxuWjiwFkAI?si","q9dFQdJFDqY?si","_oMo2i4Lo7Y?si","k4HaPvEIPuk?si","SyIpxXOXIeE?si","cBX9X6RI5vA?si","89Voc8AJyPA?si","PfBFmz-qjDM?si","cfW9AtVyY5c?si","RFOaPHF05J8?si","X7flW0mJJzE?si",];break;
//       case "NG行動" :item = ["CnFxmvmO80o?si","WQ2--v1HnCY?si","NtKUqx8_ji8?si","FatUC3RMQZc?si","SV1CfQdetbE?si","xcnV8mLsCOs?si","KGF5xajXnfg?si","kMADUly7xB0?si","ytG8eGZ9Hh4?si","cevWT8y-2NY?si","GWQmu5Frvw8?si","neTdlhkdydo?si","Gz1dkxJ1Uuc?si","jlfI8IDfpn0?si","FD3ebQJgZB0?si","5h9QU6NkfL8?si","NrjVqF-VDM8?si","8CKaHIK0kyc?si","9aXHV-HnL0s?si","Gi4eMLuq008?si","AOt7hZZfTSU?si","KeB2Tj4x4_E?si","3ntXUoEJCVY?si","D3EHg4Wgdlw?si","nx4plADmVzg?si","IIr00kXImBk?si","fUISMvfHc-M?si","FeAZrMLZ13c?si",];break;
//       case "環境作り" :item = ["8jkV9ompdzM?si","-5Tgaw62hRs?si","2qSoTDyBveA?si","-kdt10lxCmo?si","tKoJsg8QDek?si","ZDDTzRmOUWg?si","VXcVMjZwbB4?si","-dlJbGidzQs?si","jaxgVOjVyZI?si","z4sbuI9VCUk?si","mCSQrGhqrn4?si",];break;
//       case "ノート術" :item = ["Ps0Z-Gem6A0?si","x2E-7AI1IQE?si","tnyKqnXQirk?si","g66wEXHvxRY?si",];break;
//       case "目標の立て方" :item = ["8EXZXBqdc2E?si"];break;
//       case "英語勉強法" :item = ["TM3rVHtSPxU?si","II38yQXdRAo?si","9R15VNwbhwk?si","aBAsipIoCpE?si","B2ZV4sAm4rQ?si","hM6K1031jqY?si","EalEzLQ7-rw?si","oRFSScY4eg8?si","jhVTnhMzmCs?si","-sFpqvUd2rs?si","SFhM0uXNqjs?si","CaLJLP9bW-4?si","Bd9KiWtXUeU?si","PJT9UWM0sz0?si","zGmYgzpG7_U?si",];break;
//       case "数学勉強法" :item = ["Usb5SSzavZk?si","9TzXD8dt7ks?si","X14mYj39r7c?si","d1qos0sAD8E?si","73nSiYKeu7M?si","ss---nzprVI?si"];break;
//       case "物理勉強法" :item = ["2JnVYXsk1C8?si","-iKUV0kFcQA?si","E2-kMwMEIp8?si","CBTxpJ01zsY?si","sB-k8tQNTYc?si","MPiYa-rTUE4?si","3YfsGUG6n14?si"];break;
//       case "化学勉強法" :item = ["56Jni7N6oqw?si","Uy2Xh0tMN7Q?si","yITqGoh7w2o?si","Z-bwDMKLRqE?si","k9Db0EkWbj4?si","mzTjPJmry84?si","BBifo_TpnFY?si","Bknag20lHHw?si",];break;
//       case "生物勉強法" :item = ["n4RvlsRT4-4?si","vyi7KiaLw7o?si","DTEF3wItPkk?si","0_38_VuKTbM?si","YDZ0par9Erg?si","kA9_-QX-poM?si","SsP4hsE-Z5c?s","JMItllVVJ_s?si",];break;
//       case "国語勉強法" :item = ["wMBqXks1A5Q?si","oM2aswUnmJA?si","jkJLWePKDwo?si","ekDJWlm4Bsw?si","0eaw0xsva-4?si","VOegbPclh9c?si","bCR_OVo_XS4?si","xznaa5kTR0s?si","0eaw0xsva-4?si","EvaCrUweYF8?si","z-md4fsV7-I?si","wjZfcTJF7qI?si","BjE51RFLjiM?si","CEKfqVSE8QI?si","M_amEBL9qhU?si","FaD5Dg9eSag?si"];break;
//       case "世界史勉強法" :item = ["9YfmiN6MeKI?si","OmpddaXHgZM?si","1R_QKUvmiTw?si","lorf-2JQcns?si","Isz1xz5ZyLI?si","CfgbbjdLMMQ?si","TJsWj_FV_kw?si","JL1LUQ7XdBM?si","JrDM7C6LUg0?si",];break;
//       case "日本史勉強法" :item = ["-SIJiFOXl60?si","BXRo73NmJ4k?si","mVLI5iGZQYk?si","CzFxdJTu55c?si","JL1LUQ7XdBM?si","xi4ormgd0s4?si","SNmMlOMFujQ?si","qTrrIFpheuQ?si","HyLecw35-2s?si","oyqt9UkP0B4?si","4Zv5eW9YRr8?si","OFwmJREGdqU?si","SAjotU10ZK8?si","Cw483101U3I?si","pSZSOd2JeA0?si","wNfViqwNeh8?si","jq7Xh84BRDI?si","9rVHr87CUNY?si",];break;
//       case "地理勉強法" :item = ["0gJBCQhqmfY?si","tbb1MGGCuEM?si","o6BBym9i968?si","CuxGDK8p3ks?si","r40bnH0HC54?si","8Mh5m2g2Lr4?si","A_5gOwMwhqo?si","gzYvHk4dnKU?si","GeJ45sp5F58?si","kwA9T8FUSF4?si"];break;
//       case "公民勉強法" :item = ["Ue5P-6wBA2Y?si","GeJ45sp5F58?si",];break;
//
//     }}
//
//
// }



class V9List extends StatefulWidget {
  V9List(this.item);
  List item;
  @override
  State<V9List> createState() => _V9ListState();
}

class _V9ListState extends State<V9List> {
  var item1 = [];

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
  Color colors = Colors.black;
  var count = 0;
  @override
  void initState() {
    super.initState();
    //aa ();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _controller = YoutubePlayerController(initialVideoId: "",
      flags: YoutubePlayerFlags(captionLanguage: "",controlsVisibleAtStart: false,mute: false, autoPlay: false, disableDragSeek: false, loop: false, isLive: false, forceHD: false),)..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void aa (){
    Future.delayed(Duration(seconds: 1), () {
      Future.delayed(Duration(seconds: 1), () {
        for(int i = 0; i<10000; i++){
        Timer.periodic(
          // 第一引数：繰り返す間隔の時間を設定
          Duration(seconds: 1),
          // 第二引数：その間隔ごとに動作させたい処理を書く
              (Timer timer) {
            count++; print(count);_controller.play();
            setState(() {});
          },
        );
      }});
    });
  }
  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });}
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    //_controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    // _controller.dispose();
    // _idController.dispose();
    // _seekToController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, iconTheme: IconThemeData(color: Colors.black), centerTitle: true,elevation: 0,
        actions: <Widget>[
          Row(children: [
          //  IconButton(onPressed: () {print(item1);}, icon: Icon(Icons.info_outline,color: Colors.blueGrey[300],)),
          ],)],),
      body: ListView.builder( itemCount: widget.item.length, itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {//Navigator.of(context).push(MaterialPageRoute(builder: (context) => V9V2(widget.item[index])));
            },
          child:Stack(children: [
            YoutubeBoxThumbnail(url: "https://www.youtube.com/watch?v=" + widget.item[index],),
            GestureDetector(onTap: () {show(widget.item[index],index);
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => V9V2(widget.item[index])));
            },
                child: Container(color:Colors.transparent,height: 100,width: double.infinity))
          ],),);},
      ),
    );
  }
 void ww (){
    var ss = _videoMetaData.duration;print(ss.inSeconds);
    var hours = ss.inSeconds / 3600;
    var minutes = ss.inSeconds % 3600 / 60;
    var seconds = ss.inSeconds % 60;
    date = hours.toInt().toString() + "時間" + minutes.toInt().toString() + "分" + seconds.toInt().toString() + "秒";
 }

  void show (ID,index){
    _controller = YoutubePlayerController(initialVideoId: ID,
      flags: YoutubePlayerFlags(enableCaption :false,mute: false, autoPlay: true, disableDragSeek: false, loop: false, isLive: false, forceHD: false, ),
    )..addListener(listener);//ww();
    var ss = _videoMetaData.duration;print(ss.inSeconds);
    var hours = ss.inSeconds / 3600;
    var minutes = ss.inSeconds % 3600 / 60;
    var seconds = ss.inSeconds % 60;
    date = hours.toInt().toString() + "時間" + minutes.toInt().toString() + "分" + seconds.toInt().toString() + "秒";
    report(ID);
    showModalBottomSheet(isScrollControlled: true,context: context,backgroundColor: Colors.white,
      shape:   RoundedRectangleBorder( borderRadius: BorderRadius.vertical(top: Radius.circular(25.0),),),
      builder: (context) { return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return    Container(margin:EdgeInsets.only(top:co),child:  YoutubePlayerBuilder(
             onEnterFullScreen: (){setState(() {co = 0;}); },
              onExitFullScreen: () {setState(() {SystemChrome.setPreferredOrientations(DeviceOrientation.values);co = 50;});},
              player: YoutubePlayer(controller: _controller, showVideoProgressIndicator: false, progressIndicatorColor: Colors.blueAccent, onReady: () {_isPlayerReady = true;},
                //onEnded: (data) {_controller.load(widget.item[(widget.item.indexOf(data.videoId) + 1) % widget.item.length]);},
              ),
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
                                  //   onPressed: _isPlayerReady ? () {_controller.value.isPlaying ? _controller.pause() : _controller.play();
                                  //   setState(() {});} : null,),
                                  // IconButton(icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
                                  //   onPressed: _isPlayerReady ? () {_muted ? _controller.unMute() : _controller.mute();
                                  //     setState(() {_muted = !_muted;});} : null,),
                                 // FullScreenButton(controller: _controller, color: Colors.black,),
                                 //  IconButton(icon: const Icon(Icons.skip_next),
                                 //    onPressed: _isPlayerReady ? () => _controller.load(widget.item[(widget.item.indexOf(_controller.metadata.videoId) + 1) % widget.item.length]) : null,),
                                IconButton(icon: Icon(LineIcons.youtube), onPressed: () {
                                  final url = Uri.parse("https://www.youtube.com/watch?v=" + _videoMetaData.videoId);launchUrl(url);
                                } ),
                                IconButton(icon: Icon(Icons.bookmark_add_outlined,color: colors,), onPressed: () {send(index);} ),
                              ],),

                            Container(margin:EdgeInsets.only(top:50),child:IconButton(icon:  Icon(Icons.highlight_off,color: Colors.blueGrey[300],size: 40,),
                              onPressed: () {Navigator.pop(context); setState(() {colors = Colors.black;});
                              //setState(() {boo = true;});
                              },)),

                          ],),),

                            ],),),);});}, );

  }
  Future<void> send(index)  async {
    setState(() {colors = Colors.orange;});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var BookList = prefs.getStringList("動画") ?? [];
    if (BookList.contains(widget.item[index]) == false){BookList.add(widget.item[index]);prefs.setStringList("動画", BookList);}
    }

  Future<void> report(text) async {
    var ran = randomString(4);
    DateTime now = DateTime.now();DateFormat outputFormat = DateFormat('yyyy年MM月dd日'); var date = outputFormat.format(now);
    DocumentReference ref = FirebaseFirestore.instance.collection('レポート').doc(date);
      ref.update({"Youtube" : FieldValue.arrayUnion([ran + "::::" + text]),});
    }
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
}