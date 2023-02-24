import 'package:flutter/material.dart';
import 'package:health_note/common/util.dart';
import 'package:health_note/enums/unit.dart';
import 'package:health_note/models/event_model.dart';
import 'package:health_note/models/exercise_model.dart';
import 'package:intl/intl.dart';

Map<DateTime, List<EventModel>> eventSource = {
  DateTime.utc(2023, 2, 24): [
    EventModel(
      eventId: 1,
      day: Util.getNowSimple,
      isComplete: false,
      exerciseModel: ExerciseModel(
        id: 1,
        groupId: 10,
        exerciseName: "가슴",
        unit: UNIT.kg,
        isCount: false,
      ),
    ),
    EventModel(
      eventId: 2,
      day: Util.getNowSimple,
      isComplete: false,
      exerciseModel: ExerciseModel(
        id: 2,
        groupId: 10,
        exerciseName: "벤치프레스",
        unit: UNIT.kg,
        isCount: false,
      ),
    ),
    EventModel(
      eventId: 2,
      day: Util.getNowSimple,
      isComplete: false,
      exerciseModel: ExerciseModel(
        id: 2,
        groupId: 10,
        exerciseName: "벤치프레스",
        unit: UNIT.kg,
        isCount: false,
      ),
    ),
  ],
};

class EventProvider extends ChangeNotifier {
  DateTime _selectedDay = Util.getNowSimple;

  set selectedDay(select) {
    _selectedDay = select;
    print(_selectedDay);
  }

  get selectedDay => _selectedDay;

  Future<List<EventModel>> selectList({required whereArgs, bool isDelete = true}) async {
    return await EventModel.selectList(whereArgs: whereArgs, isDelete: isDelete);
  }

  Future<List<EventModel>> getEventsPerDay({required DateTime day, bool isDelete = true}) async {
    List whereArgs = [DateFormat("yyyy-MM-dd").format(day)];

    return await selectList(whereArgs: whereArgs, isDelete: isDelete);
  }

  Future<List<EventModel>> getEventsForDay({required DateTime day, bool isDelete = true}) async {
    var map = await getEventsPerDay(day: _selectedDay, isDelete: isDelete);
    print(map);
    // var list = await selectList();
    // print(list);
    // print(day);
    return eventSource[day] ?? [];
  }

  Future insertOne({required EventModel eventModel}) async {
    eventModel.insert();
    notifyListeners();
  }

  Future deleteOne({required EventModel eventModel}) async {
    eventModel.delete();
    notifyListeners();
  }

  Future updateOne({required EventModel eventModel, required EventModel changeModel}) async {
    eventModel.update(changeModel.toMap());
    notifyListeners();
  }
}
