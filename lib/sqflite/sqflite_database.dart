import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SqfLiteDatabase {
  static final databaseName = "MyDatabase.db";
  static final databaseVersion = 1;
  static final tableUser = 'users';

  // user table
  static final columnId = '_id';
  static final columnName = 'name';
  static final columnEmail = 'email';
  static final columnUsername = 'userName';
  static final columnBranchId = 'branchId';
  static final columnBranchCode = 'branchCode';
  static final columnBranchName = 'branchName';
  static final columnRoleId = 'roleId';
  static final columnRoleCode = 'roleCode';
  static final columnRoleName = 'roleName';

  SqfLiteDatabase._privateConstructor();

  static final SqfLiteDatabase instance = SqfLiteDatabase._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, databaseName);

    return await openDatabase(path,
      version: databaseVersion,
      onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableUser (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnUsername TEXT NOT NULL,
            $columnEmail TEXT NOT NULL,
            $columnBranchId TEXT NOT NULL,
            $columnBranchName TEXT NOT NULL,
            $columnBranchCode TEXT NOT NULL,
            $columnRoleId INTEGER NOT NULL,
            $columnRoleName TEXT NOT NULL,
            $columnRoleCode TEXT NOT NUll
          )
          ''');
  }
}
