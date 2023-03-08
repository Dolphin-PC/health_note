import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health_note/common/util.dart';
import 'package:health_note/providers/run_exercise_provider.dart';
import 'package:health_note/providers/workout_set_provider.dart';
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
  late WorkoutSetProvider workoutSetProvider;

  // 타이머 시간초
  static const initMinute = 0;
  int totalSeconds = initMinute;
  int setSeconds = initMinute;
  int restSeconds = initMinute;

  // 타이머 컨트롤에 필요한 변수
  late Timer totalTime, setTime;
  bool isRunning = false,
      isStarted = false,
      isLastWorkoutSet = false,
      isRest = false,
      isEnd = false;

  // 하단 버튼 컨트롤에 필요한 변수
  int indexCount = 1, maxCount = 0;

  // circular 컨트롤에 필요한 변수
  int currentEventIndex = 1, currentWorkoutIndex = 1;
  String currentEventId = "";
  double eventPercent = 0, workoutPercent = 0;

  List<String> eventIdList = [];

  List<dynamic> workoutList = [];
  List<dynamic> allWorkoutList = [];

  // 현재 운동정보
  bool isInit = false;
  late var currentRunInfo = {}, nextRunInfo = {};

  @override
  void initState() {
    super.initState();
    Util.execAfterBinding(() async {
      String dayFormat =
          DateFormat("yyyy-MM-dd").format(eventProvider.selectedDay);
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
      workoutList = allWorkoutList
          .where((element) => element['event_id'].toString() == currentEventId)
          .toList();

      setState(() {
        currentRunInfo = workoutList.first;
        nextRunInfo = workoutList.first;
        isInit = true;
        calculatePercent();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if(isStarted) {
      totalTime.cancel();
      setTime.cancel();
    }
  }

  /// 원형 퍼센트 계산
  void calculatePercent() {
    eventPercent = currentEventIndex / eventIdList.length;
    workoutPercent = currentWorkoutIndex / workoutList.length;
  }

  /// [시작] 버튼 클릭
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

  /// [일시정지] 버튼 클릭
  void onPausePressed() {
    totalTime.cancel();
    setTime.cancel();
    setState(() {
      isRunning = false;
    });
  }

  /// [다음운동] 버튼 클릭
  void onNextSetPressed() {
    // 타이머 및 버튼 컨트롤
    setSeconds = initMinute;
    onNext();

    if (indexCount == maxCount) {
      isLastWorkoutSet = true;
    }

    setState(() {});
  }

  /// 다음 진행 (휴식 진행 or 다음운동 진행)
  void onNext() {
    isRest = !isRest;

    if (isRest) {
      onCompleteCurrentWorkout(workoutSetId: currentRunInfo['workout_set_id']);
      onRest();
    } else {
      onNextWorkout();
    }
  }

  /// 휴식 진행
  void onRest() {
    if (isLastWorkoutSet == false) {
      nextRunInfo = allWorkoutList[indexCount];
    }
  }

  /// 다음운동 진행
  void onNextWorkout() {
    indexCount++;
    currentRunInfo = allWorkoutList[indexCount - 1];

    String nextEventId = currentRunInfo['event_id'].toString();

    if (nextEventId != currentEventId) {
      currentEventId = nextEventId;
      workoutList = allWorkoutList
          .where((element) => element['event_id'].toString() == currentEventId)
          .toList();
      currentWorkoutIndex = 1;
      currentEventIndex++;
    } else {
      currentWorkoutIndex++;
    }

    // 퍼센트 컨트롤
    calculatePercent();
  }

  /// 현재운동 완료 기록
  void onCompleteCurrentWorkout({required int workoutSetId}) {
    workoutSetProvider
        .updateOther(prmMap: {'is_complete': 1}, workoutSetId: workoutSetId);
  }

  /// 운동 종료
  void onEnd() {
    onCompleteCurrentWorkout(workoutSetId: currentRunInfo['workout_set_id']);
    isEnd = true;
    onPausePressed();
  }

  @override
  Widget build(BuildContext context) {
    runExerciseProvider = Provider.of(context, listen: true);
    eventProvider = Provider.of(context, listen: false);
    workoutSetProvider = Provider.of(context, listen: false);

    double fitWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: isInit
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// 상단 [총 시간]
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Text(
                        Util.timeFormat(totalSeconds),
                      ),
                    ),
                  ),

                  /// 중간 (운동/시간) 정보
                  Flexible(
                    flex: 5,
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Stack(
                        children: [
                          /// 종목(이벤트) circular
                          Center(
                            child: SizedBox(
                              width: fitWidth * 0.8,
                              height: fitWidth * 0.8,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.grey[300],
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.green),
                                strokeWidth: 15,
                                value: eventPercent,
                              ),
                            ),
                          ),

                          /// 세트 circular
                          Center(
                            child: SizedBox(
                              width: fitWidth * 0.6,
                              height: fitWidth * 0.6,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.grey[300],
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.blue),
                                strokeWidth: 15,
                                value: workoutPercent,
                              ),
                            ),
                          ),

                          /// 운동 / 세트별 시간 정보
                          Center(
                            child: isEnd
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text('운동 끝!!')])
                                : isRest
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('휴식시간...'),
                                          Text(Util.timeFormat(setSeconds)),
                                          Text('다음운동'),
                                          Text(
                                              '${nextRunInfo['group_exercise_name']} (${nextRunInfo['exercise_name']})'),
                                        ],
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(currentRunInfo[
                                              'group_exercise_name']),
                                          Text(currentRunInfo['exercise_name']),
                                          Text(Util.timeFormat(setSeconds)),
                                          Text(
                                              'SET $currentWorkoutIndex / ${workoutList.length}'),
                                        ],
                                      ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// 하단 [버튼 3]
                  Flexible(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// 종료 버튼
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: FittedBox(
                            child: IconButton(
                              icon: Icon(Icons.stop_circle),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        /// [재생 / 일시정지] 버튼
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
                              onPressed: isEnd
                                  ? null
                                  : isRunning
                                      ? onPausePressed
                                      : onStartPressed,
                            ),
                          ),
                        ),
                        /// [다음운동 or 휴식] 버튼
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: FittedBox(
                            child: IconButton(
                              icon: Icon(Icons.next_plan),
                              onPressed: !isRunning || isEnd
                                  ? null
                                  : isLastWorkoutSet
                                      ? onEnd
                                      : onNextSetPressed,
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
}
