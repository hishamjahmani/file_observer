import 'package:file_observer/models/user.dart';
import 'package:file_observer/shared/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_observer/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String error = "Great";

  //create user obj based on FirebaseUser
  AppUser _userFromFirebaseUser(User? user) {
    return user != null ? AppUser(uid: user.uid) : AppUser(uid: 'x uid');
    // if(user != null){
    //   for(int i = 0; i< users.length; i++){
    //     if (users[i].uid == user.uid){
    //       return AppUser(uid: user.uid, userName: users[i].userName, userSection: users[i].userSection);
    //     }
    //   }
    // } else{
    //   return null;
    // }
  }

  // auth change user stream
  Stream<AppUser> get appUser {
    return _auth
        .authStateChanges()
        //.map((User user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser); // the same as above.
  }

  // sign in anon
  // Future signInAnon() async {
  //   try {
  //     var result = await _auth.signInAnonymously();
  //     var user = result.user;
  //     return _userFromFirebaseUser(user);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      var user = result.user;
      if (user!.uid != 'x uid') return _userFromFirebaseUser(user);
    } catch (e) {
      toast('Invalid Sign in');
    }
  }

  //register with email & password
  Future registerWithEmailAndPassword(String email, String password,
      String userName, String userSection) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      var user = result.user;
      await DatabaseService(uid: user!.uid)
          .updateUsersList(user.uid, email, userName, userSection);
      if (user.uid != 'No user') return _userFromFirebaseUser(user);
    } catch (e) {
      toast('Invalid registration');
    }
  }

  //sign out

  Future signOut() async {
    var result = _auth.currentUser;
    //print(result!.uid);

    try {
      if (result!.uid != 'x uid') return await _auth.signOut();
      
      //print(result!.uid);
    } catch (e) {
      //print(' this is the error for signingout ${e.toString()}');
      //return null;
    }
  }
}
