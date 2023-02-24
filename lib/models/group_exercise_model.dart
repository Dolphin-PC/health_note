import 'package:health_note/db/db_helper.dart';
import 'package:health_note/db/table_names.dart';
import 'package:sqflite/sqflite.dart';

class GroupExerciseModel {
  GroupExerciseModel({this.id, required this.groupName, this.isDelete = false});

  final int? id;
  String groupName;
  bool isDelete;

  // 객체를 Map으로 변환합니다. key는 데이터베이스 컬럼 명과 동일해야 합니다.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'group_name': groupName,
      'is_delete': isDelete,
    };
  }

  static Future<List<GroupExerciseModel>> selectList() async {
    final db = await DBHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(TableNames.groupExercise);

    var list = List.generate(maps.length, (i) {
      return GroupExerciseModel(
        id: maps[i]['id'],
        groupName: maps[i]['group_name'],
        isDelete: maps[i]['is_delete'] == 1 ? true : false,
      );
    });

    return list;
  }

  static Future<GroupExerciseModel> selectById(int id) async {
    final db = await DBHelper().database;
    final List<Map<String, dynamic>> map = await db.query(TableNames.event, where: 'id = ?', whereArgs: [id]);

    return GroupExerciseModel(id: map[0]['id'], groupName: map[0]['group_name'], isDelete: map[0]['is_delete'] == 1 ? true : false);
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
    update({'is_delete': true});
  }

  Future<void> update(Map<String, dynamic> prmMap) async {
    final db = await DBHelper().database;
    await db.update(TableNames.groupExercise, prmMap, where: 'id = ?', whereArgs: [id]);
  }
}
