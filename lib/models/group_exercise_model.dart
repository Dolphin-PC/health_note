import 'dart:convert';

import 'package:health_note/models/exercise_model.dart';

class GroupExerciseModel {
  GroupExerciseModel({required this.groupName});

  late String groupName;
  late List<ExerciseModel> exerciseList;

  GroupExerciseModel.fromJson(Map<String, dynamic> json) {
    groupName = json['groupName'];

    List<dynamic> listFromJson = json['exerciseList'];
    exerciseList = listFromJson.map((exercise) {
      return ExerciseModel.fromJson(exercise);
    }).toList();
  }

}
