import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'Helpers.dart';
import 'HomePage.dart';
import 'ResponseModel.dart';
import 'Services/OnlineServices.dart';
import 'constants.dart';
import 'customWidgets.dart';

final storage = FlutterSecureStorage();
class TransferFundPage extends StatefulWidget {
  TransferFundPage();

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<TransferFundPage>{
  //variables
  var _formKey = new GlobalKey<FormState>();
  var _autoValidateMode = AutovalidateMode.always;
  final TextEditingController _depositAmountController = TextEditingController();
  String? jwt = "";
  String dropdownvalue = '';
  Future? _futureUserList;

  //functions
  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async{
    _futureUserList = getUsersWithAccounts(jwt.toString());
    setState(() {

    });
  }

  Future<String> transfer(double amount) async {
    var userID =
        await storage.read(key: GlobalConstants.storageKeyLoggedInUserID);
    var res = await OnlineService.transferMoney(amount, userID.toString(), dropdownvalue);

    return res != null ? res.body : "";
  }

  Future<List<UserResponse>> getUsersWithAccounts(String jwtToken) async{
    var res = await OnlineService.getUsersWithAccount(jwtToken);
    if(res.statusCode == 200){
      var parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();
      var userList = parsed.map<UserResponse>((json) => UserResponse.fromJson(json)).toList();
      return userList;
    }

    return List.filled(0, new UserResponse("", ""));
  }

  //widget
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Transfer fund"),),
      body: new Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: new Form(
            key: _formKey,
            autovalidateMode: _autoValidateMode,
            child: new ListView(
              children: <Widget>[
                FutureBuilder(
                  future: _futureUserList,
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      return DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                            labelText: 'Transfer to which user?'
                        ),
                        items: (snapshot.data as List<UserResponse>).map((UserResponse value) {
                          return new DropdownMenuItem<String>(
                            value: value.accountDetailsID,
                            child: new Text(
                              value.userName,
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue){
                          setState(() {
                            dropdownvalue = newValue.toString();
                          });
                        },
                      );
                    }
                    else{
                      return CircularProgressIndicator();
                    }
                  },
                ),
                TextField(
                  controller: _depositAmountController,
                  decoration: InputDecoration(
                      labelText: 'Transfer Amount'
                  ),
                  keyboardType: TextInputType.number,
                ),
                customWidgets.emptyHorizontalSpace(),
                customWidgets.elevatedButtonCustomized(
                  'Confirm',
                      () async{
                    var depositAmount = _depositAmountController.text;
                    var responseMsg = await transfer(double.parse(depositAmount));
                    if (responseMsg.isNotEmpty) {
                      Helpers.displayDialog(context, "", responseMsg, widgets: [
                        ElevatedButton(
                          child: Text("OK"),
                          onPressed: () async {
                            Navigator.pop(context);
                            await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (r) => false);
                          },
                        ),
                      ]);
                    }
                  },
                )
              ],
            )
        ),
      ),
    );
  }
}