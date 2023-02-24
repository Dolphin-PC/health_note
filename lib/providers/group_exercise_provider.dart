import 'package:flutter/foundation.dart';
import 'package:health_note/models/group_exercise_model.dart';

class GroupExerciseProvider extends ChangeNotifier {
  List<GroupExerciseModel> _groupExerciseList = [];

  get groupExerciseList => _groupExerciseList;
  set groupExerciseList(list) => _groupExerciseList = list;

  Future<List<GroupExerciseModel>> selectList() async {
    _groupExerciseList = await GroupExerciseModel.selectList();
    return _groupExerciseList;
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
