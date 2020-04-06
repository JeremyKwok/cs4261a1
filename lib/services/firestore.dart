import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../models/group.dart';
import '../models/event.dart';

final Firestore db = Firestore.instance;

class FirestoreService {
  static final FirestoreService _instance = new FirestoreService.internal();
  factory FirestoreService() => _instance;
  FirestoreService.internal();
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

}