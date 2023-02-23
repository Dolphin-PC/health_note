import 'package:flutter/material.dart';
import 'package:health_note/common/util.dart';
import 'package:health_note/enums/unit.dart';
import 'package:health_note/models/event_model.dart';
import 'package:health_note/models/exercise_model.dart';

Map<DateTime, List<EventModel>> eventSource = {
  DateTime.utc(2023, 2, 23): [
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
  Future<List<EventModel>> getEventsForDay(DateTime day) async {
    print(day);
    return eventSource[day] ?? [];
  }
}
