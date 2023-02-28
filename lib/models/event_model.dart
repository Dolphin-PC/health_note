import 'package:flutter/material.dart';
import 'package:health_note/db/db_helper.dart';
import 'package:health_note/db/table_names.dart';
import 'package:health_note/models/group_exercise_model.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqlite_api.dart';

class EventModel {
  EventModel({
    Key? key,
    this.eventId,
    this.exerciseId,
    required this.day,
    required this.isComplete,
    this.isDelete = false,
  });

  final int? eventId;
  final int? exerciseId;
  final DateTime day;
  bool isComplete, isDelete;

  Map<String, dynamic> toMap() {
    return {
      'event_id': eventId,
      'exercise_id': exerciseId,
      'day': DateFormat("yyyy-MM-dd").format(day),
      'is_complete': isComplete,
      'is_delete': isDelete,
    };
  }

  static Future<List<EventModel>> selectList({required List whereArgs, bool isDelete = true}) async {
    final db = await DBHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(TableNames.event, where: 'day = ?', whereArgs: whereArgs);

    var list = List.generate(maps.length, (i) {
      return EventModel(
        eventId: maps[i]['event_id'],
        exerciseId: maps[i]['exercise_id'],
        day: DateTime.parse(maps[i]['day']),
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

  Future selectEventById() async {
    final db = await DBHelper().database;
    final map = await db.rawQuery('''
          select * from event    m 
       left join exercise       d1 on m.exercise_id = d1.id
       left join group_exercise d2 on d1.group_id   = d2.id
           where m.event_id = $eventId
      ''');
    // print(map);
    return map;
  }

  static Future<List<DateTime>> selectEventGroupByDay() async {
    final db = await DBHelper().database;

    // List<DateTime> resultList = [];
    final dayList = await db.rawQuery('''
          select day from event 
          where is_delete = false
        group by day;
      ''');

    return List.generate(dayList.length, (index) => DateTime.parse(dayList[index]['day'].toString()));
  }

  static Future<List<DateTime>> getEventsForGroupByDay(GroupExerciseModel groupExerciseModel) async {
    final db = await DBHelper().database;

    final dayList = await db.rawQuery('''
        select day
          from event           m 
          join exercise       d1 on m.exercise_id = d1.id
          join group_exercise d2 on d1.group_id   = d2.id
         where 1=1
         ${groupExerciseModel.id != 0 ? 'and d2.id = ${groupExerciseModel.id}' : ''}
      group by day;
      ''');
    return List.generate(dayList.length, (index) => DateTime.parse(dayList[index]['day'].toString()));
  }

  static Future<List<dynamic>> getEventsForGroupByGroup(GroupExerciseModel groupExerciseModel) async {
    final db = await DBHelper().database;

    List<dynamic> dayList = await db.rawQuery('''
        select d1.*
             , count(1)             as exercise_count
          from event                m 
          join exercise             d1 on m.exercise_id = d1.id
          join group_exercise       d2 on d1.group_id   = d2.id
      ${groupExerciseModel.id != 0 ? 'and d2.id = ${groupExerciseModel.id}' : ''}
      group by d1.id
       ''');
    return dayList;
  }
}
