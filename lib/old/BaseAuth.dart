import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
abstract class BaseAuth {
  Future<FirebaseUser> signIn(String email, String password);
  Future<FirebaseUser> signUp(String username, String email, String password);
  Future<void> signOut();
}
class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<FirebaseUser> signUp(String username, String email, String password) async {
    FirebaseUser user = (await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)).user;
    try {
      await user.sendEmailVerification();
      return user;
    } catch (e) {
      print("An error occured while trying to send email        verification");
      print(e.message);
    }
  }
  @override
  Future<FirebaseUser> signIn(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password:password)).user;
    if (user.isEmailVerified) return user;
    return null;
  }
  @override
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}