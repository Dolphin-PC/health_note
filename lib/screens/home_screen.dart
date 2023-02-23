import 'package:flutter/material.dart';
import 'package:health_note/common/util.dart';
import 'package:health_note/providers/event_provider.dart';
import 'package:health_note/screens/add_exercise_screen.dart';
import 'package:health_note/styles/text_styles.dart';
import 'package:health_note/widget/event_card.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDay = Util.getNowSimple;
  DateTime _focusedDay = Util.getNowSimple;

  bool isShowCalendar = false;

  void onTapTitle() {
    setState(() => isShowCalendar = !isShowCalendar);
  }

  @override
  Widget build(BuildContext context) {
    EventProvider eventProvider = Provider.of(context, listen: true);

    print(eventProvider.getEventsForDay(Util.getNowSimple));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddExerciseScreen(), fullscreenDialog: true),
              );
            },
          )
        ],
        title: TextButton(
          onPressed: onTapTitle,
          child: Text(Util.getNowSimpleDateFormat, style: TextStyles.headText),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            Visibility(
              visible: isShowCalendar,
              child: TableCalendar(
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = selectedDay;
                  });
                },
                // eventLoader: eventProvider.getEventsForDay,
                firstDay: DateTime.utc(2000, 1, 1),
                lastDay: DateTime.utc(2099, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                calendarFormat: CalendarFormat.month,
                headerVisible: false,
              ),
            ),
            Visibility(
              visible: isShowCalendar,
              child: Divider(
                height: 3,
                color: Colors.grey,
              ),
            ),
            FutureBuilder(
              future: eventProvider.getEventsForDay(_selectedDay),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) return Text('...');

                return Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, idx) {
                        return EventCard(eventModel: snapshot.data[idx]);
                      }),
                );
              },
            )
            // Column(
            //   children: [
            //     EventCard(),
            //     EventCard(),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
