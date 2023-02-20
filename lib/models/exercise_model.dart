import 'package:health_note/enums/unit.dart';

class ExerciseModel {
  ExerciseModel({required this.exerciseName, required this.unit, required this.isCount});

  late String exerciseName;
  late UNIT unit;
  late bool isCount;


  ExerciseModel.fromJson(Map<String, dynamic> json) {
    exerciseName = json['exerciseName'];
    unit = UNIT.fromJson(json['unit']);
    isCount = json['isCount'];
  }

  Map<String, dynamic> toJson() => {'exerciseName': exerciseName};
}
