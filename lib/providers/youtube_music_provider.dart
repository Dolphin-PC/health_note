import 'package:flutter/cupertino.dart';
import 'package:health_note/models/youtube_music_model.dart';

class YoutubeMusicProvider extends ChangeNotifier {
  bool _isRunning = false;
  bool _isInitial = false;
  List<String> musicIdList = [];

  set isRunning(bool value) {
    _isRunning = value;
    notifyListeners();
  }

  bool get isRunning => _isRunning;

  set isInitial(bool value) {
    if (value == false) isRunning = false;
    _isInitial = value;
    notifyListeners();
  }

  bool get isInitial => _isInitial;

  Future<List<YoutubeMusicModel>> selectList() async {
    return await YoutubeMusicModel.selectList();
  }

  Future insertOne({required YoutubeMusicModel youtubeMusicModel}) async {
    youtubeMusicModel.insert();
    notifyListeners();
  }

  Future deleteOne({required YoutubeMusicModel youtubeMusicModel}) async {
    youtubeMusicModel.delete();
    notifyListeners();
  }
}
