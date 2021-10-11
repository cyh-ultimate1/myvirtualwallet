import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myvirtualwallet/Helpers.dart';
import 'package:myvirtualwallet/Models/AccountDetails.dart';
import 'package:myvirtualwallet/Models/AccountTransaction.dart';
import 'package:myvirtualwallet/TestPage.dart';
import 'package:myvirtualwallet/WithdrawPage.dart';
import 'package:myvirtualwallet/constants.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'DepositPage.dart';
import 'Services/OnlineServices.dart';
import 'TransferFundPage.dart';
import 'customWidgets.dart';

final storage = FlutterSecureStorage();

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<HomePage> {
  //variables
  Future<AccountDetails>? _futureAccountDetails;
  Future<List<AccountTransaction>>? _futureAccountTransactions;
  String? userID;

  //functions
  @override
  void initState() {
    init();
    super.initState();
  }

  Future<AccountDetails> getUserDetail() async {
    var res = await OnlineService.getUserDetail();
    if (res.statusCode == 200) {
      var parsed = jsonDecode(res.body).cast<String, dynamic>();
      return AccountDetails.fromJson(parsed);
    }

    return new AccountDetails(0);
  }

  Future<List<AccountTransaction>> getUserTransactionsDetail() async {
    var res = await OnlineService.getCurrentUserTransactions();
    if (res.statusCode == 200) {
      var parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();
      return parsed
          .map<AccountTransaction>((json) => AccountTransaction.fromJson(json))
          .toList();
    }

    return List.filled(0, new AccountTransaction());
  }

  Future init() async {
    _futureAccountDetails = getUserDetail();
    _futureAccountTransactions = getUserTransactionsDetail();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SlidingUpPanel(
          controller: panelController,
          maxHeight: MediaQuery.of(context).size.height - 50,
          panelBuilder: (scrollController) => buildSlidingPanel(
                scrollController: scrollController,
                panelController: panelController,
              ),
          body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration:
                  BoxDecoration(color: GlobalConstants.APPPRIMARYCOLOUR),
              child: Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    DefaultTextStyle(
                      style: TextStyle(color: Colors.white),
                      child: Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 100,
                              child: Icon(
                                Icons.person,
                                size: 100,
                                color: Colors.cyan,
                              ),
                            ),
                            Text("Current balance",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            customWidgets.emptyHorizontalSpace(),
                            FutureBuilder(
                                future: _futureAccountDetails,
                                builder: (context, snapshot) => snapshot.hasData
                                    ? Text(
                                        "\$${(snapshot.data as AccountDetails).Balance.toString()}",
                                        style: const TextStyle(fontSize: 50),
                                      )
                                    : snapshot.hasError
                                        ? customWidgets.errorDialog("Error",
                                            "There is an error getting the account details.")
                                        : CircularProgressIndicator()),
                            customWidgets.emptyHorizontalSpace(),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 400.0,
                      padding: EdgeInsets.only(top: 50.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      child: Column(
                        children: [
                          customWidgets.elevatedButtonHomepageWithIcon(
                              "Deposit funds", Icons.attach_money, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DepositPage()),
                            );
                          }),
                          customWidgets.emptyHorizontalSpace(),
                          customWidgets.elevatedButtonHomepageWithIcon(
                              "Transfer funds", Icons.send_and_archive, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TransferFundPage()),
                            );
                          }),
                          customWidgets.emptyHorizontalSpace(),
                          customWidgets.elevatedButtonHomepageWithIcon(
                              "Withdraw funds", Icons.account_balance_wallet,
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WithdrawPage()),
                            );
                          }),
                          customWidgets.emptyHorizontalSpace(),
                          /*customWidgets.elevatedButtonHomepageWithIcon(
                              "Test page", Icons.account_balance_wallet, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TestPage()),
                            );
                          }),*/
                        ],
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }

  final panelController = PanelController();
  final double tabBarHeight = 30;

  Widget buildSlidingPanel({
    required PanelController panelController,
    required ScrollController scrollController,
  }) =>
      DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: GestureDetector(
              onTap: () => panelController.open(),
              child: AppBar(
                title: buildDragIcon(), // Icon(Icons.drag_handle),
                centerTitle: true,
                automaticallyImplyLeading: false, //to hide back button
                backgroundColor: Colors.white,
              ),
            ),
          ),
          // body: Text("this sample.")
          body: FutureBuilder(
            future: _futureAccountTransactions,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var resultList =
                    (snapshot.data as List<AccountTransaction>).toList();
                return ListView.builder(
                  itemCount: resultList.length,
                  itemBuilder: (BuildContext ctxt, int idx) {
                    return Card(
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
                                      flex: 1,
                                      child: customWidgets.transactionTypeIcon(
                                          resultList[idx].TransactionType)!),
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AccountTransactionType.GetTypeName(
                                              resultList[idx].TransactionType!),
                                          style: TextStyle(fontSize: 23),
                                        ),
                                        Text(
                                            "\$${resultList[idx].GetAmount().toString()}")
                                      ],
                                    ),
                                  ),
                                ],
                              ))),
                    );
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      );

  Widget buildDragIcon() => DefaultTextStyle(
      style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      child: Container(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: GlobalConstants.APPPRIMARYCOLOUR!.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              width: 40,
              height: 8,
            ),
            customWidgets.emptyHorizontalSpace(),
            Text("ACCOUNT TRANSACTIONS")
          ],
        ),
      ));
}
