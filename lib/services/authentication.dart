import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs4261a1/locator.dart';
import 'package:cs4261a1/models/user.dart';
import 'firestore.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<void> sendPasswordReset(String email);
}

class Auth implements BaseAuth {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = locator<FirestoreService>();

  User _currentUser;
  User get currentUser => _currentUser;

  String parseEmail(String email) {
     if (email.endsWith('@gatech.edu')) {
       return email;
     }
     return email + "@gatech.edu";
  }
  Future<String> signIn(String email, String password) async {
    email = parseEmail(email);
    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password)).user;
    await _populateCurrentUser(user);
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    email = parseEmail(email);
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password)).user;
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<void> sendPasswordReset(String email) async {
    email = parseEmail(email);
    _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future _populateCurrentUser(FirebaseUser user) async {
    if (user != null) {
      // todo
      _currentUser = await _firestoreService.getUser(user.uid);
    }
  }
}