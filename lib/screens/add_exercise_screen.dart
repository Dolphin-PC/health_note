import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_note/models/group_exercise_model.dart';
import 'package:health_note/styles/color_styles.dart';
import 'package:health_note/styles/text_styles.dart';
import 'package:health_note/widget/exercise_card.dart';
import 'package:health_note/widget/group_exercise_card.dart';

class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({Key? key}) : super(key: key);

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  bool isModifyMode = false;
  late List<GroupExerciseModel> groupExerciseModelList = [];

  @override
  void initState() {
    super.initState();
    isModifyMode = false;

    fetchData();
  }

  Future<String> fetchData() async {
    final data = await rootBundle.loadString('assets/data/exercise.json');
    List<dynamic> jsonList = jsonDecode(data);
    print(jsonList);
    groupExerciseModelList = jsonList.map((json) {
      return GroupExerciseModel.fromJson(json);
    }).toList();

    setState(() {});
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('운동추가'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.ad_units),
            onPressed: () => setState(() => isModifyMode = !isModifyMode),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
            children: groupExerciseModelList.map((groupExerciseModel) {
          return GroupExerciseCard(
              isModifyMode: isModifyMode,
              groupExerciseModel: groupExerciseModel);
        }).toList()),
      ),
      floatingActionButton: Visibility(
        visible: isModifyMode,
        child: FloatingActionButton(
          backgroundColor: ColorStyles.primaryColor,
          onPressed: () {},
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
