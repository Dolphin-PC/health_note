import 'package:flutter/foundation.dart';
import 'package:health_note/db/db_helper.dart';
import 'package:health_note/db/table_names.dart';
import 'package:sqflite/sqlite_api.dart';

class YoutubeMusicModel {
  YoutubeMusicModel({
    Key? key,
    this.id,
    required this.url,
  });

  final String? id;
  final String url;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
    };
  }

  static Future<List<YoutubeMusicModel>> selectList() async {
    final db = await DBHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(TableNames.youtubeMusic);

    var list = List.generate(maps.length, (i) {
      return YoutubeMusicModel(
        id: maps[i]['id'],
        url: maps[i]['url'],
      );
    });

    return list;
  }

  Future<void> insert() async {
    final db = await DBHelper().database;

    await db.insert(
      TableNames.youtubeMusic,
      toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete() async {
    final db = await DBHelper().database;
    await db.delete(TableNames.youtubeMusic, where: 'id = ?', whereArgs: [id]);
  }
}
