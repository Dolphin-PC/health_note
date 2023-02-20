enum UNIT {
  kg,
  lbs,
  km,
  hour,
  min,
  sec,
  kcal,
  none;

  String toJson() => name;
  static UNIT fromJson(String json) => values.byName(json);
}
