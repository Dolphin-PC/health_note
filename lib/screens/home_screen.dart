import 'package:flutter/material.dart';
import 'package:health_note/common/util.dart';
import 'package:health_note/models/event_model.dart';
import 'package:health_note/providers/event_provider.dart';
import 'package:health_note/screens/add_exercise_screen.dart';
import 'package:health_note/screens/run_exercise_screen.dart';
import 'package:health_note/styles/text_styles.dart';
import 'package:health_note/widget/event_card.dart';
import 'package:intl/intl.dart';
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

  bool isShowCalendar = true;
  late List<EventModel> eventsToday = [];

  void onTapTitle() {
    setState(() => isShowCalendar = !isShowCalendar);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EventProvider eventProvider = Provider.of(context, listen: true);

    return Scaffold(
      floatingActionButton: Visibility(
        visible: eventsToday.isNotEmpty,
        child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RunExerciseScreen(day: DateFormat("yyyy-MM-dd").format(eventProvider.selectedDay)),
                  fullscreenDialog: true,
                ),
              );
            },
            child: Icon(Icons.play_arrow)),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddExerciseScreen(),
                  fullscreenDialog: true,
                ),
              );
            },
          )
        ],
        title: TextButton(
          onPressed: onTapTitle,
          child: Text(Util.getDateDisplayFormat(eventProvider.selectedDay),
              style: TextStyles.headText),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            Visibility(
              visible: isShowCalendar,
              child: FutureBuilder(
                future: eventProvider.getEventList(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) return Text('loading');

                  final Map<DateTime, List<EventModel>> eventList =
                      snapshot.data;
                  return TableCalendar(
                    eventLoader: (DateTime day) => eventProvider.getEventForDay(
                        eventList, DateTime(day.year, day.month, day.day)),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        eventProvider.selectedDay = selectedDay;
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    // eventLoader: eventProvider.getEventsForDay,
                    firstDay: DateTime(2000),
                    lastDay: DateTime(2099),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                    calendarFormat: CalendarFormat.month,
                    headerVisible: false,
                  );
                },
              ),
            ),
            Visibility(
              visible: isShowCalendar,
              child: const Divider(
                height: 3,
                color: Colors.grey,
              ),
            ),
            FutureBuilder(
              future: eventProvider.getEventsPerDay(
                  day: _selectedDay, isDelete: false),
              builder: (BuildContext context,
                  AsyncSnapshot<List<EventModel>> snapshot) {
                if (!snapshot.hasData) return const Text('...');

                eventsToday = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 200),
                    shrinkWrap: true,
                    itemCount: eventsToday.length,
                    itemBuilder: (context, idx) {
                      return EventCard(eventModel: eventsToday[idx]);
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
