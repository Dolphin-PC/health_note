import 'package:health_note/db/db_helper.dart';
import 'package:health_note/db/table_names.dart';
import 'package:health_note/enums/unit.dart';
import 'package:sqflite/sqlite_api.dart';

class ExerciseModel {
  ExerciseModel({
    this.id,
    required this.exerciseName,
    required this.unit,
    required this.isCount,
    required this.groupId,
  });

  final int? id;
  String exerciseName;
  UNIT unit;
  bool isCount;
  final int groupId;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exercise_name': exerciseName,
      'unit': unit.toString(),
      'is_count': isCount,
      'group_id': groupId,
    };
  }

  static Future<List<ExerciseModel>> selectList({required int groupId}) async {
    final db = await DBHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(TableNames.exercise, where: 'group_id = ?', whereArgs: [groupId]);

    return List.generate(maps.length, (i) {
      return ExerciseModel(
        id: maps[i]['id'],
        exerciseName: maps[i]['exercise_name'],
        unit: UNIT.fromDB(maps[i]['unit']),
        isCount: maps[i]['is_count'],
        groupId: maps[i]['group_id'],
      );
    });
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
    final db = await DBHelper().database;
    await db.delete(TableNames.exercise, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> update(Map<String, dynamic> prmMap) async {
    final db = await DBHelper().database;
    await db.update(TableNames.exercise, prmMap, where: 'id = ?', whereArgs: [id]);
  }
}
