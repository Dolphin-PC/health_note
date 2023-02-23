import 'package:flutter/foundation.dart';
import 'package:health_note/models/group_exercise_model.dart';

class GroupExerciseProvider extends ChangeNotifier {
  Future<List<GroupExerciseModel>> selectList() async {
    return await GroupExerciseModel.selectList();
  }

  Future insertOne({required GroupExerciseModel groupExerciseModel}) async {
    groupExerciseModel.insert();
    notifyListeners();
  }

  Future deleteOne({required GroupExerciseModel groupExerciseModel}) async {
    groupExerciseModel.delete();
    notifyListeners();
  }

  Future updateOne({required GroupExerciseModel groupExerciseModel, required GroupExerciseModel changeModel}) async {
    groupExerciseModel.update(changeModel.toMap());
    notifyListeners();
  }
}
