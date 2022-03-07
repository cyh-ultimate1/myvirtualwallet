
import 'package:flutter/material.dart';

class GlobalConstants{
  static const GLOBALFONTFAMILY = "Raleway";
  //static const SERVER_URL = "http://10.0.2.2/MVW_API/api/";
  static const SERVER_ADDRESS = "192.168.0.117";
  static const SERVER_URL = "http://$SERVER_ADDRESS/MVW_API/api/";
  static const CHATSERVER_URL = "http://$SERVER_ADDRESS:10000/";
  static const WEBSOCKET_ADDRESS = "ws://$SERVER_ADDRESS:10000/";
  static const API_AUTHENTICATE = SERVER_URL + "Authenticate/";
  static const API_ACCOUNTTRANSACTION = SERVER_URL + "AccountTransactions/";
  static const API_User = SERVER_URL + "User/";
  static const storageKeyLoggedInUserID = "loggedInUserID";
  static const jwt = "jwt";
  static Color? APPPRIMARYCOLOUR = Colors.blue[900];

  static const MaterialColor customBlue = const MaterialColor(
    0xFF0D47A1,
    <int, Color>{
      900: const Color(0xFF0D47A1),
    },
  );
}