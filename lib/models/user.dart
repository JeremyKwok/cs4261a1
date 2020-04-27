import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

User userFromJson(String str) {
  final jsonData = json.decode(str);
  return User.fromJson(jsonData);
}

String userToJson(User data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class User {
  String userId;
  String name;
  String email;
  int age;
  String dob;
  String race;

  User({
    this.userId,
    this.name,
    this.email,
    this.age,
    this.dob,
    this.race
  });

  factory User.fromJson(Map<String, dynamic> json) => new User(
    userId: json["userId"],
    name: json["name"],
    email: json["email"],
    age: json["age"],
    dob: json["dob"],
    race: json["race"]
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "name": name,
    "email": email,
    "age": age,
    "dob": dob,
    "race": race
  };

  factory User.fromDocument(DocumentSnapshot doc) {
    return User.fromJson(doc.data);
  }
}