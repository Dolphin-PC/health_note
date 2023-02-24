import 'package:flutter/material.dart';
import 'package:health_note/db/db_helper.dart';
import 'package:health_note/db/table_names.dart';
import 'package:health_note/enums/unit.dart';
import 'package:health_note/models/exercise_model.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqlite_api.dart';

class EventModel extends ExerciseModel {
  EventModel({Key? key, this.eventId, required this.day, required this.isComplete, required this.exerciseModel, this.isDelete = false})
      : super(
          id: exerciseModel.id,
          groupId: exerciseModel.groupId,
          exerciseName: exerciseModel.exerciseName,
          unit: exerciseModel.unit,
          isCount: exerciseModel.isCount,
        );

  final int? eventId;
  final DateTime day;
  bool isComplete, isDelete;
  final ExerciseModel exerciseModel;

  Map<String, dynamic> toMap() {
    return {
      'event_id': eventId,
      'day': DateFormat("yyyy-MM-dd").format(day),
      'is_complete': isComplete,
      'exercise_id': exerciseModel.id,
      'group_id': exerciseModel.groupId,
      'exercise_name': exerciseModel.exerciseName,
      'unit': exerciseModel.unit.toString(),
      'is_count': exerciseModel.isCount,
      'is_delete': isDelete,
    };
  }

  static Future<List<EventModel>> selectList({required List whereArgs, bool isDelete = true}) async {
    final db = await DBHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(TableNames.event, where: 'day = ?', whereArgs: whereArgs);

    var list = List.generate(maps.length, (i) {
      return EventModel(
          eventId: maps[i]['event_id'],
          day: DateTime.parse(maps[i]['day']),
          isComplete: maps[i]['is_complete'] == 1 ? true : false,
          isDelete: maps[i]['is_delete'] == 1 ? true : false,
          exerciseModel: ExerciseModel(
              id: maps[i]['exercise_id'],
              exerciseName: maps[i]['exercise_name'],
              unit: UNIT.fromString(maps[i]['unit']),
              isCount: maps[i]['is_count'] == 1 ? true : false,
              groupId: maps[i]['group_id']));
    });
    if (isDelete == false) {
      list = list.where((element) => element.isDelete == isDelete).toList();
    }

    return list;
  }

  Future<void> insert() async {
    final db = await DBHelper().database;

    print(toMap());

    // return;
    await db.insert(
      TableNames.event,
      toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete() async {
    await update({'is_delete': true});
  }

  Future<void> update(Map<String, dynamic> prmMap) async {
    final db = await DBHelper().database;
    await db.update(TableNames.event, prmMap, where: 'event_id = ?', whereArgs: [eventId]);
  }
}
