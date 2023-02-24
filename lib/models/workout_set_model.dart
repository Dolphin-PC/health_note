import 'package:flutter/material.dart';
import 'package:health_note/db/db_helper.dart';
import 'package:health_note/db/table_names.dart';
import 'package:sqflite/sqlite_api.dart';

class WorkoutSetModel {
  WorkoutSetModel({
    Key? key,
    this.workoutSetId,
    required this.eventId,
    this.setIdx,
    this.isComplete = false,
    this.isDelete = false,
  });

  final int? workoutSetId;
  final int? eventId;
  final int? setIdx;
  bool isComplete, isDelete;

  Map<String, dynamic> toMap() {
    return {
      'workout_set_id': workoutSetId,
      'event_id': eventId,
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
