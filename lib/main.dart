import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lifeplan/loginpage.dart';
import 'package:lifeplan/createaccount.dart';
import 'accountpage.dart';
import 'companiongender.dart';
import 'femalecompanion.dart';
import 'masculinecompanion.dart';
import 'homepage.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyA4DQnexpU3TzxvWTOFk0dhN1ZW3YyIeJc",
          appId: "749770628450",
          messagingSenderId: "749770628450",
          projectId: "lifeplan-20378")
  );
  runApp(MyPlanner());
}

class MyPlanner extends StatelessWidget {
  const MyPlanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/' : (context) => HomePage(),
        'home' : (context) => HomePage(),
        '/login' : (context) => LoginPage(),
        '/createaccount' : (context) => CreateAccount(),
        '/startjourney' : (context) => AccountPage(),
         '/masc' : (context) => MaleCompanion(),
        '/fem' : (context) => FemaleCompanion(),
        'companiongender' : (context) => CompanionGender()
      },
    );
  }
}
