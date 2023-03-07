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
  static const initMinute = 0; // 초기 시간
  int totalSeconds = initMinute; // 전체 시간
  int setSeconds = initMinute; // 세트당

  late Timer totalTime, setTime;
  bool isRunning = false, isStarted = false, isLastWorkoutSet = false;

  int indexCount = 1, maxCount = 0;

  List<Map<String, List<dynamic>>> eventsMapList = [];
  Map<String, List<dynamic>> eventPerWorkoutMap = {};

  late RunExerciseProvider runExerciseProvider;
  late EventProvider eventProvider;
  late var runInfo;
  double exercisePercent = 0, workoutPercent = 0;

  @override
  void initState() {
    super.initState();
    Util.execAfterBinding(() async {
      String dayFormat =
          DateFormat("yyyy-MM-dd").format(eventProvider.selectedDay);
      await runExerciseProvider.init(day: dayFormat);
      maxCount = runExerciseProvider.runList.length;
      // logger.d(runExerciseProvider.runList);

      for (var map in runExerciseProvider.runList) {
        String eventId = map['event_id'].toString();
        if (!eventPerWorkoutMap.containsKey(eventId))
          eventPerWorkoutMap[eventId] = [];
        eventPerWorkoutMap[eventId]!.add(map);
      }

      eventPerWorkoutMap
          .forEach((key, value) => eventsMapList.add({key: value}));

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    runExerciseProvider = Provider.of(context, listen: true);
    eventProvider = Provider.of(context, listen: false);

    if (runExerciseProvider.isInit) {
      runInfo = runExerciseProvider.runList[indexCount - 1];
    }

    double fitWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('운동 시작', style: TextStyles.headText),
      ),
      body: Center(
        child: runExerciseProvider.isInit
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
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.green),
                                strokeWidth: 15,
                                value: exercisePercent / 100,
                              ),
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              width: fitWidth * 0.6,
                              height: fitWidth * 0.6,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.grey[300],
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.blue),
                                strokeWidth: 15,
                                value: workoutPercent / 100,
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
                                Text('SET $indexCount'),
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
                                isRunning
                                    ? Icons.pause_circle_outline
                                    : Icons.play_circle_outline,
                              ),
                              onPressed:
                                  isRunning ? onPausePressed : onStartPressed,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: FittedBox(
                            child: IconButton(
                              icon: Icon(Icons.next_plan),
                              onPressed:
                                  isLastWorkoutSet ? null : onNextSetPressed,
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
    logger.d(indexCount);
    logger.d(maxCount);
    setState(() {
      setSeconds = initMinute;
      indexCount++;
    });
    if (indexCount == maxCount) {
      setState(() {
        isLastWorkoutSet = true;
      });
    }
  }
}
