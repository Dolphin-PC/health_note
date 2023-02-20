import 'package:health_note/enums/unit.dart';

class SetModel {
  SetModel({
    required this.setName,
    required this.unit,
    required this.unitPerCount,
    required this.count,
  });

  final String setName;
  final UNIT unit;
  int unitPerCount, count;
}
