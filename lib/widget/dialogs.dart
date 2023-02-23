import 'package:flutter/material.dart';
import 'package:health_note/enums/unit.dart';
import 'package:health_note/styles/text_styles.dart';
import 'package:health_note/widget/my_dropdown_button.dart';
import 'package:health_note/widget/my_single_toggle_button.dart';

class Dialogs {
  static inputDialog({
    required BuildContext context,
    required String titleText,
    required String inputLabel,
    required String succBtnName,
    String cancelBtnName = "취소",
    String defaultInputValue = "",
    required Function addFn,
  }) {
    final myController = TextEditingController();
    myController.text = defaultInputValue;

    return showDialog(
        context: context,
        builder: (BuildContext build) {
          return AlertDialog(
            title: Text(titleText),
            content: SingleChildScrollView(
              child: TextField(
                controller: myController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: inputLabel,
                ),
              ),
            ),
            actions: [
              TextButton(
                child: Text(cancelBtnName),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text(succBtnName),
                onPressed: () {
                  addFn(myController.text);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  static addExerciseDialog({
    required BuildContext context,
    String defaultInputValue = "",
    required Function addFn,
  }) {
    final myController = TextEditingController();
    myController.text = defaultInputValue;

    List<String> unitList = UNIT.values.map((e) => e.name).toList();
    String unitSelectValue = unitList.first;
    bool isCountValue = false;

    return showDialog(
        context: context,
        builder: (BuildContext build) {
          return AlertDialog(
            title: const Text("운동 추가"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("운동이름", style: TextStyles.labelText),
                  TextField(controller: myController),
                  const SizedBox(height: 30),
                  Text("운동단위", style: TextStyles.labelText),
                  MyDropdownButton(dropdownList: unitList, callBackFn: (select) => unitSelectValue = select),
                  const SizedBox(height: 30),
                  Text("횟수여부", style: TextStyles.labelText),
                  MySingleToggleButton(callbackFn: (select) => isCountValue = select)
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text("취소"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text("추가"),
                onPressed: () {
                  addFn(myController.text, unitSelectValue, isCountValue);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  static confirmDialog({
    required BuildContext context,
    required String contentText,
    required String succBtnName,
    String cancelBtnName = "취소",
    required Function succFn,
  }) {
    return showDialog(
        context: context,
        builder: (BuildContext build) {
          return AlertDialog(
            content: Text(contentText),
            actions: [
              TextButton(
                child: Text(cancelBtnName),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text(succBtnName),
                onPressed: () {
                  succFn();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
