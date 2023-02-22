import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBase {
  // Database _database = null;
  //
  // Future<Database> get database async {
  //   if (_database == null) _database = await initDB();
  //   return _database;
  // }

  initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'my_database.db'),
      version: 1,
      onCreate: _onCreate,
      // onUpgrade: (Database db, int oldVersion, int newVersion) => {},
    );
  }

  // 데이터베이스 테이블을 생성한다.
  static Future _onCreate(Database db, int version) async {
    // await db.execute('CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
    await db.execute('''
      CREATE TABLE Group (
        id INTEGER PRIMARY KEY,
        group_name TEXT NOT NULL,
      )
    ''');
  }
}
