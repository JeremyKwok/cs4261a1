import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

Event eventFromJson(String str) {
  final jsonData = json.decode(str);
  return Event.fromJson(jsonData);
}

String eventToJson(Event data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Event {
  String id;
  String userId;
  // String timing;
  // String activity;
  int pax;
  int attending;

  Event({
    this.id,
    this.userId,
    this.pax,
    this.attending
  });

  factory Event.fromJson(Map<String, dynamic> json) => new Event(
      id: json["id"],
      userId: json["userId"],
      pax: json["pax"],
      attending: json["attending"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "pax": pax,
    "attending": attending
  };

  factory Event.fromDocument(DocumentSnapshot doc) {
    return Event.fromJson(doc.data);
  }
}