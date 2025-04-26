import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:lifeplan/entities/account.dart';
import 'package:lifeplan/entities/companion.dart';
import 'package:lifeplan/entities/event.dart';

class LifeplanDatabase {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static int counter = 0;
  late User? _currentUser;
  User? get currentUser => _currentUser;

  Future<bool> addAccount(String email, String password) async {
    try {
      UserCredential uc = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      //await uc.user!.sendEmailVerification();

      await _db.collection('accounts').doc(uc.user!.uid).set({
        'email': email,
        'username': "User",
        'companion': null,
        'is_notification_on' : false,
        'events': []
      });

      _currentUser = FirebaseAuth.instance.currentUser;
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      UserCredential uc = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _currentUser = uc.user;
      return true;
    } catch (e) {
      print('Error: $e');
      return false;
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

  // Companion CRUD functions
  Future<bool> addCompanion(String name, String gender, List<String> replies, String image) async {
    counter++;
    try {
      await _db.collection('companions').doc(counter.toString()).set({
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
        await _db.collection('companions').doc(companionId.toString()).update({
          'replies' : FieldValue.arrayRemove([reply])
        });
        return true;
      } catch (e) {
        return false;
      }
  }

  Future<List<Companion>> readCompanion(String type) async {
    try {
      QuerySnapshot querySnapshot = await _db
      .collection("companions")
      .where('gender', isEqualTo: type)
      .get();

      List<Companion> companions = querySnapshot.docs.map((doc) {
        return Companion.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      return companions;
    } on FirebaseException catch (e) {
      return [];
    }
  }
}