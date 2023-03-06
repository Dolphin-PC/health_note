import 'package:flutter/material.dart';
import 'package:health_note/styles/text_styles.dart';

class RunExerciseScreen extends StatefulWidget {
  const RunExerciseScreen({Key? key}) : super(key: key);

  @override
  State<RunExerciseScreen> createState() => _RunExerciseScreenState();
}

class _RunExerciseScreenState extends State<RunExerciseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('운동 시작', style: TextStyles.headText),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.disabled_by_default)));
  }
}
