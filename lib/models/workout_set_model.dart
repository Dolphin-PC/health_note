import 'package:flutter/foundation.dart';
import 'package:health_note/db/db_helper.dart';
import 'package:health_note/db/table_names.dart';
import 'package:health_note/main.dart';
import 'package:sqflite/sqlite_api.dart';

class WorkoutSetModel {
  WorkoutSetModel({
    Key? key,
    this.workoutSetId,
    required this.eventId,
    this.unitCount,
    this.count,
    this.setIdx,
    this.isComplete = false,
    this.isDelete = false,
  });

  int? workoutSetId;
  final int? eventId;
  int? unitCount, count;
  final int? setIdx;
  bool isComplete, isDelete;

  Map<String, dynamic> toMap() {
    return {
      'workout_set_id': workoutSetId,
      'event_id': eventId,
      'unit_count': unitCount,
      'count': count,
      'set_idx': setIdx,
      'is_complete': isComplete,
      'is_delete': isDelete,
    };
  }

  static Future<List<WorkoutSetModel>> selectList({required List whereArgs, bool isDelete = true}) async {
    final db = await DBHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(TableNames.workoutSet, where: 'event_id = ?', whereArgs: whereArgs);

    var list = List.generate(maps.length, (i) {
      return WorkoutSetModel(
        workoutSetId: maps[i]['workout_set_id'],
        eventId: maps[i]['event_id'],
        unitCount: maps[i]['unit_count'],
        count: maps[i]['count'],
        setIdx: maps[i]['set_idx'],
        isComplete: maps[i]['is_complete'] == 1 ? true : false,
        isDelete: maps[i]['is_delete'] == 1 ? true : false,
      );
    });
    if (isDelete == false) {
      list = list.where((element) => element.isDelete == isDelete).toList();
    }

    return list;
  }

  static Future<List<dynamic>> selectListForRunExercise({required String day}) async {
    final db = await DBHelper().database;
    String sqlStr = '''
      select /* workout_set_model.selectListForRunExercise */
             d3.group_name    as group_exercise_name
           , d2.exercise_name as exercise_name
           , d2.unit          as exercise_unit
           , d2.is_count      as is_count
           , d1.day           as day
           , d1.is_complete   as event_complete
           , m.workout_set_id as workout_set_id
           , m.unit_count     as unit_count
           , m.count          as count
           , m.is_complete    as workout_is_complete
           , m.event_id       as event_id
        from workout_set     m 
        join event          d1 on m.event_id  = d1.event_id
        join exercise       d2 on d1.event_id = d2.id
        join group_exercise d3 on d2.group_id = d3.id
       where d1.day = '$day'
         and m.is_delete = 0
       order by m.event_id asc, m.workout_set_id asc
    ''';
    // logger.d(sqlStr);
    final List<dynamic> list = await db.rawQuery(sqlStr);

    return list;
  }

  Future<void> insert() async {
    final db = await DBHelper().database;

    await db.insert(
      TableNames.workoutSet,
      toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete() async {
    await update({'is_delete': true});
  }

  Future<void> update(Map<String, dynamic> prmMap) async {
    final db = await DBHelper().database;
    await db.update(TableNames.workoutSet, prmMap, where: 'workout_set_id = ?', whereArgs: [workoutSetId]);
  }
}
