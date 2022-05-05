import 'package:characrea/pages/second_screen.dart';
import 'package:characrea/pages/test_tab_transition.dart';
import 'package:flutter/material.dart';

import 'character_carousell.dart';
import 'character_list_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RootPage();
}

class _RootPage extends State<RootPage> {
  int _selectedIndex = 0;
  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      MyHomePage(),
      SecondScreen(
        message: '',
        title: '',
      ),
      CharacterCarousel(),
      TabTransition(),
    ];

    return MaterialApp(
      home: Scaffold(
          body: PageView(
            controller: _pageController,
            //The following parameter is just to prevent
            //the user from swiping to the next page.
            physics: NeverScrollableScrollPhysics(),
            children: _widgetOptions,
          ),

          // Center(
          //   child: _widgetOptions.elementAt(_selectedIndex),
          // ),
          bottomNavigationBar: GestureDetector(
            onDoubleTap: () {
              print("hi");
            },
            child: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
                BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "home"),
                BottomNavigationBarItem(icon: Icon(Icons.message), label: "home"),
                BottomNavigationBarItem(icon: Icon(Icons.table_chart), label: "home"),
                BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "home"),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Color(0xFF334192),
              unselectedItemColor: Colors.grey,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                  _pageController.jumpToPage(_selectedIndex);
                });
              },
            ),
          )),
    );
  }
}
