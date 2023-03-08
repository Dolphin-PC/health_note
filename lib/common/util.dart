import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Util {
  static void execAfterBinding(Function fn) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fn();
    });
  }

  static bool isSharedData(SharedPreferences prefs, String key) {
    return prefs.containsKey(key);
  }

  static Future getSharedData<T>(String key) async {
    final prefs = await SharedPreferences.getInstance();

    switch (T) {
      case bool:
        return prefs.getBool(key) ?? false;
      case String:
        return prefs.getString(key) ?? "";
      case int:
        return prefs.getInt(key) ?? 0;
      case double:
        return prefs.getDouble(key) ?? 0.0;
      case List<String>:
        return prefs.getStringList(key) ?? [];
      default:
        return prefs.get(key);
    }
  }

  static void setSharedData<T>(String key, T value) async {
    final prefs = await SharedPreferences.getInstance();

    switch (T) {
      case bool:
        prefs.setBool(key, value as bool);
        break;
      case String:
        prefs.setString(key, value as String);
        break;
      case int:
        prefs.setInt(key, value as int);
        break;
      case double:
        prefs.setDouble(key, value as double);
        break;
      case List<String>:
        prefs.setStringList(key, value as List<String>);
        break;
    }
  }

  static get now => DateTime.now();

  static get getNowDateDisplayFormat => DateFormat('yyyy년 MM월 dd일').format(now);
  static getDateDisplayFormat(DateTime dateTime) => DateFormat('yyyy년 MM월 dd일').format(dateTime);

  static get getNowSimple => DateTime.utc(now.year, now.month, now.day);
  static get getNowSimpleFormat => DateFormat('yyyy-MM-dd').format(now);

  static String timeFormat(int seconds) {
    var duration = Duration(seconds: seconds);
    List<String> timeArr = duration.toString().split(".").first.split(":");
    return '${timeArr[1]}:${timeArr[2]}';
  }
}
