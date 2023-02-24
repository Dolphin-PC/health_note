import 'package:flutter/material.dart';
import 'package:health_note/enums/unit.dart';
import 'package:health_note/models/exercise_model.dart';
import 'package:health_note/models/group_exercise_model.dart';
import 'package:health_note/providers/exercise_provider.dart';
import 'package:health_note/providers/group_exercise_provider.dart';
import 'package:health_note/styles/text_styles.dart';
import 'package:health_note/widget/dialogs.dart';
import 'package:health_note/widget/exercise_card.dart';
import 'package:provider/provider.dart';

class GroupExerciseCard extends StatefulWidget {
  const GroupExerciseCard({Key? key, required this.isModifyMode, required this.groupExerciseModel}) : super(key: key);

  final bool isModifyMode;
  final GroupExerciseModel groupExerciseModel;

  @override
  State<GroupExerciseCard> createState() => _GroupExerciseCardState();
}

class _GroupExerciseCardState extends State<GroupExerciseCard> {
  late GroupExerciseProvider groupExerciseProvider;
  late ExerciseProvider exerciseProvider;

  addExercise(String inputText, String unitSelectValue, bool isCount) async {
    exerciseProvider.insertOne(
        exerciseModel: ExerciseModel(
      exerciseName: inputText,
      unit: UNIT.fromString(unitSelectValue),
      isCount: isCount,
      groupId: widget.groupExerciseModel.id!,
    ));
  }

  @override
  Widget build(BuildContext context) {
    groupExerciseProvider = Provider.of(context, listen: false);
    exerciseProvider = Provider.of(context, listen: true);

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
                    // 추가버튼
                    GestureDetector(
                      onTap: () {
                        Dialogs.addExerciseDialog(
                          context: context,
                          addFn: addExercise,
                        );
                      },
                      child: const Text('추가'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    // 수정버튼
                    GestureDetector(
                      onTap: () {
                        Dialogs.inputDialog(
                          context: context,
                          titleText: "운동 그룹 수정",
                          inputLabel: "그룹 이름",
                          succBtnName: "수정",
                          defaultInputValue: widget.groupExerciseModel.groupName,
                          addFn: (inputText) {
                            widget.groupExerciseModel.groupName = inputText;
                            groupExerciseProvider.updateOne(groupExerciseModel: widget.groupExerciseModel, changeModel: widget.groupExerciseModel);
                          },
                        );
                      },
                      child: const Text('수정'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    // 삭제버튼
                    GestureDetector(
                      onTap: () {
                        Dialogs.confirmDialog(
                            context: context, contentText: "운동 그룹을 삭제하시겠습니까?", succBtnName: "삭제", succFn: () => groupExerciseProvider.deleteOne(groupExerciseModel: widget.groupExerciseModel));
                      },
                      child: const Text('삭제'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
        ),
        FutureBuilder(
          future: exerciseProvider.selectList(widget.groupExerciseModel.id!),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) return const Text('');

            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (ctx, idx) {
                return ExerciseCard(exerciseModel: snapshot.data[idx], isModifyMode: widget.isModifyMode);
              },
            );
          },
        ),
      ],
    );
  }
}
