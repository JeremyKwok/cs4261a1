import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

Status statusFromJson(String str) {
  final jsonData = json.decode(str);
  return Status.fromJson(jsonData);
}

String statusToJson(Status data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Status {
  String id;
  String userId;
  int pax;

  Status({
    this.id,
    this.userId,
    this.pax
  });

  factory Status.fromJson(Map<String, dynamic> json) => new Status(
    id: json["id"],
    userId: json["userId"],
    pax: json["pax"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "pax": pax
  };

  factory Status.fromDocument(DocumentSnapshot doc) {
    return Status.fromJson(doc.data);
  }
}