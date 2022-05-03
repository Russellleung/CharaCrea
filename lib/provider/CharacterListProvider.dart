import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CharacterListProvider with ChangeNotifier {
  StreamSubscription<QuerySnapshot>? _characterListSubscription;
  List<Character> _allCharacters = [
    new Character(
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
        documentId: 'documentId')
  ];

  List<Character> get allCharacters => _allCharacters;

  List<Character> _filteredCharacters = [];

  List<Character> get filteredCharacters => _filteredCharacters;

  set filteredCharacters(List<Character> characterlist) {
    _filteredCharacters = List.from(characterlist);
    notifyListeners();
  }

  void addFilteredCharacter(Character character) {
    _filteredCharacters.add(character);
    notifyListeners();
  }

  void setCharacterProvider() {
    _characterListSubscription = FirebaseFirestore.instance
        .collection('userCharacters')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('characters')
        .snapshots()
        .listen((snapshot) {
      _allCharacters = [];
      for (final document in snapshot.docs) {
        _allCharacters.add(Character(
          name: document.data()["name"],
          group: document.data()["group"],
          type: document.data()["type"],
          power: document.data()["power"],
          powerDescription: document.data()["power"],
          race: document.data()["race"],
          photo: document.data()["photo"],
          croppedPhoto: document.data()["croppedPhoto"],
          catchphrase: document.data()["catchphrase"],
          description: document.data()["description"],
          documentId: document.data()["documentId"],
          appearance: document.data()["appearance"],
          outfit: document.data()["outfit"],
          frame: document.data()["frame"],
          hair: document.data()["hair"],
        ));
      }
      notifyListeners();
      _characterListSubscription?.cancel();
    });
  }

  Future addCharacter(Character character) async {
    return await FirebaseFirestore.instance
        .collection('userCharacters')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('characters')
        .add(character.toJson());
  }

  Future setCharacter(Character character) async {
    return await FirebaseFirestore.instance
        .collection('userCharacters')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('characters')
        .doc(character.documentId)
        .set(character.toJson());
  }

  Future deleteCharacter(Character character) async {
    return await FirebaseFirestore.instance
        .collection('userCharacters')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('characters')
        .doc(character.documentId)
        .delete();
  }
}

class Character {
  Character({
    required this.name,
    required this.group,
    required this.type,
    required this.power,
    required this.powerDescription,
    required this.race,
    required this.photo,
    required this.croppedPhoto,
    required this.catchphrase,
    required this.description,
    required this.hair,
    required this.appearance,
    required this.frame,
    required this.outfit,
    required this.documentId,
  });

  final String name;
  final String group;
  final String type;
  final String power;
  final String powerDescription;
  final String race;
  final String photo;
  final String croppedPhoto;
  final String catchphrase;
  final String description;
  final String hair;
  final String appearance;
  final String frame;
  final String outfit;
  final String documentId;

  Map<String, dynamic> toJson() => {
        'name': name,
        'group': group,
        'type': type,
        'power': power,
        'powerDescription': powerDescription,
        'race': race,
        'photo': photo,
        'croppedPhoto': croppedPhoto,
        'catchphrase': catchphrase,
        'description': description,
        'hair': hair,
        'appearance': appearance,
        'frame': frame,
        'outfit': outfit,
      };

// Character.fromSnapshot(DocumentSnapshot snapshot)
//     :
//       name = snapshot.data()['name'],
//       group = snapshot.data()['group'],
//       type = snapshot.data()['type'],
//       power = snapshot.data()['power'],
//       race = snapshot.data()['race'],
//       photo = snapshot.data()['photo'],
//       croppedPhoto = snapshot.data()['croppedPhoto'],
//       catchphrase = snapshot.data()['catchphrase'],
//       description = snapshot.data()['description'],
//       documentId = snapshot.id;

  Map<String, IconData> groupType({color = Colors.black}) => {
        "car": Icons.directions_car,
        "bus": Icons.directions_bus,
        "train": Icons.train,
        "plane": Icons.airplanemode_active,
        "ship": Icons.directions_boat,
        "other": Icons.directions,
      };
}
