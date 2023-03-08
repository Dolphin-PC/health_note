import 'package:flutter/cupertino.dart';
import 'package:health_note/models/workout_set_model.dart';

class WorkoutSetProvider extends ChangeNotifier {
  WorkoutSetModel? _selectedWorkoutSetModel;

  set selectedWorkoutSetModel(WorkoutSetModel? workoutSetModel) {
    if (_selectedWorkoutSetModel?.workoutSetId == workoutSetModel?.workoutSetId) {
      _selectedWorkoutSetModel = null;
    } else {
      _selectedWorkoutSetModel = workoutSetModel;
    }
    notifyListeners();
  }

  WorkoutSetModel? get selectedWorkoutSetModel => _selectedWorkoutSetModel;

  Future<List<WorkoutSetModel>> selectList({required whereArgs, bool isDelete = true}) async {
    return await WorkoutSetModel.selectList(whereArgs: whereArgs, isDelete: isDelete);
  }

  Future<List<dynamic>> selectListForRunExercise({required String day}) async {
    return await WorkoutSetModel.selectListForRunExercise(day: day);
  }

  Future insert({required WorkoutSetModel workoutSetModel}) async {
    workoutSetModel.insert();
    notifyListeners();
  }

  Future delete({required WorkoutSetModel workoutSetModel}) async {
    workoutSetModel.delete();
    notifyListeners();
  }

  Future update({required WorkoutSetModel workoutSetModel, required WorkoutSetModel changeModel}) async {
    workoutSetModel.update(changeModel.toMap());
    notifyListeners();
  }

  Future updateOther({ required Map<String, dynamic> prmMap, required int workoutSetId}) async {
    WorkoutSetModel.updateOther(prmMap : prmMap, workoutSetId : workoutSetId);
    notifyListeners();
  }
}
