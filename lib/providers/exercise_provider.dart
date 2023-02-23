import 'package:flutter/cupertino.dart';
import 'package:health_note/models/exercise_model.dart';

class ExerciseProvider extends ChangeNotifier {
  Future<List<ExerciseModel>> selectList(int groupId) async {
    return await ExerciseModel.selectList(groupId: groupId);
  }

  Future insertOne({required ExerciseModel exerciseModel}) async {
    exerciseModel.insert();
    notifyListeners();
  }

  Future deleteOne({required ExerciseModel exerciseModel}) async {
    exerciseModel.delete();
    notifyListeners();
  }

  Future updateOne({required ExerciseModel exerciseModel, required ExerciseModel changeModel}) async {
    exerciseModel.update(changeModel.toMap());
    notifyListeners();
  }
}
