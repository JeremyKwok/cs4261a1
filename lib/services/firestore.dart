import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs4261a1/models/user.dart';
import 'package:cs4261a1/models/group.dart';
import 'package:cs4261a1/models/status.dart';
import 'package:cs4261a1/models/event.dart';

final Firestore db = Firestore.instance;

class FirestoreService {

  static final FirestoreService _instance = new FirestoreService.internal();
  factory FirestoreService() => _instance;
  FirestoreService.internal();

  final CollectionReference _userCR = db.collection('users');

  Future createUser(User user) async {
    await _userCR.document(user.userId).setData(user.toJson()).catchError((error) {
      print('error: $error');
      return 'error: $error';
    });
  }

  Future<User> getUser(String uid) async {
    var userData = await _userCR.document(uid).get().catchError((error) {
      print('error: $error');
      return 'error: $error';
    });
    return User.fromJson(userData.data);
  }

  Future createStatus(Status status) async {
    CollectionReference cr = _userCR.document(status.userId).collection('status');
    DocumentReference dr = cr.document(status.date);
    await dr.setData(status.toJson()).catchError((error) {
      print('error: $error');
      return 'error: $error';
    });
  }
  Future<dynamic> updateStatus(Status status) async {
    CollectionReference cr = _userCR.document(status.userId).collection('status');
    DocumentReference dr = cr.document(status.date);
    await dr.updateData(status.toJson()).catchError((error) {
      print('error: $error');
      return 'error: $error';
    });
  }
}