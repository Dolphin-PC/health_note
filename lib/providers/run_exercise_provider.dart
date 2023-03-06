import 'package:flutter/material.dart';
import 'package:health_note/models/exercise_model.dart';
import 'package:health_note/models/group_exercise_model.dart';
import 'package:health_note/models/workout_set_model.dart';

class RunExerciseProvider extends ChangeNotifier {
  List<GroupExerciseModel> _groupExerciseList = [];
  List<ExerciseModel> _exerciseList = [];
  List<WorkoutSetModel> _workoutSetList = [];

  void init() {
    _groupExerciseList =
  }

}