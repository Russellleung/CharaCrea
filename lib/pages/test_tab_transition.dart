import 'package:characrea/pages/Character_detailed_page.dart';
import 'package:characrea/pages/Character_full_screen_page.dart';
import 'package:characrea/pages/character_edit_or_add_page.dart';
import 'package:flutter/material.dart';

import '../provider/CharacterListProvider.dart';

class TabTransition extends StatefulWidget {
  const TabTransition({Key? key}) : super(key: key);

  @override
  State<TabTransition> createState() => _TabTransitionState();
}

class _TabTransitionState extends State<TabTransition> with TickerProviderStateMixin {
  int _selectedIndex = 1;
  late TabController _tabController;
  List<Widget> containers = [
// Container(
//   color: Colors.pink,
// ),
// Container(
//   color: Colors.blue,
// ),
// Container(
//   color: Colors.deepPurple,
// )
    CharacterDetailedPage(
        character: Character(
            name: "name",
            group: "group",
            type: 'type',
            power: 'power',
            powerDescription: 'powerDescription',
            race: 'race',
            photo: 'photo',
            croppedPhoto: 'croppedPhoto',
            catchphrase: 'catchphrase',
            description: 'description',
            hair: 'hair',
            appearance: 'appearance',
            frame: 'frame',
            outfit: 'outfit',
            documentId: 'documentId')),
    CharacterEditPage(title: "", message: ""),
    CharacterFullScreenPage(title: "title", message: "message"),
  ];

  @override
  void initState() {
    super.initState();
    // Create TabController for getting the index of current tab
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: _selectedIndex,
    );

    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sample'),
          bottom: TabBar(
            controller: _tabController,
            tabs: <Widget>[
              Tab(
                text: '2018',
              ),
              Tab(
                text: '2019',
              ),
              Tab(
                text: '2020',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: containers,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
