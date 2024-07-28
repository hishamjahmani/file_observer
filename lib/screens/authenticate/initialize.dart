import 'dart:async';

import 'package:file_observer/models/user.dart';
import 'package:file_observer/screens/authenticate/authenticate.dart';
import 'package:file_observer/screens/wrapper.dart';
import 'package:file_observer/services/auth.dart';
import 'package:flutter/material.dart';
// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class Initialize extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization =  Firebase.initializeApp();
  AppUser initUser = AppUser(uid:'x uid', userName: 'x userName', userSection: 'x userSection');
  bool isRealUser = false;


  Initialize({super.key});

  @override
  Widget build(BuildContext context) { 
     
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          //print('\n\n*******************************************\n\n');
          print(snapshot.error.toString());
          return Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: const Text(
                'Error',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.amber,
                ),
              ));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          if(snapshot.hasData)

          {

            return StreamProvider<AppUser?>.value(
              value: AuthService().user, initialData: initUser, child: const Wrapper());
        }
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container(
          color: Colors.amber,
        );
      },
    );
  }
}
