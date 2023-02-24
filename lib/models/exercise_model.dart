import 'package:health_note/db/db_helper.dart';
import 'package:health_note/db/table_names.dart';
import 'package:health_note/enums/unit.dart';
import 'package:sqflite/sqlite_api.dart';

class ExerciseModel {
  ExerciseModel({
    this.id,
    required this.groupId,
    required this.exerciseName,
    required this.unit,
    required this.isCount,
    this.isDelete = false,
  });

  final int? id;
  final int groupId;
  String exerciseName;
  UNIT unit;
  bool isCount, isDelete;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'group_id': groupId,
      'exercise_name': exerciseName,
      'unit': unit.toString(),
      'is_count': isCount,
      'is_delete': isDelete,
    };
  }

  static Future<List<ExerciseModel>> selectList({required int groupId, bool isDelete = true}) async {
    final db = await DBHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(TableNames.exercise, where: 'group_id = ?', whereArgs: [groupId]);

    List<ExerciseModel> list = List.generate(maps.length, (i) {
      return ExerciseModel(
        id: maps[i]['id'],
        groupId: maps[i]['group_id'],
        exerciseName: maps[i]['exercise_name'],
        unit: UNIT.fromString(maps[i]['unit']),
        isCount: maps[i]['is_count'] == 1 ? true : false,
        isDelete: maps[i]['is_delete'] == 1 ? true : false,
      );
    });
    if (isDelete == false) {
      list = list.where((element) => element.isDelete == isDelete).toList();
    }

    return list;
  }

  Future<void> insert() async {
    final db = await DBHelper().database;

    await db.insert(
      TableNames.exercise,
      toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete() async {
    await update({'is_delete': true});
  }

  Future<void> update(Map<String, dynamic> prmMap) async {
    final db = await DBHelper().database;
    await db.update(TableNames.exercise, prmMap, where: 'id = ?', whereArgs: [id]);
  }
}
