import 'package:flutter/material.dart';
import 'package:health_note/models/event_model.dart';

class SetModel {
  SetModel({
    Key? key,
    required this.setId,
    required this.setName,
    required this.unitPerCount,
    required this.isComplete,
    required this.isDelete,
    required this.eventModel,
  });

  final int? setId;
  final String setName;
  int unitPerCount;
  bool isComplete, isDelete;
  EventModel eventModel;

  // Map<String, dynamic> toMap() {
  //   return {
  //     'set_id': setId,
  //     'set_name': setName,
  //     'unit_per_count': unitPerCount,
  //     'is_complete': isComplete,
  //     'is_delete': isDelete,
  //     'exercise_id': exerciseModel.id,
  //     'group_id': exerciseModel.groupId,
  //     'exercise_name': exerciseModel.exerciseName,
  //     'unit': exerciseModel.unit.toString(),
  //     'is_count': exerciseModel.isCount,
  //   };
  // }
  //
  // static Future<List<SetModel>> selectList({required List whereArgs, bool isDelete = true}) async {
  //   final db = await DBHelper().database;
  //   final List<Map<String, dynamic>> maps = await db.query(TableNames.set, where: 'day = ?', whereArgs: whereArgs);
  //
  //   var list = List.generate(maps.length, (i) {
  //     return SetModel(
  //         setId: maps[i]['set_id'],
  //         isComplete: maps[i]['is_complete'] == 1 ? true : false,
  //         isDelete: maps[i]['is_delete'] == 1 ? true : false,
  //         exerciseModel: ExerciseModel(
  //             id: maps[i]['exercise_id'],
  //             exerciseName: maps[i]['exercise_name'],
  //             unit: UNIT.fromString(maps[i]['unit']),
  //             isCount: maps[i]['is_count'] == 1 ? true : false,
  //             groupId: maps[i]['group_id']));
  //   });
  //   if (isDelete == false) {
  //     list = list.where((element) => element.isDelete == isDelete).toList();
  //   }
  //
  //   return list;
  // }
  //
  // Future<void> insert() async {
  //   final db = await DBHelper().database;
  //
  //   print(toMap());
  //
  //   // return;
  //   await db.insert(
  //     TableNames.set,
  //     toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }
  //
  // Future<void> delete() async {
  //   await update({'is_delete': true});
  // }
  //
  // Future<void> update(Map<String, dynamic> prmMap) async {
  //   final db = await DBHelper().database;
  //   await db.update(TableNames.set, prmMap, where: 'set_id = ?', whereArgs: [setId]);
  // }
}
