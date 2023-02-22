import 'package:flutter/material.dart';
import 'package:health_note/db/db.dart';
import 'package:health_note/models/group_exercise_model.dart';
import 'package:health_note/styles/color_styles.dart';
import 'package:health_note/widget/dialogs.dart';
import 'package:health_note/widget/group_exercise_card.dart';
import 'package:sqflite/sqflite.dart';

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
    // fetchPrefsData();
  }

  Future fetchData() async {
    Database db = await DataBase().initDB();
  }

  fetchPrefsData() async {
    // var sharedData = await Util.getSharedData<List<String>>("groupExerciseList");
    // print("sharedData : $sharedData");
  }

  saveGroup(String groupName) {
    // Util.setSharedData<
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
          return GroupExerciseCard(isModifyMode: isModifyMode, groupExerciseModel: groupExerciseModel);
        }).toList()),
      ),
      floatingActionButton: Visibility(
        visible: isModifyMode,
        child: FloatingActionButton(
          backgroundColor: ColorStyles.primaryColor,
          onPressed: () {
            Dialogs.addGroupDialog(context, (groupName) {
              print("groupName : $groupName");
            });
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
