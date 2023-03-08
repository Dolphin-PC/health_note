import 'package:flutter/material.dart';
import 'package:health_note/models/event_model.dart';
import 'package:health_note/models/workout_set_model.dart';
import 'package:health_note/providers/event_provider.dart';
import 'package:health_note/providers/workout_set_provider.dart';
import 'package:health_note/styles/text_styles.dart';
import 'package:health_note/widget/bottom_sheets.dart';
import 'package:health_note/widget/dialogs.dart';
import 'package:health_note/widget/workout_set_card.dart';
import 'package:provider/provider.dart';

class EventCard extends StatefulWidget {
  const EventCard({Key? key, required this.eventModel}) : super(key: key);

  final EventModel eventModel;

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  late EventProvider eventProvider;
  late WorkoutSetProvider workoutSetProvider;
  late var exerciseInfo;

  @override
  void initState() {
    super.initState();
  }

  Future<Text> titleText() async {
    var selectEventById =
        await eventProvider.selectEventById(eventModel: widget.eventModel);
    exerciseInfo = selectEventById[0];
    String exerciseName = exerciseInfo['exercise_name'];
    String groupName = exerciseInfo['group_name'];
    return Text("$exerciseName ($groupName)", style: TextStyles.titleText);
  }

  @override
  Widget build(BuildContext context) {
    eventProvider = Provider.of(context, listen: false);
    workoutSetProvider = Provider.of(context, listen: true);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder(
                future: titleText(),
                builder: (BuildContext builder, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) return Text('');
                  return snapshot.data;
                },
              ),
              GestureDetector(
                child: Icon(Icons.pending),
                onTap: () {
                  Dialogs.confirmDialog(
                    context: context,
                    contentText: "기록을 삭제하시겠습니까?",
                    succBtnName: "삭제",
                    succFn: () {
                      eventProvider.deleteOne(eventModel: widget.eventModel);
                    },
                  );
                },
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
        ),
        FutureBuilder(
          future: workoutSetProvider.selectList(
              whereArgs: [widget.eventModel.eventId], isDelete: false),
          builder: (BuildContext context,
              AsyncSnapshot<List<WorkoutSetModel>> snapshot) {
            if (!snapshot.hasData) return Text('');

            List<WorkoutSetModel> workoutList = snapshot.data!;
            return Column(
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(), // 기존 스크롤 기능 해제
                  shrinkWrap: true,
                  itemCount: workoutList.length,
                  itemBuilder: (context, int index) {
                    return GestureDetector(
                      onTap: () {
                        workoutSetProvider.selectedWorkoutSetModel =
                            workoutList[index];
                        BottomSheets.workout(
                          context: context,
                          workoutSetProvider: workoutSetProvider,
                          exerciseInfo: exerciseInfo,
                        );
                      },
                      child: WorkoutSetCard(
                        workoutSetModel: workoutList[index],
                        index: index + 1,
                        exerciseInfo: exerciseInfo,
                      ),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: OutlinedButton(
                        onPressed: () {
                          if (workoutList.isNotEmpty) {
                            workoutSetProvider.delete(
                                workoutSetModel: workoutList.last);
                          }
                        },
                        child: Text(
                          '세트삭제',
                          style: TextStyles.buttonText,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      fit: FlexFit.tight,
                      child: OutlinedButton(
                        onPressed: () {
                          if (workoutList.isNotEmpty) {
                            workoutList.last.workoutSetId = null;
                            workoutSetProvider.insert(
                                workoutSetModel: workoutList.last);
                          } else {
                            workoutSetProvider.insert(
                              workoutSetModel: WorkoutSetModel(
                                eventId: widget.eventModel.eventId,
                                count: 0,
                                unitCount: 0,
                              ),
                            );
                          }
                        },
                        child: Text(
                          '세트추가',
                          style: TextStyles.buttonText,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ],
    );
  }
}
