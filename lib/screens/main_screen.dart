import 'package:flutter/material.dart';
import 'package:health_note/screens/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Widget> _screenList = [
    HomeScreen(),
    HomeScreen(),
    HomeScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instagram'),
      ),
      // body에 넣어줄 아이템
      body: Center(
        child: _screenList.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              // 현재 아이콘이 선택된 아이콘일때와 선택된 아이콘이 아닌 경우 Icon을 다르게 하기 위함
              icon: _selectedIndex == 0
                  ? Icon(
                      Icons.home_filled,
                      color: Colors.black,
                    )
                  : Icon(Icons.home_outlined, color: Colors.black),
              label: 'home'),
          BottomNavigationBarItem(
              icon: _selectedIndex == 1
                  ? Icon(
                      Icons.stacked_bar_chart_outlined,
                      color: Colors.black,
                    )
                  : Icon(
                      Icons.stacked_bar_chart_rounded,
                      color: Colors.black,
                    ),
              label: 'search'),
          BottomNavigationBarItem(
              icon: _selectedIndex == 2
                  ? Icon(Icons.person, color: Colors.black)
                  : Icon(
                      Icons.person_outline,
                      color: Colors.black,
                    ),
              label: 'profile')
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
        showSelectedLabels: false, //(1)
        showUnselectedLabels: false, //(1)
        type: BottomNavigationBarType.fixed, //(2)
      ),
    );
  }
}
