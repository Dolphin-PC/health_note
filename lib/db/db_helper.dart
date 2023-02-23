import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();
  static final DBHelper _db = DBHelper._();
  factory DBHelper() => _db;

  static Database? _database;

  Future<Database> get database async => _database ??= await initDB();

  Future<Database> initDB() async {
    Database db = await openDatabase(
      join(await getDatabasesPath(), 'my_database.db'),
      version: 1,
      onCreate: onCreate,
      // onUpgrade: (Database db, int oldVersion, int newVersion) => {},
    );

    await devInitDB(db);

    return db;
  }

  // 데이터베이스 테이블을 생성한다.
  static Future onCreate(Database db, int version) async {
    print("_onCreate");
    await db.execute('CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
    await db.execute('CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT)');
  }

  static Future devInitDB(Database db) async {
    // await db.execute('DROP TABLE if exists Test');
    // await db.execute('DROP TABLE if exists Test2');
    // await db.execute('DROP TABLE if exists group_exercise');
    // await db.execute('DROP TABLE if exists exercise');

    String sql1 = '''
      CREATE TABLE if not exists group_exercise (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        group_name TEXT )
    ''';
    String sql2 = '''
      CREATE TABLE if not exists exercise (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        exercise_name TEXT,
        unit TEXT,
        is_count boolean,
        group_id INTEGER,
        FOREIGN KEY(group_id) REFERENCES group_exercise(id) )
    ''';
    await db.execute(sql1);
    await db.execute(sql2);
  }
}
