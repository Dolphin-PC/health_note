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
    // await db.execute('CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
    // await db.execute('CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT)');
  }

  static Future devInitDB(Database db) async {
    // await db.execute('DROP TABLE if exists group_exercise');
    // await db.execute('DROP TABLE if exists exercise');
    // await db.execute('DROP TABLE if exists event');
    // await db.execute('DROP TABLE if exists workout_set');
    // await db.execute('DROP TABLE if exists youtube_music');

    String sql1 = '''
      CREATE TABLE if not exists group_exercise (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        group_name TEXT    NOT NULL,
        is_delete  BOOLEAN NOT NULL 
      );
    ''';
    String sql2 = '''
      CREATE TABLE if not exists exercise (
        id            INTEGER PRIMARY KEY AUTOINCREMENT,
        group_id      INTEGER NOT NULL,
        exercise_name TEXT,
        unit          TEXT,
        is_count      BOOLEAN NOT NULL,
        is_delete     BOOLEAN NOT NULL,
        
        FOREIGN KEY(group_id) REFERENCES group_exercise(id)
      );
    ''';
    String sql3 = '''
      CREATE TABLE if not exists event (
        event_id      INTEGER     PRIMARY KEY AUTOINCREMENT,
        exercise_id   INTEGER     NOT NULL,
        day           TIMESTAMP           ,
        is_complete   BOOLEAN     NOT NULL,
        is_delete     BOOLEAN     NOT NULL,
        
        FOREIGN KEY(exercise_id) REFERENCES exercise(id)
      );
    ''';

    String sql4 = '''
      CREATE TABLE if not exists workout_set (
          workout_set_id    INTEGER PRIMARY KEY AUTOINCREMENT,
          event_id          INTEGER NOT NULL,
          set_idx           INTEGER         ,
          unit_count        INTEGER         ,
          count             INTEGER         ,
          is_complete       BOOLEAN NOT NULL,
          is_delete         BOOLEAN NOT NULL,
          
          FOREIGN KEY(event_id) REFERENCES event(event_id)
      );
    ''';

    String sql5 = '''
      CREATE TABLE if not exists youtube_music (
          id  VARCHAR PRIMARY KEY,
          url VARCHAR NOT NULL
      );
    ''';

    await db.execute(sql1);
    await db.execute(sql2);
    await db.execute(sql3);
    await db.execute(sql4);
    await db.execute(sql5);
  }
}
