import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:myvirtualwallet/ResponseModel.dart';
import 'HomePage.dart';
import 'Services/OnlineServices.dart';
import 'constants.dart';

final storage = FlutterSecureStorage();

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<LoginPage>{
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<String> login(String username, String password) async {
    var res = await OnlineService.loginUser(username, password);
    if(res.statusCode == 200){
      Map<String, dynamic> userMap = jsonDecode(res.body);
      var loginResponse = LoginResponse.fromJson(userMap);

      storage.write(key: "jwt", value: loginResponse.token);
      storage.write(key: GlobalConstants.storageKeyLoggedInUserID, value: loginResponse.userID);

      return loginResponse.token;
    }

    return "";
  }

  Future<String> register(String username, String password) async {
    var res = await http.post(
        Uri.parse(GlobalConstants.API_AUTHENTICATE + 'register'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: jsonEncode({
          "username": username,
          "password": password
        })
    );

    return res.body;
  }

  void displayDialog(context, title, text) => showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
            title: Text(title),
            content: Text(text)
        ),
  );

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(title: Text("Log In"),),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                    labelText: 'Username'
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Password'
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    var username = _usernameController.text;
                    var password = _passwordController.text;
                    var jwt = await login(username, password);
                    if(jwt.isNotEmpty) {

                      //displayDialog(context, "this is response body value: ", jwt);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage()
                          )
                      );
                    } else {
                      displayDialog(context, "An Error Occurred", "No account was found matching that username and password");
                    }
                  },
                  child: Text("Log In")
              ),
              /*ElevatedButton(
                  onPressed: () async {
                    var username = _usernameController.text;
                    var password = _passwordController.text;
                    var responseBody = await register(username, password);
                    if(responseBody.isNotEmpty) {
                      displayDialog(context, "this is response body value: ", responseBody);
                    } else {
                      displayDialog(context, "An Error Occurred", "there is an error");
                    }
                  },
                  child: Text("Sign Up")*//*
              ),*/
            ],
          ),
        )
    );
  }
}