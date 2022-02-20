import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myvirtualwallet/HomePage.dart';
import 'package:myvirtualwallet/constants.dart';

import 'Helpers.dart';
import 'ResponseModel.dart';
import 'Services/OnlineServices.dart';
import 'customWidgets.dart';

final storage = FlutterSecureStorage();

class DepositPage extends StatefulWidget {
  DepositPage();

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<DepositPage> with InputValidationMixin {
  //variables
  var _formKey = new GlobalKey<FormState>();
  var _autoValidateMode = AutovalidateMode.always;
  final TextEditingController _depositAmountController =
      TextEditingController();
  String? jwt = "";
  String dropdownvalue = '';
  Future? _future;

  //functions
  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {
    setState(() {});
  }

  Future<String> deposit(double amount) async {
    var userID =
        await storage.read(key: GlobalConstants.storageKeyLoggedInUserID);
    var res = await OnlineService.depositMoney(amount, userID.toString());
    if (res.statusCode == 200) {
      return "Deposit successful !";
    }

    return res.body;
  }

  //widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Deposit"),
      ),
      body: new Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: new Form(
            key: _formKey,
            autovalidateMode: _autoValidateMode,
            child: new ListView(
              children: <Widget>[
                TextFormField(
                  controller: _depositAmountController,
                  validator: (input) =>
                      isCurrencyValid(input) ? null : "invalid currency input.",
                  decoration: InputDecoration(labelText: 'Deposit Amount'),
                  keyboardType: TextInputType.number,
                ),
                customWidgets.emptyHorizontalSpace(),
                customWidgets.elevatedButtonCustomized(
                  'Confirm',
                  () async {
                    var depositAmount = _depositAmountController.text;
                    var responseMsg =
                        await deposit(double.parse(depositAmount));
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
            )),
      ),
    );
  }
}

mixin InputValidationMixin {
  bool isPasswordValid(String password) => password.length == 6;

  bool isCurrencyValid(String? input) {
    if (input == null) {
      return false;
    }
    int? output = int.tryParse(input);
    return output != null;
  }
}
