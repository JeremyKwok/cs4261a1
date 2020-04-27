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
  final CollectionReference _statusCR = db.collection('status');

  Future createUser(User user) async {
    await _userCR.document(user.userId).setData(user.toJson()).catchError((error) {
      print('error: $error');
      return null;
    });
  }

  Future getUser(String uid) async {
    var userData = await _userCR.document(uid).get().catchError((error) {
      print('error: $error');
      return null;
    });
    return User.fromJson(userData.data);
  }

  Future<Event> createEvent(String activity, String timing, String uid, int pax) async {
    DocumentReference dr = db.collection(timing).document(activity);
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(dr.collection(uid).document('fields'));
      final Event event = new Event(id: ds.documentID, userId: uid, pax: 6, attending: 0);
      final Map<String, dynamic> data = event.toJson();
      await tx.set(ds.reference, data);
      return data;
    };
    await createGroup(timing, activity, uid, uid, pax);
    return Firestore.instance.runTransaction(createTransaction).then((mapData){
      return Event.fromJson(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }
  Future<Group> createGroup(String timing, String activity, String uid, String id, int pax) async {
    DocumentReference dr = db.collection(timing).document(activity);
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(dr.collection(uid).document());
      final Group group = new Group(id: ds.documentID, userId: id, pax: pax);
      final Map<String, dynamic> data = group.toJson();
      await tx.set(ds.reference, data);
      return data;
    };
    return db.runTransaction(createTransaction).then((mapData){
      return Group.fromJson(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }
  Future<dynamic> updateEvent(String timing, String activity, String uid, Event event, int pax) async {
    DocumentReference dr = db.collection(timing).document(activity).collection(uid).document('fields');
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(dr);

      await tx.update(ds.reference, event.toJson());
      return {'updated': true};
    };

    return db
        .runTransaction(updateTransaction)
        .then((result) => result['updated'])
        .catchError((error) {
      print('error: $error');
      return false;
    });
  }
  Future<Status> createStatus(  String id, String uid, int temp, bool tiredness, bool bodyache, bool nasalCongestion, bool soreThroat, bool diarrhoea) async {
    DocumentReference dr = db.collection("symptoms").document(uid);
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(dr.collection(uid).document('fields'));
      final Status status = new Status(id: ds.documentID, userId: uid, temp: temp, tiredness: tiredness, bodyache: bodyache, nasalCongestion: nasalCongestion, soreThroat: soreThroat, diarrhoea: diarrhoea);
      final Map<String, dynamic> data = status.toJson();
      await tx.set(ds.reference, data);
      return data;
    };
    return Firestore.instance.runTransaction(createTransaction).then((mapData){
      return Status.fromJson(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }
  Future<dynamic> updateStatus(  String id, String uid, int temp, bool tiredness, bool bodyache, bool nasalCongestion, bool soreThroat, bool diarrhoea, Status status) async {
    DocumentReference dr = db.collection("symptoms").document(uid);
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(dr);

      await tx.update(ds.reference, status.toJson());
      return {'updated': true};
    };

    return db
        .runTransaction(updateTransaction)
        .then((result) => result['updated'])
        .catchError((error) {
      print('error: $error');
      return false;
    });
  }


}