import 'package:health_note/db/db.dart';
import 'package:sqflite/sqflite.dart';

class GroupExerciseModel {
  GroupExerciseModel({required this.groupId, required this.groupName});

  final int groupId;
  final String groupName;
  final String _tableName = "group";

  // 객체를 Map으로 변환합니다. key는 데이터베이스 컬럼 명과 동일해야 합니다.
  Map<String, dynamic> toMap() {
    return {
      'id': groupId,
      'group_name': groupName,
    };
  }

  // Future<List<GroupExerciseModel>> selectList() async {
  //   // 데이터베이스 reference를 얻습니다.
  //   final Database db = await DataBase.initDb();
  //
  //   // 모든 Dog를 얻기 위해 테이블에 질의합니다.
  //   final List<Map<String, dynamic>> maps = await db.query('dogs');
  //
  //   // List<Map<String, dynamic>를 List<Dog>으로 변환합니다.
  //   return List.generate(maps.length, (i) {
  //     return Dog(
  //       id: maps[i]['id'],
  //       name: maps[i]['name'],
  //       age: maps[i]['age'],
  //     );
  //   });
  // }

  // 데이터베이스에 객체를 추가하는 함수를 정의합니다.
  Future<void> insert() async {
    final db = await DataBase().initDB();

    await db.insert(
      _tableName,
      toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
