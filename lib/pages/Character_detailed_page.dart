import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:characrea/main.dart';
import 'package:flutter/foundation.dart';
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

  Widget DisplayBlankImage() {
    return Image.asset(
      'assets/egg-eye.png',
      width: 70,
      height: 70,
    );
  }

  Widget DisplayImage(String bigImageUrl) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kIsWeb ? 24.0 : 16.0),
      child: Card(
        elevation: 4.0,
        child: Padding(
          padding: EdgeInsets.all(kIsWeb ? 24.0 : 16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 0.8 * screenWidth,
              maxHeight: 0.7 * screenHeight,
            ),
            child: Image.network(bigImageUrl),
          ),
        ),
      ),
    );
  }

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
            "Drag up  for character details",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      borderRadius: radius,
      body: Column(children: [
        IconAndDetail(Icons.person, widget.character.name),
        FutureBuilder(
            future: Future.wait([readImageFromDatabase(widget.character.displayPhoto)]),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              //TODO: bug here please fix
              if (snapshot.hasData) {
                return DisplayImage(snapshot.data![0]);
              }
              return DisplayBlankImage();
            }),
      ]),
    );
  }
}

class DetailsInSlider extends StatelessWidget {
  const DetailsInSlider({required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
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
                    text: "General",
                  ),
                  Tab(
                    text: "Identity",
                  ),
                  Tab(
                    text: "Style",
                  ),
                  Tab(
                    text: "Class",
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DetailEntry(character.power, "Power"),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DetailEntry(character.race, "Race"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          DetailEntry(character.powerDescription, "Power Description"),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DetailEntry(character.motto, "Motto"),
                          DetailEntry(character.catchphrase, "Catchphrase"),
                          DetailEntry(character.description, "Description"),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DetailEntry(character.hair, "Hair"),
                                DetailEntry(character.frame, "Frame"),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DetailEntry(character.appearance, "Appearance"),
                                DetailEntry(character.outfit, "Outfit"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconDetailEntry(character.typeImage(), character.typeWord(), "Type"),
                                IconDetailEntry(character.groupImage(), character.groupWord(), "Group"),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconDetailEntry(character.powerOriginImage(), character.powerOriginWord(), "Power Origin"),
                                IconDetailEntry(character.genderImage(), character.genderWord(), "Gender"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class DetailEntry extends StatelessWidget {
  const DetailEntry(this.detail, this.detailName);

  final String detail;
  final String detailName;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              detailName,
              textScaleFactor: 1.5,
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              detail,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      );
}

class IconDetailEntry extends StatelessWidget {
  const IconDetailEntry(this.imagePath, this.detail, this.detailName);

  final String imagePath;
  final String detail;
  final String detailName;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              detailName,
              textScaleFactor: 1.5,
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            IconImageAndDetail(imagePath, detail, 0),
          ],
        ),
      );
}
