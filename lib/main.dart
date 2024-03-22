import 'package:flutter/material.dart';
import 'package:snake/pages/home_page.dart';
// import "package:firebase_core/firebase_core.dart";

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: const FirebaseOptions(
  //       apiKey: "AIzaSyAnAVQTpX4cCvdz7umuUQ0r9yBCf262q5U",
  //       authDomain: "snake-6f4f7.firebaseapp.com",
  //       projectId: "snake-6f4f7",
  //       storageBucket: "snake-6f4f7.appspot.com",
  //       messagingSenderId: "734275804445",
  //       appId: "1:734275804445:web:252658954ffe451942d5f4",
  //       measurementId: "G-9JE2SSX32R"),
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
