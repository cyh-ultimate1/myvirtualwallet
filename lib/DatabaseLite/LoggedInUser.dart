
import 'package:sqflite/sqflite.dart';

class LoggedInUser {
  String? username;

  LoggedInUser({
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': this.username,
    };
  }

  LoggedInUser.fromMap(Map<String, dynamic> map) {
    this.username = map['Username'];
  }
}
