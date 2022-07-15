import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  // we'll have static fields so we don't have to instantiate it
  static Future<sql.Database> accessDB() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'chats.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE messages(messageId TEXT PRIMARY KEY, senderId TEXT, recieverId TEXT, isOwner INTEGER, text TEXT, isRead INTEGER, createdAt TEXT)'); //works almost like mySQL -- REAL is like double but for sql
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, dynamic> data) async {
    //inside the database in a folder named places if it doesn't find that file it creates the database
    final db = await DBHelper.accessDB();
    db.insert(table, data,
        conflictAlgorithm: sql.ConflictAlgorithm
            .replace); //so that if we try to add an element with an id that already exists it overwrite the info
  }

  static Future<List<Map<String, dynamic>>> getData(
    String table,
  ) async {
    final db = await DBHelper.accessDB();
    return db.query(table);
  }
}
