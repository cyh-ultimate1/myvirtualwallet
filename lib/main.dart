import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myvirtualwallet/customWidgets.dart';

import 'DatabaseLite/DatabaseHelper.dart';
import 'HomePage.dart';
import 'ResponseModel.dart';
import 'Services/OnlineServices.dart';
import 'constants.dart';

final storage = FlutterSecureStorage();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blue[900],
        fontFamily: GlobalConstants.GLOBALFONTFAMILY
      ),
      home: MyHomePage(title: 'My Virtual Wallet'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final dbHelper = DatabaseHelper.instance;

  Future<String> login(String username, String password) async {
    var res = await OnlineService.loginUser(username, password);
    if(res.statusCode == 200){
      Map<String, dynamic> userMap = jsonDecode(res.body);
      var loginResponse = LoginResponse.fromJson(userMap);

      storage.write(key: "jwt", value: loginResponse.token);
      storage.write(key: GlobalConstants.storageKeyLoggedInUserID, value: loginResponse.userID);
      var count = await dbHelper.queryRowCount();
      if(count  == 0 && loginResponse.userName.isNotEmpty){
        dbHelper.insert({
          DatabaseHelper.loggedInUserTableId   : 1,
          DatabaseHelper.loggedInUserTableUsername : loginResponse.userName,
        });
      }else{
        dbHelper.update({
          DatabaseHelper.loggedInUserTableId   : 1,
          DatabaseHelper.loggedInUserTableUsername : loginResponse.userName,
        });
      }

      return loginResponse.token;
    }

    return "";
  }

  void displayDialog(context, title, text) => showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
            title: Text(title),
            content: Text(text)
        ),
  );

  late bool isLoggedIn = false;
  String? something = "";
  Future<void> updateIsLoggedIn() async{
    var haveKey = await storage.containsKey(key: GlobalConstants.storageKeyLoggedInUserID);
    isLoggedIn = haveKey;
  }

  @override
  void initState() {

    init();
    super.initState();
  }

  Future<void> init() async {
    await updateIsLoggedIn();
    //setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return isLoggedIn
        ? HomePage()
        : Scaffold(
      body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 60,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: GlobalConstants.GLOBALFONTFAMILY
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                    Container(
                      height: 400.0,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                labelText: 'Username',
                              ),
                            ),
                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                  labelText: 'Password'
                              ),
                            ),
                            customWidgets.emptyHorizontalSpace(),
                            ElevatedButton(
                              onPressed: () async {
                                var username = _usernameController.text;
                                var password = _passwordController.text;
                                var jwt = await login(username, password);
                                if(jwt.isNotEmpty) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()
                                      )
                                      , (r) => false
                                  );
                                }
                                else {
                                  displayDialog(context, "An Error Occurred", "No account was found matching that username and password");
                                }
                              },
                              child: Text("Log In".toUpperCase()),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.orange[800],
                                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                  textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
          )
    );
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}