import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health_note/common/util.dart';
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
  static const initMinute = 0;
  int totalSeconds = initMinute;
  int setSeconds = initMinute;
  late Timer totalTime, setTime;
  bool isRunning = false;
  bool isStarted = false;

  int indexCount = 1;
  late int maxCount = 0;

  late RunExerciseProvider runExerciseProvider;
  late EventProvider eventProvider;
  late var runInfo;

  @override
  void initState() {
    super.initState();
    Util.execAfterBinding(() async {
      String dayFormat = DateFormat("yyyy-MM-dd").format(eventProvider.selectedDay);
      await runExerciseProvider.init(day: dayFormat);
      maxCount = runExerciseProvider.runList.length;
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
                    child: Stack(
                      children: <Widget>[
                        Flexible(
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 15,
                              value: 1.0,
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
                              onPressed: onNextSetPressed,
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
    if (indexCount + 1 == maxCount) return;
    setState(() {
      setSeconds = initMinute;
      indexCount++;
    });
  }
}
