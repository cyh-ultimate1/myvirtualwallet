import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myvirtualwallet/ChatPage.dart';
import 'package:myvirtualwallet/Models/ChatUser.dart';
import 'package:myvirtualwallet/constants.dart';
import 'DatabaseLite/DatabaseHelper.dart';
import 'myGlobals.dart' as myGlobals;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'Services/OnlineServices.dart';

final storage = FlutterSecureStorage();

class ChatListPage extends StatefulWidget {
  ChatListPage();

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<ChatListPage>{
  //variables
  Future<List<ChatUser>>? _futureChatUsers;
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
    myGlobals.wsChannel = WebSocketChannel.connect(Uri.parse("${GlobalConstants.WEBSOCKET_ADDRESS}/chat?username=$_loggedInUsername"));
    _futureChatUsers = getChatUsers();
    setState(() {});
  }

  Future<List<ChatUser>> getChatUsers() async {
    var res = await OnlineService.getChatUsers();
    if (res.statusCode == 200) {
      var parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();
      return parsed
          .map<ChatUser>((json) => ChatUser.fromJson(json))
          .toList();
    }

    return List.filled(0, new ChatUser());
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat List"),
      ),
      body: FutureBuilder(
        future: _futureChatUsers,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var resultList = (snapshot.data as List<ChatUser>).toList();
            resultList.removeWhere((element) => element.Name == _loggedInUsername);

            return ListView.builder(
              itemCount: resultList.length,
              itemBuilder: (BuildContext ctxt, int idx) {
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatPage(resultList[idx].Name)),
                      );
                    },
                    child: new Card(
                      margin:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                      elevation: 7,
                      color: Colors.white,
                      shadowColor: GlobalConstants.APPPRIMARYCOLOUR,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: GlobalConstants.APPPRIMARYCOLOUR!,
                            width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 20.0),
                          child: DefaultTextStyle(
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "${resultList[idx].Name.toString()}"
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ))),
                    ),
                );
              },
            );
          }
          else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}