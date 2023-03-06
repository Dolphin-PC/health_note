import 'package:flutter/material.dart';
import 'package:health_note/providers/youtube_music_provider.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FloatYoutubeMusicPlayer extends StatefulWidget {
  const FloatYoutubeMusicPlayer({Key? key, required this.ids}) : super(key: key);

  final List<String> ids;

  @override
  State<FloatYoutubeMusicPlayer> createState() => _FloatYoutubeMusicPlayerState();
}

class _FloatYoutubeMusicPlayerState extends State<FloatYoutubeMusicPlayer> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.ids.first,
      flags: const YoutubePlayerFlags(mute: false, autoPlay: true, disableDragSeek: false, loop: false, isLive: false, forceHD: false, enableCaption: false, hideControls: true),
    )..addListener(listener);
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    YoutubeMusicProvider youtubeMusicProvider = Provider.of(context, listen: true);
    if (youtubeMusicProvider.isRunning) {
      _controller.play();
    } else if (!youtubeMusicProvider.isRunning) {
      _controller.pause();
    }

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        onReady: () => _isPlayerReady = true,
        onEnded: (data) {
          _controller.load(widget.ids[(widget.ids.indexOf(data.videoId) + 1) % widget.ids.length]);
        },
      ),
      builder: (context, player) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 2,
              child: player,
            ),
            const SizedBox(width: 8),
            Flexible(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _isPlayerReady ? _videoMetaData.title : '',
                        overflow: TextOverflow.ellipsis,
                      )),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _isPlayerReady ? _videoMetaData.author : '',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => youtubeMusicProvider.isRunning = !youtubeMusicProvider.isRunning,
                    child: youtubeMusicProvider.isRunning ? Icon(Icons.pause_outlined) : Icon(Icons.play_arrow),
                  ),
                  // GestureDetector(
                  //   onTap: () => youtubeMusicProvider.isPlayerExpand = false,
                  //   child: Icon(Icons.fullscreen_exit),
                  // ),
                  GestureDetector(
                    onTap: () => youtubeMusicProvider.isInitial = false,
                    child: Icon(Icons.disabled_by_default),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
