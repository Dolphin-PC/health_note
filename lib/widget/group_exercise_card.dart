import 'package:flutter/material.dart';
import 'package:health_note/models/group_exercise_model.dart';
import 'package:health_note/styles/text_styles.dart';

class GroupExerciseCard extends StatefulWidget {
  const GroupExerciseCard({Key? key, required this.isModifyMode, required this.groupExerciseModel}) : super(key: key);

  final bool isModifyMode;
  final GroupExerciseModel groupExerciseModel;

  @override
  State<GroupExerciseCard> createState() => _GroupExerciseCardState();
}

class _GroupExerciseCardState extends State<GroupExerciseCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.groupExerciseModel.groupName,
                style: TextStyles.titleText,
              ),
              Visibility(
                visible: widget.isModifyMode,
                child: Row(
                  children: [
                    GestureDetector(
                      child: Text('추가'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      child: Text('수정'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      child: Text('삭제'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
        ),
        // Column(
        //   children: widget.groupExerciseModel.exerciseList.map((exercise) {
        //     return ExerciseCard(
        //         exerciseModel: exercise, isModifyMode: widget.isModifyMode);
        //   }).toList(),
        // )
      ],
    );
  }
}
