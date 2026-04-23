import 'package:doctorlite/Screens/history_page.dart';
import 'package:flutter/material.dart';

import 'Screens/home_page.dart';
import 'Screens/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int _index = 0;

  final List<Widget> pages = const [
    HomePage(),
    HistoryPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: pages[_index],

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: _index,

        onTap: (value) {
          setState(() {
            _index = value;
          });
        },

        type: BottomNavigationBarType.fixed,

        selectedItemColor: Colors.blue,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),

        ],

      ),

    );

  }

}