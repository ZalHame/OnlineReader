import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:online_reader/Auth.dart';
import 'package:online_reader/Reg.dart';

import 'MainPage.dart';
import 'ProfilePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyANuHOr3gN-4lxmTHkCxZ2CsBFvSdPQ3CM',
    appId: '1:308319939881:android:3f89fcd5b3c0aec2321b38',
    messagingSenderId: '308319939881',
    projectId: 'onlinereader-67827',
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/Reg': (context) => RegisterPage(),
        '/Main': (context) => MainPage(),
        '/Profile': (context) => ProfilePage(),
      },
    );
  }
}
