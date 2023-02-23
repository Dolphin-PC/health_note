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
  static UNIT fromDB(String value) => values.byName(value);
  static UNIT fromString(String value) => values.byName(value);
}
