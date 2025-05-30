import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:lifeplan/entities/account.dart';
import 'package:lifeplan/entities/companion.dart';
import 'package:lifeplan/entities/event.dart';

class LifeplanDatabase {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static int counter = 0;

  Future<bool> registerAndSendCode(String email, String password) async {
    try {
      UserCredential uc = await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim()
      );

      await uc.user!.sendEmailVerification();

      return true;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<bool> verifyUserAndAdd() async {
    User? user = _auth.currentUser;
    await user?.reload();
    user = _auth.currentUser;

    if (user != null && user.emailVerified) {
      await _db.collection('accounts').doc(user.uid).set({
        'email': user.email,
        'username': "User",
        'companion': null,
        'is_notification_on' : false,
        'events': []
      });
      return true;
    } else {
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      UserCredential uc = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = uc.user;

      await user?.reload();
      user = _auth.currentUser;

      if (user != null && user.emailVerified) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> forgottenPassword(String email) async{
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      return true;
    } on FirebaseAuthException catch (e) {
      return false;
    }
  }

  Future<void> logout(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
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
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.
        instance
            .collection('accounts')
            .doc(user.uid)
            .get();


        if (doc.exists) {
          Account account = Account.fromMap(doc.data() as Map<String, dynamic>);
          return account;
        }
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

    int i = eventsFromUser.indexWhere((map) {
      final Timestamp startTime = map['start_time'];
      final Timestamp endTime = map['end_time'];
      return startTime.toDate().isAtSameMomentAs(oldEvent.startTime) &&
          endTime.toDate().isAtSameMomentAs(oldEvent.endTime) &&
          map['title'] == oldEvent.title &&
          map['location'] == oldEvent.location;
    });

    if (i != -1) {
      eventsFromUser[i] = {
        'start_time': updatedEvent.startTime,
        'end_time': updatedEvent.endTime,
        'title': updatedEvent.title,
        'location': updatedEvent.location,
      };

      try {
        await _db.collection('accounts').doc(user.uid).update({
          'events': eventsFromUser,
        });
        return true;
      } catch (e) {
        print("Update failed: $e");
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