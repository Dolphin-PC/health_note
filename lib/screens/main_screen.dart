import 'package:flutter/material.dart';
import 'package:health_note/styles/text_styles.dart';
import 'package:health_note/widget/my_checkbox.dart';
import 'package:health_note/widget/set_card.dart';
import 'package:table_calendar/table_calendar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime _now = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  bool isShowCalendar = false;

  void onTapTitle() {
    setState(() => isShowCalendar = !isShowCalendar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          )
        ],
        title: TextButton(
          onPressed: onTapTitle,
          child: Text('2023년 2월 13일', style: TextStyles.headText),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2000, 1, 1),
              lastDay: DateTime.utc(2099, 12, 31),
              focusedDay: _focusedDay,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = selectedDay;
                });
              },
              selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
              calendarFormat: CalendarFormat.month,
              headerVisible: false,
            ),
            const Divider(
              height: 3,
              color: Colors.grey,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('풀업 (등)', style: TextStyles.titleText),
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
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
