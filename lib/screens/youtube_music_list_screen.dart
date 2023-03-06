import 'package:flutter/material.dart';
import 'package:health_note/models/youtube_music_model.dart';
import 'package:health_note/providers/youtube_music_provider.dart';
import 'package:health_note/styles/text_styles.dart';
import 'package:health_note/widget/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeMusicListScreen extends StatefulWidget {
  const YoutubeMusicListScreen({Key? key}) : super(key: key);

  @override
  State<YoutubeMusicListScreen> createState() => _YoutubeMusicListScreenState();
}

class _YoutubeMusicListScreenState extends State<YoutubeMusicListScreen> {
  late YoutubeMusicProvider youtubeMusicProvider;

  Future<void> addYoutubeMusic(String url) async {
    String? videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId == null) return;
    await youtubeMusicProvider.insertOne(youtubeMusicModel: YoutubeMusicModel(id: videoId, url: url));
  }

  @override
  Widget build(BuildContext context) {
    youtubeMusicProvider = Provider.of(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('내 운동 음악', style: TextStyles.headText),
        actions: [
          IconButton(
            icon: youtubeMusicProvider.isRunning ? const Icon(Icons.pause_outlined) : const Icon(Icons.play_arrow),
            onPressed: () async {
              List<YoutubeMusicModel> youtubeMusicList = await youtubeMusicProvider.selectList();
              youtubeMusicProvider.musicIdList = List.generate(youtubeMusicList.length, (index) => youtubeMusicList[index].id!);
              if (!youtubeMusicProvider.isRunning) youtubeMusicProvider.isInitial = true;
              youtubeMusicProvider.isRunning = !youtubeMusicProvider.isRunning;
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Dialogs.inputDialog(context: context, addFn: addYoutubeMusic, titleText: "음악 추가", inputLabel: "youtube url", succBtnName: "추가"),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('목록', style: TextStyles.labelText),
                  const SizedBox(height: 20),
                  FutureBuilder(
                    future: youtubeMusicProvider.selectList(),
                    builder: (BuildContext context, AsyncSnapshot<List<YoutubeMusicModel>> snapshot) {
                      if (!snapshot.hasData) return Text('');

                      List<YoutubeMusicModel> list = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: list.length,
                        itemBuilder: (context, idx) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Text(list[idx].id),
                                IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  onPressed: () {
                                    youtubeMusicProvider.deleteOne(youtubeMusicModel: list[idx]);
                                  },
                                ),
                                Text(list[idx].url),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
