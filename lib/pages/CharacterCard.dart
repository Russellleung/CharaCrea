import 'package:characrea/pages/test_tab_transition.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../provider/CharacterListProvider.dart';

Widget CharacterCard(BuildContext context, Character character) {
  // final groupType = character.groupType();

  Widget DisplayImage(String smallImageUrl) {
    return Image.network(
      smallImageUrl,
      width: 70,
      height: 70,
    );
  }

  Widget DisplayBlankImage() {
    return Image.asset(
      'assets/egg-eye.png',
      width: 70,
      height: 70,
    );
  }

  return Container(
    child: GestureDetector(
      onLongPress: () {
        FocusManager.instance.primaryFocus?.unfocus();
        _displayDialog(context, character);
      },
      child: Card(
        child: InkWell(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 4.0, bottom: 80.0),
                  //   child: Row(children: <Widget>[
                  //     Text(character.power),
                  //     Spacer(),
                  //   ]),
                  // ),
                  Text(character.name),
                  FutureBuilder(
                      future: Future.wait([readImageFromDatabase(character.facePhoto)]),
                      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                        if (snapshot.hasData) {
                          return DisplayImage(snapshot.data![0]);
                        }
                        return DisplayBlankImage();
                      }),
                ],
              ),
            ),
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              Navigator.of(context, rootNavigator: false).push(
                MaterialPageRoute(builder: (context) {
                  return TabTransition(character: character);
                }),
              );
            }),
      ),
    ),
  );
}

_displayDialog(BuildContext context, Character character) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Alert!'),
        content: Text('Do you want to delete this character?'),
        actions: [
          TextButton(
            onPressed: () {
              if (character.facePhoto != '' && character.displayPhoto != '') {
                deleteImageFromDatabase(character.facePhoto);
                deleteImageFromDatabase(character.displayPhoto);
              }
              deleteCharacter(character);
              Navigator.of(context).pop();
            },
            child: Text(
              'YES',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'NO',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
}
