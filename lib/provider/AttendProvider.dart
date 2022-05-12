import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum Attending { yes, no, unknown }

class AttendProvider with ChangeNotifier {
  int _attendees = 0;

  int get attendees => _attendees;
  Attending _attending = Attending.unknown;
  StreamSubscription<DocumentSnapshot>? _attendingSubscription;

  Attending get attending => _attending;
  StreamSubscription<QuerySnapshot>? _attendeesSubscription;

  void setAttendProvider() {
    _attendeesSubscription = FirebaseFirestore.instance.collection('attendees').where('attending', isEqualTo: true).snapshots().listen((snapshot) {
      _attendees = snapshot.docs.length;
      notifyListeners();
      _attendeesSubscription?.cancel();
    });

    _attendingSubscription =
        FirebaseFirestore.instance.collection('attendees').doc(FirebaseAuth.instance.currentUser?.uid).snapshots().listen((snapshot) {
      if (snapshot.data() != null) {
        if (snapshot.data()!['attending'] as bool) {
          _attending = Attending.yes;
        } else {
          _attending = Attending.no;
        }
      } else {
        _attending = Attending.unknown;
      }
      notifyListeners();
      _attendingSubscription?.cancel();
    });
  }

  set attending(Attending attending) {
    final userDoc = FirebaseFirestore.instance.collection('attendees').doc(FirebaseAuth.instance.currentUser!.uid);
    if (attending == Attending.yes) {
      userDoc.set(<String, dynamic>{'attending': true});
    } else {
      userDoc.set(<String, dynamic>{'attending': false});
    }
  }
}
