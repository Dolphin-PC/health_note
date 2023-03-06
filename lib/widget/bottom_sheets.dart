import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_note/models/workout_set_model.dart';
import 'package:health_note/providers/workout_set_provider.dart';

class BottomSheets {
  static workout({required BuildContext context, required WorkoutSetProvider workoutSetProvider, required Map<String, dynamic> exerciseInfo}) {
    final unitCountController = TextEditingController();
    final countController = TextEditingController();

    WorkoutSetModel selectedWorkoutSetModel = workoutSetProvider.selectedWorkoutSetModel!;

    unitCountController.text = selectedWorkoutSetModel.unitCount.toString();
    countController.text = selectedWorkoutSetModel.count.toString();

    void onButtonUnitCountAction({required int value}) {
      int currentVal = int.parse(unitCountController.text);
      int changeVal = currentVal + value;

      unitCountController.text = changeVal.toString();
      selectedWorkoutSetModel.unitCount = changeVal;
      workoutSetProvider.updateOne(workoutSetModel: selectedWorkoutSetModel, changeModel: selectedWorkoutSetModel);
    }

    void onButtonCountAction({required int value}) {
      int currentVal = int.parse(countController.text);
      int changeVal = currentVal + value;

      countController.text = changeVal.toString();
      selectedWorkoutSetModel.count = changeVal;
      workoutSetProvider.updateOne(workoutSetModel: selectedWorkoutSetModel, changeModel: selectedWorkoutSetModel);
    }

    return showBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                color: Colors.amber,
              ),
              // height: 200,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text('닫기'),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => onButtonUnitCountAction(value: -5),
                          child: const Text('-5'),
                        ),
                        TextButton(
                          onPressed: () => onButtonUnitCountAction(value: -1),
                          child: const Text('-1'),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: unitCountController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(suffixText: exerciseInfo['unit']),
                              onChanged: (value) {
                                if (value == '') {
                                  unitCountController.text = '0';
                                  return;
                                }
                                int intVal = int.parse(value);

                                selectedWorkoutSetModel.unitCount = intVal;
                                workoutSetProvider.updateOne(workoutSetModel: selectedWorkoutSetModel, changeModel: selectedWorkoutSetModel);
                              },
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => onButtonUnitCountAction(value: 1),
                          child: const Text('+1'),
                        ),
                        TextButton(
                          onPressed: () => onButtonUnitCountAction(value: 5),
                          child: const Text('+5'),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: exerciseInfo['is_count'] == 1,
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () => onButtonCountAction(value: -5),
                            child: const Text('-5'),
                          ),
                          TextButton(
                            onPressed: () => onButtonCountAction(value: -1),
                            child: const Text('-1'),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: TextField(
                                decoration: const InputDecoration(suffixText: '회'),
                                textAlign: TextAlign.center,
                                controller: countController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                onChanged: (value) {
                                  if (value == '') {
                                    countController.text = '0';
                                    return;
                                  }
                                  int intVal = int.parse(value);

                                  selectedWorkoutSetModel.count = intVal;
                                  workoutSetProvider.updateOne(workoutSetModel: selectedWorkoutSetModel, changeModel: selectedWorkoutSetModel);
                                },
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => onButtonCountAction(value: 1),
                            child: const Text('+1'),
                          ),
                          TextButton(
                            onPressed: () => onButtonCountAction(value: 5),
                            child: const Text('+5'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
