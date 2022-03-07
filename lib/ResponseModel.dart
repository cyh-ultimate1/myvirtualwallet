
import 'package:myvirtualwallet/Models/AccountDetails.dart';

class LoginResponse{

  final String token;
  final String userID;
  final String userName;
  LoginResponse(this.token, this.userID, this.userName);

  LoginResponse.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        userID = json['userID'],
        userName = json['userName'];

}

class UserResponse{
  String userName;
  String accountDetailsID;
  UserResponse(this.userName, this.accountDetailsID);

  UserResponse.fromJson(Map<String, dynamic> json)
      : userName = json['userName'],
        accountDetailsID = json['accountDetailsID'];
}

class UserDetailsResponse{
  UserDetailsResponse(this.accountDetails);
  late AccountDetails accountDetails;

  factory UserDetailsResponse.fromJson(Map<String, dynamic> json){
    return UserDetailsResponse(json['']);
  }
}