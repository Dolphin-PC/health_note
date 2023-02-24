import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:health_note/models/event_model.dart';
import 'package:health_note/models/group_exercise_model.dart';
import 'package:health_note/providers/event_provider.dart';
import 'package:health_note/providers/group_exercise_provider.dart';
import 'package:health_note/styles/text_styles.dart';
import 'package:health_note/widget/dialogs.dart';
import 'package:health_note/widget/set_card.dart';
import 'package:provider/provider.dart';

class EventCard extends StatefulWidget {
  const EventCard({Key? key, required this.eventModel}) : super(key: key);

  final EventModel eventModel;

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    EventProvider eventProvider = Provider.of(context, listen: true);
    GroupExerciseProvider groupExerciseProvider = Provider.of(context, listen: true);

    Text titleText() {
      List<GroupExerciseModel> list = groupExerciseProvider.groupExerciseList;
      GroupExerciseModel? groupExerciseModel = list.firstWhereOrNull((element) => element.id == widget.eventModel.groupId);
      String groupName = groupExerciseModel != null ? groupExerciseModel.groupName : "";

      return Text("${widget.eventModel.exerciseName} ($groupName)", style: TextStyles.titleText);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              titleText(),
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
        SetCard(
          setName: '1세트',
          setCount: '10회',
        ),
        SetCard(
          setName: '2세트',
          setCount: '10회',
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
                onPressed: () {},
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
