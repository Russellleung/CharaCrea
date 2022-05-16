import 'package:characrea/pages/second_screen.dart';
import 'package:characrea/pages/test_upload_image.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:provider/provider.dart';

import '../provider/CharacterListProvider.dart';
import '../widgets/Formbuilder.dart';
import 'Character_detailed_page.dart';
import 'character_carousell.dart';
import 'character_list_page.dart';
import '../widgets/imageCropper.dart';

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
      Formbuilder(
        originalCharacter: Character(),
        callback: (Character character) {
          print("callback");
        },
      ),
      CropperImage(title: "title"),
      DetailsInSlider(
        character: Character(),
      ),
    ];

    return MaterialApp(
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
      ],
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
                BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "calendar_today"),
                BottomNavigationBarItem(icon: Icon(Icons.message), label: "message"),
                BottomNavigationBarItem(icon: Icon(Icons.table_chart), label: "table_chart"),
                BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "account_circle"),
                BottomNavigationBarItem(icon: Icon(Icons.access_time), label: "access_time"),
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
