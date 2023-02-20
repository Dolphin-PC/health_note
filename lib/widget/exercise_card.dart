import 'package:flutter/material.dart';
import 'package:health_note/models/exercise_model.dart';
import 'package:health_note/styles/color_styles.dart';

class ExerciseCard extends StatelessWidget {
  const ExerciseCard(
      {Key? key, required this.isModifyMode, required this.exerciseModel})
      : super(key: key);

  final bool isModifyMode;
  final ExerciseModel exerciseModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                isModifyMode
                    ? Icon(Icons.remove_circle, color: Colors.deepOrange[400])
                    : Icon(Icons.add_circle, color: ColorStyles.primaryColor),
                SizedBox(width: 10),
                Text(exerciseModel.exerciseName),
              ],
            ),
          ),
          Visibility(
            visible: isModifyMode,
            child: GestureDetector(
              child: Text('수정'),
            ),
          ),
        ],
      ),
    );
  }
}
