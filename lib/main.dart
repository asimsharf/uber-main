import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "map_api_key",
        appId: "1:208035247125:android:bf96f8329af9cc8251ca1c",
        messagingSenderId: "Your Sender id found in Firebase",
        projectId: "208035247125",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

DatabaseReference usersRef =
    FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Brand Bold',
        primarySwatch: Colors.yellow,
      ),
      home: const Home(),
    );
  }
}
