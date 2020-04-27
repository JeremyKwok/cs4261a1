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
  int temp;


  Status({
    this.id,
    this.userId,
    this.temp
  });

  factory Status.fromJson(Map<String, dynamic> json) => new Status(
    id: json["id"],
    userId: json["userId"],
    temp: json["temp"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "temp": temp
  };

  factory Status.fromDocument(DocumentSnapshot doc) {
    return Status.fromJson(doc.data);
  }
}