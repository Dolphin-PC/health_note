import 'package:health_note/db/db_helper.dart';
import 'package:health_note/db/table_names.dart';
import 'package:sqflite/sqflite.dart';

class GroupExerciseModel {
  GroupExerciseModel({this.id, required this.groupName});

  final int? id;
  String groupName;

  // 객체를 Map으로 변환합니다. key는 데이터베이스 컬럼 명과 동일해야 합니다.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'group_name': groupName,
    };
  }

  static Future<List<GroupExerciseModel>> selectList() async {
    final db = await DBHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(TableNames.groupExercise);

    var list = List.generate(maps.length, (i) {
      return GroupExerciseModel(
        id: maps[i]['id'],
        groupName: maps[i]['group_name'],
      );
    });

    print(list);

    return list;
  }

  Future<void> insert() async {
    final db = await DBHelper().database;

    await db.insert(
      TableNames.groupExercise,
      toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete() async {
    final db = await DBHelper().database;
    await db.delete(TableNames.groupExercise, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> update(Map<String, dynamic> prmMap) async {
    final db = await DBHelper().database;
    await db.update(TableNames.groupExercise, prmMap, where: 'id = ?', whereArgs: [id]);
  }
}
