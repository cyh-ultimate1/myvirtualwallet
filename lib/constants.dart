
import 'package:flutter/material.dart';

class GlobalConstants{
  static const GLOBALFONTFAMILY = "Raleway";
  static const SERVER_URL = "http://10.0.2.2/MVW_API/api/";
  static const API_AUTHENTICATE = SERVER_URL + "Authenticate/";
  static const API_ACCOUNTTRANSACTION = SERVER_URL + "AccountTransactions/";
  static const API_User = SERVER_URL + "User/";
  static const storageKeyLoggedInUserID = "loggedInUserID";
  static Color? APPPRIMARYCOLOUR = Colors.blue[900];

  static const MaterialColor customBlue = const MaterialColor(
    0xFF0D47A1,
    <int, Color>{
      900: const Color(0xFF0D47A1),
    },
  );
}