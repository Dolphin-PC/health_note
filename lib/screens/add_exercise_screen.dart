import 'package:flutter/material.dart';
import 'package:health_note/models/group_exercise_model.dart';
import 'package:health_note/providers/group_exercise_provider.dart';
import 'package:health_note/styles/color_styles.dart';
import 'package:health_note/widget/dialogs.dart';
import 'package:health_note/widget/group_exercise_card.dart';
import 'package:provider/provider.dart';

class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({Key? key}) : super(key: key);

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  bool isModifyMode = false;
  late GroupExerciseProvider groupExerciseProvider;

  @override
  void initState() {
    super.initState();
    isModifyMode = true;
  }

  addGroup(String groupName) async {
    groupExerciseProvider.insertOne(groupExerciseModel: GroupExerciseModel(groupName: groupName));
  }

  @override
  Widget build(BuildContext context) {
    groupExerciseProvider = Provider.of(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('운동추가'),
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
        child: FutureBuilder(
          future: groupExerciseProvider.selectList(isDelete: false),
          builder: (BuildContext ctx, AsyncSnapshot snap) {
            if (!snap.hasData) return const Text('...');

            return ListView.builder(
              shrinkWrap: true,
              itemCount: snap.data.length,
              itemBuilder: (ctx, idx) {
                return GroupExerciseCard(groupExerciseModel: snap.data[idx], isModifyMode: isModifyMode);
              },
            );
          },
        ),
      ),
      floatingActionButton: Visibility(
        visible: isModifyMode,
        child: FloatingActionButton(
          backgroundColor: ColorStyles.primaryColor,
          onPressed: () {
            Dialogs.inputDialog(context: context, addFn: addGroup, titleText: "운동 그룹 추가", inputLabel: "그룹 이름", succBtnName: "추가");
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
