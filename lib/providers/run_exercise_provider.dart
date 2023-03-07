import 'package:flutter/material.dart';
import 'package:health_note/models/workout_set_model.dart';

class RunExerciseProvider extends ChangeNotifier {
  String runDay = '';
  List<dynamic> runList = [];
  bool isInit = false;

  Future<void> init({required String day}) async {
    runDay = day;
    runList = await WorkoutSetModel.selectListForRunExercise(day: runDay);

    isInit = true;
    notifyListeners();
  }
}
