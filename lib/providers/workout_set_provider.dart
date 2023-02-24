import 'package:flutter/cupertino.dart';
import 'package:health_note/models/workout_set_model.dart';

class WorkoutSetProvider extends ChangeNotifier {
  Future<List<WorkoutSetModel>> selectList({required whereArgs, bool isDelete = true}) async {
    return await WorkoutSetModel.selectList(whereArgs: whereArgs, isDelete: isDelete);
  }

  Future insertOne({required WorkoutSetModel workoutSetModel}) async {
    workoutSetModel.insert();
    notifyListeners();
  }

  Future deleteOne({required WorkoutSetModel workoutSetModel}) async {
    workoutSetModel.delete();
    notifyListeners();
  }

  Future updateOne({required WorkoutSetModel workoutSetModel, required WorkoutSetModel changeModel}) async {
    workoutSetModel.update(changeModel.toMap());
    notifyListeners();
  }
}
