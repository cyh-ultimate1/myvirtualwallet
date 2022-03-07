import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myvirtualwallet/Models/ChatDetails.dart';
import 'DatabaseLite/DatabaseHelper.dart';
import 'myGlobals.dart' as myGlobals;

import 'Services/OnlineServices.dart';
import 'customWidgets.dart';

final storage = FlutterSecureStorage();
final StreamController<ChatDetails> messagesStreamController =  StreamController<ChatDetails>.broadcast();
final Stream<ChatDetails> messagesStream = messagesStreamController.stream;

class ChatPage extends StatefulWidget {
  ChatPage(this.chatUsername);
  final String? chatUsername;

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<ChatPage>{
  //variables
  final double? chatInputHeight = 100;
  final List<ChatDetails> messagesInStream = [];
  late Stream broadcastStream;
  final TextEditingController _chatMessageTextController = new TextEditingController();
  ScrollController listScrollController = ScrollController();
  final dbHelper = DatabaseHelper.instance;
  late String _loggedInUsername;

  //functions
  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async{
    _loggedInUsername = await dbHelper.getLoggedInUsername();
    myGlobals.wsChannel!.sink.add('{"action": 0, "channelname": "$_loggedInUsername-${widget.chatUsername}"}');
    broadcastStream = myGlobals.wsChannel!.stream.asBroadcastStream();
    broadcastStream.listen((streamedMessages) {
      var parsedData = parseData(streamedMessages);
      messagesInStream.add(parsedData);
    });
    setState(() {});
  }

  ChatDetails parseData(Object? data){
    var parsed = jsonDecode(data.toString()).cast<String, dynamic>();
    return ChatDetails.fromJson(parsed);

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
            stream: broadcastStream,
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: messagesInStream.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 10,bottom: chatInputHeight! * 2),
                physics: AlwaysScrollableScrollPhysics(),
                controller: listScrollController,
                itemBuilder: (context, index){
                    if(snapshot.hasData) {
                      if(listScrollController.hasClients){
                        //listScrollController.animateTo(listScrollController.position.maxScrollExtent + chatInputHeight!, duration: Duration(seconds: 1), curve: Curves.easeOut);
                        listScrollController.jumpTo(listScrollController.position.maxScrollExtent);
                      }
                      return Container(
                        padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
                        child: Align(
                          alignment: (messagesInStream.length == 0 || messagesInStream[index]!.Content!.ContentSender.toString() != _loggedInUsername ? Alignment.topLeft:Alignment.topRight),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: (messagesInStream.length == 0 || messagesInStream[index]!.Content!.ContentSender.toString() != _loggedInUsername ? Colors.green.shade200:Colors.blue[200]),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Text(messagesInStream.length == 0 ? "" : messagesInStream[index]!.Content!.ContentMessage.toString(), style: TextStyle(fontSize: 15),),
                          ),
                        ),
                      );
                    }
                    else{
                      return CircularProgressIndicator();
                    }
                },
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
              height: chatInputHeight,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 20, ),
                    ),
                  ),
                  customWidgets.emptyHorizontalSpace(),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none
                      ),
                      controller: _chatMessageTextController,
                    ),
                  ),
                  customWidgets.emptyHorizontalSpace(),
                  FloatingActionButton(
                    onPressed: () {
                      myGlobals.wsChannel!.sink.add('{"action": 2, "channelname": "$_loggedInUsername-${widget.chatUsername}", "content": "${_chatMessageTextController.text}", "sender":"$_loggedInUsername"}');
                    },
                    child: Icon(Icons.send,color: Colors.white,size: 18,),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class ChatMessage {
  String? messageContent;
  String? messageType;

  ChatMessage({String? inMessageType, String? inMessageContent}) {
    messageContent = inMessageContent;
    messageType = inMessageType;
  }
}