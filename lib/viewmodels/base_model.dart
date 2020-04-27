import 'package:cs4261a1/locator.dart';
import 'package:cs4261a1/models/user.dart';
import 'package:cs4261a1/services/authentication.dart';
import 'package:flutter/widgets.dart';

class BaseModel extends ChangeNotifier {
  final Auth _auth =
  locator<Auth>();

  User get currentUser => _auth.currentUser;

  bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }
}