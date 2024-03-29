import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageProvider with ChangeNotifier {
  StreamSubscription<QuerySnapshot>? _guestBookSubscription;
  List<GuestBookMessage> _guestBookMessages = [];

  List<GuestBookMessage> get guestBookMessages => _guestBookMessages;

  void setMessageProvider() {
    _guestBookSubscription =
        FirebaseFirestore.instance.collection('guestbook').orderBy('timestamp', descending: true).limit(3).snapshots().listen((snapshot) {
      _guestBookMessages = [];
      for (final document in snapshot.docs) {
        _guestBookMessages.add(
          GuestBookMessage(
            name: document.data()['name'] as String,
            message: document.data()['text'] as String,
          ),
        );
      }
      notifyListeners();
      _guestBookSubscription?.cancel();
    });
  }

  Future<DocumentReference> addMessageToGuestBook(String message) {
    // if (_loginState != ApplicationLoginState.loggedIn) {
    //   throw Exception('Must be logged in');
    // }

    return FirebaseFirestore.instance.collection('guestbook').add(<String, dynamic>{
      'text': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }
}

class GuestBookMessage {
  GuestBookMessage({required this.name, required this.message});

  final String name;
  final String message;
}
