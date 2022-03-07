
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

final storage = FlutterSecureStorage();
class OnlineService{
  static var headersTemplate = {
    "Accept": "application/json",
    "content-type": "application/json"};

  static Future<http.Response> loginUser(String username, String password) async{
    return await http.post(
        Uri.parse(GlobalConstants.API_AUTHENTICATE + 'login'),
        headers: headersTemplate,
        body: jsonEncode({
          "username": username,
          "password": password
        })
    );
  }

  static Future<http.Response> depositMoney(double depositAmount, String userAccountID) async{
    String? jwtToken = await storage.read(key: "jwt");
    return await http.post(
        Uri.parse(GlobalConstants.API_ACCOUNTTRANSACTION + 'Deposit'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": 'Bearer ' + jwtToken.toString().replaceAll('"', '')},
        body: jsonEncode({
          "DebitAmount": depositAmount,
          "currentUserID" : userAccountID
        })
    );
  }

  static Future<http.Response> transferMoney(double amount, String userAccountID, String destinationAccountID) async{
    String? jwtToken = await storage.read(key: "jwt");
    return await http.post(
        Uri.parse(GlobalConstants.API_ACCOUNTTRANSACTION + 'Transfer'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": 'Bearer ' + jwtToken.toString().replaceAll('"', '')},
        body: jsonEncode({
          "DebitAmount": amount,
          "currentUserID" : userAccountID,
          "DestinationAccountID" : destinationAccountID
        })
    );
  }

  static Future<http.Response> withdrawMoney(double amount, String userAccountID) async{
    String? jwtToken = await storage.read(key: "jwt");
    return await http.post(
        Uri.parse(GlobalConstants.API_ACCOUNTTRANSACTION + 'Withdraw'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": 'Bearer ' + jwtToken.toString().replaceAll('"', '')},
        body: jsonEncode({
          "CreditAmount": amount,
          "currentUserID" : userAccountID
        })
    );
  }

  static Future<http.Response> getUsersWithAccount(String jwtToken) async{
    return await http.get(
      Uri.parse(GlobalConstants.API_User + 'UsersWithAccount'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        "Authorization": 'Bearer ' + jwtToken.toString().replaceAll('"', '')},
    );
  }

  static Future<http.Response> getUserDetail() async{
    String? userID = await storage.read(key: GlobalConstants.storageKeyLoggedInUserID);
    String? jwtToken = await storage.read(key: "jwt");
    return await http.get(
      Uri.parse(GlobalConstants.API_User + "UserDetails?userID=" + userID.toString()),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        "Authorization": 'Bearer ' + jwtToken.toString().replaceAll('"', '')},
    );
  }

  static Future<http.Response> getCurrentUserTransactions() async{
    String? jwtToken = await storage.read(key: "jwt");
    String? userID = await storage.read(key: GlobalConstants.storageKeyLoggedInUserID);
    return await http.get(
      Uri.parse(GlobalConstants.API_ACCOUNTTRANSACTION + "GetUserTransactionsByUserID?userID=" + userID.toString()),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        "Authorization": 'Bearer ' + jwtToken.toString().replaceAll('"', '')},
    );
  }

  static Future<http.Response> getChatUsers() async{
    return await http.get(
      Uri.parse(GlobalConstants.CHATSERVER_URL + "users"),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
      },
    );
  }
}