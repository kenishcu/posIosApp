import 'package:pos_ios_bvhn/sqflite/sqflite_database.dart';
import 'package:sqflite/sqflite.dart';

import 'model/user_model_sqflite.dart';

class UserSqfLite {

  final dbHelper = SqfLiteDatabase.instance;

  final table = 'users';

  Future queryRowCount() async {
    Database db = await dbHelper.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }


  Future findById(int id) async {
    Database db = await dbHelper.database;
    List<Map> maps =  await db.query(
        table,
        where: '_id = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return UserModelSqflite.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future insert (UserModelSqflite userModelSqflite) async {
    Database db = await dbHelper.database;
    return await db.insert(table, userModelSqflite.toMap());
  }

  Future update (UserModelSqflite userModelSqflite) async {
    Database db = await dbHelper.database;
    return await db.update(table, userModelSqflite.toMap(), where: '_id = ?', whereArgs: [userModelSqflite.id]);
  }

  Future delete (int id) async {
    Database db = await dbHelper.database;
    return await db.delete(table, where: '_id = ?', whereArgs: [id]);
  }
}
