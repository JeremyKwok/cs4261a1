import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs4261a1/models/status.dart';

final Firestore db = Firestore.instance;

class FirestoreService {

  static final FirestoreService _instance = new FirestoreService.internal();
  factory FirestoreService() => _instance;
  FirestoreService.internal();

  final CollectionReference _userCR = db.collection('users');

  final StreamController<List<Status>> _statusController =
  StreamController<List<Status>>.broadcast();

  Future createStatus(Status status) async {
    CollectionReference cr = _userCR.document(status.userId).collection('status');
    DocumentReference dr = cr.document(status.date.toString());
    await dr.setData(status.toJson()).catchError((error) {
      print('error: $error');
      return 'error: $error';
    });
  }
  Future updateStatus(Status status) async {
    CollectionReference cr = _userCR.document(status.userId).collection('status');
    DocumentReference dr = cr.document(status.date.toString());
    await dr.updateData(status.toJson()).catchError((error) {
      print('error: $error');
      return 'error: $error';
    });
  }

  Future getStatusOnceOff(String userId) async {
    try {
      CollectionReference cr = _userCR.document(userId).collection('status');
      var postDocumentSnapshot = await cr.getDocuments();
      if (postDocumentSnapshot.documents.isNotEmpty) {
        return postDocumentSnapshot.documents
            .map((snapshot) => Status.fromJson(snapshot.data))
            .where((mappedItem) => mappedItem.date != null)
            .toList();
      }
    } catch (error) {
      print('error: $error');
      return 'error: $error';
    }
  }

  Stream listenToStatusRealTime(String userId) {
    CollectionReference cr = _userCR.document(userId).collection('status');

    // Register the handler for when the posts data changes
    cr.snapshots().listen((statusSnapshot) {
      if (statusSnapshot.documents.isNotEmpty) {
        var posts = statusSnapshot.documents
            .map((snapshot) => Status.fromJson(snapshot.data))
            .where((mappedItem) => mappedItem.date != null)
            .toList();

        // Add the posts onto the controller
        _statusController.add(posts);
      }
    });
    return _statusController.stream;
  }

  Future deleteStatus(Status status) async {
    CollectionReference cr = _userCR.document(status.userId).collection('status');
    DocumentReference dr = cr.document(status.date.toString());
    await dr.delete();
  }

}