import 'package:flutter/material.dart';

class Dialogs {
  static addGroupDialog(BuildContext context, Function addFn) {
    final myController = TextEditingController();

    return showDialog(
        context: context,
        builder: (BuildContext build) {
          return AlertDialog(
            title: const Text("운동 그룹 추가"),
            content: TextField(
              controller: myController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '그룹이름',
              ),
            ),
            actions: [
              TextButton(
                child: const Text("취소"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text("추가"),
                onPressed: () => addFn(myController.text),
              ),
            ],
          );
        });
  }
}
