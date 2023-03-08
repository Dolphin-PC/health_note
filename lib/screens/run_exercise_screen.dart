import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health_note/common/util.dart';
import 'package:health_note/main.dart';
import 'package:health_note/providers/run_exercise_provider.dart';
import 'package:health_note/styles/text_styles.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/event_provider.dart';

class RunExerciseScreen extends StatefulWidget {
  const RunExerciseScreen({Key? key}) : super(key: key);

  @override
  State<RunExerciseScreen> createState() => _RunExerciseScreenState();
}

class _RunExerciseScreenState extends State<RunExerciseScreen> {
  late RunExerciseProvider runExerciseProvider;
  late EventProvider eventProvider;

  // 타이머 시간초
  static const initMinute = 0;
  int totalSeconds = initMinute;
  int setSeconds = initMinute;

  // 타이머 컨트롤에 필요한 변수
  late Timer totalTime, setTime;
  bool isRunning = false, isStarted = false, isLastWorkoutSet = false;

  // 하단 버튼 컨트롤에 필요한 변수
  int indexCount = 1, maxCount = 0;
  // circular 컨트롤에 필요한 변수
  int currentEventIndex = 1, currentWorkoutIndex = 1;
  String currentEventId = "";
  double eventPercent = 0, workoutPercent = 0;

  // List<Map<String, List<dynamic>>> eventsMapList = [];
  List<String> eventIdList = [];
  // Map<String, List<dynamic>> eventPerWorkoutMap = {};
  List<dynamic> workoutList = [];
  List<dynamic> allWorkoutList = [];

  // 현재 운동정보
  bool isInit = false;
  late var runInfo;

  @override
  void initState() {
    super.initState();
    Util.execAfterBinding(() async {
      String dayFormat = DateFormat("yyyy-MM-dd").format(eventProvider.selectedDay);
      await runExerciseProvider.init(day: dayFormat);
      allWorkoutList = runExerciseProvider.runList;
      maxCount = allWorkoutList.length;

      for (var map in allWorkoutList) {
        String eventId = map['event_id'].toString();
        if (!eventIdList.contains(eventId)) {
          eventIdList.add(eventId);
        }
      }
      currentEventId = eventIdList.first;
      workoutList = allWorkoutList.where((element) => element['event_id'].toString() == currentEventId).toList();

      setState(() {
        runInfo = workoutList.first;
        isInit = true;
        calculatePercent();
      });
    });
  }

  void calculatePercent() {
    eventPercent = currentEventIndex / eventIdList.length;
    workoutPercent = currentWorkoutIndex / workoutList.length;
  }

  @override
  Widget build(BuildContext context) {
    runExerciseProvider = Provider.of(context, listen: true);
    eventProvider = Provider.of(context, listen: false);

    double fitWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('운동 시작', style: TextStyles.headText),
      ),
      body: Center(
        child: isInit
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Text(
                        timeFormat(totalSeconds),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Stack(
                        children: [
                          Center(
                            child: SizedBox(
                              width: fitWidth * 0.8,
                              height: fitWidth * 0.8,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                strokeWidth: 15,
                                value: eventPercent,
                              ),
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              width: fitWidth * 0.6,
                              height: fitWidth * 0.6,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                strokeWidth: 15,
                                value: workoutPercent,
                              ),
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(runInfo['group_exercise_name']),
                                Text(runInfo['exercise_name']),
                                Text(timeFormat(setSeconds)),
                                Text('SET $currentWorkoutIndex'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: FittedBox(
                            child: IconButton(
                              icon: Icon(Icons.stop_circle),
                              onPressed: () {},
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          fit: FlexFit.tight,
                          child: FittedBox(
                            child: IconButton(
                              icon: Icon(
                                isRunning ? Icons.pause_circle_outline : Icons.play_circle_outline,
                              ),
                              onPressed: isRunning ? onPausePressed : onStartPressed,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: FittedBox(
                            child: IconButton(
                              icon: Icon(Icons.next_plan),
                              onPressed: isLastWorkoutSet ? null : onNextSetPressed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : Text('loading...'),
      ),
    );
  }

  String timeFormat(int seconds) {
    var duration = Duration(seconds: seconds);
    List<String> timeArr = duration.toString().split(".").first.split(":");
    return '${timeArr[1]}:${timeArr[2]}';
  }

  void onStartPressed() {
    totalTime = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => setState(() => totalSeconds++),
    );
    setTime = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => setState(() => setSeconds++),
    );

    setState(() {
      isRunning = true;
      isStarted = true;
    });
  }

  void onPausePressed() {
    totalTime.cancel();
    setTime.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void onNextSetPressed() {
    // 타이머 및 버튼 컨트롤
    setSeconds = initMinute;
    indexCount++;
    if (indexCount == maxCount) {
      setState(() {
        isLastWorkoutSet = true;
      });
    }

    onNextWorkout();
  }

  void onNextWorkout() {
    runInfo = allWorkoutList[indexCount-1];
    String nextEventId = runInfo['event_id'].toString();

    if(nextEventId != currentEventId){
      currentEventId = nextEventId;
      workoutList = allWorkoutList.where((element) => element['event_id'].toString() == currentEventId).toList();
      currentWorkoutIndex = 1;
      currentEventIndex++;
    } else {
      currentWorkoutIndex++;
    }

    // 퍼센트 컨트롤
    calculatePercent();
    setState(() {

    });
  }
}
