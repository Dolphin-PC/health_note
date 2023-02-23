import 'package:flutter/material.dart';
import 'package:health_note/models/exercise_model.dart';

class EventModel extends ExerciseModel {
  EventModel({
    Key? key,
    this.eventId,
    required this.day,
    required this.exerciseModel,
    required this.isComplete,
  }) : super(
          exerciseName: exerciseModel.exerciseName,
          groupId: exerciseModel.groupId,
          isCount: exerciseModel.isCount,
          unit: exerciseModel.unit,
          id: exerciseModel.id,
        );

  final int? eventId;
  final DateTime day;
  final ExerciseModel exerciseModel;
  final bool isComplete;
}
