import 'package:characrea/pages/test_tab_transition.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../provider/CharacterListProvider.dart';

Widget CharacterCard(BuildContext context, Character character) {
  // final groupType = character.groupType();

  return Container(
    child: GestureDetector(
      onLongPress: () {
        _displayDialog(context, character);
      },
      child: Card(
        child: InkWell(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                    child: Row(children: <Widget>[
                      Text(
                        character.name,
                        style: GoogleFonts.seymourOne(fontSize: 20.0),
                      ),
                      Spacer(),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 80.0),
                    child: Row(children: <Widget>[
                      Text(character.power),
                      Spacer(),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Row(
                      children: [
                        Text(
                          character.description,
                          style: new TextStyle(fontSize: 35.0),
                        ),
                        Spacer(),
                        // Icon(groupType[character.group]),
                      ],
                    ),
                  )
                ],
              ),
            ),
            onTap: () {
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
