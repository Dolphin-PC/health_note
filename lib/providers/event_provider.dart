import 'package:flutter/material.dart';
import 'package:health_note/common/util.dart';
import 'package:health_note/models/event_model.dart';
import 'package:intl/intl.dart';

class EventProvider extends ChangeNotifier {
  DateTime _selectedDay = Util.getNowSimple;

  set selectedDay(select) {
    _selectedDay = select;
    print(_selectedDay);
  }

  get selectedDay => _selectedDay;

  Future<List<EventModel>> selectList({required whereArgs, bool isDelete = true}) async {
    return await EventModel.selectList(whereArgs: whereArgs, isDelete: isDelete);
  }

  Future insertOne({required EventModel eventModel}) async {
    eventModel.insert();
    notifyListeners();
  }

  Future deleteOne({required EventModel eventModel}) async {
    eventModel.delete();
    notifyListeners();
  }

  Future updateOne({required EventModel eventModel, required EventModel changeModel}) async {
    eventModel.update(changeModel.toMap());
    notifyListeners();
  }

  Future<List<EventModel>> getEventsPerDay({required DateTime day, bool isDelete = true}) async {
    List whereArgs = [DateFormat("yyyy-MM-dd").format(day)];

    return await selectList(whereArgs: whereArgs, isDelete: isDelete);
  }

  Future<Map<DateTime, List<EventModel>>> getEventsForDay() async {
    List<DateTime> dayList = await EventModel.selectEventGroupByDay();

    Map<DateTime, List<EventModel>> resultMap = {};

    for (DateTime day in dayList) {
      resultMap[day] = await getEventsPerDay(day: day, isDelete: false);
    }

    return resultMap;
  }

  List<EventModel> getEventForDay(Map<DateTime, List<EventModel>> dayList, DateTime day) {
    return dayList[day] ?? [];
  }

  Future selectEventById({required EventModel eventModel}) async {
    return await eventModel.selectEventById();
  }
}
