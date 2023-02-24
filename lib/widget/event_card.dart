import 'package:flutter/material.dart';
import 'package:health_note/common/util.dart';
import 'package:health_note/models/event_model.dart';
import 'package:health_note/models/workout_set_model.dart';
import 'package:health_note/providers/event_provider.dart';
import 'package:health_note/providers/workout_set_provider.dart';
import 'package:health_note/styles/text_styles.dart';
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

  @override
  void initState() {
    super.initState();
    Util.execAfterBinding(() async {});
  }

  Future<Text> titleText() async {
    var selectEventById = await eventProvider.selectEventById(eventModel: widget.eventModel);
    String exerciseName = selectEventById[0]['exercise_name'];
    String groupName = selectEventById[0]['group_name'];
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
                      });
                },
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
        ),
        FutureBuilder(
          future: workoutSetProvider.selectList(whereArgs: [widget.eventModel.eventId]),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) return Text('');

            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context, int index) {
                return WorkoutSetCard(
                  workoutSetModel: snapshot.data[index],
                );
              },
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: OutlinedButton(
                onPressed: () {},
                child: Text(
                  '세트삭제',
                  style: TextStyles.buttonText,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              fit: FlexFit.tight,
              child: OutlinedButton(
                onPressed: () {
                  workoutSetProvider.insertOne(
                      workoutSetModel: WorkoutSetModel(
                    eventId: widget.eventModel.eventId,
                  ));
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
  }
}
