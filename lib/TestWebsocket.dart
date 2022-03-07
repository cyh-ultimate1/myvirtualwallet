import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myvirtualwallet/HomePage.dart';
import 'package:myvirtualwallet/constants.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

import 'Helpers.dart';
import 'ResponseModel.dart';
import 'Services/OnlineServices.dart';
import 'customWidgets.dart';

class TestWebsocketPage extends StatelessWidget {
  TestWebsocketPage(this.nickname);

  final String nickname;

  final WebSocketChannel channel = WebSocketChannel.connect(Uri.parse("ws://192.168.0.117:10000/chat?username=u2"));
  final TextEditingController controller = TextEditingController();


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Announcement Page"),
      ),
      body: Center(
          child: Column(
            children: <Widget>[
              StreamBuilder(
                stream: channel.stream,
                builder: (context, snapshot) {
                  return snapshot.hasData ?
                  Text(
                      snapshot.data.toString(),
                  )
                      :
                  CircularProgressIndicator();
                },
              ),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                    labelText: "Enter your message here"
                ),
              ),
              customWidgets.emptyHorizontalSpace(),
              customWidgets.elevatedButtonHomepageWithIcon(
                  "Withdraw funds", Icons.account_balance_wallet,
                      () {
                        channel.sink.add('{"command": 2, "channel": "newChannel1", "content": "${controller.text}"}');
                  }),
            ],
          )
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.access_alarm),
          onPressed: () {
            channel.sink.add('{"command": 0, "channel": "newChannel1"}');
          }
      ),
    );
  }
}
