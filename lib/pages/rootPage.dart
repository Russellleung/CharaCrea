import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:characrea/Themes.dart';
import 'package:characrea/effects/distortion.dart';
import 'package:characrea/pages/second_screen.dart';
import 'package:characrea/pages/test_upload_image.dart';
import 'package:characrea/pages/third_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../provider/CharacterListProvider.dart';
import '../widgets/Formbuilder.dart';
import '../widgets/rippleTest.dart';
import 'Character_detailed_page.dart';
import 'character_carousell.dart';
import 'character_list_page.dart';
import '../widgets/imageCropper.dart';
import 'dart:ui' as ui;

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
      CollapsingList(),
      CharacterCarousel(),
      CropperImage(title: "title"),
      RippleTest(
        character: Character(),
      ),
    ];

    return MaterialApp(
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
      ],
      theme: ThemeData(
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
              highlightColor: Colors.greenAccent,
            ),
        primarySwatch: Colors.orange,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        backgroundColor: AppThemes.pageColor,
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
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "home",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "calendar_today"),
            BottomNavigationBarItem(icon: Icon(Icons.message), label: "message"),
            BottomNavigationBarItem(icon: Icon(Icons.table_chart), label: "table_chart"),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "account_circle"),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppThemes.buttonColor,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            FocusManager.instance.primaryFocus?.unfocus();
            setState(() {
              _selectedIndex = index;
              _pageController.jumpToPage(_selectedIndex);
            });
          },
        ),
      ),
    );
  }
}
