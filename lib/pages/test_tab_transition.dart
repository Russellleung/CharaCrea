import 'package:characrea/pages/Character_detailed_page.dart';
import 'package:characrea/pages/Character_full_screen_page.dart';
import 'package:characrea/pages/character_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../provider/CharacterListProvider.dart';
import '../widgets/Formbuilder.dart';

class TabTransition extends StatefulWidget {
  TabTransition({Key? key, required this.character}) : super(key: key);
  Character character;

  @override
  State<TabTransition> createState() => _TabTransitionState();
}

class _TabTransitionState extends State<TabTransition> with TickerProviderStateMixin {
  int _selectedIndex = 1;
  late TabController _tabController;

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
        resizeToAvoidBottomInset: false,
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
          children: [
            // Container(
            //   color: Colors.pink,
            // ),
            // Container(
            //   color: Colors.blue,
            // ),
            // Container(
            //   color: Colors.deepPurple,
            // )
            CharacterDetailedPage(character: widget.character),
            // CharacterEditPage(
            //     originalCharacter: widget.character,
            //     callback: (character) {
            //       setState(() {
            //         widget.character = character;
            //       });
            //     }),
            Formbuilder(
              originalCharacter: widget.character,
              callback: (Character character) {
                setState(() {
                  widget.character = character;
                });
              },
            ),
            CharacterFullScreenPage(title: "title", message: "message"),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
