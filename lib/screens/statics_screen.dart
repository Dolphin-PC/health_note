import 'package:flutter/material.dart';
import 'package:health_note/common/util.dart';
import 'package:health_note/models/group_exercise_model.dart';
import 'package:health_note/providers/statics_provider.dart';
import 'package:health_note/styles/text_styles.dart';
import 'package:provider/provider.dart';

class StaticsScreen extends StatefulWidget {
  const StaticsScreen({Key? key}) : super(key: key);

  @override
  State<StaticsScreen> createState() => _StaticsScreenState();
}

class _StaticsScreenState extends State<StaticsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    StaticsProvider staticsProvider = Provider.of(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('나의 운동 통계', style: TextStyles.headText),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('운동', style: TextStyles.labelText),
              FutureBuilder(
                future: staticsProvider.groupExerciseList,
                builder: (BuildContext context, AsyncSnapshot<List<GroupExerciseModel>> snapshot) {
                  if (!snapshot.hasData) return Text('');

                  List<GroupExerciseModel> list = snapshot.data!;
                  list.insert(0, GroupExerciseModel(groupName: '전체보기', id: 0, isDelete: false));

                  return DropdownButtonFormField<GroupExerciseModel>(
                    value: list.firstWhere((e) => e.id == staticsProvider.selectedGroupExerciseModel.id),
                    onChanged: (value) => staticsProvider.selectedGroupExerciseModel = value!,
                    items: snapshot.data!.map<DropdownMenuItem<GroupExerciseModel>>((GroupExerciseModel value) {
                      return DropdownMenuItem<GroupExerciseModel>(
                        value: value,
                        child: Text(value.groupName),
                      );
                    }).toList(),
                  );
                },
              ),
              SizedBox(height: 20),
              Text('기록', style: TextStyles.labelText),
              FutureBuilder(
                future: staticsProvider.getEventsForGroupByDay(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) return Text('');

                  List<DateTime> allDays = snapshot.data;
                  List<DateTime> thisMonthDays = allDays.where((DateTime day) => day.month == Util.now.month).toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('총 운동 일수'),
                          Text('${allDays.length}일'),
                        ],
                      ),
                      Divider(height: 20, color: Colors.grey),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('이번달 운동 일수'),
                          Text('${thisMonthDays.length}일'),
                        ],
                      ),
                      Divider(height: 20, color: Colors.grey),
                    ],
                  );
                },
              ),
              SizedBox(height: 20),
              Text('비중', style: TextStyles.labelText),
              FutureBuilder(
                future: staticsProvider.getEventsForGroupByGroup(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) return Text('');

                  List<dynamic> list = snapshot.data;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, idx) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(list[idx]['exercise_name']),
                            Text('${list[idx]['exercise_count']}회'),
                          ],
                        ),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
