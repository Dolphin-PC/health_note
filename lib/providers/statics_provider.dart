import 'package:flutter/cupertino.dart';
import 'package:health_note/models/event_model.dart';
import 'package:health_note/models/group_exercise_model.dart';

class StaticsProvider extends ChangeNotifier {
  GroupExerciseModel _selectedGroupExerciseModel = GroupExerciseModel(groupName: '전체보기', id: 0, isDelete: false);

  Future<List<GroupExerciseModel>> get groupExerciseList async {
    return await GroupExerciseModel.selectList(isDelete: false);
  }

  GroupExerciseModel get selectedGroupExerciseModel => _selectedGroupExerciseModel;

  set selectedGroupExerciseModel(GroupExerciseModel value) {
    _selectedGroupExerciseModel = value;
    notifyListeners();
  }

  Future<List<DateTime>> getEventsForGroupByDay() async {
    return await EventModel.getEventsForGroupByDay(_selectedGroupExerciseModel);
  }

  Future<List<dynamic>> getEventsForGroupByGroup() async {
    return await EventModel.getEventsForGroupByGroup(_selectedGroupExerciseModel);
  }
}
