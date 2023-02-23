import 'package:flutter/material.dart';
import 'package:health_note/models/event_model.dart';
import 'package:health_note/styles/text_styles.dart';
import 'package:health_note/widget/set_card.dart';

class EventCard extends StatefulWidget {
  const EventCard({Key? key, required this.eventModel}) : super(key: key);

  final EventModel eventModel;

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.eventModel.exerciseName, style: TextStyles.titleText),
              GestureDetector(
                child: Icon(Icons.pending),
                onTap: () {
                  print('more');
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
