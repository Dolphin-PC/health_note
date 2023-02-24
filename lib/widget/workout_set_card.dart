import 'package:flutter/material.dart';
import 'package:health_note/models/workout_set_model.dart';
import 'package:health_note/providers/workout_set_provider.dart';
import 'package:provider/provider.dart';

class WorkoutSetCard extends StatefulWidget {
  const WorkoutSetCard({Key? key, required this.workoutSetModel}) : super(key: key);

  final WorkoutSetModel workoutSetModel;

  @override
  State<WorkoutSetCard> createState() => _WorkoutSetCardState();
}

class _WorkoutSetCardState extends State<WorkoutSetCard> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    WorkoutSetProvider workoutSetProvider = Provider.of(context, listen: true);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: widget.workoutSetModel.isComplete,
              onChanged: (bool) {
                // setState(() => isChecked = bool!);
              },
            ),
            Text('set 1'),
          ],
        ),
        Text('10 회'),
      ],
    );
  }
}
