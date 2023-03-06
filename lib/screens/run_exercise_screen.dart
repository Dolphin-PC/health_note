import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health_note/styles/text_styles.dart';

class RunExerciseScreen extends StatefulWidget {
  const RunExerciseScreen({Key? key, required this.day}) : super(key: key);

  final String day;

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

  @override
  Widget build(BuildContext context) {
    print(widget.day);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('운동 시작', style: TextStyles.headText),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Text(timeFormat(totalSeconds),
                  style: const TextStyle(fontSize: 89)),
            ),
            Flexible(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('운동 그룹 이름'),
                  Text('운동 이름'),
                  Text(timeFormat(setSeconds)),
                  Text('SET 3'),
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
                          isRunning
                              ? Icons.pause_circle_outline
                              : Icons.play_circle_outline,
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
        ),
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
    setState(() {
      setSeconds = initMinute;
    });
  }

}
