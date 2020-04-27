import 'package:cs4261a1/locator.dart';
import 'package:cs4261a1/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class BaseModel extends ChangeNotifier {
  final Auth _auth =
  locator<Auth>();

  FirebaseUser get currentUser => _auth.currentUser;

  bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }
}