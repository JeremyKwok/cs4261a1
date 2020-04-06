import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

Group groupFromJson(String str) {
  final jsonData = json.decode(str);
  return Group.fromJson(jsonData);
}

String groupToJson(Group data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Group {
  String userId;
  String pax;

  Group({
    this.userId,
    this.pax
  });

  factory Group.fromJson(Map<String, dynamic> json) => new Group(
    userId: json["userId"],
    pax: json["pax"]
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "pax": pax
  };

  factory Group.fromDocument(DocumentSnapshot doc) {
    return Group.fromJson(doc.data);
  }
}