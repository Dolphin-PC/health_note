import 'package:health_note/db/db_helper.dart';
import 'package:sqflite/sqflite.dart';

const String tableName_groupExercise = "group_exercise";

class GroupExerciseModel {
  GroupExerciseModel({this.id, required this.groupName});

  int? id;
  final String groupName;

  // 객체를 Map으로 변환합니다. key는 데이터베이스 컬럼 명과 동일해야 합니다.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'group_name': groupName,
    };
  }

  static Future<List<GroupExerciseModel>> selectList() async {
    final db = await DBHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName_groupExercise);

    return List.generate(maps.length, (i) {
      return GroupExerciseModel(
        id: maps[i]['id'],
        groupName: maps[i]['group_name'],
      );
    });
  }

  Future<void> insert() async {
    final db = await DBHelper().database;

    await db.insert(
      tableName_groupExercise,
      toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
