import 'package:flutter/material.dart';
import 'package:health_note/models/exercise_model.dart';
import 'package:health_note/providers/exercise_provider.dart';
import 'package:health_note/styles/color_styles.dart';
import 'package:health_note/widget/dialogs.dart';
import 'package:provider/provider.dart';

class ExerciseCard extends StatelessWidget {
  ExerciseCard({Key? key, required this.isModifyMode, required this.exerciseModel}) : super(key: key);

  final bool isModifyMode;
  final ExerciseModel exerciseModel;

  late ExerciseProvider exerciseProvider;

  @override
  Widget build(BuildContext context) {
    exerciseProvider = Provider.of(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              if (isModifyMode) {
                // 수정모드 일때 => 삭제
                Dialogs.confirmDialog(context: context, contentText: "운동을 삭제하시겠습니까?", succBtnName: "삭제", succFn: () => exerciseProvider.deleteOne(exerciseModel: exerciseModel));
              } else {
                //TODO 읽기모드 일때 => 현재 날짜(events)에 운동 추가
              }
            },
            child: Row(
              children: [
                isModifyMode ? Icon(Icons.remove_circle, color: Colors.deepOrange[400]) : Icon(Icons.add_circle, color: ColorStyles.primaryColor),
                const SizedBox(width: 10),
                Text(exerciseModel.exerciseName),
              ],
            ),
          ),
          Visibility(
            visible: isModifyMode,
            child: GestureDetector(
              child: const Text('수정'),
              onTap: () {
                Dialogs.inputDialog(
                  context: context,
                  titleText: "운동 수정",
                  inputLabel: "운동 이름",
                  succBtnName: "수정",
                  defaultInputValue: exerciseModel.exerciseName,
                  addFn: (inputText) {
                    exerciseModel.exerciseName = inputText;
                    exerciseProvider.updateOne(exerciseModel: exerciseModel, changeModel: exerciseModel);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
