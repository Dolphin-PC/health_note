import 'package:flutter/material.dart';
import 'package:health_note/models/workout_set_model.dart';
import 'package:health_note/providers/workout_set_provider.dart';
import 'package:provider/provider.dart';

class WorkoutSetCard extends StatefulWidget {
  const WorkoutSetCard({Key? key, required this.workoutSetModel, required this.index, this.exerciseInfo}) : super(key: key);

  final WorkoutSetModel workoutSetModel;
  final int index;
  final exerciseInfo;

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
                widget.workoutSetModel.isComplete = bool!;
                workoutSetProvider.updateOne(workoutSetModel: widget.workoutSetModel, changeModel: widget.workoutSetModel);
                // setState(() => isChecked = bool!);
              },
            ),
            Text('SET ${widget.index}'),
          ],
        ),
        Row(
          children: [
            Text('${widget.workoutSetModel.unitCount} ${widget.exerciseInfo['unit']}'),
            Visibility(
              visible: widget.exerciseInfo['is_count'] == 1,
              child: Row(
                children: [
                  Text(' X '),
                  Text('${widget.workoutSetModel.count} 회'),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
