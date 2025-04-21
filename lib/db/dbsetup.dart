import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:lifeplan/entities/account.dart';
import 'package:lifeplan/entities/companion.dart';
import 'package:lifeplan/entities/event.dart';

class Database {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static int counter = 0;
  User? currentUser;

  Future<void> addAccount(String email, String username, String password,
      Companion companion) async {
    try {
      UserCredential uc = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );


      await _db.collection('accounts').doc(uc.user!.uid).set({
        'email': email,
        'username': username,
        'companion': companion.toMap(),
        'events': null
      });

      currentUser = FirebaseAuth.instance.currentUser;
    } on FirebaseAuthException catch (e) {
      print('Registration Failed: ${e.message}');
    }
  }

  Future<bool> addEvent(Event event) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await _db.collection('accounts').doc(user.uid).update({
          'events': FieldValue.arrayUnion([{
            'start_time': event.startTime,
            'end_time': event.endTime,
            'title': event.title,
            'location': event.location,
          }
          ])
        });
        return true;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<Account?> readAccount() async {
    User? cu = FirebaseAuth.instance.currentUser;
    String uid = cu!.uid;
    DocumentSnapshot doc = await FirebaseFirestore.
    instance
        .collection('accounts')
        .doc(uid)
        .get();

    try {
      doc = await _db.collection('accounts').doc().get();

      if (doc.exists) {
        Account account = Account.fromMap(doc.data() as Map<String, dynamic>);
        return account;
      }
      return null;
    } on FirebaseException catch (e) {
      print('Error: ${e.message}');
      return null;
    }
  }

  Future<bool> updatedAccountEmail(String newEmail) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await user.verifyBeforeUpdateEmail(newEmail);
        String? updatedEmail = user.email;
        await _db.collection('accounts').doc(user.uid).update(
            {'email': updatedEmail});
        return true;
      } on FirebaseAuthException catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> updatePassword(String email) async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        await _auth.sendPasswordResetEmail(email: email);
        return true;
      } on FirebaseAuthException catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> updateAccountUsername(String newUsername) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await _db.collection('accounts').doc(user.uid).update({'username' : newUsername});
        return true;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> updateAccountCompanion(Companion companion) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await _db.collection('accounts').doc(user.uid).update({
          'companion' : companion.toMap()
        });
        return true;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> updateAccountEvent(Event oldEvent, Event updatedEvent) async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot snapshot = await _db.collection('accounts')
    .doc(user!.uid)
    .get();
    
    List<dynamic> eventsFromUser = List.from(snapshot['events']);
    int i = eventsFromUser.indexWhere((map) =>
      map['start_time'] == oldEvent.startTime &&
      map['end_time'] == oldEvent.endTime &&
        map['title'] == oldEvent.title &&
        map['location'] == oldEvent.location
    );

    if (i != -1) {
      eventsFromUser[i]['start_time'] == updatedEvent.startTime;
      eventsFromUser[i]['end_time'] == updatedEvent.endTime;
      eventsFromUser[i]['title'] == updatedEvent.title;
      eventsFromUser[i]['location'] == updatedEvent.location;

      try {
        await _db.collection('accounts').doc(user.uid).update({
          'events' : eventsFromUser
        });
        return true;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> deleteEvent(Event event) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await _db.collection('accounts').doc(user.uid).update({
          'events' : FieldValue.arrayRemove([{
            'start_time' : event.startTime,
            'end_time' : event.endTime,
            'title' : event.title,
            'location' : event.location,
          }])
        });
        return true;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  // ### Companion CRUD functions ###
  Future<bool> addCompanion(String name, Gender gender, List<String> replies, String image) async {
    counter++;
    try {
      await _db.collection('accounts').doc(counter.toString()).set({
        'companion_id': counter.toString(),
        'name': name,
        'gender' : gender.toString(),
        'replies' : replies,
        'image' : image
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addReply(int companionId, String reply) async {
      try {
        await _db.collection('accounts').doc(companionId.toString()).update({
          'replies' : FieldValue.arrayRemove([reply])
        });
        return true;
      } catch (e) {
        return false;
      }
  }

  Future<Companion?> readCompanion() async {
    DocumentSnapshot doc = await FirebaseFirestore.
    instance
        .collection('companion')
        .doc()
        .get();

    try {
      doc = await _db.collection('companion').doc().get();

      if (doc.exists) {
        Companion companion = Companion.fromMap(doc.data() as Map<String, dynamic>);
        return companion;
      }
      return null;
    } on FirebaseException catch (e) {
      print('Error: ${e.message}');
    }
  }
}