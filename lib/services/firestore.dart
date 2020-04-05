import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

final Firestore db = Firestore.instance;

class FirestoreService {
  static final FirestoreService _instance = new FirestoreService.internal();
  factory FirestoreService() => _instance;
  FirestoreService.internal();
  Future<Event> createEvent(String activity, String timing, String uid, int pax) async {
    DocumentReference dr = db.collection(timing).document(activity);
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(dr.collection(uid).document('fields'));
      final Event event = new Event(ds.documentID, 6, 0);
      final Map<String, dynamic> data = event.toMap();
      await tx.set(ds.reference, data);
      return data;
    };
    await createGroup(timing, activity, uid, uid, pax);
    return Firestore.instance.runTransaction(createTransaction).then((mapData){
      return event.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }
  Future<Group> createGroup(String timing, String activity, String uid, String id, int pax) async {
    DocumentReference dr = db.collection(timing).document(activity);
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(dr.collection(uid).document());
      final Group group = new Group(ds.documentID, id, pax);
      final Map<String, dynamic> data = group.toMap();
      await tx.set(ds.reference, data);
      return data;
    };
    return db.runTransaction(createTransaction).then((mapData){
      return group.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }
  Future<dynamic> updateEvent(String timing, String activity, String uid, Event event, int pax) async {
    DocumentReference dr = db.collection(timing).document(activity).collection(uid).document('fields');
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(dr);

      await tx.update(ds.reference, event.toMap());
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