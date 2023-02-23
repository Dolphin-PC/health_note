import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();
  static final DBHelper _db = DBHelper._();
  factory DBHelper() => _db;

  static Database? _database;

  Future<Database> get database async => _database ??= await initDB();

  Future<Database> initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'my_database.db'),
      version: 1,
      onCreate: onCreate,
      // onUpgrade: (Database db, int oldVersion, int newVersion) => {},
    );
  }

  // 데이터베이스 테이블을 생성한다.
  static Future onCreate(Database db, int version) async {
    print("_onCreate");
    await db.execute('CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
    await db.execute('CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT)');
  }

  static Future devInitDB(Database db) async {
    await db.execute('DROP TABLE if exists Test');
    await db.execute('DROP TABLE if exists Test2');
    await db.execute('DROP TABLE if exists group_exercise');

    String sql1 = '''
      CREATE TABLE if not exists group_exercise (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        group_name TEXT )
    ''';
    await db.execute(sql1);
  }
}
