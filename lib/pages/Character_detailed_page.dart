import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:characrea/main.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:ui_helper/ui_helper.dart';

import '../provider/CharacterListProvider.dart';
import '../widgets/widgets.dart';

class CharacterDetailedPage extends StatefulWidget {
  final Character character;

  CharacterDetailedPage({required this.character});

  @override
  _CharacterDetailedPage createState() => _CharacterDetailedPage();
}

class _CharacterDetailedPage extends State<CharacterDetailedPage> {
  bool panelOpen = false;

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    return SlidingUpPanel(
        onPanelClosed: () {
          setState(() {
            panelOpen = false;
          });
        },
        onPanelOpened: () {
          setState(() {
            panelOpen = true;
          });
        },
        maxHeight: MediaQuery.of(context).size.height * .30,
        minHeight: MediaQuery.of(context).size.height * .05,
        panel: DetailsInSlider(
          character: widget.character,
        ),
        collapsed: Container(
          decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: radius),
          child: Center(
            child: Text(
              "Drag up Character Details",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        borderRadius: radius,
        body: ListView(children: <Widget>[
          Image.asset('assets/codelab.png'),
          const SizedBox(height: 8),
          IconAndDetail(Icons.abc_rounded, widget.character.name),
          IconAndDetail(Icons.dangerous, widget.character.power),
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          const Header("What we'll be doing"),
          const Paragraph(
            'Join us for a day full of Firebase Workshops and Pizza!',
          ),
        ]));
  }
}

class DetailsInSlider extends StatelessWidget {
  const DetailsInSlider({required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0),
                  )),
              child: const TabBar(
                labelColor: Colors.deepOrange,
                unselectedLabelColor: Colors.lightGreen,
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.directions_car,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.directions_transit,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.directions_bike,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Icon(Icons.directions_car),
                        Text(character.name),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Icon(Icons.directions_transit),
                        Text(character.power),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Icon(Icons.directions_bike),
                        Text(character.powerDescription),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                        Icon(Icons.directions_car),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
