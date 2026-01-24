import 'dart:async';

import 'package:file_observer/models/user.dart';
import 'package:file_observer/screens/loading_screen.dart';
import 'package:file_observer/screens/wrapper.dart';
import 'package:file_observer/services/auth.dart';
import 'package:flutter/material.dart';
// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class Initialize extends StatefulWidget {
  const Initialize({super.key});

  @override
  State<Initialize> createState() => _InitializeState();
}

class _InitializeState extends State<Initialize> {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: const FirebaseOptions(
    apiKey: "AIzaSyCA2Vqjvxcj9YT9IcXTh81LzPuRIHslnZM",
    appId: "1:38258509079:web:136b6ab6be68847a1d6352",
    messagingSenderId: "38258509079",
    projectId: "flutterscanner-830ad",
  )
  );

  AppUser initUser = AppUser(
      uid: 'x uid', userName: 'x userName', userSection: 'x userSection');


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          //print('\n\n*******************************************\n\n');
          //print(snapshot.error.toString());
          return Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Text(
                  'Error:   ${snapshot.error.toString()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.amber,
                  ),
                ),
              ));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return StreamProvider<AppUser>.value(
                value: AuthService().appUser,
                initialData: initUser,
                child: const Wrapper());
          }
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const LoadingScreen();
      },
    );
  }
}
