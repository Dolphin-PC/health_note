import 'package:flutter/material.dart';
import 'package:health_note/models/exercise_model.dart';
import 'package:health_note/providers/event_provider.dart';
import 'package:health_note/providers/exercise_provider.dart';
import 'package:health_note/styles/color_styles.dart';
import 'package:health_note/widget/dialogs.dart';
import 'package:provider/provider.dart';

import '../models/event_model.dart';

class ExerciseCard extends StatelessWidget {
  ExerciseCard({Key? key, required this.isModifyMode, required this.exerciseModel}) : super(key: key);

  final bool isModifyMode;
  final ExerciseModel exerciseModel;

  @override
  Widget build(BuildContext context) {
    ExerciseProvider exerciseProvider = Provider.of(context, listen: false);
    EventProvider eventProvider = Provider.of(context, listen: false);
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
                // 읽기모드 일때 => 현재 날짜(events)에 운동 추가
                // TODO 바로 추가 하지 말고, 쌓았다가 저장하기
                eventProvider.insertOne(
                    eventModel: EventModel(
                  day: eventProvider.selectedDay,
                  isComplete: false,
                  exerciseModel: exerciseModel,
                ));
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
