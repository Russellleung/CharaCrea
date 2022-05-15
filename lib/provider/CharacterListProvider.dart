import 'dart:async';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CharacterListProvider with ChangeNotifier {
  StreamSubscription<QuerySnapshot>? characterListSubscription;
  List<Character> _allCharacters = [];

  //[
  // Character(
  //     name: "name",
  //     group: 1,
  //     type: 1,
  //     gender: 1,
  //     power: 'power',
  //     powerDescription: 'powerDescription',
  //     race: 'race',
  //     photo: 'photo',
  //     croppedPhoto: 'croppedPhoto',
  //     motto: 'motto',
  //     catchphrase: 'catchphrase',
  //     description: 'description',
  //     hair: 'hair',
  //     appearance: 'appearance',
  //     frame: 'frame',
  //     outfit: 'outfit',
  //     documentId: 'documentId')
  //];

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

  Future<void> getCharacters() async {
    String id = await FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('userCharacters').doc(id).collection('characters').get().then((snapshot) {
      _allCharacters = [];
      for (final document in snapshot.docs) {
        _allCharacters.add(Character(
          name: document.data()["name"],
          group: document.data()["group"],
          type: document.data()["type"],
          gender: document.data()["gender"],
          power: document.data()["power"],
          powerOrigin: document.data()["powerOrigin"],
          powerDescription: document.data()["powerDescription"],
          race: document.data()["race"],
          displayPhoto: document.data()["displayPhoto"],
          facePhoto: document.data()['facePhoto'],
          motto: document.data()["motto"],
          catchphrase: document.data()["catchphrase"],
          description: document.data()["description"],
          documentId: document.id,
          appearance: document.data()["appearance"],
          outfit: document.data()["outfit"],
          frame: document.data()["frame"],
          hair: document.data()["hair"],
        ));
      }
    });
  }

  Future<void> setCharacterProvider() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    characterListSubscription = FirebaseFirestore.instance.collection('userCharacters').doc(id).collection('characters').snapshots().listen((snapshot) {
      _allCharacters = [];
      for (final document in snapshot.docs) {
        _allCharacters.add(Character(
          name: document.data()["name"],
          group: document.data()["group"],
          type: document.data()["type"],
          gender: document.data()["gender"],
          power: document.data()["power"],
          powerOrigin: document.data()["powerOrigin"],
          powerDescription: document.data()["powerDescription"],
          race: document.data()["race"],
          displayPhoto: document.data()["displayPhoto"],
          facePhoto: document.data()['facePhoto'],
          motto: document.data()["motto"],
          catchphrase: document.data()["catchphrase"],
          description: document.data()["description"],
          documentId: document.id,
          appearance: document.data()["appearance"],
          outfit: document.data()["outfit"],
          frame: document.data()["frame"],
          hair: document.data()["hair"],
        ));
      }
      filteredCharacters = _allCharacters;

      notifyListeners();
      // _characterListSubscription?.cancel();
    });
  }
}

class Character {
  Character({
    this.name = '',
    this.group = 0,
    this.type = 0,
    this.gender = 0,
    this.power = '',
    this.powerOrigin = 0,
    this.powerDescription = '',
    this.race = '',
    this.displayPhoto = '',
    this.facePhoto = '',
    this.motto = '',
    this.catchphrase = '',
    this.description = '',
    this.hair = '',
    this.appearance = '',
    this.frame = '',
    this.outfit = '',
    this.documentId = '',
  });

  final String name;
  final int group;
  final int type;
  final int gender;
  final String power;
  final int powerOrigin;
  final String powerDescription;
  final String race;
  final String displayPhoto;
  final String facePhoto;
  final String motto;
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
        'gender': gender,
        'power': power,
        'powerOrigin': powerOrigin,
        'powerDescription': powerDescription,
        'race': race,
        'displayPhoto': displayPhoto,
        'facePhoto': facePhoto,
        'motto': motto,
        'catchphrase': catchphrase,
        'description': description,
        'hair': hair,
        'appearance': appearance,
        'frame': frame,
        'outfit': outfit,
      };

  Character copy() {
    return Character(
        name: name,
        group: group,
        type: type,
        gender: gender,
        power: power,
        powerOrigin: powerOrigin,
        powerDescription: powerDescription,
        race: race,
        displayPhoto: displayPhoto,
        facePhoto: facePhoto,
        motto: motto,
        catchphrase: catchphrase,
        description: description,
        hair: hair,
        appearance: appearance,
        frame: frame,
        outfit: outfit,
        documentId: documentId);
  }

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

Future<void> uploadImageToDatabase(File file, String path) async {
  final storageRef = FirebaseStorage.instance.ref();
  final ImageRef = storageRef.child(path);
  try {
    await ImageRef.putFile(
        file,
        SettableMetadata(
          contentType: "name/jpeg",
        ));
  } catch (error) {
    print(error);
  }
}

Future<String> readImageFromDatabase(String path) async {
  final storageRef = FirebaseStorage.instance.ref();
  final ImageUrl = await storageRef.child(path).getDownloadURL();
  return ImageUrl;
}

Future<void> deleteImageFromDatabase(String path) async {
  final storageRef = FirebaseStorage.instance.ref();
  await storageRef.child(path).delete();
}

Future addCharacter(Character character) async {
  return await FirebaseFirestore.instance.collection('userCharacters').doc(FirebaseAuth.instance.currentUser!.uid).collection('characters').add(character.toJson());
}

Future setCharacter(Character character) async {
  return await FirebaseFirestore.instance.collection('userCharacters').doc(FirebaseAuth.instance.currentUser!.uid).collection('characters').doc(character.documentId).set(character.toJson());
}

Future deleteCharacter(Character character) async {
  return await FirebaseFirestore.instance.collection('userCharacters').doc(FirebaseAuth.instance.currentUser!.uid).collection('characters').doc(character.documentId).delete();
}
