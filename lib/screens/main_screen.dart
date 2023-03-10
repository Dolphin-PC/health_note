import 'package:flutter/material.dart';
import 'package:health_note/providers/youtube_music_provider.dart';
import 'package:health_note/screens/home_screen.dart';
import 'package:health_note/screens/run_exercise_screen.dart';
import 'package:health_note/screens/statics_screen.dart';
import 'package:health_note/screens/youtube_music_list_screen.dart';
import 'package:health_note/widget/float_youtube_music_player.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screenList = [
    const HomeScreen(),
    const StaticsScreen(),
    const YoutubeMusicListScreen(),
    const HomeScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    YoutubeMusicProvider youtubeMusicProvider = Provider.of(context, listen: true);

    return Scaffold(
      body: Center(
        child: _screenList.elementAt(_selectedIndex),
      ),
      bottomSheet: Visibility(
        visible: youtubeMusicProvider.isInitial,
        child: FloatYoutubeMusicPlayer(ids: youtubeMusicProvider.musicIdList),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: _selectedIndex == 0
                  ? const Icon(
                      Icons.home_filled,
                      color: Colors.black,
                    )
                  : const Icon(Icons.home_outlined, color: Colors.black),
              label: 'home'),
          BottomNavigationBarItem(
              icon: _selectedIndex == 1
                  ? const Icon(
                      Icons.stacked_bar_chart_outlined,
                      color: Colors.black,
                    )
                  : const Icon(
                      Icons.stacked_bar_chart_rounded,
                      color: Colors.black,
                    ),
              label: 'search'),
          BottomNavigationBarItem(
              icon: _selectedIndex == 2
                  ? const Icon(Icons.music_note, color: Colors.black)
                  : const Icon(
                      Icons.music_note_outlined,
                      color: Colors.black,
                    ),
              label: 'youtube'),
          BottomNavigationBarItem(
              icon: _selectedIndex == 3
                  ? const Icon(Icons.person, color: Colors.black)
                  : const Icon(
                      Icons.person_outline,
                      color: Colors.black,
                    ),
              label: 'profile')
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        //(1)
        showUnselectedLabels: false,
        //(1)
        type: BottomNavigationBarType.fixed, //(2)
      ),
    );
  }
}
