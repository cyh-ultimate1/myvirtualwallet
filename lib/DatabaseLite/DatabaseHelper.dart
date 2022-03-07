import 'dart:async';
import 'dart:io';

import 'package:myvirtualwallet/DatabaseLite/LoggedInUser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;
  static final loggedInUserTable = 'LoggedInUser';
  static final loggedInUserTableId = 'Id';
  static final loggedInUserTableUsername = 'Username';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + _databaseName;
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $loggedInUserTable (
            $loggedInUserTableId INTEGER PRIMARY KEY,
            $loggedInUserTableUsername TEXT NOT NULL
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(loggedInUserTable, row);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String username = row[loggedInUserTableUsername];
    return await db.update(loggedInUserTable, row, where: '$loggedInUserTableUsername = ?', whereArgs: [username]);
  }

  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $loggedInUserTable'));
  }

  Future<String> getLoggedInUsername() async {
    Database db = await instance.database;
    var result = await db.query(loggedInUserTable, limit: 1);
    return (LoggedInUser.fromMap(result.first)).username!;
  }
}